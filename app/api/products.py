from fastapi import APIRouter

from app.db import transaction
from app.db.helper import execute_query, execute_non_query

router = APIRouter()

@router.get("/products")
def get_products():
    query = """
    SELECT * FROM products;
    """
    with transaction() as conn:
        execute_query(conn, query)

@router.post("/products")
def add_product(
        product_name: str,
        price: int,
        stock: int,
        description: str|None = None,
        is_active: bool|None = None,
):
    if not is_active:
        is_active = True if stock > 0 else False

    query = """
    INSERT INTO products (name, description, price, stock, is_active) 
    VALUES (%s, %s, %s, %s, %s)
    """
    with transaction() as conn:
        execute_non_query(conn, query,(product_name, description, price, stock, is_active))