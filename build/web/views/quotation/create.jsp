<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
                <div style="display: flex; gap: 8px; align-items: center; flex-wrap: wrap;">
                    <input type="text" id="productSearch" placeholder="Search product name..." onkeyup="filterProductOptions()" style="min-width: 260px;">

                    <select id="productPicker" style="min-width: 320px;">
                        <option value="" data-price="0">-- Select Product --</option>
                        <c:forEach items="${products}" var="product">
                            <option value="${product.productId}" data-price="${product.sellingPrice}">
                                ${product.productName} - ${product.sellingPrice}
                            </option>
                        </c:forEach>
                    </select>

                    <button type="button" onclick="addSelectedProduct()">Add</button>
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
                // Loc danh sach san pham theo text search.
                function filterProductOptions() {
                    const keyword = document.getElementById('productSearch').value.toLowerCase().trim();
                    const options = document.querySelectorAll('#productPicker option');

                    options.forEach(function(option, index) {
                        if (index === 0) {
                            option.hidden = false;
                            return;
                        }

                        const text = option.textContent.toLowerCase();
                        option.hidden = keyword !== '' && !text.includes(keyword);
                    });
                }

                // Add san pham dang chon vao bang selected products.
                function addSelectedProduct() {
                    const picker = document.getElementById('productPicker');
                    const selectedOption = picker.options[picker.selectedIndex];

                    if (!picker.value) {
                        alert('Please select a product first.');
                        return;
                    }

                    const productId = picker.value;
                    const productText = selectedOption.textContent.trim();
                    const productName = productText.split(' - ')[0];
                    const sellingPrice = selectedOption.getAttribute('data-price');

                    const tbody = document.getElementById('productRows');
                    const row = document.createElement('tr');

                    row.innerHTML =
                        '<td>'
                        + productName
                        + '<input type="hidden" name="productId" value="' + productId + '">'
                        + '</td>'
                        + '<td><input type="number" name="quantity" min="1" value="1" required oninput="calculateTotals()"></td>'
                        + '<td><input type="number" name="sellingPrice" min="0" step="0.01" value="' + sellingPrice + '" required oninput="calculateTotals()"></td>'
                        + '<td><input type="number" name="discountPercent" min="0" max="100" step="0.01" value="0" required oninput="calculateTotals()"></td>'
                        + '<td><input type="number" name="taxPercent" min="0" max="100" step="0.01" value="0" required oninput="calculateTotals()"></td>'
                        + '<td class="lineTotal">0</td>'
                        + '<td><button type="button" onclick="removeProductRow(this)">Remove</button></td>';

                    tbody.appendChild(row);
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

                        row.querySelector('.lineTotal').textContent = lineTotal.toFixed(2);
                        grandTotal += lineTotal;
                    });

                    document.getElementById('grandTotal').textContent = grandTotal.toFixed(2);
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