from dotenv import load_dotenv
from psycopg.rows import dict_row
from psycopg_pool import ConnectionPool
import os

load_dotenv()
DB_HOST = os.getenv("POSTGRES_HOST", "localhost")
DB_PORT = os.getenv("POSTGRES_PORT", "5432")
DB_NAME = os.getenv("POSTGRES_DB")
DB_USER = os.getenv("POSTGRES_USER")
DB_PASS = os.getenv("POSTGRES_PASSWORD")

conninfo = (
    f"host={DB_HOST} "
    f"port={DB_PORT} "
    f"dbname={DB_NAME} "
    f"user={DB_USER} "
    f"password={DB_PASS}"
)

pool = ConnectionPool(
    conninfo=conninfo,
    min_size=1,
    max_size=10,
    kwargs={
        "connect_timeout": 5,
        "row_factory": dict_row
    }
)