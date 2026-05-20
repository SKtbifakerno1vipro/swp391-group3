<%-- 
    Document   : AccountEdit
    Created on : Feb 3, 2026, 5:14:47 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList" %>
<%@page import="models.Account" %>
<%@page import="models.Role" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>AccountEdit</title>
    </head>
    <body>
        <% Account acc = (Account)request.getAttribute("account"); %>
        <% if (acc != null) { %>
        <div>
            <h2>Edit Account</h2>
            <form action="AccountEdit" method="POST">
                <table>
                    <tr>
                        <td>AccountId:</td>
                        <td><input type="text" name="accountId" value="<%= acc.AccountId %>" readonly/></td>
                    </tr>
                    <tr>
                        <td>Password:</td>
                        <td><input type="password" name="password" value="<%= acc.Password %>"/></td>
                    </tr>
                    <tr>
                        <td>Role:</td>
                        <td>
                            <% List<Role> roles = (ArrayList<Role>)request.getAttribute("roles"); %>
                            <select name="roleId">
                                <% for (Role role : roles) { %>
                                    <% if(role.RoleId == acc.RoleId) { %>
                                        <option value="<%= role.RoleId %>" selected><%= role.RoleName %></option>
                                    <% } else { %>
                                        <option value="<%= role.RoleId %>"><%= role.RoleName %></option>
                                    <% } %>
                                <% } %>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <button type="submit">Save</button>
                            <a href="Accounts">Cancel</a>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
        <% } %>
        <a href="Accounts">Back to List</a>
    </body>
</html>
