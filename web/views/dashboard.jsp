<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Pơ Bread</title>
</head>
<body>
    <h2>Welcome to Dashboard, ${user.fullName} (${user.userName})</h2>

    <p>Your Role ID: <strong>${user.roleId}</strong></p>

    <hr>
    <h3>Menu Chức Năng:</h3>
    <ul>
        <c:choose>
            <%-- Admin (Role = 1) --%>
            <c:when test="${user.roleId == 1}">
                <li><a href="${pageContext.request.contextPath}/role-list">Quản lý Nhóm Quyền (Role)</a></li>
                <li><a href="${pageContext.request.contextPath}/user-list">Quản lý Người Dùng (User)</a></li>
            </c:when>

            <%-- Manager (Role = 2) --%>
            <c:when test="${user.roleId == 2}">
                <li><a href="${pageContext.request.contextPath}/user-list">Quản lý Người Dùng (User)</a></li>
                <li><a href="${pageContext.request.contextPath}/customer-list">Quản lý Khách Hàng (Customer)</a></li>
                <li><a href="${pageContext.request.contextPath}/provider-list">Quản lý Nhà Cung Cấp (Provider)</a></li>
            </c:when>

            <%-- Sale (Role = 3) --%>
            <c:when test="${user.roleId == 3}">
                <li><a href="${pageContext.request.contextPath}/customer-list">Quản lý Khách Hàng (Customer)</a></li>
            </c:when>

            <%-- Provider (Role = 4) --%>
            <c:when test="${user.roleId == 4}">
                <li><a href="${pageContext.request.contextPath}/provider-list">Quản lý Hồ sơ Nhà Cung Cấp</a></li>
            </c:when>

            <%-- Customer (Role = 5) --%>
            <c:when test="${user.roleId == 5}">
                <li><a href="${pageContext.request.contextPath}/customer-list">Quản lý Hồ sơ Khách Hàng</a></li>
            </c:when>

            <c:otherwise>
                <p>Bạn chưa được phân quyền sử dụng chức năng nào.</p>
            </c:otherwise>
        </c:choose>
    </ul>

    <hr>
    <br>
    <a href="${pageContext.request.contextPath}/logout">Logout</a>

</body>
</html>
