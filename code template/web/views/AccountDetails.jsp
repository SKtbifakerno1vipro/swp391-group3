<%-- 
    Document   : AccountDetails
    Created on : Jan 30, 2026, 1:26:53 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="models.Account" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>AccountDetails</title>
    </head>
    <body>
        <div>
            <h2>Account Details</h2>
            <% Account acc = (Account)request.getAttribute("account"); %>
            <% if (acc != null) { %>
            <div>
                <table>
                    <tr>
                        <td>Id:</td>
                        <td><%= acc.AccountId %></td>
                    </tr>
                    <tr>
                        <td>Password:</td>
                        <td><%= acc.Password %></td>
                    </tr>
                    <tr>
                        <td>Role:</td>
                        <td><%= acc.RoleId %></td>
                    </tr>
                </table>
            </div>
            <% } %>
            <div>
                <a href="Accounts">Back to List</a> | <a href="#">Edit</a>
            </div>
        </div>
    </body>
</html>