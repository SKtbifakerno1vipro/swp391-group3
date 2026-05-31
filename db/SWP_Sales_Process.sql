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

select * from [user]
select * from [customer]
USE SWP_Sales_Process;
GO

-- ====================================================================================
-- BƯỚC 1: TẠO CÁC TÀI KHOẢN [user] CHO KHÁCH HÀNG (Mỗi khách hàng cần 1 tài khoản login riêng)
-- Lưu ý: role_id = 3 đại diện cho vai trò 'Customer' như bạn đã định nghĩa ở phần INSERT gốc
-- ====================================================================================
INSERT INTO [user] (user_name, password_hash, email, gender, date_of_birth, full_name, address, phone, account_status, role_id) VALUES 
('khachhang_b', 'hash_4', 'info@companyb.com', 'F', '1992-05-15', N'Nguyễn Thị Bình', N'123 Nguyễn Du, Hà Nội', '0933333333', 'ACTIVE', 3),
('khachhang_c', 'hash_5', 'contact@companyc.vn', 'M', '1988-10-20', N'Phạm Minh Chính', N'456 Lê Lợi, TP.HCM', '0944444444', 'ACTIVE', 3),
('khachhang_d', 'hash_6', 'hello@companyd.com', 'O', '1995-02-28', N'Trần Anh Dương', N'789 Trần Hưng Đạo, Đà Nẵng', '0955555555', 'ACTIVE', 3),
('khachhang_e', 'hash_7', 'office@companye.vn', 'F', '1990-12-05', N'Lê Hoàng Yến', N'101 Điện Biên Phủ, Hải Phòng', '0966666666', 'ACTIVE', 3),
('khachhang_f', 'hash_8', 'support@companyf.com', 'M', '1985-07-19', N'Vũ Hoàng Phúc', N'202 Quang Trung, Cần Thơ', '0977777777', 'ACTIVE', 3);
GO

-- ====================================================================================
-- BƯỚC 2: TẠO THÔNG TIN DOANH NGHIỆP TRONG BẢNG [customer]
-- Sử dụng câu lệnh sub-query SELECT để tự động tìm đúng user_id vừa tạo theo tên đăng nhập,
-- tránh việc phải gõ cứng (hardcode) ID số tăng tự động.
-- Mặc định assigned_to_user_id = 2 (Nhân viên Sales phụ trách chăm sóc)
-- ====================================================================================
INSERT INTO customer (tax_code, customer_type, company_name, user_id, assigned_to_user_id) VALUES 

('0312345679', 'B2B', N'Công ty TNHH Thương mại B', 
  (SELECT user_id FROM [user] WHERE user_name = 'khachhang_b'), 2),

('0312345680', 'B2C', N'Khách hàng Cá nhân Phạm Minh Chính', 
  (SELECT user_id FROM [user] WHERE user_name = 'khachhang_c'), 2),

('0312345681', 'B2B', N'Tập đoàn Công nghệ D', 
  (SELECT user_id FROM [user] WHERE user_name = 'khachhang_d'), 2),

('0312345682', 'B2B', N'Công ty Cổ phần Xuất Nhập Khẩu E', 
  (SELECT user_id FROM [user] WHERE user_name = 'khachhang_e'), 2),

('0312345683', 'B2C', N'Cửa hàng Bán lẻ Vũ Hoàng Phúc', 
  (SELECT user_id FROM [user] WHERE user_name = 'khachhang_f'), 2);
GO

-- ====================================================================================
-- BƯỚC 3: KIỂM TRA LẠI DỮ LIỆU SAU KHI CHÈN
-- ====================================================================================
SELECT 
    c.customer_id, 
    c.company_name, 
    c.tax_code, 
    c.customer_type, 
    u.user_name AS [Account_Login], 
    u.full_name AS [Owner_Name],
    u.phone,
    u.email
FROM customer c
INNER JOIN [user] u ON c.user_id = u.user_id;
GO

USE SWP_Sales_Process;
GO

