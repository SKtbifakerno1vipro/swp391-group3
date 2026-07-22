<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh sách Yêu cầu Nhập kho - Bakery Sales System</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700;800&family=Nunito+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
        <style>
            .btn-action-view {
                display: inline-flex;
                align-items: center;
                gap: 4px;
                padding: 6px 14px;
                background: var(--surface-soft);
                color: var(--primary) !important;
                border: 1px solid var(--line);
                border-radius: 999px;
                font-weight: 700;
                font-size: 13px;
                transition: all 0.2s ease;
                text-decoration: none;
            }
            .btn-action-view:hover {
                background: var(--primary);
                color: #ffffff !important;
                border-color: var(--primary);
                box-shadow: 0 4px 12px rgba(74, 124, 89, 0.25);
            }
        </style>
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="import-requests"/>
            </jsp:include>
            <main class="main">
                <!-- Topbar Header -->
                <div class="topbar">
                    <div>
                        <p class="eyebrow">QUẢN LÝ KHO HÀNG</p>
                        <h1>Yêu cầu Nhập kho</h1>
                        <p>Quản lý, duyệt và theo dõi các đề xuất nhập bổ sung nguyên liệu bánh.</p>
                    </div>
                    <c:if test="${sessionScope.user.roleId == 1 || sessionScope.user.roleId == 2 || sessionScope.user.roleId == 4}">
                        <a href="${pageContext.request.contextPath}/import-request-create" class="btn-primary-action">
                            <span class="material-symbols-outlined">add_circle</span>
                            Tạo yêu cầu mới
                        </a>
                    </c:if>
                </div>

                <!-- Thông báo hệ thống -->
                <c:if test="${message == 'addSuccess'}">
                    <div class="alert-banner success">
                        <span class="material-symbols-outlined">check_circle</span>
                        <span>Tạo yêu cầu nhập kho mới thành công. Phiếu đang chờ Bộ phận Kho xử lý.</span>
                    </div>
                </c:if>
                <c:if test="${message == 'cancelSuccess'}">
                    <div class="alert-banner warning">
                        <span class="material-symbols-outlined">warning</span>
                        <span>Đã hủy yêu cầu nhập kho thành công.</span>
                    </div>
                </c:if>
                <c:if test="${message == 'importSuccess'}">
                    <div class="alert-banner success">
                        <span class="material-symbols-outlined">task_alt</span>
                        <span>Nhập kho sản phẩm thành công và đã tự động cập nhật số lượng tồn kho khả dụng!</span>
                    </div>
                </c:if>
                <c:if test="${message == 'permissionDenied'}">
                    <div class="alert-banner danger">
                        <span class="material-symbols-outlined">block</span>
                        <span>Rất tiếc! Bạn không có quyền thực hiện thao tác này.</span>
                    </div>
                </c:if>
                <c:if test="${message == 'invalidStatus'}">
                    <div class="alert-banner danger">
                        <span class="material-symbols-outlined">error</span>
                        <span>Trạng thái yêu cầu hiện tại không hợp lệ cho hành động này.</span>
                    </div>
                </c:if>
                <c:if test="${message == 'alreadyProcessed'}">
                    <div class="alert-banner danger">
                        <span class="material-symbols-outlined">published_with_changes</span>
                        <span>Yêu cầu này đã được xử lý hoặc bị hủy bởi thiết bị/người dùng khác.</span>
                    </div>
                </c:if>
                <c:if test="${message == 'missingNote'}">
                    <div class="alert-banner danger">
                        <span class="material-symbols-outlined">edit_note</span>
                        <span>Vui lòng nhập lý do/ghi chú khi thực hiện thao tác với phiếu nhập kho.</span>
                    </div>
                </c:if>
                <c:if test="${message == 'dbError'}">
                    <div class="alert-banner danger">
                        <span class="material-symbols-outlined">database</span>
                        <span>Lỗi hệ thống Cơ sở dữ liệu. Vui lòng thử lại sau.</span>
                    </div>
                </c:if>

                <!-- Search & Filter Card -->
                <div class="search-filter-card">
                    <form action="${pageContext.request.contextPath}/import-request-list" method="get" class="search-input-group">
                        <input type="text" name="search" value="<c:out value="${searchText}"/>" placeholder="Tìm kiếm theo tên sản phẩm, mã phiếu, người tạo...">
                        <button type="submit" class="btn-primary-action" style="padding: 10px 18px;">
                            <span class="material-symbols-outlined">search</span>
                            Tìm kiếm
                        </button>
                        <c:if test="${not empty searchText}">
                            <a href="${pageContext.request.contextPath}/import-request-list" class="btn-secondary-action" style="padding: 10px 16px;">
                                <span class="material-symbols-outlined">restart_alt</span>
                                Xóa lọc
                            </a>
                        </c:if>
                    </form>
                    <div style="color: var(--muted); font-size: 13px; font-weight: 700;">
                        Tổng số: <strong style="color: var(--primary); font-size: 15px;">${totalRequests}</strong> yêu cầu
                    </div>
                </div>

                <!-- Main Data Table Panel -->
                <div class="panel table-panel" style="padding: 0; overflow: hidden;">
                    <table>
                        <thead>
                            <tr>
                                <th style="padding-left: 24px;">Mã phiếu</th>
                                <th>Sản phẩm nguyên liệu</th>
                                <th style="text-align: center;">Số lượng nhập</th>
                                <th style="text-align: center;">Trạng thái</th>
                                <th>Người tạo</th>
                                <th>Ngày tạo</th>
                                <th style="text-align: center; padding-right: 24px;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty list}">
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 36px 20px; color: var(--muted);">
                                        <span class="material-symbols-outlined" style="font-size: 48px; color: var(--line); display: block; margin-bottom: 8px;">inventory_2</span>
                                        Không tìm thấy yêu cầu nhập kho nào phù hợp.
                                    </td>
                                </tr>
                            </c:if>
                            <c:forEach items="${list}" var="ir">
                                <tr>
                                    <td style="padding-left: 24px;">
                                        <span class="code-badge">#IR-${ir.importId}</span>
                                    </td>
                                    <td>
                                        <div style="font-weight: 800; color: var(--text);">${ir.productName}</div>
                                    </td>
                                    <td style="text-align: center;">
                                        <span class="qty-pill">+${ir.quantity}</span>
                                    </td>
                                    <td style="text-align: center;">
                                        <c:choose>
                                            <c:when test="${ir.status == 1}">
                                                <span class="status-badge pending">
                                                    <span class="material-symbols-outlined" style="font-size: 15px;">schedule</span>
                                                    Chờ xử lý
                                                </span>
                                            </c:when>
                                            <c:when test="${ir.status == 2}">
                                                <span class="status-badge imported">
                                                    <span class="material-symbols-outlined" style="font-size: 15px;">check_circle</span>
                                                    Đã nhập kho
                                                </span>
                                            </c:when>
                                            <c:when test="${ir.status == 3}">
                                                <span class="status-badge cancelled">
                                                    <span class="material-symbols-outlined" style="font-size: 15px;">cancel</span>
                                                    Đã hủy
                                                </span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td style="font-weight: 700;">
                                        <c:out value="${ir.createdByName}"/>
                                    </td>
                                    <td style="color: var(--muted); font-size: 13px;">
                                        <fmt:formatDate value="${ir.createdDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td style="text-align: center; padding-right: 24px;">
                                        <a href="${pageContext.request.contextPath}/import-request-detail?id=${ir.importId}" class="btn-action-view">
                                            <span class="material-symbols-outlined" style="font-size: 16px;">visibility</span>
                                            Xem chi tiết
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination Bar -->
                <c:if test="${totalPages > 1}">
                    <div class="pagination-wrapper">
                        <div style="color: var(--muted); font-size: 13px; font-weight: 700;">
                            Hiển thị trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong>
                        </div>
                        <div class="pagination-btns">
                            <c:if test="${currentPage > 1}">
                                <a href="${pageContext.request.contextPath}/import-request-list?page=${currentPage - 1}&search=<c:out value="${searchText}"/>" class="page-link-btn">
                                    <span class="material-symbols-outlined">chevron_left</span>
                                </a>
                            </c:if>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <a href="${pageContext.request.contextPath}/import-request-list?page=${i}&search=<c:out value="${searchText}"/>" class="page-link-btn ${i == currentPage ? 'active' : ''}">
                                    ${i}
                                </a>
                            </c:forEach>
                            <c:if test="${currentPage < totalPages}">
                                <a href="${pageContext.request.contextPath}/import-request-list?page=${currentPage + 1}&search=<c:out value="${searchText}"/>" class="page-link-btn">
                                    <span class="material-symbols-outlined">chevron_right</span>
                                </a>
                            </c:if>
                        </div>
                    </div>
                </c:if>
            </main>
        </div>
    </body>
</html>
