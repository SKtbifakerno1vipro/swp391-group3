<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Customer Order Detail</title>
    </head>
    <body>
        <h2>Customer Order Detail</h2>
        

        <h3>Order Information</h3>
        <ul>
            <li><strong>Order ID:</strong> ${order.customerOrder.customerOrderId}</li>
            <li><strong>Customer Name:</strong> ${order.customerUser.fullName}</li>
            <li><strong>Tax Code:</strong> ${order.customer.taxCode}</li>
            <li><strong>Status:</strong> ${order.customerOrder.orderStatus}</li>
            <li><strong>Created At:</strong> 
                <fmt:parseDate value="${order.customerOrder.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDateTime" type="both" />
                <fmt:formatDate value="${parsedDateTime}" pattern="dd/MM/yyyy HH:mm" />
            </li>
        </ul>

        <h3>Order Items</h3>
        <table border="1" cellpadding="10" cellspacing="0">
            <thead>
                <tr>
                    <th>Product ID</th>
                    <th>Product Name</th>
                    <th>Quantity</th>
                    <th>Unit Price</th>
                    <th>Total</th>
                </tr>
            </thead>
            <tbody>
                <c:set var="totalOrderAmount" value="0" />
                <c:forEach var="item" items="${details}">
                    <c:set var="itemTotal" value="${item.detail.quantity * item.detail.sellingPrice}" />
                    <c:set var="totalOrderAmount" value="${totalOrderAmount + itemTotal}" />
                    <tr>
                        <td>${item.product.productId}</td>
                        <td>${item.product.productName}</td>
                        <td>${item.detail.quantity} ${item.product.unit}</td>
                        <td><fmt:formatNumber value="${item.detail.sellingPrice}" type="currency" currencySymbol="₫"/></td>
                        <td><fmt:formatNumber value="${itemTotal}" type="currency" currencySymbol="₫"/></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty details}">
                    <tr>
                        <td colspan="5" style="text-align: center;">No items found in this order.</td>
                    </tr>
                </c:if>
            </tbody>
            <tfoot>
                <tr>
                    <th colspan="4" style="text-align: right;">Grand Total:</th>
                    <th><fmt:formatNumber value="${totalOrderAmount}" type="currency" currencySymbol="₫"/></th>
                </tr>
            </tfoot>
        </table>
        <a href="${pageContext.request.contextPath}/customer-order-list">Back to List</a>
    </body>
</html>
