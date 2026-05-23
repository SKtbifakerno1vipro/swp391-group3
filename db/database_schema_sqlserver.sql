-- ============================================================================
-- Sales Process Digitalization System - SQL Server Schema (Exact 17 Entities)
-- Based on Context.drawio.xml ERD
-- Created: 2026-05-20
-- ============================================================================

IF DB_ID('SWP_Sales_Process') IS NULL
BEGIN
    CREATE DATABASE SWP_Sales_Process;
END
GO

USE SWP_Sales_Process;
GO

-- 1. role
CREATE TABLE role (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name VARCHAR(100) NOT NULL,
    create_at DATETIME DEFAULT GETDATE(),
    update_at DATETIME DEFAULT GETDATE()
);

-- 2. permission
CREATE TABLE permission (
    permission_id INT IDENTITY(1,1) PRIMARY KEY,
    permission_name VARCHAR(255) NOT NULL,
    create_at DATETIME DEFAULT GETDATE(),
    update_at DATETIME DEFAULT GETDATE()
);

-- 3. role_permission
CREATE TABLE role_permission (
    role_id INT NOT NULL,
    permission_id INT NOT NULL,
    PRIMARY KEY (role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES role(role_id),
    FOREIGN KEY (permission_id) REFERENCES permission(permission_id)
);

-- 4. user
CREATE TABLE [user] (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(255),
    phone VARCHAR(20),
    status VARCHAR(50),
    role_id INT, -- FK from Role
    create_at DATETIME DEFAULT GETDATE(),
    update_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (role_id) REFERENCES role(role_id)
);

-- 5. category
CREATE TABLE category (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL
);

-- 6. product
CREATE TABLE product (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    unit VARCHAR(50),
    status VARCHAR(50),
    selling_price DECIMAL(15,2),
    category_id INT, -- FK from Category
    create_at DATETIME DEFAULT GETDATE(),
    update_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (category_id) REFERENCES category(category_id)
);

-- 7. customer
CREATE TABLE customer (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT UNIQUE NULL, -- FK from User
    tax_code VARCHAR(50),
    type VARCHAR(50),
    create_by INT NULL,
    create_at DATETIME DEFAULT GETDATE(),
    update_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES [user](user_id)
);

-- 8. provider
CREATE TABLE provider (
    provider_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT UNIQUE NULL, -- FK from User
    tax_code VARCHAR(50),
    provider_name VARCHAR(255) NOT NULL,
    create_at DATETIME DEFAULT GETDATE(),
    update_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES [user](user_id)
);

-- 9. provider_product
CREATE TABLE provider_product (
    provider_id INT NOT NULL,
    product_id INT NOT NULL,
    cost_price DECIMAL(15,2),
    create_at DATETIME DEFAULT GETDATE(),
    update_at DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (provider_id, product_id),
    FOREIGN KEY (provider_id) REFERENCES provider(provider_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- 10. customer_order
CREATE TABLE customer_order (
    customer_order_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    status VARCHAR(50),
    create_by INT,
    create_at DATETIME DEFAULT GETDATE(),
    update_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

-- 11. customer_order_detail
CREATE TABLE customer_order_detail (
    customer_order_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (customer_order_id) REFERENCES customer_order(customer_order_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- 12. quotation
CREATE TABLE quotation (
    quotation_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_order_id INT NULL,
    quotation_date DATETIME DEFAULT GETDATE(),
    status VARCHAR(50),
    total_amount DECIMAL(15,2),
    created_by INT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (customer_order_id) REFERENCES customer_order(customer_order_id)
);

-- 13. quotation_detail
CREATE TABLE quotation_detail (
    quotation_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    quotation_id INT NOT NULL,
    quantity INT,
    selling_price DECIMAL(15,2),
    discount_percent DECIMAL(5,2),
    tax_percent DECIMAL(5,2),
    amount DECIMAL(15,2),
    FOREIGN KEY (quotation_id) REFERENCES quotation(quotation_id)
);

-- 14. provider_order
CREATE TABLE provider_order (
    provider_order_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_order_id INT NULL,
    asigned_by INT,
    assigned_at DATETIME DEFAULT GETDATE(),
    status VARCHAR(50),
    FOREIGN KEY (customer_order_id) REFERENCES customer_order(customer_order_id)
);

-- 15. provider_order_detail
CREATE TABLE provider_order_detail (
    provider_order_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    provider_order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (provider_order_id) REFERENCES provider_order(provider_order_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- 16. customer_contract
CREATE TABLE customer_contract (
    contract_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_order_id INT NULL,
    contract_number VARCHAR(100) UNIQUE NOT NULL,
    total_amount DECIMAL(15,2),
    status VARCHAR(50),
    contract_version INT,
    signed_at DATETIME NULL,
    FOREIGN KEY (customer_order_id) REFERENCES customer_order(customer_order_id)
);

-- 17. provider_contract
CREATE TABLE provider_contract (
    contract_id INT IDENTITY(1,1) PRIMARY KEY,
    provider_order_id INT NULL,
    start_date DATE,
    end_date DATE,
    status VARCHAR(50),
    FOREIGN KEY (provider_order_id) REFERENCES provider_order(provider_order_id)
);

-- ============================================================================
-- SEED SAMPLE DATA (Expanded)
-- ============================================================================

-- Role & Permission
INSERT INTO role (role_name) VALUES ('Admin'), ('Manager'), ('Sale'), ('Provider'), ('Customer');
INSERT INTO permission (permission_name) VALUES ('Manage Users'), ('Manage Orders'), ('Manage Contracts'), ('View Reports');
INSERT INTO role_permission (role_id, permission_id) SELECT r.role_id, p.permission_id FROM role r, permission p;

-- Users
IF NOT EXISTS (SELECT 1 FROM [user] WHERE user_name = 'admin')
BEGIN
    INSERT INTO [user] (user_name, password, email, full_name, status, role_id) VALUES
    ('admin', '123', 'admin@mail.com', 'System Admin', 'Active', 1);
END;

IF NOT EXISTS (SELECT 1 FROM [user] WHERE user_name = 'manager_a')
BEGIN
    INSERT INTO [user] (user_name, password, email, full_name, status, role_id) VALUES
    ('manager_a', '123', 'manager@mail.com', 'Nguyen Manager', 'Active', 2);
END;

IF NOT EXISTS (SELECT 1 FROM [user] WHERE user_name = 'sale_x')
BEGIN
    INSERT INTO [user] (user_name, password, email, full_name, status, role_id) VALUES
    ('sale_x', '123', 'sale@mail.com', 'Tran Sale', 'Active', 3);
END;

IF NOT EXISTS (SELECT 1 FROM [user] WHERE user_name = 'bakery_abc')
BEGIN
    INSERT INTO [user] (user_name, password, email, full_name, status, role_id) VALUES
    ('bakery_abc', '123', 'bakery@mail.com', 'ABC Bakery', 'Active', 4);
END;

IF NOT EXISTS (SELECT 1 FROM [user] WHERE user_name = 'customer_j')
BEGIN
    INSERT INTO [user] (user_name, password, email, full_name, status, role_id) VALUES
    ('customer_j', '123', 'john@mail.com', 'John Doe', 'Active', 5);
END;

-- Categories & Products
INSERT INTO category (category_name) VALUES ('Bánh Mì'), ('Bánh Kem'), ('Bánh Quy');
INSERT INTO product (product_name, selling_price, category_id, status) VALUES
('Bánh Mì Sừng Bò', 25000, 1, 'Active'),
('Bánh Kem Dâu', 350000, 2, 'Active'),
('Cookies Socola', 50000, 3, 'Active');

-- Customer & Provider Profiles
INSERT INTO customer (user_id, tax_code, type) VALUES (5, '123456', 'Personal');
INSERT INTO provider (user_id, tax_code, provider_name) VALUES (4, '789012', 'ABC Bakery Corp');

-- Quotation & Orders
INSERT INTO customer_order (customer_id, status) VALUES (1, 'Pending');
INSERT INTO customer_order_detail (customer_order_id, product_id, quantity) VALUES (1, 1, 10), (1, 2, 1);
INSERT INTO quotation (customer_order_id, status, total_amount) VALUES (1, 'Accepted', 600000);
INSERT INTO quotation_detail (quotation_id, quantity, selling_price, amount) VALUES (1, 10, 25000, 250000), (1, 1, 350000, 350000);

-- Contracts
INSERT INTO customer_contract (customer_order_id, contract_number, total_amount, status) VALUES (1, 'CTR-2026-001', 600000, 'Signed');
INSERT INTO provider_order (customer_order_id, status) VALUES (1, 'In Progress');
INSERT INTO provider_contract (provider_order_id, start_date, end_date, status) VALUES (1, '2026-05-20', '2026-06-20', 'Active');

GO
