?IF DB_ID('SWP_Sales_Process') IS NULL
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





-- =============================================================================-- BU?C 1: T?O 6 ROLE CHU?N (Kh?p 100% v?i t�i li?u v� so d? ph�n quy?n m?i)
-- =============================================================================INSERT INTO role (role_name) VALUES 
(N'System Admin'),       -- ID = 1
(N'Manager'),            -- ID = 2
(N'Customer'),           -- ID = 3
(N'Sale Staff'),         -- ID = 4
(N'Admin Officer'),      -- ID = 5
(N'Warehouse Staff');    -- ID = 6
GO

-- =============================================================================-- BU?C 2: T?O T�I KHO?N NH�N VI�N N?I B? (�? test AuthZ)
-- M?t kh?u gi? d?nh ? d�y l� '123'
-- =============================================================================INSERT INTO [user] (user_name, password_hash, email, gender, full_name, phone, account_status, role_id) VALUES 
('admin_01', '123', 'admin@bakery.com', 'M', N'Tr?n Qu?n Tr?', '0901000001', 'ACTIVE', 1),
('manager_01', '123', 'manager@bakery.com', 'F', N'L� Qu?n L�', '0901000002', 'ACTIVE', 2),
('sale_01', '123', 'sale1@bakery.com', 'M', N'Ph?m Sale M?t', '0901000003', 'ACTIVE', 4),
('sale_02', '123', 'sale2@bakery.com', 'F', N'Nguy?n Sale Hai', '0901000004', 'ACTIVE', 4),
('admin_officer', '123', 'officer@bakery.com', 'F', N'V� Ch?ng T?', '0901000005', 'ACTIVE', 5),
('warehouse_01', '123', 'warehouse@bakery.com', 'M', N'�inh Th? Kho', '0901000006', 'ACTIVE', 6);
GO

-- =============================================================================-- BU?C 3: T?O DANH M?C S?N PH?M (Category)
-- =============================================================================INSERT INTO category (category_name) VALUES 
(N'B?t M� (Flour)'),            -- ID = 1
(N'�u?ng & Ch?t t?o ng?t'),      -- ID = 2
(N'Bo & Ph� Mai (Dairy)'),       -- ID = 3
(N'Huong li?u & Gia v?'),        -- ID = 4
(N'Men & B?t N?');               -- ID = 5
GO

-- =============================================================================-- BU?C 4: T?O S?N PH?M (Product)
-- =============================================================================INSERT INTO product (product_name, cost_price, selling_price, description, unit, product_status, reorder_level, quantity_available, updated_by, category_id) VALUES 
(N'B?t M� �a D?ng Meizan', 15000, 22000, N'B?t m� chuy�n d?ng l�m b�nh quy, b�nh ng?t', N'Kg', 'ACTIVE', 50, 500, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 1),
(N'B?t M� B Bakers Choice', 18000, 25000, N'B?t m� dai, l�m b�nh m� l?t', N'Kg', 'ACTIVE', 50, 300, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 1),
(N'�u?ng K�nh Tr?ng Bi�n H�a', 18000, 24000, N'�u?ng tinh luy?n, d? h�a tan', N'Kg', 'ACTIVE', 100, 1000, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 2),
(N'Bo L?t Anchor (Unsalted)', 150000, 185000, N'Bo l?t nh?p kh?u New Zealand', N'Kh?i 5kg', 'ACTIVE', 10, 50, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 3),
(N'Ph� Mai Cream Cheese Philadelphia', 200000, 250000, N'Ph� mai chuy�n l�m Cheesecake', N'H?p 1kg', 'ACTIVE', 20, 100, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 3),
(N'Men Kh� Mauri', 80000, 110000, N'Men l?t k�ch n? nhanh', N'G�i 500g', 'ACTIVE', 30, 200, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 5);
GO

-- =============================================================================-- BU?C 5: T?O PERMISSION (C�c URL ho?c Feature ch�nh)
-- =============================================================================INSERT INTO permission (permission_name) VALUES 


