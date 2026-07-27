# TÀI LIỆU TỔNG QUAN DỰ ÁN (PROJECT OVERVIEW - UPDATED & SYNCED)

## 1. THÔNG TIN CHUNG (PROJECT IDENTITY)
*   **Tên dự án:** Bakery Ingredient Sales System (Hệ thống Quản lý Hợp đồng & Bán Nguyên liệu Bánh).
*   **Mô hình hoạt động:** **Tự cung tự cấp (In-house Inventory & Direct B2C/B2B Sales)**. Phân phối trực tiếp tới Khách hàng mà không qua trung gian.
*   **Công nghệ sử dụng:** Java Web (Servlet/JSP), MS SQL Server (Database), kiến trúc MVC thuần, **Server-Sent Events (SSE - Realtime Notifications)**.
*   **Tích hợp (Third-party):** Cổng thanh toán **VNPay**, Dịch vụ gửi mail **Gmail SMTP** (OTP Quên mật khẩu, Notifications), Thư viện xuất **PDF/Excel** (iText/Apache POI).

---

## 2. PHÂN QUYỀN CỐT LÕI (CORE ROLES & RESPONSIBILITIES)
Sự khác biệt rõ ràng giữa các Role trong hệ thống:

1.  **Sale Staff:** Lên báo giá (Quotation), thương lượng giá với khách, chốt Báo giá (Accepted), tạo Yêu cầu Nhập kho (Import Request).
2.  **Manager:** Người có thẩm quyền **Phê duyệt (Approve)** hoặc **Từ chối (Reject)** hợp đồng. Nếu hợp đồng cần sửa, Manager tạo "Yêu cầu sửa đổi" (Request Edit) kèm ghi chú. Manager **không** trực tiếp sửa text hợp đồng. Xem báo cáo doanh thu, đánh giá sản phẩm và biên bản nghiệm thu.
3.  **Admin Officer:** Người lo khâu giấy tờ (Back-office). Chịu trách nhiệm tạo Nháp (Generate Draft), **trực tiếp chỉnh sửa text** trong hợp đồng theo yêu cầu của Manager, xuất PDF, lập Biên bản Nghiệm thu (Acceptance Record), và tạo Hóa đơn VAT.
4.  **Warehouse Staff:** Quản lý xuất nhập tồn, tạo/duyệt Yêu cầu Nhập kho (Import Request), kiểm kho. Tuyệt đối không được can thiệp vào Hợp đồng/Báo giá.
5.  **Customer:** Xem báo giá, nhận link Hợp đồng, thực hiện Ký điện tử (Sign), Đánh giá sản phẩm (Product Review) và thanh toán.

---

## 3. QUY TRÌNH VẬN HÀNH SYSTEM LIFECYCLE

### GIAI ĐOẠN 1: BÁO GIÁ (QUOTATION STAGE - SALES)
*   Sale tạo Báo giá từ tồn kho. Thương lượng và chuyển trạng thái thành **ACCEPTED** khi khách đồng ý.

### GIAI ĐOẠN 2: TẠO HỢP ĐỒNG NHÁP (DRAFTING - ADMIN OFFICER)
*   Admin Officer vào **Contract Management Dashboard**, nhấn nút **Generate Draft** trên Báo giá đã duyệt.
*   Hệ thống tự động đọc file mẫu `/views/contract/template.jsp` (Hard-coded Template), điền dữ liệu (Customer Name, Items, Total) và tạo bản ghi ở trạng thái **DRAFT**.

