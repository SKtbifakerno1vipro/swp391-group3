<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>`n<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Quotation</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
</head>
<body>
    <div class="dashboard-shell">
        <jsp:include page="/views/shared/sidebar.jsp">
            <jsp:param name="activeMenu" value="quotations"/>
        </jsp:include>
        <main class="main legacy-page">

            <h1>Create Quotation</h1>

            <%-- Neu Controller gui loi sang thi hien thi loi o day. --%>
            <c:if test="${not empty error}">
                <p style="color: red;">${error}</p>
            </c:if>

            <%-- Form nay gui du lieu ve CreateQuotationController bang method POST. --%>
            <form action="${pageContext.request.contextPath}/quotation-create" method="post" onsubmit="return validateBeforeSubmit()">

                <%-- Dropdown chon khach hang. Du lieu customers duoc gui tu doGet(). --%>
                <div>
                    <label>Customer:</label>
                    <select name="customerId" required>
                        <option value="">-- Select Customer --</option>
                        <c:forEach items="${customers}" var="customer">
                            <option value="${customer.customer.customerId}">
                                ${customer.customer.companyName}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <br>

                <%-- Khu vuc search san pham va add vao quotation. --%>
                <h3>Search Product</h3>
                <div style="display: flex; gap: 8px; align-items: center; flex-wrap: wrap; position: relative;">
                    <input type="text" id="productSearch" placeholder="Search product name..." autocomplete="off" onkeyup="showCreateProductSuggestions()" style="min-width: 300px;">
                    <input type="hidden" id="selectedProductId">
                    <input type="hidden" id="selectedProductName">
                    <input type="hidden" id="selectedProductPrice">

                    <button type="button" onclick="addSelectedProduct()">Add</button>
                    <span id="selectedProductText" style="font-weight: bold; color: green;"></span>

                    <%-- Hop goi y san pham sau khi search. --%>
                    <div id="createProductSuggestions" style="border: 1px solid #ccc; max-width: 420px; display: none; background: white; position: absolute; top: 34px; left: 0; z-index: 10;"></div>
                </div>

                <br>

                <%-- Bang nay chua cac san pham da duoc add vao quotation. --%>
                <h3>Selected Products</h3>
                <table border="1" cellpadding="7" cellspacing="0" id="productTable" style="width: 100%;">
                    <thead>
                        <tr>
                            <th>Product</th>
                            <th>Quantity</th>
                            <th>Selling Price</th>
                            <th>Discount %</th>
                            <th>Tax %</th>
                            <th>Line Total</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody id="productRows">
                        <%-- JS se add tung dong san pham vao day. --%>
                    </tbody>
                    <tfoot>
                        <tr>
                            <th colspan="5" style="text-align: right;">Grand Total:</th>
                            <th id="grandTotal">0</th>
                            <th></th>
                        </tr>
                    </tfoot>
                </table>

                <br>

                <button type="submit">Create Quotation</button>
                <a href="${pageContext.request.contextPath}/quotation-list">Back to List</a>
            </form>

            <script>
                // Luu danh sach product tu server sang JavaScript de search goi y.
                const products = [
                    <c:forEach items="${products}" var="product" varStatus="status">
                        {
                            id: '${product.productId}',
                            name: '${product.productName}',
                            price: '${product.sellingPrice}'
                        }${status.last ? '' : ','}
                    </c:forEach>
                ];

                // Hien thi goi y san pham khi user go search.
                function showCreateProductSuggestions() {
                    const keyword = document.getElementById('productSearch').value.toLowerCase().trim().replace(/\s+/g, ' ');
                    const box = document.getElementById('createProductSuggestions');

                    document.getElementById('selectedProductId').value = '';
                    document.getElementById('selectedProductName').value = '';
                    document.getElementById('selectedProductPrice').value = '';
                    document.getElementById('selectedProductText').textContent = '';

                    if (keyword === '') {
                        box.style.display = 'none';
                        box.innerHTML = '';
                        return;
                    }

                    const matchedProducts = products.filter(function(product) {
                        return product.name.toLowerCase().includes(keyword);
                    });

                    if (matchedProducts.length === 0) {
                        box.innerHTML = '<div style="padding: 8px; color: red;">No product found</div>';
                        box.style.display = 'block';
                        return;
                    }

                    let html = '';
                    matchedProducts.forEach(function(product) {
                        html += '<div style="padding: 8px; cursor: pointer; border-bottom: 1px solid #eee;" data-id="' + product.id + '">'
                            + product.name + ' - ' + product.price
                            + '</div>';
                    });

                    box.innerHTML = html;
                    box.style.display = 'block';

                    const suggestionItems = box.querySelectorAll('div[data-id]');
                    suggestionItems.forEach(function(item, index) {
                        item.onclick = function() {
                            const product = matchedProducts[index];
                            selectCreateProduct(product.id, product.name, product.price);
                        };
                    });
                }

                // Chon 1 san pham tu goi y.
                function selectCreateProduct(productId, productName, productPrice) {
                    document.getElementById('selectedProductId').value = productId;
                    document.getElementById('selectedProductName').value = productName;
                    document.getElementById('selectedProductPrice').value = productPrice;
                    document.getElementById('productSearch').value = productName;
                    document.getElementById('selectedProductText').textContent = 'Selected: ' + productName;
                    document.getElementById('createProductSuggestions').style.display = 'none';
                }

                // Add san pham da chon vao bang selected products.
                function addSelectedProduct() {
                    const productId = document.getElementById('selectedProductId').value;
                    const productName = document.getElementById('selectedProductName').value;
                    const sellingPrice = document.getElementById('selectedProductPrice').value;

                    if (!productId) {
                        alert('Please select a product from suggestions first.');
                        return;
                    }

                    const tbody = document.getElementById('productRows');
                    const row = document.createElement('tr');

                    row.innerHTML =
                        '<td>'
                        + productName
                        + '<input type="hidden" name="productId" value="' + productId + '">'
                        + '</td>'
                        + '<td><input type="number" name="quantity" min="1" value="1" required oninput="calculateTotals()"></td>'
                        + '<td><input type="number" name="sellingPrice" min="0" step="0.01" value="' + sellingPrice + '" readonly oninput="calculateTotals()"></td>'
                        + '<td><input type="number" name="discountPercent" min="0" max="100" step="0.01" value="0" required oninput="calculateTotals()"></td>'
                        + '<td><input type="number" name="taxPercent" min="0" max="100" step="0.01" value="0" required oninput="calculateTotals()"></td>'
                        + '<td class="lineTotal">0</td>'
                        + '<td><button type="button" onclick="removeProductRow(this)">Remove</button></td>';

                    tbody.appendChild(row);

                    document.getElementById('productSearch').value = '';
                    document.getElementById('selectedProductId').value = '';
                    document.getElementById('selectedProductName').value = '';
                    document.getElementById('selectedProductPrice').value = '';
                    document.getElementById('selectedProductText').textContent = '';

                    calculateTotals();
                }

                // Xoa 1 dong san pham khoi quotation.
                function removeProductRow(button) {
                    button.closest('tr').remove();
                    calculateTotals();
                }

                // Tinh line total va grand total.
                function calculateTotals() {
                    const rows = document.querySelectorAll('#productRows tr');
                    let grandTotal = 0;

                    rows.forEach(function(row) {
                        const quantity = parseFloat(row.querySelector('input[name="quantity"]').value) || 0;
                        const sellingPrice = parseFloat(row.querySelector('input[name="sellingPrice"]').value) || 0;
                        const discountPercent = parseFloat(row.querySelector('input[name="discountPercent"]').value) || 0;
                        const taxPercent = parseFloat(row.querySelector('input[name="taxPercent"]').value) || 0;

                        const subtotal = quantity * sellingPrice;
                        const discountAmount = subtotal * discountPercent / 100;
                        const afterDiscount = subtotal - discountAmount;
                        const taxAmount = afterDiscount * taxPercent / 100;
                        const lineTotal = afterDiscount + taxAmount;

                        row.querySelector('.lineTotal').textContent = lineTotal.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2});
                        grandTotal += lineTotal;
                    });

                    document.getElementById('grandTotal').textContent = grandTotal.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2});
                }

                // Khong cho submit neu chua add san pham nao.
                function validateBeforeSubmit() {
                    const rows = document.querySelectorAll('#productRows tr');
                    if (rows.length === 0) {
                        alert('Please add at least one product.');
                        return false;
                    }
                    return true;
                }
            </script>

        </main>
    </div>
</body>
</html>


