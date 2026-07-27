# BUSINESS RULES & SYSTEM MESSAGES (SRS SYNCED)

## 1. Business Rules (BR)

| ID | Module | Rule Definition |
| :--- | :--- | :--- |
| **BR-01** | Role Management | Only authenticated System Administrators can create, update, or modify role permissions. Unauthorized users are not allowed to modify roles. |
| **BR-02** | Role Management | Every role must have a unique Role Name across the system. |
| **BR-03** | Role Management | A role must always contain and be assigned at least one permission. |
| **BR-04** | Role Management | The system must validate all required fields and permission assignments before saving or updating the database. |
| **BR-05** | Role Management | The system automatically records the Created Date when a new role is created. The Created Date must remain unchanged after updates. |
| **BR-06** | Role Management | The Updated Date must be refreshed automatically after every successful role or permission update. |
| **BR-07** | Role Management | Role-permission relationships and updates must be committed as a single database transaction to maintain data consistency. |
| **BR-08** | Role Management | Permission changes become effective immediately after a successful update. |
| **BR-09** | Authentication | Max failed attempts threshold is 5. |
| **BR-10** | Authentication | INACTIVE users cannot login. |
| **BR-11** | User Management | Pagination defaults to 10 records per page. |
| **BR-12** | User Management | Only users with appropriate permissions can change account status. |
| **BR-13** | User Management | Only users with the System Admin role can create new user accounts. |
| **BR-14** | User Management | Username, Email, and Phone must be unique across the system. |
| **BR-15** | User Management | A random password is automatically generated and emailed to the new user upon creation. |
| **BR-16** | User Management | A user can only edit their own profile, unless they possess the System Admin role, which allows editing any user profile. |
| **BR-17** | User Management | If a user modifies their own profile details or role, their active session data must be refreshed immediately to reflect changes. |
| **BR-18** | User Management | Resetting a password sets it to a system default ("123456") and automatically emails the user. |
| **BR-19** | Authentication | Every successful logout action by an authenticated user must be recorded in the system audit logs. |
| **BR-20** | Contract Management | Contract visibility must be strictly scoped by the Actor's account identity and role privileges (e.g., Customers only see their own contracts). |
| **BR-21** | Contract Management | Pagination defaults to 10 records per page. |
| **BR-22** | Contract Management | Spaces in search criteria are collapsed for Customer Name, and entirely removed for Contract Number, Tax Code, Phone, and Email. |
| **BR-23** | Contract Management | Only one contract can be created per quotation. |
| **BR-24** | Contract Management | Contract number is formatted based on the Quotation Identifier and the current year (e.g., 001/2026-HD). |
| **BR-25** | Contract Management | Contract content cannot be empty. |
| **BR-26** | Contract Management | All status changes must be recorded in the Contract History log. |
| **BR-27** | Contract Management | Only contracts with status Draft or Pending Review can be modified. |
| **BR-28** | Contract Management | Submitting for review changes the status to Pending Review and requires a history log entry. |
| **BR-29** | Contract Management | Admin Officer can only "Send to Manager" when status is Draft or Pending Review. |
| **BR-30** | Contract Management | Manager can only "Approve" when status is Pending Review. |
| **BR-31** | Contract Management | Customer can only "Approve" when status is Customer Check. |
| **BR-32** | Contract Management | "Request Edit" forcefully sets the status to Pending Review regardless of originating state. |
| **BR-33** | Contract Management | Final contracts can only be sent when status is Signed. |
| **BR-34** | Contract Management | The system must place signature images accurately into Buyer or Seller placeholders based on whether the signer holds a Customer role. |
| **BR-35** | Contract Management | The downloaded PDF filename must be sanitized to remove invalid operating system file characters (e.g., slashes, colons). |
| **BR-36** | Contract Management | Guest users without an active session can download the PDF if they possess a valid, unexpired Secure Access Token. |
| **BR-37** | Product Management | Only authenticated System Administrators and Warehouse Staff can perform product creation, editing, or deactivation (soft-delete). |
| **BR-38** | Product Management | Every product must belong to exactly one valid category. |
| **BR-39** | Product Management | Product name must be unique across the system catalog (case-insensitive check). |
| **BR-40** | Product Management | Product unit is required and must not exceed 50 characters. |
| **BR-41** | Product Management | Product cost price and quantity available must be non-negative (>= 0). |
| **BR-42** | Product Management | Product selling price must be greater than or equal to the cost price (`selling_price >= cost_price`). |
| **BR-43** | Product Management | Deleted products are soft-deleted by setting their status to 'INACTIVE' instead of physically deleting them to maintain integrity of quotations and customer orders. |
| **BR-44** | Product Management | Inactive products are not shown in active catalogs or selection lists for new quotations and orders. |
| **BR-45** | Product Review | A customer can only write a review for a product if they have a completed customer order containing that product (`order_status = 'COMPLETED'`). |
| **BR-46** | Product Review | Product review rating must be an integer between 1 and 5. |
| **BR-47** | Product Review | Only reviews with status 'ACTIVE' are visible on the product details page and used in the average rating calculation. |
| **BR-48** | Product Review | Reviews marked as 'HIDDEN' or 'INACTIVE' are excluded from public display and do not affect the average rating. |
| **BR-49** | Product Review | System Administrators, Managers, and Sales Staff can write an official reply to customer reviews. |
| **BR-50** | Product Audit Logging | Every product CRUD action (create, update, status toggle) must be recorded in the system audit logs. |
| **BR-51** | Invoice Management | Each invoice must be generated from exactly one completed customer order or approved contract. |
| **BR-52** | Invoice Management | The invoice total amount must match the corresponding contract or order total value. |
| **BR-53** | Invoice Management | Product names, units, prices, quantities, discount percentages, and tax percentages are pre-populated and locked as read-only during invoice creation. |
| **BR-54** | Invoice Management | Saving as "Lưu nháp" sets the invoice status to UNRELEASED (draft). Saving as "Lưu Hóa Đơn" sets the status to READY (official and locked, waiting for release). |
| **BR-55** | Invoice Management | Customers can only view and query invoices linked to their own customer account and whose status is RELEASED. |
| **BR-56** | Invoice Management | The digital "Signature Valid" seal and official invoice number (formatted as 8 digits) are generated and displayed only when the invoice status is updated to RELEASED (triggered upon successful payment confirmation). |
| **BR-57** | Invoice Management | Invoices can only be modified if their current status is UNRELEASED or READY. Released (RELEASED) or canceled (CANCELED) invoices cannot be edited. |
| **BR-58** | Invoice Management | Invoices can only be canceled by authorized staff members (roleId != 3), and only if their current status is not already CANCELED. |
| **BR-59** | Invoice Management | When an invoice is officially released (RELEASED), the system automatically generates the next sequential 8-digit invoice number and sends an automated notification email containing the e-invoice details to the customer. |
| **BR-60** | Warehouse Import Management | Only authenticated System Administrators, Managers, and Sales Staff can create warehouse import requests. |
| **BR-61** | Warehouse Import Management | Only authenticated Warehouse Staff can process (confirm import or cancel) pending import requests. |
| **BR-62** | Warehouse Import Management | Warehouse import requests can only be created for products whose status is ACTIVE. |
| **BR-63** | Warehouse Import Management | The requested import quantity must be a positive integer greater than zero. |
| **BR-64** | Warehouse Import Management | A newly created warehouse import request is initialized with the status PENDING (status code 1). |
| **BR-65** | Warehouse Import Management | Processing an import request (confirming import) is a transactional operation that updates the request status to COMPLETED (status code 2) and increases the corresponding product's stock quantity. |
| **BR-66** | Warehouse Import Management | Canceling an import request requires a mandatory cancellation note, which updates the request status to CANCELED (status code 3). |
| **BR-67** | Warehouse Import Management | Import requests can only be processed (confirmed or canceled) if their current status is PENDING. Requests already completed or canceled cannot be processed again. |
| **BR-68** | Order Management | Only authenticated internal staff (System Admin, Manager, Sales Staff, Admin Officer) can create new customer orders or update status. Customers are restricted from direct actions. |
| **BR-69** | Order Management | Every customer order must be linked to a customer who has an active signed contract (contract_status = 'SIGNED'). |
| **BR-70** | Order Management | A newly created customer order is initialized with the status PENDING. |
| **BR-71** | Order Management | During order creation, the system validates product stock. If stock is insufficient, order creation is blocked, and the system automatically generates an import request for the deficit amount in PENDING status. |
| **BR-72** | Order Management | Order creation and stock deduction (quantity_available and quantity_reserve decrement) must be executed as a single transactional operation. |
| **BR-73** | Order Management | Direct status update to COMPLETED by staff is blocked; order completion requires Customer confirmation via the Acceptance Record. |
| **BR-74** | Order Management | Valid order status transitions are: PENDING to SHIPPING, CANCELLED, or DELETED; SHIPPING to COMPLETED, CANCELLED, or DELETED. Completed, cancelled, or deleted statuses are terminal. |
| **BR-75** | Order Management | When an order is CANCELLED or DELETED, the system automatically restores the ordered quantities back to the product's available inventory (quantity_available). |
| **BR-76** | Order Management | Orders are never physically deleted. Deleting an order updates its status to DELETED (which hides it from standard views) and restores available stock. Only Managers are authorized to delete orders. |
| **BR-77** | Order Management | Order visibility is strictly scoped by user roles: Customers only view their own orders; Sales Staff only view orders for their assigned customers; other staff view all orders. |
| **BR-78** | Order Management | Creating an order automatically triggers the creation of a pending payment record for that order. |
| **BR-79** | Acceptance Record | An acceptance record is automatically generated or retrieved when accessing the Acceptance Record page for an order linked to a signed contract. |
| **BR-80** | Acceptance Record | Generated acceptance records snapshot Party A (provider credentials from configuration) and Party B (customer details), along with order line items and total amounts. |
| **BR-81** | Acceptance Record | The status of the acceptance record (acceptance_status) is synchronized with the order status when loaded or updated. |
| **BR-82** | Acceptance Record | Acceptance Record numbers are automatically formatted as AR-[YYYY]-[SEQUENCE] (e.g., AR-2026-00001), incrementing the 5-digit sequence based on the max number of that year. |
| **BR-83** | Acceptance Record | Only the Customer who owns the order can confirm successful delivery and sign the Acceptance Record. Internal staff are blocked from confirming delivery. |
| **BR-84** | Acceptance Record | Delivery confirmation is blocked if the order status is CANCELLED. Upon confirmation, both order and acceptance status transition to COMPLETED, and the action is audited. |

