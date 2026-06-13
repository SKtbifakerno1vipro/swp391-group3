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
    role_id INT NOT NULL,
    FOREIGN KEY (role_id) REFERENCES role(role_id)
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


--phân quyền trang

-- 1. Đảm bảo cấu trúc bảng chuẩn
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('permission') AND name = 'url_pattern')
BEGIN
    ALTER TABLE permission ADD url_pattern NVARCHAR(255);
END
GO

-- 2. Đảm bảo có Role "Sales Executive" để tránh lỗi NullPointerException ở trang Customer
IF NOT EXISTS (SELECT 1 FROM role WHERE role_name = 'Sales Executive')
BEGIN
    INSERT INTO role (role_name) VALUES ('Sales Executive');
END
GO

-- 3. Xóa dữ liệu cũ để nạp lại bản chuẩn khớp 100% với Code Java hiện tại
DELETE FROM role_permission;
DELETE FROM permission;
DBCC CHECKIDENT ('permission', RESEED, 0);
GO

-- 4. Nạp danh sách Permission (Dựa chính xác trên @WebServlet trong code của bạn)
INSERT INTO permission (permission_name, url_pattern) VALUES 
('View Dashboard', '/dashboard'),
('Change Password', '/user/password/change'),

-- Nhóm Category (Sửa từ dấu - sang dấu / để khớp code Java)
('Create Category', '/category/create'),
('Edit Category', '/category/edit'),
('Delete Category', '/category/delete'),

-- Nhóm Customer (Sửa từ dấu - sang dấu / để khớp code Java)
('View Customer List', '/customer/list'),
('Create Customer', '/customer/create'),
('Edit Customer', '/customer/edit'),

-- Nhóm User Management
('View User List', '/user-list'),
('View User Detail', '/user-detail'),
('Create User', '/create-user'),
('Edit User', '/edit-user'),

-- Nhóm Role Management
('View Role List', '/role-list'),
('View Role Detail', '/role-detail'),
('Add Role', '/add-role'),
('Edit Role Permissions', '/edit-role-permissions'),

-- Nhóm Order & Invoice
('View Order List', '/customer-order-list'),
('View Order Detail', '/customer-order-detail'),
('Create Order', '/create-customer-order'),
('Issue Invoice', '/Invoice'), -- Lưu ý chữ I viết hoa theo code Java

-- Nhóm Quotation & Product
('View Quotation List', '/quotation-list'),
('Create Quotation', '/create-quotation'),
('View Product List', '/product-list'),
('Edit Product', '/product-edit');
GO

-- 5. CẤP TOÀN BỘ QUYỀN TRÊN CHO ADMIN (ROLE 1)
INSERT INTO role_permission (role_id, permission_id)
SELECT 1, permission_id FROM permission;
GO

-- 6. Kiểm tra lại kết quả
SELECT p.permission_id, p.permission_name, p.url_pattern 
FROM permission p
ORDER BY p.permission_id;

