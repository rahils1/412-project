import os

import psycopg
from dotenv import load_dotenv

load_dotenv()

DB_CONN = os.getenv("DB_CONN")


def get_conn():
    if not DB_CONN:
        raise RuntimeError("DB_CONN is not set in .env")
    return psycopg.connect(DB_CONN)
