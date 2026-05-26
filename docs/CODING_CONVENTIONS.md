# Quy tắc Code Project (SWP391 - Group 3)

## 1. Kiến trúc: MVCS (Model - View - Controller - Service)
Dự án tuân thủ mô hình 4 lớp:
- **Model**: Đại diện CHÍNH XÁC 100% cho các bảng trong Database.
- **DTO (Data Transfer Object)**: Lớp bọc dữ liệu (Composition) dùng để chứa dữ liệu JOIN từ nhiều bảng phục vụ việc hiển thị trên View.
- **View**: Chỉ sử dụng JSP + JSTL. Tuyệt đối không viết code Java (`<% %>`) trong JSP.
- **Controller**: Xử lý Request/Response, điều hướng. Chia nhỏ theo hành động (Action-based).
- **Service**: Chứa logic nghiệp vụ (Business Logic). Controller không gọi trực tiếp DAO mà gọi qua Service.
- **DAL (Data Access Layer)**: Chứa các file DAO để tương tác trực tiếp với SQL Server.

## 2. Quy tắc Model & DTO (Tuyệt đối không dùng `extends` sai ngữ nghĩa)
### 2.1 Model (Ánh xạ 1-1 với Database)
- **Tuyệt đối không dùng `extends`** để mô phỏng quan hệ 1-1 (Ví dụ: `Customer extends User` là **SAI**).
- Model chỉ được phép chứa các trường tương ứng với các cột có thật trong Database.
- **Quan hệ 1-1 hoặc Khóa ngoại**: Sử dụng biến mang ID (Ví dụ: `private Integer userId;`).
- **Xử lý Nullable**: Nếu một cột trong Database cho phép `NULL` (ví dụ `role_id` hoặc `user_id` trong bảng `customer`), **bắt buộc** phải dùng class Wrapper (`Integer`, `Double`) thay vì kiểu nguyên thủy (`int`, `double`) để tránh lỗi NullPointerException khi mapping bằng ResultSet.

```java
// ĐÚNG: Model 100% DB Mapping
public class Customer {
    private int customerId; // Khóa chính (NOT NULL)
    private Integer userId; // Khóa ngoại (Cho phép NULL trong DB)
    private String taxCode;
}
```

### 2.2 DTO (Sử dụng Composition để hiển thị)
- Khi cần lấy dữ liệu tổng hợp (JOIN) từ nhiều bảng để hiển thị lên View, **KHÔNG** tạo class kiểu `CustomerDetail extends Customer`.
- **Tạo class mới trong package `dto`** và sử dụng **Composition** (Chứa đối tượng).

```java
// ĐÚNG: DTO dùng Composition (Nằm trong package dto)
public class CustomerDTO {
    private Customer customer;
    private User user;
    private String roleName; // Dữ liệu phụ lấy thêm từ JOIN
    
    // Getters / Setters
}
```

## 3. Quy tắc đặt tên (Naming Convention)
- **Controller**: `[Hành động][Đối tượng]Controller` (Ví dụ: `CreateUserController`, `ListProductController`).
- **Service**: `[Đối tượng]Service` (Ví dụ: `UserService`).
- **DAO**: `[Đối tượng]DAO` (Ví dụ: `UserDAO`).
- **DTO**: `[Đối tượng]DTO` (Ví dụ: `CustomerDTO`).
- **URL Mapping**: Dùng gạch nối `-`, không dùng CamelCase (Ví dụ: `/user-list`, `/create-customer`).

## 4. Quy tắc Controller (Servlet)

### 4.1 Sử dụng @WebServlet Annotation (Không dùng web.xml)
- Tất cả Servlet **bắt buộc** dùng `@WebServlet` annotation để khai báo URL mapping.
- File `web.xml` chỉ dùng cho những cấu hình **bắt buộc** không thể làm bằng annotation (ví dụ: `welcome-file-list`, `error-page`, `filter` đặc biệt).
- Không khai báo `<servlet>` và `<servlet-mapping>` trong `web.xml`.

