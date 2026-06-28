<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Payment Management - Po Bread Sales</title>
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
                gap: 16px;
                background: var(--surface) !important;
                border: 1px solid rgba(221, 213, 201, 0.85) !important;
                border-radius: 22px !important;
                box-shadow: var(--shadow) !important;
                padding: 22px !important;
                margin: 16px 0 22px !important;
            }

            .search-group {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            .search-label {
                font-size: 11px;
                font-weight: 800;
                color: var(--muted);
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }

            .inputs-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 12px;
            }

            .inputs-grid input,
            .inputs-grid select {
                width: 100%;
                box-sizing: border-box;
                padding: 10px 14px !important;
                font-size: 14px !important;
                border: 1px solid var(--line) !important;
                border-radius: 12px !important;
                color: var(--text) !important;
                background-color: #fff !important;
                outline: none;
                transition: border-color 0.2s ease;
            }

            .inputs-grid input:focus,
            .inputs-grid select:focus {
                border-color: var(--primary) !important;
            }

            .actions-group {
                display: flex;
                gap: 10px;
                align-items: center;
                justify-content: flex-end;
            }

            .btn-search {
                padding: 10px 24px !important;
                background-color: var(--primary) !important;
                color: white !important;
                border: none !important;
                border-radius: 999px !important;
                font-weight: 800 !important;
                cursor: pointer !important;
                transition: all 0.2s ease;
            }

            .btn-search:hover {
                transform: translateY(-2px);
                filter: brightness(1.1);
            }

            .btn-clear {
                padding: 10px 24px !important;
                background-color: var(--surface-soft) !important;
                color: var(--text) !important;
                border: 1px solid var(--line) !important;
                border-radius: 999px !important;
                text-decoration: none !important;
                font-weight: 800 !important;
                transition: all 0.2s ease;
                display: inline-block;
            }

            .btn-clear:hover {
                background-color: var(--surface-strong) !important;
                transform: translateY(-2px);
            }
        </style>
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="payments"/>
            </jsp:include>
            <main class="main legacy-page">
                <h2>Payment Management</h2>

                <form action="${pageContext.request.contextPath}/payment/list" method="GET" class="search-form-responsive">
                    <div class="search-group">
                        <label class="search-label">Search Payments:</label>
                        <div class="inputs-grid">
                            <c:if test="${sessionScope.user.roleId != 3}">
                                <input type="text" name="customerName" value="${customerName}" placeholder="Customer Name..." />
                            </c:if>
                            <input type="text" name="contractNumber" value="${contractNumber}" placeholder="Contract Number..." />
                            <select name="status">
                                <option value="">-- All Statuses --</option>
                                <option value="PENDING" ${status eq 'PENDING' ? 'selected' : ''}>Pending</option>
                                <option value="COMPLETED" ${status eq 'COMPLETED' ? 'selected' : ''}>Completed</option>
                                <option value="FAILED" ${status eq 'FAILED' ? 'selected' : ''}>Failed</option>
                            </select>
                            <input type="date" name="startDate" value="${startDate}" title="Paid Start Date" />
                            <input type="date" name="endDate" value="${endDate}" title="Paid End Date" />
                            <input type="number" step="0.01" name="minAmount" value="${minAmount}" placeholder="Min Amount..." />
                            <input type="number" step="0.01" name="maxAmount" value="${maxAmount}" placeholder="Max Amount..." />
                        </div>
                    </div>
                    <div class="actions-group">
                        <button type="submit" class="btn-search">Search</button>
                        <a href="${pageContext.request.contextPath}/payment/list" class="btn-clear">Clear Filters</a>
                    </div>
                </form>

                <table>
                    <thead>
                        <tr>
                            <th>Transaction ID</th>
                            <th>Contract Number</th>
                            <th>Customer Name</th>
                            <th>Amount</th>
                            <th>Payment Type</th>
                            <th>Status</th>
                            <th>Created Date</th>
                            <th>Processed Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty list}">
                            <tr><td colspan="9" style="text-align:center;">No payment transactions recorded.</td></tr>
                        </c:if>
                        <c:forEach items="${list}" var="p">
                            <tr>
                                <td>PAY-${p.paymentId}</td>
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
                                            System / Anonymous
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
                                        <c:when test="${p.paymentStatus == 'COMPLETED'}">
                                            <span class="badge badge-success">Completed</span>
                                        </c:when>
                                        <c:when test="${p.paymentStatus == 'FAILED'}">
                                            <span class="badge badge-danger">Failed</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-warning">${p.paymentStatus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${p.formattedCreatedAt}</td>
                                <td>${p.formattedPaidAt}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/payment/detail?id=${p.paymentId}" style="color: #0284c7; text-decoration: none; font-weight: bold;">View Details</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <c:if test="${totalPages > 1}">
                    <div class="pagination" style="margin-top: 20px;">
                        <c:set var="queryParams" value="&customerName=${customerName}&contractNumber=${contractNumber}&status=${status}&startDate=${startDate}&endDate=${endDate}&minAmount=${minAmount}&maxAmount=${maxAmount}" />
                        
                        <a class="page-link ${currentPage == 1 ? 'disabled' : ''}" 
                           href="${pageContext.request.contextPath}/payment/list?page=1${queryParams}">First</a>
                        
                        <a class="page-link ${currentPage == 1 ? 'disabled' : ''}" 
                           href="${pageContext.request.contextPath}/payment/list?page=${currentPage - 1}${queryParams}">Prev</a>
                        
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
                           href="${pageContext.request.contextPath}/payment/list?page=${currentPage + 1}${queryParams}">Next</a>
                        
                        <a class="page-link ${currentPage == totalPages ? 'disabled' : ''}" 
                           href="${pageContext.request.contextPath}/payment/list?page=${totalPages}${queryParams}">Last</a>
                    </div>
                </c:if>
            </main>
        </div>
    </body>
</html>
