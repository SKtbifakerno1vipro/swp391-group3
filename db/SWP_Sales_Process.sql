IF DB_ID('SWP_Sales_Process') IS NULL
BEGIN
    CREATE DATABASE SWP_Sales_Process;
END
GO

USE SWP_Sales_Process;
GO

--USE SWP_Sales_Process;
--GO

CREATE TABLE email_log (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    recipient NVARCHAR(255) NOT NULL,
    subject NVARCHAR(255) NOT NULL,
    content NVARCHAR(MAX) NOT NULL,
    sent_at DATETIME DEFAULT GETDATE(),
    status VARCHAR(20) NOT NULL
);


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

-- 4b. System Audit Log
CREATE TABLE system_audit_log (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NULL,
    action_type NVARCHAR(255) NOT NULL,
    affected_object NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX) NULL,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES [user](user_id)
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
	quantity_reserve INT DEFAULT 0 CHECK (quantity_reserve >= 0), --them cai nay cho hop logic
    updated_by INT,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    category_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES category(category_id),
    FOREIGN KEY (updated_by) REFERENCES [user](user_id)
);
GO

-- 6b. Import Request
IF OBJECT_ID('dbo.import_request', 'U') IS NOT NULL
    DROP TABLE dbo.import_request;
GO

CREATE TABLE import_request (
    import_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    status INT NOT NULL CHECK (status IN (1, 2, 3)), -- 1: Pending, 2: Imported, 3: Cancelled
    created_by INT NOT NULL,
    created_date DATETIME NOT NULL DEFAULT GETDATE(),
    imported_by INT NULL,
    imported_date DATETIME NULL,
    note NVARCHAR(MAX) NULL,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (created_by) REFERENCES [user](user_id),
    FOREIGN KEY (imported_by) REFERENCES [user](user_id)
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
-- 8. Quotation
CREATE TABLE quotation (
    quotation_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    quotation_date DATETIME,
    quotation_status VARCHAR(20),
	--DRAFT
--PENDING
--ACCEPTED
--REJECTED
    created_by INT,
    created_at DATETIME DEFAULT GETDATE(),
    total_price DECIMAL(18,2) DEFAULT 0.00,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (created_by) REFERENCES [user](user_id)
);
GO

-- 9. Quotation Detail
CREATE TABLE quotation_detail (
    quotation_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    quotation_id INT NOT NULL,
    product_id INT NOT NULL,
    product_name NVARCHAR(255) NULL,                       -- Added to store frozen product name
    unit NVARCHAR(50) NULL,                                -- Added to store frozen unit
    quantity INT CHECK (quantity > 0),
	cost_price DECIMAL(18,2) CHECK (cost_price >= 0),-- Added to store frozen 
    selling_price DECIMAL(18,2) CHECK (selling_price >= 0),-- Added to store frozen 
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

    effective_date DATETIME,
	end_date DATETIME,
	signed_date DATETIME,    

	contract_content nvarchar(max),
    storage_type VARCHAR(10) NOT NULL DEFAULT 'TEXT',
    token VARCHAR(255),
    token_expired_at DATETIME,

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
--PENDING_REVIEW
--CUSTOMER_CHECK
--APPROVED
--SIGNED

-- 12. Contract Edit History
CREATE TABLE contract_edit_history (
    history_id INT IDENTITY(1,1) ,
    contract_id INT NOT NULL,
    from_status VARCHAR(50),
    to_status VARCHAR(50),
	edit_status varchar(50),
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
    customer_contract_id INT,
	invoice_id int,
    file_name NVARCHAR(255),
    file_url NVARCHAR(1000),
    signer_user_id INT NULL,
    signer_name NVARCHAR(255),
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
	
--PENDING
--SHIPPING
--COMPLETED
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
    quotation_detail_id INT NOT NULL,                      -- Replaced product_id with quotation_detail_id
    quantity INT CHECK (quantity > 0),
    cost_price DECIMAL(18,2) CHECK (cost_price >= 0),
    selling_price DECIMAL(18,2) CHECK (selling_price >= 0),
    FOREIGN KEY (customer_order_id) REFERENCES customer_order(customer_order_id),
    FOREIGN KEY (quotation_detail_id) REFERENCES quotation_detail(quotation_detail_id)
);
GO

-- 17. Invoice
create TABLE invoice (
    invoice_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_contract_id INT NOT NULL,
    customer_order_id INT NOT NULL,
    invoice_no NVARCHAR(100),
    issue_date DATETIME,
    invoice_status VARCHAR(50),
--UNRELEASED
--READY
--RELEASED
--CANCELED
    invoice_type VARCHAR(20) NOT NULL DEFAULT 'SALES',      -- 'VAT' or 'SALES'
    invoice_symbol VARCHAR(20) NOT NULL DEFAULT 'K26TYY',     -- E-invoice code without tax code
    
    -- Seller info snapshot
    seller_name NVARCHAR(255) NULL,
    seller_tax_code VARCHAR(20) NULL,
    seller_address NVARCHAR(255) NULL,
	seller_phone VARCHAR(20) NULL,
    
    -- Buyer info snapshot
    buyer_name NVARCHAR(255) NULL,
    buyer_tax_code VARCHAR(20) NULL,
    buyer_address NVARCHAR(255) NULL,
    buyer_phone VARCHAR(20) NULL,

    -- Financial summary snapshot
    total_amount DECIMAL(18,2) DEFAULT 0,
    
	--Note
	customer_note NVARCHAR(max) NULL,
	internal_note NVARCHAR(max) NULL,

    created_by INT,
    created_at DATETIME DEFAULT GETDATE(),
	updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (customer_contract_id) REFERENCES customer_contract(customer_contract_id),
    FOREIGN KEY (customer_order_id) REFERENCES customer_order(customer_order_id),
    FOREIGN KEY (created_by) REFERENCES [user](user_id)
);
GO

-- 18. Payment
CREATE TABLE payment (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_contract_id INT NOT NULL,
    invoice_id INT,
    amount DECIMAL(18,2) CHECK (amount > 0),
    payment_type VARCHAR(50),
    payment_status VARCHAR(20),
    paid_at DATETIME2(6),
    created_by INT,
    created_at DATETIME2(6) DEFAULT SYSDATETIME(),
    FOREIGN KEY (customer_contract_id) REFERENCES customer_contract(customer_contract_id),
    FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id),
    FOREIGN KEY (created_by) REFERENCES [user](user_id)
);
GO

CREATE UNIQUE NONCLUSTERED INDEX UX_payment_invoice_id 
ON payment(invoice_id) 
WHERE invoice_id IS NOT NULL;
GO

-- 19. Product Review
CREATE TABLE product_review (
    review_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,                  -- FK liên kết bảng product
    user_id INT NOT NULL,                     -- FK liên kết bảng user (người đánh giá)
    rating INT CHECK (rating BETWEEN 1 AND 5),-- Số sao đánh giá từ 1 đến 5
    comment NVARCHAR(1000) NULL,              -- Nội dung đánh giá
    created_at DATETIME DEFAULT GETDATE(),    -- Thời gian đánh giá
    reply_content NVARCHAR(1000) NULL,        -- Nội dung phản hồi của nhân viên
    replied_by INT NULL,                      -- FK liên kết bảng user (nhân viên phản hồi)
    replied_at DATETIME NULL,                 -- Thời gian phản hồi
    status VARCHAR(20) DEFAULT 'ACTIVE',      -- Trạng thái: ACTIVE, HIDDEN, INACTIVE
	FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (user_id) REFERENCES [user](user_id),
    FOREIGN KEY (replied_by) REFERENCES [user](user_id)
);


-- 1. TAO ROLE
INSERT INTO role (role_name, status) VALUES 
(N'System Admin', 'Active'),
(N'Manager', 'Active'),
(N'Customer', 'Active'),
(N'Sale Staff', 'Active'),
(N'Admin Officer', 'Active'),
(N'Warehouse Staff', 'Active');
GO

-- 2. TAO TAI KHOAN NHAN VIEN
INSERT INTO [user] (user_name, password_hash, email, gender, full_name, phone, account_status, role_id, created_by, updated_by) VALUES 
('admin_01', '123', 'admin@bakery.com', 'M', N'Trần Quản Trị', '0901000001', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'System Admin'), 1, 1),
('manager_01', '1234', 'manager@bakery.com', 'F', N'Lê Quản Lý', '0901000002', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Manager'), 1, 1),
('sale_01', '1234', 'sale1@bakery.com', 'M', N'Nguyễn Sale Một', '0901000003', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Sale Staff'), 1, 1),
('sale_02', '1234', 'sale2@bakery.com', 'F', N'Phạm Sale Hai', '0901000004', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Sale Staff'), 1, 1),
('officer_01', '1234', 'officer1@bakery.com', 'F', N'Võ Chứng Từ', '0901000005', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Admin Officer'), 1, 1),
('warehouse_01', '1234', 'warehouse@bakery.com', 'M', N'Đinh Thủ Kho', '0901000006', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Warehouse Staff'), 1, 1);
GO

-- 3. TAO TAI KHOAN KHACH HANG
INSERT INTO [user] (user_name, password_hash, email, gender, date_of_birth, full_name, address, phone, account_status, role_id, created_by, updated_by) VALUES 
('khachhang_01', '1234', 'khach1@gmail.com', 'M', '1990-01-01', N'Nguyễn Văn Một', N'1 Đại Cồ Việt, Hà Nội', '0981000001', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Customer'), 1, 1),
('khachhang_02', '1234', 'khach2@gmail.com', 'F', '1991-02-02', N'Trần Thị Hai', N'2 Lê Thanh Nghị, Hà Nội', '0981000002', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Customer'), 1, 1),
('khachhang_03', '1234', 'khach3@gmail.com', 'M', '1992-03-03', N'Phạm Văn Ba', N'3 Giải Phóng, Hà Nội', '0981000003', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Customer'), 1, 1);
GO

-- 4. HO SO KHACH HANG (CUSTOMER)
INSERT INTO customer (tax_code, customer_type, company_name, user_id, assigned_to_user_id) VALUES 
('0390000001', 'CUSTOMER', N'Công ty Bánh Ngọt ABC', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
('0390000002', 'CUSTOMER', N'Cửa hàng Bánh kem Thủy Tiên', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_02'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
('0390000003', 'CUSTOMER', N'Tiệm Bánh Mì Truyền Thống', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_03'), (SELECT user_id FROM [user] WHERE user_name = 'sale_02'));
GO

-- 5. DANH MUC & SAN PHAM
INSERT INTO category (category_name) VALUES (N'Bột Mì'), (N'Đường'), (N'Bơ & Phô Mai'), (N'Men & Phụ gia');
GO

INSERT INTO product (product_name, cost_price, selling_price, description, unit, product_status, reorder_level, quantity_available, updated_by, category_id) VALUES 
(N'Bột Mì Meizan', 15000, 22000, N'Bột mì đa dụng', N'Kg', 'ACTIVE', 50, 500, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), (SELECT category_id FROM category WHERE category_name = N'Bột Mì')),
(N'Đường Biên Hòa', 18000, 24000, N'Đường tinh luyện', N'Kg', 'ACTIVE', 100, 1000, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), (SELECT category_id FROM category WHERE category_name = N'Đường')),
(N'Bơ Lạt Anchor', 150000, 185000, N'Bơ New Zealand', N'Khối 5kg', 'ACTIVE', 10, 50, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), (SELECT category_id FROM category WHERE category_name = N'Bơ & Phô Mai')),
(N'Men Khô Mauri', 80000, 110000, N'Men làm bánh', N'Gói 500g', 'ACTIVE', 30, 200, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), (SELECT category_id FROM category WHERE category_name = N'Men & Phụ gia'));
GO

-- 6. PHAN QUYEN (PERMISSION)
INSERT INTO permission (permission_name) VALUES
(N'Dashboard'),
(N'Role List'),
(N'Edit Role Permission'),
(N'User List'),
(N'User Create'),
(N'Profile'),
(N'User Edit'),
(N'Customer List'),
(N'Customer Create'),
(N'Customer Detail'),
(N'Order List'),
(N'Order Create'),
(N'Order Detail'),
(N'Category List'),
(N'Category edit'),
(N'Product List'),
(N'Product Create'),
(N'Product Detail'),
(N'Product Review'),
(N'Quotation List'),
(N'Create Quotation'),
(N'Quotation Detail'),
(N'Contract List'),
(N'Contract Create'),
(N'Contract Detail(Edit)'),
(N'Invoice List'),
(N'Invoice Create'),
(N'Invoice Detail'),
(N'Preview Invoice'),
(N'Payment List'),
(N'Payment Detail'),
(N'Email Logs'),
(N'System Audit Logs'),
(N'Revenue Report'),
(N'Acceptance Record'),
(N'Product Review'),
(N'Warehouse Dashboard'),
(N'Customer Edit'),
(N'Signature Contract'),
(N'Import Request List'),
(N'Import Request Create'),
(N'Import Request Detail');
GO

-- 7. QUY TRINH HOP DONG 01: KHACH HANG 01 (LAM TRON BO TOI THANH TOAN)
-- Bao gia
INSERT INTO quotation (customer_id, quotation_date, quotation_status, created_by) VALUES (
    (SELECT customer_id FROM customer WHERE tax_code = '0390000001'), 
    DATEADD(DAY, -20, GETDATE()), 
    'ACCEPTED', 
    (SELECT user_id FROM [user] WHERE user_name = 'sale_01')
);
DECLARE @Q1 INT = SCOPE_IDENTITY();
DECLARE @QD1 INT;
INSERT INTO quotation_detail (quotation_id, product_id, product_name, unit, quantity, cost_price, selling_price, discount_percent, tax_percent) VALUES (
    @Q1, 
    (SELECT product_id FROM product WHERE product_name = N'Bột Mì Meizan'), 
    N'Bột Mì Meizan', 
    N'Kg', 
    100, 
    15000, 
    22000, 
    5, 
    10
);
SET @QD1 = SCOPE_IDENTITY();
INSERT INTO quotation_history (quotation_id, created_by, edit_history) VALUES (@Q1, (SELECT user_id FROM [user] WHERE user_name = 'sale_01'), N'Tạo báo giá và khách đã duyệt.');

GO

-- 8. QUY TRINH HOP DONG 02: KHACH HANG 02 (ĐANG TRANG THAI KHACH YEU CAU SUA - REVISION)
INSERT INTO quotation (customer_id, quotation_date, quotation_status, created_by) VALUES (
    (SELECT customer_id FROM customer WHERE tax_code = '0390000002'), 
    DATEADD(DAY, -5, GETDATE()), 
    'ACCEPTED', 
    (SELECT user_id FROM [user] WHERE user_name = 'sale_01')
);
DECLARE @Q2 INT = SCOPE_IDENTITY();
DECLARE @QD2 INT;
INSERT INTO quotation_detail (quotation_id, product_id, product_name, unit, quantity, cost_price, selling_price, discount_percent, tax_percent) VALUES (
    @Q2, 
    (SELECT product_id FROM product WHERE product_name = N'Đường Biên Hòa'), 
    N'Đường Biên Hòa', 
    N'Kg', 
    50, 
    18000, 
    24000, 
    0, 
    10
);
SET @QD2 = SCOPE_IDENTITY();
INSERT INTO customer_contract (customer_id, quotation_id, contract_number, contract_file_url, contract_status, created_by) VALUES (
    (SELECT customer_id FROM customer WHERE tax_code = '0390000002'), 
    @Q2, 
    'HD-2026-002', 
    '/uploads/HD-002.pdf', 
    'CUSTOMER_CHECK', 
    (SELECT user_id FROM [user] WHERE user_name = 'officer_01')
);
DECLARE @C2 INT = SCOPE_IDENTITY();

-- Ghi lich su yeu cau sua
INSERT INTO contract_edit_history (contract_id, from_status, to_status, changed_by) VALUES 
(@C2, 'PENDING_REVIEW', 'CUSTOMER_CHECK', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_02'));
DECLARE @H2 INT = SCOPE_IDENTITY();
INSERT INTO contract_revision_item (history_id, contract_id, revision_type, revision_detail) VALUES 
(@H2, @C2, N'Địa chỉ', N'Đổi địa chỉ giao sang Kho số 2 quận Tân Bình'),
(@H2, @C2, N'Thanh toán', N'Muốn thanh toán 100% sau khi nhận hàng thay vì đặt cọc');
GO




-- ==========================================================
-- PHAN DU LIEU MOI TU MAIN
-- ==========================================================
USE SWP_Sales_Process;
GO

-- ==========================================================
-- BUOC DEM: CHEN THEM DU LIEU DE TRANH LOI KHOA NGOAI (FOREIGN KEY)
-- ==========================================================

-- 1. Them 2 tai khoan User cho khach hang 4 va 5
INSERT INTO [user] (user_name, password_hash, email, gender, date_of_birth, full_name, address, phone, account_status, role_id) VALUES 
('khachhang_04', '1234', 'khach4@gmail.com', 'F', '1993-04-04', N'Hoàng Thị Bốn', N'4 Trần Đại Nghĩa, Hà Nội', '0981000004', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Customer')),
('khachhang_05', '1234', 'khach5@gmail.com', 'M', '1994-05-05', N'Vũ Văn Năm', N'5 Chùa Bộc, Hà Nội', '0981000005', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Customer'));

-- 2. Them ho so cho Customer 4 va 5 (Bay gio he thong se co du customer_id tu 1 den 5)
INSERT INTO customer (tax_code, customer_type, company_name, user_id, assigned_to_user_id) VALUES 
('0390000004', 'LOYAL CUSTOMER', N'Tiệm Bánh Ngọt Homie', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_04'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
('0390000005', 'LOYAL CUSTOMER', N'Nhà Hàng Tiệc Cưới Golden', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_05'), (SELECT user_id FROM [user] WHERE user_name = 'sale_02'));

-- 3. Them 1 san pham mau de khop voi customer_order_detail
INSERT INTO product (product_name, cost_price, selling_price, description, unit, product_status, reorder_level, quantity_available, updated_by, category_id) VALUES 
(N'Hộp Phô Mai Tươi', 25000, 38000, N'Phô mai tươi làm bánh kem', N'Hộp', 'ACTIVE', 20, 150, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), (SELECT category_id FROM category WHERE category_name = N'Bơ & Phô Mai'));

-- 4. Them 3 bao gia bo sung cho khop quy trinh tao hop dong
INSERT INTO quotation (customer_id, quotation_date, quotation_status, created_by) VALUES (
    (SELECT customer_id FROM customer WHERE tax_code = '0390000003'), 
    GETDATE(), 
    'ACCEPTED', 
    (SELECT user_id FROM [user] WHERE user_name = 'sale_02')
);
DECLARE @Q3 INT = SCOPE_IDENTITY();
INSERT INTO quotation_detail (quotation_id, product_id, product_name, unit, quantity, cost_price, selling_price, discount_percent, tax_percent) VALUES (
    @Q3, 
    (SELECT product_id FROM product WHERE product_name = N'Bơ Lạt Anchor'), 
    N'Bơ Lạt Anchor', 
    N'Khối 5kg', 
    10, 
    150000, 
    185000, 
    2, 
    10
);

INSERT INTO quotation (customer_id, quotation_date, quotation_status, created_by) VALUES (
    (SELECT customer_id FROM customer WHERE tax_code = '0390000004'), 
    GETDATE(), 
    'ACCEPTED', 
    (SELECT user_id FROM [user] WHERE user_name = 'sale_01')
);
DECLARE @Q4 INT = SCOPE_IDENTITY();
INSERT INTO quotation_detail (quotation_id, product_id, product_name, unit, quantity, cost_price, selling_price, discount_percent, tax_percent) VALUES (
    @Q4, 
    (SELECT product_id FROM product WHERE product_name = N'Men Khô Mauri'), 
    N'Men Khô Mauri', 
    N'Gói 500g', 
    20, 
    80000, 
    110000, 
    0, 
    10
);

INSERT INTO quotation (customer_id, quotation_date, quotation_status, created_by) VALUES (
    (SELECT customer_id FROM customer WHERE tax_code = '0390000005'), 
    GETDATE(), 
    'ACCEPTED', 
    (SELECT user_id FROM [user] WHERE user_name = 'sale_02')
);
DECLARE @Q5 INT = SCOPE_IDENTITY();
INSERT INTO quotation_detail (quotation_id, product_id, product_name, unit, quantity, cost_price, selling_price, discount_percent, tax_percent) VALUES (
    @Q5, 
    (SELECT product_id FROM product WHERE product_name = N'Hộp Phô Mai Tươi'), 
    N'Hộp Phô Mai Tươi', 
    N'Hộp', 
    15, 
    25000, 
    38000, 
    5, 
    10
);

GO


USE SWP_Sales_Process;
GO

-- ==========================================================
GO



select * from [customer_order]
select * from [user]
select * from [Customer]
select * from [role]
UPDATE customer
SET customer_type = 'LOYAL CUSTOMER'
WHERE customer_type = 'B2B';
GO

-- ==========================================================
-- GÁN QUYỀN MẶC ĐỊNH CHO CÁC ROLE BAN ĐẦU
-- ==========================================================
USE SWP_Sales_Process;
GO
select * from role_permission
-- 1. System Admin (role_id = 1)
INSERT INTO role_permission (role_id, permission_id)
SELECT 1, permission_id FROM permission;

-- 2. Manager (role_id = 2)
INSERT INTO role_permission (role_id, permission_id)
SELECT 2, permission_id FROM permission WHERE permission_name IN (
    N'Dashboard', N'Role List', N'User List', N'Profile', N'Customer List', N'Order List', 
    N'Order Create', N'Order Detail', N'Product List', N'Product Detail', 
    N'Contract List', N'Contract Detail(Edit)', N'Signature Contract', N'Invoice List', N'Invoice Create', N'Invoice Detail', 
    N'Preview Invoice', N'Payment List', N'Payment Detail', N'Revenue Report', N'Acceptance Record',
    N'Product Review'
);

-- 3. Customer (role_id = 3)
INSERT INTO role_permission (role_id, permission_id)
SELECT 3, permission_id FROM permission WHERE permission_name IN (
    N'Dashboard', N'Profile', N'Customer Detail', N'Customer Edit', N'Order List', N'Order Detail', N'Category List',
    N'Product List', N'Quotation List', N'Quotation Detail', N'Contract List', N'Contract Detail(Edit)', N'Signature Contract',
    N'Invoice List', N'Invoice Detail', N'Preview Invoice', N'Payment List', N'Payment Detail'
);

-- 4. Sale Staff (role_id = 4)
INSERT INTO role_permission (role_id, permission_id)
SELECT 4, permission_id FROM permission WHERE permission_name IN (
    N'Dashboard', N'Profile', N'Customer List', N'Customer Create', N'Customer Detail', N'Customer Edit',
    N'Order List', N'Order Create', N'Order Detail', N'Category List', N'Category edit',
    N'Product List', N'Product Detail', N'Quotation List', N'Create Quotation', N'Quotation Detail',
    N'Invoice Create', N'Invoice Detail', N'Preview Invoice', N'Payment List', N'Payment Detail', N'Product Review',
    N'Import Request List', N'Import Request Detail'
);

-- 5. Admin Officer (role_id = 5)
INSERT INTO role_permission (role_id, permission_id)
SELECT 5, permission_id FROM permission WHERE permission_name IN (
    N'Dashboard', N'Profile', N'Customer List', N'Customer Detail', N'Order List', N'Order Create',
    N'Order Detail', N'Quotation List', N'Quotation Detail', N'Contract List', N'Contract Create',
    N'Contract Detail(Edit)', N'Invoice List', N'Invoice Create', N'Invoice Detail', N'Preview Invoice',
    N'Payment List', N'Payment Detail', N'Acceptance Record', N'Product Review'
);

-- 6. Warehouse Staff (role_id = 6)
INSERT INTO role_permission (role_id, permission_id)
SELECT 6, permission_id FROM permission WHERE permission_name IN (
    N'Warehouse Dashboard', N'Profile', N'Order List', N'Order Detail', N'Category List', N'Category edit',
    N'Product List', N'Product Create', N'Product Detail', N'Product Review', N'Contract List',
    N'Import Request List', N'Import Request Create', N'Import Request Detail'
);
GO

USE SWP_Sales_Process;
GO

SELECT user_id, user_name, password_hash, email, gender, date_of_birth, full_name
                , address, phone, account_status, created_at, updated_at, role_id 
                FROM [user] WHERE 1=2 or role_id = 4
SELECT *
FROM permission
ORDER BY permission_id;

--thêm permission (nếu cần)
--INSERT INTO permission(permission_name)
--VALUES
--('View Dashboard')