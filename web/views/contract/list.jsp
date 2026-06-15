<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Contract List</title>
    </head>
    <body>
        <h2>Contract Management</h2>

        <!-- Search Form -->
        <form action="contract-list" method="GET">
            <input type="text" name="contractNumber" value="${contractNumber}" placeholder="Contract Number">
            <input type="text" name="customerName" value="${customerName}" placeholder="Customer Name">

            <select name="status">
                <option value="">-- All Status --</option>
                <option value="DRAFT" ${status == 'DRAFT' ? 'selected' : ''}>Draft</option>
                <option value="SIGNED" ${status == 'SIGNED' ? 'selected' : ''}>Signed</option>
                <option value="CANCELLED" ${status == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
            </select>

            <select name="storageType">
                <option value="">-- Storage Type --</option>
                <option value="TEXT" ${storageType == 'TEXT' ? 'selected' : ''}>Text</option>
                <option value="IMAGE" ${storageType == 'IMAGE' ? 'selected' : ''}>Image (Scan)</option>
            </select>

            <button type="submit">Search</button>
            <a href="contract-list">Clear</a>
        </form>

        <br>

        <!-- Data Table -->
        <table border="1" cellpadding="5">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Contract Number</th>
                    <th>Customer Name</th>
                    <th>Status</th>
                    <th>Storage Type</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <c:if test="${empty list}">
                <tr><td colspan="6" style="text-align:center;">No contracts found.</td></tr>
            </c:if>

            <c:forEach items="${list}" var="c">
                <tr>
                    <td>${c.contractId}</td>
                    <td>${c.contractNumber}</td>
                    <td>${c.customerName}</td>
                    <td>${c.contractStatus}</td>
                    <td>${c.storageType}</td>
                    <td>
                        <a href="contract-save?id=${c.contractId}">Edit</a> |
                        <a href="contract-detail?id=${c.contractId}">Detail</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <br>

    <!-- Pagination -->
<c:if test="${endPage > 1}">
    <c:set var="params" value="contractNumber=${contractNumber}&customerName=${customerName}&status=${status}&storageType=${storageType}" />
    <div>
        <a href="contract-list?page=1&${params}" ${currentPage == 1 ? 'style="pointer-events:none;color:#aaa;"' : ''}>&laquo;</a>
        <a href="contract-list?page=${currentPage - 1}&${params}" ${currentPage == 1 ? 'style="pointer-events:none;color:#aaa;"' : ''}>&lsaquo;</a>

        <c:forEach begin="${currentPage - 2 > 1 ? currentPage - 2 : 1}" 
                   end="${currentPage + 2 < endPage ? currentPage + 2 : endPage}" var="i">
            <a href="contract-list?page=${i}&${params}" ${i == currentPage ? 'style="font-weight:bold;color:red;"' : ''}>${i}</a>
        </c:forEach>

        <a href="contract-list?page=${currentPage + 1}&${params}" ${currentPage == endPage ? 'style="pointer-events:none;color:#aaa;"' : ''}>&rsaquo;</a>
        <a href="contract-list?page=${endPage}&${params}" ${currentPage == endPage ? 'style="pointer-events:none;color:#aaa;"' : ''}>&raquo;</a>
    </div>
</c:if>
</body>
</html>