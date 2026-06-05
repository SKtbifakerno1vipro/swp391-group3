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





-- =============================================================================-- BU?C 1: T?O 6 ROLE CHU?N (Kh?p 100% v?i tài li?u và so d? phân quy?n m?i)
-- =============================================================================INSERT INTO role (role_name) VALUES 
(N'System Admin'),       -- ID = 1
(N'Manager'),            -- ID = 2
(N'Customer'),           -- ID = 3
(N'Sale Staff'),         -- ID = 4
(N'Admin Officer'),      -- ID = 5
(N'Warehouse Staff');    -- ID = 6
GO

-- =============================================================================-- BU?C 2: T?O TÀI KHO?N NHÂN VIÊN N?I B? (Ð? test AuthZ)
-- M?t kh?u gi? d?nh ? dây là '123'
-- =============================================================================INSERT INTO [user] (user_name, password_hash, email, gender, full_name, phone, account_status, role_id) VALUES 
('admin_01', '123', 'admin@bakery.com', 'M', N'Tr?n Qu?n Tr?', '0901000001', 'ACTIVE', 1),
('manager_01', '123', 'manager@bakery.com', 'F', N'Lê Qu?n Lý', '0901000002', 'ACTIVE', 2),
('sale_01', '123', 'sale1@bakery.com', 'M', N'Ph?m Sale M?t', '0901000003', 'ACTIVE', 4),
('sale_02', '123', 'sale2@bakery.com', 'F', N'Nguy?n Sale Hai', '0901000004', 'ACTIVE', 4),
('admin_officer', '123', 'officer@bakery.com', 'F', N'Võ Ch?ng T?', '0901000005', 'ACTIVE', 5),
('warehouse_01', '123', 'warehouse@bakery.com', 'M', N'Ðinh Th? Kho', '0901000006', 'ACTIVE', 6);
GO

-- =============================================================================-- BU?C 3: T?O DANH M?C S?N PH?M (Category)
-- =============================================================================INSERT INTO category (category_name) VALUES 
(N'B?t Mì (Flour)'),            -- ID = 1
(N'Ðu?ng & Ch?t t?o ng?t'),      -- ID = 2
(N'Bo & Phô Mai (Dairy)'),       -- ID = 3
(N'Huong li?u & Gia v?'),        -- ID = 4
(N'Men & B?t N?');               -- ID = 5
GO

-- =============================================================================-- BU?C 4: T?O S?N PH?M (Product)
-- =============================================================================INSERT INTO product (product_name, cost_price, selling_price, description, unit, product_status, reorder_level, quantity_available, updated_by, category_id) VALUES 
(N'B?t Mì Ða D?ng Meizan', 15000, 22000, N'B?t mì chuyên d?ng làm bánh quy, bánh ng?t', N'Kg', 'ACTIVE', 50, 500, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 1),
(N'B?t Mì B Bakers Choice', 18000, 25000, N'B?t mì dai, làm bánh mì l?t', N'Kg', 'ACTIVE', 50, 300, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 1),
(N'Ðu?ng Kính Tr?ng Biên Hòa', 18000, 24000, N'Ðu?ng tinh luy?n, d? hòa tan', N'Kg', 'ACTIVE', 100, 1000, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 2),
(N'Bo L?t Anchor (Unsalted)', 150000, 185000, N'Bo l?t nh?p kh?u New Zealand', N'Kh?i 5kg', 'ACTIVE', 10, 50, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 3),
(N'Phô Mai Cream Cheese Philadelphia', 200000, 250000, N'Phô mai chuyên làm Cheesecake', N'H?p 1kg', 'ACTIVE', 20, 100, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 3),
(N'Men Khô Mauri', 80000, 110000, N'Men l?t kích n? nhanh', N'Gói 500g', 'ACTIVE', 30, 200, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 5);
GO

-- =============================================================================-- BU?C 5: T?O PERMISSION (Các URL ho?c Feature chính)
-- =============================================================================INSERT INTO permission (permission_name) VALUES 


-- =============================================================================-- BÆ¯á»šC 1: Táº O 6 ROLE CHUáº¨N (Khá»›p 100% vá»›i tÃ i liá»‡u vÃ  sÆ¡ Ä‘á»“ phÃ¢n quyá»n má»›i)
-- =============================================================================INSERT INTO role (role_name) VALUES 
(N'System Admin'),       -- ID = 1
(N'Manager'),            -- ID = 2
(N'Customer'),           -- ID = 3
(N'Sale Staff'),         -- ID = 4
(N'Admin Officer'),      -- ID = 5
(N'Warehouse Staff');    -- ID = 6
GO

