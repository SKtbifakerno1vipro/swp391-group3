<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Po Bread - Báo giá</title>

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
            }
            .page-link, .page-current {
                min-width: 36px;
                height: 36px;
                display: grid;
                place-items: center;
                border-radius: 12px;
                font-weight: 900;
                text-decoration: none;
            }
            .page-link {
                background: var(--surface-soft, #f0ece4);
                color: var(--muted, #646b66);
            }
            .page-link:hover, .page-current {
                background: var(--primary, #4a7c59);
                color: #fff;
            }
        </style>
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="quotations"/>
            </jsp:include>
            <main class="main legacy-page">
                <h1>Danh sách báo giá</h1>
                <c:if test="${sessionScope.user.roleId != 3}">
                    <p><a href="${pageContext.request.contextPath}/quotation-create">Tạo báo giá mới</a></p>
                </c:if>
                <form action="quotation-list" method="GET">
                    Tên khách hàng:
                    <input type="text" name="search" value="${searchText}" placeholder="Nhập tên khách hàng">

                    Trạng thái:
                    <select name="status">
                        <option value="">-- Trạng thái --</option>
                        <option value="DRAFT" ${status == 'DRAFT' ? 'selected' : ''}>DRAFT (Nháp)</option>
                        <option value="PENDING" ${status == 'PENDING' ? 'selected' : ''}>PENDING (Chờ duyệt)</option>
                        <option value="ACCEPTED" ${status == 'ACCEPTED' ? 'selected' : ''}>ACCEPTED (Đã duyệt)</option>
                        <option value="REJECTED" ${status == 'REJECTED' ? 'selected' : ''}>REJECTED (Đã từ chối)</option>
                    </select>

                    Từ ngày:
                    <input type="date" name="fromDate" value="${fromDate}">

                    Đến ngày:
                    <input type="date" name="toDate" value="${toDate}">

                    <button type="submit">Tìm kiếm</button>
                    <a href="quotation-list"><button type="button">Đặt lại</button></a>
                </form>

                <table border="1" cellpadding="7" cellspacing="0" style="margin-top: 20px; width: 100%;">
                    <thead>
                        <tr>
                            <th>Mã</th>
                            <th>Khách hàng</th>
                            <th>Ngày báo giá</th>
                            <th>Trạng thái</th>
                            <th>Tổng giá</th>
                            <th>Người tạo</th>
                            <th>Ngày tạo</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%-- Neu danh sach rong thi hien thong bao. --%>
                        <c:if test="${empty quotationList}">
                            <tr>
                                <td colspan="8" style="text-align: center;">Không tìm thấy báo giá nào.</td>
                            </tr>
                        </c:if>

                        <%-- Vong lap hien thi tung bao gia. --%>
                        <c:forEach items="${quotationList}" var="quotation">
                            <tr>
                                <td>${quotation.quotationId}</td>
                                <td>${quotation.customerName}</td>
                                <td>${quotation.formattedQuotationDate}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${quotation.quotationStatus == 'DRAFT'}">Nháp</c:when>
                                        <c:when test="${quotation.quotationStatus == 'PENDING'}">Chờ duyệt</c:when>
                                        <c:when test="${quotation.quotationStatus == 'ACCEPTED'}">Đã duyệt</c:when>
                                        <c:when test="${quotation.quotationStatus == 'REJECTED'}">Đã từ chối</c:when>
                                        <c:otherwise>${quotation.quotationStatus}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <fmt:formatNumber value="${quotation.totalPrice != null ? quotation.totalPrice : 0}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                </td>
                                <td>${quotation.createdByName}</td>
                                <td>${quotation.formattedCreatedAt}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${quotation.hasContract && quotation.contractId != null}">
                                            <a href="quotation-detail?id=${quotation.quotationId}">Xem chi tiết</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="quotation-detail?id=${quotation.quotationId}">Xem chi tiết</a>
                                        </c:otherwise>
                                    </c:choose>

                                    <%-- Chi hien nut tao hop dong neu trang thai la ACCEPTED. --%>
                                    <c:if test="${quotation.quotationStatus == 'ACCEPTED'}">
                                        <c:choose>
                                            <c:when test="${quotation.hasContract && quotation.contractId != null}">
                                                | <a href="contract-detail?id=${quotation.contractId}" style="color: blue; font-weight: bold;">Xem hợp đồng</a>
                                            </c:when>
                                            <c:otherwise>
                                                <c:if test="${sessionScope.user.roleId == 1 || sessionScope.user.roleId == 5}">
                                                    | <a href="contract-save?quotationId=${quotation.quotationId}" style="color: green; font-weight: bold;">Tạo hợp đồng</a>
                                                </c:if>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <%-- Thanh phan trang giong Role module --%>
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
                </div>
            </main>
        </div>
    </body>
</html>