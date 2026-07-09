<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>System Statistics Report</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
    <style>
        .main { min-width:0; padding:26px 34px 38px; flex-grow: 1; }
        .topbar { display:flex; justify-content:space-between; gap:18px; align-items:center; margin-bottom:30px; }
        .eyebrow { margin:0 0 6px; color:var(--primary); font-weight:800; letter-spacing:.08em; text-transform:uppercase; font-size:12px; }
        .dashboard-shell { display:flex; min-height:100vh; }
        h1 { margin:0; font-family:'Literata',Georgia,serif; font-size:clamp(30px,4vw,44px); line-height:1.1; }
        
        .charts-container { display: grid; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); gap: 25px; margin-bottom: 30px; }
        .charts-row-3 { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 25px; }
        .chart-panel { background: white; padding: 25px; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
        .chart-panel h3 { margin: 0 0 20px 0; color: #333; font-size: 18px; text-align: center; }
        .canvas-container { position: relative; height: 300px; width: 100%; }
        .canvas-container.main-chart { height: 400px; }
    </style>
    <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&family=Nunito+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&display=block" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div class="dashboard-shell">
        <jsp:include page="shared/sidebar.jsp">
            <jsp:param name="activeMenu" value="revenue"/>
        </jsp:include>
        
        <main class="main">
            <section class="topbar">
                <div>
                    <p class="eyebrow">Analytics & Reporting</p>
                    <h1>System Statistics Report</h1>
                    <p>Visual overview of Products, Orders, Quotations, and Contracts.</p>
                </div>
            </section>
            
            <section class="charts-container">
                <div class="chart-panel">
                    <h3>Overall Total Summary</h3>
                    <div class="canvas-container main-chart">
                        <canvas id="overviewChart"></canvas>
                    </div>
                </div>
                
                <div class="chart-panel">
                    <h3>Top 5 Customers by Orders</h3>
                    <div class="canvas-container main-chart">
                        <canvas id="topCustomersChart"></canvas>
                    </div>
                </div>

                <div class="chart-panel">
                    <h3>Top 5 Selling Products (${topSellingProducts.size()})</h3>
                    <div class="canvas-container main-chart">
                        <canvas id="topProductsChart"></canvas>
                    </div>
                </div>
            </section>

            <section class="charts-row-3">
                <div class="chart-panel">
                    <h3>Orders by Status</h3>
                    <div class="canvas-container">
                        <canvas id="orderStatusChart"></canvas>
                    </div>
                </div>

                <div class="chart-panel">
                    <h3>Quotations by Status</h3>
                    <div class="canvas-container">
                        <canvas id="quotationStatusChart"></canvas>
                    </div>
                </div>

                <div class="chart-panel">
                    <h3>Contracts by Status</h3>
                    <div class="canvas-container">
                        <canvas id="contractStatusChart"></canvas>
                    </div>
                </div>
            </section>
        </main>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Colors
            const barColors = ['rgba(54, 162, 235, 0.6)', 'rgba(75, 192, 192, 0.6)', 'rgba(255, 206, 86, 0.6)', 'rgba(153, 102, 255, 0.6)'];
            const barBorders = ['rgba(54, 162, 235, 1)', 'rgba(75, 192, 192, 1)', 'rgba(255, 206, 86, 1)', 'rgba(153, 102, 255, 1)'];
            
            const pieColors = [
                'rgba(255, 99, 132, 0.6)',
                'rgba(54, 162, 235, 0.6)',
                'rgba(255, 206, 86, 0.6)',
                'rgba(75, 192, 192, 0.6)',
                'rgba(153, 102, 255, 0.6)',
                'rgba(255, 159, 64, 0.6)'
            ];

            // 1. Overview Bar Chart
            const ctxOverview = document.getElementById('overviewChart');
            new Chart(ctxOverview, {
                type: 'bar',
                data: {
                    labels: ['Products', 'Orders', 'Quotations', 'Contracts'],
                    datasets: [{
                        label: 'Total Count',
                        data: [${totalProducts}, ${totalOrders}, ${totalQuotations}, ${totalContracts}],
                        backgroundColor: barColors,
                        borderColor: barBorders,
                        borderWidth: 1,
                        borderRadius: 8
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: { beginAtZero: true }
                    },
                    plugins: {
                        legend: { display: false }
                    }
                }
            });

            // Helper function to build Pie/Doughnut charts
            function createPieChart(ctxId, labels, data) {
                const ctx = document.getElementById(ctxId);
                if(data.length === 0) {
                    // if no data, show message instead of blank chart
                    ctx.parentElement.innerHTML = '<div style="height:100%; display:flex; align-items:center; justify-content:center; color:#999;">No data available</div>';
                    return;
                }
                new Chart(ctx, {
                    type: 'doughnut',
                    data: {
                        labels: labels,
                        datasets: [{
                            data: data,
                            backgroundColor: pieColors,
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { position: 'bottom' }
                        }
                    }
                });
            }

            // 2. Order Status Chart
            const orderLabels = [];
            const orderData = [];
            <c:forEach items="${orderStatusCounts}" var="entry">
                orderLabels.push('${entry.status}');
                orderData.push(${entry.total});
            </c:forEach>
            createPieChart('orderStatusChart', orderLabels, orderData);

            // 3. Quotation Status Chart
            const quotLabels = [];
            const quotData = [];
            <c:forEach items="${quotationStatusCounts}" var="entry">
                quotLabels.push('${entry.status}');
                quotData.push(${entry.total});
            </c:forEach>
            createPieChart('quotationStatusChart', quotLabels, quotData);

            // 4. Contract Status Chart
            const contractLabels = [];
            const contractData = [];
            <c:forEach items="${contractStatusCounts}" var="entry">
                contractLabels.push('${entry.status}');
                contractData.push(${entry.total});
            </c:forEach>
            createPieChart('contractStatusChart', contractLabels, contractData);

            // 5. Top Customers Bar Chart
            const customerLabels = [];
            const customerData = [];
            <c:forEach items="${topCustomers}" var="item">
                customerLabels.push(`<c:out value="${item.companyName}" />`);
                customerData.push(${item.totalOrders});
            </c:forEach>
            
            const ctxTopCustomers = document.getElementById('topCustomersChart');
            if(customerData.length === 0) {
                ctxTopCustomers.parentElement.innerHTML = '<div style="height:100%; display:flex; align-items:center; justify-content:center; color:#999;">No data available</div>';
            } else {
                new Chart(ctxTopCustomers, {
                    type: 'bar',
                    data: {
                        labels: customerLabels,
                        datasets: [{
                            label: 'Total Orders',
                            data: customerData,
                            backgroundColor: 'rgba(255, 159, 64, 0.6)',
                            borderColor: 'rgba(255, 159, 64, 1)',
                            borderWidth: 1,
                            borderRadius: 8
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        indexAxis: 'y', // horizontal bar chart
                        scales: {
                            x: { beginAtZero: true }
                        },
                        plugins: {
                            legend: { display: false }
                        }
                    }
                });
            }

            // 6. Top Selling Products Bar Chart
            const productLabels = [];
            const productData = [];
            <c:forEach items="${topSellingProducts}" var="item">
                productLabels.push(`<c:out value="${item.productName}" />`);
                productData.push(${item.totalSold});
            </c:forEach>
            
            console.log("Top Products:", productLabels, productData);
            
            const ctxTopProducts = document.getElementById('topProductsChart');
            if(productData.length === 0) {
                ctxTopProducts.parentElement.innerHTML = '<div style="height:100%; display:flex; align-items:center; justify-content:center; color:#999;">No data available</div>';
            } else {
                new Chart(ctxTopProducts, {
                    type: 'bar',
                    data: {
                        labels: productLabels,
                        datasets: [{
                            label: 'Quantity Sold',
                            data: productData,
                            backgroundColor: 'rgba(75, 192, 192, 0.6)',
                            borderColor: 'rgba(75, 192, 192, 1)',
                            borderWidth: 1,
                            borderRadius: 8
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        indexAxis: 'y', // horizontal bar chart
                        scales: {
                            x: { beginAtZero: true }
                        },
                        plugins: {
                            legend: { display: false }
                        }
                    }
                });
            }
        });
    </script>
</body>
</html>