-- =============================================================================-- BÆ¯á»šC 2: Táº O TÃ€I KHOáº¢N NHÃ‚N VIÃŠN Ná»˜I Bá»˜ (Äá»ƒ test AuthZ)
-- Máº­t kháº©u giáº£ Ä‘á»‹nh á»Ÿ Ä‘Ã¢y lÃ  '123'
-- =============================================================================INSERT INTO [user] (user_name, password_hash, email, gender, full_name, phone, account_status, role_id) VALUES 
('admin_01', '123', 'admin@bakery.com', 'M', N'Tráº§n Quáº£n Trá»‹', '0901000001', 'ACTIVE', 1),
('manager_01', '123', 'manager@bakery.com', 'F', N'LÃª Quáº£n LÃ½', '0901000002', 'ACTIVE', 2),
('sale_01', '123', 'sale1@bakery.com', 'M', N'Pháº¡m Sale Má»™t', '0901000003', 'ACTIVE', 4),
('sale_02', '123', 'sale2@bakery.com', 'F', N'Nguyá»…n Sale Hai', '0901000004', 'ACTIVE', 4),
('admin_officer', '123', 'officer@bakery.com', 'F', N'VÃµ Chá»©ng Tá»«', '0901000005', 'ACTIVE', 5),
('warehouse_01', '123', 'warehouse@bakery.com', 'M', N'Äinh Thá»§ Kho', '0901000006', 'ACTIVE', 6);
GO

-- =============================================================================-- BÆ¯á»šC 3: Táº O DANH Má»¤C Sáº¢N PHáº¨M (Category)
-- =============================================================================INSERT INTO category (category_name) VALUES 
(N'Bá»™t MÃ¬ (Flour)'),            -- ID = 1
(N'ÄÆ°á»ng & Cháº¥t táº¡o ngá»t'),      -- ID = 2
(N'BÆ¡ & PhÃ´ Mai (Dairy)'),       -- ID = 3
(N'HÆ°Æ¡ng liá»‡u & Gia vá»‹'),        -- ID = 4
(N'Men & Bá»™t Ná»Ÿ');               -- ID = 5
GO

-- =============================================================================-- BÆ¯á»šC 4: Táº O Sáº¢N PHáº¨M (Product)
-- =============================================================================INSERT INTO product (product_name, cost_price, selling_price, description, unit, product_status, reorder_level, quantity_available, updated_by, category_id) VALUES 
(N'Bá»™t MÃ¬ Äa Dá»¥ng Meizan', 15000, 22000, N'Bá»™t mÃ¬ chuyÃªn dá»¥ng lÃ m bÃ¡nh quy, bÃ¡nh ngá»t', N'Kg', 'ACTIVE', 50, 500, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 1),
(N'Bá»™t MÃ¬ B Bakers Choice', 18000, 25000, N'Bá»™t mÃ¬ dai, lÃ m bÃ¡nh mÃ¬ láº¡t', N'Kg', 'ACTIVE', 50, 300, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 1),
(N'ÄÆ°á»ng KÃ­nh Tráº¯ng BiÃªn HÃ²a', 18000, 24000, N'ÄÆ°á»ng tinh luyá»‡n, dá»… hÃ²a tan', N'Kg', 'ACTIVE', 100, 1000, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 2),
(N'BÆ¡ Láº¡t Anchor (Unsalted)', 150000, 185000, N'BÆ¡ láº¡t nháº­p kháº©u New Zealand', N'Khá»‘i 5kg', 'ACTIVE', 10, 50, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 3),
(N'PhÃ´ Mai Cream Cheese Philadelphia', 200000, 250000, N'PhÃ´ mai chuyÃªn lÃ m Cheesecake', N'Há»™p 1kg', 'ACTIVE', 20, 100, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 3),
(N'Men KhÃ´ Mauri', 80000, 110000, N'Men láº¡t kÃ­ch ná»Ÿ nhanh', N'GÃ³i 500g', 'ACTIVE', 30, 200, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 5);
GO

