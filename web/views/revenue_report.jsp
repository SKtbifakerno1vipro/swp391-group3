<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>System Statistics Report</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&family=Nunito+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
        <style>
            :root {
                --bg:#faf6f0;
                --surface:#fffaf3;
                --surface-soft:#f0ece4;
                --surface-strong:#e4e0d8;
                --text:#2e3230;
                --muted:#646b66;
                --primary:#4a7c59;
                --primary-soft:#dcefe1;
                --secondary:#7a6148;
                --tertiary:#b1812f;
                --danger:#b83230;
                --line:#ddd5c9;
                --shadow:0 18px 45px rgba(46,50,48,.08);
                --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            }

            body {
                background-color: var(--bg);
                color: var(--text);
                font-family: 'Nunito Sans', sans-serif;
                margin: 0;
            }

            .dashboard-shell {
                display: grid;
                grid-template-columns: 260px minmax(0, 1fr);
                min-height: 100vh;
            }

            .main {
                min-width: 0;
                padding: 26px 34px 38px;
                flex-grow: 1;
                max-width: 100% !important;
                margin: 0 !important;
            }

            .topbar {
                display: flex;
                justify-content: space-between;
                gap: 18px;
                align-items: center;
                margin-bottom: 30px;
            }

            .eyebrow {
                margin: 0 0 6px;
                color: var(--primary);
                font-weight: 800;
                letter-spacing: .08em;
                text-transform: uppercase;
                font-size: 12px;
            }

            .filter-group {
                display: flex;
                gap: 8px;
                background: var(--surface-soft);
                padding: 4px;
                border-radius: 8px;
            }

            .filter-btn {
                border: none;
                background: transparent;
                padding: 8px 16px;
                border-radius: 6px;
                font-size: 13px;
                font-weight: 700;
                color: var(--muted);
                cursor: pointer;
                transition: var(--transition);
            }

            .filter-btn.active {
                background: var(--danger);
                color: #fff;
            }

            h1 {
                margin: 0;
                font-family: 'Literata', Georgia, serif;
                font-size: clamp(30px, 4vw, 44px);
                line-height: 1.1;
            }

            /* Summary KPI Cards Grid */
            .summary-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .kpi-card {
                background: var(--surface);
                border: 1px solid var(--line);
                border-radius: 22px;
                padding: 24px;
                box-shadow: var(--shadow);
                display: flex;
                align-items: center;
                gap: 18px;
                transition: var(--transition);
                position: relative;
                overflow: hidden;
            }

            .kpi-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 4px;
                height: 100%;
                background: var(--card-color, var(--primary));
            }

            .kpi-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 24px 50px rgba(46,50,48,.12);
            }

            .kpi-icon {
                width: 52px;
                height: 52px;
                border-radius: 16px;
                display: grid;
                place-items: center;
                background: var(--card-soft-color, var(--primary-soft));
                color: var(--card-color, var(--primary));
                font-weight: 700;
            }

            .kpi-info h4 {
                margin: 0;
                font-size: 28px;
                font-family: 'Literata', Georgia, serif;
                font-weight: 700;
            }

            .kpi-info p {
                margin: 4px 0 0;
                color: var(--muted);
                font-weight: 700;
                font-size: 13px;
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }

            /* Layout Columns */
            .bottom-split {
                display: grid;
                grid-template-columns: minmax(0, 1fr) minmax(0, 2fr);
                gap: 20px;
                align-items: stretch;
            }

            .section-card {
                background: var(--surface);
                border: 1px solid var(--line);
                border-radius: 26px;
                padding: 28px;
                box-shadow: var(--shadow);
            }

            .section-card h3 {
                margin: 0 0 22px 0;
                font-family: 'Literata', Georgia, serif;
                font-size: 20px;
                color: var(--text);
                position: relative;
                padding-bottom: 10px;
                border-bottom: 1px solid var(--surface-soft);
            }

            /* Custom Pure CSS Progress Bars list */
            .stat-list {
                display: flex;
                flex-direction: column;
                gap: 18px;
            }

            .stat-item {
                display: flex;
                flex-direction: column;
                gap: 8px;
            }

            .stat-meta {
                display: flex;
                justify-content: space-between;
                font-weight: 700;
                font-size: 14px;
            }

            .stat-title {
                color: var(--text);
                max-width: 75%;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .stat-value {
                color: var(--primary);
            }

            .progress-track {
                height: 8px;
                background-color: var(--surface-soft);
                border-radius: 99px;
                overflow: hidden;
                position: relative;
            }

            @keyframes fillBar {
                from {
                    width: 0;
                }
                to {
                    width: var(--bar-width);
                }
            }

            .progress-fill {
                height: 100%;
                border-radius: 99px;
                background: linear-gradient(90deg, var(--grad-start, var(--primary-soft)), var(--grad-end, var(--primary)));
                animation: fillBar 1.2s cubic-bezier(0.4, 0, 0.2, 1) forwards;
                width: var(--bar-width);
            }

            /* Status grid layout */
            .status-breakdowns {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 25px;
                margin-bottom: 30px;
            }

            .badge-status {
                display: inline-flex;
                padding: 5px 12px;
                border-radius: 99px;
                font-size: 11px;
                font-weight: 800;
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }

            .status-row {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 12px 14px;
                background: var(--surface-soft);
                border-radius: 16px;
                transition: var(--transition);
            }

            .status-row:hover {
                transform: translateX(4px);
                background: var(--surface-strong);
            }

            .status-count {
                font-weight: 800;
                font-size: 16px;
                color: var(--text);
            }

            .empty-state {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                padding: 40px 20px;
                color: var(--muted);
                font-weight: 700;
                text-align: center;
                gap: 12px;
            }

            .empty-state span {
                font-size: 40px;
                color: var(--line);
            }

            .chart-container {
                position: relative;
                height: 250px;
                width: 100%;
            }


            /* Table Styles */
            .data-table-wrapper {
                overflow-x: auto;
                background: var(--surface);
                border: 1px solid var(--line);
                border-radius: 26px;
                padding: 20px;
                box-shadow: var(--shadow);
            }

            .data-table-wrapper h3 {
                margin: 0 0 22px 0;
                font-family: 'Literata', Georgia, serif;
                font-size: 20px;
                color: var(--text);
                position: relative;
                padding-bottom: 10px;
                border-bottom: 1px solid var(--surface-soft);
            }

            .data-table {
                width: 100%;
                border-collapse: collapse;
                text-align: left;
            }

            .data-table th, .data-table td {
                padding: 12px 10px;
                border-bottom: 1px solid var(--surface-soft);
                color: var(--text);
                font-size: 13px;
            }

            .data-table th {
                color: var(--muted);
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.05em;
                font-size: 11px;
                white-space: normal;
            }

            .data-table tr:hover td {
                background: var(--surface-soft);
            }
            
            .data-table td.amount {
                color: var(--primary);
                font-weight: 800;
            }

            @media (max-width: 1100px) {
                .bottom-split {
                    grid-template-columns: 1fr;
                }
            }
            @media (max-width: 820px) {
                .dashboard-shell {
                    grid-template-columns: 1fr;
                }
                .main {
                    padding: 22px 16px;
                }
            }
        </style>
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="revenue"/>
            </jsp:include>

            <main class="main">
                <section class="topbar">
                    <div>
                        <p class="eyebrow">Dashboard / Tài chính</p>
                        <h1>Tổng quan tài chính</h1>
                        <p>Tổng quan doanh thu, chi phí và lợi nhuận của tuần/tháng.</p>
                    </div>
                    <div class="filter-group">
                        <button class="filter-btn">Hôm nay</button>
                        <button class="filter-btn">Tuần này</button>
                        <button class="filter-btn active">Tháng này</button>
                    </div>
                </section>

                <section class="summary-grid">
                    <div class="kpi-card" style="--card-color: #3b82f6; --card-soft-color: #dbeafe;">
                        <div class="kpi-icon"><span class="material-symbols-outlined">payments</span></div>
                        <div class="kpi-info">
                            <h4><fmt:formatNumber value="${totalRevenue}" type="number" maxFractionDigits="0"/> đ</h4>
                            <p>Tổng doanh thu</p>
                        </div>
                    </div>

                    <div class="kpi-card" style="--card-color: var(--primary); --card-soft-color: var(--primary-soft);">
                        <div class="kpi-icon"><span class="material-symbols-outlined">shopping_cart</span></div>
                        <div class="kpi-info">
                            <h4><c:out value="${totalOrders}"/></h4>
                            <p>Total Orders</p>
                        </div>
                    </div>

                    <div class="kpi-card" style="--card-color: var(--tertiary); --card-soft-color: #fef3c7;">
                        <div class="kpi-icon"><span class="material-symbols-outlined">request_quote</span></div>
                        <div class="kpi-info">
                            <h4><c:out value="${totalQuotations}"/></h4>
                            <p>Total Quotations</p>
                        </div>
                    </div>

                    <div class="kpi-card" style="--card-color: var(--secondary); --card-soft-color: #f5e8db;">
                        <div class="kpi-icon"><span class="material-symbols-outlined">description</span></div>
                        <div class="kpi-info">
                            <h4><c:out value="${totalContracts}"/></h4>
                            <p>Total Contracts</p>
                        </div>
                    </div>
                </section>
                <section class="bottom-split">
                    <!-- Left Column: Chart -->
                    <div class="section-card">
                        <h3>Hiệu suất khách hàng</h3>
                        <div class="stat-list">
                            <c:choose>
                                <c:when test="${empty topCustomers}">
                                    <div class="empty-state">
                                        <span class="material-symbols-outlined">groups</span>
                                        <p>No customer data available</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="chart-container">
                                        <canvas id="customersChart"></canvas>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Right Column: Data Table -->
                    <div class="data-table-wrapper">
                    <h3>Recent Revenue (Invoices)</h3>
                    <c:choose>
                        <c:when test="${empty recentInvoices}">
                            <div class="empty-state">
                                <span class="material-symbols-outlined">receipt_long</span>
                                <p>No recent invoices found</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Mã HĐ</th>
                                        <th>Khách hàng</th>
                                        <th>Mã Hợp đồng</th>
                                        <th>Ngày lập</th>
                                        <th>Trạng thái</th>
                                        <th style="text-align: right;">Số tiền</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="inv" items="${recentInvoices}">
                                        <tr>
                                            <td style="font-weight:700;">${inv.invoiceNo}</td>
                                            <td>${inv.companyName}</td>
                                            <td>${inv.contractNumber}</td>
                                            <td><fmt:formatDate value="${inv.issueDate}" pattern="dd/MM/yyyy"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${inv.invoiceStatus == 'PAID'}">
                                                        <span class="badge-status" style="background:#dcefe1; color:#4a7c59;">Đã thanh toán</span>
                                                    </c:when>
                                                    <c:when test="${inv.invoiceStatus == 'PENDING'}">
                                                        <span class="badge-status" style="background:#fef3c7; color:#b1812f;">Chờ xử lý</span>
                                                    </c:when>
                                                    <c:when test="${inv.invoiceStatus == 'CANCELLED'}">
                                                        <span class="badge-status" style="background:#fbeaea; color:#b83230;">Đã hủy</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-status" style="background:var(--surface-strong); color:var(--muted);">${inv.invoiceStatus}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="amount" style="text-align: right;">
                                                <fmt:formatNumber value="${inv.totalAmount}" type="number" maxFractionDigits="0"/>đ
                                            </td>
                                            <td>
                                                <a href="#" style="color:var(--primary); text-decoration:none; font-weight:700; font-size:12px; background:var(--primary-soft); padding:6px 12px; border-radius:6px;">Chi tiết</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                    </div>
                </section>
            </main>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
            // Common Chart Defaults
            Chart.defaults.font.family = "'Nunito Sans', sans-serif";
            Chart.defaults.color = '#646b66';
            Chart.defaults.scale.grid.color = '#f0ece4';
            
            const chartOptions = {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { position: 'bottom', labels: { padding: 20, usePointStyle: true } }
                }
            };
            const barOptions = {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: { y: { beginAtZero: true } }
            };

            // Top Customers Bar Chart
            <c:if test="${not empty topCustomers}">
            new Chart(document.getElementById('customersChart'), {
                type: 'bar',
                data: {
                    labels: [
                        <c:forEach items="${topCustomers}" var="c">"${c.companyName}",</c:forEach>
                    ],
                    datasets: [{
                        label: 'Orders',
                        data: [
                            <c:forEach items="${topCustomers}" var="c">${c.totalOrders},</c:forEach>
                        ],
                        backgroundColor: '#b83230',
                        borderRadius: 6
                    }]
                },
                options: barOptions
            });
            </c:if>

        </script>
    </body>
</html>
