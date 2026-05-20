<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Form</title>
</head>
<body>
<c:choose>
    <c:when test="${empty u}">
        <h2>Create User</h2>
        <p>This screen show create user form for purpose of allowing administrators to add new users to the system, assign appropriate roles (like Sale, Manager, or Admin), and set up initial account credentials.</p>
    </c:when>
    <c:otherwise>
        <h2>Edit User</h2>
        <p>This screen show edit user form for purpose of updating an existing user's information, modifying their contact details, changing their access roles, or updating their account status (e.g., Active/Inactive).</p>
    </c:otherwise>
</c:choose>

<form action="user" method="post">
    <input type="hidden" name="userId" value="${u.userId}" />

    <p>
        Username:<br/>
        <input type="text" name="userName" value="${u.userName}" <c:if test="${not empty u}">readonly="readonly"</c:if> required />
    </p>

    <p>
        Password:<br/>
        <input type="password" name="password" <c:if test="${empty u}">required</c:if> />
        <br/><small>(Khi edit, có thể để trống nếu không muốn đổi - bản đơn giản hiện tại vẫn nhận giá trị submit)</small>
    </p>

    <p>
        Email:<br/>
        <input type="email" name="email" value="${u.email}" required />
    </p>

    <p>
        Full Name:<br/>
        <input type="text" name="fullName" value="${u.fullName}" />
    </p>

    <p>
        Phone:<br/>
        <input type="text" name="phone" value="${u.phone}" />
    </p>

    <p>
        Role ID:<br/>
        <input type="number" name="roleId" value="${u.roleId}" required />
    </p>

    <p>
        Status:<br/>
        <select name="status">
            <option value="Active" <c:if test="${u.status eq 'Active'}">selected</c:if>>Active</option>
            <option value="Inactive" <c:if test="${u.status eq 'Inactive'}">selected</c:if>>Inactive</option>
        </select>
    </p>

    <p>
        <button type="submit">Save</button>
        <a href="user?action=list">Cancel</a>
    </p>
</form>
</body>
</html>
