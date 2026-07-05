<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Danh sách khách hàng</title>
            <style>
                table {
                    width: 100%;
                    border-collapse: collapse;
                    margin-top: 15px;
                }

                th,
                td {
                    border: 1px solid #ddd;
                    padding: 8px;
                    text-align: left;
                }

                th {
                    background-color: #f2f2f2;
                }

                .pagination-container a,
                .pagination-container span,
                .pagination-container strong {
                    margin: 0 4px;
                    padding: 5px 10px;
                    text-decoration: none;
                }

                .pagination-container a {
                    border: 1px solid #ddd;
                    color: #007bff;
                }

                .pagination-container strong {
                    border: 1px solid #007bff;
                    background-color: #007bff;
                    color: white;
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

                .search-label {
                    font-size: 11px;
                    font-weight: 800;
                    color: var(--muted);
                    text-transform: uppercase;
                    letter-spacing: 0.05em;
                    white-space: nowrap;
                    width: 130px;
                    flex-shrink: 0;
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

            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link
                href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap"
                rel="stylesheet">
            <link
                href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block"
                rel="stylesheet">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
        </head>

        <body>
            <div class="dashboard-shell">
                <jsp:include page="/views/shared/sidebar.jsp">
                    <jsp:param name="activeMenu" value="customers" />
                </jsp:include>
                <main class="main legacy-page">
                    <h2>Quản lý khách hàng (Hệ thống thành viên)</h2>

                    <c:if test="${not empty success}">
                        <div style="color: green; margin-bottom: 10px;">Chỉnh sửa thành công</div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div style="color: red; margin-bottom: 10px;">
                            ${error}
                            <c:if test="${not empty errorDetail}">
                                <br /><small>${errorDetail}</small>
                            </c:if>
                        </div>
                    </c:if>

                    <div style="margin-bottom: 15px;">
                        <a href="${pageContext.request.contextPath}/customer/create">Thêm khách hàng</a>
                    </div>

                    <form action="${pageContext.request.contextPath}/customer/list" method="GET"
                        class="search-form-responsive">
                        <!-- Row 1: Search Inputs -->
                        <div class="search-row">
                            <span class="search-label">Bộ lọc tìm kiếm:</span>
                            
                            <input type="text" name="searchName" value="${searchName}"
                                placeholder="Nhập tên..." class="input-small" />
                            <input type="text" name="searchSdt" value="${searchSdt}" placeholder="Nhập số điện thoại..." class="input-small" />
                            <input type="text" name="searchEmail" value="${searchEmail}"
                                placeholder="Nhập email..." class="input-small" />
                            <input type="text" name="searchMst" value="${searchMst}"
                                placeholder="Nhập mã số thuế..." class="input-small" />
                        </div>

                        <!-- Row 2: Select options & Actions -->
                        <div class="search-row">
                            <span class="search-label">Tùy chọn:</span>
                            
                            <select name="type" class="input-small">
                                <option value="">-- Tất cả phân loại --</option>
                                <c:forEach var="typeCus" items="${listTypeCus}">
                                    <option value="${typeCus}" ${type eq typeCus ? 'selected' : '' }>${typeCus}
                                    </option>
                                </c:forEach>
                            </select>
                            <c:if test="${sessionScope.user.roleId != 4}">
                                <select name="assignedToUserId" class="input-small">
                                    <option value="">-- Tất cả nhân viên Sale --</option>
                                    <c:forEach var="sale" items="${listSales}">
                                        <option value="${sale.userId}" ${assignedToUserId eq sale.userId
                                            ? 'selected' : '' }>${sale.fullName}</option>
                                    </c:forEach>
                                </select>
                            </c:if>
                            <select name="searchStatus" class="input-small">
                                <option value="">-- Tất cả trạng thái --</option>
                                <option value="ACTIVE" ${searchStatus eq 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                                <option value="INACTIVE" ${searchStatus eq 'INACTIVE' ? 'selected' : ''}>Ngừng hoạt động</option>
                            </select>
 
                            <span style="font-size: 11px; font-weight: 800; color: var(--muted); text-transform: uppercase; margin-left: 15px; letter-spacing: 0.05em; white-space: nowrap;">Hiển thị:</span>
                            <select name="pageSize" class="input-small" style="width: 100px !important;" onchange="this.form.submit()">
                                <option value="5" ${pageSize == 5 ? 'selected' : ''}>5 dòng</option>
                                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10 dòng</option>
                                <option value="20" ${pageSize == 20 ? 'selected' : ''}>20 dòng</option>
                            </select>
                            <span style="font-size: 11px; font-weight: 800; color: var(--muted); text-transform: uppercase; letter-spacing: 0.05em; white-space: nowrap;">trên trang</span>
 
                            <div class="actions-group">
                                <button type="submit" class="btn-search">Tìm kiếm</button>
                                <a href="${pageContext.request.contextPath}/customer/list" class="btn-clear">Xóa bộ lọc</a>
                            </div>
                        </div>
                    </form>

                    <table>
                        <thead>
                            <tr>
                                <th>Mã khách hàng</th>
                                <th>Tên khách hàng</th>
                                <th>Tên công ty</th>
                                <th>Email</th>
                                <th>Số điện thoại</th>
                                <th>Mã số thuế</th>
                                <th>Trạng thái</th>
                                <th>Cập nhật cuối</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty customersDTOs}">
                                <tr>
                                    <td colspan="9" style="text-align: center;">Không tìm thấy dữ liệu khách hàng nào</td>
                                </tr>
                            </c:if>

                            <c:forEach var="cust" items="${customersDTOs}">
                                <tr>
                                    <td>${cust.customer.customerId}</td>
                                    <td><strong>${cust.user.fullName}</strong></td>
                                    <td>${cust.customer.companyName}</td>
                                    <td>${cust.user.email}</td>
                                    <td>${cust.user.phone}</td>
                                    <td>${cust.customer.taxCode}</td>
                                    <td><span>${cust.user.status}</span></td>
                                    <td>${cust.user.updateTimeString}</td>
                                    <td>
                                        <a
                                            href="${pageContext.request.contextPath}/customer/detail?id_cus=${cust.customer.customerId}">Chi tiết</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <c:set var="currentPage" value="${empty currentPage ? 1 : currentPage}" />
                    <c:set var="totalPages" value="${empty totalPages ? 1 : totalPages}" />

                    <c:if test="${totalPages > 1}">
                        <div class="pagination-container" style="margin-top: 20px; text-align: center;">

                            <c:set var="queryParams" value="&searchName=${searchName}&searchSdt=${searchSdt}&searchEmail=${searchEmail}&searchMst=${searchMst}&type=${type}&assignedToUserId=${assignedToUserId}&searchStatus=${searchStatus}&pageSize=${pageSize}" />

                            <%-- Calculate page range for buttons --%>
                                <c:set var="startPage" value="${currentPage - 2}" />
                                <c:if test="${startPage < 1}">
                                    <c:set var="startPage" value="1" />
                                </c:if>
                                <c:set var="endPage" value="${startPage + 4}" />
                                <c:if test="${endPage > totalPages}">
                                    <c:set var="endPage" value="${totalPages}" />
                                    <c:set var="startPage" value="${endPage - 4 < 1 ? 1 : endPage - 4}" />
                                </c:if>

                                <%-- Back button (<) --%>
                                    <c:choose>
                                        <c:when test="${currentPage > 1}">
                                            <a
                                                href="${pageContext.request.contextPath}/customer/list?page=${currentPage - 1}${queryParams}">&lt;</a>
                                        </c:when>
                                        <c:otherwise>
                                            <span
                                                style="color: #999; border: 1px solid #ddd; padding: 5px 10px;">&lt;</span>
                                        </c:otherwise>
                                    </c:choose>

                                    <%-- Loop to show page numbers --%>
                                        <c:forEach var="i" begin="${startPage}" end="${endPage}">
                                            <c:choose>
                                                <c:when test="${i == currentPage}">
                                                    <strong>${i}</strong>
                                                </c:when>
                                                <c:otherwise>
                                                    <a
                                                        href="${pageContext.request.contextPath}/customer/list?page=${i}${queryParams}">${i}</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>

                                        <%-- Next button (>) --%>
                                            <c:choose>
                                                <c:when test="${currentPage < totalPages}">
                                                    <a
                                                        href="${pageContext.request.contextPath}/customer/list?page=${currentPage + 1}${queryParams}">&gt;</a>
                                                </c:when>
                                                <c:otherwise>
                                                    <span
                                                        style="color: #999; border: 1px solid #ddd; padding: 5px 10px;">&gt;</span>
                                                </c:otherwise>
                                            </c:choose>
                        </div>
                    </c:if>

                </main>
            </div>
        </body>

        </html>