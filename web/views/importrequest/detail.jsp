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
                            <td style="font-weight: bold;">Ghi chú:</td>
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
                    </table>
                </div>

                <div style="margin-top: 20px;">
                    <%-- Nút Hủy yêu cầu (Dành cho Sales, Manager, Admin khi trạng thái đang là Pending) --%>
                    <c:if test="${ir.status == 1 && (sessionScope.user.roleId == 1 || sessionScope.user.roleId == 2 || sessionScope.user.roleId == 4)}">
                        <form action="${pageContext.request.contextPath}/import-request-detail" method="post" style="display: inline;">
                            <input type="hidden" name="importId" value="${ir.importId}">
                            <input type="hidden" name="action" value="cancel">
                            <button type="submit" style="padding: 10px 20px; background-color: #f44336; color: white; border: none; cursor: pointer;" onclick="return confirm('Bạn có chắc chắn muốn hủy yêu cầu nhập kho này không?')">Hủy yêu cầu</button>
                        </form>
                    </c:if>

                    <%-- Nút Xác nhận Nhập kho (Dành cho Sales, Manager, Admin, Warehouse Staff khi trạng thái đang là Pending) --%>
                    <c:if test="${ir.status == 1 && (sessionScope.user.roleId == 1 || sessionScope.user.roleId == 2 || sessionScope.user.roleId == 4 || sessionScope.user.roleId == 6)}">
                        <form action="${pageContext.request.contextPath}/import-request-detail" method="post" style="display: inline;">
                            <input type="hidden" name="importId" value="${ir.importId}">
                            <input type="hidden" name="action" value="import">
                            <button type="submit" style="padding: 10px 20px; background-color: #4CAF50; color: white; border: none; cursor: pointer;" onclick="return confirm('Xác nhận nhập ' + ${ir.quantity} + ' sản phẩm vào tồn kho?')">Xác nhận Nhập kho</button>
                        </form>
                    </c:if>

                    <a href="${pageContext.request.contextPath}/import-request-list" style="margin-left: 10px; text-decoration: none;">
                        <button type="button" style="padding: 10px 20px; background-color: #9e9e9e; color: white; border: none; cursor: pointer;">Quay lại danh sách</button>
                    </a>
                </div>
            </main>
        </div>
    </body>
</html>
