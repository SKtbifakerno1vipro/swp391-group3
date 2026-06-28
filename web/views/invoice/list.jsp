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
                        <form action="${pageContext.request.contextPath}/invoice-list" method="get" style="margin-bottom: 20px;">
                            <table style="border: none; margin-bottom: 15px;">
                                <tr style="border: none;">
                                    <td style="border: none; padding: 5px;">Buyer Name:</td>
                                    <td style="border: none; padding: 5px;"><input type="text" name="searchBuyerName" value="${searchBuyerName}"></td>
                                    
                                    <td style="border: none; padding: 5px; padding-left: 20px;">Status:</td>
                                    <td style="border: none; padding: 5px;">
                                        <select name="status">
                                            <option value="">All Statuses</option>
                                            <option value="RELEASED" ${status == 'RELEASED' ? 'selected' : ''}>RELEASED</option>
                                            <option value="UNRELEASED" ${status == 'UNRELEASED' ? 'selected' : ''}>UNRELEASED</option>
                                            <option value="CANCELED" ${status == 'CANCELED' ? 'selected' : ''}>CANCELED</option>
                                        </select>
                                    </td>
                                    
                                    <td style="border: none; padding: 5px; padding-left: 20px;">Type:</td>
                                    <td style="border: none; padding: 5px;">
                                        <select name="type">
                                            <option value="">All Types</option>
                                            <option value="VAT" ${type == 'VAT' ? 'selected' : ''}>VAT Invoice</option>
                                            <option value="SALES" ${type == 'SALES' ? 'selected' : ''}>Sales Invoice</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr style="border: none;">
                                    <td style="border: none; padding: 5px;">From Issue Date:</td>
                                    <td style="border: none; padding: 5px;"><input type="date" name="startDate" value="${startDate}"></td>
                                    
                                    <td style="border: none; padding: 5px; padding-left: 20px;">To Issue Date:</td>
                                    <td style="border: none; padding: 5px;"><input type="date" name="endDate" value="${endDate}"></td>
                                    
                                    <td colspan="2" style="border: none; padding: 5px; padding-left: 20px;">
                                        <input type="submit" value="Search" style="padding: 4px 12px;">
                                    </td>
                                </tr>
                            </table>
                        </form>
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
                                            <c:if test="${i.invoiceStatus != 'CANCELED'}">
                                                |
                                                <form action="${pageContext.request.contextPath}/invoice-list" method="post" style="display: inline;" onsubmit="return confirm('Bạn có chắc chắn muốn hủy hóa đơn này không?');">
                                                    <input type="hidden" name="action" value="cancel">
                                                    <input type="hidden" name="invoiceId" value="${i.invoiceId}">
                                                    <input type="submit" value="Cancel" style="padding: 2px 6px; font-size: 11px;">
                                                </form>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </table>
                        </div>

                        <div class="pagination">
                            <c:set var="numLinksTwoSide" value="2"></c:set>
                            <c:set var="start" value="${page - numLinksTwoSide > 1 ? page - numLinksTwoSide : 1}"></c:set>
                            <c:set var="end" value="${page + numLinksTwoSide > totalPage ? totalPage : page + numLinksTwoSide}"></c:set>

                                <a class="page-link" href="${pageContext.request.contextPath}/invoice-list?page=1&searchBuyerName=${searchBuyerName}&status=${status}&type=${type}&startDate=${startDate}&endDate=${endDate}">Begin</a>
                            <c:if test="${page != 1}">
                                <a class="page-link" href="${pageContext.request.contextPath}/invoice-list?page=${page - 1}&searchBuyerName=${searchBuyerName}&status=${status}&type=${type}&startDate=${startDate}&endDate=${endDate}">Previous</a>
                            </c:if>
                            <c:if test="${start > 1}">...</c:if>
                            <c:forEach var="pageNum" begin="${start}" end="${end}">
                                <a href="${pageContext.request.contextPath}/invoice-list?page=${pageNum}&searchBuyerName=${searchBuyerName}&status=${status}&type=${type}&startDate=${startDate}&endDate=${endDate}"><span class="${pageNum == page ? 'page-current' : 'page-link'}">${pageNum}</span></a>
                                </c:forEach>
                                <c:if test="${end < totalPage}">...</c:if>
                            <c:if test="${page < totalPage}">
                                <a class="page-link" href="${pageContext.request.contextPath}/invoice-list?page=${page + 1}&searchBuyerName=${searchBuyerName}&status=${status}&type=${type}&startDate=${startDate}&endDate=${endDate}">Next</a>
                            </c:if>
                            <a class="page-link" href="${pageContext.request.contextPath}/invoice-list?page=${totalPage}&searchBuyerName=${searchBuyerName}&status=${status}&type=${type}&startDate=${startDate}&endDate=${endDate}">End</a>
                        </div>

                        <div><a href="${pageContext.request.contextPath}/dashboard">Back to Dashboard</a></div>
                    </div>
                </div>
            </main>
        </div>
        <script>
            let error = "${errorInvoice}";
            if (error !== "null" && error !== "") {
                alert(error);
            }
        </script>
    </body>
</html>