-- =============================================================================-- BƯỚC 1: TẠO 6 ROLE CHUẨN (Khớp 100% với tài liệu và sơ đồ phân quyền mới)
-- =============================================================================INSERT INTO role (role_name) VALUES 
(N'System Admin'),       -- ID = 1
(N'Manager'),            -- ID = 2
(N'Customer'),           -- ID = 3
(N'Sale Staff'),         -- ID = 4
(N'Admin Officer'),      -- ID = 5
(N'Warehouse Staff');    -- ID = 6
GO

-- =============================================================================-- BƯỚC 2: TẠO TÀI KHOẢN NHÂN VIÊN NỘI BỘ (Để test AuthZ)
-- Mật khẩu giả định ở đây là '123'
-- =============================================================================INSERT INTO [user] (user_name, password_hash, email, gender, full_name, phone, account_status, role_id) VALUES 
('admin_01', '123', 'admin@bakery.com', 'M', N'Trần Quản Trị', '0901000001', 'ACTIVE', 1),
('manager_01', '123', 'manager@bakery.com', 'F', N'Lê Quản Lý', '0901000002', 'ACTIVE', 2),
('sale_01', '123', 'sale1@bakery.com', 'M', N'Phạm Sale Một', '0901000003', 'ACTIVE', 4),
('sale_02', '123', 'sale2@bakery.com', 'F', N'Nguyễn Sale Hai', '0901000004', 'ACTIVE', 4),
('admin_officer', '123', 'officer@bakery.com', 'F', N'Võ Chứng Từ', '0901000005', 'ACTIVE', 5),
('warehouse_01', '123', 'warehouse@bakery.com', 'M', N'Đinh Thủ Kho', '0901000006', 'ACTIVE', 6);
GO

-- =============================================================================-- BƯỚC 3: TẠO DANH MỤC SẢN PHẨM (Category)
-- =============================================================================INSERT INTO category (category_name) VALUES 
(N'Bột Mì (Flour)'),            -- ID = 1
(N'Đường & Chất tạo ngọt'),      -- ID = 2
(N'Bơ & Phô Mai (Dairy)'),       -- ID = 3
(N'Hương liệu & Gia vị'),        -- ID = 4
(N'Men & Bột Nở');               -- ID = 5
GO

-- =============================================================================-- BƯỚC 4: TẠO SẢN PHẨM (Product)
-- =============================================================================INSERT INTO product (product_name, cost_price, selling_price, description, unit, product_status, reorder_level, quantity_available, updated_by, category_id) VALUES 
(N'Bột Mì Đa Dụng Meizan', 15000, 22000, N'Bột mì chuyên dụng làm bánh quy, bánh ngọt', N'Kg', 'ACTIVE', 50, 500, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 1),
(N'Bột Mì B Bakers Choice', 18000, 25000, N'Bột mì dai, làm bánh mì lạt', N'Kg', 'ACTIVE', 50, 300, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 1),
(N'Đường Kính Trắng Biên Hòa', 18000, 24000, N'Đường tinh luyện, dễ hòa tan', N'Kg', 'ACTIVE', 100, 1000, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 2),
(N'Bơ Lạt Anchor (Unsalted)', 150000, 185000, N'Bơ lạt nhập khẩu New Zealand', N'Khối 5kg', 'ACTIVE', 10, 50, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 3),
(N'Phô Mai Cream Cheese Philadelphia', 200000, 250000, N'Phô mai chuyên làm Cheesecake', N'Hộp 1kg', 'ACTIVE', 20, 100, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 3),
(N'Men Khô Mauri', 80000, 110000, N'Men lạt kích nở nhanh', N'Gói 500g', 'ACTIVE', 30, 200, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 5);
GO

