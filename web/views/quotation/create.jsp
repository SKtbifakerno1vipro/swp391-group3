<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>Tạo báo giá</title>

                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap"
                    rel="stylesheet">
                <link
                    href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
            </head>

            <body>
                <div class="dashboard-shell">
                    <jsp:include page="/views/shared/sidebar.jsp">
                        <jsp:param name="activeMenu" value="quotations" />
                    </jsp:include>
                    <main class="main legacy-page">

                        <h1>Tạo báo giá</h1>

                            <c:if test="${not empty error}">
                                <div style="background-color: #f8d7da; color: #721c24; padding: 12px 16px; margin-bottom: 20px; border: 1px solid #f5c6cb; border-radius: 6px; font-weight: bold; display: flex; align-items: center; gap: 8px;">
                                    <span class="material-symbols-outlined">error</span>
                                    <span><c:out value="${error}"/></span>
                                </div>
                            </c:if>

                            <%-- Form nay gui du lieu ve CreateQuotationController bang method POST. --%>
                                <form action="${pageContext.request.contextPath}/quotation-create" method="post">

                                    <%-- Dropdown chon khach hang. Du lieu customers duoc gui tu doGet(). --%>
                                        <div>
                                            <label>Khách hàng:</label>
                                            <select name="customerId" required>
                                                <option value="">-- Chọn khách hàng --</option>
                                                <c:forEach items="${customers}" var="customer">
                                                    <option value="${customer.customer.customerId}">
                                                        ${customer.customer.companyName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <br>

                                        <%-- Khu vuc search san pham va add vao quotation. --%>
                                            <h3>Tìm kiếm sản phẩm</h3>
                                            <div
                                                style="display: flex; gap: 8px; align-items: center; flex-wrap: wrap; position: relative;">
                                                <input type="text" id="productSearch"
                                                    placeholder="Tìm kiếm tên sản phẩm..." autocomplete="off"
                                                    onkeyup="showCreateProductSuggestions()" style="min-width: 300px;">
                                                <input type="hidden" id="selectedProductId">
                                                <input type="hidden" id="selectedProductName">
                                                <input type="hidden" id="selectedProductPrice">
                                                <input type="hidden" id="selectedProductCostPrice">
                                                <input type="hidden" id="selectedProductUnit">

                                                <button type="button" onclick="addSelectedProduct()">Thêm</button>

                                                <%-- Hop goi y san pham sau khi search. --%>
                                                    <div id="createProductSuggestions"
                                                        style="border: 1px solid #ccc; max-width: 420px; display: none; background: white; position: absolute; top: 34px; left: 0; z-index: 10;">
                                                    </div>
                                            </div>

                                            <br>

                                            <%-- Bang nay chua cac san pham da duoc add vao quotation. --%>
                                                <h3>Sản phẩm đã chọn</h3>
                                                <div
                                                    style="background-color: #f9f9f9; padding: 10px; margin-bottom: 15px; border: 1px solid #ddd; max-width: 600px;">
                                                    <strong>Áp dụng Chiết khấu & Thuế cho TẤT CẢ sản phẩm:</strong>
                                                    <br><br>
                                                    <label>Chiết khấu %:</label>
                                                    <input type="number" id="bulkDiscount" min="0" max="100" step="0.01"
                                                        value="0" >

                                                    <label style="margin-left: 15px;">Thuế %:</label>
                                                    <input type="number" id="bulkTax" min="0" max="100" step="0.01"
                                                        value="0">

                                                    <button type="button" onclick="applyBulkDiscountAndTax()"
                                                        style="margin-left: 15px; padding: 5px 10px; background-color: #008CBA; color: white; border: none; cursor: pointer;">Áp
                                                        dụng tất cả</button>
                                                </div>

                                                <div
                                                    style="overflow-x: auto; width: 100%; margin: 18px 0; border: 1px solid rgba(221, 213, 201, 0.85); border-radius: 8px;">
                                                    <table border="1" cellpadding="7" cellspacing="0" id="productTable"
                                                        style="width: 100%; min-width: 900px; margin: 0;">
                                                        <thead>
                                                            <tr>
                                                                <th>Sản phẩm</th>
                                                                <th>Đơn vị</th>
                                                                <th>Giá vốn</th>
                                                                <th>Giá bán</th>
                                                                <th>Số lượng</th>
                                                                <th>Chiết khấu %</th>
                                                                <th>Thuế %</th>
                                                                <th>Thành tiền</th>
                                                                <th>Hành động</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody id="productRows">
                                                            <%-- JS se add tung dong san pham vao day. --%>
                                                        </tbody>
                                                        <tfoot>
                                                            <tr>
                                                                <th colspan="7" style="text-align: right;">Tổng cộng:
                                                                </th>
                                                                <th id="grandTotal">0</th>
                                                                <th></th>
                                                            </tr>
                                                        </tfoot>
                                                    </table>
                                                </div>

                                                <br>

                                                <button type="submit">Tạo báo giá</button>
                                                <a href="${pageContext.request.contextPath}/quotation-list">Quay lại
                                                    danh sách</a>
                                </form>

                                <script>
                                    // Luu danh sach product tu server sang JavaScript de search goi y.
                                    const products = [
                                        <c:forEach items="${products}" var="product" varStatus="status">
                                            {
                                                id: '${product.productId}',
                                            name: '${product.productName}',
                                            price: '${product.sellingPrice}',
                                            costPrice: '${product.costPrice}',
                                            unit: '${product.unit}'
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
                                        document.getElementById('selectedProductCostPrice').value = '';
                                        document.getElementById('selectedProductUnit').value = '';

                                        if (keyword === '') {
                                            box.style.display = 'none';
                                            box.innerHTML = '';
                                            return;
                                        }

                                        const matchedProducts = products.filter(function (product) {
                                            return product.name.toLowerCase().includes(keyword);
                                        });

                                        if (matchedProducts.length === 0) {
                                            box.innerHTML = '<div style="padding: 8px; color: red;">Không tìm thấy sản phẩm nào</div>';
                                            box.style.display = 'block';
                                            return;
                                        }

                                        let html = '';
                                        matchedProducts.forEach(function (product) {
                                            html += '<div style="padding: 8px; cursor: pointer; border-bottom: 1px solid #eee;" data-id="' + product.id + '">'
                                                + product.name + ' - ' + product.price
                                                + '</div>';
                                        });

                                        box.innerHTML = html;
                                        box.style.display = 'block';

                                        const suggestionItems = box.querySelectorAll('div[data-id]');
                                        suggestionItems.forEach(function (item, index) {
                                            item.onclick = function () {
                                                const product = matchedProducts[index];
                                                selectCreateProduct(product.id, product.name, product.price, product.costPrice, product.unit);
                                            };
                                        });
                                    }

                                    // Chon 1 san pham tu goi y.
                                    function selectCreateProduct(productId, productName, productPrice, productCostPrice, productUnit) {
                                        document.getElementById('selectedProductId').value = productId;
                                        document.getElementById('selectedProductName').value = productName;
                                        document.getElementById('selectedProductPrice').value = productPrice;
                                        document.getElementById('selectedProductCostPrice').value = productCostPrice;
                                        document.getElementById('selectedProductUnit').value = productUnit;
                                        document.getElementById('productSearch').value = productName;
                                        document.getElementById('addProductId') ? document.getElementById('addProductId').value = productId : null; // compatibility
                                        document.getElementById('createProductSuggestions').style.display = 'none';
                                    }

                                    // Add san pham da chon vao bang selected products.
                                    function addSelectedProduct() {
                                        const productId = document.getElementById('selectedProductId').value;
                                        const productName = document.getElementById('selectedProductName').value;
                                        const sellingPrice = document.getElementById('selectedProductPrice').value;
                                        const costPrice = document.getElementById('selectedProductCostPrice').value;
                                        const unit = document.getElementById('selectedProductUnit').value;

                                        if (!productId) {
                                            return;
                                        }

                                        const tbody = document.getElementById('productRows');
                                        const existingProductInputs = tbody.querySelectorAll('input[name="productId"]');

                                        // Neu san pham da co trong bang thi chi tang quantity, khong them dong moi.
                                        for (let i = 0; i < existingProductInputs.length; i++) {
                                            if (existingProductInputs[i].value === productId) {
                                                const existingRow = existingProductInputs[i].closest('tr');
                                                const quantityInput = existingRow.querySelector('input[name="quantity"]');
                                                quantityInput.value = (parseInt(quantityInput.value) || 0) + 1;

                                                document.getElementById('productSearch').value = '';
                                                document.getElementById('selectedProductId').value = '';
                                                document.getElementById('selectedProductName').value = '';
                                                document.getElementById('selectedProductPrice').value = '';
                                                document.getElementById('selectedProductCostPrice').value = '';
                                                document.getElementById('selectedProductUnit').value = '';

                                                calculateTotals();
                                                return;
                                            }
                                        }

                                        const row = document.createElement('tr');

                                        row.innerHTML =
                                            '<td>'
                                            + productName
                                            + '<input type="hidden" name="productId" value="' + productId + '">'
                                            + '</td>'
                                            + '<td><input type="text" name="unit" value="' + unit + '" readonly style="width: 70px; padding: 4px; border: 1px solid #ccc; border-radius: 4px;"></td>'
                                            + '<td><input type="number" name="costPrice" min="0" step="0.01" value="' + costPrice + '" readonly style="width: 100px; padding: 4px; border: 1px solid #ccc; border-radius: 4px; background-color: #eee;"></td>'
                                            + '<td><input type="number" name="sellingPrice" min="0" step="0.01" value="' + sellingPrice + '" readonly style="width: 100px; padding: 4px; border: 1px solid #ccc; border-radius: 4px; background-color: #eee;"></td>'
                                            + '<td><input type="number" name="quantity" min="1" value="1" required oninput="calculateTotals()" style="width: 70px; padding: 4px; border: 1px solid #ccc; border-radius: 4px;"></td>'
                                            + '<td><input type="number" name="discountPercent" min="0" max="100" step="0.01" value="0" required oninput="calculateTotals()" style="width: 70px; padding: 4px; border: 1px solid #ccc; border-radius: 4px;"></td>'
                                            + '<td><input type="number" name="taxPercent" min="0" max="100" step="0.01" value="0" required oninput="calculateTotals()" style="width: 70px; padding: 4px; border: 1px solid #ccc; border-radius: 4px;"></td>'
                                            + '<td class="lineTotal" style="font-weight: bold; min-width: 100px;">0</td>'
                                            + '<td><button type="button" onclick="removeProductRow(this)" style="padding: 4px 8px; background-color: #ff4d4d; color: white; border: none; border-radius: 4px; cursor: pointer;">Xóa</button></td>';

                                        tbody.appendChild(row);

                                        document.getElementById('productSearch').value = '';
                                        document.getElementById('selectedProductId').value = '';
                                        document.getElementById('selectedProductName').value = '';
                                        document.getElementById('selectedProductPrice').value = '';
                                        document.getElementById('selectedProductCostPrice').value = '';
                                        document.getElementById('selectedProductUnit').value = '';

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

                                        rows.forEach(function (row) {
                                            const quantity = parseFloat(row.querySelector('input[name="quantity"]').value) || 0;
                                            const sellingPrice = parseFloat(row.querySelector('input[name="sellingPrice"]').value) || 0;
                                            const discountPercent = parseFloat(row.querySelector('input[name="discountPercent"]').value) || 0;
                                            const taxPercent = parseFloat(row.querySelector('input[name="taxPercent"]').value) || 0;

                                            const subtotal = quantity * sellingPrice;
                                            const discountAmount = subtotal * discountPercent / 100;
                                            const afterDiscount = subtotal - discountAmount;
                                            const taxAmount = afterDiscount * taxPercent / 100;
                                            const lineTotal = afterDiscount + taxAmount;

                                            row.querySelector('.lineTotal').textContent = lineTotal.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
                                            grandTotal += lineTotal;
                                        });

                                        document.getElementById('grandTotal').textContent = grandTotal.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
                                    }

                                    // Set cung muc discount va tax cho tat ca dong hien co
                                    function applyBulkDiscountAndTax() {
                                        const discount = document.getElementById('bulkDiscount').value || 0;
                                        const tax = document.getElementById('bulkTax').value || 0;
                                        const rows = document.querySelectorAll('#productRows tr');

                                        if (rows.length === 0) {
                                            return;
                                        }

                                        rows.forEach(function (row) {
                                            const discountInput = row.querySelector('input[name="discountPercent"]');
                                            const taxInput = row.querySelector('input[name="taxPercent"]');
                                            if (discountInput)
                                                discountInput.value = discount;
                                            if (taxInput)
                                                taxInput.value = tax;
                                        });

                                        calculateTotals();
                                    }
                                </script>

                    </main>
                </div>
            </body>

            </html>