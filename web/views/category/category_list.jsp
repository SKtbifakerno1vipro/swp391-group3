<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Danh sách danh mục</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        th,
        td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
        }

        .pagination-container a,
        .pagination-container span,
        .pagination-container strong {
            margin: 0 4px;
            padding: 5px 10px;
            text-decoration: none;
            border-radius: 6px;
        }

        .pagination-container a {
            border: 1px solid #ddd;
            color: var(--primary, #007bff);
            font-weight: 800;
        }

        .pagination-container strong {
            border: 1px solid var(--primary, #007bff);
            background-color: var(--primary, #007bff);
            color: white;
        }
    </style>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
</head>

<body>
    <div class="dashboard-shell">
        <jsp:include page="/views/shared/sidebar.jsp">
            <jsp:param name="activeMenu" value="categories" />
        </jsp:include>
        <main class="main legacy-page">
            <h2>Quản lý danh mục</h2>

            <c:if test="${param.status == 'add_success'}">
                <div style="color: green; margin-bottom: 10px;">Thêm danh mục thành công!</div>
            </c:if>
            <c:if test="${param.status == 'edit_success'}">
                <div style="color: green; margin-bottom: 10px;">Cập nhật danh mục thành công!</div>
            </c:if>
            <c:if test="${param.status == 'delete_success'}">
                <div style="color: green; margin-bottom: 10px;">Xóa danh mục thành công!</div>
            </c:if>
            <c:if test="${param.status == 'restore_success'}">
                <div style="color: green; margin-bottom: 10px;">Khôi phục danh mục thành công!</div>
            </c:if>
            <c:if test="${param.status == 'restore_failed'}">
                <div style="color: red; margin-bottom: 10px;">Khôi phục danh mục thất bại!</div>
            </c:if>
            <c:if test="${param.status == 'delete_in_use'}">
                <div style="color: red; margin-bottom: 10px;">Không thể xóa: Danh mục vẫn còn chứa sản phẩm.</div>
            </c:if>
            <c:if test="${param.status == 'not_found'}">
                <div style="color: red; margin-bottom: 10px;">Không tìm thấy danh mục!</div>
            </c:if>
            <c:if test="${param.status == 'delete_failed' || param.status == 'edit_failed'}">
                <div style="color: red; margin-bottom: 10px;">Thao tác thất bại! Vui lòng thử lại.</div>
            </c:if>

            <div style="margin-bottom: 15px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px;">
                <form action="${pageContext.request.contextPath}/category/list" method="GET" style="display: flex; gap: 8px; align-items: center; flex-wrap: wrap;">
                    <input type="text" name="searchName" value="<c:out value='${searchName}'/>" placeholder="Nhập tên danh mục để tìm..." style="padding: 8px 12px; border: 1px solid #ccc; border-radius: 8px; font-size: 14px; width: 220px;" />
                    
                    <select name="statusFilter" style="padding: 8px 12px; border: 1px solid #ccc; border-radius: 8px; font-size: 14px;">
                        <option value="1" ${statusFilter == 1 ? 'selected' : ''}>Đang hoạt động</option>
                        <option value="0" ${statusFilter == 0 ? 'selected' : ''}>Đã xóa</option>
                        <option value="-1" ${statusFilter == -1 ? 'selected' : ''}>-- Tất cả --</option>
                    </select>

                    <button type="submit" style="padding: 8px 16px; background-color: var(--primary, #4a7c59); color: white; border: none; border-radius: 8px; font-weight: bold; cursor: pointer;">Tìm kiếm</button>
                    <a href="${pageContext.request.contextPath}/category/list" style="padding: 8px 16px; background-color: #eee; color: #333; text-decoration: none; border-radius: 8px; font-weight: bold;">Đặt lại</a>
                </form>

                <div>
                    <c:if test="${sessionScope.user.roleId == 1 || sessionScope.user.roleId == 4 || sessionScope.user.roleId == 6}">
                        <a href="${pageContext.request.contextPath}/category/create" style="font-weight: bold; margin-right: 8px;">+ Thêm danh mục</a> |
                    </c:if>
                    <a href="${pageContext.request.contextPath}/product-list">Xem sản phẩm</a>
                </div>
            </div>

            <table>
                <thead>
                    <tr>
                        <th style="width: 120px;">Mã danh mục</th>
                        <th>Tên danh mục</th>
                        <th style="width: 150px;">Số sản phẩm</th>
                        <th style="width: 120px;">Trạng thái</th>
                        <c:if test="${sessionScope.user.roleId == 1 || sessionScope.user.roleId == 4 || sessionScope.user.roleId == 6}">
                            <th style="width: 140px;">Hành động</th>
                        </c:if>
                    </tr>
                </thead>
                <tbody>
                    <c:set var="canManage" value="${sessionScope.user.roleId == 1 || sessionScope.user.roleId == 4 || sessionScope.user.roleId == 6}" />
                    <c:if test="${empty categoryList}">
                        <tr>
                            <td colspan="${canManage ? 5 : 4}" style="text-align: center; padding: 16px;">Không tìm thấy danh mục nào.</td>
                        </tr>
                    </c:if>

                    <c:forEach var="category" items="${categoryList}">
                        <tr>
                            <td>${category.categoryId}</td>
                            <td><strong><c:out value="${category.categoryName}"/></strong></td>
                            <td><span style="font-weight: 800; color: var(--primary, #4a7c59);">${category.totalProduct}</span> sản phẩm</td>
                            <td>
                                <c:choose>
                                    <c:when test="${category.status == 1}">
                                        <span style="color: green; font-weight: 700;">Hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: red; font-weight: 700;">Đã xóa</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <c:if test="${canManage}">
                                <td>
                                    <c:choose>
                                        <c:when test="${category.status == 1}">
                                            <a href="${pageContext.request.contextPath}/category/edit?categoryId=${category.categoryId}" style="color: #0b5ed7; font-weight: 700; text-decoration: none; margin-right: 6px;">Sửa</a>
                                            <span style="color: #ccc;">|</span>
                                            <a href="${pageContext.request.contextPath}/category/edit?action=delete&categoryId=${category.categoryId}"
                                                onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục này không?');" style="color: #dc3545; font-weight: 700; text-decoration: none; margin-left: 6px;">Xóa</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/category/edit?action=restore&categoryId=${category.categoryId}"
                                                onclick="return confirm('Bạn có chắc chắn muốn khôi phục danh mục này không?');" style="color: #198754; font-weight: 800; text-decoration: none;">Khôi phục</a>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </c:if>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <c:set var="currentPage" value="${empty currentPage ? 1 : currentPage}" />
            <c:set var="totalPages" value="${empty totalPages ? 1 : totalPages}" />

            <c:if test="${totalPages > 1}">
                <div class="pagination-container" style="margin-top: 20px; text-align: center;">
                    <c:choose>
                        <c:when test="${currentPage > 1}">
                            <c:url var="prevUrl" value="/category/list">
                                <c:param name="page" value="${currentPage - 1}" />
                                <c:param name="searchName" value="${searchName}" />
                                <c:param name="statusFilter" value="${statusFilter}" />
                            </c:url>
                            <a href="${prevUrl}">&lt;</a>
                        </c:when>
                        <c:otherwise>
                            <span style="color: #999; border: 1px solid #ddd; padding: 5px 10px;">&lt;</span>
                        </c:otherwise>
                    </c:choose>

                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <strong>${i}</strong>
                            </c:when>
                            <c:otherwise>
                                <c:url var="pageUrl" value="/category/list">
                                    <c:param name="page" value="${i}" />
                                    <c:param name="searchName" value="${searchName}" />
                                    <c:param name="statusFilter" value="${statusFilter}" />
                                </c:url>
                                <a href="${pageUrl}">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <c:choose>
                        <c:when test="${currentPage < totalPages}">
                            <c:url var="nextUrl" value="/category/list">
                                <c:param name="page" value="${currentPage + 1}" />
                                <c:param name="searchName" value="${searchName}" />
                                <c:param name="statusFilter" value="${statusFilter}" />
                            </c:url>
                            <a href="${nextUrl}">&gt;</a>
                        </c:when>
                        <c:otherwise>
                            <span style="color: #999; border: 1px solid #ddd; padding: 5px 10px;">&gt;</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>

        </main>
    </div>
</body>

</html>