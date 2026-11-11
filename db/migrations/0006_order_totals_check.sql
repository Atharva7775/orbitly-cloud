-- 0006_order_totals_check: reject orders whose stored components do not add up.
-- Added after the cart-rounding incident, where a 1-cent per-line rounding drift
-- produced orders whose total disagreed with subtotal - discount + tax.
ALTER TABLE orders
    ADD CONSTRAINT orders_total_consistency
    CHECK (total_cents = subtotal_cents - discount_cents + tax_cents) NOT VALID;
