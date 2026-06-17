<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <aside class="sidebar">
            <div class="brand">
                <div class="brand-mark brand-logo-wrap"
                    style="width:52px;height:52px;min-width:52px;max-width:52px;overflow:hidden;border-radius:50%;background:#fff;">
                    <img class="brand-logo" src="${pageContext.request.contextPath}/assets/img/po-bread-logo.jpg"
                        alt="Po Bread logo"
                        style="width:100%;height:100%;max-width:100%;max-height:100%;object-fit:contain;display:block;">
                </div>
                <div>
                    <h1 class="brand-title">Po Bread</h1>
                    <p class="brand-subtitle">Sales Process Portal</p>
                </div>
            </div>

            <nav class="nav-group" aria-label="Main navigation">
                <a class="nav-link ${param.activeMenu == 'dashboard' ? 'active' : ''}"
                    href="${pageContext.request.contextPath}/dashboard"><span
                        class="material-symbols-outlined">dashboard</span>Dashboard</a>
                <a class="nav-link ${param.activeMenu == 'customers' ? 'active' : ''}"
                    href="${pageContext.request.contextPath}/customer/list"><span
                        class="material-symbols-outlined">groups</span>Customers</a>
                <a class="nav-link ${param.activeMenu == 'orders' ? 'active' : ''}"
                    href="${pageContext.request.contextPath}/customer-order-list"><span
                        class="material-symbols-outlined">receipt_long</span>Orders</a>
                <a class="nav-link ${param.activeMenu == 'products' ? 'active' : ''}"
                    href="${pageContext.request.contextPath}/product-list"><span
                        class="material-symbols-outlined">inventory_2</span>Products</a>
                <a class="nav-link ${param.activeMenu == 'categories' ? 'active' : ''}"
                    href="${pageContext.request.contextPath}/category/list"><span
                        class="material-symbols-outlined">category</span>Categories</a>
                <a class="nav-link ${param.activeMenu == 'quotations' ? 'active' : ''}"
                    href="${pageContext.request.contextPath}/quotation-list"><span
                        class="material-symbols-outlined">request_quote</span>Quotations</a>
                <a class="nav-link ${param.activeMenu == 'contracts' ? 'active' : ''}"
                    href="${pageContext.request.contextPath}/contract-list"><span
                        class="material-symbols-outlined">contract</span>Contracts</a>
                <a class="nav-link ${param.activeMenu == 'users' ? 'active' : ''}"
                    href="${pageContext.request.contextPath}/user-list"><span
                        class="material-symbols-outlined">manage_accounts</span>Users</a>
                <a class="nav-link ${param.activeMenu == 'roles' ? 'active' : ''}"
                    href="${pageContext.request.contextPath}/role-list"><span
                        class="material-symbols-outlined">admin_panel_settings</span>Roles</a>
                <c:if test="${sessionScope.user.roleId == 1 || sessionScope.user.roleId == 2}">
                    <a class="nav-link ${param.activeMenu == 'emailLogs' ? 'active' : ''}"
                        href="${pageContext.request.contextPath}/email/logs"><span
                            class="material-symbols-outlined">mail</span>Email Logs</a>
                </c:if>
            </nav>

            <div class="sidebar-footer">
                <c:if test="${not empty sessionScope.user}">
                    <div class="user-card">
                        <div class="avatar"><span class="material-symbols-outlined">person</span></div>
                        <div>
                            <strong>
                                <c:out value="${sessionScope.user.fullName}" />
                            </strong><br>
                            <small>@
                                <c:out value="${sessionScope.user.userName}" /> - Role
                                <c:out value="${sessionScope.user.roleId}" />
                            </small>
                        </div>
                    </div>
                </c:if>
                <a class="nav-link" href="${pageContext.request.contextPath}/user/password/change"><span
                        class="material-symbols-outlined">lock_reset</span>Change password</a>
                <a class="nav-link" href="${pageContext.request.contextPath}/logout"><span
                        class="material-symbols-outlined">logout</span>Logout</a>
            </div>
        </aside>