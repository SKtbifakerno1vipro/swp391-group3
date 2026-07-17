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
            </style>

            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link
                href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap"
                rel="stylesheet">
            <link
                href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block"
                rel="stylesheet">
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
                    <c:if test="${param.status == 'delete_in_use'}">
                        <div style="color: red; margin-bottom: 10px;">Không thể xóa: Danh mục vẫn còn chứa sản phẩm.
                        </div>
                    </c:if>
                    <c:if test="${param.status == 'not_found'}">
                        <div style="color: red; margin-bottom: 10px;">Không tìm thấy danh mục!</div>
                    </c:if>
                    <c:if test="${param.status == 'delete_failed' || param.status == 'edit_failed'}">
                        <div style="color: red; margin-bottom: 10px;">Thao tác thất bại! Vui lòng thử lại.</div>
                    </c:if>

                    <div style="margin-bottom: 15px;">
                        <c:if test="${sessionScope.user.roleId == 1 || sessionScope.user.roleId == 4 || sessionScope.user.roleId == 6}">
                            <a href="${pageContext.request.contextPath}/category/create">Thêm danh mục</a> |
                        </c:if>
                        <a href="${pageContext.request.contextPath}/product-list">Sản phẩm</a>
                    </div>

                    <table>
                        <thead>
                            <tr>
                                <th>Mã danh mục</th>
                                <th>Tên danh mục</th>
                                <c:if test="${sessionScope.user.roleId == 1 || sessionScope.user.roleId == 4 || sessionScope.user.roleId == 6}">
                                    <th>Hành động</th>
                                </c:if>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty categoryList}">
                                <tr>
                                    <td colspan="${sessionScope.user.roleId == 1 || sessionScope.user.roleId == 4 || sessionScope.user.roleId == 6 ? 3 : 2}">Không tìm thấy danh mục nào.</td>
                                </tr>
                            </c:if>

                            <c:forEach var="category" items="${categoryList}">
                                <tr>
                                    <td>${category.categoryId}</td>
                                    <td>${category.categoryName}</td>
                                    <c:if test="${sessionScope.user.roleId == 1 || sessionScope.user.roleId == 4 || sessionScope.user.roleId == 6}">
                                        <td>
                                            <a href="${pageContext.request.contextPath}/category/edit?categoryId=${category.categoryId}">Sửa</a> |
                                            <a href="${pageContext.request.contextPath}/category/delete?categoryId=${category.categoryId}"
                                                onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục này không?');">Xóa</a>
                                        </td>
                                    </c:if>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                </main>
            </div>
        </body>

        </html>