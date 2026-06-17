<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Order List</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
    </head>
<body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="orders"/>
            </jsp:include>
            <main class="main legacy-page">
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

            </main>
        </div>
    </body>
</html>
