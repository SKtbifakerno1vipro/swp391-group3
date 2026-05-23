# Quy tắc Code Project (SWP391 - Group 3)

## 1. Kiến trúc: MVCS (Model - View - Controller - Service)
Dự án tuân thủ mô hình 4 lớp:
- **Model**: Đại diện cho các bảng trong Database. Phải có tính kế thừa nếu DB có mối quan hệ 1-1.
- **View**: Chỉ sử dụng JSP + JSTL. Tuyệt đối không viết code Java (`<% %>`) trong JSP.
- **Controller**: Xử lý Request/Response, điều hướng. Chia nhỏ theo hành động (Action-based).
- **Service**: (Lớp mới cần bổ sung) Chứa logic nghiệp vụ (Business Logic). Controller không gọi trực tiếp DAO mà gọi qua Service.
- **DAL (Data Access Layer)**: Chứa các file DAO để tương tác trực tiếp với SQL Server.

## 2. Quy tắc Model (Kế thừa từ User)
Vì trong Database, `customer` và `provider` có quan hệ 1-1 với `user`, cấu trúc Model phải phản ánh điều này:
- `User`: Lớp cơ sở (Base Class) chứa thông tin đăng nhập, trạng thái, vai trò.
- `Customer extends User`: Chứa thêm `customerId`, `taxCode`, `type`.
- `Provider extends User`: Chứa thêm `providerId`, `taxCode`, `providerName`.
- **Lợi ích**: Khi lấy một đối tượng `Customer`, ta nghiễm nhiên có các thuộc tính `userName`, `email`, `fullName` mà không cần bọc trong lớp `Detail` phức tạp.

## 3. Quy tắc đặt tên (Naming Convention)
- **Controller**: `[Hành động][Đối tượng]Controller` (Ví dụ: `CreateUserController`, `ListProductController`).
- **Service**: `[Đối tượng]Service` (Ví dụ: `UserService`).
- **DAO**: `[Đối tượng]DAO` (Ví dụ: `UserDAO`).
- **URL Mapping**: Dùng gạch nối `-`, không dùng CamelCase (Ví dụ: `/user-list`, `/create-customer`).

## 4. Quy tắc View (JSP & JSTL)
- Luôn khai báo UTF-8 ở đầu file.
- Sử dụng URI JSTL 1.2: `http://java.sun.com/jsp/jstl/core`.
- Luôn sử dụng `${pageContext.request.contextPath}` cho mọi đường dẫn tuyệt đối.

## 5. Quy tắc Database (SQL Server)
- Tên bảng: Số ít (Ví dụ: `role`, `product`). Riêng bảng `user` phải bọc trong ngoặc vuông `[user]` để tránh trùng từ khóa.
- Khóa chính: `[tên_bảng]_id`.
- Khóa ngoại: Phải nhất quán với tên bảng tham chiếu.
