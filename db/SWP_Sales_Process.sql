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
    contract_number NVARCHAR(100),
    contract_file_url NVARCHAR(1000),
    contract_status VARCHAR(50) DEFAULT 'DRAFT',
    contract_version NVARCHAR(50) DEFAULT '1.0.0',
    effective_date DATETIME,
	end_date DATETIME,
    created_by INT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (quotation_id) REFERENCES quotation(quotation_id),
    FOREIGN KEY (created_by) REFERENCES [user](user_id)
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
    FOREIGN KEY (history_id) REFERENCES contract_edit_history(history_id)
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


-- 1. TẠO ROLE (GIỮ NGUYÊN)
INSERT INTO role (role_name, status) VALUES 
(N'System Admin', 'Active'),
(N'Manager', 'Active'),
(N'Customer', 'Active'),
(N'Sale Staff', 'Active'),
(N'Admin Officer', 'Active'),
(N'Warehouse Staff', 'Active');
GO

-- 2. TẠO TÀI KHOẢN NHÂN VIÊN (Pass: 123 - Mã hóa bcrypt mẫu)
INSERT INTO [user] (user_name, password_hash, email, gender, full_name, phone, account_status, role_id) VALUES 
('admin_01', '$2a$10$wT/p0LgXn7T6mF9x7Q1UCOY5N/K2uW/1lO1hD/E8lB5vU5xV5xU5y', 'admin@bakery.com', 'M', N'Trần Quản Trị', '0901000001', 'ACTIVE', 1),
('manager_01', '$2a$10$wT/p0LgXn7T6mF9x7Q1UCOY5N/K2uW/1lO1hD/E8lB5vU5xV5xU5y', 'manager@bakery.com', 'F', N'Lê Quản Lý', '0901000002', 'ACTIVE', 2),
('sale_01', '$2a$10$wT/p0LgXn7T6mF9x7Q1UCOY5N/K2uW/1lO1hD/E8lB5vU5xV5xU5y', 'sale1@bakery.com', 'M', N'Nguyễn Sale Một', '0901000003', 'ACTIVE', 4),
('sale_02', '$2a$10$wT/p0LgXn7T6mF9x7Q1UCOY5N/K2uW/1lO1hD/E8lB5vU5xV5xU5y', 'sale2@bakery.com', 'F', N'Phạm Sale Hai', '0901000004', 'ACTIVE', 4),
('officer_01', '$2a$10$wT/p0LgXn7T6mF9x7Q1UCOY5N/K2uW/1lO1hD/E8lB5vU5xV5xU5y', 'officer1@bakery.com', 'F', N'Võ Chứng Từ', '0901000005', 'ACTIVE', 5),
('warehouse_01', '$2a$10$wT/p0LgXn7T6mF9x7Q1UCOY5N/K2uW/1lO1hD/E8lB5vU5xV5xU5y', 'warehouse@bakery.com', 'M', N'Đinh Thủ Kho', '0901000006', 'ACTIVE', 6);
GO

-- 3. TẠO TÀI KHOẢN KHÁCH HÀNG
INSERT INTO [user] (user_name, password_hash, email, gender, date_of_birth, full_name, address, phone, account_status, role_id) VALUES 
('khachhang_01', '$2a$10$wT/p0LgXn7T6mF9x7Q1UCOY5N/K2uW/1lO1hD/E8lB5vU5xV5xU5y', 'khach1@gmail.com', 'M', '1990-01-01', N'Nguyễn Văn Một', N'1 Đại Cồ Việt, Hà Nội', '0981000001', 'ACTIVE', 3),
('khachhang_02', '$2a$10$wT/p0LgXn7T6mF9x7Q1UCOY5N/K2uW/1lO1hD/E8lB5vU5xV5xU5y', 'khach2@gmail.com', 'F', '1991-02-02', N'Trần Thị Hai', N'2 Lê Thanh Nghị, Hà Nội', '0981000002', 'ACTIVE', 3),
('khachhang_03', '$2a$10$wT/p0LgXn7T6mF9x7Q1UCOY5N/K2uW/1lO1hD/E8lB5vU5xV5xU5y', 'khach3@gmail.com', 'M', '1992-03-03', N'Phạm Văn Ba', N'3 Giải Phóng, Hà Nội', '0981000003', 'ACTIVE', 3);
GO

