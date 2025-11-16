from flask import Flask
from flask_cors import CORS
from psycopg import sql

from db import get_conn

app = Flask(__name__)

CORS(app)

TABLES = {
    "household": "householdId, ownerId, householdName",
    "users": "userId, userName, householdId, isAdmin",
    "lists": "listId, householdId, listName, comment, isStockList, admin",
    "entry": "entryId, listId, groceryId, quantity",
    "groceryitem": "groceryId, groceryName, categoryId",
    "category": "categoryId, categoryName, categoryDescription",
}


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
