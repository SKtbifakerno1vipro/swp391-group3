<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <aside class="sidebar">
            <!-- Section 1: Brand Logo -->
            <div class="sidebar-section brand-section">
                <div class="brand">
                    <div class="sidebar-icon-wrap">
                        <div class="brand-mark brand-logo-wrap"
                            style="width:32px;height:32px;overflow:hidden;border-radius:50%;background:#fff;display:flex;align-items:center;justify-content:center;">
                            <img class="brand-logo"
                                src="${pageContext.request.contextPath}/assets/img/po-bread-logo.jpg"
                                alt="Po Bread logo" style="width:100%;height:100%;object-fit:contain;display:block;">
                        </div>
                    </div>
                    <div class="sidebar-text">
                        <h1 class="brand-title">Po Bread</h1>
                        <p class="brand-subtitle">Cổng quản lý quy trình bán hàng</p>
                    </div>
                </div>
            </div>

            <!-- Section 2: Navigation Menu -->
            <div class="sidebar-section nav-section">
                <nav class="nav-group" aria-label="Main navigation">
                    <c:choose>
                        <%-- ROLE 1: SYSTEM ADMIN --%>
                        <c:when test="${sessionScope.user.roleId == 1}">
                            <a class="nav-link ${param.activeMenu == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/dashboard" title="Bảng điều khiển"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">dashboard</span></div><span class="sidebar-text">Bảng điều khiển</span></a>
                            <a class="nav-link ${param.activeMenu == 'profile' ? 'active' : ''}" href="${pageContext.request.contextPath}/edit-user?id=${sessionScope.user.userId}" title="Hồ sơ của tôi"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">account_circle</span></div><span class="sidebar-text">Hồ sơ của tôi</span></a>
                            <a class="nav-link ${param.activeMenu == 'users' ? 'active' : ''}" href="${pageContext.request.contextPath}/user-list" title="Người dùng"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">manage_accounts</span></div><span class="sidebar-text">Người dùng</span></a>
                            <a class="nav-link ${param.activeMenu == 'roles' ? 'active' : ''}" href="${pageContext.request.contextPath}/role-list" title="Vai trò"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">admin_panel_settings</span></div><span class="sidebar-text">Vai trò</span></a>
                            <a class="nav-link ${param.activeMenu == 'customers' ? 'active' : ''}" href="${pageContext.request.contextPath}/customer/list" title="Khách hàng"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">groups</span></div><span class="sidebar-text">Khách hàng</span></a>
                            <a class="nav-link ${param.activeMenu == 'orders' ? 'active' : ''}" href="${pageContext.request.contextPath}/customer-order-list" title="Đơn hàng"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">receipt_long</span></div><span class="sidebar-text">Đơn hàng</span></a>
                            <a class="nav-link ${param.activeMenu == 'categories' ? 'active' : ''}" href="${pageContext.request.contextPath}/category/list" title="Danh mục"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">category</span></div><span class="sidebar-text">Danh mục</span></a>
                            <a class="nav-link ${param.activeMenu == 'products' ? 'active' : ''}" href="${pageContext.request.contextPath}/product-list" title="Sản phẩm"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">inventory_2</span></div><span class="sidebar-text">Sản phẩm</span></a>
                            <a class="nav-link ${param.activeMenu == 'reviews' ? 'active' : ''}" href="${pageContext.request.contextPath}/product-review" title="Đánh giá & Phản hồi"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">reviews</span></div><span class="sidebar-text">Đánh giá</span></a>
                            <a class="nav-link ${param.activeMenu == 'quotations' ? 'active' : ''}" href="${pageContext.request.contextPath}/quotation-list" title="Báo giá"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">request_quote</span></div><span class="sidebar-text">Báo giá</span></a>
                            <a class="nav-link ${param.activeMenu == 'contracts' ? 'active' : ''}" href="${pageContext.request.contextPath}/contract-list" title="Hợp đồng"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">contract</span></div><span class="sidebar-text">Hợp đồng</span></a>
                            <a class="nav-link ${param.activeMenu == 'invoices' ? 'active' : ''}" href="${pageContext.request.contextPath}/invoice-list" title="Hóa đơn"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">receipt</span></div><span class="sidebar-text">Hóa đơn</span></a>
                            <a class="nav-link ${param.activeMenu == 'payments' ? 'active' : ''}" href="${pageContext.request.contextPath}/payment/list" title="Thanh toán"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">payments</span></div><span class="sidebar-text">Thanh toán</span></a>
                            <a class="nav-link ${param.activeMenu == 'import-requests' ? 'active' : ''}" href="${pageContext.request.contextPath}/import-request-list" title="Yêu cầu nhập kho"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">unarchive</span></div><span class="sidebar-text">Yêu cầu nhập kho</span></a>
                            <a class="nav-link ${param.activeMenu == 'revenue' ? 'active' : ''}" href="${pageContext.request.contextPath}/revenue-report" title="Báo cáo doanh thu"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">analytics</span></div><span class="sidebar-text">Báo cáo</span></a>
                            <a class="nav-link ${param.activeMenu == 'emailLogs' ? 'active' : ''}" href="${pageContext.request.contextPath}/email/logs" title="Nhật ký Email"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">mail</span></div><span class="sidebar-text">Nhật ký Email</span></a>
                            <a class="nav-link ${param.activeMenu == 'auditLogs' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/audit-logs" title="Nhật ký hệ thống"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">history</span></div><span class="sidebar-text">Nhật ký hệ thống</span></a>
                        </c:when>

                        <%-- ROLE 2: MANAGER --%>
                        <c:when test="${sessionScope.user.roleId == 2}">
                            <a class="nav-link ${param.activeMenu == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/dashboard" title="Bảng điều khiển"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">dashboard</span></div><span class="sidebar-text">Bảng điều khiển</span></a>
                            <a class="nav-link ${param.activeMenu == 'profile' ? 'active' : ''}" href="${pageContext.request.contextPath}/edit-user?id=${sessionScope.user.userId}" title="Hồ sơ của tôi"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">account_circle</span></div><span class="sidebar-text">Hồ sơ của tôi</span></a>
                            <a class="nav-link ${param.activeMenu == 'users' ? 'active' : ''}" href="${pageContext.request.contextPath}/user-list" title="Người dùng"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">manage_accounts</span></div><span class="sidebar-text">Người dùng</span></a>
                            <a class="nav-link ${param.activeMenu == 'roles' ? 'active' : ''}" href="${pageContext.request.contextPath}/role-list" title="Vai trò"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">admin_panel_settings</span></div><span class="sidebar-text">Vai trò</span></a>
                            <a class="nav-link ${param.activeMenu == 'customers' ? 'active' : ''}" href="${pageContext.request.contextPath}/customer/list" title="Khách hàng"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">groups</span></div><span class="sidebar-text">Khách hàng</span></a>
                            <a class="nav-link ${param.activeMenu == 'orders' ? 'active' : ''}" href="${pageContext.request.contextPath}/customer-order-list" title="Đơn hàng"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">receipt_long</span></div><span class="sidebar-text">Đơn hàng</span></a>
                            <a class="nav-link ${param.activeMenu == 'products' ? 'active' : ''}" href="${pageContext.request.contextPath}/product-list" title="Sản phẩm"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">inventory_2</span></div><span class="sidebar-text">Sản phẩm</span></a>
                            <a class="nav-link ${param.activeMenu == 'reviews' ? 'active' : ''}" href="${pageContext.request.contextPath}/product-review" title="Đánh giá & Phản hồi"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">reviews</span></div><span class="sidebar-text">Đánh giá</span></a>
                            <a class="nav-link ${param.activeMenu == 'contracts' ? 'active' : ''}" href="${pageContext.request.contextPath}/contract-list" title="Hợp đồng"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">contract</span></div><span class="sidebar-text">Hợp đồng</span></a>
                            <a class="nav-link ${param.activeMenu == 'invoices' ? 'active' : ''}" href="${pageContext.request.contextPath}/invoice-list" title="Hóa đơn"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">receipt</span></div><span class="sidebar-text">Hóa đơn</span></a>
                            <a class="nav-link ${param.activeMenu == 'payments' ? 'active' : ''}" href="${pageContext.request.contextPath}/payment/list" title="Thanh toán"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">payments</span></div><span class="sidebar-text">Thanh toán</span></a>
                            <a class="nav-link ${param.activeMenu == 'import-requests' ? 'active' : ''}" href="${pageContext.request.contextPath}/import-request-list" title="Yêu cầu nhập kho"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">unarchive</span></div><span class="sidebar-text">Yêu cầu nhập kho</span></a>
                            <a class="nav-link ${param.activeMenu == 'revenue' ? 'active' : ''}" href="${pageContext.request.contextPath}/revenue-report" title="Báo cáo doanh thu"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">analytics</span></div><span class="sidebar-text">Báo cáo</span></a>
                        </c:when>

                        <%-- ROLE 3: CUSTOMER --%>
                        <c:when test="${sessionScope.user.roleId == 3}">
                            <a class="nav-link ${param.activeMenu == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/dashboard" title="Bảng điều khiển"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">dashboard</span></div><span class="sidebar-text">Bảng điều khiển</span></a>
                            <a class="nav-link ${param.activeMenu == 'profile' ? 'active' : ''}" href="${pageContext.request.contextPath}/customer/detail?id_cus=${sessionScope.customerId}" title="Hồ sơ của tôi"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">account_circle</span></div><span class="sidebar-text">Hồ sơ của tôi</span></a>
                            <a class="nav-link ${param.activeMenu == 'orders' ? 'active' : ''}" href="${pageContext.request.contextPath}/customer-order-list" title="Đơn hàng"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">receipt_long</span></div><span class="sidebar-text">Đơn hàng</span></a>
                            <a class="nav-link ${param.activeMenu == 'categories' ? 'active' : ''}" href="${pageContext.request.contextPath}/category/list" title="Danh mục"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">category</span></div><span class="sidebar-text">Danh mục</span></a>
                            <a class="nav-link ${param.activeMenu == 'products' ? 'active' : ''}" href="${pageContext.request.contextPath}/product-list" title="Sản phẩm"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">inventory_2</span></div><span class="sidebar-text">Sản phẩm</span></a>
                            <a class="nav-link ${param.activeMenu == 'quotations' ? 'active' : ''}" href="${pageContext.request.contextPath}/quotation-list" title="Báo giá"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">request_quote</span></div><span class="sidebar-text">Báo giá</span></a>
                            <a class="nav-link ${param.activeMenu == 'contracts' ? 'active' : ''}" href="${pageContext.request.contextPath}/contract-list" title="Hợp đồng"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">contract</span></div><span class="sidebar-text">Hợp đồng</span></a>
                            <a class="nav-link ${param.activeMenu == 'invoices' ? 'active' : ''}" href="${pageContext.request.contextPath}/invoice-list" title="Hóa đơn"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">receipt</span></div><span class="sidebar-text">Hóa đơn</span></a>
                            <a class="nav-link ${param.activeMenu == 'payments' ? 'active' : ''}" href="${pageContext.request.contextPath}/payment/list" title="Thanh toán"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">payments</span></div><span class="sidebar-text">Thanh toán</span></a>
                        </c:when>

                        <%-- ROLE 4: SALE --%>
                        <c:when test="${sessionScope.user.roleId == 4}">
                            <a class="nav-link ${param.activeMenu == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/dashboard" title="Bảng điều khiển"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">dashboard</span></div><span class="sidebar-text">Bảng điều khiển</span></a>
                            <a class="nav-link ${param.activeMenu == 'profile' ? 'active' : ''}" href="${pageContext.request.contextPath}/edit-user?id=${sessionScope.user.userId}" title="Hồ sơ của tôi"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">account_circle</span></div><span class="sidebar-text">Hồ sơ của tôi</span></a>
                            <a class="nav-link ${param.activeMenu == 'customers' ? 'active' : ''}" href="${pageContext.request.contextPath}/customer/list" title="Khách hàng"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">groups</span></div><span class="sidebar-text">Khách hàng</span></a>
                            <a class="nav-link ${param.activeMenu == 'orders' ? 'active' : ''}" href="${pageContext.request.contextPath}/customer-order-list" title="Đơn hàng"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">receipt_long</span></div><span class="sidebar-text">Đơn hàng</span></a>
                            <a class="nav-link ${param.activeMenu == 'categories' ? 'active' : ''}" href="${pageContext.request.contextPath}/category/list" title="Danh mục"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">category</span></div><span class="sidebar-text">Danh mục</span></a>
                            <a class="nav-link ${param.activeMenu == 'products' ? 'active' : ''}" href="${pageContext.request.contextPath}/product-list" title="Sản phẩm"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">inventory_2</span></div><span class="sidebar-text">Sản phẩm</span></a>
                            <a class="nav-link ${param.activeMenu == 'reviews' ? 'active' : ''}" href="${pageContext.request.contextPath}/product-review" title="Đánh giá & Phản hồi"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">reviews</span></div><span class="sidebar-text">Đánh giá</span></a>
                            <a class="nav-link ${param.activeMenu == 'quotations' ? 'active' : ''}" href="${pageContext.request.contextPath}/quotation-list" title="Báo giá"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">request_quote</span></div><span class="sidebar-text">Báo giá</span></a>
                            <a class="nav-link ${param.activeMenu == 'payments' ? 'active' : ''}" href="${pageContext.request.contextPath}/payment/list" title="Thanh toán"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">payments</span></div><span class="sidebar-text">Thanh toán</span></a>
                            <a class="nav-link ${param.activeMenu == 'import-requests' ? 'active' : ''}" href="${pageContext.request.contextPath}/import-request-list" title="Yêu cầu nhập kho"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">unarchive</span></div><span class="sidebar-text">Yêu cầu nhập kho</span></a>
                        </c:when>

                        <%-- ROLE 5: ADMIN OFFICER --%>
                        <c:when test="${sessionScope.user.roleId == 5}">
                            <a class="nav-link ${param.activeMenu == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/dashboard" title="Bảng điều khiển"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">dashboard</span></div><span class="sidebar-text">Bảng điều khiển</span></a>
                            <a class="nav-link ${param.activeMenu == 'profile' ? 'active' : ''}" href="${pageContext.request.contextPath}/edit-user?id=${sessionScope.user.userId}" title="Hồ sơ của tôi"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">account_circle</span></div><span class="sidebar-text">Hồ sơ của tôi</span></a>
                            <a class="nav-link ${param.activeMenu == 'customers' ? 'active' : ''}" href="${pageContext.request.contextPath}/customer/list" title="Khách hàng"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">groups</span></div><span class="sidebar-text">Khách hàng</span></a>
                            <a class="nav-link ${param.activeMenu == 'orders' ? 'active' : ''}" href="${pageContext.request.contextPath}/customer-order-list" title="Đơn hàng"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">receipt_long</span></div><span class="sidebar-text">Đơn hàng</span></a>
                            <a class="nav-link ${param.activeMenu == 'reviews' ? 'active' : ''}" href="${pageContext.request.contextPath}/product-review" title="Đánh giá & Phản hồi"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">reviews</span></div><span class="sidebar-text">Đánh giá</span></a>
                            <a class="nav-link ${param.activeMenu == 'quotations' ? 'active' : ''}" href="${pageContext.request.contextPath}/quotation-list" title="Báo giá"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">request_quote</span></div><span class="sidebar-text">Báo giá</span></a>
                            <a class="nav-link ${param.activeMenu == 'contracts' ? 'active' : ''}" href="${pageContext.request.contextPath}/contract-list" title="Hợp đồng"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">contract</span></div><span class="sidebar-text">Hợp đồng</span></a>
                            <a class="nav-link ${param.activeMenu == 'invoices' ? 'active' : ''}" href="${pageContext.request.contextPath}/invoice-list" title="Hóa đơn"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">receipt</span></div><span class="sidebar-text">Hóa đơn</span></a>
                            <a class="nav-link ${param.activeMenu == 'payments' ? 'active' : ''}" href="${pageContext.request.contextPath}/payment/list" title="Thanh toán"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">payments</span></div><span class="sidebar-text">Thanh toán</span></a>
                        </c:when>

                        <%-- ROLE 6: WAREHOUSE --%>
                        <c:when test="${sessionScope.user.roleId == 6}">
                            <a class="nav-link ${param.activeMenu == 'profile' ? 'active' : ''}" href="${pageContext.request.contextPath}/edit-user?id=${sessionScope.user.userId}" title="Hồ sơ của tôi"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">account_circle</span></div><span class="sidebar-text">Hồ sơ của tôi</span></a>
                            <a class="nav-link ${param.activeMenu == 'orders' ? 'active' : ''}" href="${pageContext.request.contextPath}/customer-order-list" title="Đơn hàng"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">receipt_long</span></div><span class="sidebar-text">Đơn hàng</span></a>
                            <a class="nav-link ${param.activeMenu == 'categories' ? 'active' : ''}" href="${pageContext.request.contextPath}/category/list" title="Danh mục"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">category</span></div><span class="sidebar-text">Danh mục</span></a>
                            <a class="nav-link ${param.activeMenu == 'products' ? 'active' : ''}" href="${pageContext.request.contextPath}/product-list" title="Sản phẩm"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">inventory_2</span></div><span class="sidebar-text">Sản phẩm</span></a>
                            <a class="nav-link ${param.activeMenu == 'reviews' ? 'active' : ''}" href="${pageContext.request.contextPath}/product-review" title="Đánh giá & Phản hồi"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">reviews</span></div><span class="sidebar-text">Đánh giá</span></a>
                            <a class="nav-link ${param.activeMenu == 'contracts' ? 'active' : ''}" href="${pageContext.request.contextPath}/contract-list" title="Hợp đồng"><div class="sidebar-icon-wrap"><span class="material-symbols-outlined">contract</span></div><span class="sidebar-text">Hợp đồng</span></a>
                            <a class="nav-link ${param.activeMenu == 'import-requests' ? 'active' : ''}" href="${pageContext.request.contextPath}/import-request-list" title="Yêu cầu nhập kho">
                                <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">unarchive</span></div>
                                <span class="sidebar-text">
                                    Yêu cầu nhập kho
                                    <c:if test="${pendingImportsCount > 0}">
                                        <span style="background-color: #ff9800; color: white; border-radius: 10px; padding: 2px 8px; font-size: 11px; margin-left: 5px;">${pendingImportsCount}</span>
                                    </c:if>
                                </span>
                            </a>
                        </c:when>

                    </c:choose>
                </nav>
            </div>

            <div class="sidebar-footer" style="display: flex; flex-direction: column; gap: 8px;">
                <!-- Section 3: User Profile -->
                <c:if test="${not empty sessionScope.user}">
                    <div class="sidebar-section profile-section">
                        <div class="user-card">
                            <div class="sidebar-icon-wrap">
                                <div class="avatar"><span class="material-symbols-outlined">person</span></div>
                            </div>
                            <div class="sidebar-text">
                                <strong>
                                    <c:out value="${sessionScope.user.fullName}" />
                                </strong><br>
                                <small>@
                                    <c:out value="${sessionScope.user.userName}" /><br>
                                    <c:choose>
                                        <c:when test="${sessionScope.user.roleId == 1}">Admin</c:when>
                                        <c:when test="${sessionScope.user.roleId == 2}">Manager</c:when>
                                        <c:when test="${sessionScope.user.roleId == 3}">Customer</c:when>
                                        <c:when test="${sessionScope.user.roleId == 4}">Sale</c:when>
                                        <c:when test="${sessionScope.user.roleId == 5}">Admin Officer</c:when>
                                        <c:when test="${sessionScope.user.roleId == 6}">Warehouse</c:when>
                                        <c:otherwise>Role
                                            <c:out value="${sessionScope.user.roleId}" />
                                        </c:otherwise>
                                    </c:choose>
                                </small>
                            </div>
                        </div>
                    </div>
                </c:if>

                <!-- Section 4: Actions -->
                <div class="sidebar-section actions-section">
                    <a class="nav-link" href="${pageContext.request.contextPath}/user/password/change"
                        title="Đổi mật khẩu">
                        <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">lock_reset</span></div>
                        <span class="sidebar-text">Đổi mật khẩu</span>
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/logout" title="Đăng xuất">
                        <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">logout</span></div>
                        <span class="sidebar-text">Đăng xuất</span>
                    </a>
                </div>
        </aside>

        <!--  this is realtime notification, contact XHieu if you have a question-->

        <c:if test="${not empty sessionScope.user}">
            <!-- Realtime Notification Toast Container -->
            <div id="realtime-toast-container" style="
         position: fixed;
         top: 20px;
         left: 50%;
         transform: translateX(-50%);
         z-index: 99999;
         display: flex;
         flex-direction: column;
         align-items: center;
         gap: 12px;
         width: 650px;
         pointer-events: none;
         "></div>

            <style>
                .toast-box {
                    pointer-events: auto;
                    background: #ffffff;
                    color: #1e293b;
                    border-radius: 12px;
                    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
                    padding: 16px;
                    display: flex;
                    align-items: center;
                    gap: 14px;
                    font-family: 'Nunito Sans', sans-serif;
                    border-left: 5px solid var(--primary);
                    animation: toastSlideIn 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) forwards, toastFadeOut 0.5s ease-in 9.5s forwards;
                    opacity: 0;
                    width: 100%;
                    box-sizing: border-box;
                }

                .toast-box.info {
                    border-left-color: #3b82f6;
                }

                .toast-box.success {
                    border-left-color: #10b981;
                }

                @keyframes toastSlideIn {
                    from {
                        transform: translateY(-80px) scale(0.9);
                        opacity: 0;
                    }

                    to {
                        transform: translateY(0) scale(1);
                        opacity: 1;
                    }
                }

                @keyframes toastFadeOut {
                    from {
                        opacity: 1;
                        transform: translateY(0) scale(1);
                    }

                    to {
                        opacity: 0;
                        transform: translateY(-20px) scale(0.95);
                    }
                }

                .toast-icon {
                    font-size: 28px;
                    flex-shrink: 0;
                }

                .toast-content {
                    flex-grow: 1;
                }

                .toast-title {
                    font-weight: 800;
                    font-size: 16px;
                    margin: 0;
                }

                .toast-desc {
                    font-size: 14px;
                    color: #64748b;
                    margin: 2px 0 0 0;
                }

                .toast-btn {
                    font-size: 13px;
                    font-weight: 800;
                    text-transform: uppercase;
                    color: var(--primary);
                    text-decoration: none;
                    margin-left: 8px;
                    text-align: right;
                    line-height: 1.3;
                    flex-shrink: 0;
                }




                .toast-btn:hover {
                    text-decoration: underline;
                }
            </style>



            <script>
                console.log("[Realtime Notification] Connecting to: ${pageContext.request.contextPath}/realtime/notifications");
                const notifySource = new EventSource("${pageContext.request.contextPath}/realtime/notifications");

                notifySource.onopen = function (event) {
                    console.log("[Realtime Notification] Connection opened successfully!");
                };

                notifySource.onerror = function (event) {
                    console.error("[Realtime Notification] Connection error. State: " + notifySource.readyState);
                };

                notifySource.addEventListener('notification', function (event) {
                    console.log("[Realtime Notification] Raw event data received:", event.data);
                    try {
                        const notify = JSON.parse(event.data);
                        console.log("[Realtime Notification] Parsed payload:", notify);
                        triggerToast(
                            notify.type,
                            notify.title,
                            notify.message,
                            notify.link,
                            notify.btnText
                        );
                    } catch (e) {
                        console.error("[Realtime Notification] Failed to parse JSON:", e);
                    }
                });

                function triggerToast(type, title, description, detailUrl, btnText) {
                    console.log("[Realtime Notification] Triggering toast: ", { type, title, description, detailUrl, btnText });
                    const container = document.getElementById("realtime-toast-container");
                    if (!container) {
                        console.error("[Realtime Notification] Container #realtime-toast-container not found!");
                        return;
                    }

                    const id = 'toast-' + Date.now();
                    const icon = type === 'success' ? 'payments' : 'person_add';
                    const color = type === 'success' ? '#10b981' : '#3b82f6';
                    const actionText = btnText || 'Xem ngay';

                    let toastHtml = '<div id="' + id + '" class="toast-box ' + type + '">' +
                        '<span class="material-symbols-outlined toast-icon" style="color: ' + color + ';">' + icon + '</span>' +
                        '<div class="toast-content">' +
                        '<p class="toast-title">' + title + '</p>' +
                        '<p class="toast-desc">' + description + '</p>' +
                        '</div>';
                    if (detailUrl) {
                        toastHtml += '<a href="' + detailUrl + '" class="toast-btn">' + actionText + '</a>';
                    }
                    toastHtml += '</div>';

                    container.insertAdjacentHTML('beforeend', toastHtml);

                    setTimeout(() => {
                        const toastElement = document.getElementById(id);
                        if (toastElement) {
                            console.log("[Realtime Notification] Removing expired toast:", id);
                            toastElement.remove();
                        }
                    }, 10000);
                }

                window.addEventListener('beforeunload', () => {
                    console.log("[Realtime Notification] Closing connection due to page unload.");
                    notifySource.close();
                });
            </script>
        </c:if>