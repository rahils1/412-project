from flask import Flask, jsonify, render_template, request, session
from flask_cors import CORS
from psycopg import Connection, Cursor
from psycopg.rows import TupleRow

from db import get_conn
from User import User

app: Flask = Flask(__name__)
app.secret_key = "key"

CORS(app, supports_credentials=True)


@app.post("/login")
def login():
    req = request.get_json()
    uname: str = req.get("username")
    password: str = req.get("password")
    conn: Connection[TupleRow] = get_conn()
    cur: Cursor[TupleRow] = conn.cursor()
    query: str = "SELECT * from users WHERE u_username = %s and u_password = %s"
    cur.execute(query, (uname, password))
    user_info: TupleRow | None = cur.fetchone()
    if user_info:
        userid: int = user_info[0]
        username: str = user_info[1]
        householdid: int = user_info[2]
        isadmin: bool = user_info[3]
        session["user"] = User(
            uid=userid, username=username, householdid=householdid, isadmin=isadmin
        ).get_dict()
        return jsonify({"success": "Logged In", "user": session["user"]}), 200
    return jsonify({"error": "Incorrect Log In Info"}), 400


@app.get("/currUser")
def get_curruser():
    if "user" in session:
        return jsonify({"user": session["user"]}), 200
    return jsonify({"error": "No active user session"}), 400


@app.get("/")
def login_page():
    if "user" in session:
        return render_template("dashboard.html")
    return render_template("login.html")


@app.get("/dashboard")
def dashboard_page():
    return render_template("dashboard.html")


@app.get("/newlist")
def newlist_page():
    return render_template("newlist.html")


@app.get("/listview")
def listview_page():
    return render_template("listview.html")


@app.get("/logout")
def logout():
    session.clear()
    return jsonify({"Success": "Successfully Logged Out"}), 200


@app.get("/getListEntries/<int:list_id>")
def get_list_entries(list_id):
    try:
        conn: Connection[TupleRow] = get_conn()
        cur: Cursor[TupleRow] = conn.cursor()
        cur.execute("SELECT l_listname FROM lists WHERE l_listid = %s", (list_id,))
        list_info: TupleRow | None = cur.fetchone()
        if not list_info:
            return jsonify({"error": "List not found"}), 404
        list_name = list_info[0]
        query: str = """
        SELECT e.e_entryid, g.g_groceryname, c.c_categoryname, e.e_quantity
        FROM entry e
        JOIN groceryitem g
        ON e.e_groceryid = g.g_groceryid
        LEFT JOIN category c
        ON c.c_categoryid = ANY(g.g_categoryid)
        WHERE e.e_listid = %s
        """
        cur.execute(query, (list_id,))
        entries: list[TupleRow] = cur.fetchall()
        cur.close()
        conn.close()
        result = {
            "listName": list_name,
            "entries": [
                {
                    "entryId": entry[0],
                    "groceryName": entry[1],
                    "category": entry[2] if entry[2] else "Uncategorized",
                    "quantity": entry[3],
                }
                for entry in entries
            ],
        }
        return jsonify(result), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.delete("/deleteEntry/<int:entry_id>")
