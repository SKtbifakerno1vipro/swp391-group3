<%-- 
    Document   : index
    Created on : Jan 27, 2026, 3:57:47 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> 
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
                <form action="Login" method="POST">
                    <label>Username:</label>
                    <input type="text" name="username" value="<c:out value="${requestScope.username}"/>" />
                    <br>
                    <label>Password:</label>
                    <input type="password" name="password" value="<c:out value="${requestScope.password}"/>"/>
                    <br>
                    <button type="submit">Login</button>
                </form>
                
                    <div><c:out value="${requestScope.error}"/></div>
            </div>
        </div>
    </body>
</html>