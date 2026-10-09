CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    username VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL
        CHECK (role IN ('operator', 'admin')),
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE storage_cells (
    id BIGSERIAL PRIMARY KEY,
    cell_code VARCHAR(30) UNIQUE NOT NULL,
    location_description VARCHAR(200),
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'На хранении',
    storage_cell_id BIGINT REFERENCES storage_cells(id),
    received_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    issued_at TIMESTAMP,
    created_by BIGINT NOT NULL REFERENCES users(id)
);

CREATE TABLE stock_operations (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders(id),
    user_id BIGINT NOT NULL REFERENCES users(id),
    operation_type VARCHAR(30) NOT NULL,
    source_cell_id BIGINT REFERENCES storage_cells(id),
    destination_cell_id BIGINT REFERENCES storage_cells(id),
    operation_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    comment TEXT
);

CREATE TABLE inventory_checks (
    id BIGSERIAL PRIMARY KEY,
    started_by BIGINT NOT NULL REFERENCES users(id),
    started_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'in_progress',
    comment TEXT
);

CREATE TABLE inventory_items (
    id BIGSERIAL PRIMARY KEY,
    inventory_id BIGINT NOT NULL REFERENCES inventory_checks(id),
    order_id BIGINT NOT NULL REFERENCES orders(id),
    expected_cell_id BIGINT REFERENCES storage_cells(id),
    actual_cell_id BIGINT REFERENCES storage_cells(id),
    found BOOLEAN NOT NULL DEFAULT TRUE,
    discrepancy_comment TEXT,
    UNIQUE (inventory_id, order_id)
);