-- =============================================================================-- BÆ¯á»šC 5: Táº O PERMISSION (CÃ¡c URL hoáº·c Feature chÃ­nh)
-- =============================================================================INSERT INTO permission (permission_name) VALUES 
('/dashboard'),             -- ID = 1
('/product/list'),          -- ID = 2
('/product/edit'),          -- ID = 3
('/quotation/create'),      -- ID = 4
('/contract/generate'),     -- ID = 5
('/contract/approve');      -- ID = 6
GO

-- =============================================================================-- BU?C 6: GÁN QUY?N CHO ROLE (Role_Permission)
-- =============================================================================INSERT INTO role_permission (role_id, permission_id) VALUES 
-- =============================================================================-- BÆ¯á»šC 6: GÃN QUYá»€N CHO ROLE (Role_Permission)
-- =============================================================================INSERT INTO role_permission (role_id, permission_id) VALUES 
(2, 1), (2, 2), (2, 3), (2, 6),
(4, 1), (4, 2), (4, 4),
(5, 1), (5, 2), (5, 5);
GO

-- =============================================================================-- BU?C 7: T?O TÀI KHO?N [user] CHO KHÁCH HÀNG (role_id = 3)
-- =============================================================================INSERT INTO [user] (user_name, password_hash, email, gender, date_of_birth, full_name, address, phone, account_status, role_id) VALUES 
('khachhang_01', '123', 'customer01@gmail.com', 'M', '1990-01-01', N'Nguy?n Van M?t', N'1 Ð?i C? Vi?t, Hà N?i', '0981000001', 'ACTIVE', 3),
('khachhang_02', '123', 'customer02@gmail.com', 'F', '1991-02-02', N'Tr?n Th? Hai', N'2 Lê Thanh Ngh?, Hà N?i', '0981000002', 'ACTIVE', 3),
('khachhang_03', '123', 'customer03@gmail.com', 'M', '1992-03-03', N'Ph?m Van Ba', N'3 Gi?i Phóng, Hà N?i', '0981000003', 'ACTIVE', 3),
('khachhang_04', '123', 'customer04@gmail.com', 'F', '1993-04-04', N'Lê Th? B?n', N'4 Tr?n Ð?i Nghia, Hà N?i', '0981000004', 'ACTIVE', 3),
('khachhang_05', '123', 'customer05@gmail.com', 'M', '1994-05-05', N'Hoàng Van Nam', N'5 Ph? Hu?, Hà N?i', '0981000005', 'ACTIVE', 3);
GO

