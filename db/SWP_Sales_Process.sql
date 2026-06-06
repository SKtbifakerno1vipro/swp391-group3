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
    contract_status VARCHAR(20),
    contract_version NVARCHAR(50),
    signed_at DATETIME,
    created_by INT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (quotation_id) REFERENCES quotation(quotation_id),
    FOREIGN KEY (created_by) REFERENCES [user](user_id)
);
GO

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
GO

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
GO

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
GO

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
GO

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
GO

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
GO

-- 18. Stock Transaction
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

-- Tao Role
INSERT INTO role (role_name, status) VALUES 
(N'System Admin', 'Active'),
(N'Manager', 'Active'),
(N'Customer', 'Active'),
(N'Sale Staff', 'Active'),
(N'Admin Officer', 'Active'),
(N'Warehouse Staff', 'Active');
GO

-- Tao tai khoan nhan vien noi bo
INSERT INTO [user] (user_name, password_hash, email, gender, full_name, phone, account_status, role_id) VALUES 
('admin_01', '123', 'admin@bakery.com', 'M', N'Trần Quản Trị', '0901000001', 'ACTIVE', 1),
('manager_01', '123', 'manager@bakery.com', 'F', N'Lê Quản Lý', '0901000002', 'ACTIVE', 2),
('sale_01', '123', 'sale1@bakery.com', 'M', N'Phạm Sale Một', '0901000003', 'ACTIVE', 4),
('sale_02', '123', 'sale2@bakery.com', 'F', N'Nguyễn Sale Hai', '0901000004', 'ACTIVE', 4),
('admin_officer', '123', 'officer@bakery.com', 'F', N'Võ Chứng Từ', '0901000005', 'ACTIVE', 5),
('warehouse_01', '123', 'warehouse@bakery.com', 'M', N'Đinh Thủ Kho', '0901000006', 'ACTIVE', 6);
GO

-- Tao danh muc san pham
INSERT INTO category (category_name) VALUES 
(N'Bột Mì (Flour)'),
(N'Đường & Chất tạo ngọt'),
(N'Bơ & Phô Mai (Dairy)'),
(N'Hương liệu & Gia vị'),
(N'Men & Bột Nở');
GO

-- Tao san pham
INSERT INTO product (product_name, cost_price, selling_price, description, unit, product_status, reorder_level, quantity_available, updated_by, category_id) VALUES 
(N'Bột Mì Đa Dụng Meizan', 15000, 22000, N'Bột mì chuyên dụng làm bánh quy, bánh ngọt', N'Kg', 'ACTIVE', 50, 500, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 1),
(N'Bột Mì B Bakers Choice', 18000, 25000, N'Bột mì dai, làm bánh mì lát', N'Kg', 'ACTIVE', 50, 300, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 1),
(N'Đường Kính Trắng Biên Hòa', 18000, 24000, N'Đường tinh luyện, dễ hòa tan', N'Kg', 'ACTIVE', 100, 1000, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 2),
(N'Bơ Lạt Anchor (Unsalted)', 150000, 185000, N'Bơ lạt nhập khẩu New Zealand', N'Khối 5kg', 'ACTIVE', 10, 50, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 3),
(N'Phô Mai Cream Cheese Philadelphia', 200000, 250000, N'Phô mai chuyên làm Cheesecake', N'Hộp 1kg', 'ACTIVE', 20, 100, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 3),
(N'Men Khô Mauri', 80000, 110000, N'Men lạt kích nở nhanh', N'Gói 500g', 'ACTIVE', 30, 200, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 5);
GO

-- Tao quyen Permission
INSERT INTO permission (permission_name) VALUES 
('/dashboard'),
('/product/list'),
('/product/edit'),
('/quotation/create'),
('/contract/generate'),
('/contract/approve');
GO

-- Gan quyen cho Role
INSERT INTO role_permission (role_id, permission_id) VALUES 
(2, 1), (2, 2), (2, 3), (2, 6),
(4, 1), (4, 2), (4, 4),
(5, 1), (5, 2), (5, 5);
GO

