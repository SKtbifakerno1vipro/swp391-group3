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
    <%-- Hien thi thong bao sau khi bam Save. --%>
    <c:if test="${message == 'saveSuccess'}">
        <p style="color: green; font-weight: bold;">Save successfully.</p>
    </c:if>
    <c:if test="${message == 'saveFailed'}">
        <p style="color: red; font-weight: bold;">Save failed. Please try again.</p>
    </c:if>
    <c:if test="${message == 'invalidInput'}">
        <p style="color: red; font-weight: bold;">Invalid input data.</p>
    </c:if>

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
            <%-- Neu khong co san pham nao thi bao rong. --%>
            <c:if test="${empty details}">
                <tr>
                    <td colspan="7" style="text-align: center;">No product details found.</td>
                </tr>
            </c:if>

            <%-- Moi dong san pham la 1 form edit rieng. --%>
            <c:forEach items="${details}" var="detail">
                <tr>
                    <form action="${pageContext.request.contextPath}/quotation-detail" method="post">
                        <td>${detail.productName}</td>
                        <td>
                            <input type="number" name="quantity" min="1" value="${detail.quantity}" required>
                        </td>
                        <td>
                            <input type="number" name="sellingPrice" min="0" step="0.01" value="${detail.sellingPrice}" required>
                        </td>
                        <td>
                            <input type="number" name="discountPercent" min="0" max="100" step="0.01" value="${detail.discountPercent}" required>
                        </td>
                        <td>
                            <input type="number" name="taxPercent" min="0" max="100" step="0.01" value="${detail.taxPercent}" required>
                        </td>
                        <td>${detail.amount}</td>
                        <td>
                            <%-- quotationId de redirect ve dung trang detail sau khi save. --%>
                            <input type="hidden" name="quotationId" value="${quotation.quotationId}">

                            <%-- quotationDetailId de DAO biet can update dong nao. --%>
                            <input type="hidden" name="quotationDetailId" value="${detail.quotationDetailId}">

                            <button type="submit">Save</button>
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
            <tr>
                <th>Time</th>
                <th>User ID</th>
                <th>History</th>
            </tr>
        </thead>
        <tbody>
            <c:if test="${empty histories}">
                <tr>
                    <td colspan="3" style="text-align: center;">No history found.</td>
                </tr>
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

    <a href="${pageContext.request.contextPath}/quotation-list">Back to List</a>

</body>
</html>