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
-- SEED SAMPLE DATA (Expanded - ~10 records per entity with logical relationships)
-- ============================================================================

-- 1. Role (5 roles)
INSERT INTO role (role_name) VALUES
('Admin'),
('Manager'),
('Sale'),
('Provider'),
('Customer');

-- 2. Permission (10 permissions)
INSERT INTO permission (permission_name) VALUES
('Manage Users'),
('Manage Orders'),
('Manage Contracts'),
('View Reports'),
('Create Quotation'),
('Approve Contract'),
('Manage Products'),
('Manage Providers'),
('View Dashboard'),
('Export Data');

-- 3. Role_Permission (Assign permissions to roles logically)
-- Admin: all permissions
INSERT INTO role_permission (role_id, permission_id)
SELECT 1, permission_id FROM permission;

-- Manager: most permissions except user management
INSERT INTO role_permission (role_id, permission_id)
SELECT 2, permission_id FROM permission WHERE permission_id IN (2,3,4,5,6,7,8,9,10);

-- Sale: order and quotation related
INSERT INTO role_permission (role_id, permission_id)
SELECT 3, permission_id FROM permission WHERE permission_id IN (2,4,5,7,9);

-- Provider: view only
INSERT INTO role_permission (role_id, permission_id)
SELECT 4, permission_id FROM permission WHERE permission_id IN (4,9);

-- Customer: minimal view
INSERT INTO role_permission (role_id, permission_id)
SELECT 5, permission_id FROM permission WHERE permission_id IN (4,9);

-- 4. User (15 users: 1 admin, 2 managers, 4 sales, 3 providers, 5 customers)
INSERT INTO [user] (user_name, password, email, full_name, phone, status, role_id) VALUES
-- Admin
('admin', '123', 'admin@swp.com', 'Nguyen Van Admin', '0901234567', 'Active', 1),
-- Managers
('manager_north', '123', 'manager.north@swp.com', 'Tran Thi Manager North', '0902345678', 'Active', 2),
('manager_south', '123', 'manager.south@swp.com', 'Le Van Manager South', '0903456789', 'Active', 2),
-- Sales
('sale_hcm', '123', 'sale.hcm@swp.com', 'Pham Thi Sale HCM', '0904567890', 'Active', 3),
('sale_hn', '123', 'sale.hn@swp.com', 'Hoang Van Sale HN', '0905678901', 'Active', 3),
('sale_dn', '123', 'sale.dn@swp.com', 'Vo Thi Sale DN', '0906789012', 'Active', 3),
('sale_ct', '123', 'sale.ct@swp.com', 'Dang Van Sale CT', '0907890123', 'Inactive', 3),
-- Providers
('provider_abc', '123', 'contact@abc-bakery.com', 'ABC Bakery Corp', '0281234567', 'Active', 4),
('provider_xyz', '123', 'info@xyz-food.com', 'XYZ Food Supply', '0282345678', 'Active', 4),
('provider_def', '123', 'sales@def-wholesale.com', 'DEF Wholesale', '0283456789', 'Active', 4),
-- Customers
('customer_john', '123', 'john.doe@gmail.com', 'John Doe', '0908901234', 'Active', 5),
('customer_jane', '123', 'jane.smith@yahoo.com', 'Jane Smith', '0909012345', 'Active', 5),
('customer_minh', '123', 'minh.nguyen@company.vn', 'Nguyen Van Minh', '0900123456', 'Active', 5),
('customer_lan', '123', 'lan.tran@enterprise.vn', 'Tran Thi Lan', '0901234568', 'Active', 5),
('customer_hung', '123', 'hung.le@business.vn', 'Le Van Hung', '0902345679', 'Inactive', 5);

-- 5. Category (10 categories)
INSERT INTO category (category_name) VALUES
('Bánh Mì'),
('Bánh Kem'),
('Bánh Quy'),
('Bánh Ngọt'),
('Bánh Mặn'),
('Đồ Uống'),
('Nguyên Liệu'),
('Bao Bì'),
('Thiết Bị'),
('Phụ Kiện');

