-- 001_init: accounts, catalog and server-side cookie sessions.
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

-- Session id is the value of the orbitly_sid cookie.
CREATE TABLE sessions (
    id              varchar(64) PRIMARY KEY,
    user_id         uuid NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    data            jsonb NOT NULL DEFAULT '{}'::jsonb,
    created_at      timestamptz NOT NULL DEFAULT now(),
    expires_at      timestamptz NOT NULL
);

CREATE INDEX sessions_user_id_idx ON sessions (user_id);
CREATE INDEX sessions_expires_at_idx ON sessions (expires_at);
