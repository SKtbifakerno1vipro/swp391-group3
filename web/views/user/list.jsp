<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>User List</title>
    </head>
    <body>
        <h2>User List</h2>
        <p>This screen show user list for purpose of viewing all users in the system (Admin, Manager, Sale, Provider, Customer), filtering by roles or status, and managing system access effectively.</p>

        <form method="get" action="user">
            <input type="hidden" name="action" value="list" />
            Role ID: <input type="text" name="roleId"  value="${roleId}"/>
            Status:
            <select name="status">
                <option value="">All</option>
                <option value="Active"${status =='Active' ? 'selected' : ''} >Active</option>
                <option value="Inactive" ${status =='Inactive' ? 'selected' : ''}>Inactive</option>
            </select>
            <button type="submit">Filter</button>
        </form>

        <p><a href="user?action=create">Create New User</a></p>

        <table border="1" cellpadding="5" cellspacing="0">
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

            <c:forEach items="${users}" var="u">
                <tr>
                    <td>${u.userId}</td>
                    <td>${u.userName}</td>
                    <td>${u.email}</td>
                    <td>${u.fullName}</td>
                    <td>${u.phone}</td>
                    <td>${u.status}</td>
                    <td>${u.roleId}</td>
                    <td>
                        <a href="user?action=view&id=${u.userId}">View</a> |
                        <a href="user?action=edit&id=${u.userId}">Edit</a>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty users}">
                <tr>
                    <td colspan="8">No users found.</td>
                </tr>
            </c:if>
        </table>
    </body>
</html>
