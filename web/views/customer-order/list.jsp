<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Order List</title>
</head>
<body>
    <h2>Customer Order List</h2>
    <hr>
    <a href="#">Create Order</a>
    <hr>

    <table border="1" cellpadding="10" cellspacing="0">
        <thead>
            <tr>
                <th>Order ID</th>
                <th>Customer Name</th>
                <th>Tax Code</th>
                <th>Status</th>
                <th>Created At</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="item" items="${orders}">
                <tr>
                    <td>${item.customerOrder.customerOrderId}</td>
                    <td>${item.customerUser.fullName}</td>
                    <td>${item.customer.taxCode}</td>
                    <td>${item.customerOrder.status}</td>
                    <td>
                        <fmt:parseDate value="${item.customerOrder.createAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDateTime" type="both" />
                        <fmt:formatDate value="${parsedDateTime}" pattern="dd/MM/yyyy HH:mm" />
                    </td>
                    <td>
                        <a href="#">View Details</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty orders}">
                <tr>
                    <td colspan="6" style="text-align: center;">No orders found.</td>
                </tr>
            </c:if>
        </tbody>
    </table>
</body>
</html>
