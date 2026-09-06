from .pool import pool

def execute(query: str, params: tuple|None, operation):
    with pool.connection() as conn:
        with conn.cursor() as cur:
            cur.execute(query, params)
            return operation(cur, conn)

def execute_query(query: str, params: tuple|None = None):
    return execute(
        query,
        params,
        lambda cur, conn: cur.fetchall()
    )

def execute_non_query(query: str, params: tuple|None=None):
    return execute(
        query,
        params,
        lambda cur, conn: cur.fetchone()
    )