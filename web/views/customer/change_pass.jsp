<%-- 
    Document   : change_pass
    Created on : Jun 3, 2026, 1:18:42 PM
    Author     : XHieu
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đổi Mật Khẩu</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 50px; }
        .form-container { max-width: 400px; margin: 0 auto; padding: 20px; border: 1px solid #ccc; border-radius: 5px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
        .form-group input { width: 100%; padding: 8px; box-sizing: border-box; }
        .btn-submit { background-color: #4CAF50; color: white; padding: 10px 15px; border: none; border-radius: 3px; cursor: pointer; width: 100%; }
        .btn-submit:hover { background-color: #45a049; }
        .error { color: red; margin-bottom: 15px; }
        .success { color: green; margin-bottom: 15px; }
    </style>
</head>
<body>

<div class="form-container">
    <h2>Đổi Mật Khẩu</h2>

    <%-- Hiển thị thông báo lỗi nếu có --%>
    <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="error"><%= request.getAttribute("errorMessage") %></div>
    <% } %>

    <%-- Hiển thị thông báo thành công nếu có --%>
    <% if (request.getAttribute("successMessage") != null) { %>
        <div class="success"><%= request.getAttribute("successMessage") %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/change-password" method="POST">
        <div class="form-group">
            <label for="currentPassword">Mật khẩu hiện tại:</label>
            <input type="password" id="currentPassword" name="currentPassword" required>
        </div>

        <div class="form-group">
            <label for="newPassword">Mật khẩu mới:</label>
            <input type="password" id="newPassword" name="newPassword" required>
        </div>

        <div class="form-group">
            <label for="confirmPassword">Nhập lại mật khẩu mới:</label>
            <input type="password" id="confirmPassword" name="confirmPassword" required>
        </div>

        <button type="submit" class="btn-submit">Cập nhật mật khẩu</button>
    </form>
</div>

</body>
</html>