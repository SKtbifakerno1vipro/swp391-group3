<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Quotation</title>
</head>
<body>

    <h1>Create Quotation</h1>
    
    <c:if test="${not empty error}">
        <p style="color: red;">${error}</p>
    </c:if>
    
    <form action="${pageContext.request.contextPath}/quotation-create" method="post">

        
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

        
        <div>
            <label>Product:</label>
            <select name="productId" required>
                <option value="">-- Select Product --</option>

                <c:forEach items="${products}" var="product">
                    <option value="${product.productId}">
                        ${product.productName}
                    </option>
                </c:forEach>
            </select>
        </div>

        <br>

       
        <div>
            <label>Quantity:</label>
            <input type="number" name="quantity" min="1" required>
        </div>

        <br>

        
        <div>
            <label>Selling Price:</label>
            <input type="number" name="sellingPrice" min="0" step="0.01" required>
        </div>

        <br>

        
        <div>
            <label>Discount Percent:</label>
            <input type="number" name="discountPercent" min="0" max="100" step="0.01" value="0" required>
        </div>

        <br>

        
        <div>
            <label>Tax Percent:</label>
            <input type="number" name="taxPercent" min="0" max="100" step="0.01" value="0" required>
        </div>

        <br>

        <button type="submit">Create Quotation</button>
        <a href="quotation-list">Back to List</a>
    </form>

</body>
</html>