CREATE TABLE core.repositories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES core.users(id) ON DELETE CASCADE,
    repository_name VARCHAR(100) UNIQUE,
    description TEXT,
    markdown_readme TEXT,
    created_at TIMESTAMP DEFAULT current_timestamp
);

INSERT INTO core.permissions (permission_name) VALUES
    ('Admin'),
    ('Read'),
    ('Write'),
    ('Maintainer');

CREATE TABLE core.user_permissions (
    user_id UUID REFERENCES core.users(id) ON DELETE CASCADE,
    permission_id UUID REFERENCES core.permissions(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, permission_id)
);

CREATE TABLE core.group_permissions (
    group_id UUID REFERENCES core.groups(id) ON DELETE CASCADE,
    permission_id UUID REFERENCES core.permissions(id) ON DELETE CASCADE,
    PRIMARY KEY (group_id, permission_id)
);
