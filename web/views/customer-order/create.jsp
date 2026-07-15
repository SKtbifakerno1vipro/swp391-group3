<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Tạo Đơn hàng Khách hàng</title>
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
        <c:choose>
            <c:when test="${not empty customer}">
                <h2>Tạo đơn hàng cho ${customer.user.fullName}</h2>
            </c:when>
            <c:otherwise>
                <h2>Tạo mới đơn hàng khách hàng</h2>
            </c:otherwise>
        </c:choose>
        <hr>
        <a href="${pageContext.request.contextPath}/customer-order-list">Quay lại danh sách đơn hàng</a>
        <hr>

        <c:if test="${not empty error}">
            <p style="color: red;">${error}</p>
        </c:if>

        <form action="${pageContext.request.contextPath}/customer-order" method="post">
            <input type="hidden" name="action" value="create">
            
            <c:choose>
                <c:when test="${not empty customer}">
                    <input type="hidden" name="customerId" value="${customer.customer.customerId}" />
                    <p>
                        <strong>Khách hàng:</strong> ${customer.user.fullName} (${customer.user.userName})
                    </p>
                </c:when>
                <c:otherwise>
                    <p style="color: red;">Chưa chọn khách hàng.</p>
                </c:otherwise>
            </c:choose>

            <br>
            <div>
              
                <c:choose>
                    <c:when test="${not empty selectedContract}">
                        <input type="hidden" name="customerContractId" value="${selectedContract.contractId}" />
                        <p>
                            <strong>Hợp đồng đã ký:</strong> ${selectedContract.contractNumber}
                        </p>
                    </c:when>
                    <c:otherwise>
                        <p style="color: red;"><strong>Hợp đồng đã ký:</strong> Chưa có hợp đồng nào được chọn hoặc hợp đồng không khả dụng!</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:if test="${not empty quotationDetails}">
                <h3>Danh sách sản phẩm</h3>
                <table border="1" cellpadding="10" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Tên sản phẩm</th>
                            <th>Đơn giá</th>
                            <th>Đơn vị</th>
                            <th>Số lượng</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="qd" items="${quotationDetails}">
                            <tr>
                                <td>
                                    ${qd.productName}
                                    <input type="hidden" name="quotationDetailIds" value="${qd.quotationDetailId}" />
                                </td>
                                <td><fmt:formatNumber value="${qd.sellingPrice}" type="currency" currencySymbol="₫"  maxFractionDigits="0"/></td>
                                <td>${qd.unit}</td>
                                <td>
                                    <input type="hidden" name="qty_${qd.quotationDetailId}" value="${qd.quantity}" />
                                    ${qd.quantity}
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
            <br>
            <button type="submit">Tạo đơn hàng</button>
        </form>

            </main>
        </div>
    </body>
</html>
