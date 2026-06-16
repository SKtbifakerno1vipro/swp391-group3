<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Customer List</title>
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
                    <h2>Customer Management (Member System)</h2>

                    <c:if test="${not empty success}">
                        <div style="color: green; margin-bottom: 10px;">Edit successful</div>
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
                        <a href="${pageContext.request.contextPath}/customer/create">Add Customer</a>
                    </div>

                    <form action="${pageContext.request.contextPath}/customer/list" method="GET" class="search-form-responsive">
                        <div class="search-group">
                            <label class="search-label">Search Filters:</label>
                            <div class="inputs-grid">
                                <input type="text" name="searchName" value="${searchName}" placeholder="Enter name..." />
                                <input type="text" name="searchSdt" value="${searchSdt}" placeholder="Enter phone..." />
                                <input type="text" name="searchEmail" value="${searchEmail}" placeholder="Enter email..." />
                                <input type="text" name="searchMst" value="${searchMst}" placeholder="Enter tax code..." />
                                <select name="type">
                                    <option value="">-- All Types --</option>
                                    <c:forEach var="typeCus" items="${listTypeCus}">
                                        <option value="${typeCus}" ${type eq typeCus ? 'selected' : '' }>${typeCus}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="actions-group">
                            <button type="submit" class="btn-search">Search</button>
                            <a href="${pageContext.request.contextPath}/customer/list" class="btn-clear">Clear Filter</a>
                        </div>
                    </form>

                    <table>
                        <thead>
                            <tr>
                                <th>Customer ID</th>
                                <th>Customer Name</th>
                                <th>Company Name</th>
                                <th>Email</th>
                                <th>Phone Number</th>
                                <th>Tax Code</th>
                                <th>Status</th>
                                <th>Created At</th>
                                <th>Last Updated</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty customers}">
                                <tr>
                                    <td colspan="10" style="text-align: center;">No customer data found</td>
                                </tr>
                            </c:if>

                            <c:forEach var="cust" items="${customers}">
                                <tr>
                                    <td>${cust.customer.customerId}</td>
                                    <td><strong>${cust.user.fullName}</strong></td>
                                    <td>${cust.customer.companyName}</td>
                                    <td>${cust.user.email}</td>
                                    <td>${cust.user.phone}</td>
                                    <td>${cust.customer.taxCode}</td>
                                    <td><span>${cust.user.status}</span></td>
                                    <td>${cust.user.createTimeString}</td>
                                    <td>${cust.user.updateTimeString}</td>
                                    <td>
                                        <a
                                            href="${pageContext.request.contextPath}/customer/detail?id_cus=${cust.customer.customerId}">Detail</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <c:set var="currentPage" value="${empty currentPage ? 1 : currentPage}" />
                    <c:set var="totalPages" value="${empty totalPages ? 1 : totalPages}" />

                    <c:if test="${totalPages > 1}">
                        <div class="pagination-container" style="margin-top: 20px; text-align: center;">

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
                                                href="${pageContext.request.contextPath}/customer/list?page=${currentPage - 1}&searchName=${searchName}&searchSdt=${searchSdt}&searchEmail=${searchEmail}&searchMst=${searchMst}&type=${type}">&lt;</a>
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
                                                        href="${pageContext.request.contextPath}/customer/list?page=${i}&searchName=${searchName}&searchSdt=${searchSdt}&searchEmail=${searchEmail}&searchMst=${searchMst}&type=${type}">${i}</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>

                                        <%-- Next button (>) --%>
                                            <c:choose>
                                                <c:when test="${currentPage < totalPages}">
                                                    <a
                                                        href="${pageContext.request.contextPath}/customer/list?page=${currentPage + 1}&searchName=${searchName}&searchSdt=${searchSdt}&searchEmail=${searchEmail}&searchMst=${searchMst}&type=${type}">&gt;</a>
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