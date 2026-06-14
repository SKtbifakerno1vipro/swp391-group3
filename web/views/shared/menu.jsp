<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- Thanh menu chung -->
<nav style="background-color: #f8f9fa; padding: 10px; margin-bottom: 20px; border-bottom: 1px solid #dee2e6;">
    <ul style="list-style-type: none; padding: 0; margin: 0; display: flex; gap: 15px;">
        <li><a href="${pageContext.request.contextPath}/dashboard" style="text-decoration: none; color: #333; font-weight: bold;">Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/user-list" style="text-decoration: none; color: #333;">Users</a></li>
        <li><a href="${pageContext.request.contextPath}/role-list" style="text-decoration: none; color: #333;">Roles</a></li>
        <li><a href="${pageContext.request.contextPath}/customer/list" style="text-decoration: none; color: #333;">Customers</a></li>
        <li><a href="${pageContext.request.contextPath}/customer-order-list" style="text-decoration: none; color: #333;">Customer Orders</a></li>
        <li><a href="${pageContext.request.contextPath}/product-list" style="text-decoration: none; color: #333;">Products</a></li>
        <li><a href="${pageContext.request.contextPath}/category/list" style="text-decoration: none; color: #333;">Categories</a></li>
        <li><a href="${pageContext.request.contextPath}/quotation-list" style="text-decoration: none; color: #333;">Quotations</a></li>
        <li><a href="${pageContext.request.contextPath}/Signature" style="text-decoration: none; color: #333;">Demo Signature</a></li>
        
        <li style="margin-left: auto;"><a href="${pageContext.request.contextPath}/user/password/change" style="text-decoration: none; color: #0056b3;">Change password</a></li>
        <li><a href="${pageContext.request.contextPath}/logout" style="text-decoration: none; color: #dc3545;">Logout</a></li>
    </ul>
</nav>
