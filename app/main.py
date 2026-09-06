from fastapi import FastAPI
from app.api import products, admin_products

app = FastAPI()

@app.get("/api/health")
def health_check():
    return {"status": "ok"}

app.include_router(products.router, prefix="/api")
app.include_router(admin_products.router, prefix="/api/admin")