### GIAI ĐOẠN 3: PHÊ DUYỆT NỘI BỘ (APPROVAL WORKFLOW - MANAGER & ADMIN)
*   **Yêu cầu sửa đổi:** Manager vào xem chi tiết, nếu không ưng ý, nhấn "Yêu cầu sửa đổi" + nhập Note. Hệ thống ghi nhận lịch sử vào bảng **contract_edit_history** (và **contract_revision_item**), trạng thái đổi thành **PENDING_REVIEW**.
*   **Chỉnh sửa:** Admin Officer nhận thông báo, mở Tab Version/History, tiến hành sửa nội dung HTML và lưu lại.
*   **Phê duyệt:** Admin Officer gửi trình duyệt hoặc Manager trực tiếp duyệt. Khi hợp đồng được **Approve**, nội dung chốt, trạng thái chuyển thành **PENDING_SIGNATURE**, tự động gửi email thông báo cho Khách hàng.

### GIAI ĐOẠN 4: KÝ KẾT HỢP ĐỒNG (SIGNATURE - CUSTOMER)
> 📌 *Lưu ý về trạng thái tính năng:* Luồng Ký điện tử qua OTP Email không cần đăng nhập hiện là **Luồng mục tiêu (Target Flow)** đang trong lộ trình hoàn thiện. Mã nguồn thực tế hiện tại hỗ trợ ký điện tử xác nhận thông qua Signature Portal gắn với hệ thống.
*   Khách hàng mở **Contract Signature Portal**. Xem nội dung và thực hiện ký xác nhận điện tử.
*   Trạng thái chuyển thành **SIGNED**. Hệ thống khóa chức năng Edit, hỗ trợ xuất file PDF đính kèm chữ ký.

### GIAI ĐOẠN 5: TẠO ĐƠN HÀNG & GIAO HÀNG (CUSTOMER ORDER & DELIVERY)
*   **Tạo Đơn hàng:** Từ Hợp đồng đã ký (`SIGNED`), hệ thống/Admin Officer/Sale tạo **Đơn hàng (Customer Order)** liên kết với `customer_contract_id`.
*   **Vận chuyển & Giao hàng:** Kho xuất hàng và chuyển trạng thái đơn hàng (`PENDING` ➔ `SHIPPING` ➔ `COMPLETED`).
*   **Nghiệm thu hàng hóa:** Sau khi hàng được giao đến tay Khách hàng, Admin Officer/Manager lập **Biên bản Nghiệm thu (Acceptance Record)** xác nhận đầy đủ số lượng và chất lượng sản phẩm.

### GIAI ĐOẠN 6: THANH TOÁN & HÓA ĐƠN VAT (PAYMENT & INVOICE)
*   **Thanh toán:** Sau khi nhận hàng và nghiệm thu thành công, Khách hàng thực hiện thanh toán qua cổng **VNPay** (hoặc theo điều khoản hợp đồng).
*   **Hóa đơn VAT:** Admin Officer phát hành Hóa đơn VAT chính thức (kết nối với `contract_id` và `customer_order_id`).

### GIAI ĐOẠN 7: BÁO CÁO & KIỂM TOÁN (REPORTING & AUDIT TRAIL)
*   **Yêu cầu Nhập kho (Import Request):** Warehouse Staff thực hiện tạo hoặc tiếp nhận Yêu cầu Nhập kho để duy trì hạn mức tồn kho an toàn (`reorder_level`).
*   **Thông báo Realtime & Audit Trail:** Hệ thống phát thông báo realtime (SSE) cho người dùng khi có sự kiện thanh toán/giao hàng/duyệt hợp đồng. Toàn bộ lịch sử duyệt/sửa hợp đồng ghi vào `contract_edit_history`, hành động người dùng ghi vào `system_audit_log` và nhật ký mail gửi đi ghi vào `email_log`.

---

## 4. TỐI ƯU HÓA GIAO DIỆN & CHI TIẾT CÁC MODULE

### MODULE HỢP ĐỒNG (CONTRACT MODULE)
Sử dụng Mẫu tĩnh `/views/contract/template.jsp` làm thiết kế chuẩn:
1.  **Contract Management Dashboard:** Quản lý danh sách, lọc trạng thái, sinh hợp đồng tự động từ Quotation (`/contract-list`).
2.  **Contract Editor & History (Tab-based):** Màn hình chia 2 cột. Cột trái (70%) là trình soạn thảo nội dung (chỉ Admin Officer được sửa khi ở Draft/Pending Review). Cột phải (30%) là các Tabs chứa Lịch sử sửa đổi (`contract_edit_history`) và Lịch sử phê duyệt (`/contract-detail`).
3.  **Contract Signature Portal:** Cổng cho khách hàng xem và ký xác nhận điện tử (`/Signature`).

