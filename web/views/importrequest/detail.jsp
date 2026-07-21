<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết yêu cầu nhập kho</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="import-requests"/>
            </jsp:include>
            <main class="main legacy-page">
                <h1>Chi tiết yêu cầu nhập kho IR-${ir.importId}</h1>

                <%-- Thông báo kết quả thao tác --%>
                <c:if test="${message == 'cancelSuccess'}"><p style="color: green; font-weight: bold;">Hủy yêu cầu nhập kho thành công.</p></c:if>
                <c:if test="${message == 'importSuccess'}"><p style="color: green; font-weight: bold;">Nhập kho sản phẩm thành công và đã cập nhật tồn kho.</p></c:if>
                <c:if test="${message == 'permissionDenied'}"><p style="color: red; font-weight: bold;">Bạn không có quyền thực hiện thao tác này.</p></c:if>
                <c:if test="${message == 'invalidStatus'}"><p style="color: red; font-weight: bold;">Trạng thái hiện tại của yêu cầu không cho phép thực hiện thao tác này.</p></c:if>
                <c:if test="${message == 'alreadyProcessed'}"><p style="color: #d32f2f; font-weight: bold; background-color: #ffebee; padding: 10px; border-left: 4px solid #f44336; border-radius: 4px; margin-bottom: 15px;">Yêu cầu này đã được xử lý hoặc hủy trước đó bởi người dùng/thiết bị khác.</p></c:if>
                <c:if test="${message == 'missingNote'}"><p style="color: #c62828; font-weight: bold; background-color: #ffebee; padding: 10px; border-left: 4px solid #f44336; border-radius: 4px; margin-bottom: 15px;">Vui lòng nhập lý do hủy yêu cầu nhập kho.</p></c:if>
                <c:if test="${message == 'dbError'}"><p style="color: red; font-weight: bold;">Lỗi hệ thống database khi lưu trữ. Vui lòng thử lại.</p></c:if>

                <div style="background-color: #f9f9f9; padding: 20px; border-radius: 5px; border: 1px solid #e0e0e0; max-width: 700px; margin-bottom: 20px;">
                    <table cellpadding="8" cellspacing="0" style="width: 100%;">
                        <tr>
                            <td style="width: 30%; font-weight: bold;">Mã yêu cầu:</td>
                            <td>IR-${ir.importId}</td>
                        </tr>
                        <tr>
                            <td style="font-weight: bold;">Sản phẩm:</td>
                            <td>${ir.productName}</td>
                        </tr>
                        <tr>
                            <td style="font-weight: bold;">Số lượng:</td>
                            <td>${ir.quantity}</td>
                        </tr>
                        <tr>
                            <td style="font-weight: bold;">Trạng thái:</td>
                            <td>
                                <c:choose>
                                    <c:when test="${ir.status == 1}">
                                        <span style="color: #ff9800; font-weight: bold;">Pending (Chờ nhập kho)</span>
                                    </c:when>
                                    <c:when test="${ir.status == 2}">
                                        <span style="color: #4caf50; font-weight: bold;">Imported (Đã nhập kho)</span>
                                    </c:when>
                                    <c:when test="${ir.status == 3}">
                                        <span style="color: #f44336; font-weight: bold;">Cancelled (Đã hủy)</span>
                                    </c:when>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <td style="font-weight: bold;">Người tạo yêu cầu:</td>
                            <td>${ir.createdByName}</td>
                        </tr>
                        <tr>
                            <td style="font-weight: bold;">Ngày tạo:</td>
                            <td>
                                <fmt:formatDate value="${ir.createdDate}" pattern="dd/MM/yyyy HH:mm:ss"/>
                            </td>
                        </tr>
                        <tr>
                            <td style="font-weight: bold;">Ghi chú người tạo:</td>
                            <td><c:out value="${ir.note != null ? ir.note : '(Không có ghi chú)'}"/></td>
                        </tr>

                        <%-- Hiển thị thông tin nhập kho nếu đã nhập kho --%>
                        <c:if test="${ir.status == 2}">
                            <tr style="background-color: #e8f5e9;">
                                <td style="font-weight: bold; color: #2e7d32;">Người nhập kho:</td>
                                <td style="color: #2e7d32; font-weight: bold;">${ir.importedByName}</td>
                            </tr>
                            <tr style="background-color: #e8f5e9;">
                                <td style="font-weight: bold; color: #2e7d32;">Ngày nhập kho:</td>
                                <td style="color: #2e7d32; font-weight: bold;">
                                    <fmt:formatDate value="${ir.importedDate}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                </td>
                            </tr>
                        </c:if>

                        <%-- Hiển thị thông tin hủy kho nếu đã hủy --%>
                        <c:if test="${ir.status == 3}">
                            <tr style="background-color: #ffebee;">
                                <td style="font-weight: bold; color: #c62828;">Người hủy yêu cầu:</td>
                                <td style="color: #c62828; font-weight: bold;"><c:out value="${ir.importedByName != null ? ir.importedByName : '(Kho)'}"/></td>
                            </tr>
                            <tr style="background-color: #ffebee;">
                                <td style="font-weight: bold; color: #c62828;">Ngày hủy:</td>
                                <td style="color: #c62828; font-weight: bold;">
                                    <fmt:formatDate value="${ir.importedDate}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                </td>
                            </tr>
                            <tr style="background-color: #ffebee;">
                                <td style="font-weight: bold; color: #c62828;">Lý do hủy (Kho):</td>
                                <td style="color: #c62828; font-weight: bold;"><c:out value="${ir.wareHousenote != null ? ir.wareHousenote : '(Không có ghi chú)'}"/></td>
                            </tr>
                        </c:if>
                    </table>
                </div>

                <div style="margin-top: 20px;">
                    <%-- Nút Hủy yêu cầu (CHỈ dành cho Warehouse Staff - roleId == 6 khi trạng thái đang là Pending) --%>
                    <c:if test="${ir.status == 1 && sessionScope.user.roleId == 6}">
                        <button type="button" id="btnShowCancelForm" style="padding: 10px 20px; background-color: #f44336; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold;" onclick="toggleCancelForm()">Hủy yêu cầu</button>

                        <div id="cancelFormContainer" style="display: none; margin-top: 15px; background: #fff3f3; padding: 15px; border: 1px solid #ffcdd2; border-radius: 6px; max-width: 700px;">
                            <h4 style="margin-top: 0; color: #c62828;">Nhập lý do hủy yêu cầu nhập kho (Bắt buộc)</h4>
                            <form action="${pageContext.request.contextPath}/import-request-detail" method="post">
                                <input type="hidden" name="importId" value="${ir.importId}">
                                <input type="hidden" name="action" value="cancel">
                                <div style="margin-bottom: 10px;">
                                    <textarea name="wareHousenote" id="wareHousenoteInput" rows="3" required placeholder="Nhập lý do hủy yêu cầu nhập kho..." style="width: 100%; box-sizing: border-box; padding: 8px; border: 1px solid #ff9999; border-radius: 4px; font-family: inherit;"></textarea>
                                </div>
                                <div style="display: flex; gap: 10px;">
                                    <button type="submit" style="padding: 8px 16px; background-color: #d32f2f; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold;" onclick="return validateCancelForm()">Xác nhận Hủy yêu cầu</button>
                                    <button type="button" style="padding: 8px 16px; background-color: #757575; color: white; border: none; border-radius: 4px; cursor: pointer;" onclick="toggleCancelForm()">Hủy bỏ</button>
                                </div>
                            </form>
                        </div>

                        <script>
                            function toggleCancelForm() {
                                var form = document.getElementById('cancelFormContainer');
                                if (form.style.display === 'none' || form.style.display === '') {
                                    form.style.display = 'block';
                                } else {
                                    form.style.display = 'none';
                                }
                            }
                            function validateCancelForm() {
                                var note = document.getElementById('wareHousenoteInput').value.trim();
                                if (note === '') {
                                    alert('Vui lòng nhập lý do hủy yêu cầu nhập kho!');
                                    return false;
                                }
                                return confirm('Bạn có chắc chắn muốn hủy yêu cầu nhập kho này không?');
                            }
                        </script>
                    </c:if>

                    <%-- Nút Xác nhận Nhập kho (CHỈ dành cho Warehouse Staff - roleId == 6 khi trạng thái đang là Pending) --%>
                    <c:if test="${ir.status == 1 && sessionScope.user.roleId == 6}">
                        <form action="${pageContext.request.contextPath}/import-request-detail" method="post" style="display: inline;">
                            <input type="hidden" name="importId" value="${ir.importId}">
                            <input type="hidden" name="action" value="import">
                            <button type="submit" style="padding: 10px 20px; background-color: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; margin-left: 5px;" onclick="return confirm('Xác nhận nhập ' + ${ir.quantity} + ' sản phẩm vào tồn kho?')">Xác nhận Nhập kho</button>
                        </form>
                    </c:if>

                    <a href="${pageContext.request.contextPath}/import-request-list" style="margin-left: 10px; text-decoration: none;">
                        <button type="button" style="padding: 10px 20px; background-color: #9e9e9e; color: white; border: none; border-radius: 4px; cursor: pointer;">Quay lại danh sách</button>
                    </a>
                </div>
            </main>
        </div>
    </body>
</html>
