CREATE TABLE core.user_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID UNIQUE REFERENCES core.users(id) ON DELETE CASCADE,
    user_icon BYTEA,
    tagline VARCHAR(255),
    website VARCHAR(255)
);

-- Optionally, add an index on the user_id column for faster lookups
CREATE INDEX idx_user_profiles_user_id ON core.user_profiles(user_id);
