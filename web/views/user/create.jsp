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
                        <td><input type="text" name="userName" value="${u.userName}" required minlength="4" maxlength="20"
                               pattern="^[a-zA-Z0-9_]{4,20}$"
                               title="Username từ 4-20 ký tự, chỉ chứa chữ, số và gạch dưới (không khoảng trắng)."
                               ></td>
                </tr>
                <tr>
                    <td>Password:</td>
                    <td><input type="password" name="password" required minlength="4" maxlength="20"></td>
                </tr>
                <tr>
                    <td>Full Name:</td>
                    <td><input type="text" name="fullName" value="${u.fullName}" required 
                               minlength="4" maxlength="50"></td>
                </tr>
                <tr>
                    <td>Email:</td>
                    <td><input type="email" name="email" value="${u.email}" required
                               required minlength="4" maxlength="50" 
                               ></td>
                </tr>
                <tr>
                    <td>Phone:</td>
                    <td><input type="tel" name="phone" value="${u.phone}" required
                               pattern="^0[0-9]{9}$"
                               title="Số điện thoại phải bắt đầu bằng số 0 và có đúng 10 chữ số.">
                    </td>
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
                <tr><td>Role:</td>
                    <td>
                        <select name="roleId">
                            <c:forEach var="r" items="${roles}">
                                <option value="${r.roleId}" ${u.roleId == r.roleId ? 'selected' : ''}>${r.roleName}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td><button type="submit">Create Account</button> <a href="user-list">Cancel</a></td>
                </tr>
            </table>
        </form>
    </body>
</html>
