<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quotation Detail</title>
</head>
<body>

    <h1>Quotation Detail</h1>

    <%-- Khoi nay hien thi thong tin chung cua quotation. --%>
    <h2>General Information</h2>

    <table border="1" cellpadding="7" cellspacing="0">
        <tr>
            <th>Quotation ID</th>
            <td>${quotation.quotationId}</td>
        </tr>
        <tr>
            <th>Customer</th>
            <td>${quotation.customerName}</td>
        </tr>
        <tr>
            <th>Quotation Date</th>
            <td>${quotation.quotationDate}</td>
        </tr>
        <tr>
            <th>Status</th>
            <td>${quotation.quotationStatus}</td>
        </tr>
        <tr>
            <th>Created By</th>
            <td>${quotation.createdByName}</td>
        </tr>
        <tr>
            <th>Created At</th>
            <td>${quotation.createdAt}</td>
        </tr>
    </table>

    <br>

    <%-- Khoi nay hien thi danh sach san pham trong quotation. --%>
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
            </tr>
        </thead>
        <tbody>
            <%-- Neu khong co san pham nao thi bao rong. --%>
            <c:if test="${empty details}">
                <tr>
                    <td colspan="6" style="text-align: center;">No product details found.</td>
                </tr>
            </c:if>

            <%-- Lap qua tung dong quotation_detail. --%>
            <c:forEach items="${details}" var="detail">
                <tr>
                    <td>${detail.productName}</td>
                    <td>${detail.quantity}</td>
                    <td>${detail.sellingPrice}</td>
                    <td>${detail.discountPercent}</td>
                    <td>${detail.taxPercent}</td>
                    <td>${detail.amount}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <br>

    <a href="${pageContext.request.contextPath}/quotation-list">Back to List</a>

</body>
</html>