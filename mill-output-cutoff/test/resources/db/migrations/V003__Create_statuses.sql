CREATE TABLE core.statuses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    status_name VARCHAR(20) NOT NULL UNIQUE,
    description VARCHAR(255)
);
CREATE INDEX idx_status_name ON core.statuses(status_name);

-- Insert the predefined statuses
INSERT INTO core.statuses (status_name, description) VALUES 
    ('verified', 'User account is verified'),
    ('unverified', 'User account is not yet verified'),
    ('deleted', 'User account is deleted'),
    ('change_password', 'User is requested to change the password');

ALTER TABLE core.statuses
ADD CONSTRAINT chk_no_delete_unverified CHECK (status_name <> 'unverified');

CREATE OR REPLACE FUNCTION prevent_delete_unverified()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.status_name = 'unverified' THEN
        RAISE EXCEPTION 'Cannot delete the "unverified" status.';
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_prevent_delete_unverified
BEFORE DELETE ON core.statuses
FOR EACH ROW EXECUTE FUNCTION prevent_delete_unverified();
