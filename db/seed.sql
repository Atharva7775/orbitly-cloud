-- Demo catalog for local and QA environments. Never run against production.
INSERT INTO products (sku, name, description, price_cents, currency, image_url, stock) VALUES
    ('ORB-TEE-001', 'Orbit Tee', 'Heavyweight cotton tee with the Orbitly ring logo.', 2400, 'USD',
     'https://cdn.orbitly.example/img/orb-tee-001.jpg', 120),
    ('ORB-MUG-002', 'Low-Gravity Mug', 'Double-walled ceramic mug, 350 ml.', 1800, 'USD',
     'https://cdn.orbitly.example/img/orb-mug-002.jpg', 75),
    ('ORB-CAP-003', 'Apogee Cap', 'Six-panel cap, adjustable strap.', 2200, 'USD',
     'https://cdn.orbitly.example/img/orb-cap-003.jpg', 60),
    ('ORB-BAG-004', 'Payload Tote', 'Recycled canvas tote with inner pocket.', 2900, 'USD',
     'https://cdn.orbitly.example/img/orb-bag-004.jpg', 40),
    ('ORB-LMP-005', 'Moonrise Desk Lamp', 'Dimmable LED lamp with USB-C.', 6900, 'USD',
     'https://cdn.orbitly.example/img/orb-lmp-005.jpg', 25),
    ('ORB-BTL-006', 'Vacuum Flask', 'Keeps drinks cold for 24 hours.', 3400, 'USD',
     'https://cdn.orbitly.example/img/orb-btl-006.jpg', 0)
ON CONFLICT (sku) DO NOTHING;
