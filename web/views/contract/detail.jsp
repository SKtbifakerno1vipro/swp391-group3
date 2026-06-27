<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Contract Detail - Dashboard</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
        <link href="https://fonts.googleapis.com/css2?family=Literata:ital,opsz,wght@0,7..72,200..900;1,7..72,200..900&family=Nunito+Sans:ital,opsz,wght@0,6..12,200..1000;1,6..12,200..1000&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0" rel="stylesheet">
        <style>
            .layout-container {
                display: grid;
                grid-template-columns: 1fr 380px;
                gap: 20px;
                align-items: start;
            }

            .content-panel, .right-panel {
                background: var(--surface);
                border: 1px solid var(--line);
                border-radius: 22px;
                box-shadow: var(--shadow);
                padding: 20px;
            }

            .action-section {
                margin-bottom: 20px;
                padding-bottom: 20px;
                border-bottom: 1px solid var(--line);
            }

            .note-textarea {
                width: 100%;
                min-height: 120px;
                padding: 10px;
                border: 1px solid var(--line);
                border-radius: 12px;
                font-family: inherit;
                font-size: 14px;
                resize: vertical;
                box-sizing: border-box;
                margin-bottom: 10px;
            }

            .note-textarea:focus {
                outline: none;
                border-color: var(--primary);
            }

            .history-section {
                max-height: 500px;
                overflow-y: auto;
                padding-right: 5px;
            }

            .history-section::-webkit-scrollbar {
                width: 6px;
            }
            .history-section::-webkit-scrollbar-thumb {
                background: rgba(0,0,0,0.1);
                border-radius: 3px;
            }

            .note-block {
                border-left: 3px solid var(--primary);
                padding: 8px 12px;
                margin-bottom: 5px;
                background: var(--surface-soft);
                white-space: pre-wrap;
                word-wrap: break-word;
                font-size: 0.9em;
                border-radius: 0 8px 8px 0;
            }
            
            .history-item {
                border-bottom: 1px solid var(--line);
                padding-bottom: 15px;
                margin-bottom: 15px;
            }
            .history-item:last-child {
                border-bottom: none;
                margin-bottom: 0;
                padding-bottom: 0;
            }

            .action-btn-group {
                display: flex;
                flex-direction: column;
                gap: 10px;
                margin-top: 15px;
            }
            .action-btn-group form {
                margin: 0;
                padding: 0;
                background: none;
                border: none;
                box-shadow: none;
            }
            .action-btn-group .btn-full {
                width: 100%;
                display: block;
                text-align: center;
                box-sizing: border-box;
            }
            .btn-tertiary {
                background: var(--tertiary) !important;
            }
            .btn-secondary {
                background: var(--muted) !important;
            }
            
            @media (max-width: 900px) {
                .layout-container {
                    grid-template-columns: 1fr;
                }
            }

            /* Override app-layout.css for raw contract content */
            .legacy-page .raw-content table {
                background: #fff;
                box-shadow: none;
                border-radius: 0;
                border: none;
                margin: 10px 0;
            }
            .legacy-page .raw-content th,
            .legacy-page .raw-content thead td,
            .legacy-page .raw-content td {
                background: #fff;
                color: inherit;
                font-size: inherit;
                text-transform: none;
                letter-spacing: normal;
                font-weight: normal;
                border: none;
                padding: 8px;
            }
            .legacy-page .raw-content th {
                font-weight: bold;
            }
            .legacy-page .raw-content table[border="1"],
            .legacy-page .raw-content table[border="1"] th,
            .legacy-page .raw-content table[border="1"] td {
                border: 1px solid #000;
            }
        </style>
    </head>

    <body>
        <div class="dashboard-shell">
            <jsp:include page="../shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="contracts" />
            </jsp:include>
            
            <main class="main legacy-page">
                <h2>No Contract: ${contract.contractNumber}</h2>

                <div class="layout-container">
                    <!-- COT 1: CONTENT (Left) -->
                    <div class="content-panel">
                        <c:if test="${errorSig != null}">
                            <div style="color: var(--danger); background: var(--danger-soft); padding: 10px; border-radius: 8px; margin-bottom: 15px;">${errorSig}</div>
                        </c:if>
                        
                        <h3 style="margin-top: 0;">Content Details</h3>
                        <div style="background: var(--bg); padding: 15px; border: 1px solid var(--line); margin-bottom: 15px; border-radius: 12px;">
                            <p style="margin: 0 0 5px 0;"><strong>Customer:</strong> ${contract.customerName}</p>
                            <p style="margin: 0;"><strong>Storage type:</strong> ${contract.storageType}</p>
                        </div>
                        
                        <div class="raw-content" style="border: 1px solid var(--line); padding: 20px; background: #fff; min-height: 500px; overflow-x: auto; border-radius: 12px;">
                            ${contract.contractContent}
                        </div>
                    </div>

                    <!-- COT 2: ACTION + HISTORY (Right) -->
                    <div class="right-panel">
                        
                        <!-- ACTION BLOCK -->
                        <div class="action-section">
                            <h3 style="margin-top: 0;">Action For Contract</h3>
                            <p><strong>Status:</strong> <span style="color: var(--danger); font-weight: bold;">${contract.contractStatus}</span></p>
                            
                            <c:choose>
                                <c:when test="${isGuest}">
                                    <p style="color: var(--muted); font-size: 0.9em; line-height: 1.4; margin-top: 10px;">You need to login for request edit</p>
                                    <div class="action-btn-group">
                                        <a href="login?redirect=contract-detail?id=${contract.contractId}" class="btn-full"><button type="button" style="width: 100%;">Đăng Nhập</button></a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="action-btn-group">
                                        <c:choose>
                                            <c:when test="${canRequestEdit}">
                                                <!-- Manager (Role 2) -->
                                                <c:if test="${sessionScope.user.roleId == 2}">
                                                    <form method="POST" action="contract-detail">
                                                        <input type="hidden" name="action" value="approve" />
                                                        <input type="hidden" name="contractId" value="${contract.contractId}" />
                                                        <button type="submit" class="btn-full" style="background: var(--primary);">Approve</button>
                                                    </form>
                                                </c:if>

                                                <!-- Admin Officer (Role 5) -->
                                                <c:if test="${sessionScope.user.roleId == 5}">
                                                    <a href="contract-save?id=${contract.contractId}" class="btn-full" style="text-decoration:none;">
                                                        <button type="button" style="width: 100%;">Edit Contract</button>
                                                    </a>
                                                    <form method="POST" action="contract-detail">
                                                        <input type="hidden" name="action" value="send_to_manager" />
                                                        <input type="hidden" name="contractId" value="${contract.contractId}" />
                                                        <button type="submit" class="btn-full btn-secondary">Send to Manager</button>
                                                    </form>
                                                </c:if>
                                            </c:when>

                                            <c:when test="${canCustomerCheck}">
                                                <!-- Khach hang (Role 3) -->
                                                <c:if test="${sessionScope.user.roleId == 3}">
                                                    <form method="POST" action="contract-detail">
                                                        <input type="hidden" name="action" value="customer_approve" />
                                                        <input type="hidden" name="contractId" value="${contract.contractId}" />
                                                        <button type="submit" class="btn-full" style="background: var(--primary);">Approve</button>
                                                    </form>
                                                </c:if>
                                            </c:when>

                                            <c:when test="${isApproved}">
                                                <p style="color: var(--primary); text-align: center; font-weight: bold; margin: 10px 0;">Contract Approved</p>
                                                <c:if test="${sessionScope.user.roleId == 2 || sessionScope.user.roleId == 3}">
                                                    <c:if test="${not signed}">
                                                        <form action="Signature" method="get">
                                                            <input type="hidden" name="contractId" value="${contract.contractId}">
                                                            <input type="hidden" name="signerId" value="${sessionScope.user.userId}">
                                                            <button type="submit" class="btn-full">Sign Contract</button>
                                                        </form>
                                                    </c:if>
                                                </c:if>
                                            </c:when>
                                        </c:choose>

                                        <a href="export-pdf?id=${contract.contractId}" class="btn-full" style="text-decoration:none;">
                                            <button type="button" class="btn-secondary" style="width: 100%;">Xuất PDF</button>
                                        </a>
                                        <div style="text-align: center; margin-top: 5px;">
                                            <a href="contract-list" style="color: var(--primary); font-size: 0.9em; font-weight: 600;">Back to contract list</a>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- TYPE NOTE BLOCK -->
                        <c:if test="${not isGuest && (( sessionScope.user.roleId == 2) || ( sessionScope.user.roleId == 3)) 
                                      && (contract.contractStatus== 'PENDING_REVIEW' ||contract.contractStatus== 'CUSTOMER_CHECK' ) }">
                            <div class="type-note-section" style="margin-bottom: 20px; border-bottom: 1px solid var(--line); padding-bottom: 20px;">
                                <h3 style="margin-top:0;">Type note</h3>
                                <form method="POST" action="contract-detail" id="requestEditForm" style="background: none; border: none; box-shadow: none; padding: 0; margin: 0;">
                                    <input type="hidden" name="action" value="request_edit" />
                                    <input type="hidden" name="contractId" value="${contract.contractId}" />
                                    <textarea name="revision_note" class="note-textarea" placeholder="Ex:&#10;price: change to 10000&#10;name: change to vtp neee" required></textarea>
                                    <button type="submit" class="btn-tertiary" style="width: 100%;">Send note</button>
                                </form>
                            </div>
                        </c:if>

                        <!-- HISTORY BLOCK -->
                        <div class="history-section">
                            <h3 style="margin-top:0;">History request edit</h3>
                            <c:choose>
                                <c:when test="${not empty historyList}">
                                    <c:forEach var="h" items="${historyList}">
                                        <div class="history-item">
                                            <p style="margin: 0 0 3px 0; color: var(--muted); font-size: 0.85em;">${h.getCreateTimeString()}</p>
                                            <p style="margin: 0 0 3px 0; font-size: 0.9em;"><strong>Status:</strong> ${h.toStatus}</p>
                                            <p style="margin: 0 0 5px 0; font-size: 0.9em;"><strong>By:</strong> ${h.changedByName}</p>
                                            <c:if test="${sessionScope.user.roleId == 5}">
                                                <p style="margin: 0 0 5px 0; color: var(--danger); font-size: 0.9em;"><strong>Note:</strong> ${h.note}</p>
                                            </c:if>
                                            <c:if test="${not empty h.revisionItems}">
                                                <c:forEach var="item" items="${h.revisionItems}">
                                                    <div class="note-block">${item.revisionDetail}</div>
                                                </c:forEach>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <p style="color: var(--muted); font-style: italic; font-size: 0.9em;">Not have any history</p>
                                </c:otherwise>
                            </c:choose>
                        </div>

                    </div>
                </div>
            </main>
        </div>
    </body>

</html>