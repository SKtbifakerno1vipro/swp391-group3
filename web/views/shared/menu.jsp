<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <!-- Thanh menu chung -->
    <nav style="background-color: #f8f9fa; padding: 10px; margin-bottom: 20px; border-bottom: 1px solid #dee2e6;">
        <ul style="list-style-type: none; padding: 0; margin: 0; display: flex; gap: 15px;">
            <li><a href="${pageContext.request.contextPath}/dashboard"
                    style="text-decoration: none; color: #333; font-weight: bold;">Bảng điều khiển</a></li>
            <li><a href="${pageContext.request.contextPath}/user-list"
                    style="text-decoration: none; color: #333;">Người dùng</a></li>
            <li><a href="${pageContext.request.contextPath}/role-list"
                    style="text-decoration: none; color: #333;">Vai trò</a></li>
            <li><a href="${pageContext.request.contextPath}/customer/list"
                    style="text-decoration: none; color: #333;">Khách hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/customer-order-list"
                    style="text-decoration: none; color: #333;">Đơn hàng khách hàng</a></li>
            <li><a href="${pageContext.request.contextPath}/product-list"
                    style="text-decoration: none; color: #333;">Sản phẩm</a></li>
            <li><a href="${pageContext.request.contextPath}/category/list"
                    style="text-decoration: none; color: #333;">Danh mục</a></li>
            <li><a href="${pageContext.request.contextPath}/quotation-list"
                    style="text-decoration: none; color: #333;">Báo giá</a></li>
            <li><a href="${pageContext.request.contextPath}/Signature" style="text-decoration: none; color: #333;">Chữ ký mẫu</a></li>
            <li><a href="${pageContext.request.contextPath}/contract-list"
                    style="text-decoration: none; color: #333;">Quản lý hợp đồng</a></li>
            <li style="margin-left: auto;">
                <% 
                    model.User userMenu = (model.User) session.getAttribute("user");
                    if (userMenu != null && (userMenu.getRoleId() == 1 || userMenu.getRoleId() == 2)) {
                %>
                <a href="${pageContext.request.contextPath}/revenue-report"
                    style="text-decoration: none; color: #28a745; font-weight: bold; margin-right: 15px;">Báo cáo thống kê hệ thống</a>
                <% } %>
                <a href="${pageContext.request.contextPath}/user/password/change"
                    style="text-decoration: none; color: #0056b3;">Đổi mật khẩu</a>
            </li>
            <li><a href="${pageContext.request.contextPath}/logout"
                    style="text-decoration: none; color: #dc3545;">Đăng xuất</a></li>
        </ul>
    </nav>