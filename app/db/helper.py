from contextlib import contextmanager
from .database import Database
from .pool import pool

@contextmanager
def transaction():
    with pool.connection() as conn:
        db = Database(conn)

        try:
            yield db
        except Exception:
            conn.rollback()
            raise
        else:
            conn.commit()