-- =============================================================================-- BƯỚC 5: TẠO PERMISSION (Các URL hoặc Feature chính)
-- =============================================================================INSERT INTO permission (permission_name) VALUES 
('/dashboard'),             -- ID = 1
('/product/list'),          -- ID = 2
('/product/edit'),          -- ID = 3
('/quotation/create'),      -- ID = 4
('/contract/generate'),     -- ID = 5
('/contract/approve');      -- ID = 6
GO

-- =============================================================================-- BU?C 6: G�N QUY?N CHO ROLE (Role_Permission)
-- =============================================================================INSERT INTO role_permission (role_id, permission_id) VALUES 
-- =============================================================================-- BƯỚC 6: GÁN QUYỀN CHO ROLE (Role_Permission)
-- =============================================================================INSERT INTO role_permission (role_id, permission_id) VALUES 
(2, 1), (2, 2), (2, 3), (2, 6),
(4, 1), (4, 2), (4, 4),
(5, 1), (5, 2), (5, 5);
GO

-- =============================================================================-- BU?C 7: T?O T�I KHO?N [user] CHO KH�CH H�NG (role_id = 3)
-- =============================================================================INSERT INTO [user] (user_name, password_hash, email, gender, date_of_birth, full_name, address, phone, account_status, role_id) VALUES 
('khachhang_01', '123', 'customer01@gmail.com', 'M', '1990-01-01', N'Nguy?n Van M?t', N'1 �?i C? Vi?t, H� N?i', '0981000001', 'ACTIVE', 3),
('khachhang_02', '123', 'customer02@gmail.com', 'F', '1991-02-02', N'Tr?n Th? Hai', N'2 L� Thanh Ngh?, H� N?i', '0981000002', 'ACTIVE', 3),
('khachhang_03', '123', 'customer03@gmail.com', 'M', '1992-03-03', N'Ph?m Van Ba', N'3 Gi?i Ph�ng, H� N?i', '0981000003', 'ACTIVE', 3),
('khachhang_04', '123', 'customer04@gmail.com', 'F', '1993-04-04', N'L� Th? B?n', N'4 Tr?n �?i Nghia, H� N?i', '0981000004', 'ACTIVE', 3),
('khachhang_05', '123', 'customer05@gmail.com', 'M', '1994-05-05', N'Ho�ng Van Nam', N'5 Ph? Hu?, H� N?i', '0981000005', 'ACTIVE', 3);
GO

