CREATE TABLE core.user_status_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES core.users(id) ON DELETE CASCADE,
    status_id UUID REFERENCES core.statuses(id) ON DELETE CASCADE,
    status_timestamp TIMESTAMP DEFAULT current_timestamp
);
-- Add an index on the status_timestamp column
CREATE INDEX idx_status_timestamp ON core.user_status_history(status_timestamp);
