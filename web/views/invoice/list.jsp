<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Invoice List</title>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
        <style>
            .pagination {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                padding: 20px;
                border-top: 1px solid var(--line);
            }
            .page-link, .page-current {
                min-width: 36px;
                height: 36px;
                display: grid;
                place-items: center;
                border-radius: 12px;
                font-weight: 900;
                text-decoration: none;
                color: whitesmoke;
            }
            .page-link {
                background: var(--surface-soft);
                color: var(--muted);
            }
            .page-current, .page-link:hover {
                background: var(--primary);
                color: #fff;
            }
            .disabled {
                opacity: .45;
                pointer-events: none;
            }
            .status-badge {
                padding: 4px 8px;
                border-radius: 8px;
                font-size: 12px;
                font-weight: 600;
                display: inline-block;
            }
            .status-released {
                background-color: rgba(40, 167, 69, 0.2);
                color: #28a745;
            }
            .status-unreleased {
                background-color: rgba(108, 117, 125, 0.2);
                color: #6c757d;
            }
            .status-waiting {
                background-color: rgba(0, 123, 255, 0.2);
                color: #007bff;
            }
            .status-canceled {
                background-color: rgba(220, 53, 69, 0.2);
                color: #dc3545;
            }
        </style>
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="invoices"/>
            </jsp:include>
            <main class="main legacy-page">
                <div>
                    <h1>Invoices</h1>
                    <c:if test="${errorMsg != null}">
                        <div style="color: red; margin-bottom: 10px;">${errorMsg}</div>
                    </c:if>

                    <div>
                        <div>
                            <table border="1">
                                <tr>
                                    <th>Invoice Id</th>
                                    <th>Invoice No</th>
                                    <th>Company Seller</th>
                                    <th>Contract Id</th>
                                    <th>Order Id</th>
                                    <th>Issue Date</th>
                                    <th>Invoice Type</th>
                                    <th>Invoice Symbol</th>
                                    <th>Total Amount</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                                <c:if test="${empty invoices}">
                                    <tr>
                                        <td colspan="11">No invoice found.</td>
                                    </tr>
                                </c:if>
                                <c:forEach var="i" items="${invoices}">
                                    <tr>
                                        <td>${i.invoiceId}</td>
                                        <td><strong>${i.invoiceNo}</strong></td>
                                        <td>${i.buyerName}</td>
                                        <td>${i.customerContractId}</td>
                                        <td>${i.customerOrderId}</td>
                                        <td>
                                            <fmt:parseDate value="${i.issueDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                            <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm" />
                                        </td>
                                        <td>${i.invoiceType}</td>
                                        <td>${i.invoiceSymbol}</td>
                                        <td><fmt:formatNumber value="${i.totalAmount}" pattern="#,##0.##"/> VND</td>
                                        <td>
                                            <span class="status-badge ${i.invoiceStatus == 'RELEASED' ? 'status-released' : (i.invoiceStatus == 'UNRELEASED' ? 'status-unreleased' : (i.invoiceStatus == 'WAIT_FOR_RELEASE' ? 'status-waiting' : 'status-canceled'))}">
                                                ${i.invoiceStatus}
                                            </span>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/invoice?invoiceId=${i.invoiceId}">View</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </table>
                        </div>

                        <div class="pagination">
                            <c:set var="numLinksTwoSide" value="2"></c:set>
                            <c:set var="start" value="${page - numLinksTwoSide > 1 ? page - numLinksTwoSide : 1}"></c:set>
                            <c:set var="end" value="${page + numLinksTwoSide > totalPage ? totalPage : page + numLinksTwoSide}"></c:set>

                                <a class="page-link" href="${pageContext.request.contextPath}/invoice-list?page=1">Begin</a>
                            <c:if test="${page != 1}">
                                <a class="page-link" href="${pageContext.request.contextPath}/invoice-list?page=${page - 1}">Previous</a>
                            </c:if>
                            <c:if test="${start > 1}">...</c:if>
                            <c:forEach var="pageNum" begin="${start}" end="${end}">
                                <a href="${pageContext.request.contextPath}/invoice-list?page=${pageNum}"><span class="${pageNum == page ? 'page-current' : 'page-link'}">${pageNum}</span></a>
                                </c:forEach>
                                <c:if test="${end < totalPage}">...</c:if>
                            <c:if test="${page < totalPage}">
                                <a class="page-link" href="${pageContext.request.contextPath}/invoice-list?page=${page + 1}">Next</a>
                            </c:if>
                            <a class="page-link" href="${pageContext.request.contextPath}/invoice-list?page=${totalPage}">End</a>
                        </div>

                        <div><a href="${pageContext.request.contextPath}/dashboard">Back to Dashboard</a></div>
                    </div>
                </div>
            </main>
        </div>
        <script>
            
            let error = ${errorInvoice};
            if (error !== "") {
                alert(error);
            }
        </script>
    </body>
</html>
