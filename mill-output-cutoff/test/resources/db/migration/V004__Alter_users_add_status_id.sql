-- Create a function to get the default value
CREATE OR REPLACE FUNCTION get_default_status_id()
RETURNS UUID AS $$
DECLARE
  default_id UUID;
BEGIN
  SELECT id INTO default_id
  FROM core.statuses
  WHERE status_name = 'unverified'
  LIMIT 1;

  RETURN default_id;
END;
$$ LANGUAGE plpgsql;

-- Alter the table to add the column with the default value from the function
ALTER TABLE core.users
ADD COLUMN status_id UUID DEFAULT core.get_default_status_id();
-- Add an index on the status_id column for faster lookups
CREATE INDEX idx_status_id ON core.users(status_id);

-- Create the foreign key relationship with ON DELETE SET DEFAULT
ALTER TABLE core.users
ADD CONSTRAINT fk_status_id
FOREIGN KEY (status_id)
REFERENCES core.statuses(id)
ON DELETE SET DEFAULT;
