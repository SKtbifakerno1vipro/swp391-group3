<%@ page contentType="text/html;charset=UTF-8" language="java" import="service.InvoiceService,model.Invoice" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh sách Đơn hàng</title>

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
                <h2>Danh sách Đơn hàng</h2>
                <form action="customer-order-list" method="GET" style="display: flex; gap: 15px; align-items: center; margin-bottom: 10px; background: #f9f9f9; padding: 15px; border-radius: 8px; border: 1px solid #ddd;">
                    <input type="hidden" name="search" value="search">
                    <div>
                        <input type="text" placeholder="Tìm kiếm theo tên hoặc mã số thuế" name="keyword" value="${keyword}" style="padding: 6px; width: 220px;">
                    </div>
                    <div>
                        <label for="sortBy" style="font-weight: bold; margin-right: 5px;">Sắp xếp theo:</label>
                        <select name="sortBy" id="sortBy" style="padding: 6px;">
                            <option value="orderId" ${sortBy == 'orderId' ? 'selected' : ''}>Mã đơn hàng</option>
                            <option value="customerName" ${sortBy == 'customerName' ? 'selected' : ''}>Tên khách hàng</option>
                            <option value="taxCode" ${sortBy == 'taxCode' ? 'selected' : ''}>Mã số thuế</option>
                            <option value="status" ${sortBy == 'status' ? 'selected' : ''}>Trạng thái</option>
                        </select>
                    </div>
                    <div>
                        <label for="sortOrder" style="font-weight: bold; margin-right: 5px;">Thứ tự:</label>
                        <select name="sortOrder" id="sortOrder" style="padding: 6px;">
                            <option value="asc" ${sortOrder == 'asc' ? 'selected' : ''}>Tăng dần</option>
                            <option value="desc" ${sortOrder == 'desc' ? 'selected' : ''}>Giảm dần</option>
                        </select>
                    </div>
                    <div>
                        <label style="font-weight: bold; margin-right: 5px;">Kích thước trang:</label>
                        <select name="pagesize" id="pagesize" style="padding: 6px;">
                            <option value="5" ${pagesize == '5' ? 'selected' : ''}>5</option>
                            <option value="10" ${pagesize == '10' ? 'selected' : ''}>10</option>
                            <option value="20" ${pagesize == '20' ? 'selected' : ''}>20</option>
                            <option value="50" ${pagesize == '50' ? 'selected' : ''}>50</option>
                        </select>
                    </div>
                    <button type="submit" style="padding: 6px 15px; cursor: pointer;">Tìm kiếm/Lọc</button>
                </form>
                <br>
                <table border="1" cellpadding="10" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Mã đơn hàng</th>
                            <th>Tên khách hàng</th>
                            <th>Mã số thuế</th>
                            <th>Trạng thái</th>
                            <th>Ngày tạo</th>
                            <th>Hành động</th>
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
                                <td>
                                    <c:choose>
                                        <c:when test="${item.customerOrder.orderStatus == 'PENDING'}">Chờ xử lý</c:when>
                                        <c:when test="${item.customerOrder.orderStatus == 'SHIPPING'}">Đang giao hàng</c:when>
                                        <c:when test="${item.customerOrder.orderStatus == 'CANCELLED'}">Đã hủy</c:when>
                                        <c:when test="${item.customerOrder.orderStatus == 'COMPLETED'}">Đã hoàn thành</c:when>
                                        <c:otherwise>${item.customerOrder.orderStatus}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <fmt:parseDate value="${item.customerOrder.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDateTime" type="both" />
                                    <fmt:formatDate value="${parsedDateTime}" pattern="dd/MM/yyyy HH:mm" />
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/customer-order?id=${item.customerOrder.customerOrderId}">Xem</a>
                                    <c:if test="${sessionScope.user.roleId != 3}">
                                        <c:if test="${item.customerOrder.orderStatus != 'COMPLETED'}">
                                            <c:if test="${item.customerOrder.orderStatus != 'SHIPPING'}">
                                                <a href="${pageContext.request.contextPath}/customer-order?action=delete_order&id=${item.customerOrder.customerOrderId}" style="color: red;" onclick="return confirm('Bạn có chắc chắn muốn xóa đơn hàng này không?');">Xóa</a>    
                                            </c:if>
                                        </c:if>
                                    </c:if>
                                    <c:if test="${item.customerOrder.orderStatus == 'COMPLETED'}">
                                        <c:choose>
                                            <c:when test="${empty invOfOrder}">
                                                <c:if test="${sessionScope.user.roleId != 3}">
                                                    |
                                                    <a href="${pageContext.request.contextPath}/invoice?orderId=${item.customerOrder.customerOrderId}" style="color: #16a34a; font-weight: bold; text-decoration: none;">Tạo Hóa đơn</a>
                                                </c:if>
                                            </c:when>
                                            <c:otherwise>
                                                |
                                                <a href="${pageContext.request.contextPath}/invoice?invoiceId=${invOfOrder.invoiceId}" style="color: #0284c7; font-weight: bold; text-decoration: none;">Xem Hóa đơn</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty orders}">
                            <tr>
                                <td colspan="6" style="text-align: center;">Không tìm thấy đơn hàng nào.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>

                <div>
                    <c:if test="${totalPages > 1}">
                        <c:set var="queryParams" value="search=${action}&keyword=${keyword}&sortBy=${sortBy}&sortOrder=${sortOrder}" />

                        <c:if test="${currentPage > 1}">
                            <a href="customer-order-list?page=${currentPage - 1}&${queryParams}">Trước</a>
                        </c:if>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="customer-order-list?page=${i}&${queryParams}"
                               style="margin: 0 5px; ${i == currentPage ? 'font-weight:bold; color:red;' : ''}">${i}</a>
                        </c:forEach>

                        <c:if test="${currentPage < totalPages}">
                            <a href="customer-order-list?page=${currentPage + 1}&${queryParams}">Sau</a>
                        </c:if>
                    </c:if>
                </div>

            </main>
        </div>
    </body>
</html>
