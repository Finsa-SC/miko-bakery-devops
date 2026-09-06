from app.db import transaction

def create_product(
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
        return db.execute_non_query(query,(product_name, description, price, stock, is_active))

def select_products(
        search: str|None = None,
        price_below: int|None = None,
):
    conditions = []
    params = []

    query = """
        SELECT * FROM products
        """

    if search:
        conditions.append("name ILIKE %s")
        params.append(f"%{search}%")

    if price_below:
        conditions.append("price <= %s")
        params.append(price_below)

    if conditions:
        query += " WHERE " + " AND ".join(conditions)

    with transaction() as db:
        return db.execute_query(
            query,
            params=params
        )

def modify_product(
        product_id: int,
        new_name: str|None=None,
        new_price: int|None=None,
        new_stock: int|None=None,
        new_description: str | None=None,
):
    query = """
    UPDATE products 
    SET
        name = COALESCE(%s, name),
        price = COALESCE(%s, price),
        stock = COALESCE(%s, stock),
        description = COALESCE(%s, description)
    WHERE id = %s
    """
    with transaction() as db:
        return db.execute_non_query(
            query,
            params=(
                new_name,
                new_price,
                new_stock,
                new_description,
                product_id,
            )
        )

def remove_product(product_id: int):
    query = """
    DELETE FROM products
    WHERE id = %s
    """
    with transaction() as db:
        return db.execute_non_query(
            query,
            params=(product_id,)
        )