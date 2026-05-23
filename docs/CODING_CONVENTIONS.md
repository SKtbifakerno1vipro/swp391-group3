# Quy tắc Code Project (SWP391 - Group 3)

## 1. Kiến trúc: MVCS (Model - View - Controller - Service)
Dự án tuân thủ mô hình 4 lớp:
- **Model**: Đại diện cho các bảng trong Database. Phải có tính kế thừa nếu DB có mối quan hệ 1-1.
- **View**: Chỉ sử dụng JSP + JSTL. Tuyệt đối không viết code Java (`<% %>`) trong JSP.
- **Controller**: Xử lý Request/Response, điều hướng. Chia nhỏ theo hành động (Action-based).
- **Service**: Chứa logic nghiệp vụ (Business Logic). Controller không gọi trực tiếp DAO mà gọi qua Service.
- **DAL (Data Access Layer)**: Chứa các file DAO để tương tác trực tiếp với SQL Server.


## 3. Quy tắc đặt tên (Naming Convention)
- **Controller**: `[Hành động][Đối tượng]Controller` (Ví dụ: `CreateUserController`, `ListProductController`).
- **Service**: `[Đối tượng]Service` (Ví dụ: `UserService`).
- **DAO**: `[Đối tượng]DAO` (Ví dụ: `UserDAO`).
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

// Sai: Khai báo trong web.xml
// <servlet><servlet-name>UserListController</servlet-name>...</servlet>
```

### 4.2 Forward vs Redirect — Khi nào dùng cái nào?

**Forward** (`RequestDispatcher.forward`):
- Server chuyển request nội bộ, **URL trên trình duyệt không đổi**.
- **Giữ nguyên** tất cả `request.setAttribute(...)`.
- Chỉ hoạt động trong cùng webapp.
- Dùng khi: cần render JSP sau khi xử lý dữ liệu (doGet), hoặc hiển thị lỗi.

```java
request.setAttribute("users", userService.searchUsers(null, null));
request.getRequestDispatcher("/views/user/list.jsp").forward(request, response);
```

**Redirect** (`response.sendRedirect`):
- Server trả mã `302`, trình duyệt gửi **request hoàn toàn mới** → **URL thay đổi**.
- **Mất** toàn bộ `request.setAttribute(...)`.
- Dùng khi: sau `doPost` để tránh user F5 submit lại form (PRG pattern).

```java
response.sendRedirect(request.getContextPath() + "/user-list");
```

**Quy tắc áp dụng:**
- `doGet` → ưu tiên **forward** tới JSP.
- `doPost` (sau khi insert/update/delete thành công) → ưu tiên **redirect** để tránh resubmit.
- Khi forward, nếu đích là một **controller khác** (ví dụ `/user-list`) → controller đó tự load data. Nếu đích là **JSP trực tiếp** (ví dụ `/views/user/list.jsp`) → phải `setAttribute` đầy đủ dữ liệu mà JSP cần, nếu không bảng sẽ hiển thị trống hoặc gây `NullPointerException`.

### 4.3 Luôn dùng contextPath cho URL
```java
// Redirect
response.sendRedirect(request.getContextPath() + "/user-list");

// Trong JSP
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
│   └── menu.jsp
├── auth/              ← Module đăng nhập/đăng xuất
│   └── login.jsp
├── user/              ← Module quản lý User
│   ├── list.jsp
│   ├── detail.jsp
│   └── form.jsp
├── customer/          ← Module quản lý Customer
│   ├── customer-list.jsp
│   ├── detail.jsp
│   ├── create.jsp
│   └── edit.jsp
├── provider/          ← Module quản lý Provider
│   ├── list.jsp
│   ├── detail.jsp
│   └── create.jsp
├── role/              ← Module quản lý Role & Permission
│   ├── list.jsp
│   ├── add-role.jsp
│   ├── edit-role.jsp
│   └── edit-role-permissions.jsp
└── dashboard.jsp      ← Dashboard chung
```

**Sai:**
```text
views/
├── admin/         ← Chia theo actor → sai
│   ├── Dashboard.jsp
│   └── menu.jsp
├── customer/      ← Chia theo actor → dễ bị duplicate JSP
│   └── ...
```

### 5.3 Phân quyền hiển thị bằng Permission Flag (RBAC)
- Không hard-code `roleId` trong JSP để ẩn/hiện UI.
- Controller phải tính toán quyền và truyền **cờ (flag)** vào request attribute.
- JSP chỉ check cờ bằng `<c:if>`.

**Controller:**
```java
User currentUser = (User) request.getSession().getAttribute("user");
boolean canEdit = permissionDAO.checkPermission(currentUser.getRoleId(), "EDIT_USER");
boolean canDelete = permissionDAO.checkPermission(currentUser.getRoleId(), "DELETE_USER");
request.setAttribute("canEdit", canEdit);
request.setAttribute("canDelete", canDelete);
```

**JSP (Đúng):**
```jsp
<c:if test="${canEdit}">
    <a href="${pageContext.request.contextPath}/edit-user?id=${u.userId}">Sửa</a>
</c:if>
<c:if test="${canDelete}">
    <button onclick="deleteUser(${u.userId})">Xóa</button>
</c:if>
```

**JSP (Sai — hard-code roleId):**
```jsp
<%-- KHÔNG LÀM THẾ NÀY --%>
<c:if test="${user.roleId == 1}">
    <a href="edit-user?id=${u.userId}">Sửa</a>
</c:if>
```

**Lợi ích:**
- Thêm actor mới → chỉ cần cập nhật bảng permission trong DB, không sửa JSP.
- Một JSP dùng chung cho tất cả actor, khác nhau qua cờ quyền.
- Tránh duplicate code view.


