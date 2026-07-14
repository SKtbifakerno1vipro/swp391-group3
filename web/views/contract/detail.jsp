<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Contract Detail - Dashboard</title>
        <style>
<<<<<<< HEAD
            body {
                font-family: Arial, sans-serif;
=======
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
                padding-right: 5px;
            }

            .history-list {
                max-height: 400px;
                overflow-y: auto;
                padding-right: 5px;
                margin-bottom: 15px;
            }

            .history-list::-webkit-scrollbar {
                width: 6px;
            }
            .history-list::-webkit-scrollbar-thumb {
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
>>>>>>> a5d933bcdd2d38a00633fea144fd64b641bd5450
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
        <h2>Quản lý Hợp đồng: ${contract.contractNumber}</h2>

        <div class="layout-container">
            <!-- CỘT 1: SIDEBAR (Menu & Actions) -->
            <div class="sidebar">
                <h3>Thao tác Hợp đồng</h3>
                <p><strong>Trạng thái:</strong> <span style="color: red; font-weight: bold;">${contract.contractStatus}</span></p>
                <hr>

                <c:choose>
                    <%-- 1. TRẠNG THÁI: DRAFT / PENDING_REVIEW --%>
                    <c:when test="${contract.contractStatus == 'DRAFT' or contract.contractStatus == 'PENDING_REVIEW'}">
                        <!-- Manager (Role 2) -->
                        <c:if test="${sessionScope.user.roleId == 2}">
                            <button type="button" onclick="showFeedbackModal()" class="btn btn-orange">Yêu cầu sửa đổi</button>
                            <form method="POST" action="contract-detail" style="margin:0;">
                                <input type="hidden" name="action" value="approve"/>
                                <input type="hidden" name="contractId" value="${contract.contractId}"/>
                                <button type="submit" class="btn btn-green">Phê duyệt (Approve)</button>
                            </form>
                        </c:if>

<<<<<<< HEAD
                        <!-- Admin Officer (Role 5) -->
                        <c:if test="${sessionScope.user.roleId == 5}">
                            <a href="contract-save?id=${contract.contractId}" class="btn btn-blue">Chỉnh sửa HTML</a>
                            <form method="POST" action="contract-detail" style="margin:0;">
                                <input type="hidden" name="action" value="send_to_manager"/>
                                <input type="hidden" name="contractId" value="${contract.contractId}"/>
                                <button type="submit" class="btn btn-gray">Gửi lại cho Manager</button>
                            </form>
=======
                        <h3 style="margin-top: 0;">Nội dung Hợp đồng</h3>
                        <div style="background: var(--bg); padding: 15px; border: 1px solid var(--line); margin-bottom: 15px; border-radius: 12px;">
                            <p style="margin: 0 0 5px 0;"><strong>Khách hàng</strong> ${contract.customerName}</p>
                            <p style="margin: 0;"><strong>Loại lưu trữ</strong> ${contract.storageType}</p>
                        </div>

                        <div class="raw-content" style="border: 1px solid var(--line); padding: 20px; background: #fff; min-height: 500px; overflow-x: auto; border-radius: 12px;">
                            ${contract.contractContent}
                        </div>
                    </div>

                    <!-- COL 2: ACTION + HISTORY (Right) -->

                    <div class="right-panel">

                        <!-- ACTION BLOCK -->
                        <div class="action-section">

                            <c:if test="${isGuest}">
                                <p style="color: var(--muted); font-size: 0.9em; line-height: 1.4; margin-top: 10px;">Bạn cần đăng nhập để có nhiều quyền hạn hơn!</p>
                                <div class="action-btn-group">
                                    <a href="login?redirect=contract-detail?id=${contract.contractId}" class="btn-full"><button type="button" style="width: 100%;">Đăng nhập</button></a>
                                </div>
                            </c:if>
                            <c:if test="${!isGuest}">
                                <h3 style="margin-top: 0;">Hành động</h3>
                                <p><strong>Trạng thái</strong> <span style="color: var(--danger); font-weight: bold;">${contract.contractStatus}</span></p>
                                <div class="action-btn-group">
                                    
                                    <!--Action button-->
                                    <c:choose>
                                        <c:when test="${isInternalProcessing}">
                                            <!-- Manager (Role 2) -->
                                            <c:if test="${sessionScope.user.roleId == 2}">
                                                <form method="POST" action="contract-detail">
                                                    <input type="hidden" name="action" value="approve" />
                                                    <input type="hidden" name="contractId" value="${contract.contractId}" />
                                                    <button type="submit" class="btn-full" style="background: var(--primary);">Duyệt</button>
                                                </form>
                                            </c:if>

                                            <!-- Admin Officer (Role 5) -->
                                            <c:if test="${sessionScope.user.roleId == 5}">
                                                <a href="contract-save?id=${contract.contractId}" class="btn-full" style="text-decoration:none;">
                                                    <button type="button" style="width: 100%;">Sửa Hợp đồng</button>
                                                </a>
                                                <form method="POST" action="contract-detail">
                                                    <input type="hidden" name="action" value="send_to_manager" />
                                                    <input type="hidden" name="contractId" value="${contract.contractId}" />
                                                    <button type="submit" class="btn-full btn-secondary">Gửi Quản lý duyệt</button>
                                                </form>
                                            </c:if>
                                        </c:when>

                                        <c:when test="${canCustomerCheck}">
                                            <!-- Khach hang (Role 3) -->
                                            <c:if test="${sessionScope.user.roleId == 3}">
                                                <form method="POST" action="contract-detail">
                                                    <input type="hidden" name="action" value="customer_approve" />
                                                    <input type="hidden" name="contractId" value="${contract.contractId}" />
                                                    <button type="submit" class="btn-full" style="background: var(--primary);">Duyệt</button>
                                                </form>
                                            </c:if>
                                        </c:when>

                                        <c:when test="${isApproved}">
                                            <p style="color: var(--primary); text-align: center; font-weight: bold; margin: 10px 0;">Hợp đồng đã chốt</p>
                                            <c:if test="${sessionScope.user.roleId == 2 || sessionScope.user.roleId == 3}">
                                                <c:if test="${not signed}">
                                                    <form action="Signature" method="get">
                                                        <input type="hidden" name="contractId" value="${contract.contractId}">
                                                        <input type="hidden" name="signerId" value="${sessionScope.user.userId}">
                                                        <button type="submit" class="btn-full">Ký Hợp đồng</button>
                                                    </form>
                                                </c:if>
                                            </c:if>
                                        </c:when>

                                        <c:when test="${contract.contractStatus == 'SIGNED'}">
                                            <p style="color: var(--primary); text-align: center; font-weight: bold; margin: 10px 0;">Hợp đồng đã ký hoàn tất</p>
                                            <c:if test="${sessionScope.user.roleId == 2}">
                                                <form method="POST" action="contract-detail" style="margin-bottom: 10px;">
                                                    <input type="hidden" name="action" value="send_final_contract" />
                                                    <input type="hidden" name="contractId" value="${contract.contractId}" />
                                                    <button type="submit" class="btn-full" style="background: var(--primary);">Gửi hợp đồng hoàn thiện</button>
                                                </form>
                                            </c:if>
                                        </c:when>
                                    </c:choose>

                                    <a href="export-pdf?id=${contract.contractId}" class="btn-full" style="text-decoration:none;">
                                        <button type="button" class="btn-secondary" style="width: 100%;">Xuất PDF</button>
                                    </a>
                                    <div style="text-align: center; margin-top: 5px;">
                                        <a href="contract-list" style="color: var(--primary); font-size: 0.9em; font-weight: 600;">Quay lại danh sách</a>
                                    </div>
                                </div>


                            </div>

                            <!-- TYPE NOTE BLOCK -->
                            <c:if test="${(( sessionScope.user.roleId == 2) || ( sessionScope.user.roleId == 3))
                                          && (contract.contractStatus== 'PENDING_REVIEW' ||contract.contractStatus== 'CUSTOMER_CHECK' ) }">
                                  <div class="type-note-section" style="margin-bottom: 20px; border-bottom: 1px solid var(--line); padding-bottom: 20px;">
                                      <h3 style="margin-top:0;">Ghi chú</h3>
                                      <form method="POST" action="contract-detail" style="background: none; border: none; box-shadow: none; padding: 0; margin: 0;">
                                          <input type="hidden" name="action" value="request_edit" />
                                          <input type="hidden" name="contractId" value="${contract.contractId}" />
                                          <textarea name="revision_note" class="note-textarea" placeholder="Ví dụ:&#10;Giá: đổi thành 10000&#10;Tên: đổi thành Nguyễn Văn A" required></textarea>
                                          <button type="submit" class="btn-tertiary" style="width: 100%;">Gửi ghi chú</button>
                                      </form>
                                  </div>
                            </c:if>

                            <!-- HISTORY BLOCK -->

                            <div class="history-section">
                                <h3 style="margin-top:0;">Lịch sử yêu cầu chỉnh sửa</h3>
                                <c:choose>
                                    <c:when test="${not empty historyList}">
                                        <div class="history-list">
                                            <c:forEach var="h" items="${historyList}">
                                                <div class="history-item">
                                                    <p style="margin: 0 0 3px 0; color: var(--muted); font-size: 0.85em;">${h.getCreateTimeString()}</p>
                                                    <p style="margin: 0 0 3px 0; font-size: 0.9em;"><strong>Trạng thái:</strong> ${h.toStatus}</p>
                                                    <p style="margin: 0 0 5px 0; font-size: 0.9em;"><strong>Bởi:</strong> ${h.changedByName}</p>
                                                    <c:if test="${sessionScope.user.roleId == 5}">
                                                        <p style="margin: 0 0 5px 0; color: var(--danger); font-size: 0.9em;"><strong>Ghi chú:</strong> ${h.note}</p>
                                                    </c:if>
                                                    <c:if test="${not empty h.revisionItems}">
                                                        <c:forEach var="item" items="${h.revisionItems}">
                                                            <div class="note-block">${item.revisionDetail}</div>
                                                        </c:forEach>
                                                    </c:if>
                                                </div>
                                            </c:forEach>
                                        </div>
                                        <c:if test="${historyEndPage > 1}">
                                            <div style="display: flex; gap: 5px; margin-top: 15px; justify-content: center;">
                                                <c:forEach begin="1" end="${historyEndPage}" var="i">
                                                    <a href="contract-detail?id=${contract.contractId}&historyPage=${i}" 
                                                       style="padding: 4px 10px; border-radius: 4px; border: 1px solid var(--line); text-decoration: none; 
                                                              background: ${i == historyPage ? 'var(--primary)' : '#fff'};
                                                              color: ${i == historyPage ? '#fff' : 'var(--text)'};">
                                                        ${i}
                                                    </a>
                                                </c:forEach>
                                            </div>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <p style="color: var(--muted); font-style: italic; font-size: 0.9em;">Chưa có lịch sử nào</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
