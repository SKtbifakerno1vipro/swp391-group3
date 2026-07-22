<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Người dùng - Po Bread Sales</title>
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
                background:#fff;
            }
            table {
                min-width:1000px;
                width:100%;
                border-collapse:collapse;
            }
            th, td {
                padding:16px 22px;
                text-align:left;
                border-bottom:1px solid var(--line);
                vertical-align:middle;
            }
            th {
                font-size:11px;
                font-weight:900;
                text-transform:uppercase;
                letter-spacing:.05em;
                color:var(--muted);
                background:var(--surface-soft, #faf9f7);
            }
            .table-row {
                transition:background 0.2s ease;
            }
            .table-row:hover {
                background:var(--surface-soft, #faf9f7);
            }
            .table-row:last-child td {
                border-bottom:none;
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
                white-space:nowrap;
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
                flex-wrap:nowrap;
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
                white-space:nowrap;
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
                        <p class="eyebrow">Quản lý Truy cập</p>
                        <h1>Quản lý Người dùng</h1>
                        <p>Quản lý tài khoản, vai trò, thông tin liên lạc và trạng thái của người dùng.</p>
                        <c:if test="${sessionScope.errorSig != null}">
                            <div style="color: red; margin-bottom: 10px;">${sessionScope.errorSig}</div>
                        </c:if>
                    </div>
                    <div class="actions">
                        <c:if test="${sessionScope.user.roleId == 1}">
                            <a class="button primary" href="${pageContext.request.contextPath}/edit-user"><span class="material-symbols-outlined">person_add</span>Thêm Người dùng</a>
                        </c:if>
                    </div>
                </section>


                <section class="panel">
                    <div class="toolbar">
                        <form method="get" action="${pageContext.request.contextPath}/user-list">
                            <div class="filter-grid">
                                <div class="field"><label>Họ và tên</label><input type="text" name="searchName" value="${searchName}" placeholder="Tìm tên"></div>
                                <div class="field"><label>Số điện thoại</label><input type="text" name="searchPhone" value="${searchPhone}" placeholder="Tìm SĐT"></div>
                                <div class="field"><label>Email</label><input type="text" name="searchEmail" value="${searchEmail}" placeholder="Tìm email"></div>
                                <div class="field"><label>Vai trò</label><select name="roleId"><option value="0">Tất cả vai trò</option>
                                        <c:forEach var="r" items="${roles}">
                                            <option value="${r.roleId}" ${r.roleId == roleId ? 'selected' : ''}>
                                                <c:choose>
                                                    <c:when test="${r.roleId == 1}">Quản trị hệ thống</c:when>
                                                    <c:when test="${r.roleId == 2}">Quản lý</c:when>
                                                    <c:when test="${r.roleId == 4}">Nhân viên Sale</c:when>
                                                    <c:when test="${r.roleId == 5}">Nhân viên Officer</c:when>
                                                    <c:when test="${r.roleId == 6}">Thủ kho</c:when>
                                                </c:choose>
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="field"><label>Trạng thái</label><select name="status"><option value="" ${empty status ? 'selected' : ''}>Tất cả trạng thái</option><option value="ACTIVE" ${status == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option><option value="INACTIVE" ${status == 'INACTIVE' ? 'selected' : ''}>Khóa</option></select></div>
                                <div class="actions"><button class="button primary" type="submit"><span class="material-symbols-outlined">search</span>Tìm kiếm</button><a class="button" href="${pageContext.request.contextPath}/user-list">Đặt lại</a></div>
                            </div>
                        </form>
                    </div>
                    <div class="table-wrap">
                        <table>
                            <thead><tr><th>ID</th><th>Họ Tên</th><th>Tài khoản</th><th>Email</th><th>Số điện thoại</th><th>Vai trò</th><th style="min-width: 120px;">Trạng thái</th><th style="min-width: 220px;">Thao tác</th></tr></thead>
                            <tbody>
                                <c:if test="${empty users}"><tr><td colspan="8" style="text-align:center;padding:40px;color:var(--muted);font-weight:600;">Không tìm thấy người dùng.</td></tr></c:if>
                                <c:forEach var="u" items="${users}">
                                    <tr class="table-row">
                                        <td style="color:var(--muted);font-weight:800;font-size:13px;">#<c:out value="${u.userId}"/></td>
                                        <td style="font-weight:700;"><c:out value="${u.fullName}"/></td>
                                        <td style="color:var(--muted);">@<c:out value="${u.userName}"/></td>
                                        <td style="color:var(--text-light, #6b7280);"><c:out value="${u.email}"/></td>
                                        <td style="color:var(--text-light, #6b7280);"><c:out value="${u.phone}"/></td>
                                        <td style="font-weight:700;">
                                            <c:choose>
                                                <c:when test="${u.roleId == 1}">Quản trị hệ thống</c:when>
                                                <c:when test="${u.roleId == 2}">Quản lý</c:when>
                                                <c:when test="${u.roleId == 4}">Nhân viên Sale</c:when>
                                                <c:when test="${u.roleId == 5}">Nhân viên Officer</c:when>
                                                <c:when test="${u.roleId == 6}">Thủ kho</c:when>
                                            </c:choose>
                                        </td>
                                        <td><span class="status-pill ${u.status == 'ACTIVE' ? 'status-active' : 'status-inactive'}"><c:out value="${u.status == 'ACTIVE' ? 'Hoạt động' : 'Khóa'}"/></span></td>
                                        <td style="white-space: nowrap;"><div class="row-actions">
                                                <c:choose>
                                                    <c:when test="${sessionScope.user.roleId == 1}">
                                                        <a class="chip primary" href="${pageContext.request.contextPath}/edit-user?id=${u.userId}"><span class="material-symbols-outlined">edit</span>Sửa</a>
                                                        <a class="chip ${u.status == 'ACTIVE' ? 'danger' : 'primary'}" href="javascript:void(0);" onclick="document.getElementById('form_status_${u.userId}').submit();"><span class="material-symbols-outlined">${u.status == 'ACTIVE' ? 'lock' : 'lock_open'}</span>${u.status == 'ACTIVE' ? 'Khóa' : 'Mở Khóa'}</a>
                                                        <form id="form_status_${u.userId}" action="${pageContext.request.contextPath}/user-list" method="post" style="display:none;"><input type="hidden" name="userId" value="${u.userId}"><input type="hidden" name="status" value="${u.status}"></form>
                                                        </c:when>
                                                        <c:otherwise>
                                                        <a class="chip primary" href="${pageContext.request.contextPath}/edit-user?id=${u.userId}"><span class="material-symbols-outlined">visibility</span>Xem</a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div></td>
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
