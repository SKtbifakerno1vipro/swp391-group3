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
    updated_at DATETIME DEFAULT GETDATE(),
    status VARCHAR(20) DEFAULT 'Active'
);
GO

-- 2. Permission
CREATE TABLE permission (
    permission_id INT IDENTITY(1,1) PRIMARY KEY,
    permission_name NVARCHAR(100) NOT NULL,
    url_pattern NVARCHAR(255) NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);
GO

-- 3. Role_permission
CREATE TABLE role_permission (
    role_id INT NOT NULL,
    permission_id INT NOT NULL,
    PRIMARY KEY(role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES role(role_id),
    FOREIGN KEY (permission_id) REFERENCES permission(permission_id)
);
GO

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
    created_by INT NULL,
    updated_by INT NULL,
    role_id INT NOT NULL,
    FOREIGN KEY (role_id) REFERENCES role(role_id),
    FOREIGN KEY (created_by) REFERENCES [user](user_id),
    FOREIGN KEY (updated_by) REFERENCES [user](user_id)
);
GO

-- 5. Category
CREATE TABLE category (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name NVARCHAR(255) NOT NULL
);
GO

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
GO

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
GO


-- 8. Quotation
CREATE TABLE quotation (
    quotation_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    quotation_date DATETIME,
    quotation_status VARCHAR(20),
    created_by INT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (created_by) REFERENCES [user](user_id)
);
GO

