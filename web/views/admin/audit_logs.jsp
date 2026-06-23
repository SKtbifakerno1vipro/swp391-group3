<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>System Audit Logs</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
    <style>
        .badge {
            display: inline-block;
            padding: 4px 10px;
            font-size: 11px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            border-radius: 12px;
            text-align: center;
        }
        .badge-create {
            background-color: #d1fae5;
            color: #065f46;
        }
        .badge-update {
            background-color: #dbeafe;
            color: #1e40af;
        }
        .badge-delete {
            background-color: #fee2e2;
            color: #991b1b;
        }
        .badge-other {
            background-color: #f3f4f6;
            color: #374151;
        }
        
        /* Search Form & Inputs Styling */
        .search-form-responsive {
            display: flex;
            flex-direction: column;
            gap: 16px;
            background: var(--surface) !important;
            border: 1px solid rgba(221, 213, 201, 0.85) !important;
            border-radius: 22px !important;
            box-shadow: var(--shadow) !important;
            padding: 22px !important;
            margin: 16px 0 22px !important;
        }
        .search-group {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .search-label {
            font-size: 11px;
            font-weight: 800;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .inputs-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 12px;
        }
        .inputs-grid input, .inputs-grid select {
            width: 100%;
            box-sizing: border-box;
            padding: 10px 14px !important;
            font-size: 14px !important;
            border: 1px solid var(--line) !important;
            border-radius: 12px !important;
            color: var(--text) !important;
            background-color: #fff !important;
            outline: none;
            transition: border-color 0.2s ease;
        }
        .inputs-grid input:focus, .inputs-grid select:focus {
            border-color: var(--primary) !important;
        }
        .actions-group {
            display: flex;
            gap: 10px;
            align-items: center;
            justify-content: flex-end;
        }
        .btn-search {
            padding: 10px 24px !important;
            background-color: var(--primary) !important;
            color: white !important;
            border: none !important;
            border-radius: 999px !important;
            font-weight: 800 !important;
            cursor: pointer !important;
            transition: all 0.2s ease;
        }
        .btn-search:hover {
            transform: translateY(-2px);
            filter: brightness(1.1);
        }
        .btn-clear {
            padding: 10px 24px !important;
            background-color: var(--surface-soft) !important;
            color: var(--text) !important;
            border: 1px solid var(--line) !important;
            border-radius: 999px !important;
            text-decoration: none !important;
            font-weight: 800 !important;
            transition: all 0.2s ease;
            display: inline-block;
        }
        .btn-clear:hover {
            background-color: var(--surface-strong) !important;
            transform: translateY(-2px);
        }
        
        .pagination-container a,
        .pagination-container span,
        .pagination-container strong {
            margin: 0 4px;
            padding: 5px 10px;
            text-decoration: none;
            border-radius: 6px;
        }
        .pagination-container a {
            border: 1px solid var(--line);
            color: var(--primary);
            font-weight: 800;
        }
        .pagination-container strong {
            border: 1px solid var(--primary);
            background-color: var(--primary);
            color: white;
        }
        
        .audit-desc-cell {
            font-family: inherit;
            color: var(--text);
            font-weight: 500;
        }
    </style>
</head>
<body>
    <div class="dashboard-shell">
        <jsp:include page="/views/shared/sidebar.jsp">
            <jsp:param name="activeMenu" value="auditLogs"/>
        </jsp:include>
        
        <main class="main legacy-page">
            <h2>System Audit Logs</h2>
            <p style="color: var(--muted); margin-bottom: 20px;">
                Review all system data modifications. This provides an audit trail of which user performed what modifications, on what entities, and when.
            </p>
            
            <form action="${pageContext.request.contextPath}/admin/audit-logs" method="GET" class="search-form-responsive">
                <div class="search-group">
                    <label class="search-label">Audit Log Search Filters:</label>
                    <div class="inputs-grid">
                        
                        <div>
                            <span style="font-size: 10px; font-weight: 800; color: var(--muted); text-transform: uppercase; display: block; margin-bottom: 4px;">User (Name/Username)</span>
                            <input type="text" name="searchUser" value="<c:out value='${searchUser}'/>" placeholder="Search user..." />
                        </div>
                        
                        <div>
                            <span style="font-size: 10px; font-weight: 800; color: var(--muted); text-transform: uppercase; display: block; margin-bottom: 4px;">Action Type</span>
                            <select name="actionType">
                                <option value="">-- All Actions --</option>
                                <option value="CREATE" ${actionType == 'CREATE' ? 'selected' : ''}>CREATE</option>
                                <option value="UPDATE" ${actionType == 'UPDATE' ? 'selected' : ''}>UPDATE</option>
                                <option value="DELETE" ${actionType == 'DELETE' ? 'selected' : ''}>DELETE</option>
                            </select>
                        </div>
                        
                        <div>
                            <span style="font-size: 10px; font-weight: 800; color: var(--muted); text-transform: uppercase; display: block; margin-bottom: 4px;">Affected Object</span>
                            <select name="affectedObject">
                                <option value="">-- All Objects --</option>
                                <c:forEach var="obj" items="${affectedObjects}">
                                    <option value="${obj}" ${affectedObject == obj ? 'selected' : ''}>${obj}</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div>
                            <span style="font-size: 10px; font-weight: 800; color: var(--muted); text-transform: uppercase; display: block; margin-bottom: 4px;">Start Date</span>
                            <input type="date" name="startDate" value="${startDate}" />
                        </div>
                        
                        <div>
                            <span style="font-size: 10px; font-weight: 800; color: var(--muted); text-transform: uppercase; display: block; margin-bottom: 4px;">End Date</span>
                            <input type="date" name="endDate" value="${endDate}" />
                        </div>
                    </div>
                </div>

                <div class="actions-group">
                    <button type="submit" class="btn-search">Search Logs</button>
                    <a href="${pageContext.request.contextPath}/admin/audit-logs" class="btn-clear">Reset Filters</a>
                </div>
            </form>

            <table>
                <thead>
                    <tr>
                        <th style="width: 80px;">Log ID</th>
                        <th style="width: 180px;">User</th>
                        <th style="width: 120px;">Action Type</th>
                        <th style="width: 150px;">Affected Object</th>
                        <th>Description / Details</th>
                        <th style="width: 180px;">Timestamp</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${empty auditLogs}">
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 24px;">No system audit logs found.</td>
                        </tr>
                    </c:if>
                    <c:forEach var="log" items="${auditLogs}">
                        <tr>
                            <td>${log.logId}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty log.userName}">
                                        <strong><c:out value="${log.userFullName}"/></strong><br/>
                                        <small style="color: var(--muted);">@<c:out value="${log.userName}"/></small>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: var(--muted);">System / Guest (ID: ${log.userId})</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${log.actionType == 'CREATE'}">
                                        <span class="badge badge-create">CREATE</span>
                                    </c:when>
                                    <c:when test="${log.actionType == 'UPDATE'}">
                                        <span class="badge badge-update">UPDATE</span>
                                    </c:when>
                                    <c:when test="${log.actionType == 'DELETE'}">
                                        <span class="badge badge-delete">DELETE</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-other">${log.actionType}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <strong><c:out value="${log.affectedObject}"/></strong>
                            </td>
                            <td class="audit-desc-cell">
                                <c:out value="${log.description}"/>
                            </td>
                            <td style="font-size: 13px;">
                                ${log.getFormattedCreatedAt()}
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <c:set var="currentPage" value="${empty currentPage ? 1 : currentPage}" />
            <c:set var="totalPages" value="${empty totalPages ? 1 : totalPages}" />

            <c:if test="${totalPages > 1}">
                <div class="pagination-container" style="margin-top: 25px; text-align: center;">

                    <%-- Calculate page range for buttons --%>
                    <c:set var="startPage" value="${currentPage - 2}" />
                    <c:if test="${startPage < 1}">
                        <c:set var="startPage" value="1" />
                    </c:if>
                    <c:set var="endPage" value="${startPage + 4}" />
                    <c:if test="${endPage > totalPages}">
                        <c:set var="endPage" value="${totalPages}" />
                        <c:set var="startPage" value="${endPage - 4 < 1 ? 1 : endPage - 4}" />
                    </c:if>

                    <%-- Back button (<) --%>
                    <c:choose>
                        <c:when test="${currentPage > 1}">
                            <a href="${pageContext.request.contextPath}/admin/audit-logs?page=${currentPage - 1}&actionType=${actionType}&affectedObject=${affectedObject}&searchUser=${searchUser}&startDate=${startDate}&endDate=${endDate}">&lt;</a>
                        </c:when>
                        <c:otherwise>
                            <span style="color: #999; border: 1px solid #ddd; padding: 5px 10px;">&lt;</span>
                        </c:otherwise>
                    </c:choose>

                    <%-- Loop to show page numbers --%>
                    <c:forEach var="i" begin="${startPage}" end="${endPage}">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <strong>${i}</strong>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/admin/audit-logs?page=${i}&actionType=${actionType}&affectedObject=${affectedObject}&searchUser=${searchUser}&startDate=${startDate}&endDate=${endDate}">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <%-- Next button (>) --%>
                    <c:choose>
                        <c:when test="${currentPage < totalPages}">
                            <a href="${pageContext.request.contextPath}/admin/audit-logs?page=${currentPage + 1}&actionType=${actionType}&affectedObject=${affectedObject}&searchUser=${searchUser}&startDate=${startDate}&endDate=${endDate}">&gt;</a>
                        </c:when>
                        <c:otherwise>
                            <span style="color: #999; border: 1px solid #ddd; padding: 5px 10px;">&gt;</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>
        </main>
    </div>
</body>
</html>
