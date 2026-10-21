-- 005_order_cancellation: customers can cancel until the order ships.
ALTER TABLE orders
    ADD COLUMN cancelled_at   timestamptz,
    ADD COLUMN cancel_reason  varchar(50);

ALTER TABLE orders
    ADD CONSTRAINT orders_cancel_consistency
    CHECK ((status = 'cancelled') = (cancelled_at IS NOT NULL));
