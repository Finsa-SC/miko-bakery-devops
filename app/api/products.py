from fastapi import APIRouter

from app.application import collect_product_catalog

router = APIRouter()

@router.get("/products")
def get_product_catalog(search: str|None=None, price_below: int|None=None):
    return collect_product_catalog(
        search,
        price_below=price_below
    )