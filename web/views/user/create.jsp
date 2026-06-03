<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Create User</title>
    </head>
    <body>
        <h1>Create New User</h1>
        <c:if test="${not empty error}"><p style="color: red">${error}</p></c:if>
            <form action="create-user" method="post">
                <table border="0">
                    <tr>
                        <td>Username:</td>
                        <td><input type="text" name="userName" value="${u.userName}" required></td>
                </tr>
                <tr>
                    <td>Password:</td>
                    <td><input type="password" name="password" required></td>
                </tr>
                <tr>
                    <td>Full Name:</td>
                    <td><input type="text" name="fullName" value="${u.fullName}" required></td>
                </tr>
                <tr>
                    <td>Email:</td>
                    <td><input type="email" name="email" value="${u.email}" required></td>
                </tr>
                <tr>
                    <td>Phone:</td>
                    <td><input type="text" name="phone" value="${u.phone}" required></td>
                </tr>
                <tr>
                    <td>Gender:</td>
                    <td>
                        <select name="gender">
                            <option value="M" ${u.gender == 'M' ? 'selected' : ''}>Male</option>
                            <option value="F" ${u.gender == 'F' ? 'selected' : ''}>Female</option>
                            <option value="O" ${u.gender == 'O' ? 'selected' : ''}>Other</option>
                        </select>
                    </td>
                </tr>
                <tr><td>Role:</td><td>
                        <select name="roleId">
                            <c:forEach var="r" items="${roles}">
                                <option value="${r.roleId}" ${u.roleId == r.roleId ? 'selected' : ''}>${r.roleName}</option>
                            </c:forEach>
                        </select>
                    </td></tr>
                <tr>
                    <td colspan="2"><button type="submit">Create Account</button> <a href="user-list">Cancel</a></td>
                </tr>
            </table>
        </form>
    </body>
</html>
