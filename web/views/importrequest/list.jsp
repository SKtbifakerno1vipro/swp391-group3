<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh sách yêu cầu nhập kho</title>
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
                <h1>Danh sách yêu cầu nhập kho</h1>

                <%-- Thông báo kết quả thao tác --%>
                <c:if test="${message == 'addSuccess'}"><p style="color: green; font-weight: bold;">Tạo yêu cầu nhập kho thành công.</p></c:if>
                <c:if test="${message == 'cancelSuccess'}"><p style="color: green; font-weight: bold;">Hủy yêu cầu nhập kho thành công.</p></c:if>
                <c:if test="${message == 'importSuccess'}"><p style="color: green; font-weight: bold;">Nhập kho sản phẩm thành công.</p></c:if>
                <c:if test="${message == 'permissionDenied'}"><p style="color: red; font-weight: bold;">Bạn không có quyền thực hiện thao tác này.</p></c:if>
                <c:if test="${message == 'invalidStatus'}"><p style="color: red; font-weight: bold;">Trạng thái yêu cầu không hợp lệ cho hành động này.</p></c:if>
                <c:if test="${message == 'dbError'}"><p style="color: red; font-weight: bold;">Lỗi hệ thống database. Vui lòng thử lại.</p></c:if>

                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 15px;">
                    <%-- Thanh tìm kiếm (Thiết kế đơn giản, tách biệt, giống Role list) --%>
                    <form action="${pageContext.request.contextPath}/import-request-list" method="get" style="display: flex; gap: 10px; align-items: center;">
                        <input type="text" name="search" value="<c:out value="${searchText}"/>" placeholder="Tìm tên sản phẩm, người tạo..." style="padding: 8px 12px; width: 280px; border: 1px solid #ccc; border-radius: 4px;">
                        <button type="submit" style="padding: 8px 16px; background-color: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; display: flex; align-items: center; gap: 5px;">
                            <span class="material-symbols-outlined" style="font-size: 18px;">search</span>Tìm kiếm
                        </button>
                        <c:if test="${not empty searchText}">
                            <a href="${pageContext.request.contextPath}/import-request-list" style="text-decoration: none;">
                                <button type="button" style="padding: 8px 16px; background-color: #6c757d; color: white; border: none; border-radius: 4px; cursor: pointer;">Xóa lọc</button>
                            </a>
                        </c:if>
                    </form>

                    <%-- Nút thêm mới yêu cầu nhập kho --%>
                    <c:if test="${sessionScope.user.roleId == 1 || sessionScope.user.roleId == 2 || sessionScope.user.roleId == 4}">
                        <div>
                            <a href="${pageContext.request.contextPath}/import-request-create" style="text-decoration: none;">
                                <button style="padding: 10px 20px; background-color: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer; display: flex; align-items: center; gap: 5px; font-weight: bold;">
                                    <span class="material-symbols-outlined" style="font-size: 18px;">add</span>Tạo yêu cầu mới
                                </button>
                            </a>
                        </div>
                    </c:if>
                </div>

                <table border="1" cellpadding="7" cellspacing="0" style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr style="background-color: #f2f2f2;">
                            <th>Mã yêu cầu</th>
                            <th>Sản phẩm</th>
                            <th>Số lượng</th>
                            <th>Trạng thái</th>
                            <th>Người tạo</th>
                            <th>Ngày tạo</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty list}">
                            <tr><td colspan="7" style="text-align: center;">Không tìm thấy yêu cầu nhập kho nào.</td></tr>
                        </c:if>
                        <c:forEach items="${list}" var="ir">
                            <tr>
                                <td style="text-align: center;">IR-${ir.importId}</td>
                                <td>${ir.productName}</td>
                                <td style="text-align: right;">${ir.quantity}</td>
                                <td style="text-align: center;">
                                    <c:choose>
                                        <c:when test="${ir.status == 1}">
                                            <span style="color: #ff9800; font-weight: bold;">Pending</span>
                                        </c:when>
                                        <c:when test="${ir.status == 2}">
                                            <span style="color: #4caf50; font-weight: bold;">Imported</span>
                                        </c:when>
                                        <c:when test="${ir.status == 3}">
                                            <span style="color: #f44336; font-weight: bold;">Cancelled</span>
                                        </c:when>
                                    </c:choose>
                                </td>
                                <td>${ir.createdByName}</td>
                                <td style="text-align: center;">
                                    <fmt:formatDate value="${ir.createdDate}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                                <td style="text-align: center;">
                                    <a href="${pageContext.request.contextPath}/import-request-detail?id=${ir.importId}" style="text-decoration: none;">
                                        <button style="padding: 5px 10px; cursor: pointer;">Xem chi tiết</button>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <%-- Phân trang (Sử dụng cấu trúc phân trang chuẩn của project) --%>
                <div class="pagination" style="margin-top: 20px; display: flex; justify-content: center; gap: 5px; align-items: center;">
                    <c:if test="${currentPage > 1}">
                        <a class="page-link" href="${pageContext.request.contextPath}/import-request-list?page=${currentPage - 1}&search=${searchText}" style="padding: 6px 12px; border: 1px solid #ddd; text-decoration: none; color: #007bff; border-radius: 4px;">&lt;</a>
                    </c:if>
                    
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <span class="page-current" style="padding: 6px 12px; border: 1px solid #007bff; background-color: #007bff; color: white; font-weight: bold; border-radius: 4px;">${i}</span>
                            </c:when>
                            <c:otherwise>
                                <a class="page-link" href="${pageContext.request.contextPath}/import-request-list?page=${i}&search=${searchText}" style="padding: 6px 12px; border: 1px solid #ddd; text-decoration: none; color: #007bff; border-radius: 4px;">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    
                    <c:if test="${currentPage < totalPages}">
                        <a class="page-link" href="${pageContext.request.contextPath}/import-request-list?page=${currentPage + 1}&search=${searchText}" style="padding: 6px 12px; border: 1px solid #ddd; text-decoration: none; color: #007bff; border-radius: 4px;">&gt;</a>
                    </c:if>
                </div>
            </main>
        </div>
    </body>
</html>
