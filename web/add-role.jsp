<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm mới nhóm quyền</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .form-container { max-width: 400px; padding: 20px; border: 1px solid #ccc; border-radius: 5px; background: #fafafa; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input { width: 100%; padding: 8px; box-sizing: border-box; }
        .btn { padding: 10px 15px; background: #007bff; color: white; border: none; cursor: pointer; border-radius: 3px; }
        .btn-cancel { background: #6c757d; text-decoration: none; padding: 10px 15px; color: white; border-radius: 3px; margin-left: 10px; display: inline-block; }
        .error { color: red; margin-bottom: 15px; }
    </style>
</head>
<body>

    <div class="form-container">
        <h2>Thêm Nhóm Quyền Mới</h2>
        
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/add-role" method="POST">
            <div class="form-group">
                <label for="roleName">Tên nhóm quyền (Role Name):</label>
                <input type="text" id="roleName" name="roleName" required placeholder="Ví dụ: Manager, Staff...">
            </div>
            
            <button type="submit" class="btn">Thêm mới</button>
            <a href="${pageContext.request.contextPath}/role-list" class="btn-cancel">Hủy bỏ</a>
        </form>
    </div>

</body>
</html>