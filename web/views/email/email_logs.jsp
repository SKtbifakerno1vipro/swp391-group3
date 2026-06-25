<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Email Logs</title>
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
        }
        .badge-success {
            background-color: var(--primary-soft);
            color: var(--primary);
        }
        .badge-failed {
            background-color: var(--danger-soft);
            color: var(--danger);
        }
        .content-cell {
            max-width: 300px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            cursor: pointer;
        }
        .content-cell:hover {
            text-decoration: underline;
            color: var(--primary);
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
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 12px;
        }
        .inputs-grid input {
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
        .inputs-grid input:focus {
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
        /* Modal simple style */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.4);
            backdrop-filter: blur(4px);
        }
        .modal-content {
            background-color: var(--surface);
            margin: 10% auto;
            padding: 24px;
            border: 1px solid var(--line);
            width: 60%;
            border-radius: 22px;
            box-shadow: var(--shadow);
            position: relative;
        }
        .close-btn {
            position: absolute;
            right: 20px;
            top: 20px;
            font-size: 24px;
            font-weight: bold;
            cursor: pointer;
            color: var(--muted);
        }
        .close-btn:hover {
            color: var(--danger);
        }
    </style>
</head>
<body>
    <div class="dashboard-shell">
        <jsp:include page="/views/shared/sidebar.jsp">
            <jsp:param name="activeMenu" value="emailLogs"/>
        </jsp:include>
        <main class="main legacy-page">
            <h2>Email Activity Logs</h2>
            <p style="color: var(--muted); margin-bottom: 20px;">Review all outgoing system email communications (such as password recovery OTPs).</p>
            
            <form action="${pageContext.request.contextPath}/email/logs" method="GET" class="search-form-responsive">
                <div class="search-group">
                    <label class="search-label">Search Filters:</label>
                    <div class="inputs-grid">
                        <input type="text" name="searchEmail" value="${searchEmail}" placeholder="Recipient Email..." />
                        <input type="text" name="searchUsername" value="${searchUsername}" placeholder="Recipient Username..." />
                        <div style="display: flex; flex-direction: column; gap: 4px;">
                            <span style="font-size: 10px; font-weight: 800; color: var(--muted); text-transform: uppercase;">From Date/Time</span>
                            <input type="datetime-local" name="startDate" value="${startDate}" />
                        </div>
                        <div style="display: flex; flex-direction: column; gap: 4px;">
                            <span style="font-size: 10px; font-weight: 800; color: var(--muted); text-transform: uppercase;">To Date/Time</span>
                            <input type="datetime-local" name="endDate" value="${endDate}" />
                        </div>
                    </div>
                </div>

                <div class="actions-group">
                    <button type="submit" class="btn-search">Search</button>
                    <a href="${pageContext.request.contextPath}/email/logs" class="btn-clear">Clear Filter</a>
                </div>
            </form>

            <table>
                <thead>
                    <tr>
                        <th>Log ID</th>
                        <th>Recipient Email</th>
                        <th>Recipient Username</th>
                        <th>Subject</th>
                        <th>Content Preview</th>
                        <th>Sent At</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${empty emailLogs}">
                        <tr>
                            <td colspan="7" style="text-align: center;">No email logs found.</td>
                        </tr>
                    </c:if>
                    <c:forEach var="log" items="${emailLogs}">
                        <tr>
                            <td>${log.logId}</td>
                            <td><strong>${log.recipient}</strong></td>
                            <td><c:out value="${not empty log.userName ? log.userName : 'N/A'}"/></td>
                            <td>${log.subject}</td>
                            <td class="content-cell" onclick="showModal('${log.logId}')">
                                Click to view content
                                <span id="preview-${log.logId}" style="display:none;"><c:out value="${log.content}" escapeXml="false"/></span>
                            </td>
                            <td>
                                <fmt:formatDate value="${log.sentAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                            </td>
                            <td>
                                <span class="badge ${log.status == 'SUCCESS' ? 'badge-success' : 'badge-failed'}">${log.status}</span>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <c:set var="currentPage" value="${empty currentPage ? 1 : currentPage}" />
            <c:set var="totalPages" value="${empty totalPages ? 1 : totalPages}" />

            <c:if test="${totalPages > 1}">
                <div class="pagination-container" style="margin-top: 20px; text-align: center;">

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
                            <a href="${pageContext.request.contextPath}/email/logs?page=${currentPage - 1}&searchEmail=${searchEmail}&searchUsername=${searchUsername}&startDate=${startDate}&endDate=${endDate}">&lt;</a>
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
                                <a href="${pageContext.request.contextPath}/email/logs?page=${i}&searchEmail=${searchEmail}&searchUsername=${searchUsername}&startDate=${startDate}&endDate=${endDate}">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <%-- Next button (>) --%>
                    <c:choose>
                        <c:when test="${currentPage < totalPages}">
                            <a href="${pageContext.request.contextPath}/email/logs?page=${currentPage + 1}&searchEmail=${searchEmail}&searchUsername=${searchUsername}&startDate=${startDate}&endDate=${endDate}">&gt;</a>
                        </c:when>
                        <c:otherwise>
                            <span style="color: #999; border: 1px solid #ddd; padding: 5px 10px;">&gt;</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>
        </main>
    </div>

    <!-- Modal for showing full content -->
    <div id="emailModal" class="modal"> <!-- 100% man hinh -->
        <div class="modal-content">     <!-- chiem 1 phan man hinh -->
            <span class="close-btn" onclick="closeModal()">&times;</span>
            <h3 style="font-family: 'Literata', Georgia, serif; margin-top: 0;">Email Content Details</h3>
            <hr style="border: 0; border-top: 1px solid var(--line); margin: 15px 0;">
            <div id="modalBody" style="background: #fff; padding: 15px; border-radius: 12px; border: 1px solid var(--line); max-height: 400px; overflow-y: auto;">
            </div>
        </div>
    </div>

    <script>
        function showModal(logId) {
            var content = document.getElementById('preview-' + logId).innerHTML;
            document.getElementById('modalBody').innerHTML = content;
            document.getElementById('emailModal').style.display = "block";
        }
        function closeModal() {
            document.getElementById('emailModal').style.display = "none";
        }
        window.onclick = function(event) {
            var modal = document.getElementById('emailModal');
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }
    </script>
</body>
</html>
