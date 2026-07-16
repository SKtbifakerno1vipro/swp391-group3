<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thanh toán - Po Bread Sales</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
        <style>
            .badge {
                display: inline-block;
                padding: 4px 10px;
                border-radius: 9999px;
                font-size: 0.85rem;
                font-weight: 700;
                text-transform: uppercase;
                text-align: center;
            }
            .badge-success {
                background-color: #d1fae5;
                color: #065f46;
            }
            .badge-danger {
                background-color: #fee2e2;
                color: #991b1b;
            }
            .badge-warning {
                background-color: #fef3c7;
                color: #92400e;
            }
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
            
            /* Responsive Search Form Styles */
            .search-form-responsive {
                display: flex;
                flex-direction: column;
                gap: 12px;
                background: var(--surface) !important;
                border: 1px solid rgba(221, 213, 201, 0.85) !important;
                border-radius: 16px !important;
                box-shadow: var(--shadow) !important;
                padding: 16px 20px !important;
                margin: 16px 0 22px !important;
            }

            .search-row {
                display: flex;
                flex-wrap: wrap;
                align-items: center;
                gap: 12px;
                width: 100%;
            }

            .search-label,
            .range-title {
                font-size: 11px;
                font-weight: 800;
                color: var(--muted);
                text-transform: uppercase;
                letter-spacing: 0.05em;
                white-space: nowrap;
                width: 130px;
                flex-shrink: 0;
            }

            .range-separator {
                font-size: 12px;
                font-weight: 600;
                color: var(--muted);
                padding: 0 2px;
            }

            .input-small {
                box-sizing: border-box;
                padding: 6px 10px !important;
                font-size: 13px !important;
                border: 1px solid var(--line) !important;
                border-radius: 8px !important;
                color: var(--text) !important;
                background-color: #fff !important;
                outline: none;
                transition: border-color 0.2s ease;
                width: 145px !important;
                height: 34px !important;
            }

            .input-small[type="datetime-local"] {
                width: 190px !important;
            }

            .input-small[type="number"] {
                width: 160px !important;
            }

            .input-small:focus {
                border-color: var(--primary) !important;
            }

            .actions-group {
                display: flex;
                gap: 8px;
                align-items: center;
                margin-left: auto;
            }

            .btn-search {
                padding: 6px 18px !important;
                height: 34px !important;
                background-color: var(--primary) !important;
                color: white !important;
                border: none !important;
                border-radius: 999px !important;
                font-weight: 800 !important;
                cursor: pointer !important;
                transition: all 0.2s ease;
                font-size: 13px !important;
            }

            .btn-search:hover {
                transform: translateY(-1px);
                filter: brightness(1.1);
            }

            .btn-clear {
                padding: 6px 18px !important;
                height: 34px !important;
                box-sizing: border-box;
                line-height: 20px;
                background-color: var(--surface-soft) !important;
                color: var(--text) !important;
                border: 1px solid var(--line) !important;
                border-radius: 999px !important;
                text-decoration: none !important;
                font-weight: 800 !important;
                transition: all 0.2s ease;
                display: inline-flex;
                align-items: center;
                font-size: 13px !important;
            }

            .btn-clear:hover {
                background-color: var(--surface-strong) !important;
                transform: translateY(-1px);
            }
        </style>
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="payments"/>
            </jsp:include>
            <main class="main legacy-page">
                <h2>Quản lý thanh toán</h2>

                <c:if test="${not empty sessionScope.successMessage}">
                    <div style="color: #065f46; background-color: #d1fae5; border: 1px solid #10b981; padding: 12px; border-radius: 12px; margin-bottom: 20px; font-size: 14px; font-weight: bold; display: flex; align-items: center; gap: 8px;">
                        <span class="material-symbols-outlined" style="font-size: 20px;">check_circle</span>
                        ${sessionScope.successMessage}
                        <% session.removeAttribute("successMessage"); %>
                    </div>
                </c:if>
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div style="color: #991b1b; background-color: #fee2e2; border: 1px solid #ef4444; padding: 12px; border-radius: 12px; margin-bottom: 20px; font-size: 14px; font-weight: bold; display: flex; align-items: center; gap: 8px;">
                        <span class="material-symbols-outlined" style="font-size: 20px;">error</span>
                        ${sessionScope.errorMessage}
                        <% session.removeAttribute("errorMessage"); %>
                    </div>
                </c:if>                <form action="${pageContext.request.contextPath}/payment/list" method="GET" class="search-form-responsive">
                    <!-- Row 1: Basic search (Contract, Customer Name, Status) -->
                    <div class="search-row">
                        <span class="search-label">Tìm kiếm:</span>
                        
                        <c:if test="${sessionScope.user.roleId != 3}">
                            <input type="text" name="customerName" value="${customerName}" placeholder="Tên khách hàng..." class="input-small" />
                        </c:if>
                        
                        <input type="text" name="contractNumber" value="${contractNumber}" placeholder="Số hợp đồng..." class="input-small" />
                        
                        <select name="status" class="input-small">
                            <option value="">-- Trạng thái --</option>
                            <option value="PENDING" ${status eq 'PENDING' ? 'selected' : ''}>Chờ thanh toán</option>
                            <option value="COMPLETED" ${status eq 'COMPLETED' ? 'selected' : ''}>Đã hoàn tất</option>
                            <option value="FAILED" ${status eq 'FAILED' ? 'selected' : ''}>Thất bại</option>
                            <option value="CANCELLED" ${status eq 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                        </select>
                    </div>

                    <!-- Row 2: Date filter -->
                    <div class="search-row">
                        <span class="range-title">Ngày:</span>
                        <input type="datetime-local" name="startDate" value="${startDate}" title="Ngày bắt đầu" class="input-small" />
                        <span class="range-separator">đến</span>
                        <input type="datetime-local" name="endDate" value="${endDate}" title="Ngày kết thúc" class="input-small" />
                    </div>

                    <!-- Row 3: Amount filter & Buttons -->
                    <div class="search-row">
                        <span class="range-title">Số tiền:</span>
                        <input type="number" step="0.01" name="minAmount" value="${minAmount}" placeholder="Tối thiểu..." class="input-small" />
                        <span class="range-separator">đến</span>
                        <input type="number" step="0.01" name="maxAmount" value="${maxAmount}" placeholder="Tối đa..." class="input-small" />
                        
                        <span style="font-size: 11px; font-weight: 800; color: var(--muted); text-transform: uppercase; margin-left: 15px; letter-spacing: 0.05em;">Hiển thị:</span>
                        <select name="pageSize" class="input-small" style="width: 100px !important;" onchange="this.form.submit()">
                            <option value="5" ${pageSize == 5 ? 'selected' : ''}>5 dòng</option>
                            <option value="10" ${pageSize == 10 ? 'selected' : ''}>10 dòng</option>
                            <option value="15" ${pageSize == 15 ? 'selected' : ''}>15 dòng</option>
                            <option value="25" ${pageSize == 25 ? 'selected' : ''}>25 dòng</option>
                        </select>
                        <span style="font-size: 11px; font-weight: 800; color: var(--muted); text-transform: uppercase; letter-spacing: 0.05em; white-space: nowrap;">trên trang</span>
                        
                        <div class="actions-group">
                            <button type="submit" class="btn-search">Tìm kiếm</button>
                            <a href="${pageContext.request.contextPath}/payment/list" class="btn-clear">Xóa bộ lọc</a>
                        </div>
                    </div>
                </form>

                <table>
                    <thead>
                        <tr>
                    <tr>
                        <th>Mã giao dịch</th>
                        <th>Số hợp đồng</th>
                        <th>Tên khách hàng</th>
                        <th>Số tiền</th>
                        <th>Phương thức thanh toán</th>
                        <th>Trạng thái</th>
                        <th>Ngày tạo</th>
                        <th>Ngày thanh toán</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${empty list}">
                        <tr><td colspan="9" style="text-align:center;">Không có giao dịch thanh toán nào được ghi nhận.</td></tr>
                    </c:if>
                        <c:forEach items="${list}" var="p">
                            <tr>
                                <td>${p.paymentId}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.contractNumber}">
                                            ${p.contractNumber}
                                        </c:when>
                                        <c:otherwise>
                                            N/A
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.customerName}">
                                            ${p.customerName}
                                        </c:when>
                                        <c:otherwise>
                                            Hệ thống / Vô danh
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <strong style="color: #059669;">
                                        <fmt:formatNumber value="${p.amount}" type="number"/> VNĐ
                                    </strong>
                                </td>
                                <td>${p.paymentType}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.paymentStatus == 'PENDING'}">
                                            <span class="badge badge-warning">Chờ thanh toán</span>
                                        </c:when>
                                        <c:when test="${p.paymentStatus == 'COMPLETED'}">
                                            <span class="badge badge-success">Đã thanh toán</span>
                                        </c:when>
                                        <c:when test="${p.paymentStatus == 'FAILED'}">
                                            <span class="badge badge-danger">Thất bại</span>
                                        </c:when>
                                        <c:when test="${p.paymentStatus == 'CANCELLED'}">
                                            <span class="badge badge-danger">Đã hủy</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-warning">${p.paymentStatus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${p.formattedCreatedAt}</td>
                                <td>${p.formattedPaidAt}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/payment/detail?id=${p.paymentId}" style="color: #0284c7; text-decoration: none; font-weight: bold; margin-right: 10px; display: inline-block; vertical-align: middle;">Xem chi tiết</a>
                                    <c:if test="${p.paymentStatus == 'COMPLETED' && p.canIssue == true}">
                                        <a href="javascript:void(0);" onclick="if(confirm('Bạn có chắc chắn muốn phát hành hóa đơn cho thanh toán này?')) { document.getElementById('issueForm-${p.paymentId}').submit(); }" style="color: #059669; text-decoration: none; font-weight: bold; display: inline-block; vertical-align: middle;" onmouseover="this.style.textDecoration='underline';" onmouseout="this.style.textDecoration='none';">Xuất hóa đơn</a>
                                        <form id="issueForm-${p.paymentId}" action="${pageContext.request.contextPath}/invoice" method="POST" style="display: none;">
                                            <input type="hidden" name="customerContractId" value="${p.customerContractId}"/>
                                            <input type="hidden" name="action" value="notice"/>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <c:if test="${totalPages > 1}">
                    <div class="pagination" style="margin-top: 20px;">
                        <c:set var="queryParams" value="&customerName=${customerName}&contractNumber=${contractNumber}&status=${status}&startDate=${startDate}&endDate=${endDate}&minAmount=${minAmount}&maxAmount=${maxAmount}&pageSize=${pageSize}" />
                        
                        <a class="page-link ${currentPage == 1 ? 'disabled' : ''}" 
                           href="${pageContext.request.contextPath}/payment/list?page=1${queryParams}">Đầu</a>
                        
                        <a class="page-link ${currentPage == 1 ? 'disabled' : ''}" 
                           href="${pageContext.request.contextPath}/payment/list?page=${currentPage - 1}${queryParams}">Trước</a>
                        
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <c:choose>
                                <c:when test="${currentPage == i}">
                                    <span class="page-current">${i}</span>
                                </c:when>
                                <c:otherwise>
                                    <a class="page-link" 
                                       href="${pageContext.request.contextPath}/payment/list?page=${i}${queryParams}">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        
                        <a class="page-link ${currentPage == totalPages ? 'disabled' : ''}" 
                           href="${pageContext.request.contextPath}/payment/list?page=${currentPage + 1}${queryParams}">Tiếp</a>
                        
                        <a class="page-link ${currentPage == totalPages ? 'disabled' : ''}" 
                           href="${pageContext.request.contextPath}/payment/list?page=${totalPages}${queryParams}">Cuối</a>
                    </div>
                </c:if>
            </main>
        </div>
    </body>
</html>