-- 4. HỒ SƠ KHÁCH HÀNG (CUSTOMER)
INSERT INTO customer (tax_code, customer_type, company_name, user_id, assigned_to_user_id) VALUES 
('0390000001', 'B2B', N'Công ty Bánh Ngọt ABC', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
('0390000002', 'B2C', N'Cửa hàng Bánh kem Thủy Tiên', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_02'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
('0390000003', 'B2B', N'Tiệm Bánh Mì Truyền Thống', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_03'), (SELECT user_id FROM [user] WHERE user_name = 'sale_02'));
GO

-- 5. DANH MỤC & SẢN PHẨM
INSERT INTO category (category_name) VALUES (N'Bột Mì'), (N'Đường'), (N'Bơ & Phô Mai'), (N'Men & Phụ gia');
GO

INSERT INTO product (product_name, cost_price, selling_price, description, unit, product_status, reorder_level, quantity_available, updated_by, category_id) VALUES 
(N'Bột Mì Meizan', 15000, 22000, N'Bột mì đa dụng', N'Kg', 'ACTIVE', 50, 500, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 1),
(N'Đường Biên Hòa', 18000, 24000, N'Đường tinh luyện', N'Kg', 'ACTIVE', 100, 1000, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 2),
(N'Bơ Lạt Anchor', 150000, 185000, N'Bơ New Zealand', N'Khối 5kg', 'ACTIVE', 10, 50, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 3),
(N'Men Khô Mauri', 80000, 110000, N'Men làm bánh', N'Gói 500g', 'ACTIVE', 30, 200, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 4);
GO

-- 6. PHÂN QUYỀN (PERMISSION)
INSERT INTO permission (permission_name) VALUES ('/dashboard'), ('/product/list'), ('/quotation/create'), ('/contract/list'), ('/order/list');
GO
INSERT INTO role_permission (role_id, permission_id) VALUES (2,1), (2,2), (2,3), (2,4), (2,5), (4,1), (4,3), (5,4);
GO

-- 7. QUY TRÌNH HỢP ĐỒNG 01: KHÁCH HÀNG 01 (LÀM TRỌN BỘ TỚI THANH TOÁN)
-- Báo giá
INSERT INTO quotation (customer_id, quotation_date, quotation_status, created_by) VALUES (1, DATEADD(DAY, -20, GETDATE()), 'ACCEPTED', (SELECT user_id FROM [user] WHERE user_name = 'sale_01'));
DECLARE @Q1 INT = SCOPE_IDENTITY();
INSERT INTO quotation_detail (quotation_id, product_id, quantity, selling_price, discount_percent, tax_percent) VALUES (@Q1, 1, 100, 22000, 5, 10);
INSERT INTO quotation_history (quotation_id, created_by, edit_history) VALUES (@Q1, (SELECT user_id FROM [user] WHERE user_name = 'sale_01'), N'Tạo báo giá và khách đã duyệt.');

-- Hợp đồng (Trạng thái SIGNED -> ACTIVE)
INSERT INTO customer_contract (customer_id, quotation_id, contract_number, contract_file_url, contract_status, contract_version, created_by) VALUES 
(1, @Q1, 'HD-2026-001', '/uploads/HD-001.pdf', 'SIGNED', '1.0.0', (SELECT user_id FROM [user] WHERE user_name = 'officer_01'));
DECLARE @C1 INT = SCOPE_IDENTITY();

-- Lịch sử hợp đồng C1
INSERT INTO contract_edit_history (contract_id, from_status, to_status, contract_version, changed_by) VALUES 
(@C1, NULL, 'DRAFT', '1.0.0', (SELECT user_id FROM [user] WHERE user_name = 'officer_01')),
(@C1, 'DRAFT', 'PENDING_INTERNAL_REVIEW', '1.0.0', (SELECT user_id FROM [user] WHERE user_name = 'officer_01')),
(@C1, 'PENDING_INTERNAL_REVIEW', 'INTERNAL_APPROVED', '1.0.0', (SELECT user_id FROM [user] WHERE user_name = 'manager_01')),
(@C1, 'INTERNAL_APPROVED', 'SENT_TO_CUSTOMER', '1.0.0', (SELECT user_id FROM [user] WHERE user_name = 'officer_01')),
(@C1, 'SENT_TO_CUSTOMER', 'SIGNED', '1.0.0', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'));

-- Chữ ký
INSERT INTO signature (customer_contract_id, file_name, file_url, signer_user_id, signer_name, signer_type, signed_at, uploaded_by) VALUES 
(@C1, 'sign_kh.png', '/sig/kh.png', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'), N'Nguyễn Văn Một', 'CUSTOMER', GETDATE(), (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'));

-- Đơn hàng & Thanh toán
INSERT INTO customer_order (customer_id, customer_contract_id, order_status, created_by) VALUES (1, @C1, 'DELIVERED', (SELECT user_id FROM [user] WHERE user_name = 'officer_01'));
DECLARE @O1 INT = SCOPE_IDENTITY();
INSERT INTO customer_order_detail (customer_order_id, product_id, quantity, cost_price, selling_price) VALUES (@O1, 1, 100, 15000, 22000);
INSERT INTO invoice (customer_contract_id, customer_order_id, invoice_no, issue_date, invoice_status, created_by) VALUES (@C1, @O1, 'INV-001', GETDATE(), 'PAID', (SELECT user_id FROM [user] WHERE user_name = 'officer_01'));
INSERT INTO payment (customer_contract_id, invoice_id, amount, payment_type, payment_status, paid_at, created_by) VALUES (@C1, SCOPE_IDENTITY(), 2200000, 'BANK_TRANSFER', 'COMPLETED', GETDATE(), (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'));
GO

-- 8. QUY TRÌNH HỢP ĐỒNG 02: KHÁCH HÀNG 02 (ĐANG TRẠNG THÁI KHÁCH YÊU CẦU SỬA - REVISION)
INSERT INTO quotation (customer_id, quotation_date, quotation_status, created_by) VALUES (2, DATEADD(DAY, -5, GETDATE()), 'ACCEPTED', (SELECT user_id FROM [user] WHERE user_name = 'sale_01'));
DECLARE @Q2 INT = SCOPE_IDENTITY();
INSERT INTO customer_contract (customer_id, quotation_id, contract_number, contract_file_url, contract_status, contract_version, created_by) VALUES 
(2, @Q2, 'HD-2026-002', '/uploads/HD-002.pdf', 'CUSTOMER_REQUESTED_REVISION', '1.0.0', (SELECT user_id FROM [user] WHERE user_name = 'officer_01'));
DECLARE @C2 INT = SCOPE_IDENTITY();

-- Ghi lịch sử yêu cầu sửa
INSERT INTO contract_edit_history (contract_id, from_status, to_status, contract_version, changed_by) VALUES 
(@C2, 'SENT_TO_CUSTOMER', 'CUSTOMER_REQUESTED_REVISION', '1.0.0', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_02'));
DECLARE @H2 INT = SCOPE_IDENTITY();
INSERT INTO contract_revision_item (history_id, contract_id, revision_type, revision_detail) VALUES 
(@H2, @C2, N'Địa chỉ', N'Đổi địa chỉ giao sang Kho số 2 quận Tân Bình'),
(@H2, @C2, N'Thanh toán', N'Muốn thanh toán 100% sau khi nhận hàng thay vì đặt cọc');
GO

-- 9. KHO (GIAO DỊCH NHẬP KHO BAN ĐẦU)
INSERT INTO stock_transaction (product_id, transaction_type, quantity_in, quantity_out, transaction_date) VALUES 
(1, 'INITIAL_STOCK', 500, 0, GETDATE()),
(2, 'INITIAL_STOCK', 1000, 0, GETDATE());
GO


USE SWP_Sales_Process;
GO

-- ==========================================================
-- BƯỚC ĐỆM: CHÈN THÊM DỮ LIỆU ĐỂ TRÁNH LỖI KHÓA NGOẠI (FOREIGN KEY)
-- ==========================================================

-- 1. Thêm 2 tài khoản User cho khách hàng 4 và 5
INSERT INTO [user] (user_name, password_hash, email, gender, date_of_birth, full_name, address, phone, account_status, role_id) VALUES 
('khachhang_04', '$2a$10$wT/p0LgXn7T6mF9x7Q1UCOY5N/K2uW/1lO1hD/E8lB5vU5xV5xU5y', 'khach4@gmail.com', 'F', '1993-04-04', N'Hoàng Thị Bốn', N'4 Trần Đại Nghĩa, Hà Nội', '0981000004', 'ACTIVE', 3),
('khachhang_05', '$2a$10$wT/p0LgXn7T6mF9x7Q1UCOY5N/K2uW/1lO1hD/E8lB5vU5xV5xU5y', 'khach5@gmail.com', 'M', '1994-05-05', N'Vũ Văn Năm', N'5 Chùa Bộc, Hà Nội', '0981000005', 'ACTIVE', 3);

-- 2. Thêm hồ sơ cho Customer 4 và 5 (Bây giờ hệ thống sẽ có đủ customer_id từ 1 đến 5)
INSERT INTO customer (tax_code, customer_type, company_name, user_id, assigned_to_user_id) VALUES 
('0390000004', 'B2C', N'Tiệm Bánh Ngọt Homie', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_04'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
('0390000005', 'B2B', N'Nhà Hàng Tiệc Cưới Golden', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_05'), (SELECT user_id FROM [user] WHERE user_name = 'sale_02'));

-- 3. Thêm 1 sản phẩm mẫu ID = 5 để khớp với customer_order_detail
INSERT INTO product (product_name, cost_price, selling_price, description, unit, product_status, reorder_level, quantity_available, updated_by, category_id) VALUES 
(N'Hộp Phô Mai Tươi', 25000, 38000, N'Phô mai tươi làm bánh kem', N'Hộp', 'ACTIVE', 20, 150, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 3);

-- 4. Thêm 3 báo giá bổ sung cho khớp quy trình tạo hợp đồng
INSERT INTO quotation (customer_id, quotation_date, quotation_status, created_by) VALUES 
(3, GETDATE(), 'ACCEPTED', (SELECT user_id FROM [user] WHERE user_name = 'sale_02')),
(4, GETDATE(), 'ACCEPTED', (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
(5, GETDATE(), 'ACCEPTED', (SELECT user_id FROM [user] WHERE user_name = 'sale_02'));

-- 5. Thêm 3 hợp đồng mẫu (Để hệ thống có đủ customer_contract_id từ 1 đến 5)
INSERT INTO customer_contract (customer_id, quotation_id, contract_number, contract_file_url, contract_status, contract_version, created_by) VALUES 
(3, 3, 'HD-2026-003', '/uploads/HD-003.pdf', 'ACTIVE', '1.0.0', (SELECT user_id FROM [user] WHERE user_name = 'officer_01')),
(4, 4, 'HD-2026-004', '/uploads/HD-004.pdf', 'ACTIVE', '1.0.0', (SELECT user_id FROM [user] WHERE user_name = 'officer_01')),
(5, 5, 'HD-2026-005', '/uploads/HD-005.pdf', 'ACTIVE', '1.0.0', (SELECT user_id FROM [user] WHERE user_name = 'officer_01'));
GO


USE SWP_Sales_Process;
GO

-- Xóa dữ liệu rác cũ nếu có trong 2 bảng này để làm sạch
DELETE FROM customer_order_detail;
DELETE FROM customer_order;
GO

-- ==========================================================
-- SỬ DỤNG VÒNG LẶP ĐỂ CHÈN ĐỘNG 30 ĐƠN HÀNG KHÔNG LO LỖI ID
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
    -- 1. Lấy ngẫu nhiên 1 customer_id và customer_contract_id thuộc về customer đó
    SELECT TOP 1 @RandomCustomerID = customer_id 
    FROM customer ORDER BY NEWID();

    -- Tìm hợp đồng của khách hàng đó, nếu khách chưa có hợp đồng thì lấy đại 1 hợp đồng bất kỳ có sẵn
    SELECT TOP 1 @RandomContractID = customer_contract_id 
    FROM customer_contract 
    WHERE customer_id = @RandomCustomerID;

    IF @RandomContractID IS NULL
    BEGIN
        SELECT TOP 1 @RandomContractID = customer_contract_id FROM customer_contract ORDER BY NEWID();
    END

    -- 2. Lấy ngẫu nhiên 1 nhân viên tạo đơn (Role Admin/Manager/Sale...)
    SELECT TOP 1 @RandomUserID = user_id FROM [user] WHERE role_id IN (1, 2, 4, 5) ORDER BY NEWID();

    -- 3. Gán trạng thái ngẫu nhiên
    SET @Status = CASE WHEN @Loop % 4 = 0 THEN 'Completed'
                       WHEN @Loop % 4 = 1 THEN 'Processing'
                       WHEN @Loop % 4 = 2 THEN 'Pending'
                       ELSE 'Cancelled' END;

    -- 4. Chèn vào bảng customer_order
    INSERT INTO customer_order (customer_id, customer_contract_id, order_status, created_by, created_at)
    VALUES (
        @RandomCustomerID, 
        @RandomContractID, 
        @Status, 
        @RandomUserID, 
        DATEADD(MINUTE, -@Loop * 30, GETDATE())
    );

    -- Lấy ID của đơn hàng vừa chèn để dùng cho bảng chi tiết
    SET @NewOrderID = SCOPE_IDENTITY();

    -- 5. Chèn từ 1 đến 2 sản phẩm chi tiết cho đơn hàng này
    DECLARE @ProdLoop INT = 1;
    DECLARE @NumOfProducts INT = CASE WHEN @Loop % 3 = 0 THEN 2 ELSE 1 END;

    WHILE @ProdLoop <= @NumOfProducts
    BEGIN
        -- Lấy ngẫu nhiên 1 sản phẩm thực tế đang có trong bảng product
        SELECT TOP 1 
            @RandomProductID = product_id,
            @RandomUserID = updated_by -- Tạm mượn biến để đỡ tạo nhiều, thực tế lấy cost/selling price
        FROM product 
        WHERE product_id NOT IN (
            -- Tránh trùng sản phẩm trong cùng 1 đơn hàng
            SELECT product_id FROM customer_order_detail WHERE customer_order_id = @NewOrderID
        )
        ORDER BY NEWID();

        -- Nếu tìm thấy sản phẩm hợp lệ thì chèn vào chi tiết
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

-- Kiểm tra lại xem đã đủ 30 dòng chưa
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

