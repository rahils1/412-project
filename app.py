import secrets
from typing import Dict

from flask import Flask, jsonify, render_template, request, session

# from flask_cors import CORS
from psycopg import Connection, Cursor, sql
from psycopg.rows import TupleRow

from db import get_conn
from User import User

app: Flask = Flask(__name__)
app.secret_key = secrets.token_hex(32)

# CORS(app, supports_credentials=True, origins=["null"])

currUser: User | None = None

TABLES: Dict = {
    "household": "householdId, ownerId, householdName",
    "users": "userId, userName, householdId, isAdmin",
    "lists": "listId, householdId, listName, comment, isStockList, admin",
    "entry": "entryId, listId, groceryId, quantity",
    "groceryitem": "groceryId, groceryName, categoryId",
    "category": "categoryId, categoryName, categoryDescription",
}


@app.post("/login")
def login():
    req = request.get_json()
    uname: str = req.get("username")
    password: str = req.get("password")
    conn: Connection[TupleRow] = get_conn()
    cur: Cursor[TupleRow] = conn.cursor()
    query: str = "SELECT * from Users WHERE u_username = %s and u_password = %s"
    cur.execute(query, (uname, password))
    user_info: TupleRow | None = cur.fetchone()
    if user_info:
        userid: int = user_info[0]
        username: str = user_info[1]
        householdid: int = user_info[2]
        isadmin: bool = user_info[3]
        currUser = User(
            uid=userid, username=username, householdid=householdid, isadmin=isadmin
        )
        session["user"] = currUser.get_dict()
        return jsonify({"success": "Logged In", "user": currUser.get_dict()}), 200
    return jsonify({"error": "Incorrect Log In Info"}), 400


@app.get("/currUser")
def get_curruser():
    if "user" in session:
        return jsonify({"user": session["user"]}), 200
    return jsonify({"error": "No active user session"}), 400


@app.get("/table/<table_name>")
def get_table(table_name):
    if table_name not in TABLES:
        return {"error": "Table not found"}, 404

    columns = TABLES[table_name]
    query = sql.SQL("SELECT {} FROM {}").format(
        sql.SQL("*"),
        sql.Identifier(table_name),
    )

    conn = get_conn()
    cur = conn.cursor()
    cur.execute(query)
    rows = cur.fetchall()
    cur.close()
    conn.close()

    result = [dict(zip(columns.replace(" ", "").split(","), row)) for row in rows]
    return result


@app.get("/")
def login_page():
    return render_template("login.html")


@app.get("/dashboard")
def dashboard_page():
    return render_template("dashboard.html")


@app.get("/logout")
def logout():
    session.clear()
    return jsonify({"Success": "Successfully Logged Out"}), 200


if __name__ == "__main__":
    app.run(debug=True, port=5000)
