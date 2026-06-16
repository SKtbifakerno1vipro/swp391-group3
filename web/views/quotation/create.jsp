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
    <form action="${pageContext.request.contextPath}/quotation-create" method="post">

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

        <%-- Bang nay cho phep tao nhieu san pham trong 1 quotation. --%>
        <h3>Products</h3>
        <table border="1" cellpadding="7" cellspacing="0" id="productTable">
            <thead>
                <tr>
                    <th>Product</th>
                    <th>Quantity</th>
                    <th>Selling Price</th>
                    <th>Discount %</th>
                    <th>Tax %</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody id="productRows">
                <tr>
                    <td>
                        <select name="productId" required>
                            <option value="">-- Select Product --</option>
                            <c:forEach items="${products}" var="product">
                                <option value="${product.productId}">
                                    ${product.productName}
                                </option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <input type="number" name="quantity" min="1" value="1" required>
                    </td>
                    <td>
                        <input type="number" name="sellingPrice" min="0" step="0.01" required>
                    </td>
                    <td>
                        <input type="number" name="discountPercent" min="0" max="100" step="0.01" value="0" required>
                    </td>
                    <td>
                        <input type="number" name="taxPercent" min="0" max="100" step="0.01" value="0" required>
                    </td>
                    <td>
                        <button type="button" onclick="removeProductRow(this)">Remove</button>
                    </td>
                </tr>
            </tbody>
        </table>

        <br>

        <button type="button" onclick="addProductRow()">Add Product</button>
        <button type="submit">Create Quotation</button>
        <a href="${pageContext.request.contextPath}/quotation-list">Back to List</a>
    </form>

    <%-- Template an de clone khi bam Add Product. --%>
    <table style="display: none;">
        <tbody>
            <tr id="productRowTemplate">
                <td>
                    <select name="productId" required>
                        <option value="">-- Select Product --</option>
                        <c:forEach items="${products}" var="product">
                            <option value="${product.productId}">
                                ${product.productName}
                            </option>
                        </c:forEach>
                    </select>
                </td>
                <td>
                    <input type="number" name="quantity" min="1" value="1" required>
                </td>
                <td>
                    <input type="number" name="sellingPrice" min="0" step="0.01" required>
                </td>
                <td>
                    <input type="number" name="discountPercent" min="0" max="100" step="0.01" value="0" required>
                </td>
                <td>
                    <input type="number" name="taxPercent" min="0" max="100" step="0.01" value="0" required>
                </td>
                <td>
                    <button type="button" onclick="removeProductRow(this)">Remove</button>
                </td>
            </tr>
        </tbody>
    </table>

    <script>
        // Them 1 dong san pham moi vao bang.
        function addProductRow() {
            const template = document.getElementById('productRowTemplate');
            const newRow = template.cloneNode(true);
            newRow.removeAttribute('id');
            document.getElementById('productRows').appendChild(newRow);
        }

        // Xoa 1 dong san pham, nhung phai giu lai it nhat 1 dong.
        function removeProductRow(button) {
            const rows = document.querySelectorAll('#productRows tr');
            if (rows.length <= 1) {
                alert('Quotation must have at least one product.');
                return;
            }
            button.closest('tr').remove();
        }
    </script>


            </main>
        </div>
    </body>
</html>
