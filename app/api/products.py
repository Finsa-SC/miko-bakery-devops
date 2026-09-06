from fastapi import APIRouter
from app.db.helper import execute_query, execute_non_query

router = APIRouter()

@router.get("/products")
def get_products():
    query = """
    SELECT * FROM products;
    """
    return execute_query(query)

@router.post("/products")
def add_product(
        product_name: str,
        price: int,
        stock: int,
        description: str|None = None,
        is_active: bool = True,
):
    query = """
    INSERT INTO products (name, description, price, stock, is_active) 
    VALUES (%s, %s, %s, %s, %s)
    """
    return execute_non_query(query, (product_name, description, price, stock, is_active))