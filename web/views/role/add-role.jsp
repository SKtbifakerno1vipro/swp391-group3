<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm mới nhóm quyền</title>
</head>
<body>

    <div>
        <h2>Thêm Nhóm Quyền Mới</h2>

        <c:if test="${not empty error}">
            <div>${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/add-role" method="POST">
            <div>
                <label for="roleName">Tên nhóm quyền (Role Name):</label>
                <input type="text" id="roleName" name="roleName" required placeholder="Ví dụ: Manager, Staff...">
            </div>

            <button type="submit">Thêm mới</button>
            <a href="${pageContext.request.contextPath}/role-list">Hủy bỏ</a>
        </form>
    </div>

</body>
</html>
