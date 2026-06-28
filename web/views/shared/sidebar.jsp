<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<aside class="sidebar">
    <!-- Section 1: Brand Logo -->
    <div class="sidebar-section brand-section">
        <div class="brand">
            <div class="sidebar-icon-wrap">
                <div class="brand-mark brand-logo-wrap"
                     style="width:32px;height:32px;overflow:hidden;border-radius:50%;background:#fff;display:flex;align-items:center;justify-content:center;">
                    <img class="brand-logo" src="${pageContext.request.contextPath}/assets/img/po-bread-logo.jpg"
                         alt="Po Bread logo"
                         style="width:100%;height:100%;object-fit:contain;display:block;">
                </div>
            </div>
            <div class="sidebar-text">
                <h1 class="brand-title">Po Bread</h1>
                <p class="brand-subtitle">Sales Process Portal</p>
            </div>
        </div>
    </div>

    <!-- Section 2: Navigation Menu -->
    <div class="sidebar-section nav-section">
        <nav class="nav-group" aria-label="Main navigation">
            <a class="nav-link ${param.activeMenu == 'dashboard' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/dashboard" title="Dashboard">
                <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">dashboard</span></div>
                <span class="sidebar-text">Dashboard</span>
            </a>
            <c:choose>
                <c:when test="${sessionScope.user.roleId == 3}">
                    <a class="nav-link ${param.activeMenu == 'profile' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/customer/detail?id_cus=${sessionScope.customerId}" title="My Profile">
                        <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">account_circle</span></div>
                        <span class="sidebar-text">My Profile</span>
                    </a>
                    <a class="nav-link ${param.activeMenu == 'quotations' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/quotation-list" title="Quotations">
                        <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">request_quote</span></div>
                        <span class="sidebar-text">Quotations</span>
                    </a>
                    <a class="nav-link ${param.activeMenu == 'contracts' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/contract-list" title="Contracts">
                        <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">contract</span></div>
                        <span class="sidebar-text">Contracts</span>
                    </a>
                    <a class="nav-link ${param.activeMenu == 'orders' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/customer-order-list" title="My Orders">
                        <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">receipt_long</span></div>
                        <span class="sidebar-text">My Orders</span>
                    </a>
                    <a class="nav-link ${param.activeMenu == 'payments' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/payment/list" title="My Payments">
                        <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">payments</span></div>
                        <span class="sidebar-text">My Payments</span>
                    </a>
                </c:when>
                <c:when test="${sessionScope.user.roleId == 5}">
                    <a class="nav-link ${param.activeMenu == 'quotations' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/quotation-list" title="Quotations">
                        <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">request_quote</span></div>
                        <span class="sidebar-text">Quotations</span>
                    </a>
                    <a class="nav-link ${param.activeMenu == 'contracts' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/contract-list" title="Contracts">
                        <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">contract</span></div>
                        <span class="sidebar-text">Contracts</span>
                    </a>
                    <a class="nav-link ${param.activeMenu == 'orders' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/customer-order-list" title="Orders">
                        <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">shopping_cart</span></div>
                        <span class="sidebar-text">Orders</span>
                    </a>
                    <a class="nav-link ${param.activeMenu == 'invoices' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/invoice-list" title="My Invoices">
                        <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">receipt</span></div>
                        <span class="sidebar-text">My Invoices</span>
                    </a>
                    <a class="nav-link ${param.activeMenu == 'payments' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/payment/list" title="Payments">
                        <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">payments</span></div>
                        <span class="sidebar-text">Payments</span>
                    </a>
                </c:when>
                <c:otherwise>
                    <a class="nav-link ${param.activeMenu == 'customers' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/customer/list" title="Customers">
                        <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">groups</span></div>
                        <span class="sidebar-text">Customers</span>
                    </a>
                    <a class="nav-link ${param.activeMenu == 'orders' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/customer-order-list" title="Orders">
                        <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">receipt_long</span></div>
                        <span class="sidebar-text">Orders</span>
                    </a>
                    <a class="nav-link ${param.activeMenu == 'products' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/product-list" title="Products">
                        <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">inventory_2</span></div>
                        <span class="sidebar-text">Products</span>
                    </a>
                    <a class="nav-link ${param.activeMenu == 'categories' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/category/list" title="Categories">
                        <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">category</span></div>
                        <span class="sidebar-text">Categories</span>
                    </a>
                    <a class="nav-link ${param.activeMenu == 'quotations' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/quotation-list" title="Quotations">
                        <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">request_quote</span></div>
                        <span class="sidebar-text">Quotations</span>
                    </a>
                    <a class="nav-link ${param.activeMenu == 'contracts' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/contract-list" title="Contracts">
                        <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">contract</span></div>
                        <span class="sidebar-text">Contracts</span>
                    </a>
                    <a class="nav-link ${param.activeMenu == 'payments' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/payment/list" title="Payments">
                        <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">payments</span></div>
                        <span class="sidebar-text">Payments</span>
                    </a>
                    <a class="nav-link ${param.activeMenu == 'invoices' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/invoice-list" title="Invoices">
                        <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">receipt</span></div>
                        <span class="sidebar-text">Invoices</span>
                    </a>
                    <a class="nav-link ${param.activeMenu == 'users' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/user-list" title="Users">
                        <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">manage_accounts</span></div>
                        <span class="sidebar-text">Users</span>
                    </a>
                    <a class="nav-link ${param.activeMenu == 'roles' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/role-list" title="Roles">
                        <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">admin_panel_settings</span></div>
                        <span class="sidebar-text">Roles</span>
                    </a>
                    <c:if test="${sessionScope.user.roleId == 2 || sessionScope.user.roleId == 4}">
                        <a class="nav-link ${param.activeMenu == 'revenue' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/revenue-report" title="Revenue Report">
                            <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">analytics</span></div>
                            <span class="sidebar-text">Revenue Report</span>
                        </a>
                    </c:if>
                    <c:if test="${sessionScope.user.roleId == 1}">
                        <a class="nav-link ${param.activeMenu == 'emailLogs' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/email/logs" title="Email Logs">
                            <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">mail</span></div>
                            <span class="sidebar-text">Email Logs</span>
                        </a>
                        <a class="nav-link ${param.activeMenu == 'auditLogs' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/admin/audit-logs" title="System Audit Logs">
                            <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">history</span></div>
                            <span class="sidebar-text">System Audit Logs</span>
                        </a>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </nav>
    </div>

    <!-- Section 3: User Profile -->
    <c:if test="${not empty sessionScope.user}">
        <div class="sidebar-section profile-section">
            <div class="user-card">
                <div class="sidebar-icon-wrap">
                    <div class="avatar"><span class="material-symbols-outlined">person</span></div>
                </div>
                <div class="sidebar-text">
                    <strong><c:out value="${sessionScope.user.fullName}" /></strong><br>
                    <small>@<c:out value="${sessionScope.user.userName}" /><br>
                        <c:choose>
                            <c:when test="${sessionScope.user.roleId == 1}">Admin</c:when>
                            <c:when test="${sessionScope.user.roleId == 2}">Manager</c:when>
                            <c:when test="${sessionScope.user.roleId == 3}">Customer</c:when>
                            <c:when test="${sessionScope.user.roleId == 4}">Sale</c:when>
                            <c:when test="${sessionScope.user.roleId == 5}">Admin Officer</c:when>
                            <c:otherwise>Role <c:out value="${sessionScope.user.roleId}" /></c:otherwise>
                        </c:choose>
                    </small>
                </div>
            </div>
        </div>
    </c:if>

    <!-- Section 4: Actions -->
    <div class="sidebar-section actions-section">
        <a class="nav-link" href="${pageContext.request.contextPath}/user/password/change" title="Change password">
            <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">lock_reset</span></div>
            <span class="sidebar-text">Change password</span>
        </a>
        <a class="nav-link" href="${pageContext.request.contextPath}/logout" title="Logout">
            <div class="sidebar-icon-wrap"><span class="material-symbols-outlined">logout</span></div>
            <span class="sidebar-text">Logout</span>
        </a>
    </div>
</aside>