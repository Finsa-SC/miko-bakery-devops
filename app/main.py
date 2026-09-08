from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api import products, admin_products

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def health_check():
    return {"status": "ok"}

app.include_router(products.router, prefix="/api")
app.include_router(admin_products.router, prefix="/api/admin")