<%-- 
    Document   : CreateCustomer
    Created on : May 21, 2026
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Customer</title>
    </head>
    <body>
        <div>
            <h2>Create Customer with User</h2>
            <c:if test="${not empty success}">
                <div>Create successful</div>
            </c:if>
            <c:if test="${not empty error}">
                <div>Create failed</div>
                <c:if test="${not empty errorDetail}">
                    <div>${errorDetail}</div>
                </c:if>
            </c:if>
            <form action="CreateCustomer" method="post">
                <table>
                    <tr>
                        <td>Username:</td>
                        <td><input type="text" name="username" required /></td>
                    </tr>
                    <tr>
                        <td>Password:</td>
                        <td><input type="password" name="password" required /></td>
                    </tr>
                    <tr>
                        <td>Email:</td>
                        <td><input type="email" name="email" required /></td>
                    </tr>
                    <tr>
                        <td>Full Name:</td>
                        <td><input type="text" name="fullname" /></td>
                    </tr>
                    <tr>
                        <td>Phone:</td>
                        <td><input type="text" name="phone" /></td>
                    </tr>
                    <tr>
                        <td>Status:</td>
                        <td>
                            <select name="status">
                                <option value="Active" selected>Active</option>
                                <option value="Inactive">Inactive</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>Role:</td>
                        <td>
                            <input type="hidden" name="roleId" value="${customerRoleId}" />
                            Customer
                        </td>
                    </tr>
                    <tr>
                        <td>Tax Code:</td>
                        <td><input type="text" name="taxCode" required /></td>
                    </tr>
                    <tr>
                        <td>Type:</td>
                        <td><input type="text" name="type" required /></td>
                    </tr>
                    <tr>
                        <td>Created By:</td>
                        <td>
                            <select name="createBy" required>
                                <option value="">Choose staff</option>
                                <c:forEach var="user" items="${users}">
                                    <option value="${user.userId}">${user.fullName != null && !user.fullName.isEmpty() ? user.fullName : user.userName}</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td><button type="submit">Create</button></td>
                    </tr>
                </table>
            </form>
        </div>
    </body>
</html>
