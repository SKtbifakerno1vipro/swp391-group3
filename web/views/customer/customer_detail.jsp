<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Customer Details - Terra Enterprise</title>
        
        <link href="https://fonts.googleapis.com" rel="preconnect">
        <link crossorigin="" href="https://fonts.gstatic.com" rel="preconnect">
        <link href="https://fonts.googleapis.com/css2?family=Segoe+UI:wght@400;600;700&display=swap" rel="stylesheet">
        
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f8f9fa;
                color: #212529;
                margin: 0;
                padding: 20px;
            }

            .container {
                max-width: 1000px; /* Mở rộng rộng hơn form edit để chứa bảng dữ liệu */
                margin: 20px auto;
                background: #ffffff;
                padding: 30px;
                border-radius: 6px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                border: 1px solid #dee2e6;
            }

            .header-section {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                border-bottom: 2px solid #212529;
                padding-bottom: 10px;
                margin-bottom: 20px;
            }

            h1 {
                font-size: 24px;
                font-weight: 700;
                margin: 0;
                color: #000000;
            }

            .nav-links {
                margin-bottom: 25px;
            }

            .nav-links a {
                color: #0056b3;
                text-decoration: underline;
                font-size: 14px;
                margin-right: 15px;
            }

            /* CSS cho 3 Hộp KPI Thống kê nhanh */
            .kpi-container {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 15px;
                margin-bottom: 25px;
            }

            .kpi-card {
                background: #f1f3f5;
                padding: 15px;
                border-radius: 4px;
                border-left: 4px solid #007bff;
                box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            }

            .kpi-card.success { border-left-color: #28a745; }
            .kpi-card.warning { border-left-color: #ffc107; }

            .kpi-title {
                font-size: 12px;
                text-transform: uppercase;
                color: #6c757d;
                font-weight: 600;
                margin-bottom: 5px;
            }

            .kpi-value {
                font-size: 20px;
                font-weight: 700;
                color: #212529;
            }

            /* Bố cục thông tin cá nhân dạng 2 cột */
            .info-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
                margin-bottom: 30px;
            }

            .info-section {
                background: #fff;
                padding: 15px;
                border: 1px solid #e9ecef;
                border-radius: 4px;
            }

            .info-section h3 {
                margin-top: 0;
                margin-bottom: 15px;
                font-size: 16px;
                border-bottom: 1px solid #dee2e6;
                padding-bottom: 5px;
                color: #495057;
            }

            .info-row {
                display: flex;
                margin-bottom: 10px;
                font-size: 14px;
            }

            .info-label {
                width: 140px;
                font-weight: 600;
                color: #495057;
            }

            .info-value {
                flex: 1;
                color: #212529;
            }

            /* Badge trạng thái */
            .badge {
                display: inline-block;
                padding: 2px 8px;
                font-size: 12px;
                font-weight: 600;
                border-radius: 4px;
            }
            .badge-active { background-color: #d1e7dd; color: #0f5132; }
            .badge-inactive { background-color: #f8d7da; color: #842029; }
            .badge-role { background-color: #e9ecef; color: #495057; border: 1px solid #ced4da; }

            /* CSS Hệ thống Tabs xử lý luồng lịch sử giao dịch */
            .tabs-container {
                margin-top: 30px;
            }

            .tab-menu {
                display: flex;
                border-bottom: 1px solid #dee2e6;
                margin-bottom: 15px;
                padding: 0;
                list-style: none;
            }

            .tab-item {
                padding: 10px 20px;
                cursor: pointer;
                font-weight: 600;
                font-size: 14px;
                color: #495057;
                border: 1px solid transparent;
                border-bottom: none;
                margin-bottom: -1px;
            }

            .tab-item:hover {
                color: #0056b3;
                background-color: #f8f9fa;
            }

            .tab-item.active {
                color: #007bff;
                background-color: #fff;
                border-color: #dee2e6 #dee2e6 #fff;
                border-radius: 4px 4px 0 0;
            }

            .tab-content {
                display: none;
            }

            .tab-content.active {
                display: block;
            }

            /* Table chuẩn FPT hiển thị danh sách con */
            .data-table {
                width: 100%;
                border-collapse: collapse;
                font-size: 14px;
                margin-bottom: 15px;
            }

            .data-table th, .data-table td {
                border: 1px solid #dee2e6;
                padding: 10px;
                text-align: left;
            }

            .data-table th {
                background-color: #f1f3f5;
                font-weight: 600;
            }

            .data-table tbody tr:hover {
                background-color: #f8f9fa;
            }

            .text-right { text-align: right; }
            .no-data { text-align: center; color: #6c757d; padding: 20px !important; }

            /* Nút hành động thao tác nhanh */
            .btn-action-sm {
                padding: 4px 10px;
                font-size: 12px;
                text-decoration: none;
                border-radius: 4px;
                color: #fff;
                background-color: #17a2b8;
            }
            .btn-action-sm:hover { background-color: #138496; }

            .btn-group {
                margin-top: 25px;
                display: flex;
                gap: 10px;
            }

            .btn-edit {
                color: #fff;
                background-color: #007bff;
                padding: 8px 20px;
                font-size: 14px;
                border-radius: 4px;
                text-decoration: none;
            }
            .btn-edit:hover { background-color: #0069d9; }

            .btn-back {
                color: #212529;
                background-color: #e2e6ea;
                padding: 8px 20px;
                font-size: 14px;
                border-radius: 4px;
                text-decoration: none;
                border: 1px solid #dae0e5;
            }
            .btn-back:hover { background-color: #d3d9df; }
        </style>
    </head>
    <body>
        <main class="container">
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/customer/list">Customer List</a>
                <a href="${pageContext.request.contextPath}/dashboard">DashBoard</a>
            </div>

            <div class="header-section">
                <div>
                    <h1>Customer Profile</h1>
                    <span style="color: #6c757d; font-size: 14px;">ID: ${cusDTO.customer.customerId} | User ID: ${cusDTO.customer.userId}</span>
                </div>
                <div>
                    <%-- THÊM BẢO VỆ NGHIỆP VỤ: Nếu là Sale Staff thì cho phép bấm nút tạo báo giá nhanh cho riêng khách này --%>
                    <c:if test="${sessionScope.user.roleId == 4}">
                        <a href="${pageContext.request.contextPath}/quotation/create?customerId=${cusDTO.customer.customerId}" class="btn-edit" style="background-color: #28a745;">+ Quick Quotation</a>
                    </c:if>
                </div>
            </div>

            <div class="kpi-container">
                <div class="kpi-card">
                    <div class="kpi-title">Total Orders Placed</div>
                    <div class="kpi-value">${totalOrdersCus != null ? totalOrdersCus : 0} Orders</div>
                </div>
                <div class="kpi-card success">
                    <div class="kpi-title">Total Paid Amount</div>
                    <div class="kpi-value">
                        <fmt:formatNumber value="${totalPaid != null ? totalPaid : 0}" type="currency" currencySymbol="VND" maxFractionDigits="0"/>
                    </div>
                </div>
                <div class="kpi-card warning">
                    <div class="kpi-title">Account Status</div>
                    <div class="kpi-value" style="font-size: 18px; padding-top: 2px;">
                        <span class="badge ${cusDTO.user.status == 'ACTIVE' ? 'badge-active' : 'badge-inactive'}">${cusDTO.user.status}</span>
                    </div>
                </div>
            </div>

            <div class="info-grid">
                <div class="info-section">
                    <h3>Account & Contact Info</h3>
                    <div class="info-row">
                        <div class="info-label">Username:</div>
                        <div class="info-value">${cusDTO.user.userName}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Full Name:</div>
                        <div class="info-value">${not empty cusDTO.user.fullName ? cusDTO.user.fullName : 'N/A'}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Email Address:</div>
                        <div class="info-value">${cusDTO.user.email}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Phone Number:</div>
                        <div class="info-value">${not empty cusDTO.user.phone ? cusDTO.user.phone : 'N/A'}</div>
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
                        <div class="info-value"><strong>${cusDTO.customer.companyName}</strong></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Tax Code:</div>
                        <div class="info-value">${not empty cusDTO.customer.taxCode ? cusDTO.customer.taxCode : 'N/A'}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Customer Type:</div>
                        <div class="info-value">${cusDTO.customer.customerType}</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Assigned To Sale:</div>
                        <div class="info-value" style="color: #0056b3; font-weight: 600;">
                            <c:choose>
                                <c:when test="${not empty cusDTO.customer.assignedToUserId}">
                                    <c:forEach var="u" items="${users}">
                                        <c:if test="${cusDTO.customer.assignedToUserId == u.userId}">
                                            ${u.fullName} (${u.userName})
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise><span class="text-muted" style="font-weight: 400;">Unassigned</span></c:otherwise>
                            </c:choose>
                            
                            <c:if test="${sessionScope.user.roleId == 2}">
                                <a href="${pageContext.request.contextPath}/customer/edit?id=${cusDTO.customer.customerId}" style="font-size: 12px; margin-left: 10px; font-weight: 400;">[Re-assign]</a>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

            <div class="tabs-container">
                <ul class="tab-menu">
                    <li class="tab-item active" onclick="switchTab(event, 'quotationsTab')">Quotations (${listQuotations.size() != null ? listQuotations.size() : 0})</li>
                    <li class="tab-item" onclick="switchTab(event, 'contractsTab')">Contracts & Signatures (${listContracts.size() != null ? listContracts.size() : 0})</li>
                    <li class="tab-item" onclick="switchTab(event, 'ordersTab')">Orders Progress (${listOrders.size() != null ? listOrders.size() : 0})</li>
                    <li class="tab-item" onclick="switchTab(event, 'billingTab')">Invoices & Payments</li>
                </ul>

                <div id="quotationsTab" class="tab-content active">
                    <table class="data-table">
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
                                <c:when test="${not empty listQuotations}">
                                    <c:forEach var="q" items="${listQuotations}">
                                        <tr>
                                            <td>#${q.quotationId}</td>
                                            <td>${q.quotationDate}</td>
                                            <td><span class="badge" style="background-color: #e3f2fd; color: #0d47a1;">${q.quotationStatus}</span></td>
                                            <td>User ID: ${q.createdBy}</td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/quotation/detail?id=${q.quotationId}" class="btn-action-sm">View Details</a>
                                                <%-- Nếu Báo giá được ACCEPTED và vai trò là Admin Officer (Role 5), cho phép nhấn nút Tạo Hợp đồng luôn tại đây --%>
                                                <c:if test="${q.quotationStatus == 'ACCEPTED' && sessionScope.user.roleId == 5}">
                                                    <a href="${pageContext.request.contextPath}/contract/generate?quotationId=${q.quotationId}" class="btn-action-sm" style="background-color: #28a745; margin-left: 5px;">Generate Contract</a>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr><td colspan="5" class="no-data">No quotations recorded for this client.</td></tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <div id="contractsTab" class="tab-content">
                    <table class="data-table">
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
                                <c:when test="${not empty listContracts}">
                                    <c:forEach var="c" items="${listContracts}">
                                        <tr>
                                            <td><strong>${c.contractNumber}</strong></td>
                                            <td>${c.contractVersion}</td>
                                            <td><span class="badge" style="background-color: #fff3cd; color: #856404;">${c.contractStatus}</span></td>
                                            <td>${c.signedAt != null ? c.signedAt : 'Awaiting signatures'}</td>
                                            <td>
                                                <c:if test="${not empty c.contractFileUrl}">
                                                    <a href="${pageContext.request.contextPath}${c.contractFileUrl}" target="_blank" class="btn-action-sm" style="background-color: #6c757d;">Open PDF File</a>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr><td colspan="5" class="no-data">No legal contracts initialized.</td></tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <div id="ordersTab" class="tab-content">
                    <table class="data-table">
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
                                <c:when test="${not empty listOrders}">
                                    <c:forEach var="o" items="${listOrders}">
                                        <tr>
                                            <td>#${o.customerOrderId}</td>
                                            <td>${o.createdAt}</td>
                                            <td><span class="badge" style="background-color: #e2e3e5; color: #383d41;">${o.orderStatus}</span></td>
                                            <td>User ID: ${o.createdBy}</td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr><td colspan="4" class="no-data">No product orders have been executed.</td></tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <div id="billingTab" class="tab-content">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Invoice No.</th>
                                <th>Issue Date</th>
                                <th>Amount Paid</th>
                                <th>Payment Type</th>
                                <th>Payment Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty listBillings}">
                                    <c:forEach var="b" items="${listBillings}">
                                        <tr>
                                            <td>${b.invoiceNo}</td>
                                            <td>${b.issueDate}</td>
                                            <td class="text-right" style="font-weight: 600;">
                                                <fmt:formatNumber value="${b.amount}" type="currency" currencySymbol="" maxFractionDigits="0"/> VND
                                            </td>
                                            <td>${b.paymentType}</td>
                                            <td><span class="badge badge-active">${b.paymentStatus}</span></td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr><td colspan="5" class="no-data">No financial statements or payments found.</td></tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="btn-group">
                <a href="${pageContext.request.contextPath}/customer/edit?id=${cusDTO.customer.customerId}" class="btn-edit">Edit Profile</a>
                <a href="${pageContext.request.contextPath}/customer/list" class="btn-back">Back to List</a>
            </div>
        </main>

        <script>
            function switchTab(event, tabId) {
                // 1. Ẩn toàn bộ nội dung của các tab đang hiển thị
                const tabContents = document.getElementsByClassName("tab-content");
                for (let i = 0; i < tabContents.length; i++) {
                    tabContents[i].classList.remove("active");
                }

                // 2. Gỡ bỏ trạng thái active của các nút tab menu cũ
                const tabItems = document.getElementsByClassName("tab-item");
                for (let i = 0; i < tabItems.length; i++) {
                    tabItems[i].classList.remove("active");
                }

                // 3. Hiển thị nội dung của tab được click và bật trạng thái active cho nút tương ứng
                document.getElementById(tabId).classList.add("active");
                event.currentTarget.classList.add("active");
            }
        </script>
    </body>
</html>