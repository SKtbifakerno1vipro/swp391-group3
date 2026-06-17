<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                <%-- Neu danh sach rong thi hien thong bao. --%>
                <c:if test="${empty quotationList}">
                    <tr>
                        <td colspan="7" style="text-align: center;">No quotations found.</td>
                    </tr>
                </c:if>

                <%-- Vong lap hien thi tung bao gia. --%>
                <c:forEach items="${quotationList}" var="quotation">
                    <tr>
                        <td>${quotation.quotationId}</td>
                        <td>${quotation.customerName}</td>
                        <td>${quotation.quotationDate}</td>
                        <td>${quotation.quotationStatus}</td>
                        <td>${quotation.createdByName}</td>
                        <td>${quotation.createdAt}</td>
                        <td>
                            <a href="quotation-detail?id=${quotation.quotationId}">View Detail</a>

                            <%-- Chi hien nut tao hop dong neu trang thai la ACCEPTED. --%>
                            <c:if test="${quotation.quotationStatus == 'ACCEPTED'}">
                                | <a href="contract-save?quotationId=${quotation.quotationId}"
                                     style="color: green; font-weight: bold;">Create Contract</a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

            </main>
        </div>
    </body>
</html>