```java
// Đúng: Dùng annotation
@WebServlet(name = "UserListController", urlPatterns = {"/user-list"})
public class UserListController extends HttpServlet { ... }
```

### 4.2 Forward vs Redirect — Khi nào dùng cái nào?

**Forward** (`RequestDispatcher.forward`):
- Server chuyển request nội bộ, **URL trên trình duyệt không đổi**.
- **Giữ nguyên** tất cả `request.setAttribute(...)`.
- Dùng khi: cần render JSP sau khi xử lý dữ liệu (thường ở `doGet`), hoặc hiển thị lỗi.

**Redirect** (`response.sendRedirect`):
- Server trả mã `302`, trình duyệt gửi **request hoàn toàn mới** → **URL thay đổi**.
- **Mất** toàn bộ `request.setAttribute(...)`.
- Dùng khi: sau `doPost` để tránh user F5 submit lại form (PRG pattern).

**Quy tắc áp dụng:**
- `doGet` → ưu tiên **forward** tới JSP.
- `doPost` (sau khi insert/update/delete thành công) → ưu tiên **redirect** để tránh resubmit.
- Tránh `forward` trực tiếp thẳng vào file `.jsp` nếu file đó cần dữ liệu DB (VD: `list.jsp`). Hãy `forward`/`redirect` sang Controller phụ trách (VD: `/user-list`) để nó tự load đủ Model/DTO.

### 4.3 Luôn dùng contextPath cho URL
```java
// Redirect trong Controller
response.sendRedirect(request.getContextPath() + "/user-list");
```
```jsp
<!-- Trong JSP -->
<a href="${pageContext.request.contextPath}/user-list">Users</a>
```

## 5. Quy tắc View (JSP & JSTL)

### 5.1 Cấu hình cơ bản
- Luôn khai báo UTF-8 ở đầu file.
- Sử dụng URI JSTL 1.2: `http://java.sun.com/jsp/jstl/core`.
- Luôn sử dụng `${pageContext.request.contextPath}` cho mọi đường dẫn tuyệt đối.

### 5.2 Tổ chức thư mục View theo Module (Không theo Actor)
- Chia thư mục `views/` theo **module chức năng** (đối tượng nghiệp vụ), **không** theo vai trò người dùng (actor).
- Một actor có thể dùng chung màn hình với actor khác → không tạo thư mục riêng cho từng actor.
- Các thành phần dùng chung (menu, header, footer) đặt trong `views/shared/`.

```text
views/
├── shared/            ← Component dùng chung (menu, header, footer)
├── auth/              ← Module đăng nhập/đăng xuất
├── user/              ← Module quản lý User
├── customer/          ← Module quản lý Customer
└── dashboard.jsp      ← Dashboard chung
```
*(Sai: Chia thư mục theo tên actor như `admin/`, `sale/` dẫn đến trùng lặp JSP).*

### 5.3 Phân quyền hiển thị bằng Permission Flag (RBAC)
- Không hard-code `roleId` trong JSP để ẩn/hiện UI.
- Controller phải tính toán quyền và truyền **cờ (flag)** vào request attribute.
- JSP chỉ check cờ bằng `<c:if>`.

**Controller:**
```java
boolean canEdit = permissionDAO.checkPermission(currentUser.getRoleId(), "EDIT_USER");
request.setAttribute("canEdit", canEdit);
```

**JSP:**
```jsp
<c:if test="${canEdit}">
    <a href="${pageContext.request.contextPath}/edit-user?id=${u.userId}">Sửa</a>
</c:if>
```

## 6. Quy tắc Database (SQL Server)
- Tên bảng: Số ít (Ví dụ: `role`, `product`). Riêng bảng `user` phải bọc trong ngoặc vuông `[user]` để tránh trùng từ khóa.
- Khóa chính: `[tên_bảng]_id`.
- Khóa ngoại: Phải nhất quán với tên bảng tham chiếu.