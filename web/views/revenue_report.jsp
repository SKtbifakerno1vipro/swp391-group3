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
            .stats-columns {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
                gap: 25px;
                margin-bottom: 30px;
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

            @media (max-width: 820px) {
                .dashboard-shell {
                    grid-template-columns: 1fr;
                }
                .main {
                    padding: 22px 16px;
                }
                .stats-columns, .status-breakdowns {
                    grid-template-columns: 1fr;
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
                        <p class="eyebrow">Analytics & Reporting</p>
                        <h1>System Statistics Report</h1>
                        <p>Visual overview of Products, Orders, Quotations, and Contracts.</p>
                    </div>
                </section>

                <!-- Summary Grid KPI Cards -->
                <section class="summary-grid">
                    <div class="kpi-card" style="--card-color: #3b82f6; --card-soft-color: #dbeafe;">
                        <div class="kpi-icon"><span class="material-symbols-outlined">inventory_2</span></div>
                        <div class="kpi-info">
                            <h4><c:out value="${totalProducts}"/></h4>
                            <p>Total Products</p>
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

                <!-- Top Performing Metrics -->
                <section class="stats-columns">

                    <!-- Top Customers CSS Bar Chart -->
                    <div class="section-card">
                        <h3>Top 5 Customers by Orders</h3>
                        <div class="stat-list">
                            <c:choose>
                                <c:when test="${empty topCustomers}">
                                    <div class="empty-state">
                                        <span class="material-symbols-outlined">groups</span>
                                        <p>No customer data available</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="maxCustOrders" value="${topCustomers[0].totalOrders}" />
                                    <c:forEach items="${topCustomers}" var="item">
                                        <c:set var="custPct" value="${maxCustOrders gt 0 ? (item.totalOrders * 100.0 / maxCustOrders) : 0}" />
                                        <div class="stat-item">
                                            <div class="stat-meta">
                                                <span class="stat-title"><c:out value="${item.companyName}"/></span>
                                                <span class="stat-value"><c:out value="${item.totalOrders}"/> Orders</span>
                                            </div>
                                            <div class="progress-track">
                                                <div class="progress-fill" style="--bar-width: <fmt:formatNumber value='${custPct}' maxFractionDigits='1'/>%; --grad-start: #ffedd5; --grad-end: #f97316;"></div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Top Selling Products CSS Bar Chart -->
                    <div class="section-card">
                        <h3>Top 5 Selling Products</h3>
                        <div class="stat-list">
                            <c:choose>
                                <c:when test="${empty topSellingProducts}">
                                    <div class="empty-state">
                                        <span class="material-symbols-outlined">inventory_2</span>
                                        <p>No product sales data available</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="maxProdSold" value="${topSellingProducts[0].totalSold}" />
                                    <c:forEach items="${topSellingProducts}" var="item">
                                        <c:set var="prodPct" value="${maxProdSold gt 0 ? (item.totalSold * 100.0 / maxProdSold) : 0}" />
                                        <div class="stat-item">
                                            <div class="stat-meta">
                                                <span class="stat-title"><c:out value="${item.productName}"/></span>
                                                <span class="stat-value"><c:out value="${item.totalSold}"/> Sold</span>
                                            </div>
                                            <div class="progress-track">
                                                <div class="progress-fill" style="--bar-width: <fmt:formatNumber value='${prodPct}' maxFractionDigits='1'/>%; --grad-start: #ccfbf1; --grad-end: #0d9488;"></div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                </section>

                <!-- Status Breakdown Lists -->
                <section class="status-breakdowns">

                    <!-- Orders by Status -->
                    <div class="section-card">
                        <h3>Orders by Status</h3>
                        <div class="stat-list">
                            <c:choose>
                                <c:when test="${empty orderStatusCounts}">
                                    <div class="empty-state">
                                        <span class="material-symbols-outlined">shopping_cart</span>
                                        <p>No order status records found</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${orderStatusCounts}" var="entry">
                                        <c:set var="orderPct" value="${totalOrders gt 0 ? (entry.total * 100.0 / totalOrders) : 0}" />
                                        <div class="stat-item">
                                            <div class="stat-meta">
                                                <span class="badge-status" style="background-color: var(--primary-soft); color: var(--primary);"><c:out value="${entry.status}"/></span>
                                                <span class="stat-value"><c:out value="${entry.total}"/></span>
                                            </div>
                                            <div class="progress-track">
                                                <div class="progress-fill" style="--bar-width: <fmt:formatNumber value='${orderPct}' maxFractionDigits='1'/>%; --grad-start: var(--primary-soft); --grad-end: var(--primary);"></div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Quotations by Status -->
                    <div class="section-card">
                        <h3>Quotations by Status</h3>
                        <div class="stat-list">
                            <c:choose>
                                <c:when test="${empty quotationStatusCounts}">
                                    <div class="empty-state">
                                        <span class="material-symbols-outlined">request_quote</span>
                                        <p>No quotation status records found</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${quotationStatusCounts}" var="entry">
                                        <c:set var="quotPct" value="${totalQuotations gt 0 ? (entry.total * 100.0 / totalQuotations) : 0}" />
                                        <div class="stat-item">
                                            <div class="stat-meta">
                                                <span class="badge-status" style="background-color: #fef3c7; color: var(--tertiary);"><c:out value="${entry.status}"/></span>
                                                <span class="stat-value"><c:out value="${entry.total}"/></span>
                                            </div>
                                            <div class="progress-track">
                                                <div class="progress-fill" style="--bar-width: <fmt:formatNumber value='${quotPct}' maxFractionDigits='1'/>%; --grad-start: #fef3c7; --grad-end: var(--tertiary);"></div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Contracts by Status -->
                    <div class="section-card">
                        <h3>Contracts by Status</h3>
                        <div class="stat-list">
                            <c:choose>
                                <c:when test="${empty contractStatusCounts}">
                                    <div class="empty-state">
                                        <span class="material-symbols-outlined">description</span>
                                        <p>No contract status records found</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${contractStatusCounts}" var="entry">
                                        <c:set var="contractPct" value="${totalContracts gt 0 ? (entry.total * 100.0 / totalContracts) : 0}" />
                                        <div class="stat-item">
                                            <div class="stat-meta">
                                                <span class="badge-status" style="background-color: #f5e8db; color: var(--secondary);"><c:out value="${entry.status}"/></span>
                                                <span class="stat-value"><c:out value="${entry.total}"/></span>
                                            </div>
                                            <div class="progress-track">
                                                <div class="progress-fill" style="--bar-width: <fmt:formatNumber value='${contractPct}' maxFractionDigits='1'/>%; --grad-start: #f5e8db; --grad-end: var(--secondary);"></div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                </section>
            </main>
        </div>
    </body>
</html>
