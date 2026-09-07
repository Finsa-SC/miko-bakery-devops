-- ============================================================
-- Miko Bakery Database Schema
-- ============================================================

-- ============================================================
-- ROLES
-- ============================================================

CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);


-- ============================================================
-- USERS
-- ============================================================

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    role_id INTEGER NOT NULL REFERENCES roles(id),
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    password_hash TEXT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- ADDRESSES
-- ============================================================

CREATE TABLE addresses (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL
        REFERENCES users(id)
        ON DELETE CASCADE,

    label VARCHAR(50) NOT NULL,
    recipient_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    street TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    postal_code VARCHAR(10) NOT NULL,
    is_default BOOLEAN NOT NULL DEFAULT FALSE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- CATEGORIES
-- ============================================================

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);


-- ============================================================
-- PRODUCTS
-- ============================================================

CREATE TABLE products (
    id SERIAL PRIMARY KEY,

    category_id INTEGER NOT NULL
        REFERENCES categories(id),

    name VARCHAR(100) NOT NULL,
    description TEXT,

    -- Price is stored as integer Rupiah.
    price INTEGER NOT NULL CHECK (price >= 0),

    stock INTEGER NOT NULL DEFAULT 0
        CHECK (stock >= 0),

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- CARTS
-- ============================================================

CREATE TABLE carts (
    id SERIAL PRIMARY KEY,

    user_id INTEGER NOT NULL UNIQUE
        REFERENCES users(id)
        ON DELETE CASCADE,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- CART ITEMS
-- ============================================================

CREATE TABLE cart_items (
    id SERIAL PRIMARY KEY,

    cart_id INTEGER NOT NULL
        REFERENCES carts(id)
        ON DELETE CASCADE,

    product_id INTEGER NOT NULL
        REFERENCES products(id),

    quantity INTEGER NOT NULL
        CHECK (quantity > 0),

    UNIQUE (cart_id, product_id)
);


-- ============================================================
-- ORDER STATUSES
-- ============================================================

CREATE TABLE order_statuses (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);


-- ============================================================
-- ORDERS
-- ============================================================

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,

    user_id INTEGER NOT NULL
        REFERENCES users(id),

    status_id INTEGER NOT NULL
        REFERENCES order_statuses(id),

    -- Delivery address snapshot
    shipping_recipient VARCHAR(100) NOT NULL,
    shipping_phone VARCHAR(20) NOT NULL,
    shipping_street TEXT NOT NULL,
    shipping_city VARCHAR(100) NOT NULL,
    shipping_postal_code VARCHAR(10) NOT NULL,

    subtotal INTEGER NOT NULL
        CHECK (subtotal >= 0),

    delivery_fee INTEGER NOT NULL DEFAULT 0
        CHECK (delivery_fee >= 0),

    total INTEGER NOT NULL
        CHECK (total >= 0),

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- ORDER ITEMS
-- ============================================================

CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,

    order_id INTEGER NOT NULL
        REFERENCES orders(id)
        ON DELETE CASCADE,

    product_id INTEGER
        REFERENCES products(id)
        ON DELETE SET NULL,

    -- Product snapshot at checkout
    product_name VARCHAR(100) NOT NULL,
    unit_price INTEGER NOT NULL
        CHECK (unit_price >= 0),

    quantity INTEGER NOT NULL
        CHECK (quantity > 0),

    subtotal INTEGER NOT NULL
        CHECK (subtotal >= 0)
);


-- ============================================================
-- PAYMENTS
-- ============================================================

CREATE TABLE payments (
    id SERIAL PRIMARY KEY,

    order_id INTEGER NOT NULL UNIQUE
        REFERENCES orders(id)
        ON DELETE CASCADE,

    method VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL,

    amount INTEGER NOT NULL
        CHECK (amount >= 0),

    paid_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- SEED ROLES
-- ============================================================

INSERT INTO roles (name, description)
VALUES
    ('customer', 'Customer who purchases bakery products'),
    ('store_owner', 'Store owner who manages the bakery');


-- ============================================================
-- SEED ORDER STATUSES
-- ============================================================

INSERT INTO order_statuses (name)
VALUES
    ('PENDING'),
    ('CONFIRMED'),
    ('PROCESSING'),
    ('SHIPPED'),
    ('COMPLETED'),
    ('CANCELLED');


-- ============================================================
-- SEED CATEGORIES
-- ============================================================

INSERT INTO categories (name, description)
VALUES
    ('Bread', 'Fresh bread and bakery products'),
    ('Pastry', 'Pastry and laminated bakery products'),
    ('Sandwich', 'Bread-based meals and sandwiches'),
    ('Drink', 'Hot and cold beverages');