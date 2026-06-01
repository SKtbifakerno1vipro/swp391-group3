<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create Customer Order</title>
    <script>
        function toggleQty(checkbox, productId) {
            var qtyInput = document.getElementById('qty_' + productId);
            if (checkbox.checked) {
                qtyInput.disabled = false;
                if (qtyInput.value == 0) qtyInput.value = 1;
            } else {
                qtyInput.disabled = true;
                qtyInput.value = 0;
            }
        }

        function validateForm() {
            var checkboxes = document.getElementsByName('productIds');
            var selected = false;
            for (var i = 0; i < checkboxes.length; i++) {
                if (checkboxes[i].checked) {
                    selected = true;
                    var productId = checkboxes[i].value;
                    var qty = document.getElementById('qty_' + productId).value;
                    if (qty <= 0) {
                        alert('Please enter a quantity greater than 0 for all selected products.');
                        return false;
                    }
                }
            }
            if (!selected) {
                alert('Please select at least one product.');
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
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

    <form action="${pageContext.request.contextPath}/create-customer-order" method="post" onsubmit="return validateForm()">
        <c:choose>
            <c:when test="${not empty customer}">
                <input type="hidden" name="customerId" value="${customer.customer.customerId}" />
                <p>
                    <strong>Customer:</strong> ${customer.user.fullName} (${customer.user.userName})
                    <a href="${pageContext.request.contextPath}/create-customer-order" style="margin-left: 10px; text-decoration: none; color: blue; font-size: 0.9em;">[Change Customer]</a>
                </p>
            </c:when>
            <c:otherwise>
                <div>
                    <label for="customerId"><strong>Select Customer:</strong></label>
                    <select name="customerId" id="customerId" required onchange="location.href='${pageContext.request.contextPath}/create-customer-order?customerId=' + this.value">
                        <option value="">-- Choose Customer --</option>
                        <c:forEach var="c" items="${customers}">
                            <option value="${c.customer.customerId}" ${param.customerId == c.customer.customerId ? 'selected' : ''}>${c.user.fullName} (${c.user.userName})</option>
                        </c:forEach>
                    </select>
                </div>
            </c:otherwise>
        </c:choose>
        
        <br>
        <div>
            <label for="customerContractId"><strong>Select Signed Contract:</strong></label>
            <select name="customerContractId" id="customerContractId" required>
                <option value="">-- Choose Contract --</option>
                <c:forEach var="con" items="${contracts}">
                    <option value="${con.contractId}">${con.contractNumber} (${con.status})</option>
                </c:forEach>
            </select>
            <c:if test="${empty contracts && not empty customer}">
                <span style="color: red; margin-left: 10px;">No signed contracts available!</span>
            </c:if>
        </div>

        <h3>Select Products</h3>

        <table border="1" cellpadding="10" cellspacing="0">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Select</th>
                    <th>Product Name</th>
                    <th>Price</th>
                    <th>Unit</th>
                    <th>Quantity</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${products}" varStatus="loop">
                    <tr>
                        <td>${loop.index + 1}</td>
                        <td>
                            <input type="checkbox" name="productIds" value="${p.productId}" onchange="toggleQty(this, ${p.productId})" />
                        </td>
                        <td>${p.productName}</td>
                        <td><fmt:formatNumber value="${p.sellingPrice}" type="currency" currencySymbol="₫"  maxFractionDigits="0"/></td>
                        <td>${p.unit}</td>
                        <td>
                            <input type="number" id="qty_${p.productId}" name="qty_${p.productId}" min="0" value="0" style="width: 60px;" disabled />
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <br>
        <button type="submit">Create Order</button>
    </form>
</body>
</html>
