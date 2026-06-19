-- Orbitly production schema (Postgres 16), as of migration 0003_cart.
-- Generated from db/migrations/ and kept in review so DBAs can diff schema changes.
-- orbitly-backend applies the same files from its migrations/ directory.

CREATE EXTENSION IF NOT EXISTS citext;

CREATE TABLE users (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    email           citext NOT NULL UNIQUE,
    password_hash   varchar(100) NOT NULL,
    full_name       varchar(200) NOT NULL,
    created_at      timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE products (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    sku             varchar(64) NOT NULL UNIQUE,
    name            varchar(200) NOT NULL,
    description     text NOT NULL DEFAULT '',
    price_cents     integer NOT NULL CHECK (price_cents >= 0),
    currency        char(3) NOT NULL DEFAULT 'USD',
    image_url       varchar(500),
    stock           integer NOT NULL DEFAULT 0 CHECK (stock >= 0),
    created_at      timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX products_created_at_idx ON products (created_at DESC);
CREATE INDEX products_name_lower_idx ON products (lower(name));

CREATE TABLE sessions (
    id              varchar(64) PRIMARY KEY,
    user_id         uuid NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    data            jsonb NOT NULL DEFAULT '{}'::jsonb,
    created_at      timestamptz NOT NULL DEFAULT now(),
    expires_at      timestamptz NOT NULL
);
CREATE INDEX sessions_user_id_idx ON sessions (user_id);
CREATE INDEX sessions_expires_at_idx ON sessions (expires_at);

CREATE TABLE orders (
    id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id           uuid NOT NULL REFERENCES users (id),
    status            varchar(20) NOT NULL DEFAULT 'pending'
                      CHECK (status IN ('pending', 'paid', 'shipped', 'cancelled', 'refunded')),
    subtotal_cents    integer NOT NULL,
    discount_cents    integer NOT NULL DEFAULT 0,
    tax_cents         integer NOT NULL DEFAULT 0,
    total_cents       integer NOT NULL,
    currency          char(3) NOT NULL DEFAULT 'USD',
    promo_code        varchar(32),
    shipping_address  jsonb NOT NULL,
    idempotency_key   varchar(64) UNIQUE,
    created_at        timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX orders_user_id_created_at_idx ON orders (user_id, created_at DESC);

CREATE TABLE order_items (
    order_id          uuid NOT NULL REFERENCES orders (id) ON DELETE CASCADE,
    product_id        uuid NOT NULL REFERENCES products (id),
    name              varchar(200) NOT NULL,
    unit_price_cents  integer NOT NULL,
    quantity          integer NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (order_id, product_id)
);

CREATE TABLE payments (
    id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id          uuid NOT NULL REFERENCES orders (id),
    provider          varchar(32) NOT NULL DEFAULT 'paystream',
    provider_ref      varchar(100),
    amount_cents      integer NOT NULL,
    currency          char(3) NOT NULL,
    status            varchar(20) NOT NULL CHECK (status IN ('authorized', 'captured', 'declined', 'refunded')),
    failure_reason    varchar(200),
    created_at        timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX payments_order_id_idx ON payments (order_id);

CREATE TABLE cart_items (
    user_id     uuid NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    product_id  uuid NOT NULL REFERENCES products (id),
    quantity    integer NOT NULL CHECK (quantity BETWEEN 1 AND 20),
    added_at    timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, product_id)
);
