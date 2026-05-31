<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
            <div style="color: red;">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/add-role" method="POST">
            
            <div>
                <label for="roleName">Tên nhóm quyền (Role Name):</label>
                <input type="text" 
                       id="roleName" 
                       name="roleName" 
                       value="${roleName}"
                       required 
                       placeholder="Ví dụ: Manager, Staff...">
            </div>

            <h3>Chọn Permissions</h3>
            
            <table border="1" cellpadding="8" cellspacing="0">
                <thead>
                    <tr>
                        <th>Permission ID</th>
                        <th>Permission Name</th>
                        <th>Chọn</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="permission" items="${permissionList}">
                        <tr>
                            <td>${permission.permissionId}</td>
                            <td>${permission.permissionName}</td>
                            <td>
                                <input type="checkbox"
                                       name="permissionIds"
                                       value="${permission.permissionId}">
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <br>

            <button type="submit">Thêm mới</button>
            <a href="${pageContext.request.contextPath}/role-list">Hủy bỏ</a>
        </form>
    </div>

</body>
</html>