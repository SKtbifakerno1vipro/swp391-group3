<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Chi tiết khách hàng - Terra Enterprise</title>

                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap"
                    rel="stylesheet">
                <link
                    href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">

                <style>
                    .container {
                        max-width: 1200px;
                        margin: 0 auto;
                    }

                    .header-section {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-bottom: 25px;
                    }

                    h1 {
                        font-family: 'Literata', Georgia, serif;
                        font-size: 28px;
                        font-weight: 700;
                        margin: 0;
                        color: var(--text);
                    }

                    /* KPI Container & Cards */
                    .kpi-container {
                        display: grid;
                        grid-template-columns: repeat(5, 1fr);
                        gap: 16px;
                        margin-bottom: 30px;
                    }

                    .kpi-card {
                        background: var(--surface);
                        padding: 18px 16px;
                        border-radius: 18px;
                        border: 1px solid rgba(221, 213, 201, 0.85);
                        border-left: 6px solid var(--secondary);
                        box-shadow: var(--shadow);
                    }

                    .kpi-card.info {
                        border-left-color: #2b7fff;
                    }

                    .kpi-card.primary {
                        border-left-color: #8b5cf6;
                    }

                    .kpi-card.success {
                        border-left-color: var(--primary);
                    }

                    .kpi-card.warning {
                        border-left-color: var(--tertiary);
                    }

                    @media (max-width: 1024px) {
                        .kpi-container {
                            grid-template-columns: repeat(3, 1fr);
                        }
                    }

                    @media (max-width: 600px) {
                        .kpi-container {
                            grid-template-columns: 1fr;
                        }
                    }

                    .kpi-title {
                        font-size: 11px;
                        text-transform: uppercase;
                        color: var(--muted);
                        font-weight: 800;
                        letter-spacing: 0.05em;
                        margin-bottom: 8px;
                    }

                    .kpi-value {
                        font-size: 22px;
                        font-weight: 800;
                        color: var(--text);
                    }

                    /* 2-column layout for personal info */
                    .info-grid {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 24px;
                        margin-bottom: 30px;
                    }

                    .info-section {
                        background: var(--surface);
                        padding: 24px;
                        border: 1px solid rgba(221, 213, 201, 0.85);
                        border-radius: 22px;
                        box-shadow: var(--shadow);
                    }

                    .info-section h3 {
                        font-family: 'Literata', Georgia, serif;
                        margin-top: 0;
                        margin-bottom: 20px;
                        font-size: 18px;
                        border-bottom: 1px solid var(--line);
                        padding-bottom: 10px;
                        color: var(--text);
                    }

                    .info-row {
                        display: flex;
                        margin-bottom: 12px;
                        font-size: 14px;
                    }

                    .info-label {
                        width: 160px;
                        font-weight: 700;
                        color: var(--muted);
                    }

                    .info-value {
                        flex: 1;
                        color: var(--text);
                    }

                    /* Status badge */
                    .badge {
                        display: inline-block;
                        padding: 4px 10px;
                        font-size: 11px;
                        font-weight: 800;
                        text-transform: uppercase;
                        letter-spacing: 0.05em;
                        border-radius: 12px;
                    }

                    .badge-active {
                        background-color: var(--primary-soft);
                        color: var(--primary);
                    }

                    .badge-inactive {
                        background-color: var(--danger-soft);
                        color: var(--danger);
                    }

                    .badge-role {
                        background-color: var(--surface-soft);
                        color: var(--muted);
                        border: 1px solid var(--line);
                    }



                    /* Action buttons & links */
                    .btn-action-sm {
                        display: inline-block;
                        padding: 6px 14px;
                        font-size: 12px;
                        font-weight: 800;
                        text-decoration: none;
                        border-radius: 999px;
                        background-color: var(--primary-soft);
                        color: var(--primary) !important;
                        transition: all 0.2s ease;
                    }

                    .btn-action-sm:hover {
                        background-color: var(--primary);
                        color: #fff !important;
                    }

                    .btn-group {
                        margin-top: 30px;
                        display: flex;
                        gap: 12px;
                    }

                    .btn-edit {
                        display: inline-block;
                        color: #fff !important;
                        background-color: var(--primary);
                        padding: 10px 24px;
                        font-size: 14px;
                        font-weight: 800;
                        border-radius: 999px;
                        text-decoration: none;
                        box-shadow: var(--shadow);
                        transition: all 0.2s ease;
                    }

                    .btn-edit:hover {
                        transform: translateY(-2px);
                        filter: brightness(1.1);
                    }

                    .btn-back {
                        display: inline-block;
                        color: var(--text) !important;
                        background-color: var(--surface-soft);
                        padding: 10px 24px;
                        font-size: 14px;
                        font-weight: 800;
                        border-radius: 999px;
                        text-decoration: none;
                        border: 1px solid var(--line);
                        transition: all 0.2s ease;
                    }

                    .btn-back:hover {
                        background-color: var(--surface-strong);
                        transform: translateY(-2px);
                    }

                    .btn-remove {
                        display: inline-block;
                        color: #fff !important;
                        background-color: var(--danger, #dc3545);
                        padding: 10px 24px;
                        font-size: 14px;
                        font-weight: 800;
                        border-radius: 999px;
                        text-decoration: none;
                        box-shadow: var(--shadow);
                        transition: all 0.2s ease;
                        border: none;
                        cursor: pointer;
                    }

                    .btn-remove:hover {
                        transform: translateY(-2px);
                        filter: brightness(1.1);
                    }

                    .btn-activate {
                        display: inline-block;
                        color: #fff !important;
                        background-color: var(--primary, #28a745);
                        padding: 10px 24px;
                        font-size: 14px;
                        font-weight: 800;
                        border-radius: 999px;
                        text-decoration: none;
                        box-shadow: var(--shadow);
                        transition: all 0.2s ease;
                        border: none;
                        cursor: pointer;
                    }

                    .btn-activate:hover {
                        transform: translateY(-2px);
                        filter: brightness(1.1);
                    }
                </style>
            </head>

            <body>
                <div class="dashboard-shell">
                    <jsp:include page="/views/shared/sidebar.jsp">
                        <jsp:param name="activeMenu" value="${sessionScope.user.roleId == 3 ? 'profile' : 'customers'}" />
                    </jsp:include>
                    <main class="main legacy-page">
                        <div class="container">
                            <div class="header-section">
                                <div>
                                    <h1>Hồ sơ khách hàng</h1>
                                    <span style="color: var(--muted); font-size: 14px;">ID:
                                        ${cusDTO.customer.customerId} |
                                        User ID: ${cusDTO.user.userId}</span>
                                </div>
                            </div>

                            <div class="kpi-container">
                                <div class="kpi-card">
                                    <div class="kpi-title">Tổng số đơn hàng</div>
                                    <div class="kpi-value">${not empty totalOrders ? totalOrders : 0}
                                        Đơn hàng</div>
                                </div>
                                <div class="kpi-card info">
                                    <div class="kpi-title">Số lượng báo giá</div>
                                    <div class="kpi-value">${not empty totalQuotations ? totalQuotations : 0}
                                        Báo giá</div>
                                </div>
                                <div class="kpi-card primary">
                                    <div class="kpi-title">Số lượng hợp đồng</div>
                                    <div class="kpi-value">${not empty totalContracts ? totalContracts : 0}
                                        Hợp đồng</div>
                                </div>
                                <div class="kpi-card success">
                                    <div class="kpi-title">Tổng tiền thanh toán</div>
                                    <div class="kpi-value">
                                        <fmt:formatNumber value="${totalPaid != null ? totalPaid : 0}" type="currency"
                                            currencySymbol="VND" maxFractionDigits="0" />
                                    </div>
                                </div>
                                <div class="kpi-card warning">
                                    <div class="kpi-title">Trạng thái tài khoản</div>
                                    <div class="kpi-value" style="font-size: 18px; padding-top: 2px;">
                                         <span
                                             class="badge ${cusDTO.user.status == 'ACTIVE' ? 'badge-active' : 'badge-inactive'}">${cusDTO.user.status}</span>
                                    </div>
                                </div>
                            </div>

                            <div class="info-grid">
                                <div class="info-section">
                                    <h3>Thông tin tài khoản & Liên hệ</h3>
                                    <div class="info-row">
                                        <div class="info-label">Tên đăng nhập:</div>
                                        <div class="info-value">${cusDTO.user.userName}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">Họ và tên:</div>
                                        <div class="info-value">${not empty cusDTO.user.fullName ? cusDTO.user.fullName
                                             : 'N/A'}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">Địa chỉ Email:</div>
                                        <div class="info-value">${cusDTO.user.email}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">Số điện thoại:</div>
                                        <div class="info-value">${not empty cusDTO.user.phone ? cusDTO.user.phone :
                                             'N/A'}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">Giới tính:</div>
                                        <div class="info-value">
                                            <c:choose>
                                                <c:when test="${cusDTO.user.gender == 'M'}">Nam</c:when>
                                                <c:when test="${cusDTO.user.gender == 'F'}">Nữ</c:when>
                                                <c:when test="${cusDTO.user.gender == 'O'}">Khác</c:when>
                                                <c:otherwise>N/A</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">Ngày sinh:</div>
                                        <div class="info-value">${not empty cusDTO.user.dateBirth ? cusDTO.user.dateBirth : 'N/A'}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">Địa chỉ:</div>
                                        <div class="info-value">${not empty cusDTO.user.address ? cusDTO.user.address : 'N/A'}</div>
                                    </div>
                                     <div class="info-row">
                                         <div class="info-label">Vai trò hệ thống:</div>
                                         <div class="info-value">Khách hàng</div>
                                     </div>
                                </div>

                                <div class="info-section">
                                    <h3>Hồ sơ thương mại</h3>
                                    <div class="info-row">
                                        <div class="info-label">Tên công ty:</div>
                                        <div class="info-value"><strong>${cusDTO.customer.companyName}</strong></div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">Mã số thuế:</div>
                                        <div class="info-value">${not empty cusDTO.customer.taxCode ?
                                             cusDTO.customer.taxCode : 'N/A'}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">Loại khách hàng:</div>
                                        <div class="info-value">${cusDTO.customer.customerType}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">Nhân viên Sale phụ trách:</div>
                                        <div class="info-value" style="color: var(--primary); font-weight: 700;">
                                             <c:choose>
                                                 <c:when test="${not empty cusDTO.customer.assignedToUserId}">
                                                     <c:forEach var="u" items="${listSales}">
                                                         <c:if test="${cusDTO.customer.assignedToUserId == u.userId}">
                                                             ${u.fullName} (${u.userName})
                                                         </c:if>
                                                     </c:forEach>
                                                 </c:when>
                                                 <c:otherwise><span class="text-muted"
                                                         style="font-weight: 400;">Chưa phân công</span></c:otherwise>
                                             </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>



                            <div class="btn-group">
                                <a href="${pageContext.request.contextPath}/customer/edit?id=${cusDTO.customer.customerId}"
                                    class="btn-edit">Chỉnh sửa hồ sơ</a>
                                <c:if test="${sessionScope.user.roleId == 1 || sessionScope.user.roleId == 2 || sessionScope.user.roleId == 4}">
                                    <c:if test="${cusDTO.user.status == 'ACTIVE'}">
                                        <a href="${pageContext.request.contextPath}/customer/detail?action=deactivate&id_cus=${cusDTO.customer.customerId}"
                                            class="btn-remove"
                                            onclick="return confirm('Bạn có chắc chắn muốn vô hiệu hóa khách hàng này không?');">Vô hiệu hóa</a>
                                    </c:if>
                                    <c:if test="${cusDTO.user.status == 'INACTIVE'}">
                                        <a href="${pageContext.request.contextPath}/customer/detail?action=activate&id_cus=${cusDTO.customer.customerId}"
                                            class="btn-activate"
                                            onclick="return confirm('Bạn có chắc chắn muốn kích hoạt khách hàng này không?');">Kích hoạt</a>
                                    </c:if>
                                </c:if>
                                <c:if test="${sessionScope.user.roleId == 1 || sessionScope.user.roleId == 2 || sessionScope.user.roleId == 4 || sessionScope.user.roleId == 5}">
                                    <a href="${pageContext.request.contextPath}/customer/list" class="btn-back">Quay lại danh sách</a>
                                </c:if>
                            </div>
                        </div>



                    </main>
                </div>
            </body>

            </html>