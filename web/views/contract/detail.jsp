<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
            .sidebar, .content, .history {
                background: #fff;
                border: 1px solid #ddd;
                padding: 20px;
                border-radius: 5px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            }
            .revision-box {
                border: 1px solid #ccc;
                padding: 10px;
                margin-bottom: 5px;
                background: #fafafa;
                border-radius: 3px;
            }
            .modal-overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.5);
                z-index: 999;
            }
            .modal-content {
                display: none;
                position: fixed;
                top: 10%;
                left: 25%;
                width: 50%;
                background: #fff;
                padding: 20px;
                border: 2px solid #333;
                z-index: 1000;
                box-shadow: 0 4px 8px rgba(0,0,0,0.2);
                border-radius: 5px;
                max-height: 80vh;
                overflow-y: auto;
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
            .btn-add {
                background: #17a2b8;
                padding: 5px 10px;
                margin-top: 10px;
                width: auto;
            }
        </style>
    </head>
    <body>
        <h2>No Contract: ${contract.contractNumber}</h2>

        <div class="layout-container">
            <!-- CỘT 1: SIDEBAR (Menu & Actions) -->
            <div class="sidebar">
                <h3>Action For Contract</h3>
                <p><strong>Status</strong> <span style="color: red; font-weight: bold;">${contract.contractStatus}</span></p>
                <hr>

                <c:choose>
                    <%-- 1. Status: DRAFT / PENDING_REVIEW --%>
                    <c:when test="${canRequestEdit}">

                        <!-- Manager (Role 2) -->
                        <c:if test="${sessionScope.user.roleId == 2}">
                            <button type="button" onclick="showFeedbackModal()" class="btn btn-orange">Request edit</button>
                            <form method="POST" action="contract-detail" style="margin:0;">
                                <input type="hidden" name="action" value="approve"/>
                                <input type="hidden" name="contractId" value="${contract.contractId}"/>
                                <button type="submit" class="btn btn-green">Approve</button>
                            </form>
                        </c:if>

                        <!-- Admin Officer (Role 5) -->
                        <c:if test="${sessionScope.user.roleId == 5}">
                            <a href="contract-save?id=${contract.contractId}" class="btn btn-blue">Edit Contract</a>
                            <form method="POST" action="contract-detail" style="margin:0;">
                                <input type="hidden" name="action" value="send_to_manager"/>
                                <input type="hidden" name="contractId" value="${contract.contractId}"/>
                                <button type="submit" class="btn btn-gray">Send to Manager</button>
                            </form>
                        </c:if>
                    </c:when>

                    <%-- 2. TRẠNG THÁI: CUSTOMER_CHECK --%>
                    <c:when test="${canCustomerCheck}">
                        <!-- Khách hàng (Role 3) -->
                        <c:if test="${sessionScope.user.roleId == 3}">
                            <button type="button" onclick="showFeedbackModal()" class="btn btn-orange">Edit request</button>
                            <form method="POST" action="contract-detail" style="margin:0;">
                                <input type="hidden" name="action" value="customer_approve"/>
                                <input type="hidden" name="contractId" value="${contract.contractId}"/>
                                <button type="submit" class="btn btn-green">Approve</button>
                            </form>

                        </c:if>
                    </c:when>

                    <%-- 3. TRẠNG THÁI: APPROVED --%>
                    <c:when test="${isApproved}">
                        <p style="color: green; text-align: center; font-weight: bold;">Contract Approved</p>
                        <c:if test="${sessionScope.user.roleId == 2 || sessionScope.user.roleId == 3}">
                            <c:if test="${not signed}">
                                <form action="Signature" method="get">
                                    <input type="hidden" name="contractId" value="${contract.contractId}">
                                    <input type="hidden" name="signerId" value="${sessionScope.user.userId}">
                                    <input class="btn btn-blue" type="submit" value="Sign Contract" />
                                </form>
                            </c:if>
                           
                        </c:if>
                    </c:when>
                    <%-- 4. TRẠNG THÁI: SIGNED --%>
                </c:choose>
                <hr>
                <a href="export-pdf?id=${contract.contractId}" class="btn btn-blue" style="background-color: #6c757d; margin-top: 10px;">
                    📄 Xuất PDF
                </a>
                <a href="contract-list" style="color: #007bff; text-decoration: none;">⬅ Back to contract list</a>
            </div>

            <!-- CỘT 2: CONTENT -->
            <div class="content">
                <h3>Content Details</h3>
                <div style="background: #fdfdfd; padding: 15px; border: 1px solid #eee; margin-bottom: 15px; border-radius: 4px;">
                    <p style="margin: 0 0 5px 0;"><strong>Customer</strong> ${contract.customerName}</p>
                    <p style="margin: 0;"><strong>Storage type:</strong> ${contract.storageType}</p>
                </div>
                <div style="border: 1px solid #ddd; padding: 20px; background: #fff; min-height: 500px; overflow-x: auto;">
                    ${contract.contractContent}
                </div>
            </div>

            <!-- CỘT 3: HISTORY -->
            <div class="history">
                <h3>Contract history</h3>
                <c:choose>
                    <c:when test="${not empty historyList}">
                        <div style="max-height: 600px; overflow-y: auto;">
                            <c:forEach var="h" items="${historyList}">
                                <div style="border-bottom: 1px solid #ddd; padding-bottom: 15px; margin-bottom: 15px;">
                                    <p style="margin: 0 0 5px 0; color: #666; font-size: 0.9em;">🕒 ${h.createdAt}</p>
                                    <p style="margin: 0 0 5px 0;"><strong>Status:</strong> ${h.toStatus}</p>
                                    <p style="margin: 0 0 10px 0;"><strong>By:</strong> ${h.changedByName}</p>
                                    <!--Only admin officier can see NOTE-->
                                    <c:if test="${sessionScope.user.roleId== 5}">
                                        <p style="margin: 0 0 10px 0; color: red"><strong>Note:</strong> ${h.note}</p>
                                    </c:if>
                                    <c:if test="${not empty h.revisionItems}">
                                        <button class="btn btn-blue" style="padding: 5px 10px; font-size: 0.85em; width: auto;" onclick="viewHistoryDetail(${h.historyId})">View detail</button>
                                        <div id="history-data-${h.historyId}" style="display:none;">
                                            <c:forEach var="item" items="${h.revisionItems}">
                                                <div style="border-left: 3px solid #007bff; padding: 8px; margin-bottom: 5px; background: #f8f9fa;">
                                                    <strong>Location:</strong> ${item.revisionType} <br> <strong>Change:</strong> ${item.revisionDetail}
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise><p style="color: #888;">Not have any history</p></c:otherwise>
                </c:choose>

            </div>
        </div>

        <!--Popup-->
        <!--background-->
        <div id="modalOverlay" class="modal-overlay"></div>
        <!--content revision-->
        <div id="feedbackModal" class="modal-content">
            <h3>Request edit</h3>
            <form method="POST" action="contract-detail" id="feedbackForm">
                <input type="hidden" name="action" value="request_edit"/>
                <input type="hidden" name="contractId" value="${contract.contractId}"/>
                <div id="revisionContainer">
                    <div class="revision-box">
                        <input type="text" name="revision_type[]" placeholder="Location (Ex: Name...)" required style="width:40%; padding: 8px;">
                        <input type="text" name="revision_detail[]" placeholder="Change information" required style="width:50%; padding: 8px;">
                    </div>
                </div>
                <button type="button" onclick="addRevisionBox()" class="btn btn-add">+ Add more</button>
                <div style="margin-top: 20px; text-align: right;">
                    <button type="button" onclick="hideModals()" class="btn btn-red" style="width:auto;">Cancel</button>
                    <button type="submit" class="btn btn-green" style="width:auto;">Send feedback</button>
                </div>
            </form>
        </div>

        <div id="viewHistoryModal" class="modal-content" style="width: 40%; left: 30%;">
            <h3>Detail of edit request</h3>
            <div id="viewHistoryBody" style="margin-bottom: 20px;"></div>
            <button type="button" onclick="hideModals()" class="btn btn-gray" style="width: auto;">Cancel</button>
        </div>

        <script>
            function hideModals() {
                document.getElementById('modalOverlay').style.display = 'none';
                document.getElementById('feedbackModal').style.display = 'none';
                document.getElementById('viewHistoryModal').style.display = 'none';
            }
            function showFeedbackModal() {
                document.getElementById('modalOverlay').style.display = 'block';
                document.getElementById('feedbackModal').style.display = 'block';
            }
            function addRevisionBox() {
                var container = document.getElementById('revisionContainer');
                var div = document.createElement('div');
                div.className = 'revision-box';
                div.innerHTML = '<input type="text" name="revision_type[]" placeholder="Location" required style="width:40%; padding: 8px; margin-top: 5px;"> ' +
                        '<input type="text" name="revision_detail[]" placeholder="Change" required style="width:50%; padding: 8px;">';
                container.appendChild(div);
            }
            function viewHistoryDetail(historyId) {
                document.getElementById('viewHistoryBody').innerHTML = document.getElementById('history-data-' + historyId).innerHTML;
                document.getElementById('modalOverlay').style.display = 'block';
                document.getElementById('viewHistoryModal').style.display = 'block';
            }
        </script>
    </body>
</html>