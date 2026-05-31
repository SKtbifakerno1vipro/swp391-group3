<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Edit Role Permissions</title>
</head>
<body>

    <h2>Edit Permissions for Role: ${role.roleName}</h2>

    <p>
        <a href="${pageContext.request.contextPath}/role-detail?roleId=${role.roleId}">
            Back to Role Detail
        </a>
    </p>

    <form action="${pageContext.request.contextPath}/edit-role-permissions" method="post">
        <input type="hidden" name="roleId" value="${role.roleId}">

        <table border="1" cellpadding="8" cellspacing="0">
            <thead>
                <tr>
                    <th>Permission ID</th>
                    <th>Permission Name</th>
                    <th>Enabled</th>
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
                                   value="${permission.permissionId}"
                                   <c:if test="${selectedPermissionIds.contains(permission.permissionId)}">checked</c:if>>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <br>

        <button type="submit">Save Permissions</button>
        <a href="${pageContext.request.contextPath}/role-detail?roleId=${role.roleId}">
            Cancel
        </a>
    </form>

</body>
</html>