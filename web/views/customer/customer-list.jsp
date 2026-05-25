<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Danh sÃ¡ch khÃ¡ch hÃ ng</title>
    </head>
    <body>

        <h2>Quá quản lý danh sách khách hàng (Hệ thống thành viên)</h2>

        <table>
            <thead>
                <tr>
                    <th>MÃ£ KH (User ID)</th>
                    <th>TÃ i khoáº£n</th>
                    <th>TÃªn hiá»ƒn thá»‹</th>
                    <th>Email</th>
                    <th>Sá»‘ Ä‘iá»‡n thoáº¡i</th>
                    <th>Äá»‹a chá»‰ riÃªng</th>
                    <th>Tráº¡ng thÃ¡i</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${empty customerList}">
                    <tr>
                        <td colspan="7">KhÃ´ng cÃ³ dá»¯ liá»‡u khÃ¡ch hÃ ng.</td>
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

