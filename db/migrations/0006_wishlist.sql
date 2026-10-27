-- 006_wishlist: saved-for-later products.
CREATE TABLE wishlist_items (
    user_id     uuid NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    product_id  uuid NOT NULL REFERENCES products (id) ON DELETE CASCADE,
    added_at    timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, product_id)
);