-- =============================================================================-- BU?C 8: THÔNG TIN CHI TI?T KHÁCH HÀNG (Customer)
-- =============================================================================INSERT INTO customer (tax_code, customer_type, company_name, user_id, assigned_to_user_id) VALUES 
('0390000001', 'B2B', N'Công ty TNHH M?t Thành Viên', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
('0390000002', 'B2C', N'C?a hàng Bán l? Hai Th?y', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_02'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
('0390000003', 'B2B', N'Công ty C? ph?n Xây d?ng Ba Ðình', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_03'), (SELECT user_id FROM [user] WHERE user_name = 'sale_02')),
('0390000004', 'B2B', N'T?p doàn May m?c B?n Phuong', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_04'), (SELECT user_id FROM [user] WHERE user_name = 'sale_02')),
('0390000005', 'B2C', N'Ð?i lý Phân ph?i Nam Sao', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_05'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01'));
GO

-- =============================================================================-- BU?C 9: BÁO GIÁ (Quotation)
-- =============================================================================INSERT INTO quotation (customer_id, quotation_date, quotation_status, created_by) VALUES 

-- =============================================================================-- BÆ¯á»šC 7: Táº O TÃ€I KHOáº¢N [user] CHO KHÃCH HÃ€NG (role_id = 3)
-- =============================================================================INSERT INTO [user] (user_name, password_hash, email, gender, date_of_birth, full_name, address, phone, account_status, role_id) VALUES 
('khachhang_01', '123', 'customer01@gmail.com', 'M', '1990-01-01', N'Nguyá»…n VÄƒn Má»™t', N'1 Äáº¡i Cá»“ Viá»‡t, HÃ  Ná»™i', '0981000001', 'ACTIVE', 3),
('khachhang_02', '123', 'customer02@gmail.com', 'F', '1991-02-02', N'Tráº§n Thá»‹ Hai', N'2 LÃª Thanh Nghá»‹, HÃ  Ná»™i', '0981000002', 'ACTIVE', 3),
('khachhang_03', '123', 'customer03@gmail.com', 'M', '1992-03-03', N'Pháº¡m VÄƒn Ba', N'3 Giáº£i PhÃ³ng, HÃ  Ná»™i', '0981000003', 'ACTIVE', 3),
('khachhang_04', '123', 'customer04@gmail.com', 'F', '1993-04-04', N'LÃª Thá»‹ Bá»‘n', N'4 Tráº§n Äáº¡i NghÄ©a, HÃ  Ná»™i', '0981000004', 'ACTIVE', 3),
('khachhang_05', '123', 'customer05@gmail.com', 'M', '1994-05-05', N'HoÃ ng VÄƒn NÄƒm', N'5 Phá»‘ Huáº¿, HÃ  Ná»™i', '0981000005', 'ACTIVE', 3);
GO

-- =============================================================================-- BÆ¯á»šC 8: THÃ”NG TIN CHI TIáº¾T KHÃCH HÃ€NG (Customer)
-- =============================================================================INSERT INTO customer (tax_code, customer_type, company_name, user_id, assigned_to_user_id) VALUES 
('0390000001', 'B2B', N'CÃ´ng ty TNHH Má»™t ThÃ nh ViÃªn', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
('0390000002', 'B2C', N'Cá»­a hÃ ng BÃ¡n láº» Hai Thá»§y', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_02'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
('0390000003', 'B2B', N'CÃ´ng ty Cá»• pháº§n XÃ¢y dá»±ng Ba ÄÃ¬nh', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_03'), (SELECT user_id FROM [user] WHERE user_name = 'sale_02')),
('0390000004', 'B2B', N'Táº­p Ä‘oÃ n May máº·c Bá»‘n PhÆ°Æ¡ng', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_04'), (SELECT user_id FROM [user] WHERE user_name = 'sale_02')),
('0390000005', 'B2C', N'Äáº¡i lÃ½ PhÃ¢n phá»‘i NÄƒm Sao', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_05'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01'));
GO

-- =============================================================================-- BÆ¯á»šC 9: BÃO GIÃ (Quotation)
-- =============================================================================INSERT INTO quotation (customer_id, quotation_date, quotation_status, created_by) VALUES 
((SELECT customer_id FROM customer WHERE tax_code = '0390000001'), GETDATE(), 'ACCEPTED', (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
((SELECT customer_id FROM customer WHERE tax_code = '0390000002'), GETDATE(), 'PENDING', (SELECT user_id FROM [user] WHERE user_name = 'sale_01'));
GO

-- =============================================================================-- BU?C 10: CHI TI?T BÁO GIÁ (Quotation_Detail)
-- =============================================================================DECLARE @Q1_ID INT = (SELECT MIN(quotation_id) FROM quotation);
-- =============================================================================-- BÆ¯á»šC 10: CHI TIáº¾T BÃO GIÃ (Quotation_Detail)
-- =============================================================================DECLARE @Q1_ID INT = (SELECT MIN(quotation_id) FROM quotation);
DECLARE @Q2_ID INT = (SELECT MAX(quotation_id) FROM quotation);

INSERT INTO quotation_detail (quotation_id, product_id, quantity, selling_price, discount_percent, tax_percent) VALUES 
(@Q1_ID, (SELECT product_id FROM product WHERE product_name LIKE N'%Meizan%'), 100, 22000, 5.0, 10.0),
(@Q1_ID, (SELECT product_id FROM product WHERE product_name LIKE N'%Biên Hòa%'), 50, 24000, 0, 10.0),
(@Q2_ID, (SELECT product_id FROM product WHERE product_name LIKE N'%Philadelphia%'), 10, 250000, 10.0, 10.0);
GO

-- =============================================================================-- BU?C 11: L?CH S? BÁO GIÁ (Quotation_History)
-- =============================================================================DECLARE @Q1_ID_H INT = (SELECT MIN(quotation_id) FROM quotation);
INSERT INTO quotation_history (quotation_id, created_by, edit_history) VALUES 
(@Q1_ID_H, (SELECT user_id FROM [user] WHERE user_name = 'sale_01'), N'T?o m?i báo giá'),
(@Q1_ID_H, (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'), N'Khách hàng d?ng ý báo giá');
GO

-- =============================================================================-- BU?C 12: H?P Ð?NG KHÁCH HÀNG (Customer_Contract)
-- =============================================================================DECLARE @Q1_ID_C INT = (SELECT MIN(quotation_id) FROM quotation);
(@Q1_ID, (SELECT product_id FROM product WHERE product_name LIKE N'%BiÃªn HÃ²a%'), 50, 24000, 0, 10.0),
(@Q2_ID, (SELECT product_id FROM product WHERE product_name LIKE N'%Philadelphia%'), 10, 250000, 10.0, 10.0);
GO

-- =============================================================================-- BÆ¯á»šC 11: Lá»ŠCH Sá»¬ BÃO GIÃ (Quotation_History)
-- =============================================================================DECLARE @Q1_ID_H INT = (SELECT MIN(quotation_id) FROM quotation);
INSERT INTO quotation_history (quotation_id, created_by, edit_history) VALUES 
(@Q1_ID_H, (SELECT user_id FROM [user] WHERE user_name = 'sale_01'), N'Táº¡o má»›i bÃ¡o giÃ¡'),
(@Q1_ID_H, (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'), N'KhÃ¡ch hÃ ng Ä‘á»“ng Ã½ bÃ¡o giÃ¡');
GO

-- =============================================================================-- BÆ¯á»šC 12: Há»¢P Äá»’NG KHÃCH HÃ€NG (Customer_Contract)
-- =============================================================================DECLARE @Q1_ID_C INT = (SELECT MIN(quotation_id) FROM quotation);

INSERT INTO customer_contract (customer_id, quotation_id, contract_number, contract_file_url, contract_status, contract_version, created_by) VALUES 
((SELECT customer_id FROM customer WHERE tax_code = '0390000001'), @Q1_ID_C, 'HD-2026-001', '/uploads/contracts/HD-2026-001.pdf', 'APPROVED', 'v1.0', (SELECT user_id FROM [user] WHERE user_name = 'admin_officer'));
GO

-- =============================================================================-- BU?C 13: L?CH S? CH?NH S?A H?P Ð?NG (Contract_Edit_History)
-- =============================================================================DECLARE @Contract_ID INT = (SELECT MAX(customer_contract_id) FROM customer_contract);

INSERT INTO contract_edit_history (contract_id, from_status, to_status, changed_by, reason, comment) VALUES 
(@Contract_ID, NULL, 'DRAFT', (SELECT user_id FROM [user] WHERE user_name = 'admin_officer'), N'T?o h?p d?ng nháp', N'Khách VIP ABC, don hàng l?n, d? xu?t chi?t kh?u 5% nhu Sale báo. Kho còn d? hàng.'),
(@Contract_ID, 'DRAFT', 'APPROVED', (SELECT user_id FROM [user] WHERE user_name = 'manager_01'), N'Phê duy?t h?p d?ng', N'Ð?ng ý các di?u kho?n. Ti?n hành g?i khách ký.');
GO

-- =============================================================================-- BU?C 14: CH? KÝ (Signature)
-- =============================================================================DECLARE @Contract_ID_S INT = (SELECT MAX(customer_contract_id) FROM customer_contract);

INSERT INTO signature (customer_contract_id, file_name, file_url, signer_user_id, signer_name, signer_type, uploaded_by) VALUES 
(@Contract_ID_S, 'sign_khachhang.png', '/uploads/signatures/sign_kh.png', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'), N'Nguy?n Van M?t', 'CUSTOMER', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01')),
(@Contract_ID_S, 'sign_manager.png', '/uploads/signatures/sign_mgr.png', (SELECT user_id FROM [user] WHERE user_name = 'manager_01'), N'Lê Qu?n Lý', 'COMPANY_REPRESENTATIVE', (SELECT user_id FROM [user] WHERE user_name = 'admin_officer'));
GO

-- =============================================================================-- BU?C 15: ÐON HÀNG (Customer_Order)
-- =============================================================================DECLARE @Contract_ID_O INT = (SELECT MAX(customer_contract_id) FROM customer_contract);
-- =============================================================================-- BÆ¯á»šC 13: Lá»ŠCH Sá»¬ CHá»ˆNH Sá»¬A Há»¢P Äá»’NG (Contract_Edit_History)
-- =============================================================================DECLARE @Contract_ID INT = (SELECT MAX(customer_contract_id) FROM customer_contract);

INSERT INTO contract_edit_history (contract_id, from_status, to_status, changed_by, reason, comment) VALUES 
(@Contract_ID, NULL, 'DRAFT', (SELECT user_id FROM [user] WHERE user_name = 'admin_officer'), N'Táº¡o há»£p Ä‘á»“ng nhÃ¡p', N'KhÃ¡ch VIP ABC, Ä‘Æ¡n hÃ ng lá»›n, Ä‘á» xuáº¥t chiáº¿t kháº¥u 5% nhÆ° Sale bÃ¡o. Kho cÃ²n Ä‘á»§ hÃ ng.'),
(@Contract_ID, 'DRAFT', 'APPROVED', (SELECT user_id FROM [user] WHERE user_name = 'manager_01'), N'PhÃª duyá»‡t há»£p Ä‘á»“ng', N'Äá»“ng Ã½ cÃ¡c Ä‘iá»u khoáº£n. Tiáº¿n hÃ nh gá»­i khÃ¡ch kÃ½.');
GO

-- =============================================================================-- BÆ¯á»šC 14: CHá»® KÃ (Signature)
-- =============================================================================DECLARE @Contract_ID_S INT = (SELECT MAX(customer_contract_id) FROM customer_contract);

INSERT INTO signature (customer_contract_id, file_name, file_url, signer_user_id, signer_name, signer_type, uploaded_by) VALUES 
(@Contract_ID_S, 'sign_khachhang.png', '/uploads/signatures/sign_kh.png', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'), N'Nguyá»…n VÄƒn Má»™t', 'CUSTOMER', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01')),
(@Contract_ID_S, 'sign_manager.png', '/uploads/signatures/sign_mgr.png', (SELECT user_id FROM [user] WHERE user_name = 'manager_01'), N'LÃª Quáº£n LÃ½', 'COMPANY_REPRESENTATIVE', (SELECT user_id FROM [user] WHERE user_name = 'admin_officer'));
GO

-- =============================================================================-- BÆ¯á»šC 15: ÄÆ N HÃ€NG (Customer_Order)
-- =============================================================================DECLARE @Contract_ID_O INT = (SELECT MAX(customer_contract_id) FROM customer_contract);

INSERT INTO customer_order (customer_id, customer_contract_id, order_status, created_by) VALUES 
((SELECT customer_id FROM customer WHERE tax_code = '0390000001'), @Contract_ID_O, 'PENDING_PACKING', (SELECT user_id FROM [user] WHERE user_name = 'admin_officer'));
GO

-- =============================================================================-- BU?C 16: CHI TI?T ÐON HÀNG (Customer_Order_Detail)
-- =============================================================================DECLARE @Order_ID INT = (SELECT MAX(customer_order_id) FROM customer_order);

INSERT INTO customer_order_detail (customer_order_id, product_id, quantity, cost_price, selling_price) VALUES 
(@Order_ID, (SELECT product_id FROM product WHERE product_name LIKE N'%Meizan%'), 100, 15000, 22000),
(@Order_ID, (SELECT product_id FROM product WHERE product_name LIKE N'%Biên Hòa%'), 50, 18000, 24000);
GO

-- =============================================================================-- BU?C 17: HÓA ÐON & THANH TOÁN (Invoice & Payment)
-- =============================================================================-- T?o Hóa don d? VAT (Mô ph?ng ? Giai do?n 2)
-- =============================================================================-- BÆ¯á»šC 16: CHI TIáº¾T ÄÆ N HÃ€NG (Customer_Order_Detail)
-- =============================================================================DECLARE @Order_ID INT = (SELECT MAX(customer_order_id) FROM customer_order);

INSERT INTO customer_order_detail (customer_order_id, product_id, quantity, cost_price, selling_price) VALUES 
(@Order_ID, (SELECT product_id FROM product WHERE product_name LIKE N'%Meizan%'), 100, 15000, 22000),
(@Order_ID, (SELECT product_id FROM product WHERE product_name LIKE N'%BiÃªn HÃ²a%'), 50, 18000, 24000);
GO

-- =============================================================================-- BÆ¯á»šC 17: HÃ“A ÄÆ N & THANH TOÃN (Invoice & Payment)
-- =============================================================================-- Táº¡o HÃ³a Ä‘Æ¡n Ä‘á» VAT (MÃ´ phá»ng á»Ÿ Giai Ä‘oáº¡n 2)
INSERT INTO invoice (customer_contract_id, customer_order_id, invoice_no, issue_date, invoice_status, created_by) VALUES 
((SELECT MAX(customer_contract_id) FROM customer_contract), (SELECT MAX(customer_order_id) FROM customer_order), 'INV-2026-0001', GETDATE(), 'ISSUED', (SELECT user_id FROM [user] WHERE user_name = 'admin_officer'));
GO

-- Th?c hi?n thanh toán qua VNPay (mô ph?ng)
-- Thá»±c hiá»‡n thanh toÃ¡n qua VNPay (mÃ´ phá»ng)
INSERT INTO payment (customer_contract_id, invoice_id, amount, payment_type, payment_status, paid_at, created_by) VALUES 
((SELECT MAX(customer_contract_id) FROM customer_contract), (SELECT MAX(invoice_id) FROM invoice), 3000000, 'ONLINE_VNPAY', 'COMPLETED', GETDATE(), (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'));
GO

-- =============================================================================-- BU?C 18: L?CH S? GIAO D?CH KHO (Stock Transaction)
-- =============================================================================-- T?o l?ch s? giao d?ch ban d?u (Initial Stock) và xu?t bán hàng
INSERT INTO stock_transaction (product_id, transaction_type, quantity_in, quantity_out, customer_order_id) VALUES 
((SELECT product_id FROM product WHERE product_name LIKE N'%Meizan%'), 'INITIAL_STOCK', 500, 0, NULL),
((SELECT product_id FROM product WHERE product_name LIKE N'%Meizan%'), 'SALES_ORDER', 0, 100, (SELECT MAX(customer_order_id) FROM customer_order)),
((SELECT product_id FROM product WHERE product_name LIKE N'%Biên Hòa%'), 'INITIAL_STOCK', 1000, 0, NULL),
((SELECT product_id FROM product WHERE product_name LIKE N'%Biên Hòa%'), 'SALES_ORDER', 0, 50, (SELECT MAX(customer_order_id) FROM customer_order));
GO

-- C?p nh?t l?i kho kh? d?ng (Kh?u tr? kho v?t lý)
UPDATE product SET quantity_available = quantity_available - 100 WHERE product_name LIKE N'%Meizan%';
UPDATE product SET quantity_available = quantity_available - 50 WHERE product_name LIKE N'%Biên Hòa%';
-- =============================================================================-- BÆ¯á»šC 18: Lá»ŠCH Sá»¬ GIAO Dá»ŠCH KHO (Stock Transaction)
-- =============================================================================-- Táº¡o lá»‹ch sá»­ giao dá»‹ch ban Ä‘áº§u (Initial Stock) vÃ  xuáº¥t bÃ¡n hÃ ng
INSERT INTO stock_transaction (product_id, transaction_type, quantity_in, quantity_out, customer_order_id) VALUES 
((SELECT product_id FROM product WHERE product_name LIKE N'%Meizan%'), 'INITIAL_STOCK', 500, 0, NULL),
((SELECT product_id FROM product WHERE product_name LIKE N'%Meizan%'), 'SALES_ORDER', 0, 100, (SELECT MAX(customer_order_id) FROM customer_order)),
((SELECT product_id FROM product WHERE product_name LIKE N'%BiÃªn HÃ²a%'), 'INITIAL_STOCK', 1000, 0, NULL),
((SELECT product_id FROM product WHERE product_name LIKE N'%BiÃªn HÃ²a%'), 'SALES_ORDER', 0, 50, (SELECT MAX(customer_order_id) FROM customer_order));
GO

-- Cáº­p nháº­t láº¡i kho kháº£ dá»¥ng (Kháº¥u trá»« kho váº­t lÃ½)
UPDATE product SET quantity_available = quantity_available - 100 WHERE product_name LIKE N'%Meizan%';
UPDATE product SET quantity_available = quantity_available - 50 WHERE product_name LIKE N'%BiÃªn HÃ²a%';
GO


select * from [user]
select * from [customer]

UPDATE [user]
SET phone = '0981234567'
WHERE user_id = 24;

-- Bước 1: Xóa dữ liệu trong bảng customer trước
DELETE FROM [customer] 
WHERE user_id = 55;

-- Bước 2: Xóa dữ liệu trong bảng user sau
DELETE FROM [user] 
WHERE user_id = 55;

UPDATE [user]
set role_id = 1 from [user]
where user_id = 56