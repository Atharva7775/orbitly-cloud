-- 003_cart: server-side carts so a cart follows the customer across devices.
CREATE TABLE cart_items (
    user_id     uuid NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    product_id  uuid NOT NULL REFERENCES products (id),
    quantity    integer NOT NULL CHECK (quantity BETWEEN 1 AND 20),
    added_at    timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, product_id)
);
