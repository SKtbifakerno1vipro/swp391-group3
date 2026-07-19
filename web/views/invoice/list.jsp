<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Danh sách hóa đơn</title>

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
                    <h1>Quản lý hóa đơn</h1>
                    <c:if test="${errorMsg != null}">
                        <div style="color: red; margin-bottom: 10px;">${errorMsg}</div>
                    </c:if>

                    <div>
                        <form action="${pageContext.request.contextPath}/invoice-list" method="get">
                            <table>
                                <tr>
                                    <td>Tìm kiếm:</td>
                                    <td><input type="text" name="searchBuyerName" value="${searchBuyerName}" placeholder="Tên, số HĐ, MST, SĐT..."></td>

                                    <td>Trạng thái:</td>
                                    <td>
                                        <select name="status">
                                            <option value="">Tất cả trạng thái</option>
                                            <option value="RELEASED" ${status == 'RELEASED' ? 'selected' : ''}>Đã phát hành</option>
                                            <option value="UNRELEASED" ${status == 'UNRELEASED' ? 'selected' : ''}>Chưa phát hành</option>
                                            <option value="CANCELED" ${status == 'CANCELED' ? 'selected' : ''}>Đã hủy</option>
                                        </select>
                                    </td>

                                    <td>Loại hóa đơn:</td>
                                    <td>
                                        <select name="type">
                                            <option value="">Tất cả loại</option>
                                            <option value="VAT" ${type == 'VAT' ? 'selected' : ''}>Hóa đơn GTGT</option>
                                            <option value="SALES" ${type == 'SALES' ? 'selected' : ''}>Hóa đơn bán hàng</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Từ ngày phát hành:</td>
                                    <td><input type="date" name="startDate" value="${startDate}"></td>

                                    <td>Đến ngày phát hành:</td>
                                    <td><input type="date" name="endDate" value="${endDate}"></td>

                                    <td>Cỡ trang:</td>
                                    <td>
                                        <div style="display: flex; gap: 10px; align-items: center;">
                                            <select name="pageSize" style="flex: 1;">
                                                <option value="5" ${pageSize == 5 || empty pageSize ? 'selected' : ''}>5</option>
                                                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                                <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                                                <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                                            </select>
                                            <input type="submit" value="Tìm kiếm">
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </form>
                        <div>
                            <table border="1">
                                <tr>
                                    <th>Mã hóa đơn</th>
                                    <th>Công ty khách hàng</th>
                                    <th>Số hợp đồng</th>
                                    <th>Mã đơn hàng</th>
                                    <th>Ngày phát hành</th>
                                    <th>Loại hóa đơn</th>
                                    <th>Ký hiệu hóa đơn</th>
                                    <th>Tổng tiền</th>
                                    <th>Trạng thái</th>
                                    <th>Hành động</th>
                                </tr>
                                <c:if test="${empty invoices}">
                                    <tr>
                                        <td colspan="11">Không tìm thấy hóa đơn nào.</td>
                                    </tr>
                                </c:if>
                                <c:forEach var="i" items="${invoices}">
                                    <tr>
                                        <td>${i.invoiceId}</td>
                                        <td>${i.buyerName}</td>
                                        <td>${i.contractNo}</td>
                                        <td>${i.customerOrderId}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty i.issueDate}">
                                                    <fmt:parseDate value="${i.issueDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                    <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm" />
                                                </c:when>
                                                <c:otherwise>
                                                    Chưa phát hành
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${i.invoiceType == 'VAT'}">VAT</c:when>
                                                <c:when test="${i.invoiceType == 'SALES'}">SALES</c:when>
                                                <c:otherwise>${i.invoiceType}</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${i.invoiceSymbol}</td>
                                        <td><fmt:formatNumber value="${i.totalAmount}" pattern="#,##0.##"/> VND
                                        </td>
                                        <td>
                                            <span class="status-badge ${i.invoiceStatus == 'RELEASED' ? 'status-released' : (i.invoiceStatus == 'UNRELEASED' ? 'status-unreleased' : (i.invoiceStatus == 'WAIT_FOR_RELEASE' ? 'status-waiting' : 'status-canceled'))}">
                                                <c:choose>
                                                    <c:when test="${i.invoiceStatus == 'RELEASED'}">Đã phát hành</c:when>
                                                    <c:when test="${i.invoiceStatus == 'UNRELEASED'}">Chưa phát hành</c:when>
                                                    <c:when test="${i.invoiceStatus == 'WAIT_FOR_RELEASE'}">Chờ phát hành</c:when>
                                                    <c:when test="${i.invoiceStatus == 'CANCELED'}">Đã hủy</c:when>
                                                    <c:otherwise>${i.invoiceStatus}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td style="white-space: nowrap; vertical-align: middle;">
                                            <div style="display: inline-flex; gap: 8px; align-items: center;">
                                                <a href="${pageContext.request.contextPath}/invoice?invoiceId=${i.invoiceId}" style="text-decoration: none; padding: 4px 10px; background-color: var(--primary-soft); color: var(--primary); border-radius: 6px; font-size: 11px; font-weight: 800; display: inline-flex; align-items: center; justify-content: center; min-width: 45px;">Chi tiết</a>
                                                <c:if test="${i.invoiceStatus != 'CANCELED'}">
                                                    <form action="${pageContext.request.contextPath}/invoice-list" method="post" style="display: inline; margin: 0; padding: 0; background: none; border: none; box-shadow: none;" onsubmit="return confirm('Bạn có chắc chắn muốn hủy hóa đơn này không?');">
                                                        <input type="hidden" name="action" value="cancel">
                                                        <input type="hidden" name="invoiceId" value="${i.invoiceId}">
                                                        <c:if test="${sessionScope.user.roleId != 3}">
                                                            <input type="submit" value="Hủy" style="padding: 4px 10px; font-size: 11px; background-color: var(--danger-soft); color: var(--danger); border: none; border-radius: 6px; font-weight: 800; cursor: pointer; display: inline-flex; align-items: center; justify-content: center; min-width: 50px; line-height: normal;">
                                                        </c:if>
                                                    </form>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </table>
                        </div>

                        <div class="pagination">
                            <c:set var="numLinksTwoSide" value="2"></c:set>
                            <c:set var="start" value="${page - numLinksTwoSide > 1 ? page - numLinksTwoSide : 1}"></c:set>
                            <c:set var="end" value="${page + numLinksTwoSide > totalPage ? totalPage : page + numLinksTwoSide}"></c:set>

                                <a class="page-link" href="${pageContext.request.contextPath}/invoice-list?page=1&searchBuyerName=${searchBuyerName}&status=${status}&type=${type}&startDate=${startDate}&endDate=${endDate}&pageSize=${pageSize}">Đầu</a>
                            <c:if test="${page != 1}">
                                <a class="page-link" href="${pageContext.request.contextPath}/invoice-list?page=${page - 1}&searchBuyerName=${searchBuyerName}&status=${status}&type=${type}&startDate=${startDate}&endDate=${endDate}&pageSize=${pageSize}">Trước</a>
                            </c:if>
                            <c:if test="${start > 1}">...</c:if>
                            <c:forEach var="pageNum" begin="${start}" end="${end}">
                                <a href="${pageContext.request.contextPath}/invoice-list?page=${pageNum}&searchBuyerName=${searchBuyerName}&status=${status}&type=${type}&startDate=${startDate}&endDate=${endDate}&pageSize=${pageSize}"><span class="${pageNum == page ? 'page-current' : 'page-link'}">${pageNum}</span></a>
                                </c:forEach>
                                <c:if test="${end < totalPage}">...</c:if>
                            <c:if test="${page < totalPage}">
                                <a class="page-link" href="${pageContext.request.contextPath}/invoice-list?page=${page + 1}&searchBuyerName=${searchBuyerName}&status=${status}&type=${type}&startDate=${startDate}&endDate=${endDate}&pageSize=${pageSize}">Sau</a>
                            </c:if>
                            <a class="page-link" href="${pageContext.request.contextPath}/invoice-list?page=${totalPage}&searchBuyerName=${searchBuyerName}&status=${status}&type=${type}&startDate=${startDate}&endDate=${endDate}&pageSize=${pageSize}">Cuối</a>
                        </div>

                        <div><a href="${pageContext.request.contextPath}/dashboard">Quay lại Trang chủ</a></div>
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
