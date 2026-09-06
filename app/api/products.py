from fastapi import APIRouter

from app.db import transaction

router = APIRouter()

@router.get("/products")
def get_products():
    query = """
    SELECT * FROM products;
    """
    with transaction() as db:
        return db.execute_query(query)

@router.post("/products")
def add_product(
        product_name: str,
        price: int,
        stock: int,
        description: str|None = None,
        is_active: bool|None = None,
):
    if not is_active or stock <= 0:
        is_active = True if stock > 0 else False

    query = """
    INSERT INTO products (name, description, price, stock, is_active) 
    VALUES (%s, %s, %s, %s, %s)
    """
    with transaction() as db:
        db.execute_non_query(query,(product_name, description, price, stock, is_active))