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
                    <h2>Manage Categories</h2>

                    <c:if test="${param.status == 'add_success'}">
                        <div style="color: green; margin-bottom: 10px;">Category added successfully!</div>
                    </c:if>
                    <c:if test="${param.status == 'edit_success'}">
                        <div style="color: green; margin-bottom: 10px;">Category updated successfully!</div>
                    </c:if>
                    <c:if test="${param.status == 'delete_success'}">
                        <div style="color: green; margin-bottom: 10px;">Category deleted successfully!</div>
                    </c:if>
                    <c:if test="${param.status == 'delete_in_use'}">
                        <div style="color: red; margin-bottom: 10px;">Cannot delete: Category still contains products.
                        </div>
                    </c:if>
                    <c:if test="${param.status == 'not_found'}">
                        <div style="color: red; margin-bottom: 10px;">Category not found!</div>
                    </c:if>
                    <c:if test="${param.status == 'delete_failed' || param.status == 'edit_failed'}">
                        <div style="color: red; margin-bottom: 10px;">Operation failed! Please try again.</div>
                    </c:if>

                    <div style="margin-bottom: 15px;">
                        <a href="${pageContext.request.contextPath}/category/create">Add Category</a> |
                        <a href="${pageContext.request.contextPath}/product-list">Products</a>
                    </div>

                    <table>
                        <thead>
                            <tr>
                                <th>Category ID</th>
                                <th>Category Name</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty categoryList}">
                                <tr>
                                    <td colspan="3">No categories found.</td>
                                </tr>
                            </c:if>

                            <c:forEach var="category" items="${categoryList}">
                                <tr>
                                    <td>${category.categoryId}</td>
                                    <td>${category.categoryName}</td>
                                    <td>
                                        <a
                                            href="${pageContext.request.contextPath}/category/edit?categoryId=${category.categoryId}">Edit</a>
                                        <a href="${pageContext.request.contextPath}/category/delete?categoryId=${category.categoryId}"
                                            onclick="return confirm('Are you sure you want to delete this category?');">Delete</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                </main>
            </div>
        </body>

        </html>