-- 9. Quotation Detail
CREATE TABLE quotation_detail (
    quotation_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    quotation_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT CHECK (quantity > 0),
    selling_price DECIMAL(18,2) CHECK (selling_price >= 0),
    discount_percent DECIMAL(5,2) CHECK (discount_percent BETWEEN 0 AND 100),
    tax_percent DECIMAL(5,2) CHECK (tax_percent BETWEEN 0 AND 100),
    FOREIGN KEY (quotation_id) REFERENCES quotation(quotation_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);
GO

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
GO

-- 11. Customer Contract
CREATE TABLE customer_contract (
    customer_contract_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    quotation_id INT UNIQUE,
    contract_number NVARCHAR(100) unique,
    contract_file_url NVARCHAR(1000),
    contract_status VARCHAR(50) DEFAULT 'DRAFT',
    contract_version NVARCHAR(50) DEFAULT '1.0.0',

    effective_date DATETIME,
	end_date DATETIME,
	signed_date DATETIME,    

	contract_content NVARCHAR(MAX),
    storage_type VARCHAR(10) NOT NULL DEFAULT 'TEXT',

    created_by INT,
	updated_by INT,
    created_at DATETIME DEFAULT GETDATE(),
	updated_at DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (quotation_id) REFERENCES quotation(quotation_id),
    FOREIGN KEY (created_by) REFERENCES [user](user_id),
	FOREIGN KEY (updated_by) REFERENCES [user](user_id)
);
GO

--DRAFT
--PENDING_INTERNAL_REVIEW
--INTERNAL_REVISION
--INTERNAL_APPROVED
--SENT_TO_CUSTOMER
--CUSTOMER_REQUESTED_REVISION
--CUSTOMER_CONFIRMED
--SIGNED
--ACTIVE
--COMPLETED
--CANCELLED

-- 12. Contract Edit History
CREATE TABLE contract_edit_history (
    history_id INT IDENTITY(1,1) ,
    contract_id INT NOT NULL,
    from_status VARCHAR(50),
    to_status VARCHAR(50),
	contract_version VARCHAR(50),
	note nvarchar(max),
    changed_by INT,
    created_at DATETIME DEFAULT GETDATE(),
	PRIMARY KEY(history_id),
    FOREIGN KEY (contract_id) REFERENCES customer_contract(customer_contract_id),
    FOREIGN KEY (changed_by) REFERENCES [user](user_id)
);
GO

-- 13. Contract Revision Item
CREATE TABLE contract_revision_item (
    revision_item_id INT IDENTITY(1,1) PRIMARY KEY,
    history_id INT NOT NULL,
	contract_id INT NOT NULL,
    revision_type NVARCHAR(100) NOT NULL,
    revision_detail NVARCHAR(MAX) NOT NULL,
    FOREIGN KEY (history_id) REFERENCES contract_edit_history(history_id),
	FOREIGN KEY (contract_id) REFERENCES customer_contract(customer_contract_id)
);

-- 14. Signature
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
GO

-- 15. Customer Order
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
GO

-- 16. Customer Order Detail
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
GO

-- 17. Invoice
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
GO

-- 18. Payment
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
GO

-- 19. Stock Transaction
CREATE TABLE stock_transaction (
    transaction_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    transaction_date DATETIME DEFAULT GETDATE(),
    transaction_type VARCHAR(50),
    quantity_in INT DEFAULT 0 CHECK (quantity_in >= 0),
    quantity_out INT DEFAULT 0 CHECK (quantity_out >= 0),
    customer_order_id INT,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (customer_order_id) REFERENCES customer_order(customer_order_id)
);
GO


-- 1. TAO ROLE (GIU NGUYEN)
INSERT INTO role (role_name, status) VALUES 
(N'System Admin', 'Active'),
(N'Manager', 'Active'),
(N'Customer', 'Active'),
(N'Sale Staff', 'Active'),
(N'Admin Officer', 'Active'),
(N'Warehouse Staff', 'Active');
GO

-- 2. TAO TAI KHOAN NHAN VIEN (Pass: 123 - Ma hoa bcrypt mau)
INSERT INTO [user] (user_name, password_hash, email, gender, full_name, phone, account_status, role_id) VALUES 
('admin_01', '123', 'admin@bakery.com', 'M', N'Trần Quản Trị', '0901000001', 'ACTIVE', 1),
('manager_01', '$2a$10$wT/p0LgXn7T6mF9x7Q1UCOY5N/K2uW/1lO1hD/E8lB5vU5xV5xU5y', 'manager@bakery.com', 'F', N'Lê Quản Lý', '0901000002', 'ACTIVE', 2),
('sale_01', '$2a$10$wT/p0LgXn7T6mF9x7Q1UCOY5N/K2uW/1lO1hD/E8lB5vU5xV5xU5y', 'sale1@bakery.com', 'M', N'Nguyễn Sale Một', '0901000003', 'ACTIVE', 4),
('sale_02', '$2a$10$wT/p0LgXn7T6mF9x7Q1UCOY5N/K2uW/1lO1hD/E8lB5vU5xV5xU5y', 'sale2@bakery.com', 'F', N'Phạm Sale Hai', '0901000004', 'ACTIVE', 4),
('officer_01', '$2a$10$wT/p0LgXn7T6mF9x7Q1UCOY5N/K2uW/1lO1hD/E8lB5vU5xV5xU5y', 'officer1@bakery.com', 'F', N'Võ Chứng Từ', '0901000005', 'ACTIVE', 5),
('warehouse_01', '$2a$10$wT/p0LgXn7T6mF9x7Q1UCOY5N/K2uW/1lO1hD/E8lB5vU5xV5xU5y', 'warehouse@bakery.com', 'M', N'Đinh Thủ Kho', '0901000006', 'ACTIVE', 6);
GO

-- 3. TAO TAI KHOAN KHACH HANG
INSERT INTO [user] (user_name, password_hash, email, gender, date_of_birth, full_name, address, phone, account_status, role_id) VALUES 
('khachhang_01', '$2a$10$wT/p0LgXn7T6mF9x7Q1UCOY5N/K2uW/1lO1hD/E8lB5vU5xV5xU5y', 'khach1@gmail.com', 'M', '1990-01-01', N'Nguyễn Văn Một', N'1 Đại Cồ Việt, Hà Nội', '0981000001', 'ACTIVE', 3),
('khachhang_02', '$2a$10$wT/p0LgXn7T6mF9x7Q1UCOY5N/K2uW/1lO1hD/E8lB5vU5xV5xU5y', 'khach2@gmail.com', 'F', '1991-02-02', N'Trần Thị Hai', N'2 Lê Thanh Nghị, Hà Nội', '0981000002', 'ACTIVE', 3),
('khachhang_03', '$2a$10$wT/p0LgXn7T6mF9x7Q1UCOY5N/K2uW/1lO1hD/E8lB5vU5xV5xU5y', 'khach3@gmail.com', 'M', '1992-03-03', N'Phạm Văn Ba', N'3 Giải Phóng, Hà Nội', '0981000003', 'ACTIVE', 3);
GO

-- 4. HO SO KHACH HANG (CUSTOMER)
INSERT INTO customer (tax_code, customer_type, company_name, user_id, assigned_to_user_id) VALUES 
('0390000001', 'B2B', N'Công ty Bánh Ngọt ABC', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
('0390000002', 'B2C', N'Cửa hàng Bánh kem Thủy Tiên', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_02'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
('0390000003', 'B2B', N'Tiệm Bánh Mì Truyền Thống', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_03'), (SELECT user_id FROM [user] WHERE user_name = 'sale_02'));
GO

-- 5. DANH MUC & SAN PHAM
INSERT INTO category (category_name) VALUES (N'Bột Mì'), (N'Đường'), (N'Bơ & Phô Mai'), (N'Men & Phụ gia');
GO

INSERT INTO product (product_name, cost_price, selling_price, description, unit, product_status, reorder_level, quantity_available, updated_by, category_id) VALUES 
(N'Bột Mì Meizan', 15000, 22000, N'Bột mì đa dụng', N'Kg', 'ACTIVE', 50, 500, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 1),
(N'Đường Biên Hòa', 18000, 24000, N'Đường tinh luyện', N'Kg', 'ACTIVE', 100, 1000, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 2),
(N'Bơ Lạt Anchor', 150000, 185000, N'Bơ New Zealand', N'Khối 5kg', 'ACTIVE', 10, 50, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 3),
(N'Men Khô Mauri', 80000, 110000, N'Men làm bánh', N'Gói 500g', 'ACTIVE', 30, 200, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 4);
GO

-- 6. PHAN QUYEN (PERMISSION)
-- Permission seed is centralized below to match SecurityFilter url_pattern.

-- 7. QUY TRINH HOP ĐONG 01: KHACH HANG 01 (LAM TRON BO TOI THANH TOAN)
-- Bao gia
INSERT INTO quotation (customer_id, quotation_date, quotation_status, created_by) VALUES (1, DATEADD(DAY, -20, GETDATE()), 'ACCEPTED', (SELECT user_id FROM [user] WHERE user_name = 'sale_01'));
DECLARE @Q1 INT = SCOPE_IDENTITY();
INSERT INTO quotation_detail (quotation_id, product_id, quantity, selling_price, discount_percent, tax_percent) VALUES (@Q1, 1, 100, 22000, 5, 10);
INSERT INTO quotation_history (quotation_id, created_by, edit_history) VALUES (@Q1, (SELECT user_id FROM [user] WHERE user_name = 'sale_01'), N'Tạo báo giá và khách đã duyệt.');

-- Hop đong (Trang thai SIGNED -> ACTIVE)
INSERT INTO customer_contract (customer_id, quotation_id, contract_number, contract_file_url, contract_status, contract_version, created_by) VALUES 
(1, @Q1, 'HD-2026-001', '/uploads/HD-001.pdf', 'SIGNED', '1.0.0', (SELECT user_id FROM [user] WHERE user_name = 'officer_01'));
DECLARE @C1 INT = SCOPE_IDENTITY();

-- Lich su hop đong C1
INSERT INTO contract_edit_history (contract_id, from_status, to_status, contract_version, changed_by) VALUES 
(@C1, NULL, 'DRAFT', '1.0.0', (SELECT user_id FROM [user] WHERE user_name = 'officer_01')),
(@C1, 'DRAFT', 'PENDING_INTERNAL_REVIEW', '1.0.0', (SELECT user_id FROM [user] WHERE user_name = 'officer_01')),
(@C1, 'PENDING_INTERNAL_REVIEW', 'INTERNAL_APPROVED', '1.0.0', (SELECT user_id FROM [user] WHERE user_name = 'manager_01')),
(@C1, 'INTERNAL_APPROVED', 'SENT_TO_CUSTOMER', '1.0.0', (SELECT user_id FROM [user] WHERE user_name = 'officer_01')),
(@C1, 'SENT_TO_CUSTOMER', 'SIGNED', '1.0.0', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'));

-- Chu ky
INSERT INTO signature (customer_contract_id, file_name, file_url, signer_user_id, signer_name, signer_type, signed_at, uploaded_by) VALUES 
(@C1, 'sign_kh.png', '/sig/kh.png', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'), N'Nguyễn Văn Một', 'CUSTOMER', GETDATE(), (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'));

-- Đon hang & Thanh toan
INSERT INTO customer_order (customer_id, customer_contract_id, order_status, created_by) VALUES (1, @C1, 'DELIVERED', (SELECT user_id FROM [user] WHERE user_name = 'officer_01'));
DECLARE @O1 INT = SCOPE_IDENTITY();
INSERT INTO customer_order_detail (customer_order_id, product_id, quantity, cost_price, selling_price) VALUES (@O1, 1, 100, 15000, 22000);
INSERT INTO invoice (customer_contract_id, customer_order_id, invoice_no, issue_date, invoice_status, created_by) VALUES (@C1, @O1, 'INV-001', GETDATE(), 'PAID', (SELECT user_id FROM [user] WHERE user_name = 'officer_01'));
INSERT INTO payment (customer_contract_id, invoice_id, amount, payment_type, payment_status, paid_at, created_by) VALUES (@C1, SCOPE_IDENTITY(), 2200000, 'BANK_TRANSFER', 'COMPLETED', GETDATE(), (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'));
GO

-- 8. QUY TRINH HOP ĐONG 02: KHACH HANG 02 (ĐANG TRANG THAI KHACH YEU CAU SUA - REVISION)
INSERT INTO quotation (customer_id, quotation_date, quotation_status, created_by) VALUES (2, DATEADD(DAY, -5, GETDATE()), 'ACCEPTED', (SELECT user_id FROM [user] WHERE user_name = 'sale_01'));
DECLARE @Q2 INT = SCOPE_IDENTITY();
INSERT INTO customer_contract (customer_id, quotation_id, contract_number, contract_file_url, contract_status, contract_version, created_by) VALUES 
(2, @Q2, 'HD-2026-002', '/uploads/HD-002.pdf', 'CUSTOMER_REQUESTED_REVISION', '1.0.0', (SELECT user_id FROM [user] WHERE user_name = 'officer_01'));
DECLARE @C2 INT = SCOPE_IDENTITY();

-- Ghi lich su yeu cau sua
INSERT INTO contract_edit_history (contract_id, from_status, to_status, contract_version, changed_by) VALUES 
(@C2, 'SENT_TO_CUSTOMER', 'CUSTOMER_REQUESTED_REVISION', '1.0.0', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_02'));
DECLARE @H2 INT = SCOPE_IDENTITY();
INSERT INTO contract_revision_item (history_id, contract_id, revision_type, revision_detail) VALUES 
(@H2, @C2, N'Địa chỉ', N'Đổi địa chỉ giao sang Kho số 2 quận Tân Bình'),
(@H2, @C2, N'Thanh toán', N'Muốn thanh toán 100% sau khi nhận hàng thay vì đặt cọc');
GO

-- 9. KHO (GIAO DICH NHAP KHO BAN ĐAU)
INSERT INTO stock_transaction (product_id, transaction_type, quantity_in, quantity_out, transaction_date) VALUES 
(1, 'INITIAL_STOCK', 500, 0, GETDATE()),
(2, 'INITIAL_STOCK', 1000, 0, GETDATE());
GO

-- 10. DONG BO PERMISSION CHO SECURITY FILTER
-- Danh sach nay phai khop voi cac @WebServlet hien co trong src/java/controller.
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('permission') AND name = 'url_pattern')
BEGIN
    ALTER TABLE permission ADD url_pattern NVARCHAR(255) NULL;
END
GO

DELETE FROM role_permission;
DELETE FROM permission;
DBCC CHECKIDENT ('permission', RESEED, 0);
GO

INSERT INTO permission (permission_name, url_pattern) VALUES
('View Dashboard', '/dashboard'),
('View User List', '/user-list'),
('View User Detail', '/user-detail'),
('Create User', '/create-user'),
('Edit User', '/edit-user'),
('View Role List', '/role-list'),
('View Role Detail', '/role-detail'),
('Add Role', '/add-role'),
('Edit Role Permissions', '/edit-role-permissions'),
('View Category List', '/category/list'),
('Create Category', '/category/create'),
('Edit Category', '/category/edit'),
('Delete Category', '/category/delete'),
('View Product List', '/product-list'),
('Create Product', '/create-product'),
('Edit Product', '/edit-product'),
('Delete Product', '/product-delete'),
('View Customer List', '/customer/list'),
('View Customer Detail', '/customer/detail'),
('Create Customer', '/customer/create'),
('Edit Customer', '/customer/edit'),
('View Quotation List', '/quotation-list'),
('View Contract List', '/contract-list'),
('Save Contract', '/contract-save'),
('View Order List', '/customer-order-list'),
('View Order Detail', '/customer-order-detail'),
('Create Order', '/create-customer-order'),
('Issue Invoice', '/Invoice');
GO
INSERT INTO permission (permission_name, url_pattern)
VALUES ('Create Quotation', '/quotation-create');

-- Admin/System Admin mac dinh co toan quyen de team vua dung DB la dang nhap dung duoc ngay.
INSERT INTO role_permission (role_id, permission_id)
SELECT 1, permission_id
FROM permission
WHERE url_pattern = '/quotation-create';

-- ==========================================================
-- PHAN DU LIEU MOI TU MAIN
-- ==========================================================
USE SWP_Sales_Process;
GO

-- ==========================================================
-- BUOC ĐEM: CHEN THEM DU LIEU ĐE TRANH LOI KHOA NGOAI (FOREIGN KEY)
-- ==========================================================

-- 1. Them 2 tai khoan User cho khach hang 4 va 5
INSERT INTO [user] (user_name, password_hash, email, gender, date_of_birth, full_name, address, phone, account_status, role_id) VALUES 
('khachhang_04', '$2a$10$wT/p0LgXn7T6mF9x7Q1UCOY5N/K2uW/1lO1hD/E8lB5vU5xV5xU5y', 'khach4@gmail.com', 'F', '1993-04-04', N'Hoàng Thị Bốn', N'4 Trần Đại Nghĩa, Hà Nội', '0981000004', 'ACTIVE', 3),
('khachhang_05', '$2a$10$wT/p0LgXn7T6mF9x7Q1UCOY5N/K2uW/1lO1hD/E8lB5vU5xV5xU5y', 'khach5@gmail.com', 'M', '1994-05-05', N'Vũ Văn Năm', N'5 Chùa Bộc, Hà Nội', '0981000005', 'ACTIVE', 3);

-- 2. Them ho so cho Customer 4 va 5 (Bay gio he thong se co đu customer_id tu 1 đen 5)
INSERT INTO customer (tax_code, customer_type, company_name, user_id, assigned_to_user_id) VALUES 
('0390000004', 'B2C', N'Tiệm Bánh Ngọt Homie', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_04'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
('0390000005', 'B2B', N'Nhà Hàng Tiệc Cưới Golden', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_05'), (SELECT user_id FROM [user] WHERE user_name = 'sale_02'));

-- 3. Them 1 san pham mau ID = 5 đe khop voi customer_order_detail
INSERT INTO product (product_name, cost_price, selling_price, description, unit, product_status, reorder_level, quantity_available, updated_by, category_id) VALUES 
(N'Hộp Phô Mai Tươi', 25000, 38000, N'Phô mai tươi làm bánh kem', N'Hộp', 'ACTIVE', 20, 150, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 3);

-- 4. Them 3 bao gia bo sung cho khop quy trinh tao hop đong
INSERT INTO quotation (customer_id, quotation_date, quotation_status, created_by) VALUES 
(3, GETDATE(), 'ACCEPTED', (SELECT user_id FROM [user] WHERE user_name = 'sale_02')),
(4, GETDATE(), 'ACCEPTED', (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
(5, GETDATE(), 'ACCEPTED', (SELECT user_id FROM [user] WHERE user_name = 'sale_02'));

-- 5. Them 3 hop đong mau (Đe he thong co đu customer_contract_id tu 1 đen 5)
INSERT INTO customer_contract (customer_id, quotation_id, contract_number, contract_file_url, contract_status, contract_version, created_by) VALUES 
(3, 3, 'HD-2026-003', '/uploads/HD-003.pdf', 'ACTIVE', '1.0.0', (SELECT user_id FROM [user] WHERE user_name = 'officer_01')),
(4, 4, 'HD-2026-004', '/uploads/HD-004.pdf', 'ACTIVE', '1.0.0', (SELECT user_id FROM [user] WHERE user_name = 'officer_01')),
(5, 5, 'HD-2026-005', '/uploads/HD-005.pdf', 'ACTIVE', '1.0.0', (SELECT user_id FROM [user] WHERE user_name = 'officer_01'));
GO


USE SWP_Sales_Process;
GO

-- Xoa du lieu rac cu neu co trong 2 bang nay đe lam sach
DELETE FROM customer_order_detail;
DELETE FROM customer_order;
GO

-- ==========================================================
-- SU DUNG VONG LAP ĐE CHEN ĐONG 30 ĐON HANG KHONG LO LOI ID
-- ==========================================================
DECLARE @Loop INT = 1;
DECLARE @RandomCustomerID INT;
DECLARE @RandomContractID INT;
DECLARE @RandomUserID INT;
DECLARE @RandomProductID INT;
DECLARE @NewOrderID INT;
DECLARE @Status VARCHAR(20);

WHILE @Loop <= 30
BEGIN
    -- 1. Lay ngau nhien 1 customer_id va customer_contract_id thuoc ve customer đo
    SELECT TOP 1 @RandomCustomerID = customer_id 
    FROM customer ORDER BY NEWID();

    -- Tim hop đong cua khach hang đo, neu khach chua co hop đong thi lay đai 1 hop đong bat ky co san
    SELECT TOP 1 @RandomContractID = customer_contract_id 
    FROM customer_contract 
    WHERE customer_id = @RandomCustomerID;

    IF @RandomContractID IS NULL
    BEGIN
        SELECT TOP 1 @RandomContractID = customer_contract_id FROM customer_contract ORDER BY NEWID();
    END

    -- 2. Lay ngau nhien 1 nhan vien tao đon (Role Admin/Manager/Sale...)
    SELECT TOP 1 @RandomUserID = user_id FROM [user] WHERE role_id IN (1, 2, 4, 5) ORDER BY NEWID();

    -- 3. Gan trang thai ngau nhien
    SET @Status = CASE WHEN @Loop % 4 = 0 THEN 'Completed'
                       WHEN @Loop % 4 = 1 THEN 'Processing'
                       WHEN @Loop % 4 = 2 THEN 'Pending'
                       ELSE 'Cancelled' END;

    -- 4. Chen vao bang customer_order
    INSERT INTO customer_order (customer_id, customer_contract_id, order_status, created_by, created_at)
    VALUES (
        @RandomCustomerID, 
        @RandomContractID, 
        @Status, 
        @RandomUserID, 
        DATEADD(MINUTE, -@Loop * 30, GETDATE())
    );

    -- Lay ID cua đon hang vua chen đe dung cho bang chi tiet
    SET @NewOrderID = SCOPE_IDENTITY();

    -- 5. Chen tu 1 đen 2 san pham chi tiet cho đon hang nay
    DECLARE @ProdLoop INT = 1;
    DECLARE @NumOfProducts INT = CASE WHEN @Loop % 3 = 0 THEN 2 ELSE 1 END;

    WHILE @ProdLoop <= @NumOfProducts
    BEGIN
        -- Lay ngau nhien 1 san pham thuc te đang co trong bang product
        SELECT TOP 1 
            @RandomProductID = product_id,
            @RandomUserID = updated_by -- Tạm mượn biến để đỡ tạo nhiều, thực tế lấy cost/selling price
        FROM product 
        WHERE product_id NOT IN (
            -- Tranh trung san pham trong cung 1 đon hang
            SELECT product_id FROM customer_order_detail WHERE customer_order_id = @NewOrderID
        )
        ORDER BY NEWID();

        -- Neu tim thay san pham hop le thi chen vao chi tiet
        IF @RandomProductID IS NOT NULL
        BEGIN
            INSERT INTO customer_order_detail (customer_order_id, product_id, quantity, cost_price, selling_price)
            SELECT 
                @NewOrderID, 
                product_id, 
                (CASE WHEN @Loop % 2 = 0 THEN 2 ELSE 5 END), -- Số lượng ngẫu nhiên 2 hoặc 5
                cost_price, 
                selling_price
            FROM product 
            WHERE product_id = @RandomProductID;
        END

        SET @ProdLoop = @ProdLoop + 1;
    END

    SET @Loop = @Loop + 1;
END;
GO

-- Kiem tra lai xem đa đu 30 dong chua
SELECT 'Tổng số đơn hàng' AS [Bảng], COUNT(*) AS [Số lượng] FROM customer_order
UNION ALL
SELECT 'Tổng số chi tiết đơn' AS [Bảng], COUNT(*) AS [Số lượng] FROM customer_order_detail;
GO

select * from [user]
select * from [Customer]
UPDATE customer
SET customer_type = 'LOYAL CUSTOMER'
WHERE customer_type = 'B2B';
GO

USE SWP_Sales_Process;
GO
