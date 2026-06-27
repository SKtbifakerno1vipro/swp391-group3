<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Contract List - Po Bread Sales</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="contracts"/>
            </jsp:include>
            <main class="main legacy-page">
                <h2>Contract Management</h2>

                <form action="contract-list" method="GET">
                    <input type="text" name="contractNumber" value="${contractNumber}" placeholder="Contract number">
                    <input type="text" name="customerName" value="${customerName}" placeholder="Customer name">
                    <input type="text" name="customerTaxCode" value="${customerTaxCode}" placeholder="Customer tax code">
                    <input type="text" name="customerPhone" value="${customerPhone}" placeholder="Customer phone">
                    <input type="text" name="customerEmail" value="${customerEmail}" placeholder="Customer email">
                    <select name="status">
                        <option value="">-- All statuses --</option>
                        <option value="DRAFT" ${status == 'DRAFT' ? 'selected' : ''}>Draft</option>
                        <option value="PENDING_REVIEW" ${status == 'PENDING_REVIEW' ? 'selected' : ''}>Pending Review</option>
                        <option value="CUSTOMER_CHECK" ${status == 'CUSTOMER_CHECK' ? 'selected' : ''}>Customer Check</option>
                        <option value="APPROVED" ${status == 'APPROVED' ? 'selected' : ''}>Approved</option>
                        <option value="SIGNED" ${status == 'SIGNED' ? 'selected' : ''}>Signed</option>
                    </select>
                    <select name="storageType">
                        <option value="">-- Storage type --</option>
                        <option value="TEXT" ${storageType == 'TEXT' ? 'selected' : ''}>Text</option>
                        <option value="IMAGE" ${storageType == 'IMAGE' ? 'selected' : ''}>Image scan</option>
                    </select>
                    <br>
                    <label>From date</label>
                    <input type="date" name="fromDate" value="${fromDate}">
                    <label>To date</label>
                    <input type="date" name="toDate" value="${toDate}">
                    <button type="submit">Search</button>
                    <a href="${pageContext.request.contextPath}/contract-list">Reset filters</a>
                </form>

                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Contract Number</th>
                            <th>Customer</th>
                            <th>Status</th>
                            <th>Storage Type</th>
                            <th>Tax Code</th>
                            <th>Phone</th>
                            <th>Email</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty list}">
                            <tr><td colspan="9" style="text-align:center;">No contracts found.</td></tr>
                        </c:if>
                        <c:forEach items="${list}" var="c">
                            <tr>
                                <td>${c.contractId}</td>
                                <td>${c.contractNumber}</td>
                                <td>${c.customerName}</td>
                                <td>${c.contractStatus}</td>
                                <td>${c.storageType}</td>
                                <td>${c.taxCode}</td>
                                <td>${c.phone}</td>
                                <td>${c.email}</td>
                                <td>
                                    <c:if test="${sessionScope.user.roleId==5}">
                                        <c:if test="${c.contractStatus != 'SIGNED'}">
                                            <a href="${pageContext.request.contextPath}/contract-save?id=${c.contractId}">Edit</a> |      
                                        </c:if>                    
                                    </c:if>
                                    <a href="${pageContext.request.contextPath}/contract-detail?id=${c.contractId}">Details</a> 
                                    <c:if test="${c.contractStatus =='SIGNED'}">
                                        <c:choose>
                                            <c:when test="${c.orderId > 0}">
                                                <a href="${pageContext.request.contextPath}/customer-order?id=${c.orderId}">| View Order</a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}//customer-order?contractId=${c.contractId}">Create Order</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <c:if test="${endPage > 1}">
                    <c:set var="params" value="contractNumber=${contractNumber}&customerName=${customerName}
                           &status=${status}&storageType=${storageType}&fromDate=${fromDate}&toDate=${toDate}
                           &customerTaxCode=${customerTaxCode}&customerPhone=${customerPhone}&customerEmail=${customerEmail}" />
                    <div>
                        <a href="contract-list?page=1&${params}" ${currentPage == 1 ? 'style="pointer-events:none;color:#aaa;"' : ''}>&laquo;</a>
                        <a href="contract-list?page=${currentPage - 1}&${params}" ${currentPage == 1 ? 'style="pointer-events:none;color:#aaa;"' : ''}>&lsaquo;</a>
                        <c:forEach begin="${currentPage - 2 > 1 ? currentPage - 2 : 1}" end="${currentPage + 2 < endPage ? currentPage + 2 : endPage}" var="i">
                            <a href="contract-list?page=${i}&${params}" ${i == currentPage ? 'style="font-weight:bold;color:red;"' : ''}>${i}</a>&nbsp;
                        </c:forEach>
                        <a href="contract-list?page=${currentPage + 1}&${params}" ${currentPage == endPage ? 'style="pointer-events:none;color:#aaa;"' : ''}>&rsaquo;</a>
                        <a href="contract-list?page=${endPage}&${params}" ${currentPage == endPage ? 'style="pointer-events:none;color:#aaa;"' : ''}>&raquo;</a>
                    </div>
                </c:if>
            </main>
        </div>
    </body>
</html>
