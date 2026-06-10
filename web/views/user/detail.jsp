<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Edit User</title>
    </head>
    <body>
        <h1>Edit User</h1>

        <c:if test="${not empty error}"><p style="color: red">${error}</p></c:if>

            <form action="edit-user" method="post">
                <input type="hidden" name="id" value="${u.userId}">

            <table border="0">
                <tr>
                    <td>Username:</td>
                    <td><input type="text" name="userName" value="${u.userName}" readonly></td>
                </tr>
                <tr>
                    <td>Full Name:</td>
                    <td><input type="text" name="fullName" value="${u.fullName}" required minlength="4" maxlength="50"></td>
                </tr>
                <tr>
                    <td>Email:</td>
                    <td><input type="email" name="email" value="${u.email}" required></td>
                </tr>
                <tr>
                    <td>Phone:</td>
                    <td><input type="text" name="phone" value="${u.phone}" required pattern="^0[0-9]{9}$"></td>
                </tr>
                <tr>
                    <td>Address:</td>
                    <td><input type="text" name="address" value="${u.address}"></td>
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
                <tr>
                    <td>Role:</td>
                    <td>
                        <select name="roleId">
                            <c:forEach var="r" items="${roles}">
                                <option value="${r.roleId}" ${u.roleId == r.roleId ? 'selected' : ''}>${r.roleName}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>Status:</td>
                    <td>
                        <select name="status">
                            <option value="ACTIVE" ${u.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                            <option value="INACTIVE" ${u.status == 'INACTIVE' ? 'selected' : ''}>INACTIVE</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>Created By:</td>
                    <td><input type="text" name="createdBy" value="${u.createdBy}" readonly></td>
                </tr>
                <tr>
                    <td>Updated By:</td>
                    <td><input type="text" name="updatedBy" value="${u.updatedBy}" readonly></td>
                </tr>
                <tr>
                    <td colspan="2" style="padding-top: 15px;">
                        <button type="submit">Save Changes</button>
                        <a href="user-list">Back to List</a>
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>
