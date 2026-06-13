USE [SWP_Sales_Process];
GO

-- 1. Thêm t?t c? các URL còn thi?u vào b?ng permission
-- Nhóm Customer
IF NOT EXISTS (SELECT 1 FROM permission WHERE url_pattern = '/customer/list') 
    INSERT INTO permission (permission_name, url_pattern) VALUES ('View Customer List', '/customer/list');
IF NOT EXISTS (SELECT 1 FROM permission WHERE url_pattern = '/customer/create') 
    INSERT INTO permission (permission_name, url_pattern) VALUES ('Create Customer', '/customer/create');
IF NOT EXISTS (SELECT 1 FROM permission WHERE url_pattern = '/customer/edit') 
    INSERT INTO permission (permission_name, url_pattern) VALUES ('Edit Customer', '/customer/edit');

-- Nhóm Category
IF NOT EXISTS (SELECT 1 FROM permission WHERE url_pattern = '/category/create') 
    INSERT INTO permission (permission_name, url_pattern) VALUES ('Create Category', '/category/create');
IF NOT EXISTS (SELECT 1 FROM permission WHERE url_pattern = '/category/edit') 
    INSERT INTO permission (permission_name, url_pattern) VALUES ('Edit Category', '/category/edit');
IF NOT EXISTS (SELECT 1 FROM permission WHERE url_pattern = '/category/delete') 
    INSERT INTO permission (permission_name, url_pattern) VALUES ('Delete Category', '/category/delete');

-- Nhóm User & Role
IF NOT EXISTS (SELECT 1 FROM permission WHERE url_pattern = '/user-list') 
    INSERT INTO permission (permission_name, url_pattern) VALUES ('View User List', '/user-list');
IF NOT EXISTS (SELECT 1 FROM permission WHERE url_pattern = '/user-detail') 
    INSERT INTO permission (permission_name, url_pattern) VALUES ('View User Detail', '/user-detail');
IF NOT EXISTS (SELECT 1 FROM permission WHERE url_pattern = '/create-user') 
    INSERT INTO permission (permission_name, url_pattern) VALUES ('Create User', '/create-user');
IF NOT EXISTS (SELECT 1 FROM permission WHERE url_pattern = '/edit-user') 
    INSERT INTO permission (permission_name, url_pattern) VALUES ('Edit User', '/edit-user');
IF NOT EXISTS (SELECT 1 FROM permission WHERE url_pattern = '/role-list') 
    INSERT INTO permission (permission_name, url_pattern) VALUES ('View Role List', '/role-list');
IF NOT EXISTS (SELECT 1 FROM permission WHERE url_pattern = '/add-role') 
    INSERT INTO permission (permission_name, url_pattern) VALUES ('Add Role', '/add-role');
IF NOT EXISTS (SELECT 1 FROM permission WHERE url_pattern = '/role-detail') 
    INSERT INTO permission (permission_name, url_pattern) VALUES ('View Role Detail', '/role-detail');
IF NOT EXISTS (SELECT 1 FROM permission WHERE url_pattern = '/edit-role-permissions') 
    INSERT INTO permission (permission_name, url_pattern) VALUES ('Edit Role Permissions', '/edit-role-permissions');

-- Nhóm Order & Invoice
IF NOT EXISTS (SELECT 1 FROM permission WHERE url_pattern = '/customer-order-list') 
    INSERT INTO permission (permission_name, url_pattern) VALUES ('View Order List', '/customer-order-list');
IF NOT EXISTS (SELECT 1 FROM permission WHERE url_pattern = '/customer-order-detail') 
    INSERT INTO permission (permission_name, url_pattern) VALUES ('View Order Detail', '/customer-order-detail');
IF NOT EXISTS (SELECT 1 FROM permission WHERE url_pattern = '/create-customer-order') 
    INSERT INTO permission (permission_name, url_pattern) VALUES ('Create Order', '/create-customer-order');
IF NOT EXISTS (SELECT 1 FROM permission WHERE url_pattern = '/Invoice') 
    INSERT INTO permission (permission_name, url_pattern) VALUES ('Issue Invoice', '/Invoice');

-- Nhóm Quotation
IF NOT EXISTS (SELECT 1 FROM permission WHERE url_pattern = '/quotation-list') 
    INSERT INTO permission (permission_name, url_pattern) VALUES ('View Quotation List', '/quotation-list');

GO

-- 2. C?P T?T C? QUY?N TRÊN CHO ADMIN (ROLE 1)
INSERT INTO role_permission (role_id, permission_id)
SELECT 1, permission_id FROM permission
WHERE NOT EXISTS (
    SELECT 1 FROM role_permission WHERE role_id = 1 AND permission_id = permission.permission_id
);
GO

SELECT p.permission_name, p.url_pattern FROM permission p
JOIN role_permission rp ON p.permission_id = rp.permission_id
WHERE rp.role_id = 1;
GO
