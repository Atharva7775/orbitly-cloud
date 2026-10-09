-- 006_price_tiers: per-product volume tiers for the new-pricing experiment.
CREATE TABLE price_tiers (
    product_id    uuid NOT NULL REFERENCES products (id) ON DELETE CASCADE,
    min_quantity  integer NOT NULL CHECK (min_quantity > 1),
    off_bps       integer NOT NULL CHECK (off_bps BETWEEN 1 AND 5000),
    PRIMARY KEY (product_id, min_quantity)
);
