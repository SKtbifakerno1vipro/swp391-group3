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
            .dashboard-shell { display:grid; grid-template-columns:260px minmax(0,1fr); min-height:100vh; }
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
            .main { min-width:0; padding:26px 34px 38px; }
            .topbar { display:flex; justify-content:space-between; gap:18px; align-items:center; margin-bottom:30px; }
            .eyebrow { margin:0 0 6px; color:var(--primary); font-weight:800; letter-spacing:.08em; text-transform:uppercase; font-size:12px; }
            h1,h2 { font-family:'Literata',Georgia,serif; }
            h1 { margin:0; font-size:clamp(30px,4vw,44px); line-height:1.1; }
            .topbar p { margin:8px 0 0; color:var(--muted); }
        </style>
    </head>
    <body>
        <div class="dashboard-shell">
            <!-- SIDEBAR -->
            <aside class="sidebar">
                <div class="brand">
                    <div class="brand-mark"><span class="material-symbols-outlined">bakery_dining</span></div>
                    <div>
                        <h1 class="brand-title">Po Bread</h1>
                        <p class="brand-subtitle">Sales Management</p>
                    </div>
                </div>
                
                <nav class="nav-group">
                    <a href="${pageContext.request.contextPath}/dashboard" class="nav-link active">
                        <span class="material-symbols-outlined">dashboard</span>
                        <span>Dashboard</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/contract-list" class="nav-link">
                        <span class="material-symbols-outlined">contract</span>
                        <span>Contracts</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/customer-order-list" class="nav-link">
                        <span class="material-symbols-outlined">shopping_cart</span>
                        <span>Orders</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/invoice" class="nav-link">
                        <span class="material-symbols-outlined">receipt_long</span>
                        <span>Invoices</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/payment-list" class="nav-link">
                        <span class="material-symbols-outlined">payments</span>
                        <span>Payments</span>
                    </a>
                </nav>

                <div class="sidebar-footer">
                    <div class="user-card">
                        <div class="avatar">${user.fullName.substring(0,1)}</div>
                        <div style="flex:1; min-width:0;">
                            <div style="font-weight:800; color:var(--primary); white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">${user.fullName}</div>
                            <div style="font-size:12px; color:var(--muted); margin-top:2px;">Admin Officer</div>
                        </div>
                        <a href="${pageContext.request.contextPath}/logout" style="color:var(--danger); padding:8px; border-radius:8px; background:rgba(184,50,48,.1); display:grid; place-items:center;" title="Logout">
                            <span class="material-symbols-outlined" style="font-size:18px;">logout</span>
                        </a>
                    </div>
                </div>
            </aside>

            <!-- NỘI DUNG CHÍNH -->
            <div class="main">
                <div class="topbar">
                    <div>
                        <p class="eyebrow">Overview</p>
                        <h1>Admin Officer Dashboard</h1>
                        <p>Quản lý hợp đồng và tình trạng phê duyệt</p>
                    </div>
                </div>

                <!-- 1. KHU VỰC KPI -->
                <div style="display:grid; grid-template-columns:repeat(auto-fit, minmax(200px, 1fr)); gap:20px; margin-bottom:30px;">
                    <div style="padding:20px; background:var(--surface); border-radius:16px; border:1px solid var(--line); box-shadow:var(--shadow);">
                        <h3 style="margin:0 0 10px; color:var(--muted); font-size:14px;">Awaiting Quotations</h3>
                        <p style="margin:0; font-size:36px; font-weight:800; color:var(--danger);">${awaitingQuotations}</p>
                        <small style="color:var(--muted);">Báo giá chờ làm hợp đồng</small>
                    </div>
                    <div style="padding:20px; background:var(--surface); border-radius:16px; border:1px solid var(--line); box-shadow:var(--shadow);">
                        <h3 style="margin:0 0 10px; color:var(--muted); font-size:14px;">Contracts In Progress</h3>
                        <p style="margin:0; font-size:36px; font-weight:800; color:var(--tertiary);">${contractsInProgress}</p>
                        <small style="color:var(--muted);">Đang xử lý / chờ duyệt</small>
                    </div>
                    <div style="padding:20px; background:var(--surface); border-radius:16px; border:1px solid var(--line); box-shadow:var(--shadow);">
                        <h3 style="margin:0 0 10px; color:var(--muted); font-size:14px;">Active Contracts</h3>
                        <p style="margin:0; font-size:36px; font-weight:800; color:var(--primary);">${activeContracts}</p>
                        <small style="color:var(--muted);">Đã ký kết / hiệu lực</small>
                    </div>
                </div>

                <div style="display:grid; grid-template-columns: 1fr 2fr; gap: 20px;">
                    <!-- 2. BIỂU ĐỒ TRẠNG THÁI -->
                    <div style="background:var(--surface); padding:24px; border-radius:16px; border:1px solid var(--line);">
                        <h3 style="margin-top:0;">Contract Status</h3>
                        <canvas id="statusChart"></canvas>
                    </div>

                    <!-- 3. DANH SÁCH NHẮC VIỆC -->
                    <div style="background:var(--surface); padding:24px; border-radius:16px; border:1px solid var(--line);">
                        <h3 style="margin-top:0;">Contracts Needing Action</h3>
                        <table style="width:100%; text-align:left; border-collapse: collapse;">
                            <thead>
                                <tr style="border-bottom: 2px solid var(--line); color:var(--muted);">
                                    <th style="padding:12px 10px;">ID</th>
                                    <th style="padding:12px 10px;">Company</th>
                                    <th style="padding:12px 10px;">Status</th>
                                    <th style="padding:12px 10px; text-align:right;">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="c" items="${contractsNeedingAction}">
                                    <tr style="border-bottom: 1px solid var(--line);">
                                        <td style="padding:12px 10px; font-weight:bold;">${c.contractNumber}</td>
                                        <td style="padding:12px 10px;">${c.customerName}</td>
                                        <td style="padding:12px 10px;">
                                            <span style="padding:4px 8px; background:var(--primary-soft); color:var(--primary); border-radius:6px; font-size:12px; font-weight:bold;">${c.contractStatus}</span>
                                        </td>
                                        <td style="padding:12px 10px; text-align:right;">
                                            <a href="${pageContext.request.contextPath}/contract-detail?id=${c.contractId}" style="color:var(--primary); font-weight:bold;">Review &rarr;</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty contractsNeedingAction}">
                                    <tr><td colspan="4" style="padding:20px; text-align:center; color:var(--muted);">No pending actions. Great job!</td></tr>
                                </c:if>
                            </tbody>
                        </table>
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
                    cutout: '70%',
                    plugins: {
                        legend: { position: 'bottom' }
                    }
                }
            });
        </script>
    </body>
</html>
