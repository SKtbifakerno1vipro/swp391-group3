<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Contract Detail - Dashboard</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f4f7f6;
            }

            h2 {
                padding-left: 20px;
                color: #333;
            }

            .layout-container {
                display: grid;
                grid-template-columns: 250px 1fr 350px;
                gap: 20px;
                padding: 20px;
            }

            .sidebar,
            .content,
            .history {
                background: #fff;
                border: 1px solid #ddd;
                padding: 20px;
                border-radius: 5px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            }

            .right-panel {
                background: #fff;
                border: 1px solid #ddd;
                border-radius: 5px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
                padding: 20px;
                display: flex;
                flex-direction: column;
            }

            .type-note-section {
                margin-bottom: 15px;
            }

            .note-textarea {
                width: 100%;
                min-height: 150px;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 4px;
                font-family: Arial, sans-serif;
                font-size: 14px;
                resize: vertical;
                box-sizing: border-box;
            }

            .note-textarea:focus {
                outline: none;
                border-color: #007bff;
                box-shadow: 0 0 0 2px rgba(0,123,255,0.15);
            }

            .btn {
                padding: 10px 15px;
                border: none;
                cursor: pointer;
                border-radius: 3px;
                color: white;
                text-decoration: none;
                display: inline-block;
                text-align: center;
                width: 100%;
                box-sizing: border-box;
                margin-bottom: 10px;
                font-weight: bold;
            }

            .btn-orange {
                background: #fd7e14;
            }

            .btn-green {
                background: #28a745;
            }

            .btn-blue {
                background: #007bff;
            }

            .btn-gray {
                background: #6c757d;
            }

            .btn-red {
                background: #dc3545;
                width: auto;
            }

            .btn-submit-note {
                background: #fd7e14;
                margin-top: 10px;
            }

            .history-section {
                flex: 1;
                overflow-y: auto;
                max-height: 400px;
            }

            .note-block {
                border-left: 3px solid #007bff;
                padding: 8px;
                margin-bottom: 5px;
                background: #f8f9fa;
                white-space: pre-wrap;
                word-wrap: break-word;
                font-size: 0.9em;
            }
        </style>
    </head>

    <body>
        <h2>No Contract: ${contract.contractNumber}</h2>

        <div class="layout-container">
            <!-- COT 1: SIDEBAR -->
            <div class="sidebar">
                <c:choose>
                    <c:when test="${isGuest}">
                        <h3>Action For Contract</h3>
                        <p><strong>Status</strong> <span
                                style="color: red; font-weight: bold;">${contract.contractStatus}</span></p>
                        <hr>
                        <p style="color: #666; font-size: 0.9em; line-height: 1.4;">You need to login for request edit</p>
                        <a href="login?redirect=contract-detail?id=${contract.contractId}" class="btn btn-blue" style="margin-top: 10px;">Đăng Nhập</a>
                    </c:when>
                    <c:otherwise>
                        <h3>Action For Contract</h3>
                        <p><strong>Status</strong> <span
                                style="color: red; font-weight: bold;">${contract.contractStatus}</span></p>
                        <hr>

                        <c:choose>
                            <%-- 1. Status: DRAFT / PENDING_REVIEW --%>
                            <c:when test="${canRequestEdit}">

                                <!-- Manager (Role 2) -->
                                <c:if test="${sessionScope.user.roleId == 2}">
                                    <form method="POST" action="contract-detail" style="margin:0;">
                                        <input type="hidden" name="action" value="approve" />
                                        <input type="hidden" name="contractId" value="${contract.contractId}" />
                                        <button type="submit" class="btn btn-green">Approve</button>
                                    </form>
                                </c:if>

                                <!-- Admin Officer (Role 5) -->
                                <c:if test="${sessionScope.user.roleId == 5}">
                                    <a href="contract-save?id=${contract.contractId}" class="btn btn-blue">Edit
                                        Contract</a>
                                    <form method="POST" action="contract-detail" style="margin:0;">
                                        <input type="hidden" name="action" value="send_to_manager" />
                                        <input type="hidden" name="contractId" value="${contract.contractId}" />
                                        <button type="submit" class="btn btn-gray">Send to Manager</button>
                                    </form>
                                </c:if>
                            </c:when>

                            <%-- 2. TRANG THAI: CUSTOMER_CHECK --%>
                            <c:when test="${canCustomerCheck}">
                                <!-- Khach hang (Role 3) -->
                                <c:if test="${sessionScope.user.roleId == 3}">
                                    <form method="POST" action="contract-detail" style="margin:0;">
                                        <input type="hidden" name="action" value="customer_approve" />
                                        <input type="hidden" name="contractId" value="${contract.contractId}" />
                                        <button type="submit" class="btn btn-green">Approve</button>
                                    </form>

                                </c:if>
                            </c:when>

                            <%-- 3. TRANG THAI: APPROVED --%>
                            <c:when test="${isApproved}">
                                <p style="color: green; text-align: center; font-weight: bold;">Contract
                                    Approved</p>
                                    <c:if test="${sessionScope.user.roleId == 2 || sessionScope.user.roleId == 3}">
                                        <c:if test="${not signed}">
                                        <form action="Signature" method="get">
                                            <input type="hidden" name="contractId"
                                                   value="${contract.contractId}">
                                            <input type="hidden" name="signerId"
                                                   value="${sessionScope.user.userId}">
                                            <input class="btn btn-blue" type="submit" value="Sign Contract" />
                                            <hr>
                                        </form>
                                    </c:if>
                                </c:if>
                            </c:when>
                            <%-- 4. TRANG THAI: SIGNED --%>
                        </c:choose>

                        <a href="export-pdf?id=${contract.contractId}" class="btn btn-blue"
                           style="background-color: #6c757d; margin-top: 10px;">
                            Xuất PDF
                        </a>
                        <a href="contract-list" style="color: #007bff; text-decoration: none;">Back to contract list</a>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- COT 2: CONTENT -->
            <div class="content">
                <c:if test="${errorSig != null}">
                    <p style="color: red">${errorSig}</p>
                </c:if>
                <h3>Content Details</h3>
                <div
                    style="background: #fdfdfd; padding: 15px; border: 1px solid #eee; margin-bottom: 15px; border-radius: 4px;">
                    <p style="margin: 0 0 5px 0;"><strong>Customer</strong> ${contract.customerName}</p>
                    <p style="margin: 0;"><strong>Storage type:</strong> ${contract.storageType}</p>
                </div>
                <div
                    style="border: 1px solid #ddd; padding: 20px; background: #fff; min-height: 500px; overflow-x: auto;">
                    ${contract.contractContent}
                </div>
            </div>

            <!-- COT 3: TYPE NOTE + HISTORY -->
            <div class="right-panel">
                <c:if test="${not isGuest && (( sessionScope.user.roleId == 2) || ( sessionScope.user.roleId == 3)) 
                              && (contract.contractStatus== 'PENDING_REVIEW' ||contract.contractStatus== 'CUSTOMER_CHECK' ) }">
                      <div class="type-note-section">
                          <h3 style="margin-top:0;">Type note</h3>
                          <form method="POST" action="contract-detail" id="requestEditForm">
                              <input type="hidden" name="action" value="request_edit" />
                              <input type="hidden" name="contractId" value="${contract.contractId}" />
                              <textarea name="revision_note" class="note-textarea" placeholder="Ex:&#10;price: change to 10000&#10;name: change to vtp neee" required></textarea>
                              <button type="submit" class="btn btn-submit-note">Send note</button>
                          </form>
                      </div>
                      <hr style="margin:10px 0;">
                </c:if>

                <div class="history-section">
                    <h3 style="margin-top:0;">History request edit</h3>
                    <c:choose>
                        <c:when test="${not empty historyList}">
                            <c:forEach var="h" items="${historyList}">
                                <div style="border-bottom: 1px solid #ddd; padding-bottom: 10px; margin-bottom: 10px;">
                                    <p style="margin: 0 0 3px 0; color: #666; font-size: 0.85em;">${h.getCreateTimeString()}</p>
                                    <p style="margin: 0 0 3px 0; font-size: 0.9em;"><strong>Status:</strong> ${h.toStatus}</p>
                                    <p style="margin: 0 0 5px 0; font-size: 0.9em;"><strong>By:</strong> ${h.changedByName}</p>
                                    <c:if test="${sessionScope.user.roleId == 5}">
                                        <p style="margin: 0 0 5px 0; color: red; font-size: 0.9em;"><strong>Note:</strong> ${h.note}</p>
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
                            <p style="color: #888;">Not have any history</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

    </body>

</html>