### CÁC MODULE CHÍNH & PHỤ TRỢ BỔ SUNG

1.  **Biên bản Nghiệm thu (Acceptance Record Module):**
    *   *Chức năng:* Quản lý việc lập và theo dõi Biên bản Nghiệm thu sản phẩm giữa Công ty và Khách hàng sau khi đơn hàng/hợp đồng được giao.
    *   *Màn hình & Endpoint:* `/acceptance-record` (`/views/acceptanceRecord/`).
2.  **Yêu cầu Nhập kho (Import Request Module):**
    *   *Chức năng:* Quản lý quy trình đề xuất nhập thêm nguyên liệu vào kho của Nhân viên Kho/Sale. Trạng thái phiếu: `1: Pending` (Chờ duyệt), `2: Imported` (Đã nhập kho), `3: Cancelled` (Đã hủy).
    *   *Màn hình & Endpoint:* `/import-request-list`, `/import-request-create`, `/import-request-detail` (`/views/importrequest/`).
3.  **Thông báo Realtime (Realtime Notification SSE Module):**
    *   *Chức năng:* Sử dụng cơ chế **Server-Sent Events (SSE)** để tự động đẩy thông báo thời gian thực về thanh toán, duyệt hợp đồng, đơn hàng, hóa đơn và đánh giá mới đến các User đang đăng nhập mà không cần load lại trang.
    *   *Endpoint:* `/realtime/notifications`.
4.  **Xác thực & Khôi phục Mật khẩu OTP (Auth & Password Recovery):**
    *   *Chức năng:* Đăng nhập, đăng xuất, và khôi phục mật khẩu bảo mật qua mã xác thực **OTP 6 số gửi tới Email** người dùng với thời gian hết hạn 5 phút.
    *   *Màn hình & Endpoint:* `/forgot-password`, `/views/auth/forgot_pass.jsp`.
5.  **Đánh giá Sản phẩm (Product Review Module):**
    *   *Chức năng:* Cho phép Khách hàng phản hồi, đánh giá chất lượng nguyên liệu bánh; giúp Manager/Sale theo dõi mức độ hài lòng của khách.
    *   *Màn hình & Endpoint:* Đính kèm trong màn hình chi tiết sản phẩm / quản lý review.
6.  **Nhật ký Kiểm toán Hệ thống (System Audit Log Module):**
    *   *Chức năng:* Ghi nhận chi tiết mọi thao tác (Thêm, Sửa, Xóa, Đăng nhập, Duyệt) của người dùng kèm mốc thời gian, IP và đối tượng bị tác động (`affected_object`).
    *   *Màn hình & Endpoint:* `/admin/audit-logs` (`/views/admin/audit_logs.jsp`).
7.  **Nhật ký Email System (Email Log Module):**
    *   *Chức năng:* Theo dõi toàn bộ lịch sử Email gửi ra từ hệ thống (email thông báo, OTP khôi phục mật khẩu, link ký hợp đồng) cùng trạng thái gửi (`SUCCESS`/`FAILED`).
    *   *Màn hình & Endpoint:* `/email/logs` (`/views/email/email_logs.jsp`).

