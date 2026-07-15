<%@ page contentType="text/html;charset=UTF-8" language="java" import="service.InvoiceService,model.Invoice" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết Đơn hàng</title>

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
                <h2>Chi tiết Đơn hàng</h2>


                <h3>Thông tin Đơn hàng</h3>
                <c:choose>
                    <c:when test="${sessionScope.user.roleId == 3}">
                        <ul>
                            <li><strong>Mã đơn hàng:</strong> ${order.customerOrder.customerOrderId}</li>
                            <li><strong>Tên khách hàng:</strong> ${order.customerUser.fullName}</li>
                            <li><strong>Mã số thuế:</strong> ${order.customer.taxCode}</li>
                            <li><strong>Trạng thái:</strong>
                                <c:choose>
                                    <c:when test="${order.customerOrder.orderStatus == 'PENDING'}">Chờ xử lý</c:when>
                                    <c:when test="${order.customerOrder.orderStatus == 'SHIPPING'}">Đang giao hàng</c:when>
                                    <c:when test="${order.customerOrder.orderStatus == 'CANCELLED'}">Đã hủy</c:when>
                                    <c:when test="${order.customerOrder.orderStatus == 'COMPLETED'}">Đã hoàn thành</c:when>
                                    <c:otherwise>${order.customerOrder.orderStatus}</c:otherwise>
                                </c:choose>
                            </li>
                                <c:if test="${order.customerOrder.orderStatus == 'COMPLETED'}">
                                    <c:if test="${order.customerOrder.hasInvoice == true}">
                                    <li style="margin-top: 15px;"><strong>Hành động:</strong>
                                        <a href="${pageContext.request.contextPath}/invoice?invoiceId=${invOfOrder.invoiceId}" style="display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px; background: #0284c7; color: white; border-radius: 999px; font-weight: bold; text-decoration: none; font-size: 13px; vertical-align: middle; box-shadow: 0 4px 10px rgba(2, 132, 199, 0.2);">
                                            <span class="material-symbols-outlined" style="font-size: 18px; color: white;">visibility</span> Xem Hóa đơn
                                        </a>
                                    </li>
                                </c:if>
                            </c:if>
                            <c:if test="${order.customerOrder.orderStatus == 'SHIPPING' || order.customerOrder.orderStatus == 'COMPLETED'}">
                                <li style="margin-top: 15px;"><strong>Biên bản:</strong>
                                    <a href="${pageContext.request.contextPath}/AcceptanceRecordController?orderId=${order.customerOrder.customerOrderId}" style="display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px; background: #0284c7; color: white; border-radius: 999px; font-weight: bold; text-decoration: none; font-size: 13px; vertical-align: middle; box-shadow: 0 4px 10px rgba(2, 132, 199, 0.2);">
                                        Biên bản nghiệm thu
                                    </a>
                                </li>
                            </c:if>
                            <li style="margin-top: 15px;"><strong>Ngày tạo:</strong>
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
<<<<<<< HEAD
                                <li><strong>Mã đơn hàng:</strong> ${order.customerOrder.customerOrderId}</li>
                                <li><strong>Tên khách hàng:</strong> ${order.customerUser.fullName}</li>
                                <li><strong>Mã số thuế:</strong> ${order.customer.taxCode}</li>
                                <li><strong>Trạng thái:</strong>
                                    <select name="status" ${order.customerOrder.orderStatus == 'COMPLETED' || order.customerOrder.orderStatus == 'CANCELLED' ? 'disabled' : ''} >
                                        <option value="PENDING" ${order.customerOrder.orderStatus == 'PENDING' ? 'selected' : 'hidden'}>Chờ xử lý</option>
                                         <option value="SHIPPING" ${order.customerOrder.orderStatus == 'SHIPPING' ? 'selected' : ''}>Đang giao hàng</option>
                                         <option value="CANCELLED" ${order.customerOrder.orderStatus == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                                         <option value="COMPLETED" ${order.customerOrder.orderStatus != 'COMPLETED' ? 'hidden' : 'selected'}>ĐÃ HOÀN THÀNH</option>
                                     </select>
                                        <button type="submit" ${order.customerOrder.orderStatus == 'COMPLETED' || order.customerOrder.orderStatus == 'CANCELLED' ? 'hidden' : ''}>Cập nhật trạng thái</button>
=======
                                <li><strong>Order ID:</strong> ${order.customerOrder.customerOrderId}</li>
                                <li><strong>Customer Name:</strong> ${order.customerUser.fullName}</li>
                                <li><strong>Tax Code:</strong> ${order.customer.taxCode}</li>
                                <li><strong>Status:</strong>
                                    <select name="status" ${order.customerOrder.orderStatus == 'COMPLETED' || order.customerOrder.orderStatus == 'CANCELLED' ? 'disabled' : ''} >
                                        <option value="PENDING" ${order.customerOrder.orderStatus == 'PENDING' ? 'selected' : 'hidden'}>PENDING</option>
                                         <option value="SHIPPING" ${order.customerOrder.orderStatus == 'SHIPPING' ? 'selected' : ''}>SHIPPING</option>
                                         <option value="CANCELLED" ${order.customerOrder.orderStatus == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                                         <option value="COMPLETED" ${order.customerOrder.orderStatus == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                                     </select>
                                        <button type="submit" ${order.customerOrder.orderStatus == 'COMPLETED' || order.customerOrder.orderStatus == 'CANCELLED' ? 'hidden' : ''}>Update Status</button>
>>>>>>> 56a0ace80a9ac499cdedcb1b8a0ec78c796fcd91
                                </li>
                                <c:if test="${order.customerOrder.orderStatus == 'COMPLETED'}">
                                    <li style="margin-top: 15px;"><strong>Hành động:</strong>
                                        <c:choose>
                                            <c:when test="${order.customerOrder.hasInvoice == true}">
                                                <a href="${pageContext.request.contextPath}/invoice?invoiceId=${invOfOrder.invoiceId}" style="display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px; background: #0284c7; color: white; border-radius: 999px; font-weight: bold; text-decoration: none; font-size: 13px; vertical-align: middle; box-shadow: 0 4px 10px rgba(2, 132, 199, 0.2);">
                                                    <span class="material-symbols-outlined" style="font-size: 18px; color: white;">visibility</span> Xem Hóa đơn
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/invoice?orderId=${order.customerOrder.customerOrderId}" style="display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px; background: #15803d; color: white; border-radius: 999px; font-weight: bold; text-decoration: none; font-size: 13px; vertical-align: middle; box-shadow: 0 4px 10px rgba(21, 128, 61, 0.2);">
                                                    <span class="material-symbols-outlined" style="font-size: 18px; color: white;">receipt_long</span> Tạo Hóa đơn
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </li>
                                </c:if>
                                <li style="margin-top: 15px;"><strong>Ngày tạo:</strong>
                                    <fmt:parseDate value="${order.customerOrder.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDateTime" type="both" />
                                    <fmt:formatDate value="${parsedDateTime}" pattern="dd/MM/yyyy HH:mm" />
                                </li>
                            </ul>
                        </form>
                                    <c:if test="${order.customerOrder.orderStatus == 'SHIPPING' || order.customerOrder.orderStatus == 'COMPLETED' || order.customerOrder.orderStatus == 'CANCELLED'}">
<<<<<<< HEAD
                            <a href="${pageContext.request.contextPath}/AcceptanceRecordController?orderId=${order.customerOrder.customerOrderId}" style="display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px; background: #0284c7; color: white; border-radius: 999px; font-weight: bold; text-decoration: none; font-size: 13px; vertical-align: middle; box-shadow: 0 4px 10px rgba(2, 132, 199, 0.2);">Biên bản nghiệm thu</a>
=======
                            <a href="${pageContext.request.contextPath}/AcceptanceRecordController?orderId=${order.customerOrder.customerOrderId}" style="display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px; background: #0284c7; color: white; border-radius: 999px; font-weight: bold; text-decoration: none; font-size: 13px; vertical-align: middle; box-shadow: 0 4px 10px rgba(2, 132, 199, 0.2);">Acceptance Record</a>
>>>>>>> 56a0ace80a9ac499cdedcb1b8a0ec78c796fcd91
                        </c:if>

                    </c:otherwise>
                </c:choose>


                <h3>Danh sách sản phẩm</h3>
                <table border="1" cellpadding="10" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Mã sản phẩm</th>
                            <th>Tên sản phẩm</th>
                            <th>Số lượng</th>
                            <th>Đơn giá</th>
                            <th>Chiết khấu</th>
                            <th>Thuế (%)</th>
                            <th>Thành tiền (gồm thuế)</th>
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
                                <td colspan="7" style="text-align: center;">Không tìm thấy mặt hàng nào trong đơn hàng này.</td>
                            </tr>
                        </c:if>
                    </tbody>
                    <tfoot>
                        <tr>
                            <th colspan="6" style="text-align: right;">Tổng cộng:</th>
                            <th><fmt:formatNumber value="${quotationTotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></th>
                        </tr>
                    </tfoot>
                </table>
                <a href="${pageContext.request.contextPath}/customer-order-list">Quay lại danh sách</a>
            </main>
        </div>
    </body>
</html>
