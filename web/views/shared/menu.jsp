<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Menu</title>
</head>
<body>
<nav>
    <ul>
        <li><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/user-list">Users</a></li>

        <li><a href="${pageContext.request.contextPath}/customer-order-list">Customer Orders</a></li>
        
        <li><a href="${pageContext.request.contextPath}/customer/list">Customers</a></li>
        <li><a href="${pageContext.request.contextPath}/product-list">Product</a></li>
        <li><a href="${pageContext.request.contextPath}/category/list">Category</a></li>
        <li><a href="${pageContext.request.contextPath}/role-list">Roles</a></li>
        <li><a href="${pageContext.request.contextPath}/quotation-list">Quotation</a></li>
        <li><a href="${pageContext.request.contextPath}/user/password/change">Change password</a></li>
        <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
    </ul>
</nav>
</body>
</html>
