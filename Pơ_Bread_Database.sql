CREATE DATABASE SalesProcessDB;
GO

USE SalesProcessDB;
GO

-- =========================
-- 1. ROLE / PERMISSION / USER
-- =========================

CREATE TABLE [role] (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name NVARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME NULL
);

CREATE TABLE permission (
    permission_id INT IDENTITY(1,1) PRIMARY KEY,
    permission_name NVARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME NULL
);

CREATE TABLE role_permission (
    role_id INT NOT NULL,
    permission_id INT NOT NULL,

    PRIMARY KEY (role_id, permission_id),

    CONSTRAINT fk_role_permission_role
        FOREIGN KEY (role_id) REFERENCES [role](role_id),

    CONSTRAINT fk_role_permission_permission
        FOREIGN KEY (permission_id) REFERENCES permission(permission_id)
);

CREATE TABLE [user] (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    role_id INT NOT NULL,
    user_name NVARCHAR(100) NOT NULL UNIQUE,
    [password] NVARCHAR(255) NOT NULL,
    email NVARCHAR(150) NOT NULL UNIQUE,
    full_name NVARCHAR(150) NOT NULL,
    phone NVARCHAR(20),
    [status] NVARCHAR(50) DEFAULT 'Active',
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME NULL,

    CONSTRAINT fk_user_role
        FOREIGN KEY (role_id) REFERENCES [role](role_id)
);

-- =========================
-- 2. CUSTOMER / PROVIDER
-- =========================

CREATE TABLE customer (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NULL,
    tax_code NVARCHAR(50),
    [type] NVARCHAR(50),
    created_by INT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME NULL,

    CONSTRAINT fk_customer_user
        FOREIGN KEY (user_id) REFERENCES [user](user_id),

    CONSTRAINT fk_customer_created_by
        FOREIGN KEY (created_by) REFERENCES [user](user_id)
);

CREATE TABLE provider (
    provider_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NULL,
    tax_code NVARCHAR(50),
    provider_name NVARCHAR(150) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME NULL,

    CONSTRAINT fk_provider_user
        FOREIGN KEY (user_id) REFERENCES [user](user_id)
);

-- =========================
-- 3. CATEGORY / PRODUCT
-- =========================

CREATE TABLE category (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name NVARCHAR(100) NOT NULL
);

CREATE TABLE product (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    category_id INT NOT NULL,
    product_name NVARCHAR(150) NOT NULL,
    [description] NVARCHAR(MAX),
    unit NVARCHAR(50),
    [status] NVARCHAR(50) DEFAULT 'Active',
    selling_price DECIMAL(18,2) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME NULL,

    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id) REFERENCES category(category_id)
);

CREATE TABLE provider_product (
    provider_id INT NOT NULL,
    product_id INT NOT NULL,
    cost_price DECIMAL(18,2) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME NULL,

    PRIMARY KEY (provider_id, product_id),

    CONSTRAINT fk_provider_product_provider
        FOREIGN KEY (provider_id) REFERENCES provider(provider_id),

    CONSTRAINT fk_provider_product_product
        FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- =========================
-- 4. QUOTATION
-- =========================

CREATE TABLE quotation (
    quotation_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    quotation_date DATE DEFAULT GETDATE(),
    [status] NVARCHAR(50) DEFAULT 'Draft',
    total_amount DECIMAL(18,2) DEFAULT 0,
    created_by INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),

    CONSTRAINT fk_quotation_customer
        FOREIGN KEY (customer_id) REFERENCES customer(customer_id),

    CONSTRAINT fk_quotation_created_by
        FOREIGN KEY (created_by) REFERENCES [user](user_id)
);

CREATE TABLE quotation_detail (
    quotation_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    quotation_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    selling_price DECIMAL(18,2) NOT NULL,
    discount_percent DECIMAL(5,2) DEFAULT 0,
    tax_percent DECIMAL(5,2) DEFAULT 0,
    amount DECIMAL(18,2) NOT NULL,

    CONSTRAINT fk_quotation_detail_quotation
        FOREIGN KEY (quotation_id) REFERENCES quotation(quotation_id),

    CONSTRAINT fk_quotation_detail_product
        FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- =========================
-- 5. CUSTOMER CONTRACT
-- =========================

CREATE TABLE customer_contract (
    contract_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    quotation_id INT NULL,
    contract_number NVARCHAR(100) NOT NULL UNIQUE,
    total_amount DECIMAL(18,2) NOT NULL,
    [status] NVARCHAR(50) DEFAULT 'Draft',
    contract_version INT DEFAULT 1,
    signed_at DATETIME NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME NULL,

    CONSTRAINT fk_customer_contract_customer
        FOREIGN KEY (customer_id) REFERENCES customer(customer_id),

    CONSTRAINT fk_customer_contract_quotation
        FOREIGN KEY (quotation_id) REFERENCES quotation(quotation_id)
);

-- =========================
-- 6. CUSTOMER ORDER
-- =========================

CREATE TABLE customer_order (
    customer_order_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    quotation_id INT NULL,
    contract_id INT NULL,
    [status] NVARCHAR(50) DEFAULT 'Pending',
    created_by INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME NULL,

    CONSTRAINT fk_customer_order_customer
        FOREIGN KEY (customer_id) REFERENCES customer(customer_id),

    CONSTRAINT fk_customer_order_quotation
        FOREIGN KEY (quotation_id) REFERENCES quotation(quotation_id),

    CONSTRAINT fk_customer_order_contract
        FOREIGN KEY (contract_id) REFERENCES customer_contract(contract_id),

    CONSTRAINT fk_customer_order_created_by
        FOREIGN KEY (created_by) REFERENCES [user](user_id)
);

CREATE TABLE customer_order_detail (
    customer_order_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,

    CONSTRAINT fk_customer_order_detail_order
        FOREIGN KEY (customer_order_id) REFERENCES customer_order(customer_order_id),

    CONSTRAINT fk_customer_order_detail_product
        FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- =========================
-- 7. PROVIDER CONTRACT / PROVIDER ORDER
-- =========================

CREATE TABLE provider_contract (
    contract_id INT IDENTITY(1,1) PRIMARY KEY,
    provider_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    [status] NVARCHAR(50) DEFAULT 'Active',

    CONSTRAINT fk_provider_contract_provider
        FOREIGN KEY (provider_id) REFERENCES provider(provider_id)
);

CREATE TABLE provider_order (
    provider_order_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_order_id INT NOT NULL,
    provider_id INT NOT NULL,
    provider_contract_id INT NULL,
    assigned_by INT NOT NULL,
    assigned_at DATETIME DEFAULT GETDATE(),
    [status] NVARCHAR(50) DEFAULT 'Assigned',

    CONSTRAINT fk_provider_order_customer_order
        FOREIGN KEY (customer_order_id) REFERENCES customer_order(customer_order_id),

    CONSTRAINT fk_provider_order_provider
        FOREIGN KEY (provider_id) REFERENCES provider(provider_id),

    CONSTRAINT fk_provider_order_contract
        FOREIGN KEY (provider_contract_id) REFERENCES provider_contract(contract_id),

    CONSTRAINT fk_provider_order_assigned_by
        FOREIGN KEY (assigned_by) REFERENCES [user](user_id)
);

CREATE TABLE provider_order_detail (
    provider_order_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    provider_order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,

    CONSTRAINT fk_provider_order_detail_order
        FOREIGN KEY (provider_order_id) REFERENCES provider_order(provider_order_id),

    CONSTRAINT fk_provider_order_detail_product
        FOREIGN KEY (product_id) REFERENCES product(product_id)
);