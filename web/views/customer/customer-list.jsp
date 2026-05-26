<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Danh sach khach hang</title>
    </head>
    <body>

        <h2>Danh sach khach hang</h2>
        <h2>Quá quản lý danh sách khách hàng (Hệ thống thành viên)</h2>

        <table>
            <thead>
                <tr>
                    <th>Ma customer (ID) </th>
                    <th>Ten khach hang‹</th>
                    <th>Email</th>
                    <th>So dien thoai</th>
                    <th>Ma so thue</th>
                    <th>Trang thai</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${empty customerList}">
                    <tr>
                        <td colspan="7">Khong co du lieu khach hang</td>
                    </tr>
                </c:if>

                <c:forEach var="cust" items="${customerList}">
                    <tr>
                        <td>${cust.customer.customerId}</td>
                        <td><strong>${cust.user.fullName}</strong></td>
                        <td>${cust.user.email}</td>
                        <td>${cust.user.phone}</td>
                        <td>${cust.customer.taxCode}</td>
                        <td><span>${cust.user.status}</span></td>
                        <td>
                        <a href="${pageContext.request.contextPath}/CustomerDetail?id=${cust.customer.customerId}">View</a>
                        <a href="${pageContext.request.contextPath}/EditCustomer?id=${cust.customer.customerId}">Edit</a>
                    </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

    </body>
</html>

