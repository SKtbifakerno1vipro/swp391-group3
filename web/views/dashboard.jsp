<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Dashboard - Pơ Bread</title>
    </head>
    <body>
        <h2>Welcome to Dashboard, ${user.fullName} (${user.userName})</h2>
        <p>Your Role ID: <strong>${user.roleId}</strong></p>
        <hr>
        <jsp:include page="shared/menu.jsp"/>
        </hr>
       
    </body>
</html>
