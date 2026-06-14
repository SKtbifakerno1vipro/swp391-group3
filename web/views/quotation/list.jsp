<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>PÆ¡ Bread</title>
    </head>
    <body>
        <h1>Quotation List</h1>
        <p><a href="${pageContext.request.contextPath}/quotation-create">Create New Quotation</a></p>
        <form action="quotation-list" method="GET">
            Customer Name:
            <input type="text" name="search" value="${searchText}" placeholder="Enter customer name">

            Status:
            <select name="status">
                <option value="">-- Status --</option>
                <option value="DRAFT" ${status == 'DRAFT' ? 'selected' : ''}>DRAFT</option> 
                <option value="PENDING" ${status == 'PENDING' ? 'selected' : ''}>PENDING</option>
                <option value="ACCEPTED" ${status == 'ACCEPTED' ? 'selected' : ''}>ACCEPTED</option>
                <option value="REJECTED" ${status == 'REJECTED' ? 'selected' : ''}>REJECTED</option>
            </select>
            <button type="submit">Search</button>
            <a href="quotation-list"><button type="button">Reset</button></a>
        </form>

        <table border="1" cellpadding="7" cellspacing="0" style="margin-top: 20px; width: 100%;">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Customer</th>
                    <th>Quotation Date</th>
                    <th>Status</th>
                    <th>Created By</th>
                    <th>Created At</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%-- Neu danh sach rong thi hien thong bao --%>
                <c:if test="${empty quotationList}">
                    <tr>
                        <td colspan="7" style="text-align: center;">No quotations found.</td>
                    </tr>
                </c:if>


                <%-- Vòng lặp hiển thị từng báo giá --%>
                <c:forEach items="${quotationList}" var="quotation">
                    <tr>
                        <td>${quotation.quotationId}</td>
                        <td>${quotation.customerName}</td>
                        <td>${quotation.quotationDate}</td>
                        <td>${quotation.quotationStatus}</td>
                        <td>${quotation.createdByName}</td>
                        <td>${quotation.createdAt}</td>
                        <td>
                            <a href="quotation-detail?id=${quotation.quotationId}">view</a>
                        </td>
                        <td>
                            <a href="quotation-detail?id=${quotation.quotationId}">view</a>

                            <%-- Chỉ hiện nút Tạo hợp đồng nếu trạng thái là ACCEPTED --%>
                            <c:if test="${quotation.quotationStatus == 'ACCEPTED'}">
                                | <a href="contract-save?quotationId=${quotation.quotationId}" 
                                     style="color: green; font-weight: bold;">Tạo Hợp đồng</a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </body>
</html>