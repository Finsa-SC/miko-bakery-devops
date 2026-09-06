from fastapi import APIRouter
from app.db.helper import execute_query

router = APIRouter()

@router.get("/products")
def get_products():
    query = """
    SELECT * FROM products;
    """
    return execute_query(query)