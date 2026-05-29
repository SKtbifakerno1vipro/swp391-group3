IF DB_ID('SWP_Sales_Process') IS NULL
BEGIN
    CREATE DATABASE SWP_Sales_Process;
END
GO

USE SWP_Sales_Process;
GO

-- 1. Role
CREATE TABLE role (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name NVARCHAR(100) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- 2. Permission
CREATE TABLE permission (
    permission_id INT IDENTITY(1,1) PRIMARY KEY,
    permission_name NVARCHAR(100) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- 3. Role_permission
CREATE TABLE role_permission (
    role_id INT NOT NULL,
    permission_id INT NOT NULL,
    PRIMARY KEY(role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES role(role_id),
    FOREIGN KEY (permission_id) REFERENCES permission(permission_id)
);

-- 4. User
CREATE TABLE [user] (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    user_name NVARCHAR(100) UNIQUE NOT NULL,
    password_hash NVARCHAR(255) NOT NULL,
    email NVARCHAR(255) UNIQUE NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F', 'O')),
    date_of_birth DATE,
    full_name NVARCHAR(255),
    address NVARCHAR(255),
    phone VARCHAR(20) UNIQUE,
    account_status VARCHAR(20),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    role_id INT NOT NULL,
    FOREIGN KEY (role_id) REFERENCES role(role_id)
);

-- 5. Category
CREATE TABLE category (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name NVARCHAR(255) NOT NULL
);

-- 6. Product
CREATE TABLE product (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    product_name NVARCHAR(255) NOT NULL,
    cost_price DECIMAL(18,2) CHECK (cost_price >= 0),
    selling_price DECIMAL(18,2) CHECK (selling_price >= 0),
    description NVARCHAR(MAX),
    unit NVARCHAR(50),
    product_status VARCHAR(20),
    reorder_level INT CHECK (reorder_level >= 0),
    quantity_available INT DEFAULT 0 CHECK (quantity_available >= 0),
    updated_by INT,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    category_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES category(category_id),
    FOREIGN KEY (updated_by) REFERENCES [user](user_id)
);

-- 7. Customer
CREATE TABLE customer (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    tax_code VARCHAR(20) UNIQUE,
    customer_type VARCHAR(50),
    company_name NVARCHAR(255) NOT NULL,
    user_id INT UNIQUE NOT NULL,
    assigned_to_user_id INT,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES [user](user_id),
    FOREIGN KEY (assigned_to_user_id) REFERENCES [user](user_id)
);

-- 8. Quotation
CREATE TABLE quotation (
    quotation_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    quotation_date DATETIME,
    quotation_status VARCHAR(20),
    -- NOTE: Removed total_amount to strictly satisfy 3NF
    created_by INT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (created_by) REFERENCES [user](user_id)
);

-- 9. Quotation Detail
CREATE TABLE quotation_detail (
    quotation_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    quotation_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT CHECK (quantity > 0),
    selling_price DECIMAL(18,2) CHECK (selling_price >= 0),
    discount_percent DECIMAL(5,2) CHECK (discount_percent BETWEEN 0 AND 100),
    tax_percent DECIMAL(5,2) CHECK (tax_percent BETWEEN 0 AND 100),
    -- NOTE: Removed amount to strictly satisfy 3NF
    FOREIGN KEY (quotation_id) REFERENCES quotation(quotation_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- 10. Quotation History
CREATE TABLE quotation_history (
    quotation_history_id INT IDENTITY(1,1) PRIMARY KEY,
    quotation_id INT NOT NULL,
    created_by INT,
    created_at DATETIME DEFAULT GETDATE(),
    edit_history NVARCHAR(MAX),
    FOREIGN KEY (quotation_id) REFERENCES quotation(quotation_id),
    FOREIGN KEY (created_by) REFERENCES [user](user_id)
);

-- 11. Customer Contract
CREATE TABLE customer_contract (
    customer_contract_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    quotation_id INT UNIQUE,
    contract_number NVARCHAR(100),
    contract_file_url NVARCHAR(1000),
    contract_status VARCHAR(20),
    contract_version NVARCHAR(50),
    signed_at DATETIME,
    created_by INT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (quotation_id) REFERENCES quotation(quotation_id),
    FOREIGN KEY (created_by) REFERENCES [user](user_id)
);

-- 12. Contract Edit History
CREATE TABLE contract_edit_history (
    history_id INT IDENTITY(1,1) PRIMARY KEY,
    contract_id INT NOT NULL,
    from_status VARCHAR(20),
    to_status VARCHAR(20),
    changed_by INT,
    reason NVARCHAR(MAX),
    comment NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (contract_id) REFERENCES customer_contract(customer_contract_id),
    FOREIGN KEY (changed_by) REFERENCES [user](user_id)
);

-- 13. Signature
CREATE TABLE signature (
    signature_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_contract_id INT NOT NULL,
    file_name NVARCHAR(255),
    file_url NVARCHAR(1000),
    signer_user_id INT NULL,
    signer_name NVARCHAR(255),
    signer_type VARCHAR(50),
    signed_at DATETIME,
    uploaded_by INT,
    uploaded_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (customer_contract_id) REFERENCES customer_contract(customer_contract_id),
    FOREIGN KEY (signer_user_id) REFERENCES [user](user_id),
    FOREIGN KEY (uploaded_by) REFERENCES [user](user_id)
);

-- 14. Customer Order
CREATE TABLE customer_order (
    customer_order_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    customer_contract_id INT NOT NULL,
    order_status VARCHAR(20),
    created_by INT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (customer_contract_id) REFERENCES customer_contract(customer_contract_id),
    FOREIGN KEY (created_by) REFERENCES [user](user_id)
);

-- 15. Customer Order Detail
CREATE TABLE customer_order_detail (
    customer_order_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT CHECK (quantity > 0),
    cost_price DECIMAL(18,2) CHECK (cost_price >= 0),
    selling_price DECIMAL(18,2) CHECK (selling_price >= 0),
    FOREIGN KEY (customer_order_id) REFERENCES customer_order(customer_order_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- 16. Invoice
CREATE TABLE invoice (
    invoice_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_contract_id INT NOT NULL,
    customer_order_id INT NOT NULL,
    invoice_no NVARCHAR(100) UNIQUE,
    issue_date DATETIME,
    invoice_status VARCHAR(20),
    created_by INT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (customer_contract_id) REFERENCES customer_contract(customer_contract_id),
    FOREIGN KEY (customer_order_id) REFERENCES customer_order(customer_order_id),
    FOREIGN KEY (created_by) REFERENCES [user](user_id)
);

-- 17. Payment
CREATE TABLE payment (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_contract_id INT NOT NULL,
    invoice_id INT UNIQUE,
    amount DECIMAL(18,2) CHECK (amount > 0),
    payment_type VARCHAR(50),
    payment_status VARCHAR(20),
    paid_at DATETIME,
    created_by INT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (customer_contract_id) REFERENCES customer_contract(customer_contract_id),
    FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id),
    FOREIGN KEY (created_by) REFERENCES [user](user_id)
);

-- 18. Stock Transaction
CREATE TABLE stock_transaction (
    transaction_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    transaction_date DATETIME DEFAULT GETDATE(),
    transaction_type VARCHAR(50),
    quantity_in INT DEFAULT 0 CHECK (quantity_in >= 0),
    quantity_out INT DEFAULT 0 CHECK (quantity_out >= 0),
    -- NOTE: Removed balance_after to strictly satisfy 3NF
    customer_order_id INT,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (customer_order_id) REFERENCES customer_order(customer_order_id)
);



-- 1. TẠO ROLE & PERMISSION TRƯỚC (Bảng độc lập)
INSERT INTO role (role_name) VALUES 
('Admin'), 
('Sales Executive'), 
('Customer');

INSERT INTO permission (permission_name) VALUES 
('CREATE_QUOTATION'), 
('SIGN_CONTRACT'), 
('PLACE_ORDER');

-- 2. MAP ROLE VÀO PERMISSION
INSERT INTO role_permission (role_id, permission_id) VALUES 
(1, 1), (1, 2), (1, 3), -- Admin full quyền
(2, 1), (2, 2),         -- Sales làm báo giá, hợp đồng
(3, 3);                 -- Khách đặt hàng

-- 3. TẠO USER (Cần Role_ID)
INSERT INTO [user] (user_name, password_hash, email, gender, full_name, phone, account_status, role_id) VALUES 
('admin_sys', 'hash_1', 'admin@congty.com', 'M', N'Nguyễn Quản Trị', '0900000001', 'ACTIVE', 1),
('sales_01', 'hash_2', 'sales@congty.com', 'F', N'Trần Nhân Viên', '0911111111', 'ACTIVE', 2),
('khachhang_a', 'hash_3', 'ceo@khachhang.com', 'M', N'Lê Khách Hàng', '0922222222', 'ACTIVE', 3);

-- 4. TẠO CATEGORY & PRODUCT (Cần User_ID cho cập nhật)
INSERT INTO category (category_name) VALUES 
(N'Phần mềm'), 
(N'Phần cứng');

-- Lưu ý: Đã xoá các cột không phù hợp, thêm check >= 0
INSERT INTO product (product_name, cost_price, selling_price, unit, product_status, reorder_level, quantity_available, category_id, updated_by) VALUES 
(N'Hệ thống ERP Basic', 10000000, 30000000, 'License', 'ACTIVE', 5, 50, 1, 1),
(N'Server Dell R740', 40000000, 55000000, 'Máy', 'ACTIVE', 2, 10, 2, 1);

-- Nhập kho ban đầu (Lưu lại dấu vết tạo ra 50 ERP và 10 Server)
INSERT INTO stock_transaction (product_id, transaction_type, quantity_in, quantity_out) VALUES 
(1, 'INITIAL_STOCK', 50, 0),
(2, 'INITIAL_STOCK', 10, 0);

-- 5. TẠO CUSTOMER (Cần User_ID làm tài khoản và Sales để chăm sóc)
INSERT INTO customer (tax_code, customer_type, company_name, user_id, assigned_to_user_id) VALUES 
('0312345678', 'B2B', N'Công ty Cổ phần A', 3, 2);

-- 6. TẠO QUOTATION & DETAIL (Báo giá không còn lưu total_amount hay amount)
INSERT INTO quotation (customer_id, quotation_date, quotation_status, created_by) VALUES 
(1, GETDATE(), 'APPROVED', 2);

INSERT INTO quotation_detail (quotation_id, product_id, quantity, selling_price, discount_percent, tax_percent) VALUES 
(1, 1, 1, 30000000, 0, 10),  -- 1 License ERP
(1, 2, 2, 55000000, 5, 10);  -- 2 Server, giảm giá 5%

-- 7. TẠO CUSTOMER CONTRACT (Không còn total_amount)
INSERT INTO customer_contract (customer_id, quotation_id, contract_number, contract_status, contract_version, signed_at, created_by) VALUES 
(1, 1, 'HD-2026-001', 'SIGNED', 'v1.0', GETDATE(), 2);

-- 8. LÊN ĐƠN HÀNG (CUSTOMER ORDER)
INSERT INTO customer_order (customer_id, customer_contract_id, order_status, created_by) VALUES 
(1, 1, 'PROCESSING', 2);

-- Lưu lại giá vốn / giá bán thực tế lúc chốt đơn (Bắt buộc phải có để tính lãi lỗ)
INSERT INTO customer_order_detail (customer_order_id, product_id, quantity, cost_price, selling_price) VALUES 
(1, 1, 1, 10000000, 30000000), 
(1, 2, 2, 40000000, 52250000); -- Đã trừ 5% discount từ giá 55tr

-- 9. XUẤT HÓA ĐƠN & THANH TOÁN (Không còn total_amount trong Invoice)
INSERT INTO invoice (customer_contract_id, customer_order_id, invoice_no, issue_date, invoice_status, created_by) VALUES 
(1, 1, 'INV-260001', GETDATE(), 'ISSUED', 2);

-- Thanh toán cục tiền (Giả sử thanh toán đủ 137.500.000)
INSERT INTO payment (customer_contract_id, invoice_id, amount, payment_type, payment_status, paid_at, created_by) VALUES 
(1, 1, 137500000, 'BANK_TRANSFER', 'COMPLETED', GETDATE(), 3);

-- 10. TRỪ TỒN KHO & CẬP NHẬT LẠI PRODUCT (Stock Transaction không còn balance_after)
INSERT INTO stock_transaction (product_id, transaction_type, quantity_in, quantity_out, customer_order_id) VALUES 
(1, 'SALES_ORDER', 0, 1, 1),
(2, 'SALES_ORDER', 0, 2, 1);

-- Cập nhật lại số lượng khả dụng ở bảng Product
UPDATE product SET quantity_available = quantity_available - 1 WHERE product_id = 1;
UPDATE product SET quantity_available = quantity_available - 2 WHERE product_id = 2;