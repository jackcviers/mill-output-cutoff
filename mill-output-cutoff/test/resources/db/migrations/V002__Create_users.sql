CREATE TABLE core.users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(50) NOT NULL,
    encrypted_email BYTEA,
    created_at TIMESTAMP DEFAULT current_timestamp
);

-- Create an index on the username column
CREATE INDEX core.idx_username ON core.users(username);
