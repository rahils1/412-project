from typing import List

from flask import Flask, jsonify, request
from flask_cors import CORS
from psycopg import sql

from db import get_conn
from User import *

app = Flask(__name__)

CORS(app)

currUser = None

TABLES = {
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
    conn = get_conn()
    cur = conn.cursor()
    query: str = "SELECT * from Users WHERE u_username = %s and u_password = %s"
    cur.execute(query, (uname, password))
    user_info: List = cur.fetchall()
    if user_info:
        userid: int = user_info[0][0]
        username: str = user_info[0][1]
        householdid: int = user_info[0][2]
        isadmin: bool = user_info[0][3]
        print(userid)
        print(username)
        print(householdid)
        print(isadmin)
    else:
        return jsonify({"error": "Incorrect Log In Info"}), 400
    return jsonify({})


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


if __name__ == "__main__":
    app.run(debug=True, port=5000)