-- ====================================================================================
-- BƯỚC 1: TẠO 15 TÀI KHOẢN [user] CHO KHÁCH HÀNG (role_id = 3)
-- Tên đăng nhập chạy từ khachhang_01 đến khachhang_15
-- ====================================================================================
INSERT INTO [user] (user_name, password_hash, email, gender, date_of_birth, full_name, address, phone, account_status, role_id) VALUES 
('khachhang_01', 'hash_01', 'customer01@gmail.com', 'M', '1990-01-01', N'Nguyễn Văn Một', N'1 Đại Cồ Việt, Hà Nội', '0981000001', 'ACTIVE', 3),
('khachhang_02', 'hash_02', 'customer02@gmail.com', 'F', '1991-02-02', N'Trần Thị Hai', N'2 Lê Thanh Nghị, Hà Nội', '0981000002', 'ACTIVE', 3),
('khachhang_03', 'hash_03', 'customer03@gmail.com', 'M', '1992-03-03', N'Phạm Văn Ba', N'3 Giải Phóng, Hà Nội', '0981000003', 'ACTIVE', 3),
('khachhang_04', 'hash_04', 'customer04@gmail.com', 'F', '1993-04-04', N'Lê Thị Bốn', N'4 Trần Đại Nghĩa, Hà Nội', '0981000004', 'ACTIVE', 3),
('khachhang_05', 'hash_05', 'customer05@gmail.com', 'M', '1994-05-05', N'Hoàng Văn Năm', N'5 Phố Huế, Hà Nội', '0981000005', 'ACTIVE', 3),
('khachhang_06', 'hash_06', 'customer06@gmail.com', 'F', '1995-06-06', N'Vũ Thị Sáu', N'6 Hàng Bài, Hà Nội', '0981000006', 'ACTIVE', 3),
('khachhang_07', 'hash_07', 'customer07@gmail.com', 'M', '1996-07-07', N'Đặng Văn Bảy', N'7 Đinh Tiên Hoàng, Hà Nội', '0981000007', 'ACTIVE', 3),
('khachhang_08', 'hash_08', 'customer08@gmail.com', 'F', '1997-08-08', N'Bùi Thị Tám', N'8 Nguyễn Du, Hà Nội', '0981000008', 'ACTIVE', 3),
('khachhang_09', 'hash_09', 'customer09@gmail.com', 'M', '1998-09-09', N'Đỗ Văn Chín', N'9 Bà Triệu, Hà Nội', '0981000009', 'ACTIVE', 3),
('khachhang_10', 'hash_10', 'customer10@gmail.com', 'F', '1999-10-10', N'Ngô Thị Mười', N'10 Quang Trung, Hà Nội', '0981000010', 'ACTIVE', 3),
('khachhang_11', 'hash_11', 'customer11@gmail.com', 'M', '2000-11-11', N'Lý Văn Mười Một', N'11 Tràng Thi, Hà Nội', '0981000011', 'ACTIVE', 3),
('khachhang_12', 'hash_12', 'customer12@gmail.com', 'F', '2001-12-12', N'Đoàn Thị Mười Hai', N'12 Điện Biên Phủ, Hà Nội', '0981000012', 'ACTIVE', 3),
('khachhang_13', 'hash_13', 'customer13@gmail.com', 'M', '1991-05-20', N'Phùng Văn Mười Ba', N'13 Kim Mã, Hà Nội', '0981000013', 'ACTIVE', 3),
('khachhang_14', 'hash_14', 'customer14@gmail.com', 'F', '1992-06-25', N'Tô Thị Mười Bốn', N'14 Nguyễn Thái Học, Hà Nội', '0981000014', 'ACTIVE', 3),
('khachhang_15', 'hash_15', 'customer15@gmail.com', 'M', '1993-07-30', N'Đinh Văn Mười Lăm', N'15 Liễu Giai, Hà Nội', '0981000015', 'ACTIVE', 3);
GO

-- ====================================================================================
-- BƯỚC 2: TẠO THÔNG TIN DOANH NGHIỆP TRONG BẢNG customer TƯƠNG ỨNG
-- Sử dụng SELECT lồng để tự tìm user_id theo user_name vừa tạo ở trên
-- Phân công mặc định cho nhân viên Sales có id = 2 phụ trách chăm sóc
-- ====================================================================================
INSERT INTO customer (tax_code, customer_type, company_name, user_id, assigned_to_user_id) VALUES 
('0390000001', 'B2B', N'Công ty TNHH Một Thành Viên', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'), 2),
('0390000002', 'B2C', N'Cửa hàng Bán lẻ Hai Thủy', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_02'), 2),
('0390000003', 'B2B', N'Công ty Cổ phần Xây dựng Ba Đình', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_03'), 2),
('0390000004', 'B2B', N'Tập đoàn May mặc Bốn Phương', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_04'), 2),
('0390000005', 'B2C', N'Đại lý Phân phối Năm Sao', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_05'), 2),
('0390000006', 'B2B', N'Công ty TNHH Logistics Sáu Tấm', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_06'), 2),
('0390000007', 'B2B', N'Doanh nghiệp Tư nhân Bảy Hiền', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_07'), 2),
('0390000008', 'B2C', N'Cửa hàng Thực phẩm Sạch Tám Oanh', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_08'), 2),
('0390000009', 'B2B', N'Công ty Cổ phần Đầu tư Chín Chín', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_09'), 2),
('0390000010', 'B2B', N'Tập đoàn Xuất Nhập Khẩu Mười Điểm', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_10'), 2),
('0390000011', 'B2C', N'Nhà thuốc Tư nhân Mười Một', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_11'), 2),
('0390000012', 'B2B', N'Công ty TNHH Công nghệ Mười Hai', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_12'), 2),
('0390000013', 'B2B', N'Hợp tác xã Nông nghiệp Mười Ba', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_13'), 2),
('0390000014', 'B2C', N'Cửa hàng Thời trang Mười Bốn', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_14'), 2),
('0390000015', 'B2B', N'Chuỗi Siêu thị Điện máy Mười Lăm', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_15'), 2);
GO

-- ====================================================================================
-- BƯỚC 3: XEM TOÀN BỘ DANH SÁCH CUSTOMER DTO (Giống hệt câu query trong hàm getAllCustomerDTOs)
-- ====================================================================================
SELECT 
    c.customer_id, 
    c.tax_code, 
    c.customer_type, 
    c.company_name, 
    c.user_id, 
    c.assigned_to_user_id, 
    c.created_at, 
    c.updated_at, 
    u.user_id AS u_id, 
    u.full_name, 
    u.email, 
    u.phone, 
    u.account_status, 
    u.user_name,
    u.role_id
FROM customer c 
LEFT JOIN [user] u ON c.user_id = u.user_id;
GO