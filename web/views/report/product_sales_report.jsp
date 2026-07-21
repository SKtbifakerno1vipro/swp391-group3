<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Báo cáo Doanh số Sản phẩm</title>
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
                margin-bottom: 24px;
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
                font-size: clamp(26px, 3.5vw, 38px);
                line-height: 1.15;
            }

            .top-actions {
                display: flex;
                gap: 10px;
            }

            .btn {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 10px 18px;
                border-radius: 8px;
                font-size: 13px;
                font-weight: 700;
                text-decoration: none;
                border: none;
                cursor: pointer;
                transition: var(--transition);
            }

            .btn-primary {
                background: var(--primary);
                color: #fff;
            }
            .btn-primary:hover {
                background: #3b6548;
            }

            .btn-secondary {
                background: var(--surface-soft);
                color: var(--text);
                border: 1px solid var(--line);
            }
            .btn-secondary:hover {
                background: var(--surface-strong);
            }

            .btn-excel {
                background: #107c41;
                color: #fff;
            }
            .btn-excel:hover {
                background: #0b5c30;
            }

            /* Filter Card */
            .filter-card {
                background: var(--surface);
                border: 1px solid var(--line);
                border-radius: 18px;
                padding: 20px 24px;
                box-shadow: var(--shadow);
                margin-bottom: 24px;
            }

            .filter-form {
                display: flex;
                flex-wrap: wrap;
                gap: 16px;
                align-items: flex-end;
            }

            .form-group {
                display: flex;
                flex-direction: column;
                gap: 6px;
                flex: 1;
                min-width: 140px;
            }

            .form-group label {
                font-size: 12px;
                font-weight: 800;
                color: var(--muted);
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }

            .form-control {
                padding: 9px 12px;
                border: 1px solid var(--line);
                border-radius: 8px;
                background: var(--bg);
                color: var(--text);
                font-family: inherit;
                font-size: 13px;
                font-weight: 600;
                outline: none;
                transition: var(--transition);
            }

            .form-control:focus {
                border-color: var(--primary);
                box-shadow: 0 0 0 3px rgba(74, 124, 89, 0.15);
            }

            /* KPI Grid */
            .kpi-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
                gap: 18px;
                margin-bottom: 28px;
            }

            .kpi-card {
                background: var(--surface);
                border: 1px solid var(--line);
                border-radius: 18px;
                padding: 20px 24px;
                box-shadow: var(--shadow);
                display: flex;
                align-items: center;
                gap: 16px;
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

            .kpi-icon {
                width: 48px;
                height: 48px;
                border-radius: 14px;
                display: grid;
                place-items: center;
                background: var(--card-soft-color, var(--primary-soft));
                color: var(--card-color, var(--primary));
                font-weight: 700;
            }

            .kpi-info h4 {
                margin: 0;
                font-size: 24px;
                font-family: 'Literata', Georgia, serif;
                font-weight: 700;
            }

            .kpi-info p {
                margin: 3px 0 0;
                color: var(--muted);
                font-weight: 700;
                font-size: 12px;
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }

            /* Data Table Wrapper */
            .data-table-wrapper {
                background: var(--surface);
                border: 1px solid var(--line);
                border-radius: 20px;
                padding: 24px;
                box-shadow: var(--shadow);
                overflow-x: auto;
            }

            .data-table-wrapper h3 {
                margin: 0 0 18px 0;
                font-family: 'Literata', Georgia, serif;
                font-size: 20px;
                color: var(--text);
                padding-bottom: 10px;
                border-bottom: 1px solid var(--surface-soft);
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .data-table {
                width: 100%;
                border-collapse: collapse;
                text-align: left;
            }

            .data-table th, .data-table td {
                padding: 13px 14px;
                border-bottom: 1px solid var(--surface-soft);
                font-size: 13px;
            }

            .data-table th {
                color: var(--muted);
                font-weight: 800;
                text-transform: uppercase;
                letter-spacing: 0.05em;
                font-size: 11px;
                background: var(--surface-soft);
            }

            .data-table tr:hover td {
                background: var(--surface-soft);
            }

            .data-table tfoot td {
                font-weight: 800;
                font-size: 14px;
                border-top: 2px solid var(--line);
                background: var(--surface-soft);
            }

            .amount {
                text-align: right;
                font-weight: 700;
                color: var(--primary);
            }

            .number {
                text-align: center;
            }

            .empty-state {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                padding: 48px 20px;
                color: var(--muted);
                font-weight: 700;
                text-align: center;
                gap: 12px;
            }

            .empty-state span {
                font-size: 44px;
                color: var(--line);
            }

            @media (max-width: 820px) {
                .dashboard-shell {
                    grid-template-columns: 1fr;
                }
                .main {
                    padding: 20px 16px;
                }
                .topbar {
                    flex-direction: column;
                    align-items: flex-start;
                }
            }
        </style>
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="revenue"/>
            </jsp:include>

            <main class="main">
                <section class="topbar">
                    <div>
                        <p class="eyebrow">Dashboard / Báo cáo tài chính</p>
                        <h1>Báo cáo Doanh số Sản phẩm</h1>
                        <p style="margin: 4px 0 0; color: var(--muted);">Thống kê chi tiết danh sách sản phẩm, số lượng bán, đơn giá và tổng doanh thu.</p>
                    </div>
                    <div class="top-actions">
                        <a href="${pageContext.request.contextPath}/revenue-report" class="btn btn-secondary">
                            <span class="material-symbols-outlined">arrow_back</span>
                            Báo cáo doanh thu
                        </a>
                        <button type="button" onclick="exportExcel()" class="btn btn-excel">
                            <span class="material-symbols-outlined">download</span>
                            Xuất File Excel
                        </button>
                    </div>
                </section>

                <!-- Filter Card -->
                <section class="filter-card">
                    <form id="filterForm" method="GET" action="${pageContext.request.contextPath}/product-sales-report" class="filter-form">
                        <div class="form-group">
                            <label>Từ ngày</label>
                            <input type="date" name="startDate" value="${startDate}" class="form-control">
                        </div>
                        <div class="form-group">
                            <label>Đến ngày</label>
                            <input type="date" name="endDate" value="${endDate}" class="form-control">
                        </div>

                        <c:if test="${not empty staffList}">
                            <div class="form-group">
                                <label>Nhân viên Sale</label>
                                <select name="staffId" class="form-control">
                                    <option value="">-- Tất cả nhân viên Sale --</option>
                                    <c:forEach var="st" items="${staffList}">
                                        <option value="${st.userId}" ${staffId == st.userId ? 'selected' : ''}>${st.fullName} (${st.userName})</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </c:if>

                        <div style="display: flex; gap: 8px;">
                            <button type="submit" class="btn btn-primary">
                                <span class="material-symbols-outlined">filter_alt</span>
                                Lọc dữ liệu
                            </button>
                            <a href="${pageContext.request.contextPath}/product-sales-report" class="btn btn-secondary" title="Xóa lọc">
                                <span class="material-symbols-outlined">restart_alt</span>
                            </a>
                        </div>
                    </form>
                </section>

                <!-- Summary KPI Cards -->
                <section class="kpi-grid">
                    <div class="kpi-card" style="--card-color: #059669; --card-soft-color: #d1fae5;">
                        <div class="kpi-icon"><span class="material-symbols-outlined">payments</span></div>
                        <div class="kpi-info">
                            <h4><fmt:formatNumber value="${grandTotalRevenue}" type="number" maxFractionDigits="0"/> đ</h4>
                            <p>Tổng Doanh Thu</p>
                        </div>
                    </div>

                    <div class="kpi-card" style="--card-color: #0284c7; --card-soft-color: #e0f2fe;">
                        <div class="kpi-icon"><span class="material-symbols-outlined">inventory_2</span></div>
                        <div class="kpi-info">
                            <h4><fmt:formatNumber value="${totalQuantitySold}" type="number" maxFractionDigits="0"/></h4>
                            <p>Tổng Số Lượng Bán</p>
                        </div>
                    </div>

                    <div class="kpi-card" style="--card-color: #7c3aed; --card-soft-color: #f3e8ff;">
                        <div class="kpi-icon"><span class="material-symbols-outlined">category</span></div>
                        <div class="kpi-info">
                            <h4><c:out value="${reportList.size()}"/></h4>
                            <p>Mặt Hàng Phát Sinh Doanh Số</p>
                        </div>
                    </div>
                </section>

                <!-- Data Table -->
                <section class="data-table-wrapper">
                    <h3>
                        <span>Danh sách doanh số theo mặt hàng</span>
                        <span style="font-size: 13px; font-weight: 600; color: var(--muted);">Hiển thị ${reportList.size()} sản phẩm</span>
                    </h3>

                    <c:choose>
                        <c:when test="${empty reportList}">
                            <div class="empty-state">
                                <span class="material-symbols-outlined">search_off</span>
                                <p>Không tìm thấy dữ liệu doanh số sản phẩm trong khoảng lọc này</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th class="number" style="width: 60px;">STT</th>
                                        <th>Tên sản phẩm</th>
                                        <th class="number" style="width: 140px;">Số lượng bán</th>
                                        <th class="amount" style="width: 200px;">Đơn giá trung bình</th>
                                        <th class="amount" style="width: 220px;">Thành tiền / Doanh thu</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${reportList}" var="item" varStatus="loop">
                                        <tr>
                                            <td class="number">${loop.index + 1}</td>
                                            <td style="font-weight: 700; color: var(--text);">${item.productName}</td>
                                            <td class="number font-weight-700">${item.quantity}</td>
                                            <td class="amount" style="color: var(--text);">
                                                <fmt:formatNumber value="${item.price}" type="number" maxFractionDigits="0"/> đ
                                            </td>
                                            <td class="amount">
                                                <fmt:formatNumber value="${item.amount}" type="number" maxFractionDigits="0"/> đ
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <td colspan="2" style="text-align: right;">TỔNG CỘNG:</td>
                                        <td class="number">${totalQuantitySold}</td>
                                        <td></td>
                                        <td class="amount" style="color: var(--primary); font-size: 16px;">
                                            <fmt:formatNumber value="${grandTotalRevenue}" type="number" maxFractionDigits="0"/> đ
                                        </td>
                                    </tr>
                                </tfoot>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </section>
            </main>
        </div>

        <script>
            function exportExcel() {
                const form = document.getElementById('filterForm');
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'export';
                
                const tempForm = form.cloneNode(true);
                tempForm.appendChild(actionInput);
                tempForm.style.display = 'none';
                document.body.appendChild(tempForm);
                tempForm.submit();
                document.body.removeChild(tempForm);
            }
        </script>
    </body>
</html>
