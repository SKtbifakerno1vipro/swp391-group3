-- 1. TAO ROLE
INSERT INTO role (role_name, status) VALUES 
(N'System Admin', 'Active'),
(N'Manager', 'Active'),
(N'Customer', 'Active'),
(N'Sale Staff', 'Active'),
(N'Admin Officer', 'Active'),
(N'Warehouse Staff', 'Active');
GO
INSERT INTO [user] (user_name, password_hash, email, gender, date_of_birth, full_name, address, phone, account_status, role_id)
VALUES
('admin_01', '1234', 'minh.nguyen1984@gmail.com', 'M', '1984-03-15', N'Nguyễn Quang Minh', N'123 Lê Lợi, Hà Nội', '0912345678', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'System Admin'));
-- 2. TAO TAI KHOAN NHAN VIEN
INSERT INTO [user] (user_name, password_hash, email, gender, date_of_birth, full_name, address, phone, account_status, role_id, created_by, updated_by)
VALUES
('admin_02', '1234', 'huong.tran1987@gmail.com', 'F', '1987-08-22', N'Trần Thu Hương', N'45 Nguyễn Huệ, TP.HCM', '0912345679', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'System Admin'), 1, 1),
('manager_01', '1234', 'duc.pham1988@gmail.com', 'M', '1988-05-18', N'Phạm Anh Đức', N'78 Trần Phú, Đà Nẵng', '0912345680', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Manager'), 1, 1),
('manager_02', '1234', 'lan.le1990@gmail.com', 'F', '1990-11-07', N'Lê Thị Lan', N'15 Hai Bà Trưng, Hải Phòng', '0912345681', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Manager'), 1, 1),
('sale_01', '1234', 'khoa.vo1996@gmail.com', 'M', '1996-01-12', N'Võ Minh Khoa', N'22 Nguyễn Trãi, Hà Nội', '0912345682', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Sale Staff'), 1, 1),
('sale_02', '1234', 'linh.bui1998@gmail.com', 'F', '1998-07-24', N'Bùi Khánh Linh', N'81 Điện Biên Phủ, TP.HCM', '0912345683', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Sale Staff'), 1, 1),
('officer_01', '1234', 'thao.do1994@gmail.com', 'F', '1994-04-05', N'Đỗ Phương Thảo', N'39 Phan Chu Trinh, Huế', '0912345684', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Admin Officer'), 1, 1),
('officer_02', '1234', 'hieu.hoang1993@gmail.com', 'M', '1993-10-16', N'Hoàng Trung Hiếu', N'56 Lý Thường Kiệt, Cần Thơ', '0912345685', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Admin Officer'), 1, 1),
('warehouse_01', '1234', 'son.dang1992@gmail.com', 'M', '1992-06-30', N'Đặng Đức Sơn', N'90 Quốc Lộ 1A, Bình Dương', '0912345686', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Warehouse Staff'), 1, 1),
('warehouse_02', '1234', 'mai.ngo1997@gmail.com', 'F', '1997-09-14', N'Ngô Thanh Mai', N'12 Nguyễn Văn Linh, Đồng Nai', '0912345687', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Warehouse Staff'), 1, 1);
GO

-- 3. TAO TAI KHOAN KHACH HANG
INSERT INTO [user] (user_name, password_hash, email, gender, date_of_birth, full_name, address, phone, account_status, role_id, created_by, updated_by)
VALUES
('khachhang_01', '1234', 'tuan.nguyen1992@gmail.com', 'M', '1992-05-18', N'Nguyễn Minh Tuấn', N'15 Đại Cồ Việt, Hà Nội', '0981234561', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Customer'), 1, 1),
('khachhang_02', '1234', 'linh.tran1994@gmail.com', 'F', '1994-09-27', N'Trần Ngọc Linh', N'28 Lê Thanh Nghị, Hà Nội', '0981234562', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Customer'), 1, 1),
('khachhang_03', '1234', 'huy.pham1990@gmail.com', 'M', '1990-12-10', N'Phạm Quang Huy', N'102 Giải Phóng, Hà Nội', '0981234563', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Customer'), 1, 1),
('khachhang_04', '1234', 'mai.nguyen1993@gmail.com', 'F', '1993-08-14', N'Nguyễn Thanh Mai', N'56 Trần Duy Hưng, Hà Nội', '0981234564', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Customer'), 1, 1),
('khachhang_05', '1234', 'long.le1991@gmail.com', 'M', '1991-11-22', N'Lê Hoàng Long', N'89 Phạm Hùng, Hà Nội', '0981234565', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Customer'), 1, 1),
('khachhang_06', '1234', 'ha.nguyen1990@gmail.com', 'F', '1990-03-12', N'Nguyễn Thu Hà', N'18 Kim Mã, Hà Nội', '0981234566', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Customer'), 1, 1),
('khachhang_07', '1234', 'nam.tran1989@gmail.com', 'M', '1989-07-25', N'Trần Hoài Nam', N'72 Cầu Giấy, Hà Nội', '0981234567', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Customer'), 1, 1),
('khachhang_08', '1234', 'thao.pham1995@gmail.com', 'F', '1995-11-08', N'Phạm Minh Thảo', N'35 Xuân Thủy, Hà Nội', '0981234568', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Customer'), 1, 1),
('khachhang_09', '1234', 'vinh.le1992@gmail.com', 'M', '1992-06-20', N'Lê Quốc Vinh', N'120 Hoàng Quốc Việt, Hà Nội', '0981234569', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Customer'), 1, 1),
('khachhang_10', '1234', 'yen.do1994@gmail.com', 'F', '1994-10-15', N'Đỗ Hải Yến', N'48 Nguyễn Chí Thanh, Hà Nội', '0981234570', 'ACTIVE', (SELECT role_id FROM role WHERE role_name = N'Customer'), 1, 1);
GO

-- 4. HO SO KHACH HANG (CUSTOMER)
INSERT INTO customer (tax_code, customer_type, company_name, user_id, assigned_to_user_id)
VALUES
('0101234567', 'CUSTOMER', N'Công ty TNHH Nguyên Liệu Bánh Việt', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_01'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
('0312345678', 'CUSTOMER', N'Công ty Cổ phần Bánh Kem Sweet House', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_02'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
('0409876543', 'CUSTOMER', N'Công ty TNHH Tiệm Bánh Hương Việt', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_03'), (SELECT user_id FROM [user] WHERE user_name = 'sale_02')),
('0203456789', 'CUSTOMER', N'Công ty TNHH Thực Phẩm Golden Bakery', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_04'), (SELECT user_id FROM [user] WHERE user_name = 'sale_02')),
('0112345987', 'CUSTOMER', N'Công ty Cổ phần Bánh Ngọt Phương Nam', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_05'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
('0114567890', 'LOYAL CUSTOMER', N'Công ty TNHH Bánh Ngọt Ánh Dương', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_06'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
('0315678901', 'LOYAL CUSTOMER', N'Công ty Cổ phần Fresh Bakery', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_07'), (SELECT user_id FROM [user] WHERE user_name = 'sale_02')),
('0416789012', 'LOYAL CUSTOMER', N'Công ty TNHH Hương Bánh Việt', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_08'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01')),
('0217890123', 'LOYAL CUSTOMER', N'Công ty Cổ phần Bánh Mì Phố', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_09'), (SELECT user_id FROM [user] WHERE user_name = 'sale_02')),
('0118901234', 'LOYAL CUSTOMER', N'Công ty TNHH Golden Flour Bakery', (SELECT user_id FROM [user] WHERE user_name = 'khachhang_10'), (SELECT user_id FROM [user] WHERE user_name = 'sale_01'));
GO

-- 5. DANH MUC SAN PHAM
INSERT INTO category (category_name)
VALUES
(N'Bột làm bánh'),
(N'Men nở & Chất tạo nở'),
(N'Đường & Chất tạo ngọt'),
(N'Bơ & Chất béo'),
(N'Sữa & Chế phẩm từ sữa'),
(N'Trứng & Chế phẩm từ trứng'),
(N'Socola & Ca cao'),
(N'Hương liệu & Phụ gia thực phẩm'),
(N'Nhân bánh & Mứt'),
(N'Hạt & Trái cây sấy');
GO

-- 6. SAN PHAM

INSERT INTO product (product_name, cost_price, selling_price, description, unit, product_status, quantity_available, updated_by, category_id)
VALUES
(N'Bột mì Baker''s Choice số 8', 310000, 355000, N'Bột mì chuyên dùng cho bánh ngọt', N'Bao 25kg', 'ACTIVE', 120, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 1),
(N'Bột mì Baker''s Choice số 11', 320000, 365000, N'Bột mì đa dụng', N'Bao 25kg', 'ACTIVE', 100, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 1),
(N'Bột mì Baker''s Choice số 13', 335000, 385000, N'Bột mì chuyên làm bánh mì', N'Bao 25kg', 'ACTIVE', 90, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 1),
(N'Bột mì Hoa Ngọc Lan', 295000, 340000, N'Bột mì cao cấp', N'Bao 25kg', 'ACTIVE', 80, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 1),
(N'Bột mì Prima Bread Flour', 345000, 395000, N'Bột mì nhập khẩu Singapore', N'Bao 25kg', 'ACTIVE', 60, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 1),

(N'Men khô Saf-Instant Gold', 72000, 86000, N'Men nở dành cho bánh ngọt', N'Gói 500g', 'ACTIVE', 180, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 2),
(N'Men khô Saf-Instant Red', 70000, 84000, N'Men nở dành cho bánh mì', N'Gói 500g', 'ACTIVE', 200, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 2),
(N'Baking Powder Alsa', 42000, 52000, N'Bột nở Alsa', N'Hộp 1kg', 'ACTIVE', 100, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 2),
(N'Baking Soda Arm & Hammer', 38000, 50000, N'Baking soda thực phẩm', N'Hộp 454g', 'ACTIVE', 90, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 2),
(N'Bread Improver Puratos S500', 185000, 225000, N'Phụ gia cải thiện chất lượng bánh mì', N'Gói 1kg', 'ACTIVE', 70, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 2),

(N'Đường tinh luyện Biên Hòa', 450000, 520000, N'Đường trắng tinh luyện', N'Bao 50kg', 'ACTIVE', 50, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 3),
(N'Đường nâu Biên Hòa', 29000, 36000, N'Đường nâu dùng làm bánh', N'Kg', 'ACTIVE', 300, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 3),
(N'Đường bột Baker''s Choice', 36000, 45000, N'Đường bột mịn', N'Kg', 'ACTIVE', 180, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 3),
(N'Glucose Syrup Puratos', 920000, 1080000, N'Siro glucose thực phẩm', N'Thùng 25kg', 'ACTIVE', 20, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 3),
(N'Mật ong nguyên chất', 155000, 185000, N'Mật ong dùng trong làm bánh', N'Chai 1L', 'ACTIVE', 80, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 3),

(N'Bơ lạt Anchor', 1180000, 1320000, N'Bơ lạt New Zealand', N'Thùng 20kg', 'ACTIVE', 35, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 4),
(N'Bơ lạt Elle & Vire', 1260000, 1420000, N'Bơ lạt Pháp', N'Thùng 20kg', 'ACTIVE', 25, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 4),
(N'Margarine Meizan', 530000, 620000, N'Bơ thực vật Meizan', N'Thùng 15kg', 'ACTIVE', 45, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 4),
(N'Shortening Cái Lân', 610000, 710000, N'Shortening dùng làm bánh', N'Thùng 15kg', 'ACTIVE', 40, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 4),
(N'Bơ President', 1280000, 1450000, N'Bơ President nhập khẩu', N'Thùng 20kg', 'ACTIVE', 18, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 4),

(N'Whipping Cream Anchor', 112000, 132000, N'Kem tươi Anchor', N'Hộp 1L', 'ACTIVE', 120, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 5),
(N'Topping Cream Rich''s', 78000, 95000, N'Kem thực vật Rich''s', N'Hộp 1L', 'ACTIVE', 150, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 5),
(N'Cream Cheese Philadelphia', 148000, 175000, N'Phô mai kem Philadelphia', N'Hộp 1kg', 'ACTIVE', 80, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 5),
(N'Sữa đặc Ông Thọ', 420000, 490000, N'Sữa đặc có đường', N'Thùng 24 lon', 'ACTIVE', 40, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 5),
(N'Sữa bột Anchor', 175000, 205000, N'Sữa bột nguyên kem', N'Gói 1kg', 'ACTIVE', 70, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 5);
GO

INSERT INTO product (product_name, cost_price, selling_price, description, unit, product_status, quantity_available, updated_by, category_id)
VALUES
(N'Trứng gà tươi', 32000, 38000, N'Trứng gà tươi dùng làm bánh', N'Vỉ 10 quả', 'ACTIVE', 150, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 6),
(N'Lòng đỏ trứng thanh trùng', 105000, 125000, N'Lòng đỏ trứng thanh trùng', N'Hộp 1kg', 'ACTIVE', 60, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 6),
(N'Lòng trắng trứng thanh trùng', 98000, 118000, N'Lòng trắng trứng thanh trùng', N'Hộp 1kg', 'ACTIVE', 60, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 6),
(N'Bột lòng trắng trứng Ovodan', 420000, 495000, N'Bột lòng trắng trứng nhập khẩu', N'Gói 1kg', 'ACTIVE', 25, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 6),
(N'Bột trứng nguyên chất Sanovo', 465000, 545000, N'Bột trứng nguyên chất', N'Gói 1kg', 'ACTIVE', 20, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 6),

(N'Chocolate Couverture Callebaut 811', 425000, 495000, N'Socola đen couverture 54.5%', N'Gói 2.5kg', 'ACTIVE', 40, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 7),
(N'Chocolate Couverture Callebaut 823', 435000, 510000, N'Socola sữa couverture', N'Gói 2.5kg', 'ACTIVE', 35, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 7),
(N'Chocolate Compound Beryls Dark', 235000, 275000, N'Socola compound đen', N'Gói 1kg', 'ACTIVE', 70, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 7),
(N'Chocolate Chips Beryls', 255000, 295000, N'Socola chip chịu nhiệt', N'Gói 1kg', 'ACTIVE', 65, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 7),
(N'Bột ca cao Van Houten', 205000, 245000, N'Bột ca cao nguyên chất', N'Gói 1kg', 'ACTIVE', 50, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 7),

(N'Vanilla Extract Nielsen-Massey', 395000, 455000, N'Tinh chất vanilla tự nhiên', N'Chai 118ml', 'ACTIVE', 25, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 8),
(N'Hương bơ Rayner''s', 68000, 85000, N'Hương bơ thực phẩm', N'Chai 28ml', 'ACTIVE', 90, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 8),
(N'Hương sữa Rayner''s', 68000, 85000, N'Hương sữa thực phẩm', N'Chai 28ml', 'ACTIVE', 90, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 8),
(N'Gelatin Gold Leaf', 148000, 175000, N'Lá gelatin dùng làm mousse và thạch', N'Hộp 200g', 'ACTIVE', 45, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 8),
(N'Bột Agar Vĩnh Thuận', 45000, 58000, N'Bột rau câu Agar', N'Gói 50g', 'ACTIVE', 120, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 8),

(N'Nhân đậu đỏ Puratos', 98000, 118000, N'Nhân đậu đỏ làm bánh', N'Gói 1kg', 'ACTIVE', 80, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 9),
(N'Nhân khoai môn Puratos', 108000, 128000, N'Nhân khoai môn làm bánh', N'Gói 1kg', 'ACTIVE', 70, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 9),
(N'Nhân phô mai Puratos', 145000, 170000, N'Nhân phô mai làm bánh', N'Gói 1kg', 'ACTIVE', 55, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 9),
(N'Mứt dâu Puratos', 92000, 110000, N'Mứt dâu làm bánh', N'Hộp 1kg', 'ACTIVE', 65, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 9),
(N'Custard Filling Puratos', 158000, 188000, N'Nhân custard pha sẵn', N'Gói 1kg', 'ACTIVE', 40, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 9),

(N'Hạnh nhân Mỹ', 265000, 310000, N'Hạnh nhân nguyên hạt nhập khẩu', N'Gói 1kg', 'ACTIVE', 45, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 10),
(N'Hạt óc chó Mỹ', 315000, 365000, N'Hạt óc chó tách vỏ', N'Gói 1kg', 'ACTIVE', 35, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 10),
(N'Hạt điều Bình Phước', 225000, 265000, N'Hạt điều rang tự nhiên', N'Gói 1kg', 'ACTIVE', 55, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 10),
(N'Nho khô Sun-Maid', 175000, 210000, N'Nho khô không hạt', N'Gói 1kg', 'ACTIVE', 60, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 10),
(N'Cranberry sấy Ocean Spray', 235000, 275000, N'Nam việt quất sấy khô', N'Gói 1kg', 'ACTIVE', 40, (SELECT user_id FROM [user] WHERE user_name = 'warehouse_01'), 10);
GO

-- 7. PHAN QUYEN (PERMISSION)
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
