-- Modify the existing status_id column to use ON DELETE SET DEFAULT
ALTER TABLE core.users
ALTER COLUMN status_id SET DEFAULT (SELECT id FROM core.statuses WHERE status_name = 'unverified')::UUID;

-- Add an index on the status_id column for faster lookups
CREATE INDEX idx_status_id ON core.users(status_id);

-- Create the foreign key relationship with ON DELETE SET DEFAULT
ALTER TABLE core.users
ADD CONSTRAINT fk_status_id
FOREIGN KEY (status_id)
REFERENCES core.statuses(id)
ON DELETE SET DEFAULT;
