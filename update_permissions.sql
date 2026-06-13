USE [SWP_Sales_Process];
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('permission') AND name = 'url_pattern')
BEGIN
    ALTER TABLE permission ADD url_pattern NVARCHAR(255);
END
GO

-- Xóa NULL tru?c
UPDATE permission SET url_pattern = permission_name WHERE url_pattern IS NULL;
GO

-- C?p nh?t chính xác
UPDATE permission SET url_pattern = '/product-list' WHERE permission_name = '/product/list';
UPDATE permission SET url_pattern = '/product-edit' WHERE permission_name = '/product/edit';
UPDATE permission SET url_pattern = '/create-quotation' WHERE permission_name = '/quotation/create';
UPDATE permission SET url_pattern = '/contract-generate' WHERE permission_name = '/contract/generate';
UPDATE permission SET url_pattern = '/contract-approve' WHERE permission_name = '/contract/approve';
UPDATE permission SET url_pattern = '/dashboard' WHERE permission_name = '/dashboard';

UPDATE permission SET url_pattern = '/user-list' WHERE permission_name LIKE '%user%list%' OR permission_name = 'View User List';
UPDATE permission SET url_pattern = '/user-detail' WHERE permission_name LIKE '%User Detail%';
UPDATE permission SET url_pattern = '/create-user' WHERE permission_name LIKE '%Add User%' OR permission_name LIKE '%Create User%';
UPDATE permission SET url_pattern = '/edit-user' WHERE permission_name LIKE '%Edit User%';

UPDATE permission SET url_pattern = '/role-list' WHERE permission_name LIKE '%Role List%';
UPDATE permission SET url_pattern = '/role-detail' WHERE permission_name LIKE '%Role Detail%';
UPDATE permission SET url_pattern = '/add-role' WHERE permission_name LIKE '%Add Role%';
UPDATE permission SET url_pattern = '/edit-role-permissions' WHERE permission_name LIKE '%Edit Role Permissions%';

UPDATE permission SET url_pattern = '/customer-list' WHERE permission_name LIKE '%Customer List%';
UPDATE permission SET url_pattern = '/customer-order-list' WHERE permission_name LIKE '%Order List%';
UPDATE permission SET url_pattern = '/create-customer-order' WHERE permission_name LIKE '%Add Order%' OR permission_name LIKE '%Create Order%';
UPDATE permission SET url_pattern = '/quotation-list' WHERE permission_name LIKE '%Quotation List%';

UPDATE permission SET url_pattern = '/product-detail' WHERE permission_name LIKE '%Product Detail%';
UPDATE permission SET url_pattern = '/category' WHERE permission_name LIKE '%Category%';
UPDATE permission SET url_pattern = '/inventory' WHERE permission_name LIKE '%Inventory%';

SELECT permission_id, permission_name, url_pattern FROM permission;
GO
