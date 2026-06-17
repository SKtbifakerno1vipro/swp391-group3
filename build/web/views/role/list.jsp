<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Role Management - Po Bread Sales</title>
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
            .role-shell { display:grid; grid-template-columns:260px minmax(0,1fr); min-height:100vh; }
            .sidebar { position:sticky; top:0; height:100vh; padding:28px 18px; background:linear-gradient(180deg,#f7f2eb 0%,#f2ede5 100%); border-right:1px solid var(--line); display:flex; flex-direction:column; gap:28px; overflow:hidden; }
            .sidebar::before { content:''; position:absolute; inset:0; background:radial-gradient(circle at top left,rgba(142,207,158,.2),transparent 28%); pointer-events:none; }
            .brand,.nav-group,.sidebar-footer { position:relative; z-index:1; }
            .brand { display:flex; align-items:center; gap:12px; padding:0 8px; animation:sidebarFadeIn .5s ease-out; }
            .brand-mark { width:44px; height:44px; border-radius:16px; display:grid; place-items:center; background:linear-gradient(135deg,var(--primary),#8ecf9e); color:#fff; box-shadow:var(--shadow); }
            .brand-title { margin:0; color:var(--primary); font-family:'Literata',Georgia,serif; font-size:21px; line-height:1.1; }
            .brand-subtitle { margin:2px 0 0; color:var(--muted); font-size:12px; }
            .nav-group { display:flex; flex-direction:column; gap:7px; }
            .nav-link { position:relative; display:flex; align-items:center; gap:12px; padding:12px 14px; border-radius:16px; color:var(--muted); font-weight:700; overflow:hidden; transition:transform .28s ease,color .28s ease,box-shadow .28s ease; }
            .nav-link::before { content:''; position:absolute; inset:0; border-radius:inherit; background:linear-gradient(90deg,rgba(220,239,225,.95),rgba(220,239,225,.55)); transform:scaleX(.72); transform-origin:left center; opacity:0; transition:transform .28s ease,opacity .28s ease; z-index:-1; }
            .nav-link:hover,.nav-link.active { color:var(--primary); transform:translateX(6px); box-shadow:0 10px 24px rgba(74,124,89,.12); }
            .nav-link:hover::before,.nav-link.active::before { opacity:1; transform:scaleX(1); }
            .nav-link .material-symbols-outlined { transition:transform .28s ease; }
            .nav-link:hover .material-symbols-outlined,.nav-link.active .material-symbols-outlined { transform:scale(1.08); }
            .sidebar-footer { margin-top:auto; padding-top:18px; border-top:1px solid var(--line); animation:sidebarFadeIn .65s ease-out; }
            .user-card { display:flex; gap:12px; align-items:center; padding:12px; border-radius:18px; background:var(--surface); }
            .avatar { width:42px; height:42px; border-radius:50%; display:grid; place-items:center; background:var(--primary); color:#fff; }
            .main { min-width:0; padding:30px 36px 42px; }
            .page-top { display:flex; align-items:flex-end; justify-content:space-between; gap:20px; margin-bottom:26px; }
            .eyebrow { margin:0 0 6px; color:var(--primary); font-weight:800; letter-spacing:.08em; text-transform:uppercase; font-size:12px; }
            h1,h2 { font-family:'Literata',Georgia,serif; }
            h1 { margin:0; font-size:clamp(32px,4vw,46px); line-height:1.08; }
            .page-top p { margin:8px 0 0; color:var(--muted); }
            .actions { display:flex; flex-wrap:wrap; justify-content:flex-end; gap:10px; }
            .button { display:inline-flex; align-items:center; gap:8px; padding:11px 16px; border:1px solid var(--line); border-radius:999px; background:var(--surface); font-weight:800; cursor:pointer; }
            .button.primary { background:var(--primary); border-color:var(--primary); color:#fff; }
            .button:hover { transform:translateY(-1px); box-shadow:0 12px 28px rgba(46,50,48,.08); }
            .summary-grid { display:grid; grid-template-columns:repeat(3,minmax(0,1fr)); gap:16px; margin-bottom:22px; }
            .summary-card { padding:20px; border-radius:24px; background:var(--surface); border:1px solid rgba(221,213,201,.85); box-shadow:var(--shadow); }
            .summary-icon { width:42px; height:42px; display:grid; place-items:center; border-radius:15px; background:var(--primary-soft); color:var(--primary); margin-bottom:14px; }
            .summary-value { margin:0; font-family:'Literata',Georgia,serif; font-size:34px; font-weight:700; }
            .summary-label { margin:2px 0 0; color:var(--muted); font-weight:700; }
            .panel { background:var(--surface); border:1px solid rgba(221,213,201,.85); border-radius:28px; box-shadow:var(--shadow); overflow:hidden; }
            .toolbar { display:flex; justify-content:space-between; gap:18px; align-items:center; padding:22px; border-bottom:1px solid var(--line); background:linear-gradient(135deg,#fffaf3,#f0ece4); }
            .search-box { flex:1; max-width:430px; display:flex; align-items:center; gap:10px; padding:12px 14px; border:1px solid var(--line); border-radius:999px; background:rgba(255,255,255,.72); color:var(--muted); }
            .search-box input { width:100%; border:0; outline:0; background:transparent; color:var(--text); font:inherit; }
            .search-box .button { padding:8px 12px; border-radius:999px; box-shadow:none; }
            .role-table-wrap { overflow-x:auto; }
            table { width:100%; border-collapse:collapse; min-width:760px; }
            th { padding:16px 22px; color:var(--muted); text-align:left; font-size:12px; letter-spacing:.05em; text-transform:uppercase; background:#fbf7f0; }
            td { padding:18px 22px; border-top:1px solid var(--line); font-weight:700; vertical-align:middle; }
            tbody tr { transition:background .2s ease; }
            tbody tr:hover { background:#fbf6ee; }
            .role-id { color:var(--primary); font-weight:900; }
            .role-name { display:flex; align-items:center; gap:12px; }
            .role-badge { width:38px; height:38px; display:grid; place-items:center; border-radius:14px; background:var(--primary-soft); color:var(--primary); }
            .date-muted { color:var(--muted); font-weight:700; }
            .row-actions { display:flex; gap:8px; flex-wrap:wrap; }
            .chip { display:inline-flex; align-items:center; gap:6px; padding:8px 11px; border-radius:999px; background:var(--surface-soft); color:var(--muted); font-size:12px; font-weight:900; }
            .chip.primary { background:var(--primary-soft); color:var(--primary); }
            .chip:hover { transform:translateY(-1px); }
            .empty-state { padding:34px; text-align:center; color:var(--muted); font-weight:800; }
            .pagination { display:flex; align-items:center; justify-content:center; gap:8px; padding:20px; border-top:1px solid var(--line); }
            .page-link,.page-current { min-width:36px; height:36px; display:grid; place-items:center; border-radius:12px; font-weight:900; }
            .page-link { background:var(--surface-soft); color:var(--muted); }
            .page-link:hover,.page-current { background:var(--primary); color:#fff; }
            @keyframes sidebarFadeIn { from { opacity:0; transform:translateX(-10px); } to { opacity:1; transform:translateX(0); } }
            @media (max-width:1080px) { .summary-grid { grid-template-columns:1fr; } .role-shell { grid-template-columns:1fr; } .sidebar { position:static; height:auto; } .nav-group { display:grid; grid-template-columns:repeat(2,minmax(0,1fr)); } }
            @media (max-width:720px) { .main { padding:22px 16px; } .page-top,.toolbar { align-items:flex-start; flex-direction:column; } .actions,.search-box { width:100%; max-width:none; } }
        </style>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
    </head>
    <body>
        <div class="role-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="roles"/>
            </jsp:include>
            <main class="main">
                <section class="page-top">
                    <div><p class="eyebrow">Access Control</p><h1>Role Management</h1><p>Manage system roles and assign permissions for each responsibility group.</p></div>
                    <div class="actions"><a class="button" href="${pageContext.request.contextPath}/dashboard"><span class="material-symbols-outlined">arrow_back</span>Dashboard</a><a class="button primary" href="${pageContext.request.contextPath}/add-role"><span class="material-symbols-outlined">add</span>Add Role</a></div>
                </section>
                <section class="summary-grid">
                    <div class="summary-card"><div class="summary-icon"><span class="material-symbols-outlined">admin_panel_settings</span></div><p class="summary-value"><c:out value="${totalRoles}"/></p><p class="summary-label">Total matched roles</p></div>
                    <div class="summary-card"><div class="summary-icon"><span class="material-symbols-outlined">search</span></div><p class="summary-value"><c:out value="${empty searchText ? 'All' : '1'}"/></p><p class="summary-label"><c:out value="${empty searchText ? 'Showing all roles' : 'Search filter active'}"/></p></div>
                    <div class="summary-card"><div class="summary-icon"><span class="material-symbols-outlined">layers</span></div><p class="summary-value"><c:out value="${totalPages}"/></p><p class="summary-label">Total pages</p></div>
                </section>
                <section class="panel">
                    <div class="toolbar">
                        <form class="search-box" action="${pageContext.request.contextPath}/role-list" method="get"><span class="material-symbols-outlined">search</span><input type="text" name="search" value="${searchText}" placeholder="Search role name..."><button class="button primary" type="submit"><span class="material-symbols-outlined">arrow_forward</span>Search</button></form>
                        <a class="button" href="${pageContext.request.contextPath}/role-list"><span class="material-symbols-outlined">refresh</span>Reset</a>
                    </div>
                    <div class="role-table-wrap">
                        <table>
                            <thead><tr><th>Role ID</th><th>Role Name</th><th>Created At</th><th>Updated At</th><th>Actions</th></tr></thead>
                            <tbody>
                                <c:if test="${empty roleList}"><tr><td colspan="5"><div class="empty-state">No roles found.</div></td></tr></c:if>
                                <c:forEach var="role" items="${roleList}">
                                    <tr>
                                        <td><span class="role-id">R-<c:out value="${role.roleId}"/></span></td>
                                        <td><div class="role-name"><span class="role-badge"><span class="material-symbols-outlined">shield_person</span></span><strong><c:out value="${role.roleName}"/></strong></div></td>
                                        <td class="date-muted"><fmt:formatDate value="${role.createAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                        <td class="date-muted"><fmt:formatDate value="${role.updateAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                        <td><div class="row-actions"><a class="chip primary" href="${pageContext.request.contextPath}/role-detail?roleId=${role.roleId}"><span class="material-symbols-outlined">visibility</span>View</a><a class="chip" href="${pageContext.request.contextPath}/edit-role-permissions?roleId=${role.roleId}"><span class="material-symbols-outlined">tune</span>Permissions</a></div></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div class="pagination">
                        <c:if test="${currentPage > 1}"><a class="page-link" href="${pageContext.request.contextPath}/role-list?page=${currentPage - 1}&search=${searchText}">&lt;</a></c:if>
                        <c:forEach begin="1" end="${totalPages}" var="i"><c:choose><c:when test="${i == currentPage}"><span class="page-current">${i}</span></c:when><c:otherwise><a class="page-link" href="${pageContext.request.contextPath}/role-list?page=${i}&search=${searchText}">${i}</a></c:otherwise></c:choose></c:forEach>
                        <c:if test="${currentPage < totalPages}"><a class="page-link" href="${pageContext.request.contextPath}/role-list?page=${currentPage + 1}&search=${searchText}">&gt;</a></c:if>
                    </div>
                </section>
            </main>
        </div>
    </body>
</html>
