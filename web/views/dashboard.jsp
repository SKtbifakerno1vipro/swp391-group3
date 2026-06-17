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
        <style>
            :root { --bg:#faf6f0; --surface:#fffaf3; --surface-soft:#f0ece4; --surface-strong:#e4e0d8; --text:#2e3230; --muted:#646b66; --primary:#4a7c59; --primary-soft:#dcefe1; --secondary:#7a6148; --tertiary:#b1812f; --danger:#b83230; --line:#ddd5c9; --shadow:0 18px 45px rgba(46,50,48,.08); }
            * { box-sizing:border-box; }
            body { margin:0; min-height:100vh; background:var(--bg); color:var(--text); font-family:'Nunito Sans',Arial,sans-serif; }
            a { color:inherit; text-decoration:none; }
            .material-symbols-outlined { font-family:'Material Symbols Outlined'; font-weight:normal; font-style:normal; font-size:22px; line-height:1; letter-spacing:normal; text-transform:none; display:inline-flex; align-items:center; justify-content:center; white-space:nowrap; word-wrap:normal; direction:ltr; -webkit-font-feature-settings:'liga'; -webkit-font-smoothing:antialiased; font-feature-settings:'liga'; font-variation-settings:'FILL' 0,'wght' 500,'GRAD' 0,'opsz' 24; width:1em; min-width:1em; overflow:hidden; }
            .dashboard-shell { display:grid; grid-template-columns:260px minmax(0,1fr); min-height:100vh; }
            .sidebar { position:sticky; top:0; height:100vh; padding:28px 18px; background:linear-gradient(180deg,#f7f2eb 0%,#f2ede5 100%); border-right:1px solid var(--line); display:flex; flex-direction:column; gap:28px; overflow:hidden; }
            .sidebar::before { content:''; position:absolute; inset:0; background:radial-gradient(circle at top left,rgba(142,207,158,.2),transparent 28%); pointer-events:none; }
            .brand { position:relative; z-index:1; display:flex; align-items:center; gap:12px; padding:0 8px; animation:sidebarFadeIn .5s ease-out; }
            .brand-mark { width:44px; height:44px; border-radius:16px; display:grid; place-items:center; background:linear-gradient(135deg,var(--primary),#8ecf9e); color:#fff; box-shadow:var(--shadow); }
            .brand-title { margin:0; color:var(--primary); font-family:'Literata',Georgia,serif; font-size:21px; line-height:1.1; }
            .brand-subtitle { margin:2px 0 0; color:var(--muted); font-size:12px; }
            .nav-group { position:relative; z-index:1; display:flex; flex-direction:column; gap:7px; }
            .nav-link { position:relative; display:flex; align-items:center; gap:12px; padding:12px 14px; border-radius:16px; color:var(--muted); font-weight:700; overflow:hidden; transform:translateX(0); transition:transform .28s ease,color .28s ease,box-shadow .28s ease,background-color .28s ease; }
            .nav-link::before { content:''; position:absolute; inset:0; border-radius:inherit; background:linear-gradient(90deg,rgba(220,239,225,.95),rgba(220,239,225,.55)); transform:scaleX(.72); transform-origin:left center; opacity:0; transition:transform .28s ease,opacity .28s ease; z-index:-1; }
            .nav-link .material-symbols-outlined { transition:transform .28s ease,color .28s ease; }
            .nav-link:hover,.nav-link.active { color:var(--primary); transform:translateX(6px); box-shadow:0 10px 24px rgba(74,124,89,.12); }
            .nav-link:hover::before,.nav-link.active::before { opacity:1; transform:scaleX(1); }
            .nav-link:hover .material-symbols-outlined,.nav-link.active .material-symbols-outlined { transform:scale(1.08); }
            .sidebar-footer { position:relative; z-index:1; margin-top:auto; padding-top:18px; border-top:1px solid var(--line); animation:sidebarFadeIn .65s ease-out; }
            .user-card { display:flex; gap:12px; align-items:center; padding:12px; border-radius:18px; background:var(--surface); }
            .avatar { width:42px; height:42px; border-radius:50%; display:grid; place-items:center; background:var(--primary); color:white; font-weight:800; }
            .main { min-width:0; padding:26px 34px 38px; }
            .topbar { display:flex; justify-content:space-between; gap:18px; align-items:center; margin-bottom:30px; }
            .eyebrow { margin:0 0 6px; color:var(--primary); font-weight:800; letter-spacing:.08em; text-transform:uppercase; font-size:12px; }
            h1,h2 { font-family:'Literata',Georgia,serif; }
            h1 { margin:0; font-size:clamp(30px,4vw,44px); line-height:1.1; }
            .topbar p { margin:8px 0 0; color:var(--muted); }
            .top-actions { display:flex; gap:10px; flex-wrap:wrap; justify-content:flex-end; }
            .button { display:inline-flex; align-items:center; gap:8px; padding:11px 16px; border-radius:999px; font-weight:800; border:1px solid var(--line); background:var(--surface); }
            .button.primary { background:var(--primary); color:white; border-color:var(--primary); }
            .hero { display:grid; grid-template-columns:minmax(0,1.6fr) minmax(280px,.9fr); gap:20px; margin-bottom:22px; }
            .panel,.metric-card { background:var(--surface); border:1px solid rgba(221,213,201,.8); border-radius:26px; box-shadow:var(--shadow); }
            .hero-card { padding:28px; background:radial-gradient(circle at top right,rgba(142,207,158,.42),transparent 32%),linear-gradient(135deg,#fffaf3,#f0ece4); overflow:hidden; position:relative; }
            .hero-card h2 { margin:0; font-size:28px; }
            .hero-card p { max-width:650px; color:var(--muted); line-height:1.7; }
            .quick-grid { display:grid; grid-template-columns:repeat(3,minmax(0,1fr)); gap:12px; margin-top:24px; }
            .quick-link { padding:14px; border-radius:18px; background:rgba(255,255,255,.62); border:1px solid rgba(221,213,201,.7); font-weight:800; }
            .quick-link span { display:block; color:var(--muted); font-weight:600; font-size:12px; margin-top:4px; }
            .status-panel { padding:22px; }
            .panel-title { display:flex; align-items:center; justify-content:space-between; gap:12px; margin-bottom:16px; }
            .panel-title h2 { margin:0; font-size:20px; }
            .status-list { display:flex; flex-direction:column; gap:12px; }
            .status-item { display:flex; justify-content:space-between; align-items:center; padding:13px 14px; border-radius:16px; background:var(--surface-soft); color:var(--muted); font-weight:800; }
            .status-item strong { color:var(--text); font-size:18px; }
            .metric-grid { display:grid; grid-template-columns:repeat(6,minmax(0,1fr)); gap:16px; margin-bottom:22px; }
            .metric-card { padding:20px; transition:.2s ease; }
            .metric-card:hover { transform:translateY(-4px); }
            .metric-icon { width:42px; height:42px; display:grid; place-items:center; border-radius:15px; margin-bottom:18px; background:var(--primary-soft); color:var(--primary); }
            .metric-card.secondary .metric-icon { background:#f0e8db; color:var(--secondary); }
            .metric-card.tertiary .metric-icon { background:#f8e0a8; color:var(--tertiary); }
            .metric-card.danger .metric-icon { background:#ffdad8; color:var(--danger); }
            .metric-card.info .metric-icon { background:#e0f2fe; color:#0369a1; }
            .metric-value { margin:0; font-size:24px; font-family:'Literata',Georgia,serif; font-weight:700; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
            .metric-label { margin:3px 0 0; color:var(--muted); font-weight:700; }
            .content-grid { display:grid; grid-template-columns:minmax(0,1.25fr) minmax(300px,.75fr); gap:20px; margin-bottom: 22px; }
            .table-panel { padding:22px; overflow:hidden; }
            table { width:100%; border-collapse:collapse; }
            th,td { padding:14px 10px; text-align:left; border-bottom:1px solid var(--line); }
            th { color:var(--muted); font-size:12px; text-transform:uppercase; letter-spacing:.04em; }
            td { font-weight:700; }
            .badge { display:inline-flex; padding:6px 10px; border-radius:999px; background:var(--primary-soft); color:var(--primary); font-size:12px; font-weight:800; }
            .workflow-panel { padding:22px; }
            .workflow-step { display:grid; grid-template-columns:38px minmax(0,1fr); gap:12px; padding:12px 0; }
            .step-number { width:34px; height:34px; border-radius:12px; display:grid; place-items:center; background:var(--surface-soft); color:var(--primary); font-weight:900; }
            .workflow-step h3 { margin:0 0 4px; font-size:15px; }
            .workflow-step p { margin:0; color:var(--muted); line-height:1.5; }
            .empty-state { padding:24px; border-radius:18px; background:var(--surface-soft); color:var(--muted); text-align:center; font-weight:700; }
            .chart-container { position: relative; height: 300px; width: 100%; }
            @keyframes sidebarFadeIn { from { opacity:0; transform:translateX(-10px); } to { opacity:1; transform:translateX(0); } }
            @media (max-width:1400px) { .metric-grid { grid-template-columns:repeat(3,minmax(0,1fr)); } }
            @media (max-width:1180px) { .hero,.content-grid { grid-template-columns:1fr; } }
            @media (max-width:820px) { .dashboard-shell { grid-template-columns:1fr; } .sidebar { position:static; height:auto; } .nav-group { display:grid; grid-template-columns:repeat(2,minmax(0,1fr)); } .main { padding:22px 16px; } .topbar { align-items:flex-start; flex-direction:column; } .metric-grid,.quick-grid { grid-template-columns:1fr; } }
        </style>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="dashboard"/>
            </jsp:include>
            <main class="main">
                <section class="topbar">
                    <div><p class="eyebrow">Sales Performance Dashboard</p><h1>Welcome back, <c:out value="${user.fullName}"/>.</h1><p>Overview of sales activity, revenue trends, and key performance indicators.</p></div><div class="top-actions"><a class="button" href="${pageContext.request.contextPath}/product-list"><span class="material-symbols-outlined">inventory_2</span>Products</a><a class="button primary" href="${pageContext.request.contextPath}/customer-order-list"><span class="material-symbols-outlined">shopping_cart</span>Orders</a></div></section>
                
                <section class="metric-grid" aria-label="Dashboard metrics">
                    <div class="metric-card info">
                        <div class="metric-icon"><span class="material-symbols-outlined">payments</span></div>
                        <p class="metric-value"><fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/> ₫</p>
                        <p class="metric-label">Total Revenue</p>
                    </div>
                    <a class="metric-card" href="${pageContext.request.contextPath}/customer/list">
                        <div class="metric-icon"><span class="material-symbols-outlined">groups</span></div>
                        <p class="metric-value"><c:out value="${totalCustomers}"/></p>
                        <p class="metric-label">Customers</p>
                    </a>
                    <a class="metric-card danger" href="${pageContext.request.contextPath}/customer-order-list">
                        <div class="metric-icon"><span class="material-symbols-outlined">local_shipping</span></div>
                        <p class="metric-value"><c:out value="${totalOrders}"/></p>
                        <p class="metric-label">Total Orders</p>
                    </a>
                    <a class="metric-card secondary" href="${pageContext.request.contextPath}/product-list">
                        <div class="metric-icon"><span class="material-symbols-outlined">inventory_2</span></div>
                        <p class="metric-value"><c:out value="${totalProducts}"/></p>
                        <p class="metric-label">Products</p>
                    </a>
                    <a class="metric-card tertiary" href="${pageContext.request.contextPath}/quotation-list">
                        <div class="metric-icon"><span class="material-symbols-outlined">request_quote</span></div>
                        <p class="metric-value"><c:out value="${totalQuotations}"/></p>
                        <p class="metric-label">Quotations</p>
                    </a>
                    <a class="metric-card" href="${pageContext.request.contextPath}/contract-list">
                        <div class="metric-icon"><span class="material-symbols-outlined">description</span></div>
                        <p class="metric-value"><c:out value="${totalContracts}"/></p>
                        <p class="metric-label">Contracts</p>
                    </a>
                </section>

                <section class="hero">
                    <div class="panel status-panel" style="grid-column: span 2;">
                        <div class="panel-title"><h2>Order Status</h2><span class="badge"><c:out value="${totalOrders}"/> total</span></div>
                        <div class="status-list" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 15px;">
                            <c:forEach var="entry" items="${orderStatusCounts}">
                                <div class="status-item"><span><c:out value="${entry.key}"/></span><strong><c:out value="${entry.value}"/></strong></div>
                            </c:forEach>
                            <c:if test="${empty orderStatusCounts}">
                                <div class="empty-state">No order data yet.</div>
                            </c:if>
                        </div>
                    </div>
                </section>

                <section class="content-grid" style="grid-template-columns: 1fr;">
                    <div class="panel table-panel">
                        <div class="panel-title"><h2>Recent Orders</h2><a class="badge" href="${pageContext.request.contextPath}/customer-order-list">View all</a></div>
                        <c:choose>
                            <c:when test="${empty recentOrders}">
                                <div class="empty-state">No recent orders found.</div>
                            </c:when>
                            <c:otherwise>
                                <table>
                                    <thead><tr><th>ID</th><th>Customer</th><th>Status</th><th>Date</th><th></th></tr></thead>
                                    <tbody>
                                        <c:forEach var="order" items="${recentOrders}">
                                            <tr>
                                                <td>#<c:out value="${order.id}"/></td>
                                                <td><c:out value="${not empty order.companyName ? order.companyName : order.customerName}" default="Unknown"/></td>
                                                <td><span class="badge"><c:out value="${order.status}"/></span></td>
                                                <td><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy"/></td>
                                                <td><a class="badge" href="${pageContext.request.contextPath}/customer-order-detail?id=${order.id}">Details</a></td>
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

        <script>
            // Dashboard scripts
        </script>
    </body>
</html>
