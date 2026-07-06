<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Role Detail - ${role.roleName}</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
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
                --danger-soft:#ffdad8;
                --line:#ddd5c9;
                --shadow:0 18px 45px rgba(46,50,48,.08);
            }
            * {
                box-sizing:border-box;
            }
            body {
                margin:0;
                min-height:100vh;
                background:var(--bg);
                color:var(--text);
                font-family:'Nunito Sans',Arial,sans-serif;
            }
            a {
                color:inherit;
                text-decoration:none;
            }
            .material-symbols-outlined {
                font-family:'Material Symbols Outlined';
                font-weight:normal;
                font-style:normal;
                font-size:22px;
                line-height:1;
                letter-spacing:normal;
                text-transform:none;
                display:inline-flex;
                align-items:center;
                justify-content:center;
                white-space:nowrap;
                word-wrap:normal;
                direction:ltr;
                -webkit-font-feature-settings:'liga';
                -webkit-font-smoothing:antialiased;
                font-feature-settings:'liga';
                font-variation-settings:'FILL' 0,'wght' 500,'GRAD' 0,'opsz' 24;
                width:1em;
                min-width:1em;
                overflow:hidden;
            }
            .role-shell {
                display:grid;
                grid-template-columns:260px minmax(0,1fr);
                min-height:100vh;
            }
            .sidebar {
                position:sticky;
                top:0;
                height:100vh;
                padding:28px 18px;
                background:linear-gradient(180deg,#f7f2eb 0%,#f2ede5 100%);
                border-right:1px solid var(--line);
                display:flex;
                flex-direction:column;
                gap:28px;
                overflow-y:auto;
            }
            .sidebar::-webkit-scrollbar {
                width:6px;
            }
            .sidebar::-webkit-scrollbar-track {
                background:transparent;
            }
            .sidebar::-webkit-scrollbar-thumb {
                background:rgba(0,0,0,0.08);
                border-radius:3px;
            }
            .sidebar::-webkit-scrollbar-thumb:hover {
                background:rgba(0,0,0,0.16);
            }
            .sidebar::before {
                content:'';
                position:absolute;
                inset:0;
                background:radial-gradient(circle at top left,rgba(142,207,158,.2),transparent 28%);
                pointer-events:none;
            }
            .brand,.nav-group,.sidebar-footer {
                position:relative;
                z-index:1;
            }
            .brand {
                display:flex;
                align-items:center;
                gap:12px;
                padding:0 8px;
            }
            .brand-mark {
                width:44px;
                height:44px;
                border-radius:16px;
                display:grid;
                place-items:center;
                background:linear-gradient(135deg,var(--primary),#8ecf9e);
                color:#fff;
                box-shadow:var(--shadow);
            }
            .brand-title {
                margin:0;
                color:var(--primary);
                font-family:'Literata',Georgia,serif;
                font-size:21px;
                line-height:1.1;
            }
            .brand-subtitle {
                margin:2px 0 0;
                color:var(--muted);
                font-size:12px;
            }
            .nav-group {
                display:flex;
                flex-direction:column;
                gap:7px;
            }
            .nav-link {
                position:relative;
                display:flex;
                align-items:center;
                gap:12px;
                padding:12px 14px;
                border-radius:16px;
                color:var(--muted);
                font-weight:700;
                overflow:hidden;
                transition:transform .28s ease,color .28s ease,box-shadow .28s ease;
            }
            .nav-link::before {
                content:'';
                position:absolute;
                inset:0;
                border-radius:inherit;
                background:linear-gradient(90deg,rgba(220,239,225,.95),rgba(220,239,225,.55));
                transform:scaleX(.72);
                transform-origin:left center;
                opacity:0;
                transition:transform .28s ease,opacity .28s ease;
                z-index:-1;
            }
            .nav-link:hover,.nav-link.active {
                color:var(--primary);
                transform:translateX(6px);
                box-shadow:0 10px 24px rgba(74,124,89,.12);
            }
            .nav-link:hover::before,.nav-link.active::before {
                opacity:1;
                transform:scaleX(1);
            }
            .sidebar-footer {
                position:relative;
                z-index:1;
                margin-top:auto;
                padding-top:18px;
                border-top:1px solid var(--line);
            }
            .main {
                min-width:0;
                padding:30px 36px 42px;
            }
            .page-top {
                display:flex;
                align-items:flex-end;
                justify-content:space-between;
                gap:20px;
                margin-bottom:26px;
            }
            .eyebrow {
                margin:0 0 6px;
                color:var(--primary);
                font-weight:800;
                letter-spacing:.08em;
                text-transform:uppercase;
                font-size:12px;
            }
            h1,h2,h3 {
                font-family:'Literata',Georgia,serif;
            }
            h1 {
                margin:0;
                font-size:clamp(32px,4vw,46px);
                line-height:1.08;
            }
            .page-top p {
                margin:8px 0 0;
                color:var(--muted);
            }
            .actions {
                display:flex;
                flex-wrap:wrap;
                justify-content:flex-end;
                gap:10px;
            }
            .button {
                display:inline-flex;
                align-items:center;
                justify-content:center;
                gap:8px;
                padding:11px 16px;
                border:1px solid var(--line);
                border-radius:999px;
                background:var(--surface);
                color:var(--text);
                font-weight:800;
                cursor:pointer;
                font-family:inherit;
            }
            .button.primary {
                background:var(--primary);
                border-color:var(--primary);
                color:#fff;
            }
            .button.danger {
                background:var(--danger-soft);
                border-color:var(--danger-soft);
                color:var(--danger);
            }
            .button:hover {
                transform:translateY(-1px);
                box-shadow:0 12px 28px rgba(46,50,48,.08);
            }
            .panel {
                background:var(--surface);
                border:1px solid rgba(221,213,201,.85);
                border-radius:28px;
                box-shadow:var(--shadow);
                overflow:hidden;
            }
            .panel-head {
                padding:22px 24px;
                border-bottom:1px solid var(--line);
                background:linear-gradient(135deg,#fffaf3,#f0ece4);
                display:flex;
                justify-content:space-between;
                align-items:center;
                gap:16px;
            }
            .panel-head h2 {
                margin:0;
                font-size:22px;
            }
            .panel-body {
                padding:24px;
            }
            .info-grid {
                display:grid;
                grid-template-columns:repeat(5,minmax(0,1fr));
                gap:14px;
                margin-bottom:22px;
            }
            .info-card {
                padding:16px;
                border-radius:18px;
                background:var(--surface-soft);
                border:1px solid rgba(221,213,201,.75);
            }
            .info-label {
                margin:0 0 7px;
                color:var(--muted);
                font-size:12px;
                font-weight:800;
                text-transform:uppercase;
                letter-spacing:.05em;
            }
            .info-value {
                margin:0;
                font-weight:900;
                color:var(--text);
            }
            .form-grid {
                display:grid;
                grid-template-columns:repeat(2,minmax(0,1fr));
                gap:16px;
                margin-bottom:22px;
            }
            .field label {
                display:block;
                margin-bottom:8px;
                color:var(--muted);
                font-weight:800;
            }
            .field input {
                width:100%;
                padding:13px 14px;
                border:1px solid var(--line);
                border-radius:16px;
                background:#fff;
                color:var(--text);
                font:inherit;
                font-weight:700;
                outline:none;
            }
            .field input:read-only {
                background:var(--surface-soft);
                color:var(--muted);
            }
            .permission-grid {
                display:grid;
                grid-template-columns:repeat(auto-fill,minmax(230px,1fr));
                gap:12px;
            }
            .permission-card {
                display:flex;
                align-items:center;
                gap:12px;
                padding:14px;
                border:1px solid var(--line);
                border-radius:18px;
                background:#fffdf8;
                font-weight:800;
            }
            .permission-card .material-symbols-outlined {
                color:var(--primary);
            }
            .terra-checkbox {
                appearance:none;
                width:22px;
                height:22px;
                border:2px solid #c4c8bc;
                border-radius:7px;
                background:#fff;
                display:inline-grid;
                place-items:center;
                cursor:pointer;
                transition:.2s ease;
            }
            .terra-checkbox:checked {
                background:var(--primary);
                border-color:var(--primary);
            }
            .terra-checkbox:checked::after {
                content:'check';
                font-family:'Material Symbols Outlined';
                color:#fff;
                font-size:17px;
                line-height:1;
            }
            table {
                width:100%;
                border-collapse:collapse;
                min-width:620px;
            }
            th {
                padding:15px 18px;
                color:var(--muted);
                text-align:left;
                font-size:12px;
                letter-spacing:.05em;
                text-transform:uppercase;
                background:#fbf7f0;
            }
            td {
                padding:16px 18px;
                border-top:1px solid var(--line);
                font-weight:700;
            }
            .table-wrap {
                overflow-x:auto;
                border-radius:20px;
                border:1px solid var(--line);
            }
            .alert {
                padding:14px 16px;
                border-radius:16px;
                margin-bottom:18px;
                background:var(--danger-soft);
                color:var(--danger);
                font-weight:800;
            }
            .empty-state {
                padding:24px;
                border-radius:18px;
                background:var(--surface-soft);
                color:var(--muted);
                text-align:center;
                font-weight:800;
            }
            @media (max-width:1080px) {
                .role-shell {
                    grid-template-columns:1fr;
                }
                .sidebar {
                    position:static;
                    height:auto;
                }
                .nav-group {
                    display:grid;
                    grid-template-columns:repeat(2,minmax(0,1fr));
                }
                .info-grid,.form-grid {
                    grid-template-columns:1fr;
                }
            }
            @media (max-width:720px) {
                .main {
                    padding:22px 16px;
                }
                .page-top,.panel-head {
                    align-items:flex-start;
                    flex-direction:column;
                }
                .actions {
                    width:100%;
                    justify-content:flex-start;
                }
            }
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
                    <div><p class="eyebrow">Access Control</p><h1>Role Detail</h1><p>Review role profile and manage its permission set.</p></div>
                    <div class="actions"><a class="button" href="${pageContext.request.contextPath}/role-list"><span class="material-symbols-outlined">arrow_back</span>Back to roles</a>
                        <a class="button primary" href="${pageContext.request.contextPath}/edit-role-permissions?roleId=${role.roleId}"><span class="material-symbols-outlined">tune</span>Edit permissions</a></div>
                </section>
                <section class="panel">
                    <div class="panel-head"><h2><c:out value="${role.roleName}"/></h2><span class="button"><span class="material-symbols-outlined">shield_person</span>R-${role.roleId}</span></div>
                    <div class="panel-body">
                        <div class="info-grid">
                            <div class="info-card"><p class="info-label">Role ID</p><p class="info-value">R-<c:out value="${role.roleId}"/></p></div>
                            <div class="info-card"><p class="info-label">Role Name</p><p class="info-value"><c:out value="${role.roleName}"/></p></div>
                            <div class="info-card"><p class="info-label">Created At</p><p class="info-value"><fmt:formatDate value="${role.createAt}" pattern="dd/MM/yyyy HH:mm"/></p></div>
                            <div class="info-card"><p class="info-label">Updated At</p><p class="info-value"><fmt:formatDate value="${role.updateAt}" pattern="dd/MM/yyyy HH:mm"/></p></div>
                            <div class="info-card"><p class="info-label">Status</p><p class="info-value" style="color: ${role.status == 'Active' || empty role.status ? 'var(--primary)' : 'var(--danger)'};"><c:out value="${empty role.status ? 'Active' : role.status}"/></p></div>
                        </div>
                        <div class="panel-head" style="border:1px solid var(--line); border-radius:20px; margin-bottom:16px;"><h2>Permissions</h2><span class="button"><span class="material-symbols-outlined">key</span><c:out value="${empty role.permissions ? 0 : role.permissions.size()}"/> enabled</span></div>
                        <c:choose>
                            <c:when test="${empty role.permissions}"><div class="empty-state">No permissions assigned to this role yet.</div></c:when>
                            <c:otherwise><div class="permission-grid"><c:forEach var="p" items="${role.permissions}"><div class="permission-card"><span class="material-symbols-outlined">verified_user</span><c:out value="${p.permissionName}"/></div></c:forEach></div></c:otherwise>
                        </c:choose>
                    </div>
                </section>
            </main>
        </div>
    </body>
</html>