-- 6. Product (15 products across categories)
INSERT INTO product (product_name, description, unit, status, selling_price, category_id) VALUES
('Bánh Mì Sừng Bò', 'Croissant bơ Pháp', 'Cái', 'Active', 25000, 1),
('Bánh Mì Sandwich', 'Bánh mì kẹp thịt', 'Cái', 'Active', 35000, 1),
('Bánh Kem Dâu', 'Bánh kem tươi dâu tây', 'Hộp', 'Active', 350000, 2),
('Bánh Kem Socola', 'Bánh kem socola đen', 'Hộp', 'Active', 380000, 2),
('Cookies Socola', 'Bánh quy socola chip', 'Hộp', 'Active', 50000, 3),
('Cookies Bơ', 'Bánh quy bơ truyền thống', 'Hộp', 'Active', 45000, 3),
('Bánh Bông Lan', 'Bánh bông lan trứng', 'Cái', 'Active', 15000, 4),
('Bánh Tiramisu', 'Bánh Tiramisu Ý', 'Miếng', 'Active', 55000, 4),
('Bánh Pate Gà', 'Bánh patê nhân gà', 'Cái', 'Active', 20000, 5),
('Bánh Pizza Mini', 'Pizza mini phô mai', 'Cái', 'Active', 30000, 5),
('Cà Phê Đen', 'Cà phê đen nguyên chất', 'Ly', 'Active', 25000, 6),
('Trà Sữa Trân Châu', 'Trà sữa trân châu đường đen', 'Ly', 'Active', 35000, 6),
('Bột Mì Số 13', 'Bột mì đa dụng', 'Kg', 'Active', 18000, 7),
('Hộp Giấy 20x20', 'Hộp đựng bánh giấy kraft', 'Cái', 'Active', 3000, 8),
('Dao Cắt Bánh', 'Dao inox cắt bánh chuyên dụng', 'Cái', 'Inactive', 120000, 9);

-- 7. Customer (10 customer profiles linked to user_id 11-15 + 5 more without user account)
INSERT INTO customer (user_id, tax_code, type, create_by) VALUES
(11, 'TCN-001', 'Personal', 4),  -- John Doe
(12, 'TCN-002', 'Personal', 4),  -- Jane Smith
(13, 'TDN-1234567890', 'Business', 5), -- Nguyen Van Minh (company)
(14, 'TDN-0987654321', 'Business', 5), -- Tran Thi Lan (enterprise)
(15, 'TCN-003', 'Personal', 6),  -- Le Van Hung
(NULL, 'TDN-1122334455', 'Business', 4), -- Walk-in customer 1
(NULL, 'TCN-004', 'Personal', 5), -- Walk-in customer 2
(NULL, 'TDN-5566778899', 'Business', 6), -- Walk-in customer 3
(NULL, 'TCN-005', 'Personal', 4), -- Walk-in customer 4
(NULL, 'TDN-9988776655', 'Business', 5); -- Walk-in customer 5

-- 8. Provider (10 provider profiles: 3 with user accounts + 7 without)
INSERT INTO provider (user_id, tax_code, provider_name) VALUES
(8, 'MST-ABC-123456', 'ABC Bakery Corp'),
(9, 'MST-XYZ-789012', 'XYZ Food Supply Co., Ltd'),
(10, 'MST-DEF-345678', 'DEF Wholesale Distribution'),
(NULL, 'MST-GHI-111222', 'GHI Ingredient Supplier'),
(NULL, 'MST-JKL-333444', 'JKL Packaging Solutions'),
(NULL, 'MST-MNO-555666', 'MNO Equipment Trading'),
(NULL, 'MST-PQR-777888', 'PQR Dairy Products'),
(NULL, 'MST-STU-999000', 'STU Chocolate Import'),
(NULL, 'MST-VWX-121314', 'VWX Organic Flour'),
(NULL, 'MST-YZA-151617', 'YZA Coffee Beans');

-- 9. Provider_Product (Link providers to products they supply with cost price)
INSERT INTO provider_product (provider_id, product_id, cost_price) VALUES
-- ABC Bakery supplies bread products
(1, 1, 18000), (1, 2, 25000), (1, 7, 10000), (1, 9, 15000),
-- XYZ Food supplies cakes and drinks
(2, 3, 280000), (2, 4, 300000), (2, 11, 18000), (2, 12, 25000),
-- DEF Wholesale supplies cookies and ingredients
(3, 5, 35000), (3, 6, 32000), (3, 13, 15000),
-- GHI supplies ingredients
(4, 13, 16000),
-- JKL supplies packaging
(5, 14, 2000),
-- MNO supplies equipment
(6, 15, 95000),
-- PQR supplies dairy for cakes
(7, 3, 290000), (7, 4, 310000),
-- STU supplies chocolate products
(8, 4, 295000), (8, 5, 36000), (8, 8, 42000),
-- VWX supplies organic flour
(9, 13, 20000),
-- YZA supplies coffee
(10, 11, 20000);

