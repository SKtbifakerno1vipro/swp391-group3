<%-- 
    Document   : create
    Created on : May 29, 2026, 10:53:57 PM
    Author     : omovi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Create User</h1>
        <c:if test="${not empty error}">
            <p style="color:red">${error}</p>
        </c:if>
        <form action="create-user" method="post">
            <table>
                <tr>
                    <td>User name: </td>
                    <td><input type="text" name="userName" value="${u.userName}" required maxlength="50" minlength="4"></td>
                </tr>

                <tr>
                    <td>Password:</td>
                    <td><input type="password" name="password" value="${u.password}" required maxlength="50" minlength="4"></td>
                </tr>

                <tr>
                    <td>Email:  </td>
                    <td><input type="email" name="email" value="${u.email}"></td>
                </tr>

                <tr>
                    <td>Full Name:   </td>
                    <td><input type="text" name="fullName" value="${u.fullName}"></td>
                </tr>
                <tr>
                    <td>Phone:  </td>
                    <td><input type="tel" name="phone" value="${u.phone}" required pattern="[0-9]{10}"></td>
                </tr>

                <tr>
                    <td>Gender:  </td>
                    <td>
                        <select name="gender">
                            <option value="M" ${u.gender =='M' ? 'selected' : ''}>Male</option>
                            <option value="F" ${u.gender =='F' ? 'selected' : ' '} >Female</option>
                            <option value="O" ${u.gender =='O' ? 'selected' : ''}>Other</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>Role:  </td>
                    <td>
                        <select id="roleId" name="roleId">
                            <c:forEach var="r" items="${roles}">
                                <option value="${r.roleId}"  ${u.roleId == r.roleId ? 'selected' : ''}>${r.roleName}</option>
                            </c:forEach>
                        </select>

                    </td>
                </tr>
                <tr>
                    <td><input type="submit" name="name"></td>
                </tr>


            </table>
        </form>
    </body>
</html>
