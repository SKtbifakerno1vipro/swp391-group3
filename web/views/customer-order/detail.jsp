<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Customer Order Detail</title>

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
        <h2>Customer Order Detail</h2>


        <h3>Order Information</h3>
        <form action="${pageContext.request.contextPath}/customer-order" method="POST">
            <input type="hidden" name="orderId" value="${order.customerOrder.customerOrderId}">
            <input type="hidden" name="action" value="update_status">
            <ul>
                <li><strong>Order ID:</strong> ${order.customerOrder.customerOrderId}</li>
                <li><strong>Customer Name:</strong> ${order.customerUser.fullName}</li>
                <li><strong>Tax Code:</strong> ${order.customer.taxCode}</li>
                <li><strong>Status:</strong>
                    <select name="status">
                        <option value="PENDING" ${order.customerOrder.orderStatus == 'PENDING' ? 'selected' : ''}>PENDING</option>
                        <option value="SHIPPING" ${order.customerOrder.orderStatus == 'SHIPPING' ? 'selected' : ''}>SHIPPING</option>
                        <option value="COMPLETED" ${order.customerOrder.orderStatus == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                    </select>
                    <button type="submit">Update Status</button>
                </li>
                <li><strong>Created At:</strong>
                    <fmt:parseDate value="${order.customerOrder.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDateTime" type="both" />
                    <fmt:formatDate value="${parsedDateTime}" pattern="dd/MM/yyyy HH:mm" />
                </li>
            </ul>
        </form>

        <h3>Order Items</h3>
        <table border="1" cellpadding="10" cellspacing="0">
            <thead>
                <tr>
                    <th>Product ID</th>
                    <th>Product Name</th>
                    <th>Quantity</th>
                    <th>Unit Price</th>
                    <th>Tax (%)</th>
                    <th>Total (incl. Tax)</th>
                </tr>
            </thead>
            <tbody>
                <c:set var="totalOrderAmount" value="0" />
                <c:forEach var="item" items="${details}">
                    <c:set var="subTotal" value="${item.detail.quantity * item.detail.sellingPrice}" />
                    <c:set var="taxAmount" value="${subTotal * (item.detail.taxPercent / 100.0)}" />
                    <c:set var="itemTotal" value="${subTotal + taxAmount}" />
                    <c:set var="totalOrderAmount" value="${totalOrderAmount + itemTotal}" />
                    <tr>
                        <td>${item.product.productId}</td>
                        <td>${item.product.productName}</td>
                        <td>
                            ${item.detail.quantity} ${item.product.unit}
                        </td>
                        <td><fmt:formatNumber value="${item.detail.sellingPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                        <td><fmt:formatNumber value="${item.detail.taxPercent}" maxFractionDigits="2"/>%</td>
                        <td><fmt:formatNumber value="${itemTotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty details}">
                    <tr>
                        <td colspan="6" style="text-align: center;">No items found in this order.</td>
                    </tr>
                </c:if>
            </tbody>
            <tfoot>
                <tr>
                    <th colspan="5" style="text-align: right;">Grand Total:</th>
                    <th><fmt:formatNumber value="${totalOrderAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></th>
                </tr>
            </tfoot>
        </table>
        <a href="${pageContext.request.contextPath}/customer-order-list">Back to List</a>

            </main>
        </div>
    </body>
</html>
