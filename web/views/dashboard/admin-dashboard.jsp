<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trang quản trị - Po Bread Sales</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    </head>
    <body>
        <div class="dashboard-shell">
            <!-- Reuse existing Sidebar -->
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="dashboard"/>
            </jsp:include>
            
            <main class="main">
                <!-- Top Header Section -->
                <section class="topbar">
                    <div>
                        <p class="eyebrow">Quản trị hệ thống</p>
                        <h1>Bảng điều khiển Admin</h1>
                        <p>Tổng quan về hiệu suất hệ thống, thống kê vai trò, trạng thái hợp đồng và lịch sử hoạt động hệ thống.</p>
                    </div>
                </section>

                <!-- SECTION 1: Summary Cards -->
                <section class="metric-grid" aria-label="Dashboard metrics">
                    <!-- Total Users -->
                    <a class="metric-card info" href="${pageContext.request.contextPath}/user-list">
                        <div class="metric-icon"><span class="material-symbols-outlined">manage_accounts</span></div>
                        <p class="metric-value"><c:out value="${summary.totalUsers}"/></p>
                        <p class="metric-label">Tổng số người dùng</p>
                    </a>
                    <!-- Total Customers -->
                    <a class="metric-card" href="${pageContext.request.contextPath}/customer/list">
                        <div class="metric-icon"><span class="material-symbols-outlined">groups</span></div>
                        <p class="metric-value"><c:out value="${summary.totalCustomers}"/></p>
                        <p class="metric-label">Tổng số khách hàng</p>
                    </a>
                    <!-- Total Products -->
                    <a class="metric-card secondary" href="${pageContext.request.contextPath}/product-list">
                        <div class="metric-icon"><span class="material-symbols-outlined">inventory_2</span></div>
                        <p class="metric-value"><c:out value="${summary.totalProducts}"/></p>
                        <p class="metric-label">Tổng số sản phẩm</p>
                    </a>
                    <!-- Total Contracts -->
                    <a class="metric-card tertiary" href="${pageContext.request.contextPath}/contract-list">
                        <div class="metric-icon"><span class="material-symbols-outlined">contract</span></div>
                        <p class="metric-value"><c:out value="${summary.totalContracts}"/></p>
                        <p class="metric-label">Tổng số hợp đồng</p>
                    </a>
                    <!-- Total Orders -->
                    <a class="metric-card danger" href="${pageContext.request.contextPath}/customer-order-list">
                        <div class="metric-icon"><span class="material-symbols-outlined">receipt_long</span></div>
                        <p class="metric-value"><c:out value="${summary.totalOrders}"/></p>
                        <p class="metric-label">Tổng số đơn hàng</p>
                    </a>
                    <!-- Total Invoices -->
                    <a class="metric-card pink" href="${pageContext.request.contextPath}/invoice-list">
                        <div class="metric-icon"><span class="material-symbols-outlined">receipt</span></div>
                        <p class="metric-value"><c:out value="${summary.totalInvoices}"/></p>
                        <p class="metric-label">Tổng số hóa đơn</p>
                    </a>
                </section>

                <!-- SECTION 2: Charts -->
                <section class="charts-grid" aria-label="Dashboard charts">
                    <!-- Users by Role Pie Chart -->
                    <div class="panel status-panel">
                        <div class="panel-title"><h2>Người dùng theo vai trò</h2></div>
                        <div class="chart-container">
                            <canvas id="usersRoleChart"></canvas>
                        </div>
                    </div>
                    <!-- Contracts by Status Bar Chart -->
                    <div class="panel status-panel">
                        <div class="panel-title"><h2>Hợp đồng theo trạng thái</h2></div>
                        <div class="chart-container">
                            <canvas id="contractsStatusChart"></canvas>
                        </div>
                    </div>
                    <!-- Orders by Status Doughnut Chart -->
                    <div class="panel status-panel">
                        <div class="panel-title"><h2>Đơn hàng theo trạng thái</h2></div>
                        <div class="chart-container">
                            <canvas id="ordersStatusChart"></canvas>
                        </div>
                    </div>
                </section>

                <!-- SECTION 3 & SECTION 4: Content Grid -->
                <section class="content-grid">
                    <!-- Section 3: Recent Activity Log Table -->
                    <div class="panel table-panel">
                        <div class="panel-title"><h2>Hoạt động hệ thống gần đây</h2></div>
                        <table>
                            <thead>
                                <tr>
                                    <th style="width: 20%;">Thời gian</th>
                                    <th style="width: 20%;">Người dùng</th>
                                    <th style="width: 15%;">Hành động</th>
                                    <th style="width: 20%;">Đối tượng tác động</th>
                                    <th style="width: 25%;">Mô tả</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="act" items="${recentActivities}">
                                    <tr>
                                        <td>
                                            <c:if test="${act.createdAt != null}">
                                                <fmt:parseDate value="${act.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" type="both" />
                                                <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd HH:mm:ss" />
                                            </c:if>
                                            <c:if test="${act.createdAt == null}">N/A</c:if>
                                        </td>
                                        <td><c:out value="${act.fullName != null ? act.fullName : 'System'}"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${act.actionType == 'CREATE'}">
                                                    <span class="badge create">CREATE</span>
                                                </c:when>
                                                <c:when test="${act.actionType == 'UPDATE'}">
                                                    <span class="badge update">UPDATE</span>
                                                </c:when>
                                                <c:when test="${act.actionType == 'DELETE'}">
                                                    <span class="badge delete">DELETE</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge other"><c:out value="${act.actionType}"/></span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><code><c:out value="${act.affectedObject}"/></code></td>
                                        <td style="font-weight: normal; color: var(--muted);"><c:out value="${act.description}"/></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty recentActivities}">
                                    <tr>
                                        <td colspan="5" style="text-align: center; color: var(--muted);">Không tìm thấy hoạt động gần đây nào.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>

                    <!-- Section 4: Quick System Info Panel -->
                    <div class="panel status-panel">
                        <div class="panel-title"><h2>Thông tin nhanh hệ thống</h2></div>
                        <div class="status-list">
                            <div class="status-item">
                                <span>Thời gian máy chủ</span>
                                <strong><c:out value="${serverTime}"/></strong>
                            </div>
                            <div class="status-item">
                                <span>Admin hiện tại</span>
                                <strong><c:out value="${adminName}"/></strong>
                            </div>
                            <div class="status-item">
                                <span>Tên cơ sở dữ liệu</span>
                                <strong><c:out value="${dbName}"/></strong>
                            </div>
                            <div class="status-item">
                                <span>Phiên bản ứng dụng</span>
                                <strong><c:out value="${appVersion}"/></strong>
                            </div>
                        </div>
                    </div>
                </section>
            </main>
        </div>

        <!-- SECTION 6: JavaScript for Chart.js -->
        <script>
            // --- Chart 1: Users by Role (Pie Chart) ---
            const usersRoleCtx = document.getElementById('usersRoleChart').getContext('2d');
            const usersRoleLabels = [
                <c:forEach var="r" items="${usersByRole}" varStatus="loop">
                    "<c:out value="${r.roleName}"/>"${!loop.last ? ',' : ''}
                </c:forEach>
            ];
            const usersRoleData = [
                <c:forEach var="r" items="${usersByRole}" varStatus="loop">
                    <c:out value="${r.total}" />${!loop.last ? ',' : ''}
                </c:forEach>
            ];

            new Chart(usersRoleCtx, {
                type: 'pie',
                data: {
                    labels: usersRoleLabels,
                    datasets: [{
                        data: usersRoleData,
                        backgroundColor: [
                            '#4a7c59', // primary green
                            '#7a6148', // secondary brown
                            '#b1812f', // tertiary gold
                            '#0369a1', // info blue
                            '#b83230', // danger red
                            '#646b66'  // muted grey
                        ],
                        borderWidth: 2,
                        borderColor: '#fffaf3' // matches var(--surface)
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                boxWidth: 12,
                                font: {
                                    size: 11,
                                    family: "'Nunito Sans', Arial, sans-serif",
                                    weight: 'bold'
                                },
                                color: '#2e3230'
                            }
                        }
                    }
                }
            });

            // --- Chart 2: Contracts by Status (Bar Chart) ---
            const contractsStatusCtx = document.getElementById('contractsStatusChart').getContext('2d');
            const contractsStatusLabels = [
                <c:forEach var="c" items="${contractsByStatus}" varStatus="loop">
                    "<c:out value="${c.status}"/>"${!loop.last ? ',' : ''}
                </c:forEach>
            ];
            const contractsStatusData = [
                <c:forEach var="c" items="${contractsByStatus}" varStatus="loop">
                    <c:out value="${c.total}"/>${!loop.last ? ',' : ''}
                </c:forEach>
            ];

            new Chart(contractsStatusCtx, {
                type: 'bar',
                data: {
                    labels: contractsStatusLabels,
                    datasets: [{
                        label: 'Số lượng hợp đồng',
                        data: contractsStatusData,
                        backgroundColor: '#7a6148', // secondary brown
                        borderRadius: 8,
                        maxBarThickness: 35
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                precision: 0,
                                color: '#646b66',
                                font: {
                                    family: "'Nunito Sans', Arial, sans-serif"
                                }
                            },
                            grid: {
                                color: '#f0ece4'
                            }
                        },
                        x: {
                            ticks: {
                                color: '#646b66',
                                font: {
                                    family: "'Nunito Sans', Arial, sans-serif",
                                    weight: 'bold'
                                }
                            },
                            grid: {
                                display: false
                            }
                        }
                    }
                }
            });

            // --- Chart 3: Orders by Status (Doughnut Chart) ---
            const ordersStatusCtx = document.getElementById('ordersStatusChart').getContext('2d');
            const ordersStatusLabels = [
                <c:forEach var="o" items="${ordersByStatus}" varStatus="loop">
                    "<c:out value="${o.status}"/>"${!loop.last ? ',' : ''}
                </c:forEach>
            ];
            const ordersStatusData = [
                <c:forEach var="o" items="${ordersByStatus}" varStatus="loop">
                    <c:out value="${o.total}"/>${!loop.last ? ',' : ''}
                </c:forEach>
            ];

            new Chart(ordersStatusCtx, {
                type: 'doughnut',
                data: {
                    labels: ordersStatusLabels,
                    datasets: [{
                        data: ordersStatusData,
                        backgroundColor: [
                            '#4a7c59', // primary green
                            '#b1812f', // tertiary gold
                            '#b83230', // danger red
                            '#0369a1', // info blue
                            '#7a6148'  // secondary brown
                        ],
                        borderWidth: 2,
                        borderColor: '#fffaf3'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                boxWidth: 12,
                                font: {
                                    size: 11,
                                    family: "'Nunito Sans', Arial, sans-serif",
                                    weight: 'bold'
                                },
                                color: '#2e3230'
                            }
                        }
                    },
                    cutout: '65%'
                }
            });
        </script>
    </body>
</html>
