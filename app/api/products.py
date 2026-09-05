from fastapi import APIRouter

router = APIRouter()

@router.get("/products")
def get_products():
    return [
        {"id": 1, "name": "Roti Coklat", "price": 8000},
        {"id": 2, "name": "Roti Keju", "price": 9000},
        {"id": 3, "name": "Croissant", "price": 12000},
    ]