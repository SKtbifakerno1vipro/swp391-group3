<%@ page contentType="text/html;charset=UTF-8" language="java" import="service.InvoiceService,model.Invoice" %>
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
    <form action="customer-order-list" method="GET" style="display: flex; gap: 15px; align-items: center; margin-bottom: 10px; background: #f9f9f9; padding: 15px; border-radius: 8px; border: 1px solid #ddd;">
        <input type="hidden" name="search" value="search">
        <div>
            <input type="text" placeholder="Search by name or tax code" name="keyword" value="${keyword}" style="padding: 6px; width: 220px;">
        </div>
        <div>
            <label for="sortBy" style="font-weight: bold; margin-right: 5px;">Sort by:</label>
            <select name="sortBy" id="sortBy" style="padding: 6px;">
                <option value="orderId" ${sortBy == 'orderId' ? 'selected' : ''}>Order ID</option>
                <option value="customerName" ${sortBy == 'customerName' ? 'selected' : ''}>Customer Name</option>
                <option value="taxCode" ${sortBy == 'taxCode' ? 'selected' : ''}>Tax Code</option>
                <option value="status" ${sortBy == 'status' ? 'selected' : ''}>Status</option>
            </select>
        </div>
        <div>
            <label for="sortOrder" style="font-weight: bold; margin-right: 5px;">Order:</label>
            <select name="sortOrder" id="sortOrder" style="padding: 6px;">
                <option value="asc" ${sortOrder == 'asc' ? 'selected' : ''}>Ascending</option>
                <option value="desc" ${sortOrder == 'desc' ? 'selected' : ''}>Descending</option>
            </select>
        </div>
        <button type="submit" style="padding: 6px 15px; cursor: pointer;">Search/Filter</button>
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
        <% InvoiceService invService = new InvoiceService(); %>
        <tbody>
            <c:forEach var="item" items="${orders}">
                <%
                    dto.CustomerOrderDTO itemDto = (dto.CustomerOrderDTO) pageContext.getAttribute("item");
                    if (itemDto != null && itemDto.getCustomerOrder() != null) {
                        Invoice inv = invService.getInvoiceByOrderId(itemDto.getCustomerOrder().getCustomerOrderId());
                        pageContext.setAttribute("invOfOrder", inv);
                    } else {
                        pageContext.removeAttribute("invOfOrder");
                    }
                %>
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
                        <a href="${pageContext.request.contextPath}/customer-order?id=${item.customerOrder.customerOrderId}">View</a> |
                        <a href="${pageContext.request.contextPath}/customer-order?action=delete_order&id=${item.customerOrder.customerOrderId}" style="color: red;" onclick="return confirm('Are you sure you want to delete this order?');">Delete</a>
                        <c:if test="${item.customerOrder.orderStatus == 'COMPLETED'}">
                            |
                            <c:choose>
                                <c:when test="${empty invOfOrder}">
                                    <a href="${pageContext.request.contextPath}/invoice?orderId=${item.customerOrder.customerOrderId}" style="color: #16a34a; font-weight: bold; text-decoration: none;">Create Invoice</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/invoice?invoiceId=${invOfOrder.invoiceId}" style="color: #0284c7; font-weight: bold; text-decoration: none;">View Invoice</a>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
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
            <c:set var="queryParams" value="search=${action}&keyword=${keyword}&sortBy=${sortBy}&sortOrder=${sortOrder}" />

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
