<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pơ Bread - Role Management</title>
</head>
<body>
    <h2>Role Management</h2>
    <p><a href="${pageContext.request.contextPath}/add-role">Add Role</a></p>

    <table border="1" cellpadding="6" cellspacing="0">
        <thead>
            <tr>
                <th>Role ID</th>
                <th>Role Name</th> 
                <th>Created At</th>
                <th>Updated At</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:if test="${empty roleList}">
                <tr>
                    <td colspan="5">No roles found.</td>
                </tr>
            </c:if>

            <c:forEach var="role" items="${roleList}">
                <tr>
                    <td>R-${role.roleId}</td>
                    <td>${role.roleName}</td>
                    <td>${role.createAt}</td>
                    <td>${role.updateAt}</td>                   
                    <td>
                        <a href="${pageContext.request.contextPath}/role-detail?roleId=${role.roleId}">View</a>
                        <a href="${pageContext.request.contextPath}/edit-role-permissions?roleId=${role.roleId}">Permissions</a>
                    </td>
                    
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>
    