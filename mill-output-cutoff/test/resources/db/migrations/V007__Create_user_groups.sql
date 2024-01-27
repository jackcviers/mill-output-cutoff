CREATE TABLE core.groups (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    group_name VARCHAR(100) UNIQUE
);
CREATE TABLE core.user_groups (
    user_id UUID REFERENCES core.users(id) ON DELETE CASCADE,
    group_id UUID REFERENCES core.groups(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, group_id)
);