-- ==========================================================
-- PH?N D? LI?U M?I T? MAIN
-- ==========================================================
         r e v i s i o n _ d e t a i l   N V A R C H A R ( M A X )   N O T   N U L L , 
 
         F O R E I G N   K E Y   ( h i s t o r y _ i d )   R E F E R E N C E S   c o n t r a c t _ e d i t _ h i s t o r y ( h i s t o r y _ i d ) , 
 
 	 F O R E I G N   K E Y   ( c o n t r a c t _ i d )   R E F E R E N C E S   c u s t o m e r _ c o n t r a c t ( c u s t o m e r _ c o n t r a c t _ i d ) 
 
 ) ; 
 
 
 
 - -   1 4 .   S i g n a t u r e 
 
 C R E A T E   T A B L E   s i g n a t u r e   ( 
 
         s i g n a t u r e _ i d   I N T   I D E N T I T Y ( 1 , 1 )   P R I M A R Y   K E Y , 
 
         c u s t o m e r _ c o n t r a c t _ i d   I N T   N O T   N U L L , 
 
         f i l e _ n a m e   N V A R C H A R ( 2 5 5 ) , 
 
         f i l e _ u r l   N V A R C H A R ( 1 0 0 0 ) , 
 
         s i g n e r _ u s e r _ i d   I N T   N U L L , 
 
         s i g n e r _ n a m e   N V A R C H A R ( 2 5 5 ) , 
 
         s i g n e r _ t y p e   V A R C H A R ( 5 0 ) , 
 
         s i g n e d _ a t   D A T E T I M E , 
 
         u p l o a d e d _ b y   I N T , 
 
         u p l o a d e d _ a t   D A T E T I M E   D E F A U L T   G E T D A T E ( ) , 
 
         F O R E I G N   K E Y   ( c u s t o m e r _ c o n t r a c t _ i d )   R E F E R E N C E S   c u s t o m e r _ c o n t r a c t ( c u s t o m e r _ c o n t r a c t _ i d ) , 
 
         F O R E I G N   K E Y   ( s i g n e r _ u s e r _ i d )   R E F E R E N C E S   [ u s e r ] ( u s e r _ i d ) , 
 
         F O R E I G N   K E Y   ( u p l o a d e d _ b y )   R E F E R E N C E S   [ u s e r ] ( u s e r _ i d ) 
 
 ) ; 
 
 G O 
 
 
 
 - -   1 5 .   C u s t o m e r   O r d e r 
 
 C R E A T E   T A B L E   c u s t o m e r _ o r d e r   ( 
 
         c u s t o m e r _ o r d e r _ i d   I N T   I D E N T I T Y ( 1 , 1 )   P R I M A R Y   K E Y , 
 
         c u s t o m e r _ i d   I N T   N O T   N U L L , 
 
         c u s t o m e r _ c o n t r a c t _ i d   I N T   N O T   N U L L , 
 
         o r d e r _ s t a t u s   V A R C H A R ( 2 0 ) , 
 
         c r e a t e d _ b y   I N T , 
 
         c r e a t e d _ a t   D A T E T I M E   D E F A U L T   G E T D A T E ( ) , 
 
         F O R E I G N   K E Y   ( c u s t o m e r _ i d )   R E F E R E N C E S   c u s t o m e r ( c u s t o m e r _ i d ) , 
 
         F O R E I G N   K E Y   ( c u s t o m e r _ c o n t r a c t _ i d )   R E F E R E N C E S   c u s t o m e r _ c o n t r a c t ( c u s t o m e r _ c o n t r a c t _ i d ) , 
 
         F O R E I G N   K E Y   ( c r e a t e d _ b y )   R E F E R E N C E S   [ u s e r ] ( u s e r _ i d ) 
 
 ) ; 
 
 G O 
 
 
 
 - -   1 6 .   C u s t o m e r   O r d e r   D e t a i l 
 
 C R E A T E   T A B L E   c u s t o m e r _ o r d e r _ d e t a i l   ( 
 
         c u s t o m e r _ o r d e r _ d e t a i l _ i d   I N T   I D E N T I T Y ( 1 , 1 )   P R I M A R Y   K E Y , 
 
         c u s t o m e r _ o r d e r _ i d   I N T   N O T   N U L L , 
 
         p r o d u c t _ i d   I N T   N O T   N U L L , 
 
         q u a n t i t y   I N T   C H E C K   ( q u a n t i t y   >   0 ) , 
 
         c o s t _ p r i c e   D E C I M A L ( 1 8 , 2 )   C H E C K   ( c o s t _ p r i c e   > =   0 ) , 
 
         s e l l i n g _ p r i c e   D E C I M A L ( 1 8 , 2 )   C H E C K   ( s e l l i n g _ p r i c e   > =   0 ) , 
 
         F O R E I G N   K E Y   ( c u s t o m e r _ o r d e r _ i d )   R E F E R E N C E S   c u s t o m e r _ o r d e r ( c u s t o m e r _ o r d e r _ i d ) , 
 
         F O R E I G N   K E Y   ( p r o d u c t _ i d )   R E F E R E N C E S   p r o d u c t ( p r o d u c t _ i d ) 
 
 ) ; 
 
 G O 
 
 
 
 - -   1 7 .   I n v o i c e 
 
 C R E A T E   T A B L E   i n v o i c e   ( 
 
         i n v o i c e _ i d   I N T   I D E N T I T Y ( 1 , 1 )   P R I M A R Y   K E Y , 
 
         c u s t o m e r _ c o n t r a c t _ i d   I N T   N O T   N U L L , 
 
         c u s t o m e r _ o r d e r _ i d   I N T   N O T   N U L L , 
 
         i n v o i c e _ n o   N V A R C H A R ( 1 0 0 )   U N I Q U E , 
 
         i s s u e _ d a t e   D A T E T I M E , 
 
         i n v o i c e _ s t a t u s   V A R C H A R ( 2 0 ) , 
 
         c r e a t e d _ b y   I N T , 
 
         c r e a t e d _ a t   D A T E T I M E   D E F A U L T   G E T D A T E ( ) , 
 
         F O R E I G N   K E Y   ( c u s t o m e r _ c o n t r a c t _ i d )   R E F E R E N C E S   c u s t o m e r _ c o n t r a c t ( c u s t o m e r _ c o n t r a c t _ i d ) , 
 
         F O R E I G N   K E Y   ( c u s t o m e r _ o r d e r _ i d )   R E F E R E N C E S   c u s t o m e r _ o r d e r ( c u s t o m e r _ o r d e r _ i d ) , 
 
         F O R E I G N   K E Y   ( c r e a t e d _ b y )   R E F E R E N C E S   [ u s e r ] ( u s e r _ i d ) 
 
 ) ; 
 
 G O 
 
 
 
 - -   1 8 .   P a y m e n t 
 
 C R E A T E   T A B L E   p a y m e n t   ( 
 
         p a y m e n t _ i d   I N T   I D E N T I T Y ( 1 , 1 )   P R I M A R Y   K E Y , 
 
         c u s t o m e r _ c o n t r a c t _ i d   I N T   N O T   N U L L , 
 
         i n v o i c e _ i d   I N T   U N I Q U E , 
 
         a m o u n t   D E C I M A L ( 1 8 , 2 )   C H E C K   ( a m o u n t   >   0 ) , 
 
         p a y m e n t _ t y p e   V A R C H A R ( 5 0 ) , 
 
         p a y m e n t _ s t a t u s   V A R C H A R ( 2 0 ) , 
 
         p a i d _ a t   D A T E T I M E , 
 
         c r e a t e d _ b y   I N T , 
 
         c r e a t e d _ a t   D A T E T I M E   D E F A U L T   G E T D A T E ( ) , 
 
         F O R E I G N   K E Y   ( c u s t o m e r _ c o n t r a c t _ i d )   R E F E R E N C E S   c u s t o m e r _ c o n t r a c t ( c u s t o m e r _ c o n t r a c t _ i d ) , 
 
         F O R E I G N   K E Y   ( i n v o i c e _ i d )   R E F E R E N C E S   i n v o i c e ( i n v o i c e _ i d ) , 
 
         F O R E I G N   K E Y   ( c r e a t e d _ b y )   R E F E R E N C E S   [ u s e r ] ( u s e r _ i d ) 
 
 ) ; 
 
 G O 
 
 
 
 - -   1 9 .   S t o c k   T r a n s a c t i o n 
 
 C R E A T E   T A B L E   s t o c k _ t r a n s a c t i o n   ( 
 
         t r a n s a c t i o n _ i d   I N T   I D E N T I T Y ( 1 , 1 )   P R I M A R Y   K E Y , 
 
         p r o d u c t _ i d   I N T   N O T   N U L L , 
 
         t r a n s a c t i o n _ d a t e   D A T E T I M E   D E F A U L T   G E T D A T E ( ) , 
 
         t r a n s a c t i o n _ t y p e   V A R C H A R ( 5 0 ) , 
 
         q u a n t i t y _ i n   I N T   D E F A U L T   0   C H E C K   ( q u a n t i t y _ i n   > =   0 ) , 
 
         q u a n t i t y _ o u t   I N T   D E F A U L T   0   C H E C K   ( q u a n t i t y _ o u t   > =   0 ) , 
 
         c u s t o m e r _ o r d e r _ i d   I N T , 
 
         F O R E I G N   K E Y   ( p r o d u c t _ i d )   R E F E R E N C E S   p r o d u c t ( p r o d u c t _ i d ) , 
 
         F O R E I G N   K E Y   ( c u s t o m e r _ o r d e r _ i d )   R E F E R E N C E S   c u s t o m e r _ o r d e r ( c u s t o m e r _ o r d e r _ i d ) 
 
 ) ; 
 
 G O 
 
 
 
 
 
 - -   1 .   T �
O   R O L E   ( G I �
  N G U Y � N ) 
 
 I N S E R T   I N T O   r o l e   ( r o l e _ n a m e ,   s t a t u s )   V A L U E S   
 
 ( N ' S y s t e m   A d m i n ' ,   ' A c t i v e ' ) , 
 
 ( N ' M a n a g e r ' ,   ' A c t i v e ' ) , 
 
 ( N ' C u s t o m e r ' ,   ' A c t i v e ' ) , 
 
 ( N ' S a l e   S t a f f ' ,   ' A c t i v e ' ) , 
 
 ( N ' A d m i n   O f f i c e r ' ,   ' A c t i v e ' ) , 
 
 ( N ' W a r e h o u s e   S t a f f ' ,   ' A c t i v e ' ) ; 
 
 G O 
 
 
 
 - -   2 .   T �
O   T � I   K H O �
N   N H � N   V I � N   ( P a s s :   1 2 3   -   M �   h � a   b c r y p t   m �
u ) 
 
 I N S E R T   I N T O   [ u s e r ]   ( u s e r _ n a m e ,   p a s s w o r d _ h a s h ,   e m a i l ,   g e n d e r ,   f u l l _ n a m e ,   p h o n e ,   a c c o u n t _ s t a t u s ,   r o l e _ i d )   V A L U E S   
 
 ( ' a d m i n _ 0 1 ' ,   ' 1 2 3 ' ,   ' a d m i n @ b a k e r y . c o m ' ,   ' M ' ,   N ' T r �
n   Q u �
n   T r �
' ,   ' 0 9 0 1 0 0 0 0 0 1 ' ,   ' A C T I V E ' ,   1 ) , 
 
 ( ' m a n a g e r _ 0 1 ' ,   ' $ 2 a $ 1 0 $ w T / p 0 L g X n 7 T 6 m F 9 x 7 Q 1 U C O Y 5 N / K 2 u W / 1 l O 1 h D / E 8 l B 5 v U 5 x V 5 x U 5 y ' ,   ' m a n a g e r @ b a k e r y . c o m ' ,   ' F ' ,   N ' L �   Q u �
n   L � ' ,   ' 0 9 0 1 0 0 0 0 0 2 ' ,   ' A C T I V E ' ,   2 ) , 
 
 ( ' s a l e _ 0 1 ' ,   ' $ 2 a $ 1 0 $ w T / p 0 L g X n 7 T 6 m F 9 x 7 Q 1 U C O Y 5 N / K 2 u W / 1 l O 1 h D / E 8 l B 5 v U 5 x V 5 x U 5 y ' ,   ' s a l e 1 @ b a k e r y . c o m ' ,   ' M ' ,   N ' N g u y �
n   S a l e   M �
t ' ,   ' 0 9 0 1 0 0 0 0 0 3 ' ,   ' A C T I V E ' ,   4 ) , 
 
 ( ' s a l e _ 0 2 ' ,   ' $ 2 a $ 1 0 $ w T / p 0 L g X n 7 T 6 m F 9 x 7 Q 1 U C O Y 5 N / K 2 u W / 1 l O 1 h D / E 8 l B 5 v U 5 x V 5 x U 5 y ' ,   ' s a l e 2 @ b a k e r y . c o m ' ,   ' F ' ,   N ' P h �
m   S a l e   H a i ' ,   ' 0 9 0 1 0 0 0 0 0 4 ' ,   ' A C T I V E ' ,   4 ) , 
 
 ( ' o f f i c e r _ 0 1 ' ,   ' $ 2 a $ 1 0 $ w T / p 0 L g X n 7 T 6 m F 9 x 7 Q 1 U C O Y 5 N / K 2 u W / 1 l O 1 h D / E 8 l B 5 v U 5 x V 5 x U 5 y ' ,   ' o f f i c e r 1 @ b a k e r y . c o m ' ,   ' F ' ,   N ' V �   C h �
n g   T �
' ,   ' 0 9 0 1 0 0 0 0 0 5 ' ,   ' A C T I V E ' ,   5 ) , 
 
 ( ' w a r e h o u s e _ 0 1 ' ,   ' $ 2 a $ 1 0 $ w T / p 0 L g X n 7 T 6 m F 9 x 7 Q 1 U C O Y 5 N / K 2 u W / 1 l O 1 h D / E 8 l B 5 v U 5 x V 5 x U 5 y ' ,   ' w a r e h o u s e @ b a k e r y . c o m ' ,   ' M ' ,   N ' i n h   T h �
  K h o ' ,   ' 0 9 0 1 0 0 0 0 0 6 ' ,   ' A C T I V E ' ,   6 ) ; 
 
 G O 
 
 
 
 - -   3 .   T �
O   T � I   K H O �
N   K H � C H   H � N G 
 
 I N S E R T   I N T O   [ u s e r ]   ( u s e r _ n a m e ,   p a s s w o r d _ h a s h ,   e m a i l ,   g e n d e r ,   d a t e _ o f _ b i r t h ,   f u l l _ n a m e ,   a d d r e s s ,   p h o n e ,   a c c o u n t _ s t a t u s ,   r o l e _ i d )   V A L U E S   
 
 ( ' k h a c h h a n g _ 0 1 ' ,   ' $ 2 a $ 1 0 $ w T / p 0 L g X n 7 T 6 m F 9 x 7 Q 1 U C O Y 5 N / K 2 u W / 1 l O 1 h D / E 8 l B 5 v U 5 x V 5 x U 5 y ' ,   ' k h a c h 1 @ g m a i l . c o m ' ,   ' M ' ,   ' 1 9 9 0 - 0 1 - 0 1 ' ,   N ' N g u y �
n   V n   M �
t ' ,   N ' 1   �
i   C �
  V i �
t ,   H �   N �
i ' ,   ' 0 9 8 1 0 0 0 0 0 1 ' ,   ' A C T I V E ' ,   3 ) , 
 
 ( ' k h a c h h a n g _ 0 2 ' ,   ' $ 2 a $ 1 0 $ w T / p 0 L g X n 7 T 6 m F 9 x 7 Q 1 U C O Y 5 N / K 2 u W / 1 l O 1 h D / E 8 l B 5 v U 5 x V 5 x U 5 y ' ,   ' k h a c h 2 @ g m a i l . c o m ' ,   ' F ' ,   ' 1 9 9 1 - 0 2 - 0 2 ' ,   N ' T r �
n   T h �
  H a i ' ,   N ' 2   L �   T h a n h   N g h �
,   H �   N �
i ' ,   ' 0 9 8 1 0 0 0 0 0 2 ' ,   ' A C T I V E ' ,   3 ) , 
 
 ( ' k h a c h h a n g _ 0 3 ' ,   ' $ 2 a $ 1 0 $ w T / p 0 L g X n 7 T 6 m F 9 x 7 Q 1 U C O Y 5 N / K 2 u W / 1 l O 1 h D / E 8 l B 5 v U 5 x V 5 x U 5 y ' ,   ' k h a c h 3 @ g m a i l . c o m ' ,   ' M ' ,   ' 1 9 9 2 - 0 3 - 0 3 ' ,   N ' P h �
m   V n   B a ' ,   N ' 3   G i �
i   P h � n g ,   H �   N �
i ' ,   ' 0 9 8 1 0 0 0 0 0 3 ' ,   ' A C T I V E ' ,   3 ) ; 
 
 G O 
 
 
 
 - -   4 .   H �
  S �  K H � C H   H � N G   ( C U S T O M E R ) 
 
 I N S E R T   I N T O   c u s t o m e r   ( t a x _ c o d e ,   c u s t o m e r _ t y p e ,   c o m p a n y _ n a m e ,   u s e r _ i d ,   a s s i g n e d _ t o _ u s e r _ i d )   V A L U E S   
 
 ( ' 0 3 9 0 0 0 0 0 0 1 ' ,   ' B 2 B ' ,   N ' C � n g   t y   B � n h   N g �
t   A B C ' ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' k h a c h h a n g _ 0 1 ' ) ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' s a l e _ 0 1 ' ) ) , 
 
 ( ' 0 3 9 0 0 0 0 0 0 2 ' ,   ' B 2 C ' ,   N ' C �
a   h � n g   B � n h   k e m   T h �
y   T i � n ' ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' k h a c h h a n g _ 0 2 ' ) ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' s a l e _ 0 1 ' ) ) , 
 
 ( ' 0 3 9 0 0 0 0 0 0 3 ' ,   ' B 2 B ' ,   N ' T i �
m   B � n h   M �   T r u y �
n   T h �
n g ' ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' k h a c h h a n g _ 0 3 ' ) ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' s a l e _ 0 2 ' ) ) ; 
 
 G O 
 
 
 
 - -   5 .   D A N H   M �
C   &   S �
N   P H �
M 
 
 I N S E R T   I N T O   c a t e g o r y   ( c a t e g o r y _ n a m e )   V A L U E S   ( N ' B �
t   M � ' ) ,   ( N ' ��
n g ' ) ,   ( N ' B �  &   P h �   M a i ' ) ,   ( N ' M e n   &   P h �
  g i a ' ) ; 
 
 G O 
 
 
 
 I N S E R T   I N T O   p r o d u c t   ( p r o d u c t _ n a m e ,   c o s t _ p r i c e ,   s e l l i n g _ p r i c e ,   d e s c r i p t i o n ,   u n i t ,   p r o d u c t _ s t a t u s ,   r e o r d e r _ l e v e l ,   q u a n t i t y _ a v a i l a b l e ,   u p d a t e d _ b y ,   c a t e g o r y _ i d )   V A L U E S   
 
 ( N ' B �
t   M �   M e i z a n ' ,   1 5 0 0 0 ,   2 2 0 0 0 ,   N ' B �
t   m �   a   d �
n g ' ,   N ' K g ' ,   ' A C T I V E ' ,   5 0 ,   5 0 0 ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' w a r e h o u s e _ 0 1 ' ) ,   1 ) , 
 
 ( N ' ��
n g   B i � n   H � a ' ,   1 8 0 0 0 ,   2 4 0 0 0 ,   N ' ��
n g   t i n h   l u y �
n ' ,   N ' K g ' ,   ' A C T I V E ' ,   1 0 0 ,   1 0 0 0 ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' w a r e h o u s e _ 0 1 ' ) ,   2 ) , 
 
 ( N ' B �  L �
t   A n c h o r ' ,   1 5 0 0 0 0 ,   1 8 5 0 0 0 ,   N ' B �  N e w   Z e a l a n d ' ,   N ' K h �
i   5 k g ' ,   ' A C T I V E ' ,   1 0 ,   5 0 ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' w a r e h o u s e _ 0 1 ' ) ,   3 ) , 
 
 ( N ' M e n   K h �   M a u r i ' ,   8 0 0 0 0 ,   1 1 0 0 0 0 ,   N ' M e n   l � m   b � n h ' ,   N ' G � i   5 0 0 g ' ,   ' A C T I V E ' ,   3 0 ,   2 0 0 ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' w a r e h o u s e _ 0 1 ' ) ,   4 ) ; 
 
 G O 
 
 
 
 - -   6 .   P H � N   Q U Y �
N   ( P E R M I S S I O N ) 
 
 I N S E R T   I N T O   p e r m i s s i o n   ( p e r m i s s i o n _ n a m e )   V A L U E S   ( ' / d a s h b o a r d ' ) ,   ( ' / p r o d u c t / l i s t ' ) ,   ( ' / q u o t a t i o n / c r e a t e ' ) ,   ( ' / c o n t r a c t / l i s t ' ) ,   ( ' / o r d e r / l i s t ' ) ; 
 
 G O 
 
 I N S E R T   I N T O   r o l e _ p e r m i s s i o n   ( r o l e _ i d ,   p e r m i s s i o n _ i d )   V A L U E S   ( 2 , 1 ) ,   ( 2 , 2 ) ,   ( 2 , 3 ) ,   ( 2 , 4 ) ,   ( 2 , 5 ) ,   ( 4 , 1 ) ,   ( 4 , 3 ) ,   ( 5 , 4 ) ; 
 
 G O 
 
 
 
 - -   7 .   Q U Y   T R � N H   H �
P   �
N G   0 1 :   K H � C H   H � N G   0 1   ( L � M   T R �
N   B �
  T �
I   T H A N H   T O � N ) 
 
 - -   B � o   g i � 
 
 I N S E R T   I N T O   q u o t a t i o n   ( c u s t o m e r _ i d ,   q u o t a t i o n _ d a t e ,   q u o t a t i o n _ s t a t u s ,   c r e a t e d _ b y )   V A L U E S   ( 1 ,   D A T E A D D ( D A Y ,   - 2 0 ,   G E T D A T E ( ) ) ,   ' A C C E P T E D ' ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' s a l e _ 0 1 ' ) ) ; 
 
 D E C L A R E   @ Q 1   I N T   =   S C O P E _ I D E N T I T Y ( ) ; 
 
 I N S E R T   I N T O   q u o t a t i o n _ d e t a i l   ( q u o t a t i o n _ i d ,   p r o d u c t _ i d ,   q u a n t i t y ,   s e l l i n g _ p r i c e ,   d i s c o u n t _ p e r c e n t ,   t a x _ p e r c e n t )   V A L U E S   ( @ Q 1 ,   1 ,   1 0 0 ,   2 2 0 0 0 ,   5 ,   1 0 ) ; 
 
 I N S E R T   I N T O   q u o t a t i o n _ h i s t o r y   ( q u o t a t i o n _ i d ,   c r e a t e d _ b y ,   e d i t _ h i s t o r y )   V A L U E S   ( @ Q 1 ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' s a l e _ 0 1 ' ) ,   N ' T �
o   b � o   g i �   v �   k h � c h   �   d u y �
t . ' ) ; 
 
 
 
 - -   H �
p   �
n g   ( T r �
n g   t h � i   S I G N E D   - >   A C T I V E ) 
 
 I N S E R T   I N T O   c u s t o m e r _ c o n t r a c t   ( c u s t o m e r _ i d ,   q u o t a t i o n _ i d ,   c o n t r a c t _ n u m b e r ,   c o n t r a c t _ f i l e _ u r l ,   c o n t r a c t _ s t a t u s ,   c o n t r a c t _ v e r s i o n ,   c r e a t e d _ b y )   V A L U E S   
 
 ( 1 ,   @ Q 1 ,   ' H D - 2 0 2 6 - 0 0 1 ' ,   ' / u p l o a d s / H D - 0 0 1 . p d f ' ,   ' S I G N E D ' ,   ' 1 . 0 . 0 ' ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' o f f i c e r _ 0 1 ' ) ) ; 
 
 D E C L A R E   @ C 1   I N T   =   S C O P E _ I D E N T I T Y ( ) ; 
 
 
 
 - -   L �
c h   s �
  h �
p   �
n g   C 1 
 
 I N S E R T   I N T O   c o n t r a c t _ e d i t _ h i s t o r y   ( c o n t r a c t _ i d ,   f r o m _ s t a t u s ,   t o _ s t a t u s ,   c o n t r a c t _ v e r s i o n ,   c h a n g e d _ b y )   V A L U E S   
 
 ( @ C 1 ,   N U L L ,   ' D R A F T ' ,   ' 1 . 0 . 0 ' ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' o f f i c e r _ 0 1 ' ) ) , 
 
 ( @ C 1 ,   ' D R A F T ' ,   ' P E N D I N G _ I N T E R N A L _ R E V I E W ' ,   ' 1 . 0 . 0 ' ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' o f f i c e r _ 0 1 ' ) ) , 
 
 ( @ C 1 ,   ' P E N D I N G _ I N T E R N A L _ R E V I E W ' ,   ' I N T E R N A L _ A P P R O V E D ' ,   ' 1 . 0 . 0 ' ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' m a n a g e r _ 0 1 ' ) ) , 
 
 ( @ C 1 ,   ' I N T E R N A L _ A P P R O V E D ' ,   ' S E N T _ T O _ C U S T O M E R ' ,   ' 1 . 0 . 0 ' ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' o f f i c e r _ 0 1 ' ) ) , 
 
 ( @ C 1 ,   ' S E N T _ T O _ C U S T O M E R ' ,   ' S I G N E D ' ,   ' 1 . 0 . 0 ' ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' k h a c h h a n g _ 0 1 ' ) ) ; 
 
 
 
 - -   C h �
  k � 
 
 I N S E R T   I N T O   s i g n a t u r e   ( c u s t o m e r _ c o n t r a c t _ i d ,   f i l e _ n a m e ,   f i l e _ u r l ,   s i g n e r _ u s e r _ i d ,   s i g n e r _ n a m e ,   s i g n e r _ t y p e ,   s i g n e d _ a t ,   u p l o a d e d _ b y )   V A L U E S   
 
 ( @ C 1 ,   ' s i g n _ k h . p n g ' ,   ' / s i g / k h . p n g ' ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' k h a c h h a n g _ 0 1 ' ) ,   N ' N g u y �
n   V n   M �
t ' ,   ' C U S T O M E R ' ,   G E T D A T E ( ) ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' k h a c h h a n g _ 0 1 ' ) ) ; 
 
 
 
 - -   �n   h � n g   &   T h a n h   t o � n 
 
 I N S E R T   I N T O   c u s t o m e r _ o r d e r   ( c u s t o m e r _ i d ,   c u s t o m e r _ c o n t r a c t _ i d ,   o r d e r _ s t a t u s ,   c r e a t e d _ b y )   V A L U E S   ( 1 ,   @ C 1 ,   ' D E L I V E R E D ' ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' o f f i c e r _ 0 1 ' ) ) ; 
 
 D E C L A R E   @ O 1   I N T   =   S C O P E _ I D E N T I T Y ( ) ; 
 
 I N S E R T   I N T O   c u s t o m e r _ o r d e r _ d e t a i l   ( c u s t o m e r _ o r d e r _ i d ,   p r o d u c t _ i d ,   q u a n t i t y ,   c o s t _ p r i c e ,   s e l l i n g _ p r i c e )   V A L U E S   ( @ O 1 ,   1 ,   1 0 0 ,   1 5 0 0 0 ,   2 2 0 0 0 ) ; 
 
 I N S E R T   I N T O   i n v o i c e   ( c u s t o m e r _ c o n t r a c t _ i d ,   c u s t o m e r _ o r d e r _ i d ,   i n v o i c e _ n o ,   i s s u e _ d a t e ,   i n v o i c e _ s t a t u s ,   c r e a t e d _ b y )   V A L U E S   ( @ C 1 ,   @ O 1 ,   ' I N V - 0 0 1 ' ,   G E T D A T E ( ) ,   ' P A I D ' ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' o f f i c e r _ 0 1 ' ) ) ; 
 
 I N S E R T   I N T O   p a y m e n t   ( c u s t o m e r _ c o n t r a c t _ i d ,   i n v o i c e _ i d ,   a m o u n t ,   p a y m e n t _ t y p e ,   p a y m e n t _ s t a t u s ,   p a i d _ a t ,   c r e a t e d _ b y )   V A L U E S   ( @ C 1 ,   S C O P E _ I D E N T I T Y ( ) ,   2 2 0 0 0 0 0 ,   ' B A N K _ T R A N S F E R ' ,   ' C O M P L E T E D ' ,   G E T D A T E ( ) ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' k h a c h h a n g _ 0 1 ' ) ) ; 
 
 G O 
 
 
 
 - -   8 .   Q U Y   T R � N H   H �
P   �
N G   0 2 :   K H � C H   H � N G   0 2   ( A N G   T R �
N G   T H � I   K H � C H   Y � U   C �
U   S �
A   -   R E V I S I O N ) 
 
 I N S E R T   I N T O   q u o t a t i o n   ( c u s t o m e r _ i d ,   q u o t a t i o n _ d a t e ,   q u o t a t i o n _ s t a t u s ,   c r e a t e d _ b y )   V A L U E S   ( 2 ,   D A T E A D D ( D A Y ,   - 5 ,   G E T D A T E ( ) ) ,   ' A C C E P T E D ' ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' s a l e _ 0 1 ' ) ) ; 
 
 D E C L A R E   @ Q 2   I N T   =   S C O P E _ I D E N T I T Y ( ) ; 
 
 I N S E R T   I N T O   c u s t o m e r _ c o n t r a c t   ( c u s t o m e r _ i d ,   q u o t a t i o n _ i d ,   c o n t r a c t _ n u m b e r ,   c o n t r a c t _ f i l e _ u r l ,   c o n t r a c t _ s t a t u s ,   c o n t r a c t _ v e r s i o n ,   c r e a t e d _ b y )   V A L U E S   
 
 ( 2 ,   @ Q 2 ,   ' H D - 2 0 2 6 - 0 0 2 ' ,   ' / u p l o a d s / H D - 0 0 2 . p d f ' ,   ' C U S T O M E R _ R E Q U E S T E D _ R E V I S I O N ' ,   ' 1 . 0 . 0 ' ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' o f f i c e r _ 0 1 ' ) ) ; 
 
 D E C L A R E   @ C 2   I N T   =   S C O P E _ I D E N T I T Y ( ) ; 
 
 
 
 - -   G h i   l �
c h   s �
  y � u   c �
u   s �
a 
 
 I N S E R T   I N T O   c o n t r a c t _ e d i t _ h i s t o r y   ( c o n t r a c t _ i d ,   f r o m _ s t a t u s ,   t o _ s t a t u s ,   c o n t r a c t _ v e r s i o n ,   c h a n g e d _ b y )   V A L U E S   
 
 ( @ C 2 ,   ' S E N T _ T O _ C U S T O M E R ' ,   ' C U S T O M E R _ R E Q U E S T E D _ R E V I S I O N ' ,   ' 1 . 0 . 0 ' ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' k h a c h h a n g _ 0 2 ' ) ) ; 
 
 D E C L A R E   @ H 2   I N T   =   S C O P E _ I D E N T I T Y ( ) ; 
 
 I N S E R T   I N T O   c o n t r a c t _ r e v i s i o n _ i t e m   ( h i s t o r y _ i d ,   c o n t r a c t _ i d ,   r e v i s i o n _ t y p e ,   r e v i s i o n _ d e t a i l )   V A L U E S   
 
 ( @ H 2 ,   @ C 2 ,   N ' �
a   c h �
' ,   N ' �
i   �
a   c h �
  g i a o   s a n g   K h o   s �
  2   q u �
n   T � n   B � n h ' ) , 
 
 ( @ H 2 ,   @ C 2 ,   N ' T h a n h   t o � n ' ,   N ' M u �
n   t h a n h   t o � n   1 0 0 %   s a u   k h i   n h �
n   h � n g   t h a y   v �   �
t   c �
c ' ) ; 
 
 G O 
 
 
 
 - -   9 .   K H O   ( G I A O   D �
C H   N H �
P   K H O   B A N   �
U ) 
 
 I N S E R T   I N T O   s t o c k _ t r a n s a c t i o n   ( p r o d u c t _ i d ,   t r a n s a c t i o n _ t y p e ,   q u a n t i t y _ i n ,   q u a n t i t y _ o u t ,   t r a n s a c t i o n _ d a t e )   V A L U E S   
 
 ( 1 ,   ' I N I T I A L _ S T O C K ' ,   5 0 0 ,   0 ,   G E T D A T E ( ) ) , 
 
 ( 2 ,   ' I N I T I A L _ S T O C K ' ,   1 0 0 0 ,   0 ,   G E T D A T E ( ) ) ; 
 
 G O 
 
 
 
 
 
 U S E   S W P _ S a l e s _ P r o c e s s ; 
 
 G O 
 
 
 
 - -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
 
 - -   B ��
C   �
M :   C H � N   T H � M   D �
  L I �
U   �
  T R � N H   L �
I   K H � A   N G O �
I   ( F O R E I G N   K E Y ) 
 
 - -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
 
 
 
 - -   1 .   T h � m   2   t � i   k h o �
n   U s e r   c h o   k h � c h   h � n g   4   v �   5 
 
 I N S E R T   I N T O   [ u s e r ]   ( u s e r _ n a m e ,   p a s s w o r d _ h a s h ,   e m a i l ,   g e n d e r ,   d a t e _ o f _ b i r t h ,   f u l l _ n a m e ,   a d d r e s s ,   p h o n e ,   a c c o u n t _ s t a t u s ,   r o l e _ i d )   V A L U E S   
 
 ( ' k h a c h h a n g _ 0 4 ' ,   ' $ 2 a $ 1 0 $ w T / p 0 L g X n 7 T 6 m F 9 x 7 Q 1 U C O Y 5 N / K 2 u W / 1 l O 1 h D / E 8 l B 5 v U 5 x V 5 x U 5 y ' ,   ' k h a c h 4 @ g m a i l . c o m ' ,   ' F ' ,   ' 1 9 9 3 - 0 4 - 0 4 ' ,   N ' H o � n g   T h �
  B �
n ' ,   N ' 4   T r �
n   �
i   N g h )a ,   H �   N �
i ' ,   ' 0 9 8 1 0 0 0 0 0 4 ' ,   ' A C T I V E ' ,   3 ) , 
 
 ( ' k h a c h h a n g _ 0 5 ' ,   ' $ 2 a $ 1 0 $ w T / p 0 L g X n 7 T 6 m F 9 x 7 Q 1 U C O Y 5 N / K 2 u W / 1 l O 1 h D / E 8 l B 5 v U 5 x V 5 x U 5 y ' ,   ' k h a c h 5 @ g m a i l . c o m ' ,   ' M ' ,   ' 1 9 9 4 - 0 5 - 0 5 ' ,   N ' V i  V n   N m ' ,   N ' 5   C h � a   B �
c ,   H �   N �
i ' ,   ' 0 9 8 1 0 0 0 0 0 5 ' ,   ' A C T I V E ' ,   3 ) ; 
 
 
 
 - -   2 .   T h � m   h �
  s �  c h o   C u s t o m e r   4   v �   5   ( B � y   g i �
  h �
  t h �
n g   s �
  c �   �
  c u s t o m e r _ i d   t �
  1   �
n   5 ) 
 
 I N S E R T   I N T O   c u s t o m e r   ( t a x _ c o d e ,   c u s t o m e r _ t y p e ,   c o m p a n y _ n a m e ,   u s e r _ i d ,   a s s i g n e d _ t o _ u s e r _ i d )   V A L U E S   
 
 ( ' 0 3 9 0 0 0 0 0 0 4 ' ,   ' B 2 C ' ,   N ' T i �
m   B � n h   N g �
t   H o m i e ' ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' k h a c h h a n g _ 0 4 ' ) ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' s a l e _ 0 1 ' ) ) , 
 
 ( ' 0 3 9 0 0 0 0 0 0 5 ' ,   ' B 2 B ' ,   N ' N h �   H � n g   T i �
c   C ��
i   G o l d e n ' ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' k h a c h h a n g _ 0 5 ' ) ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' s a l e _ 0 2 ' ) ) ; 
 
 
 
 - -   3 .   T h � m   1   s �
n   p h �
m   m �
u   I D   =   5   �
  k h �
p   v �
i   c u s t o m e r _ o r d e r _ d e t a i l 
 
 I N S E R T   I N T O   p r o d u c t   ( p r o d u c t _ n a m e ,   c o s t _ p r i c e ,   s e l l i n g _ p r i c e ,   d e s c r i p t i o n ,   u n i t ,   p r o d u c t _ s t a t u s ,   r e o r d e r _ l e v e l ,   q u a n t i t y _ a v a i l a b l e ,   u p d a t e d _ b y ,   c a t e g o r y _ i d )   V A L U E S   
 
 ( N ' H �
p   P h �   M a i   T ��i ' ,   2 5 0 0 0 ,   3 8 0 0 0 ,   N ' P h �   m a i   t ��i   l � m   b � n h   k e m ' ,   N ' H �
p ' ,   ' A C T I V E ' ,   2 0 ,   1 5 0 ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' w a r e h o u s e _ 0 1 ' ) ,   3 ) ; 
 
 
 
 - -   4 .   T h � m   3   b � o   g i �   b �
  s u n g   c h o   k h �
p   q u y   t r � n h   t �
o   h �
p   �
n g 
 
 I N S E R T   I N T O   q u o t a t i o n   ( c u s t o m e r _ i d ,   q u o t a t i o n _ d a t e ,   q u o t a t i o n _ s t a t u s ,   c r e a t e d _ b y )   V A L U E S   
 
 ( 3 ,   G E T D A T E ( ) ,   ' A C C E P T E D ' ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' s a l e _ 0 2 ' ) ) , 
 
 ( 4 ,   G E T D A T E ( ) ,   ' A C C E P T E D ' ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' s a l e _ 0 1 ' ) ) , 
 
 ( 5 ,   G E T D A T E ( ) ,   ' A C C E P T E D ' ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' s a l e _ 0 2 ' ) ) ; 
 
 
 
 - -   5 .   T h � m   3   h �
p   �
n g   m �
u   ( �
  h �
  t h �
n g   c �   �
  c u s t o m e r _ c o n t r a c t _ i d   t �
  1   �
n   5 ) 
 
 I N S E R T   I N T O   c u s t o m e r _ c o n t r a c t   ( c u s t o m e r _ i d ,   q u o t a t i o n _ i d ,   c o n t r a c t _ n u m b e r ,   c o n t r a c t _ f i l e _ u r l ,   c o n t r a c t _ s t a t u s ,   c o n t r a c t _ v e r s i o n ,   c r e a t e d _ b y )   V A L U E S   
 
 ( 3 ,   3 ,   ' H D - 2 0 2 6 - 0 0 3 ' ,   ' / u p l o a d s / H D - 0 0 3 . p d f ' ,   ' A C T I V E ' ,   ' 1 . 0 . 0 ' ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' o f f i c e r _ 0 1 ' ) ) , 
 
 ( 4 ,   4 ,   ' H D - 2 0 2 6 - 0 0 4 ' ,   ' / u p l o a d s / H D - 0 0 4 . p d f ' ,   ' A C T I V E ' ,   ' 1 . 0 . 0 ' ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' o f f i c e r _ 0 1 ' ) ) , 
 
 ( 5 ,   5 ,   ' H D - 2 0 2 6 - 0 0 5 ' ,   ' / u p l o a d s / H D - 0 0 5 . p d f ' ,   ' A C T I V E ' ,   ' 1 . 0 . 0 ' ,   ( S E L E C T   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   u s e r _ n a m e   =   ' o f f i c e r _ 0 1 ' ) ) ; 
 
 G O 
 
 
 
 
 
 U S E   S W P _ S a l e s _ P r o c e s s ; 
 
 G O 
 
 
 
 - -   X � a   d �
  l i �
u   r � c   c i  n �
u   c �   t r o n g   2   b �
n g   n � y   �
  l � m   s �
c h 
 
 D E L E T E   F R O M   c u s t o m e r _ o r d e r _ d e t a i l ; 
 
 D E L E T E   F R O M   c u s t o m e r _ o r d e r ; 
 
 G O 
 
 
 
 - -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
 
 - -   S �
  D �
N G   V � N G   L �
P   �
  C H � N   �
N G   3 0   �N   H � N G   K H � N G   L O   L �
I   I D 
 
 - -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
 
 D E C L A R E   @ L o o p   I N T   =   1 ; 
 
 D E C L A R E   @ R a n d o m C u s t o m e r I D   I N T ; 
 
 D E C L A R E   @ R a n d o m C o n t r a c t I D   I N T ; 
 
 D E C L A R E   @ R a n d o m U s e r I D   I N T ; 
 
 D E C L A R E   @ R a n d o m P r o d u c t I D   I N T ; 
 
 D E C L A R E   @ N e w O r d e r I D   I N T ; 
 
 D E C L A R E   @ S t a t u s   V A R C H A R ( 2 0 ) ; 
 
 
 
 W H I L E   @ L o o p   < =   3 0 
 
 B E G I N 
 
         - -   1 .   L �
y   n g �
u   n h i � n   1   c u s t o m e r _ i d   v �   c u s t o m e r _ c o n t r a c t _ i d   t h u �
c   v �
  c u s t o m e r   � 
 
         S E L E C T   T O P   1   @ R a n d o m C u s t o m e r I D   =   c u s t o m e r _ i d   
 
         F R O M   c u s t o m e r   O R D E R   B Y   N E W I D ( ) ; 
 
 
 
         - -   T � m   h �
p   �
n g   c �
a   k h � c h   h � n g   � ,   n �
u   k h � c h   c h �a   c �   h �
p   �
n g   t h �   l �
y   �
i   1   h �
p   �
n g   b �
t   k �
  c �   s �
n 
 
         S E L E C T   T O P   1   @ R a n d o m C o n t r a c t I D   =   c u s t o m e r _ c o n t r a c t _ i d   
 
         F R O M   c u s t o m e r _ c o n t r a c t   
 
         W H E R E   c u s t o m e r _ i d   =   @ R a n d o m C u s t o m e r I D ; 
 
 
 
         I F   @ R a n d o m C o n t r a c t I D   I S   N U L L 
 
         B E G I N 
 
                 S E L E C T   T O P   1   @ R a n d o m C o n t r a c t I D   =   c u s t o m e r _ c o n t r a c t _ i d   F R O M   c u s t o m e r _ c o n t r a c t   O R D E R   B Y   N E W I D ( ) ; 
 
         E N D 
 
 
 
         - -   2 .   L �
y   n g �
u   n h i � n   1   n h � n   v i � n   t �
o   �n   ( R o l e   A d m i n / M a n a g e r / S a l e . . . ) 
 
         S E L E C T   T O P   1   @ R a n d o m U s e r I D   =   u s e r _ i d   F R O M   [ u s e r ]   W H E R E   r o l e _ i d   I N   ( 1 ,   2 ,   4 ,   5 )   O R D E R   B Y   N E W I D ( ) ; 
 
 
 
         - -   3 .   G � n   t r �
n g   t h � i   n g �
u   n h i � n 
 
         S E T   @ S t a t u s   =   C A S E   W H E N   @ L o o p   %   4   =   0   T H E N   ' C o m p l e t e d ' 
 
                                               W H E N   @ L o o p   %   4   =   1   T H E N   ' P r o c e s s i n g ' 
 
                                               W H E N   @ L o o p   %   4   =   2   T H E N   ' P e n d i n g ' 
 
                                               E L S E   ' C a n c e l l e d '   E N D ; 
 
 
 
         - -   4 .   C h � n   v � o   b �
n g   c u s t o m e r _ o r d e r 
 
         I N S E R T   I N T O   c u s t o m e r _ o r d e r   ( c u s t o m e r _ i d ,   c u s t o m e r _ c o n t r a c t _ i d ,   o r d e r _ s t a t u s ,   c r e a t e d _ b y ,   c r e a t e d _ a t ) 
 
         V A L U E S   ( 
 
                 @ R a n d o m C u s t o m e r I D ,   
 
                 @ R a n d o m C o n t r a c t I D ,   
 
                 @ S t a t u s ,   
 
                 @ R a n d o m U s e r I D ,   
 
                 D A T E A D D ( M I N U T E ,   - @ L o o p   *   3 0 ,   G E T D A T E ( ) ) 
 
         ) ; 
 
 
 
         - -   L �
y   I D   c �
a   �n   h � n g   v �
a   c h � n   �
  d � n g   c h o   b �
n g   c h i   t i �
t 
 
         S E T   @ N e w O r d e r I D   =   S C O P E _ I D E N T I T Y ( ) ; 
 
 
 
         - -   5 .   C h � n   t �
  1   �
n   2   s �
n   p h �
m   c h i   t i �
t   c h o   �n   h � n g   n � y 
 
         D E C L A R E   @ P r o d L o o p   I N T   =   1 ; 
 
         D E C L A R E   @ N u m O f P r o d u c t s   I N T   =   C A S E   W H E N   @ L o o p   %   3   =   0   T H E N   2   E L S E   1   E N D ; 
 
 
 
         W H I L E   @ P r o d L o o p   < =   @ N u m O f P r o d u c t s 
 
         B E G I N 
 
                 - -   L �
y   n g �
u   n h i � n   1   s �
n   p h �
m   t h �
c   t �
  a n g   c �   t r o n g   b �
n g   p r o d u c t 
 
                 S E L E C T   T O P   1   
 
                         @ R a n d o m P r o d u c t I D   =   p r o d u c t _ i d , 
 
                         @ R a n d o m U s e r I D   =   u p d a t e d _ b y   - -   T �
m   m ��
n   b i �
n   �
  �
  t �
o   n h i �
u ,   t h �
c   t �
  l �
y   c o s t / s e l l i n g   p r i c e 
 
                 F R O M   p r o d u c t   
 
                 W H E R E   p r o d u c t _ i d   N O T   I N   ( 
 
                         - -   T r � n h   t r � n g   s �
n   p h �
m   t r o n g   c � n g   1   �n   h � n g 
 
                         S E L E C T   p r o d u c t _ i d   F R O M   c u s t o m e r _ o r d e r _ d e t a i l   W H E R E   c u s t o m e r _ o r d e r _ i d   =   @ N e w O r d e r I D 
 
                 ) 
 
                 O R D E R   B Y   N E W I D ( ) ; 
 
 
 
                 - -   N �
u   t � m   t h �
y   s �
n   p h �
m   h �
p   l �
  t h �   c h � n   v � o   c h i   t i �
t 
 
                 I F   @ R a n d o m P r o d u c t I D   I S   N O T   N U L L 
 
                 B E G I N 
 
                         I N S E R T   I N T O   c u s t o m e r _ o r d e r _ d e t a i l   ( c u s t o m e r _ o r d e r _ i d ,   p r o d u c t _ i d ,   q u a n t i t y ,   c o s t _ p r i c e ,   s e l l i n g _ p r i c e ) 
 
                         S E L E C T   
 
                                 @ N e w O r d e r I D ,   
 
                                 p r o d u c t _ i d ,   
 
                                 ( C A S E   W H E N   @ L o o p   %   2   =   0   T H E N   2   E L S E   5   E N D ) ,   - -   S �
  l ��
n g   n g �
u   n h i � n   2   h o �
c   5 
 
                                 c o s t _ p r i c e ,   
 
                                 s e l l i n g _ p r i c e 
 
                         F R O M   p r o d u c t   
 
                         W H E R E   p r o d u c t _ i d   =   @ R a n d o m P r o d u c t I D ; 
 
                 E N D 
 
 
 
                 S E T   @ P r o d L o o p   =   @ P r o d L o o p   +   1 ; 
 
         E N D 
 
 
 
         S E T   @ L o o p   =   @ L o o p   +   1 ; 
 
 E N D ; 
 
 G O 
 
 
 
 - -   K i �
m   t r a   l �
i   x e m   �   �
  3 0   d � n g   c h �a 
 
 S E L E C T   ' T �
n g   s �
  �n   h � n g '   A S   [ B �
n g ] ,   C O U N T ( * )   A S   [ S �
  l ��
n g ]   F R O M   c u s t o m e r _ o r d e r 
 
 U N I O N   A L L 
 
 S E L E C T   ' T �
n g   s �
  c h i   t i �
t   �n '   A S   [ B �
n g ] ,   C O U N T ( * )   A S   [ S �
  l ��
n g ]   F R O M   c u s t o m e r _ o r d e r _ d e t a i l ; 
 
 G O 
 
 
 
 s e l e c t   *   f r o m   [ u s e r ] 
 
 s e l e c t   *   f r o m   [ C u s t o m e r ] 
 
 U P D A T E   c u s t o m e r 
 
 S E T   c u s t o m e r _ t y p e   =   ' L O Y A L   C U S T O M E R ' 
 
 W H E R E   c u s t o m e r _ t y p e   =   ' B 2 B ' ; 
 
 G O 
 
 
 
 U S E   S W P _ S a l e s _ P r o c e s s ; 
 
 G O 
 
 
 
 