---

## 2. System Messages (MSG)

| Code | Context | Type | Content |
| :--- | :--- | :--- | :--- |
| **MSG-01** | Role Management | Required Field Missing | The Role Name field is required. |
| **MSG-02** | Role Management | Duplicate Role Name | Role name already exists. |
| **MSG-03** | Role Management | No Permission Selected | Please assign at least one permission. |
| **MSG-04** | Role Management | Invalid Role Name Length | Role Name exceeds the maximum allowed length. |
| **MSG-05** | Role Management | Role Not Found | The selected role could not be found. |
| **MSG-06** | Role Management | Permission Update Conflict | The permission settings have been modified by another administrator. Please reload and try again. |
| **MSG-07** | Authentication | Empty Input | Username and password cannot be empty. |
| **MSG-08** | Authentication | Max Attempts Exceeded | Too many failed attempts. Please try again later or contact support. |
| **MSG-09** | Authentication | Account Locked | Your account has been locked by the administrator. / INACTIVE status. |
| **MSG-10** | Authentication | Invalid Credentials | Invalid username or password. Attempts left: X |
| **MSG-11** | General | Unauthorized Access | Access Denied / You do not have permission to perform this action. |
| **MSG-12** | User Management | Missing Required Fields | Full Name, Username, Email, Phone is required! |
| **MSG-13** | User Management | Invalid Format | Invalid data format (Based on Validation utilities). |
| **MSG-14** | User Management | Duplicate Data | [Field] duplicated! (Email, Phone, or Username). |
| **MSG-15** | General | Database Error | Database error! |
| **MSG-16** | User Management | Invalid User ID | Invalid User ID. |
| **MSG-17** | General | Invalid Page Input | System catches format errors and defaults to the first page. |
| **MSG-18** | Contract Management | Signature Error | Displays pending signature error message if present. |
| **MSG-19** | Contract Management | Empty Content | Nội dung hợp đồng không được để trống! |
| **MSG-20** | Contract Management | Duplicate Contract | Báo giá này đã có hợp đồng! |
| **MSG-21** | Contract Management | Creation Failed | Tạo hợp đồng thất bại! |
| **MSG-22** | Contract Management | Invalid Status | Hợp đồng đã chốt, không được phép chỉnh sửa nội dung! |
| **MSG-23** | Contract Management | Update Failed | Cập nhật thất bại! |
| **MSG-24** | Contract Management | Invalid State | System detects status violation and displays an error message. |
| **MSG-25** | Contract Management | Invalid Token | Link tải file đã hết hạn hoặc không hợp lệ! |
| **MSG-26** | Contract Management | Contract Not Found | Không tìm thấy hợp đồng hợp lệ! |
| **MSG-27** | Contract Management | PDF Gen Error | LỖI KHI TẠO PDF... |
| **MSG-28** | Product Management | Required Field Missing | Tên sản phẩm không được để trống! / Tên sản phẩm tối đa chỉ được 255 kí tự! |
| **MSG-29** | Product Management | Invalid Cost Price | Giá gốc: Price must not be empty! / Giá gốc: Price must be greater than or equal to zero / Giá gốc: Price must be a valid number |
| **MSG-30** | Product Management | Invalid Selling Price | Giá bán: Price must not be empty! / Giá bán: Price must be greater than or equal to zero / Giá bán: Price must be a valid number |
| **MSG-31** | Product Management | Pricing Constraint | Giá bán phải lớn hơn hoặc bằng giá gốc sản phẩm! / Định dạng giá gốc hoặc giá bán không hợp lệ! |
| **MSG-32** | Product Management | Duplicate Name | Tên sản phẩm này đã tồn tại trong hệ thống! |
| **MSG-33** | Product Management | Invalid Unit | Đơn vị tính không được để trống! / Đơn vị tính tối đa chỉ được 50 kí tự! |
| **MSG-34** | Product Management | Invalid Quantity | Quantity must not be empty! / Quantity must be greater than or equal to zero / Quantity must be integer / Lỗi định dạng số liệu sản phẩm! |
| **MSG-35** | Product Management | Access Constraint | Quý khách không có tính năng này. / Quý khách không thể thực hiện tính năng này. |
| **MSG-36** | Product Management | Data Not Found | Không tìm thấy sản phẩm. / Sản phẩm không tồn tại. / ID sản phẩm lỗi / Không tìm thấy hành động hợp lệ. |
| **MSG-37** | Product Management | Action Failure | Sản phẩm này không thể xóa. / ID sản phẩm lỗi. |
| **MSG-38** | Product Review | Purchase Constraint | Quý khách chỉ được đánh giá những sản phẩm đã mua thành công! |
| **MSG-39** | Product Review | Invalid Rating | Điểm đánh giá phải từ 1 đến 5 sao! |
| **MSG-40** | Product Review | Required Reply | Nội dung phản hồi không được để trống! |
| **MSG-41** | Product Review | Duplicate Review Blocked | You have already submitted a review for this product. / Quý khách đã gửi đánh giá cho sản phẩm này rồi! |
| **MSG-42** | Invoice Management | Duplicate Invoice | Hóa đơn này đã được tạo vui lòng kiểm tra lại! |
| **MSG-43** | Invoice Management | Required Symbol Missing | Ký hiệu hóa đơn không được để trống! |
| **MSG-44** | Invoice Management | Invalid Symbol Format | Ký hiệu hóa đơn không đúng định dạng (Phải có dạng 1K[năm]TYY cho VAT hoặc 2K[năm]TYY cho loại khác)! |
| **MSG-45** | Invoice Management | Symbol Mismatch Type | Ký hiệu hóa đơn không khớp với loại hóa đơn (Loại [Loại] phải bắt đầu bằng [Tiền tố])! |
| **MSG-46** | Invoice Management | Symbol Mismatch Year | Ký hiệu hóa đơn không khớp với năm phát hành (Phải chứa năm '[yy]')! |
| **MSG-47** | Invoice Management | Buyer Tax Code Missing | Mã số thuế người mua không được để trống! |
| **MSG-48** | Invoice Management | Buyer Tax Code Format | Mã số thuế không đúng định dạng (Phải gồm 10 số hoặc 13 số dạng XXXXXXXXXX-XXX)! |
| **MSG-49** | Invoice Management | Buyer Phone Missing | Số điện thoại người mua không được để trống! |
| **MSG-50** | Invoice Management | Buyer Phone Format | Số điện thoại không đúng định dạng (Phải gồm đúng 10 chữ số)! |
| **MSG-51** | Invoice Management | Invoice No Format | Số hóa đơn phải là số gồm đúng 8 chữ số! |
| **MSG-52** | Invoice Management | Other Customer Access | Bạn không được xem hóa đơn của khách hàng khác |
| **MSG-53** | Invoice Management | Unreleased Invoice View | Hóa đơn chưa được phát hành |
| **MSG-54** | Invoice Management | Invoice Already Released/Canceled | Hóa đơn này đã ở trạng thái [Trạng thái], không thể chỉnh sửa! |
| **MSG-55** | Invoice Management | Concurrency Error | Không thể cập nhật nháp! Hóa đơn này vừa được một tài khoản/thiết bị khác chuyển sang trạng thái Sẵn sàng phát hành. |
| **MSG-56** | Warehouse Import Management | Invalid Input Format | Dữ liệu nhập vào không đúng định dạng số. |
| **MSG-57** | Warehouse Import Management | Invalid Quantity | Số lượng nhập kho phải lớn hơn 0. |
| **MSG-58** | Warehouse Import Management | Product Not Found | Sản phẩm chọn không tồn tại. |
| **MSG-59** | Warehouse Import Management | Product Inactive | Sản phẩm hiện đang không hoạt động (Inactive). |
| **MSG-60** | Warehouse Import Management | Creation Failed | Không thể tạo yêu cầu nhập kho. Lỗi cơ sở dữ liệu. |
| **MSG-61** | Warehouse Import Management | Concurrency Conflict | Yêu cầu đã được xử lý bởi người dùng khác. / Trạng thái đã bị thay đổi trước đó. |
| **MSG-62** | Warehouse Import Management | Required Note Missing | Nội dung ghi chú không được để trống! / Yêu cầu điền lý do hủy đơn. |
| **MSG-63** | Order Management | Required Field Missing | Khách hàng và Hợp đồng là bắt buộc. |
| **MSG-64** | Order Management | Required Field Missing | Vui lòng chọn ít nhất một sản phẩm. |
| **MSG-65** | Order Management | Invalid Input | Không có sản phẩm hoặc số lượng hợp lệ nào được chọn. |
| **MSG-66** | Order Management | Action Failure | Tạo đơn hàng thất bại. [Chi tiết lỗi] |
| **MSG-67** | Order Management | Invalid Format | Định dạng dữ liệu không hợp lệ. |
| **MSG-68** | Order Management | Stock Insufficient | Sản phẩm [Tên sản phẩm] (Tồn kho: [X], Cần: [Y], Thiếu: [Z]) không đủ tồn kho. Hệ thống đã tự động gửi Yêu cầu nhập kho (Import Request). Vui lòng hoàn tất nhập kho trước khi tạo đơn hàng. |
| **MSG-69** | Order Management | Invalid Status | Trạng thái 'Đã hoàn thành' chỉ được cập nhật khi nghiệm thu thành công. |
| **MSG-70** | Order Management | Invalid Status Transition | Không thể chuyển trạng thái đơn hàng từ [Trạng thái cũ] sang [Trạng thái mới]. |
| **MSG-71** | Order Management | Data Not Found | Đơn hàng không tồn tại hoặc đã bị xóa. |
| **MSG-72** | Acceptance Record | Access Constraint | Chỉ khách hàng mới có quyền xác nhận nhận hàng. |
| **MSG-73** | Acceptance Record | Success Message | Xác nhận giao hàng thành công. |
| **MSG-74** | Acceptance Record | Action Failure | Không thể cập nhật trạng thái đơn hàng. |
