<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết Role - ${role.roleName}</title>
</head>
<body>
    <h2>Chi tiết Role</h2>
    <p><a href="${pageContext.request.contextPath}/role-list">&larr; Quay lại danh sách</a></p>

    <!-- VIEW MODE -->
    <c:if test="${param.mode != 'edit'}">
        <div>
            <p><strong>Role ID:</strong> R-${role.roleId}</p>
            <p><strong>Role Name:</strong> ${role.roleName}</p>
            <p><strong>Created At:</strong> ${role.createAt != null ? role.createAt : '-'}</p>
            <p><strong>Updated At:</strong> ${role.updateAt != null ? role.updateAt : '-'}</p>
            
            <h3>Permissions</h3>
            <ul>
                <c:if test="${empty role.permissions}">
                    <li>Chưa có quyền nào</li>
                </c:if>
                <c:forEach var="p" items="${role.permissions}">
                    <li>${p.permissionName}</li>
                </c:forEach>
            </ul>
            
            <a href="${pageContext.request.contextPath}/role-detail?roleId=${role.roleId}&mode=edit">
                <button type="button">Chỉnh sửa</button>
            </a>
        </div>
    </c:if>
    
    <!-- EDIT MODE -->
    <c:if test="${param.mode == 'edit'}">
        <form action="${pageContext.request.contextPath}/role-detail" method="POST">
            <input type="hidden" name="roleId" value="${role.roleId}">
            
            <div>
                <label>Role ID:</label>
                <input type="text" value="R-${role.roleId}" readonly>
            </div>
            
            <div>
                <label>Role Name:</label>
                <input type="text" name="roleName" value="${role.roleName}" required>
            </div>
            
            <div>
                <label>Created At:</label>
                <input type="text" value="${role.createAt != null ? role.createAt : '-'}" readonly>
            </div>
            
            <div>
                <label>Updated At:</label>
                <input type="text" value="${role.updateAt != null ? role.updateAt : '-'}" readonly>
            </div>
            
            <c:if test="${not empty error}">
                <p style="color: red;">${error}</p>
            </c:if>
            
            <button type="submit">Lưu thay đổi</button>
            <a href="${pageContext.request.contextPath}/role-detail?roleId=${role.roleId}">
                <button type="button">Hủy</button>
            </a>
        </form>
    </c:if>
</body>
</html>