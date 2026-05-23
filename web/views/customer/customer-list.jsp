<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Danh sách khách hàng</title>
    </head>
    <body>

        <h2>Quản lý danh sách khách hàng (Hệ thống thành viên)</h2>

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
                        <td colspan="7">Không có dữ liệu khách hàng.</td>
                    </tr>
                </c:if>

                <c:forEach var="cust" items="${customerList}">
                    <tr>
                        <td>${cust.userId}</td>
                        <td>${cust.user.userName}</td>
                        <td><strong>${cust.user.fullName}</strong></td>
                        <td>${cust.user.email}</td>
                        <td>${cust.user.phone}</td>
                        <td></td>
                        <td><span>${cust.user.status}</span></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

    </body>
</html>
