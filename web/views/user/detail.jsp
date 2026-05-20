<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Detail</title>
</head>
<body>
<h2> User Detail</h2>
<p>This screen show user detail for purpose of viewing complete profile information of a specific user, including their role, contact details (email, phone), status, and associated account histories.</p>

<c:choose>
    <c:when test="${not empty u}">
        <p><b>ID:</b> ${u.userId}</p>
        <p><b>Username:</b> ${u.userName}</p>
        <p><b>Email:</b> ${u.email}</p>
        <p><b>Full Name:</b> ${u.fullName}</p>
        <p><b>Phone:</b> ${u.phone}</p>
        <p><b>Status:</b> ${u.status}</p>
        <p><b>Role ID:</b> ${u.roleId}</p>
    </c:when>
    <c:otherwise>
        <p>User not found.</p>
    </c:otherwise>
</c:choose>

<p>
    <a href="user?action=edit&id=${u.userId}">Edit this user</a> |
    <a href="user?action=list">Back to User List</a>
</p>
</body>
</html>
