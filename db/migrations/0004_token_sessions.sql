-- 004_token_sessions: replace cookie sessions with opaque bearer tokens.
--
-- Why: the EU edge and the mobile app both call the API cross-origin, where
-- third-party cookie blocking broke sign-in, and sticky cookie sessions tied
-- users to one region. Tokens are sent in the Authorization header instead.
--
-- Existing cookie sessions cannot be turned into tokens (we never stored a
-- token), so they are dropped and every customer signs in once more.
DROP TABLE sessions;

CREATE TABLE sessions (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     uuid NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    -- SHA-256 hex of the bearer token; the token itself is never stored.
    token_hash  char(64) NOT NULL UNIQUE,
    user_agent  varchar(300),
    created_at  timestamptz NOT NULL DEFAULT now(),
    expires_at  timestamptz NOT NULL,
    revoked_at  timestamptz,
    metadata    jsonb NOT NULL DEFAULT '{}'::jsonb
);

CREATE INDEX sessions_user_id_idx ON sessions (user_id);
CREATE INDEX sessions_expires_at_idx ON sessions (expires_at) WHERE revoked_at IS NULL;
