<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Po Bread</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
        <style>
            .pagination { display: flex; align-items: center; justify-content: center; gap: 8px; padding: 20px; }
            .page-link, .page-current { min-width: 36px; height: 36px; display: grid; place-items: center; border-radius: 12px; font-weight: 900; text-decoration: none; }
            .page-link { background: var(--surface-soft, #f0ece4); color: var(--muted, #646b66); }
            .page-link:hover, .page-current { background: var(--primary, #4a7c59); color: #fff; }
        </style>
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="quotations"/>
            </jsp:include>
            <main class="main legacy-page">
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

            From Date:
            <input type="date" name="fromDate" value="${fromDate}">

            To Date:
            <input type="date" name="toDate" value="${toDate}">

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
                    <th>Total Price</th>
                    <th>Created By</th>
                    <th>Created At</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%-- Neu danh sach rong thi hien thong bao. --%>
                <c:if test="${empty quotationList}">
                    <tr>
                        <td colspan="8" style="text-align: center;">No quotations found.</td>
                    </tr>
                </c:if>

                <%-- Vong lap hien thi tung bao gia. --%>
                <c:forEach items="${quotationList}" var="quotation">
                    <tr>
                        <td>${quotation.quotationId}</td>
                        <td>${quotation.customerName}</td>
                        <td>${quotation.quotationDate}</td>
                        <td>${quotation.quotationStatus}</td>
                        <td>
                            <fmt:formatNumber value="${quotation.totalPrice != null ? quotation.totalPrice : 0}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                        </td>
                        <td>${quotation.createdByName}</td>
                        <td>${quotation.createdAt}</td>
                        <td>
                            <a href="quotation-detail?id=${quotation.quotationId}">View Detail</a>

                            <%-- Chi hien nut tao hop dong neu trang thai la ACCEPTED. --%>
                            <c:if test="${quotation.quotationStatus == 'ACCEPTED'}">
                                <c:choose>
                                    <c:when test="${quotation.hasContract}">
                                        | <a href="contract-detail?quotationId=${quotation.quotationId}" style="color: blue; font-weight: bold;">View Contract</a>
                                    </c:when>
                                    <c:otherwise>
                                        | <a href="contract-save?quotationId=${quotation.quotationId}" style="color: green; font-weight: bold;">Create Contract</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

<!--         Thanh phân trang giống Role module 
        <div class="pagination" style="margin-top: 20px;">
            <c:if test="${currentPage > 1}">
                <a class="page-link" href="${pageContext.request.contextPath}/quotation-list?page=${currentPage - 1}&search=${searchText}&status=${status}&fromDate=${fromDate}&toDate=${toDate}">&lt;</a>
            </c:if>
            <c:forEach begin="1" end="${totalPages}" var="i">
                <c:choose>
                    <c:when test="${i == currentPage}">
                        <span class="page-current">${i}</span>
                    </c:when>
                    <c:otherwise>
                        <a class="page-link" href="${pageContext.request.contextPath}/quotation-list?page=${i}&search=${searchText}&status=${status}&fromDate=${fromDate}&toDate=${toDate}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            <c:if test="${currentPage < totalPages}">
                <a class="page-link" href="${pageContext.request.contextPath}/quotation-list?page=${currentPage + 1}&search=${searchText}&status=${status}&fromDate=${fromDate}&toDate=${toDate}">&gt;</a>
            </c:if>
        </div>-->

            </main>
        </div>
    </body>
</html>


