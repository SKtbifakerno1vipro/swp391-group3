<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Bảng điều khiển - Po Bread Sales</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            :root { --bg:#faf6f0; --surface:#fffaf3; --surface-soft:#f0ece4; --surface-strong:#e4e0d8; --text:#2e3230; --muted:#646b66; --primary:#4a7c59; --primary-soft:#dcefe1; --secondary:#7a6148; --tertiary:#b1812f; --danger:#b83230; --line:#ddd5c9; --shadow:0 18px 45px rgba(46,50,48,.08); }
            * { box-sizing:border-box; }
            body { margin:0; min-height:100vh; background:var(--bg); color:var(--text); font-family:'Nunito Sans',Arial,sans-serif; }
            a { color:inherit; text-decoration:none; }
            .material-symbols-outlined { font-family:'Material Symbols Outlined'; font-weight:normal; font-style:normal; font-size:22px; line-height:1; letter-spacing:normal; text-transform:none; display:inline-flex; align-items:center; justify-content:center; white-space:nowrap; word-wrap:normal; direction:ltr; -webkit-font-feature-settings:'liga'; -webkit-font-smoothing:antialiased; font-feature-settings:'liga'; font-variation-settings:'FILL' 0,'wght' 500,'GRAD' 0,'opsz' 24; width:1em; min-width:1em; overflow:hidden; }
            .dashboard-shell { display:grid; grid-template-columns:260px minmax(0,1fr); height:100vh; overflow:hidden; }
            .sidebar { position:sticky; top:0; height:100vh; padding:28px 18px; background:linear-gradient(180deg,#f7f2eb 0%,#f2ede5 100%); border-right:1px solid var(--line); display:flex; flex-direction:column; gap:28px; overflow-y:auto; }
            .sidebar::-webkit-scrollbar { width:6px; }
            .sidebar::-webkit-scrollbar-track { background:transparent; }
            .sidebar::-webkit-scrollbar-thumb { background:rgba(0,0,0,0.08); border-radius:3px; }
            .sidebar::-webkit-scrollbar-thumb:hover { background:rgba(0,0,0,0.16); }
            .sidebar::before { content:''; position:absolute; inset:0; background:radial-gradient(circle at top left,rgba(142,207,158,.2),transparent 28%); pointer-events:none; }
            .brand { position:relative; z-index:1; display:flex; align-items:center; gap:12px; padding:0 8px; }
            .brand-mark { width:44px; height:44px; border-radius:16px; display:grid; place-items:center; background:linear-gradient(135deg,var(--primary),#8ecf9e); color:#fff; box-shadow:var(--shadow); }
            .brand-title { margin:0; color:var(--primary); font-family:'Literata',Georgia,serif; font-size:21px; line-height:1.1; }
            .brand-subtitle { margin:2px 0 0; color:var(--muted); font-size:12px; }
            .nav-group { position:relative; z-index:1; display:flex; flex-direction:column; gap:7px; }
            .nav-link { position:relative; display:flex; align-items:center; gap:12px; padding:12px 14px; border-radius:16px; color:var(--muted); font-weight:700; overflow:hidden; transform:translateX(0); transition:transform .28s ease,color .28s ease,box-shadow .28s ease,background-color .28s ease; }
            .nav-link::before { content:''; position:absolute; inset:0; border-radius:inherit; background:linear-gradient(90deg,rgba(220,239,225,.95),rgba(220,239,225,.55)); transform:scaleX(.72); transform-origin:left center; opacity:0; transition:transform .28s ease,opacity .28s ease; z-index:-1; }
            .nav-link:hover,.nav-link.active { color:var(--primary); transform:translateX(6px); box-shadow:0 10px 24px rgba(74,124,89,.12); }
            .nav-link:hover::before,.nav-link.active::before { opacity:1; transform:scaleX(1); }
            .sidebar-footer { position:relative; z-index:1; margin-top:auto; padding-top:18px; border-top:1px solid var(--line); }
            .user-card { display:flex; gap:12px; align-items:center; padding:12px; border-radius:18px; background:var(--surface); }
            .avatar { width:42px; height:42px; border-radius:50%; display:grid; place-items:center; background:var(--primary); color:white; font-weight:800; text-transform:uppercase;}
            .main { min-width:0; padding:20px 24px; display:flex; flex-direction:column; height:100vh; overflow:hidden; }
            .topbar { display:flex; justify-content:space-between; gap:18px; align-items:center; margin-bottom:16px; flex-shrink:0; }
            .eyebrow { margin:0 0 4px; color:var(--primary); font-weight:800; letter-spacing:.08em; text-transform:uppercase; font-size:11px; }
            h1,h2 { font-family:'Literata',Georgia,serif; }
            h1 { margin:0; font-size:clamp(24px,3vw,32px); line-height:1.1; }
            .topbar p { margin:4px 0 0; color:var(--muted); font-size:14px; }
            
            .kpi-row { display: grid; grid-template-columns: repeat(6, 1fr); gap: 12px; margin-bottom: 20px; flex-shrink: 0; }
            .kpi-card { padding: 14px; background: var(--surface); border-radius: 12px; border: 1px solid var(--line); box-shadow: var(--shadow); }
            .kpi-card h3 { margin: 0 0 6px; color: var(--muted); font-size: 12px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
            .kpi-card p { margin: 0; font-size: 24px; font-weight: 800; line-height: 1; }
            
            .content-grid { display: grid; grid-template-columns: 1fr 1.2fr 1.8fr; gap: 16px; flex: 1; min-height: 0; }
            .content-card { background: var(--surface); padding: 16px; border-radius: 12px; border: 1px solid var(--line); display: flex; flex-direction: column; overflow: hidden; }
            .content-card h3 { margin: 0 0 12px 0; font-size: 16px; flex-shrink:0; }
            .table-wrapper { flex: 1; overflow-y: auto; padding-right:4px; }
            .table-wrapper::-webkit-scrollbar { width:6px; }
            .table-wrapper::-webkit-scrollbar-track { background:transparent; }
            .table-wrapper::-webkit-scrollbar-thumb { background:rgba(0,0,0,0.1); border-radius:3px; }
            table { width:100%; text-align:left; border-collapse: separate; border-spacing: 0; }
            th { padding:10px 8px; font-size: 13px; position: sticky; top: 0; background: var(--surface); z-index: 1; border-bottom: 2px solid var(--line); color:var(--muted); }
            td { padding:10px 8px; font-size: 13px; border-bottom: 1px solid var(--line); }
            .badge { padding:4px 6px; border-radius:6px; font-size:11px; font-weight:bold; }
            
            @media (max-width: 1200px) {
                .kpi-row { grid-template-columns: repeat(3, 1fr); }
                .content-grid { grid-template-columns: 1fr; }
                .content-grid .content-card { min-height: 350px; }
                .main { overflow-y: auto; }
            }
            @media (max-width: 768px) {
                .dashboard-shell { grid-template-columns: 80px 1fr; }
                .sidebar-text { display: none; }
                .sidebar { padding: 28px 10px; align-items: center; }
                .nav-link { padding: 12px; justify-content: center; }
                .user-card { padding: 8px; justify-content: center; }
                .brand { padding: 0; justify-content: center; }
                .kpi-row { grid-template-columns: repeat(2, 1fr); }
            }
        </style>
    </head>
    <body>
        <div class="dashboard-shell">
            <!-- SIDEBAR -->
            <jsp:include page="../shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="dashboard"/>
            </jsp:include>

            <!-- NỘI DUNG CHÍNH -->
            <div class="main">
                <div class="topbar">
                    <div>
                        <p class="eyebrow">Tổng quan</p>
                        <h1>Bảng điều khiển Admin Officer</h1>
                        <p>Quản lý hợp đồng và tình trạng phê duyệt</p>
                    </div>
                    <div>
                        <form action="${pageContext.request.contextPath}/dashboard" method="GET" style="display:flex; gap:10px; align-items:center;">
                            <label style="font-size:12px; font-weight:bold;">Từ ngày:</label>
                            <input type="date" name="startDate" value="${startDate}" style="padding:8px; border-radius:6px; border:1px solid var(--line);">
                            <label style="font-size:12px; font-weight:bold;">Đến ngày:</label>
                            <input type="date" name="endDate" value="${endDate}" style="padding:8px; border-radius:6px; border:1px solid var(--line);">
                            <button type="submit" style="padding:8px 16px; background:var(--primary); color:white; font-weight:bold; border:none; border-radius:6px; cursor:pointer;">Lọc dữ liệu</button>
                            <a href="${pageContext.request.contextPath}/dashboard" style="padding:8px 16px; background:var(--surface-strong); color:var(--text); font-weight:bold; border-radius:6px; text-decoration:none;">Xóa lọc</a>
                        </form>
                    </div>
                </div>

                <div class="kpi-row">
                    <!-- Contract KPIs -->
                    <div class="kpi-card">
                        <h3>Báo giá chờ Hợp đồng</h3>
                        <p style="color:${awaitingQuotations > 0 ? 'var(--danger)' : 'var(--muted)'};">${awaitingQuotations}</p>
                    </div>
                    <div class="kpi-card">
                        <h3>Hợp đồng đang xử lý</h3>
                        <p style="color:${contractsInProgress > 0 ? 'var(--tertiary)' : 'var(--muted)'};">${contractsInProgress}</p>
                    </div>
                    <div class="kpi-card">
                        <h3>Hợp đồng hiệu lực</h3>
                        <p style="color:${activeContracts > 0 ? 'var(--primary)' : 'var(--muted)'};">${activeContracts}</p>
                    </div>
                    <!-- Invoice KPIs -->
                    <div class="kpi-card">
                        <h3>Tổng số Hóa đơn</h3>
                        <p style="color:var(--primary);">${invoiceSummary.totalInvoices != null ? invoiceSummary.totalInvoices : 0}</p>
                    </div>
                    <div class="kpi-card">
                        <h3>Tổng tiền Đã thu</h3>
                        <p style="color:${invoiceSummary.paidAmount > 0 ? '#4caf50' : 'var(--muted)'};">
                            <fmt:formatNumber value="${invoiceSummary.paidAmount}" type="number" maxFractionDigits="0"/>đ
                        </p>
                    </div>
                    <div class="kpi-card">
                        <h3>Tổng tiền Chưa thu</h3>
                        <p style="color:${invoiceSummary.unpaidAmount > 0 ? 'var(--danger)' : 'var(--muted)'};">
                            <fmt:formatNumber value="${invoiceSummary.unpaidAmount}" type="number" maxFractionDigits="0"/>đ
                        </p>
                    </div>
                </div>

                <!-- CONTENT GRID (3 Columns) -->
                <div class="content-grid">
                    <!-- Column 1: Biểu đồ -->
                    <div class="content-card">
                        <h3>Trạng thái Hợp đồng</h3>
                        <div style="position:relative; width:100%; flex:1; display:flex; justify-content:center; align-items:center; min-height:0;">
                            <canvas id="statusChart"></canvas>
                        </div>
                    </div>

                    <!-- Column 2: Nhắc việc -->
                    <div class="content-card">
                        <h3>Hợp đồng Cần Xử Lý</h3>
                        <div class="table-wrapper">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Mã HĐ</th>
                                        <th>Khách hàng</th>
                                        <th>Trạng thái</th>
                                        <th style="text-align:right;">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="c" items="${contractsNeedingAction}">
                                        <c:set var="bg" value="var(--surface-strong)" />
                                        <c:set var="col" value="var(--muted)" />
                                        <c:choose>
                                            <c:when test="${c.contractStatus == 'SIGNED' || c.contractStatus == 'APPROVED' || c.contractStatus == 'COMPLETED'}"><c:set var="bg" value="var(--primary-soft)" /><c:set var="col" value="var(--primary)" /></c:when>
                                            <c:when test="${c.contractStatus == 'DRAFT'}"><c:set var="bg" value="var(--surface-strong)" /><c:set var="col" value="var(--muted)" /></c:when>
                                            <c:when test="${c.contractStatus == 'PENDING_REVIEW' || c.contractStatus == 'CUSTOMER_CHECK'}"><c:set var="bg" value="#f9ebce" /><c:set var="col" value="var(--tertiary)" /></c:when>
                                            <c:when test="${c.contractStatus == 'CANCELLED' || c.contractStatus == 'REJECTED'}"><c:set var="bg" value="#fbeaea" /><c:set var="col" value="var(--danger)" /></c:when>
                                        </c:choose>
                                        <tr>
                                            <td style="font-weight:bold;">${c.contractNumber}</td>
                                            <td>${c.customerName}</td>
                                            <td>
                                                <span class="badge" style="background:${bg}; color:${col};">
                                                    <c:choose>
                                                        <c:when test="${c.contractStatus == 'SIGNED'}">Đã ký</c:when>
                                                        <c:when test="${c.contractStatus == 'APPROVED'}">Đã duyệt</c:when>
                                                        <c:when test="${c.contractStatus == 'COMPLETED'}">Đã hoàn thành</c:when>
                                                        <c:when test="${c.contractStatus == 'DRAFT'}">Bản nháp</c:when>
                                                        <c:when test="${c.contractStatus == 'PENDING_REVIEW'}">Chờ duyệt</c:when>
                                                        <c:when test="${c.contractStatus == 'CUSTOMER_CHECK'}">Chờ khách duyệt</c:when>
                                                        <c:when test="${c.contractStatus == 'CANCELLED'}">Đã hủy</c:when>
                                                        <c:when test="${c.contractStatus == 'REJECTED'}">Bị từ chối</c:when>
                                                        <c:otherwise>${c.contractStatus}</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td style="text-align:right;">
                                                <a href="${pageContext.request.contextPath}/contract-detail?id=${c.contractId}" style="color:var(--primary); font-weight:bold;">Xem</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty contractsNeedingAction}">
                                        <tr><td colspan="4" style="text-align:center; color:var(--muted); padding:20px;">Không có công việc nào cần xử lý. Rất tốt!</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
            
                    <!-- Column 3: Hóa đơn gần đây -->
                    <div class="content-card">
                        <h3>Hóa đơn Gần Đây</h3>
                        <div class="table-wrapper">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Số Hóa đơn</th>
                                        <th>Mã HĐ</th>
                                        <th>Khách hàng</th>
                                        <th>Số tiền</th>
                                        <th style="width:1%; white-space:nowrap;">Trạng thái</th>
                                        <th style="width:1%; white-space:nowrap;">Thanh toán</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="i" items="${recentInvoices}">
                                        <c:set var="ibg" value="var(--surface-strong)" />
                                        <c:set var="icol" value="var(--muted)" />
                                        <c:choose>
                                            <c:when test="${i.invoiceStatus == 'PAID' || i.invoiceStatus == 'APPROVED' || i.invoiceStatus == 'COMPLETED'}"><c:set var="ibg" value="var(--primary-soft)" /><c:set var="icol" value="var(--primary)" /></c:when>
                                            <c:when test="${i.invoiceStatus == 'PENDING' || i.invoiceStatus == 'UNRELEASED'}"><c:set var="ibg" value="#f9ebce" /><c:set var="icol" value="var(--tertiary)" /></c:when>
                                            <c:when test="${i.invoiceStatus == 'CANCELLED' || i.invoiceStatus == 'OVERDUE'}"><c:set var="ibg" value="#fbeaea" /><c:set var="icol" value="var(--danger)" /></c:when>
                                        </c:choose>
                                        <tr>
                                            <td style="font-weight:bold;">${i.invoiceNo}</td>
                                            <td>${i.contractNumber}</td>
                                            <td>${i.companyName}</td>
                                            <td style="color:var(--primary); font-weight:bold;">
                                                <fmt:formatNumber value="${i.totalAmount}" type="number" maxFractionDigits="0"/>đ
                                            </td>
                                            <td style="white-space:nowrap;">
                                                <span class="badge" style="background:${ibg}; color:${icol};">
                                                    <c:choose>
                                                        <c:when test="${i.invoiceStatus == 'PAID'}">Đã thanh toán</c:when>
                                                        <c:when test="${i.invoiceStatus == 'PENDING'}">Chờ xử lý</c:when>
                                                        <c:when test="${i.invoiceStatus == 'UNRELEASED'}">Chưa phát hành</c:when>
                                                        <c:when test="${i.invoiceStatus == 'CANCELLED'}">Đã hủy</c:when>
                                                        <c:when test="${i.invoiceStatus == 'OVERDUE'}">Quá hạn</c:when>
                                                        <c:otherwise>${i.invoiceStatus}</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td style="white-space:nowrap;">
                                                <span class="badge" style="
                                                    background:${i.paymentStatus == 'PAID' ? '#dcefe1' : (i.paymentStatus == 'UNPAID' ? '#fbeaea' : '#f0ece4')}; 
                                                    color:${i.paymentStatus == 'PAID' ? '#4a7c59' : (i.paymentStatus == 'UNPAID' ? '#b83230' : '#646b66')};">
                                                    <c:choose>
                                                        <c:when test="${i.paymentStatus == 'PAID'}">Đã thanh toán</c:when>
                                                        <c:when test="${i.paymentStatus == 'UNPAID'}">Chưa thanh toán</c:when>
                                                        <c:otherwise>Chưa thanh toán</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty recentInvoices}">
                                        <tr><td colspan="6" style="text-align:center; color:var(--muted); padding:20px;">Không tìm thấy hóa đơn nào.</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- SCRIPT VẼ CHART -->
        <script>
            function getSemanticColor(status) {
                if (['SIGNED', 'APPROVED', 'COMPLETED'].includes(status)) return '#4a7c59'; 
                if (['DRAFT'].includes(status)) return '#646b66'; 
                if (['PENDING_REVIEW', 'AWAITING_QUOTATION'].includes(status)) return '#b1812f'; 
                if (['CANCELLED', 'REJECTED'].includes(status)) return '#b83230'; 
                if (['CUSTOMER_CHECK'].includes(status)) return '#FFDEA0'; 
                return '#e4e0d8'; 
            }

            const data = [];
            const bgColors = [];
            let totalCount = 0;
            <c:forEach items="${contractStatusCounts}" var="entry">
                data.push(${entry.total});
                bgColors.push(getSemanticColor('${entry.status}'));
                totalCount += ${entry.total};
            </c:forEach>
            const labels = [];
            <c:forEach items="${contractStatusCounts}" var="entry">
                {
                    let val = ${entry.total};
                    let pct = totalCount > 0 ? Math.round((val / totalCount) * 100) : 0;
                    labels.push('${entry.status} (' + val + ' - ' + pct + '%)');
                }
            </c:forEach>

            new Chart(document.getElementById('statusChart'), {
                type: 'doughnut',
                data: {
                    labels: labels,
                    datasets: [{
                        data: data,
                        backgroundColor: bgColors,
                        borderWidth: 0,
                        hoverOffset: 4
                    }]
                },
                options: { 
                    responsive: true, 
                    maintainAspectRatio: false,
                    cutout: '70%',
                    plugins: {
                        legend: { position: 'bottom' },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    let label = context.label || '';
                                    if (label) {
                                        label += ': ';
                                    }
                                    let total = context.dataset.data.reduce((a, b) => a + b, 0);
                                    let value = context.raw;
                                    let percentage = Math.round((value / total) * 100) + '%';
                                    return label + value + ' (' + percentage + ')';
                                }
                            }
                        }
                    }
                }
            });
        </script>
    </body>
</html>