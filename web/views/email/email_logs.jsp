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
            
            <table>
                <thead>
                    <tr>
                        <th>Log ID</th>
                        <th>Recipient</th>
                        <th>Subject</th>
                        <th>Content Preview</th>
                        <th>Sent At</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${empty emailLogs}">
                        <tr>
                            <td colspan="6" style="text-align: center;">No email logs found.</td>
                        </tr>
                    </c:if>
                    <c:forEach var="log" items="${emailLogs}">
                        <tr>
                            <td>${log.logId}</td>
                            <td><strong>${log.recipient}</strong></td>
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
        </main>
    </div>

    <!-- Modal for showing full content -->
    <div id="emailModal" class="modal">
        <div class="modal-content">
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
