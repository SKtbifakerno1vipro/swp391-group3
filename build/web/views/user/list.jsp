<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>User Management - Po Bread Sales</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
        <style>
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
            h1 {
                margin:0;
                font-family:'Literata', Georgia, serif;
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
                gap:10px;
                justify-content:flex-end;
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
                text-decoration:none;
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
            .summary-grid {
                display:grid;
                grid-template-columns:repeat(3,minmax(0,1fr));
                gap:16px;
                margin-bottom:22px;
            }
            .summary-card {
                padding:20px;
                border-radius:24px;
                background:var(--surface);
                border:1px solid rgba(221,213,201,.85);
                box-shadow:var(--shadow);
            }
            .summary-icon {
                width:42px;
                height:42px;
                display:grid;
                place-items:center;
                border-radius:15px;
                background:var(--primary-soft);
                color:var(--primary);
                margin-bottom:14px;
            }
            .summary-value {
                margin:0;
                font-family:'Literata', Georgia, serif;
                font-size:34px;
                font-weight:700;
            }
            .summary-label {
                margin:2px 0 0;
                color:var(--muted);
                font-weight:700;
            }
            .panel {
                background:var(--surface);
                border:1px solid rgba(221,213,201,.85);
                border-radius:28px;
                box-shadow:var(--shadow);
                overflow:hidden;
            }
            .toolbar {
                padding:22px;
                border-bottom:1px solid var(--line);
                background:linear-gradient(135deg,#fffaf3,#f0ece4);
            }
            .filter-grid {
                display:grid;
                grid-template-columns:repeat(5,minmax(0,1fr)) auto;
                gap:12px;
                align-items:end;
            }
            .field label {
                display:block;
                margin-bottom:7px;
                color:var(--muted);
                font-size:12px;
                font-weight:900;
                text-transform:uppercase;
                letter-spacing:.04em;
            }
            .field input,.field select {
                width:100%;
                padding:11px 12px;
                border:1px solid var(--line);
                border-radius:14px;
                background:#fff;
                color:var(--text);
                font:inherit;
                font-weight:700;
            }
            .table-wrap {
                overflow-x:auto;
            }
            table {
                min-width:980px;
            }
            .user-name {
                display:flex;
                align-items:center;
                gap:12px;
            }
            .user-avatar {
                width:38px;
                height:38px;
                display:grid;
                place-items:center;
                border-radius:14px;
                background:var(--primary-soft);
                color:var(--primary);
            }
            .status-pill {
                display:inline-flex;
                align-items:center;
                padding:6px 10px;
                border-radius:999px;
                font-size:12px;
                font-weight:900;
            }
            .status-active {
                background:var(--primary-soft);
                color:var(--primary);
            }
            .status-inactive {
                background:var(--danger-soft);
                color:var(--danger);
            }
            .row-actions {
                display:flex;
                align-items:center;
                gap:8px;
                flex-wrap:wrap;
            }
            .chip {
                display:inline-flex;
                align-items:center;
                gap:6px;
                padding:8px 11px;
                border-radius:999px;
                background:var(--surface-soft);
                color:var(--muted);
                font-size:12px;
                font-weight:900;
                text-decoration:none;
                border:0;
                cursor:pointer;
            }
            .chip.primary {
                background:var(--primary-soft);
                color:var(--primary);
            }
            .chip.danger {
                background:var(--danger-soft);
                color:var(--danger);
            }
            .pagination {
                display:flex;
                align-items:center;
                justify-content:center;
                gap:8px;
                padding:20px;
                border-top:1px solid var(--line);
            }
            .page-link,.page-current {
                min-width:36px;
                height:36px;
                display:grid;
                place-items:center;
                border-radius:12px;
                font-weight:900;
                text-decoration:none;
            }
            .page-link {
                background:var(--surface-soft);
                color:var(--muted);
            }
            .page-current,.page-link:hover {
                background:var(--primary);
                color:#fff;
            }
            .disabled {
                opacity:.45;
                pointer-events:none;
            }
            @media (max-width:1100px) {
                .filter-grid,.summary-grid {
                    grid-template-columns:1fr 1fr;
                }
            }
            @media (max-width:720px) {
                .page-top {
                    flex-direction:column;
                    align-items:flex-start;
                }
                .filter-grid,.summary-grid {
                    grid-template-columns:1fr;
                }
                .actions {
                    justify-content:flex-start;
                }
            }
        </style>
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="users"/>
            </jsp:include>
            <main class="main legacy-page">
                <section class="page-top">
                    <div>
                        <p class="eyebrow">Access Control</p>
                        <h1>User Management</h1>
                        <p>Manage employee accounts, roles, contact information and account status.</p>
                    </div>
                    <div class="actions">
                        <a class="button primary" href="${pageContext.request.contextPath}/edit-user"><span class="material-symbols-outlined">person_add</span>Create User</a>
                    </div>
                </section>

                <section class="summary-grid">
                    <div class="summary-card"><div class="summary-icon"><span class="material-symbols-outlined">group</span></div><p class="summary-value"><c:out value="${empty users ? 0 : users.size()}"/></p><p class="summary-label">Users on this page</p></div>
                    <div class="summary-card"><div class="summary-icon"><span class="material-symbols-outlined">admin_panel_settings</span></div><p class="summary-value"><c:out value="${empty roles ? 0 : roles.size()}"/></p><p class="summary-label">Available roles</p></div>
                    <div class="summary-card"><div class="summary-icon"><span class="material-symbols-outlined">layers</span></div><p class="summary-value"><c:out value="${endPage}"/></p><p class="summary-label">Total pages</p></div>
                </section>

                <section class="panel">
                    <div class="toolbar">
                        <form method="get" action="${pageContext.request.contextPath}/user-list">
                            <div class="filter-grid">
                                <div class="field"><label>Full name</label><input type="text" name="searchName" value="${searchName}" placeholder="Search name"></div>
                                <div class="field"><label>Phone</label><input type="text" name="searchPhone" value="${searchPhone}" placeholder="Search phone"></div>
                                <div class="field"><label>Email</label><input type="text" name="searchEmail" value="${searchEmail}" placeholder="Search email"></div>
                                <div class="field"><label>Role</label><select name="roleId"><option value="0">All roles</option><c:forEach var="r" items="${roles}"><option value="${r.roleId}" ${r.roleId == roleId ? 'selected' : ''}>${r.roleName}</option></c:forEach></select></div>
                                <div class="field"><label>Status</label><select name="status"><option value="" ${empty status ? 'selected' : ''}>All statuses</option><option value="ACTIVE" ${status == 'ACTIVE' ? 'selected' : ''}>Active</option><option value="INACTIVE" ${status == 'INACTIVE' ? 'selected' : ''}>Inactive</option></select></div>
                                <div class="actions"><button class="button primary" type="submit"><span class="material-symbols-outlined">search</span>Search</button><a class="button" href="${pageContext.request.contextPath}/user-list">Reset</a></div>
                            </div>
                        </form>
                    </div>
                    <div class="table-wrap">
                        <table>
                            <thead><tr><th>User</th><th>Email</th><th>Phone</th><th>Role</th><th>Status</th><th>Actions</th></tr></thead>
                            <tbody>
                                <c:if test="${empty users}"><tr><td colspan="6" style="text-align:center;">No users found.</td></tr></c:if>
                                <c:forEach var="u" items="${users}">
                                    <tr>
                                        <td><div class="user-name"><span class="user-avatar"><span class="material-symbols-outlined">person</span></span><div><strong><c:out value="${u.fullName}"/></strong><br><small>@<c:out value="${u.userName}"/></small></div></div></td>
                                        <td><c:out value="${u.email}"/></td>
                                        <td><c:out value="${u.phone}"/></td>
                                        <td><c:out value="${u.roleName}"/></td>
                                        <td><span class="status-pill ${u.status == 'ACTIVE' ? 'status-active' : 'status-inactive'}"><c:out value="${u.status}"/></span></td>
                                        <td><div class="row-actions"><a class="chip primary" href="${pageContext.request.contextPath}/edit-user?id=${u.userId}"><span class="material-symbols-outlined">edit</span>Edit</a><form action="${pageContext.request.contextPath}/user-list" method="post" style="display:inline;"><input type="hidden" name="userId" value="${u.userId}"><input type="hidden" name="status" value="${u.status}"><button class="chip ${u.status == 'ACTIVE' ? 'danger' : 'primary'}" type="submit"><span class="material-symbols-outlined">${u.status == 'ACTIVE' ? 'lock' : 'lock_open'}</span>${u.status == 'ACTIVE' ? 'Ban' : 'Unban'}</button></form></div></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <c:if test="${endPage > 1}">
                        <c:set var="windowSize" value="2" />
                        <c:set var="start" value="${currentPage - windowSize > 1 ? currentPage - windowSize : 1}" />
                        <c:set var="end" value="${currentPage + windowSize < endPage ? currentPage + windowSize : endPage}" />
                        <div class="pagination">
                            <a class="page-link ${currentPage == 1 ? 'disabled' : ''}" href="user-list?page=1&searchName=${searchName}&searchPhone=${searchPhone}&searchEmail=${searchEmail}&roleId=${roleId}&status=${status}">&laquo;</a>
                            <a class="page-link ${currentPage == 1 ? 'disabled' : ''}" href="user-list?page=${currentPage - 1}&searchName=${searchName}&searchPhone=${searchPhone}&searchEmail=${searchEmail}&roleId=${roleId}&status=${status}">&lsaquo;</a>
                            <c:forEach begin="${start}" end="${end}" var="i"><c:choose><c:when test="${currentPage == i}"><span class="page-current">${i}</span></c:when><c:otherwise><a class="page-link" href="user-list?page=${i}&searchName=${searchName}&searchPhone=${searchPhone}&searchEmail=${searchEmail}&roleId=${roleId}&status=${status}">${i}</a></c:otherwise></c:choose></c:forEach>
                            <a class="page-link ${currentPage == endPage ? 'disabled' : ''}" href="user-list?page=${currentPage + 1}&searchName=${searchName}&searchPhone=${searchPhone}&searchEmail=${searchEmail}&roleId=${roleId}&status=${status}">&rsaquo;</a>
                            <a class="page-link ${currentPage == endPage ? 'disabled' : ''}" href="user-list?page=${endPage}&searchName=${searchName}&searchPhone=${searchPhone}&searchEmail=${searchEmail}&roleId=${roleId}&status=${status}">&raquo;</a>
                        </div>
                    </c:if>
                </section>
            </main>
        </div>
    </body>
</html>
