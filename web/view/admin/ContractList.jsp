<%-- 
    Document   : ContractList
    Created on : Mar 4, 2026, 12:51:46 AM
    Author     : omovi
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Contract  List</title>
    </head>
    <body>
        <jsp:include page="menu.jsp"/>

        <h2>Contract List</h2>

        <table class="table table-striped">

            <thead class="table-dark">

                <tr>

                    <th>ID</th>
                    <th>Room</th>
                    <th>Tenant</th>
                    <th>Start</th>
                    <th>End</th>
                    <th>Action</th>

                </tr>

            </thead>

            <tbody>

                <c:forEach var="c" items="${contracts}">

                    <tr>

                        <td>${c.contractID}</td>
                        <td>${c.roomID}</td>
                        <td>${c.accountID}</td>
                        <td>${c.startDate}</td>
                        <td>${c.endDate}</td>

                        <td>

                            <a class="btn btn-danger btn-sm"
                               href="${pageContext.request.contextPath}/Contract?action=terminate&id=${c.contractID}&roomId=${c.roomID}">
                                Terminate
                            </a>

                        </td>

                    </tr>

                </c:forEach>

            </tbody>

        </table>


</body>
</html>
