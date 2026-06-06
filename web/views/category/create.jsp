<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm danh mục</title>
</head>
<body>
    <h2>Thêm danh mục mới</h2>

    <c:if test="${not empty error}">
        <div style="color: red; margin-bottom: 10px;">${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/category/create" method="POST">
        <div style="margin-bottom: 10px;">
            <label for="categoryName">Tên danh mục:</label><br/>
            <input type="text"
                   id="categoryName"
                   name="categoryName"
                   value="${categoryName}"
                   required
                   placeholder="Ví dụ: Bánh mì, Bánh ngọt...">
        </div>

        <button type="submit">Thêm mới</button>
        <a href="${pageContext.request.contextPath}/category/list">Hủy</a>
    </form>
</body>
</html>