-- 10. Customer_Order (12 orders from different customers with different statuses)
INSERT INTO customer_order (customer_id, status, create_by) VALUES
(1, 'Completed', 4),   -- John Doe order
(2, 'Completed', 4),   -- Jane Smith order
(3, 'In Progress', 5), -- Nguyen Van Minh order
(4, 'Pending', 5),     -- Tran Thi Lan order
(5, 'Cancelled', 6),   -- Le Van Hung order
(1, 'Completed', 4),   -- John Doe 2nd order
(3, 'Completed', 5),   -- Nguyen Van Minh 2nd order
(6, 'In Progress', 4), -- Walk-in customer 1
(7, 'Pending', 5),     -- Walk-in customer 2
(8, 'Completed', 6),   -- Walk-in customer 3
(2, 'In Progress', 4), -- Jane Smith 2nd order
(4, 'Completed', 5);   -- Tran Thi Lan 2nd order

-- 11. Customer_Order_Detail (Order items for each order)
INSERT INTO customer_order_detail (customer_order_id, product_id, quantity) VALUES
-- Order 1: John Doe - Breakfast combo
(1, 1, 10), (1, 11, 5),
-- Order 2: Jane Smith - Birthday cake
(2, 3, 1), (2, 5, 2),
-- Order 3: Nguyen Van Minh - Corporate event
(3, 2, 50), (3, 10, 30), (3, 12, 40),
-- Order 4: Tran Thi Lan - Office snacks
(4, 5, 10), (4, 6, 10), (4, 11, 20),
-- Order 5: Le Van Hung - Cancelled
(5, 3, 1),
-- Order 6: John Doe 2nd - Weekend party
(6, 3, 2), (6, 4, 1), (6, 5, 3),
-- Order 7: Nguyen Van Minh 2nd - Monthly supply
(7, 1, 100), (7, 7, 50), (7, 9, 80),
-- Order 8: Walk-in 1
(8, 2, 5), (8, 10, 5),
-- Order 9: Walk-in 2
(9, 6, 5), (9, 11, 10),
-- Order 10: Walk-in 3
(10, 1, 20), (10, 7, 15),
-- Order 11: Jane Smith 2nd
(11, 4, 1), (11, 8, 4),
-- Order 12: Tran Thi Lan 2nd
(12, 2, 30), (12, 9, 25), (12, 12, 30);

-- 12. Quotation (10 quotations for orders)
INSERT INTO quotation (customer_order_id, quotation_date, status, total_amount, created_by) VALUES
(1, '2026-05-10 09:00:00', 'Accepted', 375000, 4),
(2, '2026-05-11 10:30:00', 'Accepted', 450000, 4),
(3, '2026-05-12 14:00:00', 'Accepted', 3550000, 5),
(4, '2026-05-13 11:00:00', 'Pending', 1400000, 5),
(5, '2026-05-14 15:00:00', 'Rejected', 350000, 6),
(6, '2026-05-15 16:00:00', 'Accepted', 1230000, 4),
(7, '2026-05-16 09:30:00', 'Accepted', 4850000, 5),
(8, '2026-05-17 13:00:00', 'Accepted', 325000, 4),
(9, '2026-05-18 10:00:00', 'Pending', 575000, 5),
(10, '2026-05-19 11:30:00', 'Accepted', 725000, 6);

