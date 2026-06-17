<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>`n<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quotation Detail</title>

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

    <h1>Quotation Detail</h1>

    <%-- Hien thi thong bao sau khi thao tac. --%>
    <c:if test="${message == 'saveSuccess'}"><p style="color: green; font-weight: bold;">Save successfully.</p></c:if>
    <c:if test="${message == 'saveFailed'}"><p style="color: red; font-weight: bold;">Save failed. Please try again.</p></c:if>
    <c:if test="${message == 'addSuccess'}"><p style="color: green; font-weight: bold;">Product added successfully.</p></c:if>
    <c:if test="${message == 'addFailed'}"><p style="color: red; font-weight: bold;">Add product failed.</p></c:if>
    <c:if test="${message == 'deleteSuccess'}"><p style="color: green; font-weight: bold;">Product deleted successfully.</p></c:if>
    <c:if test="${message == 'deleteFailed'}"><p style="color: red; font-weight: bold;">Delete product failed.</p></c:if>
    <c:if test="${message == 'invalidInput'}"><p style="color: red; font-weight: bold;">Invalid input data.</p></c:if>
    <c:if test="${message == 'accepted'}"><p style="color: green; font-weight: bold;">Quotation accepted.</p></c:if>

    <%-- Khoi nay hien thi thong tin chung cua quotation. --%>
    <h2>General Information</h2>

    <table border="1" cellpadding="7" cellspacing="0">
        <tr><th>Quotation ID</th><td>${quotation.quotationId}</td></tr>
        <tr><th>Customer</th><td>${quotation.customerName}</td></tr>
        <tr><th>Quotation Date</th><td>${quotation.quotationDate}</td></tr>
        <tr><th>Status</th><td>${quotation.quotationStatus}</td></tr>
        <tr><th>Created By</th><td>${quotation.createdByName}</td></tr>
        <tr><th>Created At</th><td>${quotation.createdAt}</td></tr>
    </table>

    <br>

    <%-- Form them san pham moi vao quotation hien tai bang searchbar. --%>
    <h2>Add Product</h2>
    <form action="${pageContext.request.contextPath}/quotation-detail" method="post" onsubmit="return validateAddProductForm()">
        <input type="hidden" name="action" value="addProduct">
        <input type="hidden" name="quotationId" value="${quotation.quotationId}">
        <input type="hidden" name="productId" id="addProductId">

        <label>Search Product:</label>
        <input type="text" id="addProductSearch" placeholder="Type product name..." autocomplete="off" onkeyup="showProductSuggestions()">

        <%-- Hop goi y san pham sau khi search. --%>
        <div id="productSuggestions" style="border: 1px solid #ccc; max-width: 420px; display: none; background: white; position: absolute; z-index: 10;"></div>

        <span id="selectedProductName" style="font-weight: bold; color: green; margin-left: 10px;"></span>

        <br><br>

        <label>Quantity:</label>
        <input type="number" name="quantity" min="1" value="1" required>

        <label>Selling Price:</label>
        <input type="number" id="addSellingPrice" name="sellingPrice" min="0" step="0.01" readonly>

        <label>Discount %:</label>
        <input type="number" name="discountPercent" min="0" max="100" step="0.01" value="0" required>

        <label>Tax %:</label>
        <input type="number" name="taxPercent" min="0" max="100" step="0.01" value="0" required>

        <button type="submit">Add Product</button>
    </form>

    <br>

    <%-- Khoi nay hien thi va cho sua danh sach san pham trong quotation. --%>
    <h2>Product Details</h2>

    <table border="1" cellpadding="7" cellspacing="0" style="width: 100%;">
        <thead>
            <tr>
                <th>Product</th>
                <th>Quantity</th>
                <th>Selling Price</th>
                <th>Discount %</th>
                <th>Tax %</th>
                <th>Amount</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <c:if test="${empty details}">
                <tr><td colspan="7" style="text-align: center;">No product details found.</td></tr>
            </c:if>

            <c:forEach items="${details}" var="detail">
                <tr>
                    <form action="${pageContext.request.contextPath}/quotation-detail" method="post">
                        <td>
                            ${detail.productName}
                            <input type="hidden" name="productId" value="${detail.productId}">
                        </td>
                        <td><input type="number" name="quantity" min="1" value="${detail.quantity}" required></td>
                        <td><input type="number" name="sellingPrice" min="0" step="0.01" value="${detail.sellingPrice}" readonly></td>
                        <td><input type="number" name="discountPercent" min="0" max="100" step="0.01" value="${detail.discountPercent}" required></td>
                        <td><input type="number" name="taxPercent" min="0" max="100" step="0.01" value="${detail.taxPercent}" required></td>
                        <td><fmt:formatNumber value="${detail.amount}" type="number" minFractionDigits="2" maxFractionDigits="2" /></td>
                        <td>
                            <input type="hidden" name="quotationId" value="${quotation.quotationId}">
                            <input type="hidden" name="quotationDetailId" value="${detail.quotationDetailId}">
                            <button type="submit" name="action" value="updateDetail">Save</button>
                            <button type="submit" name="action" value="deleteProduct" onclick="return confirm('Delete this product from quotation?')">Delete</button>
                        </td>
                    </form>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <br>

    <%-- Khoi nay hien thi lich su negotiation cua quotation. --%>
    <h2>Negotiation History</h2>

    <table border="1" cellpadding="7" cellspacing="0" style="width: 100%;">
        <thead>
            <tr><th>Time</th><th>User ID</th><th>History</th></tr>
        </thead>
        <tbody>
            <c:if test="${empty histories}">
                <tr><td colspan="3" style="text-align: center;">No history found.</td></tr>
            </c:if>

            <c:forEach items="${histories}" var="history">
                <tr>
                    <td>${history.createdAt}</td>
                    <td>${history.createdBy}</td>
                    <td>${history.editHistory}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <br>
    <div style="margin-top: 20px;">
        <c:if test="${quotation.quotationStatus == 'DRAFT' || quotation.quotationStatus == 'PENDING'}">
            <form action="quotation-detail" method="POST" style="display:inline;">
                <input type="hidden" name="quotationId" value="${quotation.quotationId}">
                <input type="hidden" name="action" value="accept">
                <button type="submit" style="padding: 10px 20px; background-color: #4CAF50; color: white; border: none; cursor: pointer;">Accept Quotation</button>
            </form>
        </c:if>

        <c:if test="${sessionScope.user.roleId == 4 && quotation.quotationStatus == 'ACCEPTED'}">
            <a href="contract-generate?quotationId=${quotation.quotationId}">
                <button style="padding: 10px 20px; background-color: #008CBA; color: white; border: none; cursor: pointer;">Generate Draft Contract</button>
            </a>
        </c:if>
    </div>

    <br>
    <a href="${pageContext.request.contextPath}/quotation-list">Back to List</a>

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

        // Hien thi danh sach goi y theo keyword user dang go.
        function showProductSuggestions() {
            const keyword = document.getElementById('addProductSearch').value.toLowerCase().trim().replace(/\s+/g, ' ');
            const box = document.getElementById('productSuggestions');

            document.getElementById('addProductId').value = '';
            document.getElementById('selectedProductName').textContent = '';

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
                html += '<div style="padding: 8px; cursor: pointer; border-bottom: 1px solid #eee;" '
                    + 'onclick="selectProduct(\'' + product.id + '\', \'' + escapeSingleQuote(product.name) + '\', \'' + product.price + '\')">'
                    + product.name + ' - ' + product.price
                    + '</div>';
            });

            box.innerHTML = html;
            box.style.display = 'block';
        }

        // Chon 1 san pham tu goi y.
        function selectProduct(productId, productName, productPrice) {
            document.getElementById('addProductId').value = productId;
            document.getElementById('addProductSearch').value = productName;
            document.getElementById('selectedProductName').textContent = 'Selected: ' + productName;
            document.getElementById('addSellingPrice').value = productPrice;
            document.getElementById('productSuggestions').style.display = 'none';
        }

        // Khong cho add neu user chua chon san pham tu goi y.
        function validateAddProductForm() {
            if (document.getElementById('addProductId').value === '') {
                alert('Please select a product from suggestions.');
                return false;
            }
            return true;
        }

        // Xu ly dau nhay don trong ten san pham de JS khong bi loi.
        function escapeSingleQuote(text) {
            return text.replace(/'/g, "\\'");
        }
    </script>

            </main>
        </div>
    </body>
</html>





