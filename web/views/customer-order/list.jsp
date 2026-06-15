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
    <a href="${pageContext.request.contextPath}/create-customer-order">Create Order</a>
    <hr>
    <form action="customer-order-list" method="GET" >
        <input type="hidden" name="search" value="search">
        <input type="text" placeholder="Search" name="keyword" value="${keyword}">
        <button type="submit">Search</button>
    </form>
    <br>

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
                    <td>${item.customerOrder.orderStatus}</td>
                    <td>
                        <fmt:parseDate value="${item.customerOrder.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDateTime" type="both" />
                        <fmt:formatDate value="${parsedDateTime}" pattern="dd/MM/yyyy HH:mm" />
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/customer-order-detail?id=${item.customerOrder.customerOrderId}">View Details</a>
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

    <div>
        <c:if test="${totalPages > 1}">
            <c:set var="queryParams" value="search=${action}&keyword=${keyword}" />

            <c:if test="${currentPage > 1}">
                <a href="customer-order-list?page=${currentPage - 1}&${queryParams}">Previous</a>
            </c:if>

            <c:forEach begin="1" end="${totalPages}" var="i">
                <a href="customer-order-list?page=${i}&${queryParams}" 
                   style="margin: 0 5px; ${i == currentPage ? 'font-weight:bold; color:red;' : ''}">${i}</a>
            </c:forEach>

            <c:if test="${currentPage < totalPages}">
                <a href="customer-order-list?page=${currentPage + 1}&${queryParams}">Next</a>
            </c:if>
        </c:if>
    </div>
    <div><a href="${pageContext.request.contextPath}/dashboard">Back to Dashboard</a></div>
</body>
</html>
