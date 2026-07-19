<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Warehouse Dashboard - Po Bread Sales</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="dashboard"/>
            </jsp:include>
            <main class="main">
                <section class="topbar">
                    <div>
                        <p class="eyebrow">Warehouse Central Control</p>
                        <h1>Welcome back, <c:out value="${user.fullName}"/>.</h1>
                        <p>Hệ thống giám sát tồn kho, kiểm duyệt nhập hàng và điều phối đơn hàng.</p>
                    </div>
                </section>

                <%-- 1. TỔNG QUAN HỆ THỐNG (Summary Cards) --%>
                <section class="metric-grid" aria-label="Dashboard metrics" style="display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 20px; margin-bottom: 30px;">
                    <a class="metric-card tertiary" href="${pageContext.request.contextPath}/import-request-list" style="text-decoration: none;">
                        <div class="metric-icon"><span class="material-symbols-outlined">unarchive</span></div>
                        <p class="metric-value"><c:out value="${pendingImports}"/> Requests</p>
                        <p class="metric-label">Pending Import Requests</p>
                    </a>
                    <a class="metric-card danger" href="${pageContext.request.contextPath}/customer-order-list" style="text-decoration: none;">
                        <div class="metric-icon"><span class="material-symbols-outlined">shopping_cart</span></div>
                        <p class="metric-value"><c:out value="${pendingOrders}"/> Orders</p>
                        <p class="metric-label">Pending Orders</p>
                    </a>
                    <a class="metric-card info" href="${pageContext.request.contextPath}/product-list" style="text-decoration: none;">
                        <div class="metric-icon"><span class="material-symbols-outlined">inventory_2</span></div>
                        <p class="metric-value"><c:out value="${totalProducts}"/></p>
                        <p class="metric-label">Total Products</p>
                    </a>
                    <a class="metric-card danger" href="#low-stock-section" style="text-decoration: none; background-color: #fff0f0; border-color: #ffcccc;">
                        <div class="metric-icon" style="color: #d9534f;"><span class="material-symbols-outlined">warning</span></div>
                        <p class="metric-value" style="color: #d9534f;"><c:out value="${lowStockCount}"/> Products</p>
                        <p class="metric-label" style="color: #a94442;">Low Stock Products</p>
                    </a>
                </section>

                <%-- GỒM CÁC BẢNG THEO DÕI --%>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px; margin-bottom: 30px;">
                    
                    <%-- 2. LOW STOCK PRODUCTS --%>
                    <div class="panel table-panel" id="low-stock-section">
                        <div class="panel-title" style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--line); padding-bottom: 10px; margin-bottom: 15px;">
                            <h2 style="margin: 0; font-size: 18px; display: flex; align-items: center; gap: 8px;">
                                <span class="material-symbols-outlined" style="color: #d9534f;">warning</span>Sản phẩm sắp hết hàng
                            </h2>
                            <a class="badge" href="${pageContext.request.contextPath}/product-list" style="background-color: #f0ece4; color: #646b66; text-decoration: none; padding: 4px 8px; border-radius: 4px; font-size: 12px;">Xem tất cả</a>
                        </div>
                        <c:choose>
                            <c:when test="${empty lowStockProductsList}">
                                <div class="empty-state" style="padding: 20px; text-align: center; color: #888;">Tất cả sản phẩm đều đủ số lượng tồn kho an toàn.</div>
                            </c:when>
                            <c:otherwise>
                                <table border="0" cellpadding="8" cellspacing="0" style="width: 100%; border-collapse: collapse;">
                                    <thead>
                                        <tr style="border-bottom: 2px solid #ddd; background-color: #fdfaf7;">
                                            <th style="text-align: left; font-size: 11px;">Sản phẩm</th>
                                            <th style="text-align: left; font-size: 11px;">Danh mục</th>
                                            <th style="text-align: right; font-size: 11px;">Hiện có</th>
                                            <th style="text-align: center; font-size: 11px;">Trạng thái</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="p" items="${lowStockProductsList}">
                                            <tr style="border-bottom: 1px solid #eee;">
                                                <td style="font-weight: bold; font-size: 13px;">${p.productName}</td>
                                                <td style="font-size: 13px;">${p.categoryName}</td>
                                                <td style="text-align: right; font-weight: bold; font-size: 13px; color: ${p.status == 'Critical' ? '#d9534f' : '#f0ad4e'};">${p.available}</td>
                                                <td style="text-align: center;">
                                                    <c:choose>
                                                        <c:when test="${p.status == 'Critical'}">
                                                            <span style="background-color: #d9534f; color: white; padding: 2px 8px; border-radius: 4px; font-size: 11px; font-weight: bold;">Critical</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="background-color: #f0ad4e; color: white; padding: 2px 8px; border-radius: 4px; font-size: 11px; font-weight: bold;">Low</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <%-- 3. PENDING IMPORT REQUESTS --%>
                    <div class="panel table-panel">
                        <div class="panel-title" style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--line); padding-bottom: 10px; margin-bottom: 15px;">
                            <h2 style="margin: 0; font-size: 18px; display: flex; align-items: center; gap: 8px;">
                                <span class="material-symbols-outlined" style="color: #ff9800;">unarchive</span>Yêu cầu nhập kho chờ duyệt
                            </h2>
                            <a class="badge" href="${pageContext.request.contextPath}/import-request-list" style="background-color: #f0ece4; color: #646b66; text-decoration: none; padding: 4px 8px; border-radius: 4px; font-size: 12px;">Xem tất cả</a>
                        </div>
                        <c:choose>
                            <c:when test="${empty pendingImportRequestsList}">
                                <div class="empty-state" style="padding: 20px; text-align: center; color: #888;">Không có yêu cầu nhập kho nào đang chờ.</div>
                            </c:when>
                            <c:otherwise>
                                <table border="0" cellpadding="8" cellspacing="0" style="width: 100%; border-collapse: collapse;">
                                    <thead>
                                        <tr style="border-bottom: 2px solid #ddd; background-color: #fdfaf7;">
                                            <th style="text-align: left; font-size: 11px;">Mã yêu cầu</th>
                                            <th style="text-align: left; font-size: 11px;">Sản phẩm</th>
                                            <th style="text-align: right; font-size: 11px;">SL</th>
                                            <th style="text-align: left; font-size: 11px;">Người tạo</th>
                                            <th style="text-align: center; font-size: 11px;">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="ir" items="${pendingImportRequestsList}">
                                            <tr style="border-bottom: 1px solid #eee;">
                                                <td style="font-size: 13px;">IR-${ir.importId}</td>
                                                <td style="font-weight: bold; font-size: 13px;">${ir.productName}</td>
                                                <td style="text-align: right; font-weight: bold; font-size: 13px;">${ir.quantity}</td>
                                                <td style="font-size: 13px;">${ir.creatorName}</td>
                                                <td style="text-align: center;">
                                                    <a href="${pageContext.request.contextPath}/import-request-detail?id=${ir.importId}">
                                                        <button style="padding: 4px 8px; cursor: pointer; background-color: #4CAF50; color: white; border: none; border-radius: 4px; font-size: 11px;">Nhập kho</button>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div>

                </div>

                <%-- 4. RECENT ORDERS & QUICK ACTIONS --%>
                <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 30px;">
                    
                    <%-- RECENT ORDERS --%>
                    <div class="panel table-panel">
                        <div class="panel-title" style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--line); padding-bottom: 10px; margin-bottom: 15px;">
                            <h2 style="margin: 0; font-size: 18px; display: flex; align-items: center; gap: 8px;">
                                <span class="material-symbols-outlined" style="color: #4a7c59;">receipt_long</span>Đơn hàng gần đây
                            </h2>
                            <a class="badge" href="${pageContext.request.contextPath}/customer-order-list" style="background-color: #f0ece4; color: #646b66; text-decoration: none; padding: 4px 8px; border-radius: 4px; font-size: 12px;">Xem tất cả</a>
                        </div>
                        <c:choose>
                            <c:when test="${empty recentOrdersList}">
                                <div class="empty-state" style="padding: 20px; text-align: center; color: #888;">Không có đơn hàng nào gần đây.</div>
                            </c:when>
                            <c:otherwise>
                                <table border="0" cellpadding="8" cellspacing="0" style="width: 100%; border-collapse: collapse;">
                                    <thead>
                                        <tr style="border-bottom: 2px solid #ddd; background-color: #fdfaf7;">
                                            <th style="text-align: left; font-size: 11px;">Mã đơn</th>
                                            <th style="text-align: left; font-size: 11px;">Khách hàng</th>
                                            <th style="text-align: center; font-size: 11px;">Trạng thái</th>
                                            <th style="text-align: center; font-size: 11px;">Ngày tạo</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="o" items="${recentOrdersList}">
                                            <tr style="border-bottom: 1px solid #eee;">
                                                <td style="font-size: 13px;">OD-${o.orderId}</td>
                                                <td style="font-weight: bold; font-size: 13px;">${o.companyName}</td>
                                                <td style="text-align: center;">
                                                    <c:choose>
                                                        <c:when test="${o.status == 'COMPLETED'}">
                                                            <span style="background-color: #4caf50; color: white; padding: 2px 8px; border-radius: 4px; font-size: 11px; font-weight: bold;">Completed</span>
                                                        </c:when>
                                                        <c:when test="${o.status == 'CANCELLED'}">
                                                            <span style="background-color: #f44336; color: white; padding: 2px 8px; border-radius: 4px; font-size: 11px; font-weight: bold;">Cancelled</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span style="background-color: #ff9800; color: white; padding: 2px 8px; border-radius: 4px; font-size: 11px; font-weight: bold;">${o.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td style="text-align: center; font-size: 12px; color: #666;">
                                                    <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <%-- 5. QUICK ACTIONS --%>
                    <div class="panel" style="padding: 20px; background-color: #fffaf3; border: 1px solid var(--line); border-radius: 8px;">
                        <h2 style="margin-top: 0; font-size: 18px; border-bottom: 1px solid var(--line); padding-bottom: 10px; margin-bottom: 15px; display: flex; align-items: center; gap: 8px;">
                            <span class="material-symbols-outlined" style="color: #7a6148;">bolt</span>Thao tác nhanh
                        </h2>
                        <div style="display: flex; flex-direction: column; gap: 12px;">
                            <a href="${pageContext.request.contextPath}/product-list" style="text-decoration: none;">
                                <button style="width: 100%; padding: 12px; font-weight: bold; background-color: #fff; border: 1px solid #7a6148; color: #7a6148; border-radius: 4px; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 8px; transition: all 0.2s;">
                                    <span class="material-symbols-outlined">inventory_2</span> Quản lý Sản phẩm
                                </button>
                            </a>
                            <a href="${pageContext.request.contextPath}/customer-order-list" style="text-decoration: none;">
                                <button style="width: 100%; padding: 12px; font-weight: bold; background-color: #fff; border: 1px solid #4a7c59; color: #4a7c59; border-radius: 4px; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 8px; transition: all 0.2s;">
                                    <span class="material-symbols-outlined">receipt_long</span> Quản lý Đơn hàng
                                </button>
                            </a>
                            <a href="${pageContext.request.contextPath}/import-request-list" style="text-decoration: none;">
                                <button style="width: 100%; padding: 12px; font-weight: bold; background-color: #fff; border: 1px solid #b1812f; color: #b1812f; border-radius: 4px; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 8px; transition: all 0.2s;">
                                    <span class="material-symbols-outlined">unarchive</span> Yêu cầu nhập kho
                                </button>
                            </a>
                        </div>
                    </div>

                </div>

            </main>
        </div>
    </body>
</html>