-- 13. Quotation_Detail (Details for each quotation with pricing)
INSERT INTO quotation_detail (quotation_id, quantity, selling_price, discount_percent, tax_percent, amount) VALUES
-- Quotation 1
(1, 10, 25000, 0, 10, 275000), (1, 5, 25000, 0, 10, 137500),
-- Quotation 2
(2, 1, 350000, 0, 10, 385000), (2, 2, 50000, 5, 10, 104500),
-- Quotation 3
(3, 50, 35000, 5, 10, 1826250), (3, 30, 30000, 5, 10, 940500), (3, 40, 35000, 5, 10, 1460400),
-- Quotation 4
(4, 10, 50000, 0, 10, 550000), (4, 10, 45000, 0, 10, 495000), (4, 20, 25000, 0, 10, 550000),
-- Quotation 5
(5, 1, 350000, 0, 10, 385000),
-- Quotation 6
(6, 2, 350000, 5, 10, 730500), (6, 1, 380000, 5, 10, 396550), (6, 3, 50000, 0, 10, 165000),
-- Quotation 7
(7, 100, 25000, 10, 10, 2475000), (7, 50, 15000, 10, 10, 742500), (7, 80, 20000, 10, 10, 1584000),
-- Quotation 8
(8, 5, 35000, 0, 10, 192500), (8, 5, 30000, 0, 10, 165000),
-- Quotation 9
(9, 5, 45000, 0, 10, 247500), (9, 10, 25000, 0, 10, 275000),
-- Quotation 10
(10, 20, 25000, 5, 10, 522500), (10, 15, 15000, 5, 10, 234563);

-- 14. Provider_Order (8 provider orders linked to customer orders)
INSERT INTO provider_order (customer_order_id, asigned_by, assigned_at, status) VALUES
(1, 2, '2026-05-10 10:00:00', 'Completed'),
(2, 2, '2026-05-11 11:00:00', 'Completed'),
(3, 3, '2026-05-12 15:00:00', 'In Progress'),
(6, 2, '2026-05-15 17:00:00', 'Completed'),
(7, 3, '2026-05-16 10:00:00', 'Completed'),
(8, 2, '2026-05-17 14:00:00', 'In Progress'),
(10, 3, '2026-05-19 12:00:00', 'Completed'),
(12, 3, '2026-05-20 09:00:00', 'Pending');

-- 15. Provider_Order_Detail (Items for provider orders)
INSERT INTO provider_order_detail (provider_order_id, product_id, quantity) VALUES
-- Provider Order 1
(1, 1, 10), (1, 11, 5),
-- Provider Order 2
(2, 3, 1), (2, 5, 2),
-- Provider Order 3
(3, 2, 50), (3, 10, 30), (3, 12, 40),
-- Provider Order 4
(4, 3, 2), (4, 4, 1), (4, 5, 3),
-- Provider Order 5
(5, 1, 100), (5, 7, 50), (5, 9, 80),
-- Provider Order 6
(6, 2, 5), (6, 10, 5),
-- Provider Order 7
(7, 1, 20), (7, 7, 15),
-- Provider Order 8
(8, 2, 30), (8, 9, 25), (8, 12, 30);

-- 16. Customer_Contract (10 contracts for accepted quotations)
INSERT INTO customer_contract (customer_order_id, contract_number, total_amount, status, contract_version, signed_at) VALUES
(1, 'CTR-2026-001', 375000, 'Signed', 1, '2026-05-10 14:00:00'),
(2, 'CTR-2026-002', 450000, 'Signed', 1, '2026-05-11 15:00:00'),
(3, 'CTR-2026-003', 3550000, 'Signed', 1, '2026-05-12 16:00:00'),
(6, 'CTR-2026-004', 1230000, 'Signed', 1, '2026-05-15 18:00:00'),
(7, 'CTR-2026-005', 4850000, 'Signed', 1, '2026-05-16 11:00:00'),
(8, 'CTR-2026-006', 325000, 'Signed', 1, '2026-05-17 15:00:00'),
(10, 'CTR-2026-007', 725000, 'Signed', 1, '2026-05-19 13:00:00'),
(12, 'CTR-2026-008', 2850000, 'Draft', 1, NULL),
(11, 'CTR-2026-009', 532000, 'Signed', 1, '2026-05-18 16:00:00'),
(4, 'CTR-2026-010', 1400000, 'Draft', 1, NULL);

-- 17. Provider_Contract (8 provider contracts for provider orders)
INSERT INTO provider_contract (provider_order_id, start_date, end_date, status) VALUES
(1, '2026-05-10', '2026-05-20', 'Completed'),
(2, '2026-05-11', '2026-05-21', 'Completed'),
(3, '2026-05-12', '2026-05-30', 'Active'),
(4, '2026-05-15', '2026-05-25', 'Completed'),
(5, '2026-05-16', '2026-06-05', 'Completed'),
(6, '2026-05-17', '2026-05-27', 'Active'),
(7, '2026-05-19', '2026-05-29', 'Completed'),
(8, '2026-05-20', '2026-06-10', 'Pending');

GO
