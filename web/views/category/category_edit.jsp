<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Edit Category</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
    </head>
<body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="categories"/>
            </jsp:include>
            <main class="main legacy-page">
    <h2>Edit Category</h2>

    <c:if test="${not empty error}">
        <div style="color: red; margin-bottom: 10px;">${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/category/edit" method="POST">
        <input type="hidden" name="categoryId" value="${category.categoryId}">

        <div style="margin-bottom: 10px;">
            <label for="categoryName">Category Name:</label><br/>
            <input type="text"
                   id="categoryName"
                   name="categoryName"
                   value="${category.categoryName}"
                   required>
        </div>

        <button type="submit">Update</button>
        <a href="${pageContext.request.contextPath}/category/list">Cancel</a>
    </form>

            </main>
        </div>
    </body>
</html>