-- Tao tai khoan khach hang
INSERT INTO [user] (user_name, password_hash, email, gender, date_of_birth, full_name, address, phone, account_status, role_id) VALUES 
('khachhang_01', '123', 'customer01@gmail.com', 'M', '1990-01-01', N'Nguyễn Văn Một', N'1 Đại Cồ Việt, Hà Nội', '0981000001', 'ACTIVE', 3),
('khachhang_02', '123', 'customer02@gmail.com', 'F', '1991-02-02', N'Trần Thị Hai', N'2 Lê Thanh Nghị, Hà Nội', '0981000002', 'ACTIVE', 3),
('khachhang_03', '123', 'customer03@gmail.com', 'M', '1992-03-03', N'Phạm Văn Ba', N'3 Giải Phóng, Hà Nội', '0981000003', 'ACTIVE', 3),
('khachhang_04', '123', 'customer04@gmail.com', 'F', '1993-04-04', N'Lê Thị Bốn', N'4 Trần Đại Nghĩa, Hà Nội', '0981000004', 'ACTIVE', 3),
('khachhang_05', '123', 'customer05@gmail.com', 'M', '1994-05-05', N'Hoàng Văn Năm', N'5 Phố Huế, Hà Nội', '0981000005', 'ACTIVE', 3);
GO

