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
            <c:choose>
                <c:when test="${sessionScope.user.roleId == 3}">
                <a class="nav-link ${param.activeMenu == 'profile' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/customer/detail?id_cus=${sessionScope.customerId}"><span
                        class="material-symbols-outlined">account_circle</span>My Profile</a>
                <a class="nav-link ${param.activeMenu == 'quotations' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/quotation-list"><span
                        class="material-symbols-outlined">request_quote</span>Quotations</a>
                <a class="nav-link ${param.activeMenu == 'contracts' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/contract-list"><span
                        class="material-symbols-outlined">contract</span>Contracts</a>
                <a class="nav-link ${param.activeMenu == 'orders' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/customer-order-list"><span
                        class="material-symbols-outlined">receipt_long</span>My Orders</a>
                <a class="nav-link ${param.activeMenu == 'payments' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/payment/list"><span
                        class="material-symbols-outlined">payments</span>My Payments</a>
                </c:when>
                <c:when test="${sessionScope.user.roleId == 5}">
                    
                <a class="nav-link ${param.activeMenu == 'quotations' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/quotation-list"><span
                        class="material-symbols-outlined">request_quote</span>Quotations</a>
                <a class="nav-link ${param.activeMenu == 'contracts' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/contract-list"><span
                        class="material-symbols-outlined">contract</span>Contracts</a>
                <a class="nav-link ${param.activeMenu == 'orders' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/customer-order-list"><span
                        class="material-symbols-outlined">shopping_cart</span>Orders</a>
                <a class="nav-link ${param.activeMenu == 'invoices' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/invoice-list"><span
                        class="material-symbols-outlined">receipt</span>My Invoices</a>
                <a class="nav-link ${param.activeMenu == 'payments' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/payment/list"><span
                        class="material-symbols-outlined">payments</span>Payments</a>
                        
                </c:when>
                <c:otherwise>

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
                <a class="nav-link ${param.activeMenu == 'payments' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/payment/list"><span
                        class="material-symbols-outlined">payments</span>Payments</a>

                <a class="nav-link ${param.activeMenu == 'invoices' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/invoice-list"><span
                        class="material-symbols-outlined">receipt</span>Invoices</a>
                <a class="nav-link ${param.activeMenu == 'users' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/user-list"><span
                        class="material-symbols-outlined">manage_accounts</span>Users</a>
                <a class="nav-link ${param.activeMenu == 'roles' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/role-list"><span
                        class="material-symbols-outlined">admin_panel_settings</span>Roles</a>
                    <c:if test="${sessionScope.user.roleId == 2 || sessionScope.user.roleId == 4}">
                    <a class="nav-link ${param.activeMenu == 'revenue' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/revenue-report"><span
                            class="material-symbols-outlined">analytics</span>Revenue Report</a>
                    </c:if>
                    <c:if test="${sessionScope.user.roleId == 1}">
                    <a class="nav-link ${param.activeMenu == 'emailLogs' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/email/logs"><span
                            class="material-symbols-outlined">mail</span>Email Logs</a>
                    <a class="nav-link ${param.activeMenu == 'auditLogs' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/admin/audit-logs"><span
                            class="material-symbols-outlined">history</span>System Audit Logs</a>
                    </c:if>
                </c:otherwise>
            </c:choose>
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
                        <c:out value="${sessionScope.user.userName}" />
                        <br>
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
        </c:if>
        <a class="nav-link" href="${pageContext.request.contextPath}/user/password/change"><span
                class="material-symbols-outlined">lock_reset</span>Change password</a>
        <a class="nav-link" href="${pageContext.request.contextPath}/logout"><span
                class="material-symbols-outlined">logout</span>Logout</a>
    </div>
</aside>

<!-- XHieu, this is realtime notification, contact me if you have a question-->

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

        notifySource.onopen = function(event) {
            console.log("[Realtime Notification] Connection opened successfully!");
        };

        notifySource.onerror = function(event) {
            console.error("[Realtime Notification] Connection error. State: " + notifySource.readyState);
        };

        notifySource.addEventListener('notification', function(event) {
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
            } catch(e) {
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