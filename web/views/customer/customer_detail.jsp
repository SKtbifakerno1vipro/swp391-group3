<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Customer Details - Terra Enterprise</title>

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
                        grid-template-columns: repeat(3, 1fr);
                        gap: 20px;
                        margin-bottom: 30px;
                    }

                    .kpi-card {
                        background: var(--surface);
                        padding: 20px;
                        border-radius: 18px;
                        border: 1px solid rgba(221, 213, 201, 0.85);
                        border-left: 6px solid var(--secondary);
                        box-shadow: var(--shadow);
                    }

                    .kpi-card.success {
                        border-left-color: var(--primary);
                    }

                    .kpi-card.warning {
                        border-left-color: var(--tertiary);
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

                    /* Tabs Handling */
                    .tabs-container {
                        margin-top: 30px;
                    }

                    .tab-menu {
                        display: flex;
                        border-bottom: 1px solid var(--line);
                        margin-bottom: 20px;
                        padding: 0;
                        list-style: none;
                    }

                    .tab-item {
                        padding: 12px 24px;
                        cursor: pointer;
                        font-weight: 800;
                        font-size: 14px;
                        color: var(--muted);
                        border: 1px solid transparent;
                        border-bottom: none;
                        margin-bottom: -1px;
                        border-radius: 16px 16px 0 0;
                        transition: all 0.2s ease;
                    }

                    .tab-item:hover {
                        color: var(--primary);
                        background-color: var(--primary-soft);
                    }

                    .tab-item.active {
                        color: var(--primary);
                        background-color: var(--surface);
                        border-color: rgba(221, 213, 201, 0.85) rgba(221, 213, 201, 0.85) var(--bg);
                    }

                    .tab-content {
                        display: none;
                    }

                    .tab-content.active {
                        display: block;
                    }

                    .text-right {
                        text-align: right;
                    }

                    .no-data {
                        text-align: center;
                        color: var(--muted);
                        padding: 30px !important;
                        font-style: italic;
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
                        <jsp:param name="activeMenu" value="customers" />
                    </jsp:include>
                    <main class="main legacy-page">
                        <div class="container">
                            <div class="header-section">
                                <div>
                                    <h1>Customer Profile</h1>
                                    <span style="color: var(--muted); font-size: 14px;">ID:
                                        ${cusDTO.customerId} |
                                        User ID: ${cusDTO.userId}</span>
                                </div>
                                <div>
                                    <%-- THEM BAO VE NGHIEP VU: Neu la Sale Staff thi cho phep bam nut tao bao gia nhanh
                                        cho rieng khach nay --%>
                                        <c:if test="${sessionScope.user.roleId == 4}">
                                            <a href="${pageContext.request.contextPath}/quotation/create?customerId=${cusDTO.customerId}"
                                                class="btn-edit">+ Quick Quotation</a>
                                        </c:if>
                                </div>
                            </div>

                            <div class="kpi-container">
                                <div class="kpi-card">
                                    <div class="kpi-title">Total Orders Placed</div>
                                    <div class="kpi-value">${listOrdersForCus != null ? listOrdersForCus.size() : 0}
                                        Orders</div>
                                </div>
                                <div class="kpi-card success">
                                    <div class="kpi-title">Total Paid Amount</div>
                                    <div class="kpi-value">
                                        <fmt:formatNumber value="${totalPaid != null ? totalPaid : 0}" type="currency"
                                            currencySymbol="VND" maxFractionDigits="0" />
                                    </div>
                                </div>
                                <div class="kpi-card warning">
                                    <div class="kpi-title">Account Status</div>
                                    <div class="kpi-value" style="font-size: 18px; padding-top: 2px;">
                                        <span
                                            class="badge ${cusDTO.status == 'ACTIVE' ? 'badge-active' : 'badge-inactive'}">${cusDTO.status}</span>
                                    </div>
                                </div>
                            </div>

                            <div class="info-grid">
                                <div class="info-section">
                                    <h3>Account & Contact Info</h3>
                                    <div class="info-row">
                                        <div class="info-label">Username:</div>
                                        <div class="info-value">${cusDTO.userName}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">Full Name:</div>
                                        <div class="info-value">${not empty cusDTO.fullName ? cusDTO.fullName
                                            : 'N/A'}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">Email Address:</div>
                                        <div class="info-value">${cusDTO.email}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">Phone Number:</div>
                                        <div class="info-value">${not empty cusDTO.phone ? cusDTO.phone :
                                            'N/A'}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">System Role:</div>
                                        <div class="info-value"><span class="badge badge-role">Customer</span></div>
                                    </div>
                                </div>

                                <div class="info-section">
                                    <h3>Commercial Profile</h3>
                                    <div class="info-row">
                                        <div class="info-label">Company Name:</div>
                                        <div class="info-value"><strong>${cusDTO.companyName}</strong></div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">Tax Code:</div>
                                        <div class="info-value">${not empty cusDTO.taxCode ?
                                            cusDTO.taxCode : 'N/A'}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">Customer Type:</div>
                                        <div class="info-value">${cusDTO.customerType}</div>
                                    </div>
                                    <div class="info-row">
                                        <div class="info-label">Assigned To Sale:</div>
                                        <div class="info-value" style="color: var(--primary); font-weight: 700;">
                                            <c:choose>
                                                <c:when test="${not empty cusDTO.assignedToUserId}">
                                                    <c:forEach var="u" items="${users}">
                                                        <c:if test="${cusDTO.assignedToUserId == u.userId}">
                                                            ${u.fullName} (${u.userName})
                                                        </c:if>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise><span class="text-muted"
                                                        style="font-weight: 400;">Unassigned</span></c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="tabs-container">
                                <ul class="tab-menu">
                                    <li class="tab-item active" onclick="switchTab(event, 'quotationsTab')">Quotations
                                        (${listQuotationsForCus != null ? listQuotationsForCus.size() : 0})</li>
                                    <li class="tab-item" onclick="switchTab(event, 'contractsTab')">Contracts &
                                        Signatures (${listContractsForCus != null ? listContractsForCus.size() : 0})
                                    </li>
                                    <li class="tab-item" onclick="switchTab(event, 'ordersTab')">Orders Progress
                                        (${listOrdersForCus != null ? listOrdersForCus.size() : 0})</li>
                                    <li class="tab-item" onclick="switchTab(event, 'billingTab')">Invoices & Payments
                                    </li>
                                </ul>

                                <div id="quotationsTab" class="tab-content active">
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>Quotation ID</th>
                                                <th>Quotation Date</th>
                                                <th>Status</th>
                                                <th>Created By</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${not empty listQuotationsForCus}">
                                                    <c:forEach var="q" items="${listQuotationsForCus}">
                                                        <tr>
                                                            <td>#${q.quotationId}</td>
                                                            <td>${q.formattedQuotationDate}</td>
                                                            <td><span class="badge"
                                                                    style="background-color: #e2e3e5; color: #383d41;">${q.quotationStatus}</span>
                                                            </td>
                                                            <td>${not empty q.createdByName ? q.createdByName : 'N/A'}
                                                            </td>
                                                            <td><a href="${pageContext.request.contextPath}/quotation-detail?id=${q.quotationId}"
                                                                    class="btn-action-sm">View Details</a></td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr>
                                                        <td colspan="5" class="no-data">No quotations recorded for this
                                                            client.
                                                        </td>
                                                    </tr>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>

                                <div id="contractsTab" class="tab-content">
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>Contract No.</th>
                                                <th>Version</th>
                                                <th>Status</th>
                                                <th>Signed At</th>
                                                <th>Documents</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${not empty listContractsForCus}">
                                                    <c:forEach var="c" items="${listContractsForCus}">
                                                        <tr>
                                                            <td>
                                                                <a
                                                                    href="${pageContext.request.contextPath}/contract-detail?id=${c.contractId}">
                                                                    ${c.contractNumber}
                                                                </a>
                                                            </td>
                                                            <td>v${c.contractVersion}</td>
                                                            <td><span class="badge"
                                                                    style="background-color: #e2e3e5; color: #383d41;">${c.contractStatus}</span>
                                                            </td>
                                                            <td>${c.formattedSignDate}</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${not empty c.contractFileUrl}">
                                                                        <a href="${pageContext.request.contextPath}/${c.contractFileUrl}"
                                                                            target="_blank" class="btn-action-sm"
                                                                            style="background-color: #28a745;">Download</a>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span
                                                                            style="color: #6c757d; font-style: italic;">No
                                                                            Document</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr>
                                                        <td colspan="5" class="no-data">No legal contracts initialized.
                                                        </td>
                                                    </tr>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>

                                <div id="ordersTab" class="tab-content">
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>Order ID</th>
                                                <th>Date Created</th>
                                                <th>Current Status</th>
                                                <th>Handler</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${not empty listOrdersForCus}">
                                                    <c:forEach var="o" items="${listOrdersForCus}">
                                                        <tr>
                                                            <td>#${o.customerOrder.customerOrderId}</td>
                                                            <td>${o.customerOrder.formattedCreatedAt}</td>
                                                            <td><span class="badge"
                                                                    style="background-color: #e2e3e5; color: #383d41;">${o.customerOrder.orderStatus}</span>
                                                            </td>
                                                            <td><a href="${pageContext.request.contextPath}/customer-order?id=${o.customerOrder.customerOrderId}"
                                                                    class="btn-action-sm">View
                                                                    Details
                                                                </a></td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr>
                                                        <td colspan="4" class="no-data">No product orders have been
                                                            executed.
                                                        </td>
                                                    </tr>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>

                                <div id="billingTab" class="tab-content">
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>Invoice No.</th>
                                                <th>Issue Date</th>
                                                <th>Amount Paid</th>
                                                <th>Payment Type</th>
                                                <th>Payment Status</th>
                                            </tr>
                                        </thead>
                                        <tbody style="background: none;">
                                            <c:choose>
                                                <c:when test="${not empty listBillings}">
                                                    <!-- not yet available -->
                                                </c:when>
                                                <c:otherwise>
                                                    <tr>
                                                        <td colspan="5" class="no-data">No financial statements or
                                                            payments found.</td>
                                                    </tr>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <div class="btn-group">
                                <a href="${pageContext.request.contextPath}/customer/edit?id=${cusDTO.customerId}"
                                    class="btn-edit">Edit Profile</a>
                                <c:if test="${cusDTO.status == 'ACTIVE'}">
                                    <a href="${pageContext.request.contextPath}/customer/detail?action=deactivate&id_cus=${cusDTO.customerId}"
                                        class="btn-remove"
                                        onclick="return confirm('Are you sure you want to deactivate this customer?');">Remove</a>
                                </c:if>
                                <c:if test="${cusDTO.status == 'INACTIVE'}">
                                    <a href="${pageContext.request.contextPath}/customer/detail?action=activate&id_cus=${cusDTO.customerId}"
                                        class="btn-activate"
                                        onclick="return confirm('Are you sure you want to activate this customer?');">Activate</a>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/customer/list" class="btn-back">Back to
                                    List</a>
                            </div>
                        </div>

                        <script>
                            function switchTab(event, tabId) {
                                // 1. Hide all tab contents currently displayed
                                const tabContents = document.getElementsByClassName("tab-content");
                                for (let i = 0; i < tabContents.length; i++) {
                                    tabContents[i].classList.remove("active");
                                }

                                // 2. Remove active state from old tab items
                                const tabItems = document.getElementsByClassName("tab-item");
                                for (let i = 0; i < tabItems.length; i++) {
                                    tabItems[i].classList.remove("active");
                                }

                                // 3. Show clicked tab content and activate corresponding tab item
                                document.getElementById(tabId).classList.add("active");
                                event.currentTarget.classList.add("active");
                            }
                        </script>

                    </main>
                </div>
            </body>

            </html>