def delete_entry(entry_id):
    try:
        conn: Connection[TupleRow] = get_conn()
        cur: Cursor[TupleRow] = conn.cursor()
        cur.execute("DELETE FROM entry WHERE e_entryid = %s", (entry_id,))
        conn.commit()
        cur.close()
        conn.close()
        return jsonify({"success": "Entry deleted"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.get("/getCategories")
def get_categories():
    try:
        conn: Connection[TupleRow] = get_conn()
        cur: Cursor[TupleRow] = conn.cursor()
        query: str = "SELECT c_categoryid, c_categoryname FROM category"
        cur.execute(query)
        categories = cur.fetchall()
        cur.close()
        conn.close()

        result = [
            {"c_categoryid": cat[0], "c_categoryname": cat[1]} for cat in categories
        ]
        return jsonify(result), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.post("/addEntry")
def add_entry():
    # If you get "duplicate key value violates unique constraint 'groceryitem_pkey'" error
    # run SELECT setval('groceryitem_g_groceryid_seq', (SELECT MAX(g_groceryid) FROM groceryitem) + 1);
    current_user = session.get("user")
    if not current_user:
        return jsonify({"error": "User not logged in"}), 401

    req = request.get_json()
    list_id: int = req.get("listId")
    grocery_name: str = req.get("groceryName")
    quantity: int = req.get("quantity")
    category_id: int = req.get("categoryId")

    if list_id is None or not grocery_name or quantity is None:
        return jsonify({"error": "Missing required fields"}), 400

    try:
        conn: Connection[TupleRow] = get_conn()
        cur: Cursor[TupleRow] = conn.cursor()

        query_check: str = (
            "SELECT g_groceryid FROM groceryitem WHERE LOWER(g_groceryname) = LOWER(%s)"
        )
        cur.execute(query_check, (grocery_name,))
        grocery_result = cur.fetchone()

        if grocery_result:
            grocery_id = grocery_result[0]
            if category_id:
                query_check_category: str = (
                    "SELECT g_categoryid FROM groceryitem WHERE g_groceryid = %s"
                )
                cur.execute(query_check_category, (grocery_id,))
                category_result = cur.fetchone()

                if category_result and category_result[0]:
                    query_update_category = """
                        UPDATE groceryitem
                        SET g_categoryid = array_append(g_categoryid, %s)
                        WHERE g_groceryid = %s AND NOT %s = ANY(g_categoryid)
                        RETURNING g_groceryid
                    """
                    cur.execute(
                        query_update_category, (category_id, grocery_id, category_id)
                    )
                else:
                    query_update_category: str = """
                        UPDATE groceryitem
                        SET g_categoryid = ARRAY[%s]
                        WHERE g_groceryid = %s
                    """
                    cur.execute(query_update_category, (category_id, grocery_id))
        else:
            try:
                if category_id:
                    query_insert_grocery = """
                        INSERT INTO groceryitem (g_groceryname, g_categoryid)
                        VALUES (%s, ARRAY[%s])
                        RETURNING g_groceryid
                    """
                    cur.execute(query_insert_grocery, (grocery_name, category_id))
                else:
                    query_insert_grocery: str = """
                        INSERT INTO groceryitem (g_groceryname, g_categoryid)
                        VALUES (%s, ARRAY[]::int[])
                        RETURNING g_groceryid
                    """
                    cur.execute(query_insert_grocery, (grocery_name,))

                grocery = cur.fetchone()
                grocery_id = None
                if grocery:
                    grocery_id = grocery[0]
            except Exception as _:
                cur.execute(
                    "SELECT g_groceryid FROM groceryitem WHERE LOWER(g_groceryname) = LOWER(%s)",
                    (grocery_name,),
                )
                result = cur.fetchone()
                if result:
                    grocery_id = result[0]
                else:
                    raise

        query_check_entry: str = """
            SELECT e_entryid FROM entry
            WHERE e_listid = %s AND e_groceryid = %s
        """
        cur.execute(query_check_entry, (list_id, grocery_id))
        entry_exists = cur.fetchone()

        if entry_exists:
            return jsonify({"error": "This item already exists in this list"}), 400

        query_insert_entry: str = """
            INSERT INTO entry (e_listid, e_groceryid, e_quantity)
            VALUES (%s, %s, %s)
            RETURNING e_entryid
        """
        cur.execute(query_insert_entry, (list_id, grocery_id, quantity))
        entry = cur.fetchone()
        entry_id = None
        if entry:
            entry_id = entry[0]

        conn.commit()
        cur.close()
        conn.close()

        return jsonify({"success": "Entry added", "entryId": entry_id}), 200

    except Exception as e:
        print(f"Error in add_entry: {str(e)}")
        return jsonify({"error": str(e)}), 500


@app.get("/listTable_load_data")
def listTable_load_data():
    conn: Connection[TupleRow] = get_conn()
    cur: Cursor[TupleRow] = conn.cursor()

    current_user = session.get("user")
    query: str = (
        "SELECT l_listid, l_listname, l_isstocklist FROM lists WHERE l_householdid = %s"
    )
    cur.execute(query, (current_user["householdid"] if current_user else "",))

    lists_in_household: list[TupleRow] = cur.fetchall()

    res = []
    for list_info in lists_in_household:
        res.append(
            {
                "listid": list_info[0],
                "listname": list_info[1],
                "isstocklist": list_info[2],
            }
        )
    return jsonify(res)


@app.get("/userTable_load_data")
def userTable_load_data():
    conn: Connection[TupleRow] = get_conn()
    cur: Cursor[TupleRow] = conn.cursor()

    current_user = session.get("user")
    query: str = "SELECT u_username FROM users WHERE u_householdid = %s"
    cur.execute(query, (current_user["householdid"] if current_user else "",))

    users_in_household: list[TupleRow] = cur.fetchall()

    res = []
    for user in users_in_household:
        res.append({"username": user[0]})

    return jsonify(res)


@app.post("/createList")
def create_list():
    current_user = session.get("user")
    if not current_user:
        return jsonify({"error": "User not logged in"}), 401

    req = request.get_json()
    list_name: str = req.get("listName")
    comment: str = req.get("comment")
    is_stock_list: bool = req.get("isStockList")

    if not list_name:
        return jsonify({"error": "List name is required"}), 400

    try:
        conn: Connection[TupleRow] = get_conn()
        cur: Cursor[TupleRow] = conn.cursor()
        query: str = """
            INSERT INTO lists (l_householdid, l_listname, l_comment, l_isstocklist, l_admin)
            VALUES (%s, %s, %s, %s, %s)
            RETURNING l_listid
        """
        cur.execute(
            query,
            (
                current_user["householdid"],
                list_name,
                comment,
                is_stock_list,
                current_user["uid"],
            ),
        )
        new_list = cur.fetchone()
        new_list_id = None
        if new_list:
            new_list_id = new_list[0]
        conn.commit()
        cur.close()
        conn.close()
        return jsonify({"success": "List created", "listId": new_list_id}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    app.run(debug=True, port=5000)
