-- ============================================================================
-- Sales Process Digitalization System - SQL Server Schema (3NF)
-- Database: SWP_Sales_Process
-- Created: 2026-05-20
-- ============================================================================

IF DB_ID('SWP_Sales_Process') IS NULL
BEGIN
    CREATE DATABASE SWP_Sales_Process;
END
GO

USE SWP_Sales_Process;
GO

-- 1. AUTHENTICATION & RBAC
-- ============================================================================

CREATE TABLE roles (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT NULL
);

CREATE TABLE permissions (
    permission_id INT IDENTITY(1,1) PRIMARY KEY,
    permission_code VARCHAR(100) UNIQUE NOT NULL, -- e.g., 'A01', 'SUBMIT_ORDER'
    permission_name VARCHAR(255) NOT NULL
);

CREATE TABLE role_permissions (
    role_id INT NOT NULL,
    permission_id INT NOT NULL,
    PRIMARY KEY (role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES roles(role_id),
    FOREIGN KEY (permission_id) REFERENCES permissions(permission_id)
);

CREATE TABLE users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(255) NULL,
    role_id INT NULL,
    is_active BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

-- 2. CORE MASTER DATA
-- ============================================================================

CREATE TABLE customers (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT UNIQUE NULL,
    company_name VARCHAR(255) NULL,
    address TEXT NULL,
    phone VARCHAR(20) NULL,
    tax_code VARCHAR(50) NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE providers (
    provider_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT UNIQUE NULL,
    provider_name VARCHAR(255) NOT NULL,
    address TEXT NULL,
    phone VARCHAR(20) NULL,
    rating DECIMAL(3,2) DEFAULT 0.0,
    production_capacity TEXT NULL,
    lead_time_avg INT NULL, -- in days
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE product_categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL,
    description TEXT NULL
);

CREATE TABLE provider_categories (
    provider_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (provider_id, category_id),
    FOREIGN KEY (provider_id) REFERENCES providers(provider_id),
    FOREIGN KEY (category_id) REFERENCES product_categories(category_id)
);

CREATE TABLE products_services (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    category_id INT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    base_price DECIMAL(15,2) NULL,
    description TEXT NULL,
    FOREIGN KEY (category_id) REFERENCES product_categories(category_id)
);

-- 3. ORDERING & SOURCING
-- ============================================================================

CREATE TABLE customer_orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    sale_id INT NULL, -- Manager/Sale who handles
    order_date DATETIME DEFAULT GETDATE(),
    status VARCHAR(50) NOT NULL, -- Draft, Pending Approval, Approved, Negotiating, Accepted, Rejected, Cancelled, Expired
    total_estimated_amount DECIMAL(15,2) NULL,
    requirement_details TEXT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (sale_id) REFERENCES users(user_id)
);

CREATE TABLE quotations (
    quotation_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    created_by INT NOT NULL,
    quoted_amount DECIMAL(15,2) NOT NULL,
    valid_until DATETIME NULL,
    is_final BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (order_id) REFERENCES customer_orders(order_id),
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

CREATE TABLE negotiation_history (
    negotiation_id INT IDENTITY(1,1) PRIMARY KEY,
    quotation_id INT NOT NULL,
    user_id INT NOT NULL, -- Who made the note/offer
    note TEXT NOT NULL,
    offered_amount DECIMAL(15,2) NULL,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (quotation_id) REFERENCES quotations(quotation_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 4. CONTRACTS (CUSTOMER & PROVIDER)
-- ============================================================================

CREATE TABLE customer_contracts (
    contract_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT UNIQUE NOT NULL,
    customer_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    status VARCHAR(50) NOT NULL, -- Draft, Pending Approval, Waiting Signature, Approved, In Execution, Completed, Cancelled
    total_value DECIMAL(15,2) NOT NULL,
    start_date DATE NULL,
    end_date DATE NULL,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (order_id) REFERENCES customer_orders(order_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE customer_contract_versions (
    version_id INT IDENTITY(1,1) PRIMARY KEY,
    contract_id INT NOT NULL,
    version_number INT NOT NULL,
    content_snapshot NVARCHAR(MAX) NOT NULL, -- JSON format
    modified_by INT NULL,
    reason_for_change TEXT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (contract_id) REFERENCES customer_contracts(contract_id),
    FOREIGN KEY (modified_by) REFERENCES users(user_id)
);

CREATE TABLE provider_orders (
    p_order_id INT IDENTITY(1,1) PRIMARY KEY,
    c_contract_id INT NOT NULL,
    provider_id INT NOT NULL,
    manager_id INT NULL,
    status VARCHAR(50) NOT NULL, -- Sent To Provider, Negotiating, Accepted, Rejected, Cancelled
    estimated_cost DECIMAL(15,2) NULL,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (c_contract_id) REFERENCES customer_contracts(contract_id),
    FOREIGN KEY (provider_id) REFERENCES providers(provider_id),
    FOREIGN KEY (manager_id) REFERENCES users(user_id)
);

CREATE TABLE provider_contracts (
    p_contract_id INT IDENTITY(1,1) PRIMARY KEY,
    p_order_id INT UNIQUE NOT NULL,
    c_contract_id INT NOT NULL, -- Link to source customer contract
    provider_id INT NOT NULL,
    status VARCHAR(50) NOT NULL, -- Waiting Provider Signature, Approved, In Progress, Completed, Cancelled
    contract_value DECIMAL(15,2) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (p_order_id) REFERENCES provider_orders(p_order_id),
    FOREIGN KEY (c_contract_id) REFERENCES customer_contracts(contract_id),
    FOREIGN KEY (provider_id) REFERENCES providers(provider_id)
);

CREATE TABLE provider_contract_versions (
    version_id INT IDENTITY(1,1) PRIMARY KEY,
    p_contract_id INT NOT NULL,
    version_number INT NOT NULL,
    content_snapshot NVARCHAR(MAX) NOT NULL, -- JSON format
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (p_contract_id) REFERENCES provider_contracts(p_contract_id)
);

-- 5. EXECUTION & QUALITY
-- ============================================================================

CREATE TABLE provider_tasks (
    task_id INT IDENTITY(1,1) PRIMARY KEY,
    p_contract_id INT NOT NULL,
    task_name VARCHAR(255) NOT NULL,
    description TEXT NULL,
    status VARCHAR(50) NOT NULL, -- Assigned, In Progress, Completed, Locked
    delivery_status VARCHAR(50) NULL, -- Not Started, Packing, Delivering, Delivered, Received
    due_date DATETIME NULL,
    assigned_to INT NULL, -- User from Provider entity
    FOREIGN KEY (p_contract_id) REFERENCES provider_contracts(p_contract_id),
    FOREIGN KEY (assigned_to) REFERENCES users(user_id)
);

CREATE TABLE task_history (
    history_id INT IDENTITY(1,1) PRIMARY KEY,
    task_id INT NOT NULL,
    old_status VARCHAR(50) NULL,
    new_status VARCHAR(50) NOT NULL,
    changed_by INT NULL,
    reason TEXT NULL,
    changed_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (task_id) REFERENCES provider_tasks(task_id),
    FOREIGN KEY (changed_by) REFERENCES users(user_id)
);

CREATE TABLE quality_checks (
    qc_id INT IDENTITY(1,1) PRIMARY KEY,
    task_id INT NOT NULL,
    checker_id INT NOT NULL, -- Manager
    check_date DATETIME DEFAULT GETDATE(),
    result VARCHAR(50) NOT NULL, -- Approved, Rejected, Request Rework
    feedback TEXT NULL,
    FOREIGN KEY (task_id) REFERENCES provider_tasks(task_id),
    FOREIGN KEY (checker_id) REFERENCES users(user_id)
);

-- 6. FINANCE
-- ============================================================================

CREATE TABLE payments (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    c_contract_id INT NULL, -- Inflow (from customer)
    p_contract_id INT NULL, -- Outflow (to provider)
    amount DECIMAL(15,2) NOT NULL,
    payment_type VARCHAR(20) NOT NULL, -- 'INFLOW' or 'OUTFLOW'
    status VARCHAR(50) NOT NULL, -- Pending, Confirmed, Rejected, Paid
    payment_date DATETIME NULL,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (c_contract_id) REFERENCES customer_contracts(contract_id),
    FOREIGN KEY (p_contract_id) REFERENCES provider_contracts(p_contract_id)
);

CREATE TABLE invoices (
    invoice_id INT IDENTITY(1,1) PRIMARY KEY,
    payment_id INT NOT NULL,
    invoice_number VARCHAR(100) UNIQUE NOT NULL,
    invoice_url TEXT NULL,
    issue_date DATE DEFAULT CAST(GETDATE() AS DATE),
    status VARCHAR(50) NOT NULL, -- Generated, Exported, Cancelled
    FOREIGN KEY (payment_id) REFERENCES payments(payment_id)
);

-- 7. COMMONS & AUDIT
-- ============================================================================

CREATE TABLE attachments (
    attachment_id INT IDENTITY(1,1) PRIMARY KEY,
    entity_type VARCHAR(50) NULL, -- 'CONTRACT', 'ORDER', 'TASK'
    entity_id INT NULL,
    file_name VARCHAR(255) NULL,
    file_url TEXT NULL,
    uploaded_by INT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (uploaded_by) REFERENCES users(user_id)
);

CREATE TABLE status_history (
    history_id INT IDENTITY(1,1) PRIMARY KEY,
    entity_type VARCHAR(50) NOT NULL, -- 'CUSTOMER_ORDER', 'CUSTOMER_CONTRACT', etc.
    entity_id INT NOT NULL,
    old_status VARCHAR(50) NULL,
    new_status VARCHAR(50) NOT NULL,
    changed_by INT NULL,
    reason TEXT NULL,
    changed_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (changed_by) REFERENCES users(user_id)
);

-- ============================================================================
-- INDEXES (Performance Optimization)
-- ============================================================================

CREATE INDEX idx_customer_order_status ON customer_orders(status);
CREATE INDEX idx_customer_order_customer_id ON customer_orders(customer_id);
CREATE INDEX idx_customer_contract_status ON customer_contracts(status);
CREATE INDEX idx_customer_contract_customer_id ON customer_contracts(customer_id);
CREATE INDEX idx_provider_task_p_contract ON provider_tasks(p_contract_id);
CREATE INDEX idx_provider_task_status ON provider_tasks(status);
CREATE INDEX idx_payment_c_contract ON payments(c_contract_id);
CREATE INDEX idx_payment_p_contract ON payments(p_contract_id);
CREATE INDEX idx_payment_status ON payments(status);
CREATE INDEX idx_provider_order_provider_id ON provider_orders(provider_id);
CREATE INDEX idx_provider_contract_provider_id ON provider_contracts(provider_id);
CREATE INDEX idx_status_history_entity ON status_history(entity_type, entity_id);
CREATE INDEX idx_quotation_order_id ON quotations(order_id);
CREATE INDEX idx_negotiation_quotation_id ON negotiation_history(quotation_id);

-- ============================================================================
-- SAMPLE DATA (Optional - for testing)
-- ============================================================================

-- Insert Roles
INSERT INTO roles (role_name, description) VALUES
('Admin', 'System Administrator'),
('Manager', 'Business Manager'),
('Sale', 'Sales Representative'),
('Provider', 'Service Provider'),
('Customer', 'Customer');

-- Insert Permissions (Sample - A01 to A80 from requirements)
INSERT INTO permissions (permission_code, permission_name) VALUES
('A01', 'Submit Customer Order for Approval'),
('A02', 'Approve Customer Order'),
('A03', 'Reject Customer Order'),
('A04', 'Send Customer Order Quotation'),
('A05', 'Mark Customer Order as Negotiating'),
('A06', 'Accept Customer Order'),
('A07', 'Cancel Customer Order'),
('A08', 'Expire Customer Order'),
('A09', 'Create Customer Contract from Customer Order'),
('A10', 'Submit Provider Order for Approval'),
('A11', 'Approve Provider Order'),
('A12', 'Reject Provider Order'),
('A13', 'Send Provider Order to Provider'),
('A14', 'Mark Provider Order as Negotiating'),
('A15', 'Accept Provider Order'),
('A16', 'Reject Provider Order by Provider'),
('A17', 'Cancel Provider Order'),
('A18', 'Expire Provider Order'),
('A19', 'Create Provider Contract from Provider Order'),
('A20', 'Send Quotation'),
('A21', 'Revise Quotation'),
('A22', 'Accept Quotation'),
('A23', 'Reject Quotation'),
('A24', 'Add Negotiation Note'),
('A25', 'Submit Customer Contract for Approval'),
('A26', 'Approve Customer Contract'),
('A27', 'Reject Customer Contract'),
('A28', 'Send Customer Contract for Signature'),
('A29', 'Sign Customer Contract'),
('A30', 'Decline Customer Contract'),
('A31', 'Cancel Customer Contract'),
('A32', 'Create Customer Contract Version'),
('A33', 'Add Customer Contract Reject Note'),
('A34', 'Move Customer Contract to In Execution'),
('A35', 'Complete Customer Contract'),
('A36', 'Submit Provider Contract for Approval'),
('A37', 'Approve Provider Contract'),
('A38', 'Reject Provider Contract'),
('A39', 'Send Provider Contract for Signature'),
('A40', 'Sign / Accept Provider Contract'),
('A41', 'Decline Provider Contract'),
('A42', 'Cancel Provider Contract'),
('A43', 'Create Provider Contract Version'),
('A44', 'Add Provider Contract Reject Note'),
('A45', 'Assign Provider Contract'),
('A46', 'Move Provider Contract to In Progress'),
('A47', 'Complete Provider Contract'),
('A48', 'Assign Provider Task'),
('A49', 'Edit Provider Task'),
('A50', 'Accept Provider Task'),
('A51', 'Reject Provider Task'),
('A52', 'Update Provider Task Progress'),
('A53', 'Mark Provider Task as Completed'),
('A54', 'Update Delivery Status'),
('A55', 'Mark as Delivered'),
('A56', 'Confirm Customer Received Order'),
('A57', 'Lock Provider Task'),
('A58', 'Submit Quality Check Result'),
('A59', 'Approve Quality Check'),
('A60', 'Reject Quality Check'),
('A61', 'Request Provider Rework'),
('A62', 'Create Customer Payment Request'),
('A63', 'Confirm Customer Payment'),
('A64', 'Reject Customer Payment'),
('A65', 'Create Provider Payment Request'),
('A66', 'Approve Provider Payment'),
('A67', 'Reject Provider Payment'),
('A68', 'Mark Provider Payment as Paid'),
('A69', 'Generate Customer Invoice'),
('A70', 'Export Customer Invoice'),
('A71', 'Cancel Customer Invoice'),
('A72', 'Generate Provider Invoice'),
('A73', 'Export Provider Invoice'),
('A74', 'Cancel Provider Invoice'),
('A75', 'Export Report'),
('A76', 'Export Excel'),
('A77', 'Export PDF'),
('A78', 'View History'),
('A79', 'Upload Attachment'),
('A80', 'Download Attachment');

-- Insert Product Categories
INSERT INTO product_categories (category_name, description) VALUES
('Bánh Sinh Nhật', 'Birthday cakes'),
('Bánh Cưới', 'Wedding cakes'),
('Bánh Kem Custom', 'Custom cream cakes'),
('Bánh Fondant', 'Fondant cakes'),
('Bánh Sự Kiện', 'Event cakes'),
('Bánh Doanh Nghiệp', 'Corporate cakes'),
('Cupcake', 'Cupcakes'),
('Bánh Lạnh', 'Cold cakes'),
('Bánh Trung Thu', 'Mid-autumn cakes'),
('Sản Xuất Bánh', 'Cake production service'),
('In Hộp Bánh', 'Cake box printing'),
('Trang Trí Bánh', 'Cake decoration'),
('Giao Hàng Lạnh', 'Cold delivery service'),
('Cung Cấp Nguyên Liệu', 'Raw material supply');

-- ============================================================================
-- BUSINESS RULES & CONSTRAINTS NOTES
-- ============================================================================
/*
BR01: Customer Order phải Accepted trước khi tạo Customer Contract
  -> Enforce: App layer checks customer_orders.status = 'Accepted' before INSERT into customer_contracts

BR02: Customer Contract phải Approved trước khi tạo Provider Order
  -> Enforce: App layer checks customer_contracts.status = 'Approved' before INSERT into provider_orders

BR03: Provider Order phải Accepted trước khi tạo Provider Contract
  -> Enforce: App layer checks provider_orders.status = 'Accepted' before INSERT into provider_contracts

BR04: Một Customer Contract có thể có nhiều Provider Contract
  -> Enforce: FK c_contract_id in provider_contracts allows multiple rows per contract

BR05: Provider chỉ thấy contract/task của chính mình
  -> Enforce: App layer filters by provider_id in WHERE clause

BR06: Completed contract không được sửa giá trị tiền
  -> Enforce: App layer checks status != 'Completed' before UPDATE total_value

BR07: Mọi thay đổi workflow phải lưu history
  -> Enforce: Trigger on customer_contracts, provider_contracts, provider_tasks INSERT/UPDATE -> status_history

BR08: Provider Contract phải gắn với Customer Contract
  -> Enforce: FK c_contract_id NOT NULL in provider_contracts

BR09: Không được thanh toán provider nếu task chưa completed
  -> Enforce: App layer checks provider_tasks.status = 'Completed' before INSERT payments with payment_type='OUTFLOW'

BR10: Nếu Customer Contract chưa được ký thì không được triển khai provider workflow
  -> Enforce: App layer checks status = 'Approved' before allowing provider_tasks creation

BR11: Nếu Provider từ chối contract thì task phải bị khóa
  -> Enforce: Trigger on provider_contracts UPDATE status='Provider Declined' -> UPDATE provider_tasks SET status='Locked'

BR12: Hệ thống phải lưu lý do từ chối của customer/provider
  -> Enforce: reason column in status_history captures rejection reason

BR13: Mỗi lần sửa contract phải tạo version mới
  -> Enforce: Trigger on customer_contracts UPDATE -> INSERT into customer_contract_versions

BR14: Provider phải cập nhật trạng thái delivery của đơn hàng lên hệ thống
  -> Enforce: App layer allows provider to UPDATE provider_tasks.delivery_status

BR15: Manager phải kiểm tra chất lượng sản phẩm trước khi provider giao hàng cho customer
  -> Enforce: App layer checks quality_checks.result = 'Approved' before allowing delivery_status='Delivered'

BR16: Provider chỉ được chuyển trạng thái Delivered khi customer đã xác nhận nhận hàng
  -> Enforce: App layer checks delivery_status='Received' before marking task as completed
*/

-- ============================================================================
-- END OF SCHEMA
-- ============================================================================
