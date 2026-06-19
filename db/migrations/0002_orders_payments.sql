-- 002_orders_payments: orders snapshot prices at purchase time so later catalog
-- edits never change what a customer was charged.
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
