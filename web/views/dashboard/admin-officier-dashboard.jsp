<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard - Po Bread Sales</title>
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
                        <p class="eyebrow">Overview</p>
                        <h1>Admin Officer Dashboard</h1>
                        <p>Quản lý hợp đồng và tình trạng phê duyệt</p>
                    </div>
                </div>

                <!-- KPI ROW (6 Cards) -->
                <div class="kpi-row">
                    <!-- Contract KPIs -->
                    <div class="kpi-card">
                        <h3>Awaiting Quotations</h3>
                        <p style="color:var(--danger);">${awaitingQuotations}</p>
                    </div>
                    <div class="kpi-card">
                        <h3>Contracts In Progress</h3>
                        <p style="color:var(--tertiary);">${contractsInProgress}</p>
                    </div>
                    <div class="kpi-card">
                        <h3>Active Contracts</h3>
                        <p style="color:var(--primary);">${activeContracts}</p>
                    </div>
                    <!-- Invoice KPIs -->
                    <div class="kpi-card">
                        <h3>Total Invoices</h3>
                        <p style="color:var(--primary);">${invoiceSummary.totalInvoices != null ? invoiceSummary.totalInvoices : 0}</p>
                    </div>
                    <div class="kpi-card">
                        <h3>Total Paid Amount</h3>
                        <p style="color:#4caf50;">
                            <fmt:formatNumber value="${invoiceSummary.paidAmount}" type="number" maxFractionDigits="0"/>đ
                        </p>
                    </div>
                    <div class="kpi-card">
                        <h3>Total Unpaid Amount</h3>
                        <p style="color:var(--danger);">
                            <fmt:formatNumber value="${invoiceSummary.unpaidAmount}" type="number" maxFractionDigits="0"/>đ
                        </p>
                    </div>
                </div>

                <!-- CONTENT GRID (3 Columns) -->
                <div class="content-grid">
                    <!-- Column 1: Biểu đồ -->
                    <div class="content-card">
                        <h3>Contract Status</h3>
                        <div style="position:relative; width:100%; flex:1; display:flex; justify-content:center; align-items:center; min-height:0;">
                            <canvas id="statusChart"></canvas>
                        </div>
                    </div>

                    <!-- Column 2: Nhắc việc -->
                    <div class="content-card">
                        <h3>Contracts Needing Action</h3>
                        <div class="table-wrapper">
                            <table>
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Company</th>
                                        <th>Status</th>
                                        <th style="text-align:right;">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="c" items="${contractsNeedingAction}">
                                        <tr>
                                            <td style="font-weight:bold;">${c.contractNumber}</td>
                                            <td>${c.customerName}</td>
                                            <td><span class="badge" style="background:var(--primary-soft); color:var(--primary);">${c.contractStatus}</span></td>
                                            <td style="text-align:right;">
                                                <a href="${pageContext.request.contextPath}/contract-detail?id=${c.contractId}" style="color:var(--primary); font-weight:bold;">Review</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty contractsNeedingAction}">
                                        <tr><td colspan="4" style="text-align:center; color:var(--muted); padding:20px;">No pending actions. Great job!</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
            
                    <!-- Column 3: Hóa đơn gần đây -->
                    <div class="content-card">
                        <h3>Recent Invoices</h3>
                        <div class="table-wrapper">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Invoice No</th>
                                        <th>Contract</th>
                                        <th>Customer</th>
                                        <th>Amount</th>
                                        <th>Status</th>
                                        <th>Payment</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="i" items="${recentInvoices}">
                                        <tr>
                                            <td style="font-weight:bold;">${i.invoiceNo}</td>
                                            <td>${i.contractNumber}</td>
                                            <td style="white-space:nowrap; overflow:hidden; text-overflow:ellipsis; max-width:80px;">${i.companyName}</td>
                                            <td style="color:var(--primary); font-weight:bold;">
                                                <fmt:formatNumber value="${i.totalAmount}" type="number" maxFractionDigits="0"/>đ
                                            </td>
                                            <td><span class="badge" style="background:var(--primary-soft); color:var(--primary);">${i.invoiceStatus}</span></td>
                                            <td>
                                                <span class="badge" style="
                                                    background:${i.paymentStatus == 'PAID' ? '#dcefe1' : (i.paymentStatus == 'UNPAID' ? '#fbeaea' : '#f0ece4')}; 
                                                    color:${i.paymentStatus == 'PAID' ? '#4a7c59' : (i.paymentStatus == 'UNPAID' ? '#b83230' : '#646b66')};">
                                                    ${i.paymentStatus != null ? i.paymentStatus : 'UNPAID'}
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty recentInvoices}">
                                        <tr><td colspan="6" style="text-align:center; color:var(--muted); padding:20px;">No invoices found.</td></tr>
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
            const labels = [];
            const data = [];
            <c:forEach items="${contractStatusCounts}" var="entry">
                labels.push('${entry.key}');
                data.push(${entry.value});
            </c:forEach>

            new Chart(document.getElementById('statusChart'), {
                type: 'doughnut',
                data: {
                    labels: labels,
                    datasets: [{
                        data: data,
                        backgroundColor: ['#4a7c59', '#b1812f', '#b83230', '#646b66', '#dcefe1', '#7a6148'],
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
