<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh sách hợp đồng - Po Bread Sales</title>
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
                <h2>Quản lý Hợp đồng</h2>

                <form action="contract-list" method="GET">
                    <input type="text" name="contractNumber" value="${contractNumber}" placeholder="Mã hợp đồng">
                    <input type="text" name="customerName" value="${customerName}" placeholder="Tên khách hàng">
                    <input type="text" name="customerTaxCode" value="${customerTaxCode}" placeholder="Mã số thuế">
                    <input type="text" name="customerPhone" value="${customerPhone}" placeholder="Số điện thoại">
                    <input type="text" name="customerEmail" value="${customerEmail}" placeholder="Email">
                    <select name="status">
                        <option value="">-- Tất cả trạng thái --</option>
                        <option value="DRAFT" ${status == 'DRAFT' ? 'selected' : ''}>Nháp</option>
                        <option value="PENDING_REVIEW" ${status == 'PENDING_REVIEW' ? 'selected' : ''}>Chờ duyệt</option>
                        <option value="CUSTOMER_CHECK" ${status == 'CUSTOMER_CHECK' ? 'selected' : ''}>Chờ khách hàng duyệt</option>
                        <option value="APPROVED" ${status == 'APPROVED' ? 'selected' : ''}>Đã chốt</option>
                        <option value="SIGNED" ${status == 'SIGNED' ? 'selected' : ''}>Đã ký</option>
                    </select>
                    <select name="storageType">
                        <option value="">-- Hình thức lưu trữ --</option>
                        <option value="TEXT" ${storageType == 'TEXT' ? 'selected' : ''}>Văn bản</option>
                        <option value="IMAGE" ${storageType == 'IMAGE' ? 'selected' : ''}>Ảnh scan</option>
                    </select>
                    <br>
                    <label>Từ ngày</label>
                    <input type="date" name="fromDate" value="${fromDate}">
                    <label>Đến ngày</label>
                    <input type="date" name="toDate" value="${toDate}">
                    <button type="submit">Tìm kiếm</button>
                    <a href="${pageContext.request.contextPath}/contract-list">Xóa bộ lọc</a>
                </form>

                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Mã Hợp Đồng</th>
                            <th>Khách hàng</th>
                            <th>Trạng thái</th>
                            <th>Hình thức lưu</th>
                            <th>Mã số thuế</th>
                            <th>Số điện thoại</th>
                            <th>Ngày tạo</th>
                            <th>Email</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty list}">
                            <tr><td colspan="9" style="text-align:center;">Không tìm thấy hợp đồng nào.</td></tr>
                        </c:if>
                        <c:forEach items="${list}" var="c">
                            <tr>
                                <td>${c.contractId}</td>
                                <td>${c.contractNumber}</td>
                                <td>${c.customerName}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${c.contractStatus == 'DRAFT'}">Nháp</c:when>
                                        <c:when test="${c.contractStatus == 'PENDING_REVIEW'}">Chờ duyệt</c:when>
                                        <c:when test="${c.contractStatus == 'CUSTOMER_CHECK'}">Chờ khách duyệt</c:when>
                                        <c:when test="${c.contractStatus == 'APPROVED'}">Đã chốt</c:when>
                                        <c:when test="${c.contractStatus == 'SIGNED'}">Đã ký</c:when>
                                        <c:otherwise>${c.contractStatus}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${c.storageType}</td>
                                <td>${c.taxCode}</td>
                                <td>${c.phone}</td>
                                <td>${c.formattedCreatedAtDate}</td>
                                <td>${c.email}</td>
                                <td>
                                    <c:if test="${sessionScope.user.roleId==5}">
                                        <c:if test="${c.contractStatus != 'SIGNED' && c.contractStatus !='APPROVED'}">
                                            <a href="${pageContext.request.contextPath}/contract-save?id=${c.contractId}">Sửa</a> |      
                                        </c:if>                    
                                    </c:if>
                                    <a href="${pageContext.request.contextPath}/contract-detail?id=${c.contractId}">Chi tiết</a> 
                                    <c:if test="${c.contractStatus =='SIGNED'}">
                                        <c:choose>
                                            <c:when test="${c.orderId > 0}">
                                                <a href="${pageContext.request.contextPath}/customer-order?id=${c.orderId}">| Xem Đơn hàng</a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}//customer-order?contractId=${c.contractId}">| Tạo Đơn hàng</a>
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
