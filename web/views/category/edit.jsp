<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Sửa danh mục</title>
</head>
<body>
    <h2>Sửa danh mục</h2>

    <c:if test="${not empty error}">
        <div style="color: red; margin-bottom: 10px;">${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/edit-category" method="POST">
        <input type="hidden" name="categoryId" value="${category.categoryId}">

        <div style="margin-bottom: 10px;">
            <label for="categoryName">Tên danh mục:</label><br/>
            <input type="text"
                   id="categoryName"
                   name="categoryName"
                   value="${category.categoryName}"
                   required>
        </div>

        <button type="submit">Cập nhật</button>
        <a href="${pageContext.request.contextPath}/category-list">Hủy</a>
    </form>
</body>
</html>
