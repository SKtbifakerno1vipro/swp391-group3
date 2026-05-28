     <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User List</title>
</head>
<body>

<div>
    <h1>User List</h1>

    <form method="get" action="${pageContext.request.contextPath}/user-list">
        <label for="roleId">Role ID</label>
        <input id="roleId" type="text" name="roleId" value="${roleId}" placeholder="Enter role id" />

        <label for="status">Status</label>
        <select id="status" name="status">
            <option value="" ${empty status ? 'selected' : ''}>All</option>
            <option value="Active" ${status == 'Active' ? 'selected' : ''}>Active</option>
            <option value="Inactive" ${status == 'Inactive' ? 'selected' : ''}>Inactive</option>
        </select>

        <button type="submit">Filter</button>
    </form>

    <p><a href="${pageContext.request.contextPath}/create-user">Create New User</a></p>

    <table border="1" cellpadding="6" cellspacing="0">
        <thead>
            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Email</th>
                <th>Full Name</th>
                <th>Phone</th>
                <th>Status</th>
                <th>Role ID</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty users}">
                    <tr>
                        <td colspan="8">No users found.</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="u" items="${users}">
                        <tr>
                            <td>${u.userId}</td>
                            <td>${u.userName}</td>
                            <td>${u.email}</td>
                            <td>${u.fullName}</td>
                            <td>${u.phone}</td>
                            <td>${u.status}</td>
                            <td>${u.roleId}</td>
                            <td>
                                
                                <a href="${pageContext.request.contextPath}/edit-user?id=${u.userId}">Edit</a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

</body>
</html>
