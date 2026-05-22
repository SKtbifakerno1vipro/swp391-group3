<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách khách hàng</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 30px; background-color: #f8f9fa; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; background-color: #fff; }
        th, td { border: 1px solid #dee2e6; padding: 12px; text-align: left; }
        th { background-color: #007bff; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        .status-active { color: green; font-weight: bold; }
    </style>
</head>
<body>

    <h2>👥 Quản lý danh sách khách hàng (Hệ thống thành viên)</h2>

    <table>
        <thead>
            <tr>
                <th>Mã KH (User ID)</th>
                <th>Tài khoản</th>
                <th>Tên hiển thị</th>
                <th>Email</th>
                <th>Số điện thoại</th>
                <th>Địa chỉ riêng</th>
                <th>Trạng thái</th>
            </tr>
        </thead>
        <tbody>
            <c:if test="${empty customerList}">
                <tr>
                    <td colspan="7" style="text-align: center; color: #6c757d;">Không có dữ liệu khách hàng.</td>
                </tr>
            </c:if>
            
            <c:forEach var="cust" items="${customerList}">
                <tr>
                    <td>${cust.userId}</td>
                    <td>${cust.userName}</td>
                    <td><strong>${cust.fullName}</strong></td>
                    <td>${cust.email}</td>
                    <td>${cust.phone}</td>
                    <td></td>
                    <td><span class="status-active">${cust.status}</span></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

</body>
</html>