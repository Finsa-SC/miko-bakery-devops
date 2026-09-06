from fastapi import APIRouter

from app.application import create_product, modify_product

router = APIRouter()

@router.post("/products")
def add_product(
        product_name: str,
        price: int,
        stock: int,
        description: str|None = None,
        is_active: bool|None = None,
):
    result = create_product(
            product_name,
            price,
            stock,
            description,
            is_active
        )
    return

def update_product():
    result = modify_product()