-- =============================================================================-- BU?C 8: TH�NG TIN CHI TI?T KH�CH H�NG (Customer)
-- =============================================================================INSERT INTO customer (tax_code, customer_type, company_name, user_id, assigned_to_user_id) VALUES 
('0390000001', 'B2B', N'C�ng ty TNHH M?t Th�nh Vi�n', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
('0390000002', 'B2C', N'C?a h�ng B�n l? Hai Th?y', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_02'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
('0390000003', 'B2B', N'C�ng ty C? ph?n X�y d?ng Ba ��nh', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_03'), (SELECT user_id FROM [user] WHERE user_name = 'sale_02')),
('0390000004', 'B2B', N'T?p do�n May m?c B?n Phuong', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_04'), (SELECT user_id FROM [user] WHERE user_name = 'sale_02')),
('0390000005', 'B2C', N'�?i l� Ph�n ph?i Nam Sao', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_05'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01'));
GO

-- =============================================================================-- BU?C 9: B�O GI� (Quotation)
-- =============================================================================INSERT INTO quotation (customer_id, quotation_date, quotation_status, created_by) VALUES 

-- =============================================================================-- BƯỚC 7: TẠO TÀI KHOẢN [user] CHO KHÁCH HÀNG (role_id = 3)
-- =============================================================================INSERT INTO [user] (user_name, password_hash, email, gender, date_of_birth, full_name, address, phone, account_status, role_id) VALUES 
('khachhang_01', '123', 'customer01@gmail.com', 'M', '1990-01-01', N'Nguyễn Văn Một', N'1 Đại Cồ Việt, Hà Nội', '0981000001', 'ACTIVE', 3),
('khachhang_02', '123', 'customer02@gmail.com', 'F', '1991-02-02', N'Trần Thị Hai', N'2 Lê Thanh Nghị, Hà Nội', '0981000002', 'ACTIVE', 3),
('khachhang_03', '123', 'customer03@gmail.com', 'M', '1992-03-03', N'Phạm Văn Ba', N'3 Giải Phóng, Hà Nội', '0981000003', 'ACTIVE', 3),
('khachhang_04', '123', 'customer04@gmail.com', 'F', '1993-04-04', N'Lê Thị Bốn', N'4 Trần Đại Nghĩa, Hà Nội', '0981000004', 'ACTIVE', 3),
('khachhang_05', '123', 'customer05@gmail.com', 'M', '1994-05-05', N'Hoàng Văn Năm', N'5 Phố Huế, Hà Nội', '0981000005', 'ACTIVE', 3);
GO

-- =============================================================================-- BƯỚC 8: THÔNG TIN CHI TIẾT KHÁCH HÀNG (Customer)
-- =============================================================================INSERT INTO customer (tax_code, customer_type, company_name, user_id, assigned_to_user_id) VALUES 
('0390000001', 'B2B', N'Công ty TNHH Một Thành Viên', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
('0390000002', 'B2C', N'Cửa hàng Bán lẻ Hai Thủy', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_02'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
('0390000003', 'B2B', N'Công ty Cổ phần Xây dựng Ba Đình', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_03'), (SELECT user_id FROM [user] WHERE user_name = 'sale_02')),
('0390000004', 'B2B', N'Tập đoàn May mặc Bốn Phương', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_04'), (SELECT user_id FROM [user] WHERE user_name = 'sale_02')),
('0390000005', 'B2C', N'Đại lý Phân phối Năm Sao', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_05'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01'));
GO

-- =============================================================================-- BƯỚC 9: BÁO GIÁ (Quotation)
-- =============================================================================INSERT INTO quotation (customer_id, quotation_date, quotation_status, created_by) VALUES 
((SELECT customer_id FROM customer WHERE tax_code = '0390000001'), GETDATE(), 'ACCEPTED', (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
((SELECT customer_id FROM customer WHERE tax_code = '0390000002'), GETDATE(), 'PENDING', (SELECT user_id FROM [user] WHERE user_name = 'sale_01'));
GO

-- =============================================================================-- BU?C 10: CHI TI?T B�O GI� (Quotation_Detail)
-- =============================================================================DECLARE @Q1_ID INT = (SELECT MIN(quotation_id) FROM quotation);
-- =============================================================================-- BƯỚC 10: CHI TIẾT BÁO GIÁ (Quotation_Detail)
-- =============================================================================DECLARE @Q1_ID INT = (SELECT MIN(quotation_id) FROM quotation);
DECLARE @Q2_ID INT = (SELECT MAX(quotation_id) FROM quotation);

INSERT INTO quotation_detail (quotation_id, product_id, quantity, selling_price, discount_percent, tax_percent) VALUES 
(@Q1_ID, (SELECT product_id FROM product WHERE product_name LIKE N'%Meizan%'), 100, 22000, 5.0, 10.0),
(@Q1_ID, (SELECT product_id FROM product WHERE product_name LIKE N'%Bi�n H�a%'), 50, 24000, 0, 10.0),
(@Q2_ID, (SELECT product_id FROM product WHERE product_name LIKE N'%Philadelphia%'), 10, 250000, 10.0, 10.0);
GO

-- =============================================================================-- BU?C 11: L?CH S? B�O GI� (Quotation_History)
-- =============================================================================DECLARE @Q1_ID_H INT = (SELECT MIN(quotation_id) FROM quotation);
INSERT INTO quotation_history (quotation_id, created_by, edit_history) VALUES 
(@Q1_ID_H, (SELECT user_id FROM [user] WHERE user_name = 'sale_01'), N'T?o m?i b�o gi�'),
(@Q1_ID_H, (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'), N'Kh�ch h�ng d?ng � b�o gi�');
GO

-- =============================================================================-- BU?C 12: H?P �?NG KH�CH H�NG (Customer_Contract)
-- =============================================================================DECLARE @Q1_ID_C INT = (SELECT MIN(quotation_id) FROM quotation);
(@Q1_ID, (SELECT product_id FROM product WHERE product_name LIKE N'%Biên Hòa%'), 50, 24000, 0, 10.0),
(@Q2_ID, (SELECT product_id FROM product WHERE product_name LIKE N'%Philadelphia%'), 10, 250000, 10.0, 10.0);
GO

-- =============================================================================-- BƯỚC 11: LỊCH SỬ BÁO GIÁ (Quotation_History)
-- =============================================================================DECLARE @Q1_ID_H INT = (SELECT MIN(quotation_id) FROM quotation);
INSERT INTO quotation_history (quotation_id, created_by, edit_history) VALUES 
(@Q1_ID_H, (SELECT user_id FROM [user] WHERE user_name = 'sale_01'), N'Tạo mới báo giá'),
(@Q1_ID_H, (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'), N'Khách hàng đồng ý báo giá');
GO

-- =============================================================================-- BƯỚC 12: HỢP ĐỒNG KHÁCH HÀNG (Customer_Contract)
-- =============================================================================DECLARE @Q1_ID_C INT = (SELECT MIN(quotation_id) FROM quotation);

INSERT INTO customer_contract (customer_id, quotation_id, contract_number, contract_file_url, contract_status, contract_version, created_by) VALUES 
((SELECT customer_id FROM customer WHERE tax_code = '0390000001'), @Q1_ID_C, 'HD-2026-001', '/uploads/contracts/HD-2026-001.pdf', 'APPROVED', 'v1.0', (SELECT user_id FROM [user] WHERE user_name = 'admin_officer'));
GO

-- =============================================================================-- BU?C 13: L?CH S? CH?NH S?A H?P �?NG (Contract_Edit_History)
-- =============================================================================DECLARE @Contract_ID INT = (SELECT MAX(customer_contract_id) FROM customer_contract);

INSERT INTO contract_edit_history (contract_id, from_status, to_status, changed_by, reason, comment) VALUES 
(@Contract_ID, NULL, 'DRAFT', (SELECT user_id FROM [user] WHERE user_name = 'admin_officer'), N'T?o h?p d?ng nh�p', N'Kh�ch VIP ABC, don h�ng l?n, d? xu?t chi?t kh?u 5% nhu Sale b�o. Kho c�n d? h�ng.'),
(@Contract_ID, 'DRAFT', 'APPROVED', (SELECT user_id FROM [user] WHERE user_name = 'manager_01'), N'Ph� duy?t h?p d?ng', N'�?ng � c�c di?u kho?n. Ti?n h�nh g?i kh�ch k�.');
GO

-- =============================================================================-- BU?C 14: CH? K� (Signature)
-- =============================================================================DECLARE @Contract_ID_S INT = (SELECT MAX(customer_contract_id) FROM customer_contract);

INSERT INTO signature (customer_contract_id, file_name, file_url, signer_user_id, signer_name, signer_type, uploaded_by) VALUES 
(@Contract_ID_S, 'sign_khachhang.png', '/uploads/signatures/sign_kh.png', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'), N'Nguy?n Van M?t', 'CUSTOMER', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01')),
(@Contract_ID_S, 'sign_manager.png', '/uploads/signatures/sign_mgr.png', (SELECT user_id FROM [user] WHERE user_name = 'manager_01'), N'L� Qu?n L�', 'COMPANY_REPRESENTATIVE', (SELECT user_id FROM [user] WHERE user_name = 'admin_officer'));
GO

-- =============================================================================-- BU?C 15: �ON H�NG (Customer_Order)
-- =============================================================================DECLARE @Contract_ID_O INT = (SELECT MAX(customer_contract_id) FROM customer_contract);
-- =============================================================================-- BƯỚC 13: LỊCH SỬ CHỈNH SỬA HỢP ĐỒNG (Contract_Edit_History)
-- =============================================================================DECLARE @Contract_ID INT = (SELECT MAX(customer_contract_id) FROM customer_contract);

INSERT INTO contract_edit_history (contract_id, from_status, to_status, changed_by, reason, comment) VALUES 
(@Contract_ID, NULL, 'DRAFT', (SELECT user_id FROM [user] WHERE user_name = 'admin_officer'), N'Tạo hợp đồng nháp', N'Khách VIP ABC, đơn hàng lớn, đề xuất chiết khấu 5% như Sale báo. Kho còn đủ hàng.'),
(@Contract_ID, 'DRAFT', 'APPROVED', (SELECT user_id FROM [user] WHERE user_name = 'manager_01'), N'Phê duyệt hợp đồng', N'Đồng ý các điều khoản. Tiến hành gửi khách ký.');
GO

-- =============================================================================-- BƯỚC 14: CHỮ KÝ (Signature)
-- =============================================================================DECLARE @Contract_ID_S INT = (SELECT MAX(customer_contract_id) FROM customer_contract);

INSERT INTO signature (customer_contract_id, file_name, file_url, signer_user_id, signer_name, signer_type, uploaded_by) VALUES 
(@Contract_ID_S, 'sign_khachhang.png', '/uploads/signatures/sign_kh.png', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'), N'Nguyễn Văn Một', 'CUSTOMER', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01')),
(@Contract_ID_S, 'sign_manager.png', '/uploads/signatures/sign_mgr.png', (SELECT user_id FROM [user] WHERE user_name = 'manager_01'), N'Lê Quản Lý', 'COMPANY_REPRESENTATIVE', (SELECT user_id FROM [user] WHERE user_name = 'admin_officer'));
GO

-- =============================================================================-- BƯỚC 15: ĐƠN HÀNG (Customer_Order)
-- =============================================================================DECLARE @Contract_ID_O INT = (SELECT MAX(customer_contract_id) FROM customer_contract);

INSERT INTO customer_order (customer_id, customer_contract_id, order_status, created_by) VALUES 
((SELECT customer_id FROM customer WHERE tax_code = '0390000001'), @Contract_ID_O, 'PENDING_PACKING', (SELECT user_id FROM [user] WHERE user_name = 'admin_officer'));
GO

-- =============================================================================-- BU?C 16: CHI TI?T �ON H�NG (Customer_Order_Detail)
-- =============================================================================DECLARE @Order_ID INT = (SELECT MAX(customer_order_id) FROM customer_order);

INSERT INTO customer_order_detail (customer_order_id, product_id, quantity, cost_price, selling_price) VALUES 
(@Order_ID, (SELECT product_id FROM product WHERE product_name LIKE N'%Meizan%'), 100, 15000, 22000),
(@Order_ID, (SELECT product_id FROM product WHERE product_name LIKE N'%Bi�n H�a%'), 50, 18000, 24000);
GO

-- =============================================================================-- BU?C 17: H�A �ON & THANH TO�N (Invoice & Payment)
-- =============================================================================-- T?o H�a don d? VAT (M� ph?ng ? Giai do?n 2)
-- =============================================================================-- BƯỚC 16: CHI TIẾT ĐƠN HÀNG (Customer_Order_Detail)
-- =============================================================================DECLARE @Order_ID INT = (SELECT MAX(customer_order_id) FROM customer_order);

INSERT INTO customer_order_detail (customer_order_id, product_id, quantity, cost_price, selling_price) VALUES 
(@Order_ID, (SELECT product_id FROM product WHERE product_name LIKE N'%Meizan%'), 100, 15000, 22000),
(@Order_ID, (SELECT product_id FROM product WHERE product_name LIKE N'%Biên Hòa%'), 50, 18000, 24000);
GO

-- =============================================================================-- BƯỚC 17: HÓA ĐƠN & THANH TOÁN (Invoice & Payment)
-- =============================================================================-- Tạo Hóa đơn đỏ VAT (Mô phỏng ở Giai đoạn 2)
INSERT INTO invoice (customer_contract_id, customer_order_id, invoice_no, issue_date, invoice_status, created_by) VALUES 
((SELECT MAX(customer_contract_id) FROM customer_contract), (SELECT MAX(customer_order_id) FROM customer_order), 'INV-2026-0001', GETDATE(), 'ISSUED', (SELECT user_id FROM [user] WHERE user_name = 'admin_officer'));
GO

-- Th?c hi?n thanh to�n qua VNPay (m� ph?ng)
-- Thực hiện thanh toán qua VNPay (mô phỏng)
INSERT INTO payment (customer_contract_id, invoice_id, amount, payment_type, payment_status, paid_at, created_by) VALUES 
((SELECT MAX(customer_contract_id) FROM customer_contract), (SELECT MAX(invoice_id) FROM invoice), 3000000, 'ONLINE_VNPAY', 'COMPLETED', GETDATE(), (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'));
GO

-- =============================================================================-- BU?C 18: L?CH S? GIAO D?CH KHO (Stock Transaction)
-- =============================================================================-- T?o l?ch s? giao d?ch ban d?u (Initial Stock) v� xu?t b�n h�ng
INSERT INTO stock_transaction (product_id, transaction_type, quantity_in, quantity_out, customer_order_id) VALUES 
((SELECT product_id FROM product WHERE product_name LIKE N'%Meizan%'), 'INITIAL_STOCK', 500, 0, NULL),
((SELECT product_id FROM product WHERE product_name LIKE N'%Meizan%'), 'SALES_ORDER', 0, 100, (SELECT MAX(customer_order_id) FROM customer_order)),
((SELECT product_id FROM product WHERE product_name LIKE N'%Bi�n H�a%'), 'INITIAL_STOCK', 1000, 0, NULL),
((SELECT product_id FROM product WHERE product_name LIKE N'%Bi�n H�a%'), 'SALES_ORDER', 0, 50, (SELECT MAX(customer_order_id) FROM customer_order));
GO

-- C?p nh?t l?i kho kh? d?ng (Kh?u tr? kho v?t l�)
UPDATE product SET quantity_available = quantity_available - 100 WHERE product_name LIKE N'%Meizan%';
UPDATE product SET quantity_available = quantity_available - 50 WHERE product_name LIKE N'%Bi�n H�a%';
-- =============================================================================-- BƯỚC 18: LỊCH SỬ GIAO DỊCH KHO (Stock Transaction)
-- =============================================================================-- Tạo lịch sử giao dịch ban đầu (Initial Stock) và xuất bán hàng
INSERT INTO stock_transaction (product_id, transaction_type, quantity_in, quantity_out, customer_order_id) VALUES 
((SELECT product_id FROM product WHERE product_name LIKE N'%Meizan%'), 'INITIAL_STOCK', 500, 0, NULL),
((SELECT product_id FROM product WHERE product_name LIKE N'%Meizan%'), 'SALES_ORDER', 0, 100, (SELECT MAX(customer_order_id) FROM customer_order)),
((SELECT product_id FROM product WHERE product_name LIKE N'%Biên Hòa%'), 'INITIAL_STOCK', 1000, 0, NULL),
((SELECT product_id FROM product WHERE product_name LIKE N'%Biên Hòa%'), 'SALES_ORDER', 0, 50, (SELECT MAX(customer_order_id) FROM customer_order));
GO

-- Cập nhật lại kho khả dụng (Khấu trừ kho vật lý)
UPDATE product SET quantity_available = quantity_available - 100 WHERE product_name LIKE N'%Meizan%';
UPDATE product SET quantity_available = quantity_available - 50 WHERE product_name LIKE N'%Biên Hòa%';
GO