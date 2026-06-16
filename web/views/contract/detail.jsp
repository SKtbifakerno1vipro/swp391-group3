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

            /* Bố cục Grid: 3 cột (Sidebar - Content - History) */
            .layout-container {
                display: grid;
                grid-template-columns: 250px 1fr 350px; /* Cột 1: 250px, Cột 2: Co giãn, Cột 3: 350px */
                gap: 20px;
                padding: 20px;
            }

            /* Styles cho từng cột */
            .sidebar {
                background: #fff;
                border: 1px solid #ddd;
                padding: 20px;
                border-radius: 5px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            }
            .content {
                background: #fff;
                border: 1px solid #ddd;
                padding: 20px;
                border-radius: 5px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            }
            .history {
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

            /* Modal Styles (Dành cho Yêu cầu sửa đổi) */
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

            /* Buttons */
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
            .btn-orange:hover {
                background: #e86c0c;
            }
            .btn-green {
                background: #28a745;
            }
            .btn-green:hover {
                background: #218838;
            }
            .btn-blue {
                background: #007bff;
            }
            .btn-blue:hover {
                background: #0069d9;
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
                    <%-- ROLE ID 2 (Manager) và 3 (Customer) --%>
                    <c:when test="${not empty sessionScope.user and (sessionScope.user.roleId == 2 or sessionScope.user.roleId == 3) and (contract.contractStatus == 'DRAFT' or contract.contractStatus == 'PENDING_REVIEW')}">

                        <!-- Cả Manager và Customer đều thấy nút Yêu cầu sửa đổi -->
                        <button type="button" onclick="showFeedbackModal()" class="btn btn-orange">
                            Yêu cầu sửa đổi
                        </button>

                        <!-- NÚT PHÊ DUYỆT: Chặn không cho Customer (Role 3) nhìn thấy -->
                        <c:if test="${sessionScope.user.roleId != 3}">
                            <form method="POST" action="contract-detail" style="margin:0;">
                                <input type="hidden" name="action" value="approve"/>
                                <input type="hidden" name="contractId" value="${contract.contractId}"/>
                                <button type="submit" class="btn btn-green">Phê duyệt (Approve)</button>
                            </form>
                        </c:if>

                    </c:when>

                    <%-- ROLE ID 5: Admin Officer --%>
                    <c:when test="${not empty sessionScope.user and sessionScope.user.roleId == 5 and (contract.contractStatus == 'DRAFT' or contract.contractStatus == 'PENDING_REVIEW')}">
                        <a href="contract-save?id=${contract.contractId}" class="btn btn-blue">Chỉnh sửa HTML</a>
                        <form method="POST" action="contract-detail" style="margin:0;">
                            <input type="hidden" name="action" value="send_to_manager"/>
                            <input type="hidden" name="contractId" value="${contract.contractId}"/>
                            <button type="submit" class="btn btn-gray">Gửi lại cho Manager</button>
                        </form>
                    </c:when>
                </c:choose>

                <hr>
                <a href="contract-list" style="color: #007bff; text-decoration: none;">⬅ Quay lại danh sách</a>
            </div>

            <!-- CỘT 2: CONTENT (Nội dung hợp đồng) -->
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

            <!-- CỘT 3: HISTORY (Lịch sử phiên bản) -->
            <div class="history">
                <h3>Lịch sử chỉnh sửa</h3>
                <c:choose>
                    <c:when test="${not empty historyList}">
                        <div style="max-height: 600px; overflow-y: auto;">
                            <c:forEach var="h" items="${historyList}">
                                <div style="border-bottom: 1px solid #ddd; padding-bottom: 15px; margin-bottom: 15px;">
                                    <p style="margin: 0 0 5px 0; color: #666; font-size: 0.9em;">
                                        🕒 ${h.createdAt}
                                    </p>
                                    <p style="margin: 0 0 5px 0;">
                                        <strong>Trạng thái:</strong> ${h.toStatus}
                                    </p>
                                    <p style="margin: 0 0 10px 0;">
                                        <strong>Bởi:</strong> ${h.changedByName}
                                    </p>

                                    <%-- Nút View Detail Lịch sử --%>
                                    <c:if test="${not empty h.revisionItems}">
                                        <button class="btn btn-blue" style="padding: 5px 10px; font-size: 0.85em; width: auto;" onclick="viewHistoryDetail(${h.historyId})">
                                            Xem chi tiết sửa đổi
                                        </button>

                                        <%-- Dữ liệu ẩn để JS đọc --%>
                                        <div id="history-data-${h.historyId}" style="display:none;">
                                            <c:forEach var="item" items="${h.revisionItems}">
                                                <div style="border-left: 3px solid #007bff; padding-left: 10px; margin-bottom: 5px; background: #f8f9fa; padding: 8px;">
                                                    <strong>Vị trí:</strong> ${item.revisionType} <br>
                                                    <strong>Thay đổi:</strong> ${item.revisionDetail}
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p style="color: #888;">Chưa có lịch sử chỉnh sửa nào.</p>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>

        <!-- ========================================== -->
        <!-- MODALS (Popups)                            -->
        <!-- ========================================== -->
        <div id="modalOverlay" class="modal-overlay"></div>

        <!-- 1. Modal: YÊU CẦU SỬA ĐỔI (Dành cho Manager) -->
        <div id="feedbackModal" class="modal-content">
            <h3>Yêu cầu sửa đổi hợp đồng</h3>
            <hr>
            <form method="POST" action="contract-detail" id="feedbackForm">
                <input type="hidden" name="action" value="request_edit"/>
                <input type="hidden" name="contractId" value="${contract.contractId}"/>

                <div id="revisionContainer">
                    <div class="revision-box">
                        <label><strong>Mục 1:</strong></label><br>
                        <input type="text" name="revision_type[]" placeholder="Vị trí (vd: Điều 2, Khoản 1)" required style="width:40%; padding: 8px; margin-top: 5px;">
                        <input type="text" name="revision_detail[]" placeholder="Thông tin cần thay đổi" required style="width:55%; padding: 8px; margin-top: 5px;">
                    </div>
                </div>

                <button type="button" onclick="addRevisionBox()" class="btn btn-add">+ Thêm mục sửa đổi</button>

                <div style="margin-top: 20px; text-align: right;">
                    <button type="button" onclick="hideModals()" class="btn btn-red">Hủy bỏ</button>
                    <button type="submit" class="btn btn-green" style="width:auto;">Gửi phản hồi</button>
                </div>
            </form>
        </div>

        <!-- 2. Modal: XEM CHI TIẾT LỊCH SỬ (Dành cho mọi Role) -->
        <div id="viewHistoryModal" class="modal-content" style="width: 40%; left: 30%;">
            <h3>Chi tiết Yêu cầu sửa đổi</h3>
            <hr>
            <div id="viewHistoryBody" style="margin-bottom: 20px;">
                <!-- Nội dung sẽ được nhúng bằng JavaScript -->
            </div>
            <div style="text-align: right;">
                <button type="button" onclick="hideModals()" class="btn btn-gray" style="width: auto;">Đóng</button>
            </div>
        </div>

        <!-- ========================================== -->
        <!-- SCRIPT XỬ LÝ                              -->
        <!-- ========================================== -->
        <script>
            // 1. Quản lý Đóng/Mở Modals
            function hideModals() {
                document.getElementById('modalOverlay').style.display = 'none';
                document.getElementById('feedbackModal').style.display = 'none';
                document.getElementById('viewHistoryModal').style.display = 'none';
            }

            // 2. JS cho Modal Yêu cầu sửa đổi (Manager)
            var revisionCount = 1;
            function showFeedbackModal() {
                document.getElementById('modalOverlay').style.display = 'block';
                document.getElementById('feedbackModal').style.display = 'block';
            }

            function addRevisionBox() {
                revisionCount++;
                var container = document.getElementById('revisionContainer');
                var div = document.createElement('div');
                div.className = 'revision-box';
                div.innerHTML = '<label><strong>Mục ' + revisionCount + ':</strong></label><br>' +
                        '<input type="text" name="revision_type[]" placeholder="Vị trí cần sửa" required style="width:40%; padding: 8px; margin-top: 5px; margin-right: 1%;">' +
                        '<input type="text" name="revision_detail[]" placeholder="Thông tin thay đổi" required style="width:55%; padding: 8px; margin-top: 5px;">';
                container.appendChild(div);
            }

            // 3. JS cho Modal Xem Chi tiết Lịch sử
            function viewHistoryDetail(historyId) {
                // Lấy HTML từ thẻ ẩn (div id="history-data-{id}")
                var historyHtml = document.getElementById('history-data-' + historyId).innerHTML;

                // Nhúng vào Modal Body
                document.getElementById('viewHistoryBody').innerHTML = historyHtml;

                // Hiển thị Modal
                document.getElementById('modalOverlay').style.display = 'block';
                document.getElementById('viewHistoryModal').style.display = 'block';
            }
        </script>
    </body>
</html>