>>>>>>> a5d933bcdd2d38a00633fea144fd64b641bd5450
                        </c:if>
                    </c:when>

                    <%-- 2. TRẠNG THÁI: CUSTOMER_CHECK --%>
                    <c:when test="${contract.contractStatus == 'CUSTOMER_CHECK'}">
                        <!-- Khách hàng (Role 3) -->
                        <c:if test="${sessionScope.user.roleId == 3}">
                            <form method="POST" action="contract-detail" style="margin:0;">
                                <input type="hidden" name="action" value="customer_approve"/>
                                <input type="hidden" name="contractId" value="${contract.contractId}"/>
                                <button type="submit" class="btn btn-green">Đồng ý hợp đồng (Approve)</button>
                            </form>
                            <button type="button" onclick="showFeedbackModal()" class="btn btn-orange">Yêu cầu sửa đổi</button>
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
                </c:choose>

                <hr>
                <a href="contract-list" style="color: #007bff; text-decoration: none;">⬅ Quay lại danh sách</a>
            </div>

            <!-- CỘT 2: CONTENT -->
            <div class="content">
                <h3>Chi tiết Nội dung</h3>
                <div style="background: #fdfdfd; padding: 15px; border: 1px solid #eee; margin-bottom: 15px; border-radius: 4px;">
                    <p style="margin: 0 0 5px 0;"><strong>Khách hàng:</strong> ${contract.customerName}</p>
                    <p style="margin: 0;"><strong>Loại lưu trữ:</strong> ${contract.storageType}</p>
                </div>
                <div style="border: 1px solid #ddd; padding: 20px; background: #fff; min-height: 500px; overflow-x: auto;">
                    ${contract.contractContent}
                </div>
            </div>

            <!-- CỘT 3: HISTORY -->
            <div class="history">
                <h3>Lịch sử chỉnh sửa</h3>
                <c:choose>
                    <c:when test="${not empty historyList}">
                        <div style="max-height: 600px; overflow-y: auto;">
                            <c:forEach var="h" items="${historyList}">
                                <div style="border-bottom: 1px solid #ddd; padding-bottom: 15px; margin-bottom: 15px;">
                                    <p style="margin: 0 0 5px 0; color: #666; font-size: 0.9em;">🕒 ${h.createdAt}</p>
                                    <p style="margin: 0 0 5px 0;"><strong>Trạng thái:</strong> ${h.toStatus}</p>
                                    <p style="margin: 0 0 10px 0;"><strong>Bởi:</strong> ${h.changedByName}</p>
                                    <c:if test="${not empty h.revisionItems}">
                                        <button class="btn btn-blue" style="padding: 5px 10px; font-size: 0.85em; width: auto;" onclick="viewHistoryDetail(${h.historyId})">Xem chi tiết</button>
                                        <div id="history-data-${h.historyId}" style="display:none;">
                                            <c:forEach var="item" items="${h.revisionItems}">
                                                <div style="border-left: 3px solid #007bff; padding: 8px; margin-bottom: 5px; background: #f8f9fa;">
                                                    <strong>Vị trí:</strong> ${item.revisionType} <br> <strong>Thay đổi:</strong> ${item.revisionDetail}
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise><p style="color: #888;">Chưa có lịch sử.</p></c:otherwise>
                </c:choose>
            </div>
        </div>

        <div id="modalOverlay" class="modal-overlay"></div>
        <div id="feedbackModal" class="modal-content">
            <h3>Yêu cầu sửa đổi</h3>
            <form method="POST" action="contract-detail" id="feedbackForm">
                <input type="hidden" name="action" value="request_edit"/>
                <input type="hidden" name="contractId" value="${contract.contractId}"/>
                <div id="revisionContainer">
                    <div class="revision-box">
                        <input type="text" name="revision_type[]" placeholder="Vị trí (vd: Điều 2)" required style="width:40%; padding: 8px;">
                        <input type="text" name="revision_detail[]" placeholder="Thông tin thay đổi" required style="width:50%; padding: 8px;">
                    </div>
                </div>
                <button type="button" onclick="addRevisionBox()" class="btn btn-add">+ Thêm mục</button>
                <div style="margin-top: 20px; text-align: right;">
                    <button type="button" onclick="hideModals()" class="btn btn-red" style="width:auto;">Hủy</button>
                    <button type="submit" class="btn btn-green" style="width:auto;">Gửi phản hồi</button>
                </div>
            </form>
        </div>

        <div id="viewHistoryModal" class="modal-content" style="width: 40%; left: 30%;">
            <h3>Chi tiết Yêu cầu sửa đổi</h3>
            <div id="viewHistoryBody" style="margin-bottom: 20px;"></div>
            <button type="button" onclick="hideModals()" class="btn btn-gray" style="width: auto;">Đóng</button>
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
                div.innerHTML = '<input type="text" name="revision_type[]" placeholder="Vị trí" required style="width:40%; padding: 8px; margin-top: 5px;"> ' +
                        '<input type="text" name="revision_detail[]" placeholder="Thay đổi" required style="width:50%; padding: 8px;">';
                container.appendChild(div);
            }
            function viewHistoryDetail(historyId) {
                document.getElementById('viewHistoryBody').innerHTML = document.getElementById('history-data-' + historyId).innerHTML;
                document.getElementById('modalOverlay').style.display = 'block';
                document.getElementById('viewHistoryModal').style.display = 'block';
            }

            let errorSig = "${errorSig}";

            if (errorSig !== "") {
                alert("${errorSig}");
            }
        </script>
    </body>
</html>