### BẢNG MAPPING MODULE - ENDPOINT - VIEW - ROLE (CẬP NHẬT ĐẦY ĐỦ)
| Module | Endpoint URL | Thư mục JSP View | Phân quyền (Role Access) |
| :--- | :--- | :--- | :--- |
| **Dashboard** | `/dashboard`, `/admin-dashboard`, `/warehouse-dashboard` | `/views/dashboard/` | Tất cả Roles (5 View Dashboard riêng) |
| **Revenue & Sales Report** | `/revenue-report`, `/product-sales-report` | `/views/report/` | System Admin, Manager |
| **Auth & OTP Recovery** | `/login`, `/logout`, `/forgot-password` | `/views/auth/` | Tất cả (Public/User) |
| **Realtime SSE** | `/realtime/notifications` | Backend Event Stream | Tất cả Roles đã Đăng nhập |
| **User** | `/user-list`, `/create-user`, `/edit-user`... | `/views/user/` | System Admin, Manager |
| **Role** | `/role-list`, `/add-role`, `/role-detail`... | `/views/role/` | System Admin, Manager |
| **Customer** | `/customer-list`, `/customer/create`... | `/views/customer/` | System Admin, Manager, Sale, Admin Officer, Customer |
| **Category** | `/category/list`, `/category/create`... | `/views/category/` | System Admin, Sale, Warehouse, Customer |
| **Product** | `/product-list`, `/create-product`... | `/views/product/` | System Admin, Manager, Sale, Warehouse, Customer |
| **Product Review** | `/product-review`... | `/views/product/` | System Admin, Manager, Sale, Warehouse, Customer |
| **Quotation** | `/quotation-list`, `/quotation-create`... | `/views/quotation/` | System Admin, Sale, Admin Officer, Customer |
| **Contract** | `/contract-list`, `/contract-save`, `/contract-detail` | `/views/contract/` | System Admin, Manager, Admin Officer, Customer |
| **Signature** | `/Signature`, `/SignatureAcceptance` | `/views/signature/` | System Admin, Manager, Admin Officer, Customer |
| **Order** | `/customer-order-list`, `/create-order`... | `/views/customer-order/`| Tất cả Roles |
| **Acceptance Record** | `/acceptance-record` | `/views/acceptanceRecord/` | System Admin, Manager, Admin Officer |
| **Import Request** | `/import-request-list`, `/import-request-create`, `/import-request-detail` | `/views/importrequest/` | System Admin, Sale, Warehouse |
| **Invoice** | `/invoice-list`, `/invoice/create`, `/preview`| `/views/invoice/` | System Admin, Manager, Admin Officer, Customer |
| **Payment** | `/payment/list`, `/payment`, `/payment/detail`| `/views/payment/` | System Admin, Manager, Sale, Admin Officer, Customer |
| **Audit Logs** | `/admin/audit-logs` | `/views/admin/` | System Admin |
| **Email Logs** | `/email/logs` | `/views/email/` | System Admin |

---

## 5. CÁC QUYẾT ĐỊNH KỸ THUẬT QUAN TRỌNG (KEY ARCHITECTURE DECISIONS)

1.  **Single Source of Truth cho Mẫu Hợp Đồng:** KHÔNG sử dụng bảng `contract_template` trong Database để làm CRUD. Mẫu được lưu dưới dạng file template `/views/contract/template.jsp`. Đảm bảo tính nhất quán pháp lý cao nhất và giảm thời gian phát triển UI thừa.
2.  **Versioning & Audit Trail:** Sử dụng bảng `contract_edit_history` (và `contract_revision_item`) để lưu nội dung/trạng thái của từng lần sửa đổi và `system_audit_log` để lưu dấu vết người thao tác. Đảm bảo tiêu chuẩn kiểm toán (Non-repudiation).
3.  **Realtime Communications (SSE):** Sử dụng Server-Sent Events thay vì Polling liên tục, giúp giảm tải Server và tăng trải nghiệm người dùng tức thì.
4.  **Soft-Delete:** Không có hành động `DELETE` trên Contract, Quotation hay Order. Chỉ chuyển trạng thái (CANCELLED, VOIDED, INACTIVE).
5.  **Database Pagination & PreparedStatement:** Tất cả danh sách đều sử dụng `OFFSET ... FETCH NEXT` tại tầng SQL và dùng Parameterized Queries để chống SQL Injection và tối ưu bộ nhớ.