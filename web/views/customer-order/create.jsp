<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Create Customer Order</title>
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
                <h2>Create Order for ${customer.user.fullName}</h2>
            </c:when>
            <c:otherwise>
                <h2>Create New Customer Order</h2>
            </c:otherwise>
        </c:choose>
        <hr>
        <a href="${pageContext.request.contextPath}/customer-order-list">Back to Orders</a>
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
                        <strong>Customer:</strong> ${customer.user.fullName} (${customer.user.userName})
                    </p>
                </c:when>
                <c:otherwise>
                    <p style="color: red;">No customer selected.</p>
                </c:otherwise>
            </c:choose>

            <br>
            <div>
              
                <c:choose>
                    <c:when test="${not empty selectedContract}">
                        <input type="hidden" name="customerContractId" value="${selectedContract.contractId}" />
                        <p>
                            <strong>Signed Contract:</strong> ${selectedContract.contractNumber}
                        </p>
                    </c:when>
                    <c:otherwise>
                        <p style="color: red;"><strong>Signed Contract:</strong> No signed contract selected or available!</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:if test="${not empty quotationDetails}">
                <h3>Select Products</h3>
                <table border="1" cellpadding="10" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Product Name</th>
                            <th>Price</th>
                            <th>Unit</th>
                            <th>Quantity</th>
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
            <button type="submit">Create Order</button>
        </form>

            </main>
        </div>
    </body>
</html>
