from fastapi import APIRouter

from app.application import create_product, select_products

router = APIRouter()

@router.get("/products")
def get_products(search: str|None=None, price_below: int|None=None):
    return select_products(
        search,
        price_below=price_below
    )