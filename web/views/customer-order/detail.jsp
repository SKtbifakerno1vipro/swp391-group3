<%@ page contentType="text/html;charset=UTF-8" language="java" import="service.InvoiceService,model.Invoice" %>
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
                <c:choose>
                    <c:when test="${sessionScope.user.roleId == 3}">
                        <ul>
                            <li><strong>Order ID:</strong> ${order.customerOrder.customerOrderId}</li>
                            <li><strong>Customer Name:</strong> ${order.customerUser.fullName}</li>
                            <li><strong>Tax Code:</strong> ${order.customer.taxCode}</li>
                            <li><strong>Status:</strong> ${order.customerOrder.orderStatus}</li>
                                <c:if test="${order.customerOrder.orderStatus == 'COMPLETED'}">
                                    <c:if test="${order.customerOrder.hasInvoice == true}">
                                    <li style="margin-top: 15px;"><strong>Hành động:</strong>
                                        <a href="${pageContext.request.contextPath}/invoice?invoiceId=${invOfOrder.invoiceId}" style="display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px; background: #0284c7; color: white; border-radius: 999px; font-weight: bold; text-decoration: none; font-size: 13px; vertical-align: middle; box-shadow: 0 4px 10px rgba(2, 132, 199, 0.2);">
                                            <span class="material-symbols-outlined" style="font-size: 18px; color: white;">visibility</span> View Invoice
                                        </a>
                                    </li>
                                </c:if>
                            </c:if>
                            <c:if test="${order.customerOrder.orderStatus == 'SHIPPING' || order.customerOrder.orderStatus == 'COMPLETED'}">
                                <li style="margin-top: 15px;"><strong>Biên Bản:</strong>
                                    <a href="${pageContext.request.contextPath}/AcceptanceRecordController?orderId=${order.customerOrder.customerOrderId}" style="display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px; background: #0284c7; color: white; border-radius: 999px; font-weight: bold; text-decoration: none; font-size: 13px; vertical-align: middle; box-shadow: 0 4px 10px rgba(2, 132, 199, 0.2);">
                                        Acceptance Record
                                    </a>
                                </li>
                            </c:if>
                            <li style="margin-top: 15px;"><strong>Created At:</strong>
                                <fmt:parseDate value="${order.customerOrder.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDateTime" type="both" />
                                <fmt:formatDate value="${parsedDateTime}" pattern="dd/MM/yyyy HH:mm" />
                            </li>
                        </ul>
                    </c:when>
                    <c:otherwise>
                        <form action="${pageContext.request.contextPath}/customer-order" method="POST">
                            <input type="hidden" name="orderId" value="${order.customerOrder.customerOrderId}">
                            <input type="hidden" name="action" value="update_status">
                            <ul>
                                <li><strong>Order ID:</strong> ${order.customerOrder.customerOrderId}</li>
                                <li><strong>Customer Name:</strong> ${order.customerUser.fullName}</li>
                                <li><strong>Tax Code:</strong> ${order.customer.taxCode}</li>
                                <li><strong>Status:</strong>
                                    <select name="status" ${order.customerOrder.orderStatus == 'COMPLETED' ? 'disabled' : ''} >
                                         <option value="PENDING" ${order.customerOrder.orderStatus == 'PENDING' ? 'selected' : ''}>PENDING</option>
                                         <option value="SHIPPING" ${order.customerOrder.orderStatus == 'SHIPPING' ? 'selected' : ''}>SHIPPING</option>
                                         <c:if test="${order.customerOrder.orderStatus == 'COMPLETED'}">
                                             <option value="COMPLETED" selected>COMPLETED</option>
                                         </c:if>
                                     </select>
                                        <button type="submit" ${order.customerOrder.orderStatus == 'COMPLETED' ? 'hidden' : ''}>Update Status</button>
                                </li>
                                <c:if test="${order.customerOrder.orderStatus == 'COMPLETED'}">
                                    <li style="margin-top: 15px;"><strong>Hành động:</strong>
                                        <c:choose>
                                            <c:when test="${order.customerOrder.hasInvoice == true}">
                                                <a href="${pageContext.request.contextPath}/invoice?invoiceId=${invOfOrder.invoiceId}" style="display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px; background: #0284c7; color: white; border-radius: 999px; font-weight: bold; text-decoration: none; font-size: 13px; vertical-align: middle; box-shadow: 0 4px 10px rgba(2, 132, 199, 0.2);">
                                                    <span class="material-symbols-outlined" style="font-size: 18px; color: white;">visibility</span> View Invoice
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/invoice?orderId=${order.customerOrder.customerOrderId}" style="display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px; background: #15803d; color: white; border-radius: 999px; font-weight: bold; text-decoration: none; font-size: 13px; vertical-align: middle; box-shadow: 0 4px 10px rgba(21, 128, 61, 0.2);">
                                                    <span class="material-symbols-outlined" style="font-size: 18px; color: white;">receipt_long</span> Create Invoice
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </li>
                                </c:if>
                                <li style="margin-top: 15px;"><strong>Created At:</strong>
                                    <fmt:parseDate value="${order.customerOrder.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDateTime" type="both" />
                                    <fmt:formatDate value="${parsedDateTime}" pattern="dd/MM/yyyy HH:mm" />
                                </li>
                            </ul>
                        </form>
                                    <c:if test="${order.customerOrder.orderStatus == 'SHIPPING' || order.customerOrder.orderStatus == 'COMPLETED'}">
                            <a href="${pageContext.request.contextPath}/AcceptanceRecordController?orderId=${order.customerOrder.customerOrderId}" style="display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px; background: #0284c7; color: white; border-radius: 999px; font-weight: bold; text-decoration: none; font-size: 13px; vertical-align: middle; box-shadow: 0 4px 10px rgba(2, 132, 199, 0.2);">Acceptance Record</a>
                        </c:if>

                    </c:otherwise>
                </c:choose>


                <h3>Order Items</h3>
                <table border="1" cellpadding="10" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Product ID</th>
                            <th>Product Name</th>
                            <th>Quantity</th>
                            <th>Unit Price</th>
                            <th>Discount</th>
                            <th>Tax (%)</th>
                            <th>Total (incl. Tax)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${details}">
                            <tr>
                                <td>${item.product.productId}</td>
                                <td>${item.product.productName}</td>
                                <td>
                                    ${item.detail.quantity} ${item.product.unit}
                                </td>
                                <td><fmt:formatNumber value="${item.detail.sellingPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                <td>

                                    <fmt:formatNumber value="${item.detail.discountPercent}" maxFractionDigits="2"/>%
                                </td>
                                <td><fmt:formatNumber value="${item.detail.taxPercent}" maxFractionDigits="2"/>%</td>
                                <td><fmt:formatNumber value="${item.detail.total}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty details}">
                            <tr>
                                <td colspan="7" style="text-align: center;">No items found in this order.</td>
                            </tr>
                        </c:if>
                    </tbody>
                    <tfoot>
                        <tr>
                            <th colspan="6" style="text-align: right;">Grand Total:</th>
                            <th><fmt:formatNumber value="${quotationTotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></th>
                        </tr>
                    </tfoot>
                </table>
                <a href="${pageContext.request.contextPath}/customer-order-list">Back to List</a>
            </main>
        </div>
    </body>
</html>
