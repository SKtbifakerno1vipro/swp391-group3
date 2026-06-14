<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Create Customer Order</title>
        <script>
            // Store selected products in localStorage: { productId: { name: string, price: number, quantity: number } }
            let selectedProducts = JSON.parse(localStorage.getItem('selectedOrderProducts')) || {};
            function toggleQty(checkbox, productId) {
                var qtyInput = document.getElementById('qty_' + productId);
                if (checkbox.checked) {
                    qtyInput.disabled = false;
                    if (qtyInput.value == 0)
                        qtyInput.value = 1;
                    selectedProducts[productId] = qtyInput.value;
                } else {
                    qtyInput.disabled = true;
                    qtyInput.value = 0;
                    delete selectedProducts[productId];
                }
                saveToStorage();
            }
            function updateQty(productId, value) {
                if (selectedProducts[productId]) {
                    selectedProducts[productId] = value;
                    saveToStorage();
                }

                function saveToStorage() {
                    localStorage.setItem('selectedOrderProducts', JSON.stringify(selectedProducts));
                }
            }
            // Khi trang load, phuc hoi trang thai cac checkbox tu localStorage
            window.onload = function () {
                for (let pid in selectedProducts) {
                    let checkbox = document.querySelector(`input[name="productIds"][value="${pid}"]`);
                    let qtyInput = document.getElementById('qty_' + pid);
                    if (checkbox) {
                        checkbox.checked = true;
                        qtyInput.disabled = false;
                        qtyInput.value = selectedProducts[pid];
                    }
                }
            };

            function validateForm() {
                // Truoc khi submit, tao cac hidden input cho toan bo san pham trong localStorage
                const form = document.querySelector('form');
                // Xoa cac input cu đe tranh trung lap
                const oldHidden = form.querySelectorAll('.hidden-product-data');
                oldHidden.forEach(el => el.remove());

                let count = 0;
                for (let pid in selectedProducts) {
                    let qty = selectedProducts[pid];
                    if (qty > 0) {
                        // Tao hidden input cho productId
                        let inputId = document.createElement('input');
                        inputId.type = 'hidden';
                        inputId.name = 'productIds';
                        inputId.value = pid;
                        inputId.className = 'hidden-product-data';
                        form.appendChild(inputId);

                        // Tao hidden input cho quantity (tuong ung name="qty_ID")
                        let inputQty = document.createElement('input');
                        inputQty.type = 'hidden';
                        inputQty.name = 'qty_' + pid;
                        inputQty.value = qty;
                        inputQty.className = 'hidden-product-data';
                        form.appendChild(inputQty);
                        count++;
                    }
                }

                if (count === 0) {
                    alert('Please select at least one product.');
                    return false;
                }

                // Xoa localStorage sau khi submit thanh cong (co the thuc hien o trang ket qua hoac tai đay)
                // localStorage.removeItem('selectedOrderProducts');
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
                        <select name="customerId" id="customerId" required onchange="location.href = '${pageContext.request.contextPath}/create-customer-order?customerId=' + this.value">
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
                        <option value="${con.contractId}">${con.contractNumber} (${con.contractStatus})</option>
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
            <div class="pagination" style="margin-top: 10px;">
                <c:if test="${currentProductPage > 1}">
                    <a href="?customerId=${param.customerId}&productPage=${currentProductPage - 1}">Previous</a>
                </c:if>
                <c:forEach begin="1" end="${totalProductPages}" var="i">
                    <a href="?customerId=${param.customerId}&productPage=${i}" 
                       style="margin: 0 5px; ${i == currentProductPage ? 'font-weight:bold; color:red;' : ''}">${i}</a>
                </c:forEach>
                

                <c:if test="${currentProductPage < totalProductPages}">
                    <a href="?customerId=${param.customerId}&productPage=${currentProductPage + 1}">Next</a>
                </c:if>
            </div>
            <br>
            <button type="submit">Create Order</button>
        </form>
    </body>
</html>
