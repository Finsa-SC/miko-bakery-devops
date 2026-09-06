-- =========================================
-- Categories
-- =========================================

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- =========================================
-- Products
-- =========================================

CREATE TABLE products (
    id SERIAL PRIMARY KEY,

    category_id INTEGER NOT NULL
        REFERENCES categories(id)
        ON DELETE RESTRICT,

    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,

    price INTEGER NOT NULL
        CHECK (price >= 0),

    stock INTEGER NOT NULL DEFAULT 0
        CHECK (stock >= 0),

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- =========================================
-- Orders
-- =========================================

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,

    status VARCHAR(20) NOT NULL DEFAULT 'PENDING'
        CHECK (
            status IN (
                'PENDING',
                'CONFIRMED',
                'PROCESSING',
                'SHIPPED',
                'COMPLETED',
                'CANCELLED'
            )
        ),

    total_amount INTEGER NOT NULL DEFAULT 0
        CHECK (total_amount >= 0),

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- =========================================
-- Order Items
-- =========================================

CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,

    order_id INTEGER NOT NULL
        REFERENCES orders(id)
        ON DELETE CASCADE,

    product_id INTEGER NOT NULL
        REFERENCES products(id)
        ON DELETE RESTRICT,

    product_name VARCHAR(100) NOT NULL,

    unit_price INTEGER NOT NULL
        CHECK (unit_price >= 0),

    quantity INTEGER NOT NULL
        CHECK (quantity > 0),

    subtotal INTEGER NOT NULL
        CHECK (subtotal >= 0)
);


-- =========================================
-- Seed Categories
-- =========================================

INSERT INTO categories (name, description)
VALUES
    ('Roti', 'Berbagai macam roti'),
    ('Pastry', 'Pastry dan makanan panggang'),
    ('Sandwich', 'Sandwich dan makanan ringan'),
    ('Minuman', 'Minuman panas dan dingin');


-- =========================================
-- Seed Products
-- =========================================

INSERT INTO products
    (category_id, name, description, price, stock)
VALUES
    (1, 'Roti Coklat', 'Roti lembut dengan isian coklat', 8000, 20),
    (1, 'Roti Keju', 'Roti dengan isian dan topping keju', 9000, 15),
    (2, 'Croissant', 'Croissant buttery dan renyah', 12000, 10),
    (2, 'Cinnamon Roll', 'Roti cinnamon dengan glaze manis', 11000, 12),
    (2, 'Roti Sosis', 'Roti lembut dengan isian sosis', 10000, 10),
    (3, 'Sandwich Telur', 'Sandwich dengan telur dan sayuran', 15000, 8),
    (4, 'Kopi Susu', 'Kopi susu dengan rasa creamy', 12000, 20),
    (4, 'Teh Manis', 'Teh manis dingin', 6000, 25),
    (4, 'Teh Lemon', 'Teh dengan perasan lemon', 8000, 15),
    (4, 'Susu Coklat', 'Susu coklat dingin', 10000, 15),
    (4, 'Jus Jeruk', 'Jus jeruk segar', 10000, 12);