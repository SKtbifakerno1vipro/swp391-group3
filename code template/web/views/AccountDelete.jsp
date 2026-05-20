<%-- 
    Document   : AccountDelete
    Created on : Feb 6, 2026, 1:28:26 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>AccountDelete</title>
    </head>
    <body>
        <% String id = request.getParameter("id"); %>
        <div>
            <h2>Delete Account Confirm</h2>
            <p>Are you sure to delete account: <%= id %></p>
            <form action="AccountDelete" method="POST">
                <input type="hidden" name="accountId" value="<%= id %>"/>
                <button type="submit">Delete</button> | <a href="Accounts">Cancel</a>
            </form>
        </div>
        <a href="Accounts">Back to List</a>
    </body>
</html>
