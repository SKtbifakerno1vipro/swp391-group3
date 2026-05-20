<%-- 
    Document   : index
    Created on : Jan 27, 2026, 3:57:47 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login</title>
        <link rel="stylesheet" href="static/css/styles.css" />
    </head>
    <body>
        <div>
            <h2>Login Page</h2>
            <div>
                <%
                    String username = request.getParameter("username");
                    String password = request.getParameter("password");
                    if (username == null) username = "";
                    if (password == null) password = "";
                %>
                <form action="Login" method="POST">
                    <table>
                        <tr>
                            <td>Username: </td>
                            <td><input type="text" name="username" value="<%= username %>"/></td>
                        </tr>
                        <tr>
                            <td>Password: </td>
                            <td><input type="password" name="password" value="<%= password %>"/></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td><button type="submit">Login</button></td>
                        </tr>
                    </table>
                </form>
                <%
                    String error = (String)request.getAttribute("error");
                    if (error == null) error = ""; //fix 500 error
                %>
                <div><%= error %></div>
            </div>
        </div>
    </body>
</html>