<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Pơ Bread - Role Management</title>
    </head>
    <body>
        <h1>Quotation List</h1>
        <table border="1" cellpadding=7 cellspacing="0">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Customer</th>
                    <th>Quotation Date</th>
                    <th>Status</th>
                    <th>Created By</th>
                    <th>Created At</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${empty quotationList}">
                    <tr>
                        <td colspan="7">No roles found.</td>
                    </tr>
                </c:if>
                <c:forEach items="${quotationList}" var="quotation">
                    <tr>
                        <td>${quotation.quotationId}</td>
                        <td>${quotation.customerName}</td>
                        <td>${quotation.quotationDate}</td>
                        <td>${quotation.quotationStatus}</td>
                        <td>${quotation.createdByName}</td>
                        <td>${quotation.createdAt}</td>
                        <td>
                            <a href="quotation-detail?id=${quotation.quotationId}">view</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>


    </body>
</html>