-- Tao thong tin khach hang
INSERT INTO customer (tax_code, customer_type, company_name, user_id, assigned_to_user_id) VALUES 
('0390000001', 'B2B', N'Công ty TNHH Một Thành Viên', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
('0390000002', 'B2C', N'Cửa hàng Bán lẻ Hai Thủy', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_02'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
('0390000003', 'B2B', N'Công ty Cổ phần Xây dựng Ba Đình', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_03'), (SELECT user_id FROM [user] WHERE user_name = 'sale_02')),
('0390000004', 'B2B', N'Tập đoàn May mặc Bốn Phương', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_04'), (SELECT user_id FROM [user] WHERE user_name = 'sale_02')),
('0390000005', 'B2C', N'Đại lý Phân phối Năm Sao', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_05'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01'));
GO

-- Tao bao gia
INSERT INTO quotation (customer_id, quotation_date, quotation_status, created_by) VALUES 
((SELECT customer_id FROM customer WHERE tax_code = '0390000001'), GETDATE(), 'ACCEPTED', (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
((SELECT customer_id FROM customer WHERE tax_code = '0390000002'), GETDATE(), 'PENDING', (SELECT user_id FROM [user] WHERE user_name = 'sale_01'));
GO

-- Tao chi tiet bao gia
DECLARE @Q1_ID INT = (SELECT MIN(quotation_id) FROM quotation);
DECLARE @Q2_ID INT = (SELECT MAX(quotation_id) FROM quotation);

INSERT INTO quotation_detail (quotation_id, product_id, quantity, selling_price, discount_percent, tax_percent) VALUES 
(@Q1_ID, (SELECT product_id FROM product WHERE product_name LIKE N'%Meizan%'), 100, 22000, 5.0, 10.0),
(@Q1_ID, (SELECT product_id FROM product WHERE product_name LIKE N'%Biên Hòa%'), 50, 24000, 0, 10.0),
(@Q2_ID, (SELECT product_id FROM product WHERE product_name LIKE N'%Philadelphia%'), 10, 250000, 10.0, 10.0);
GO

-- Tao lich su bao gia
DECLARE @Q1_ID_H INT = (SELECT MIN(quotation_id) FROM quotation);

INSERT INTO quotation_history (quotation_id, created_by, edit_history) VALUES 
(@Q1_ID_H, (SELECT user_id FROM [user] WHERE user_name = 'sale_01'), N'Tạo mới báo giá'),
(@Q1_ID_H, (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'), N'Khách hàng đồng ý báo giá');
GO

-- Tao hop dong khach hang
DECLARE @Q1_ID_C INT = (SELECT MIN(quotation_id) FROM quotation);

INSERT INTO customer_contract (customer_id, quotation_id, contract_number, contract_file_url, contract_status, contract_version, created_by) VALUES 
((SELECT customer_id FROM customer WHERE tax_code = '0390000001'), @Q1_ID_C, 'HD-2026-001', '/uploads/contracts/HD-2026-001.pdf', 'APPROVED', 'v1.0', (SELECT user_id FROM [user] WHERE user_name = 'admin_officer'));
GO

-- Tao lich su chinh sua hop dong
DECLARE @Contract_ID INT = (SELECT MAX(customer_contract_id) FROM customer_contract);

INSERT INTO contract_edit_history (contract_id, from_status, to_status, changed_by, reason, comment) VALUES 
(@Contract_ID, NULL, 'DRAFT', (SELECT user_id FROM [user] WHERE user_name = 'admin_officer'), N'Tạo hợp đồng nháp', N'Khách VIP ABC, đơn hàng lớn, đề xuất chiết khấu 5% như Sale báo. Kho còn đủ hàng.'),
(@Contract_ID, 'DRAFT', 'APPROVED', (SELECT user_id FROM [user] WHERE user_name = 'manager_01'), N'Phê duyệt hợp đồng', N'Đồng ý các điều khoản. Tiến hành gửi khách ký.');
GO

-- Tao chu ky
DECLARE @Contract_ID_S INT = (SELECT MAX(customer_contract_id) FROM customer_contract);

INSERT INTO signature (customer_contract_id, file_name, file_url, signer_user_id, signer_name, signer_type, uploaded_by) VALUES 
(@Contract_ID_S, 'sign_khachhang.png', '/uploads/signatures/sign_kh.png', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'), N'Nguyễn Văn Một', 'CUSTOMER', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01')),
(@Contract_ID_S, 'sign_manager.png', '/uploads/signatures/sign_mgr.png', (SELECT user_id FROM [user] WHERE user_name = 'manager_01'), N'Lê Quản Lý', 'COMPANY_REPRESENTATIVE', (SELECT user_id FROM [user] WHERE user_name = 'admin_officer'));
GO

-- Tao don hang
DECLARE @Contract_ID_O INT = (SELECT MAX(customer_contract_id) FROM customer_contract);

INSERT INTO customer_order (customer_id, customer_contract_id, order_status, created_by) VALUES 
((SELECT customer_id FROM customer WHERE tax_code = '0390000001'), @Contract_ID_O, 'PENDING_PACKING', (SELECT user_id FROM [user] WHERE user_name = 'admin_officer'));
GO

-- Tao chi tiet don hang
DECLARE @Order_ID INT = (SELECT MAX(customer_order_id) FROM customer_order);

INSERT INTO customer_order_detail (customer_order_id, product_id, quantity, cost_price, selling_price) VALUES 
(@Order_ID, (SELECT product_id FROM product WHERE product_name LIKE N'%Meizan%'), 100, 15000, 22000),
(@Order_ID, (SELECT product_id FROM product WHERE product_name LIKE N'%Biên Hòa%'), 50, 18000, 24000);
GO

-- Tao hoa don
INSERT INTO invoice (customer_contract_id, customer_order_id, invoice_no, issue_date, invoice_status, created_by) VALUES 
((SELECT MAX(customer_contract_id) FROM customer_contract), (SELECT MAX(customer_order_id) FROM customer_order), 'INV-2026-0001', GETDATE(), 'ISSUED', (SELECT user_id FROM [user] WHERE user_name = 'admin_officer'));
GO

-- Tao thanh toan
INSERT INTO payment (customer_contract_id, invoice_id, amount, payment_type, payment_status, paid_at, created_by) VALUES 
((SELECT MAX(customer_contract_id) FROM customer_contract), (SELECT MAX(invoice_id) FROM invoice), 3000000, 'ONLINE_VNPAY', 'COMPLETED', GETDATE(), (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'));
GO

-- Lich su giao dich kho
INSERT INTO stock_transaction (product_id, transaction_type, quantity_in, quantity_out, customer_order_id) VALUES 
((SELECT product_id FROM product WHERE product_name LIKE N'%Meizan%'), 'INITIAL_STOCK', 500, 0, NULL),
((SELECT product_id FROM product WHERE product_name LIKE N'%Meizan%'), 'SALES_ORDER', 0, 100, (SELECT MAX(customer_order_id) FROM customer_order)),
((SELECT product_id FROM product WHERE product_name LIKE N'%Biên Hòa%'), 'INITIAL_STOCK', 1000, 0, NULL),
((SELECT product_id FROM product WHERE product_name LIKE N'%Biên Hòa%'), 'SALES_ORDER', 0, 50, (SELECT MAX(customer_order_id) FROM customer_order));
GO

-- Update product stock after sales order
UPDATE product SET quantity_available = quantity_available - 100 WHERE product_name LIKE N'%Meizan%';
UPDATE product SET quantity_available = quantity_available - 50 WHERE product_name LIKE N'%Biên Hòa%';
GO
