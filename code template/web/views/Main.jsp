<%-- 
    Document   : Main
    Created on : Jan 27, 2026, 4:11:34 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="static/css/styles.css" />
        <title>Main</title>
    </head>
    <body>
        <jsp:include page="header.jsp" />
        <jsp:include page="topnav.jsp" />
        <div>
            <%
                String user = (String)request.getAttribute("user");
            %>
            <h2>Java Web Application - Demo</h2>
            <h4>Account: <%= user %></h4>
            <div><a href="Accounts">Account Management</a> </div>
        </div>
        <jsp:include page="footer.jsp" />
    </body>
</html>