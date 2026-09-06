from fastapi import APIRouter

from app.application import create_product, modify_product, remove_product

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
    return result

@router.patch("/products")
def update_product(
        product_id: int,
        new_name: str|None = None,
        new_description: str|None = None,
        new_stock: int|None = None,
        new_price: int|None = None,
):
    result = modify_product(
        product_id,
        new_name,
        new_price,
        new_stock,
        new_description,
    )
    return result

@router.delete("/products")
def delete_product(product_id: int):
    result = remove_product(
        product_id
    )
    return result