from contextlib import contextmanager

from .pool import pool

def execute(conn, query: str, params: tuple|None, operation):
    with conn.cursor() as cur:
        cur.execute(query, params)
        return operation(cur, conn)

@contextmanager
def execute_transaction():
    with pool.connection() as conn:
        try:
            yield conn
        except Exception:
            conn.rollback()
            raise
        else:
            conn.commit()

def execute_query(conn, query: str, params: tuple|None = None):
    return execute(
        conn,
        query,
        params,
        lambda cur, con: cur.fetchall()
    )

def execute_non_query(conn, query: str, params: tuple|None=None):
    return execute(
        conn,
        query,
        params,
        lambda cur, con: cur.rowcount
    )