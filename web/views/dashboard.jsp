<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard - Pơ Bread</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@400;600;700&family=Nunito+Sans:wght@300;400;600;700;800&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
        <script>
            tailwind.config = {
                theme: {
                    extend: {
                        colors: {
                            primary: "#4a7c59",
                            background: "#faf6f0",
                            surface: "#ffffff",
                            "on-surface": "#2e3230",
                            "on-surface-variant": "#4a4e4a",
                            outline: "#c4c8bc",
                            revenue: "#2a6038",
                            orders: "#3b82f6",
                            customers: "#f59e0b",
                            products: "#ef4444"
                        },
                        fontFamily: {
                            headline: ["Literata", "serif"],
                            body: ["Nunito Sans", "sans-serif"]
                        }
                    }
                }
            }
        </script>
        <style>
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            }
        </style>
    </head>
    <body class="bg-background font-body text-on-surface">
        <jsp:include page="shared/menu.jsp"/>

        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
            <header class="mb-8 flex justify-between items-center">
                <div>
                    <h1 class="text-3xl font-headline font-bold text-primary">Management Dashboard</h1>
                    <p class="text-on-surface-variant">Welcome back, ${user.fullName}!</p>
                </div>
                <div class="text-sm text-on-surface-variant">
                    <span class="material-symbols-outlined align-middle">calendar_month</span>
                    <fmt:formatDate value="<%= new java.util.Date() %>" pattern="MMMM dd, yyyy" />
                </div>
            </header>

            <c:choose>
                <c:when test="${user.roleId == 1 || user.roleId == 2}">
                    <!-- Stats Overview -->
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
                        <div class="bg-surface p-6 rounded-2xl shadow-sm border border-outline/30 flex items-center">
                            <div class="p-3 bg-revenue/10 rounded-xl mr-4 text-revenue">
                                <span class="material-symbols-outlined">payments</span>
                            </div>
                            <div>
                                <p class="text-sm font-semibold text-on-surface-variant">Total Revenue</p>
                                <p class="text-2xl font-bold"><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></p>
                            </div>
                        </div>

                        <div class="bg-surface p-6 rounded-2xl shadow-sm border border-outline/30 flex items-center">
                            <div class="p-3 bg-orders/10 rounded-xl mr-4 text-orders">
                                <span class="material-symbols-outlined">shopping_cart</span>
                            </div>
                            <div>
                                <p class="text-sm font-semibold text-on-surface-variant">Total Orders</p>
                                <p class="text-2xl font-bold">${totalOrders}</p>
                            </div>
                        </div>

                        <div class="bg-surface p-6 rounded-2xl shadow-sm border border-outline/30 flex items-center">
                            <div class="p-3 bg-customers/10 rounded-xl mr-4 text-customers">
                                <span class="material-symbols-outlined">groups</span>
                            </div>
                            <div>
                                <p class="text-sm font-semibold text-on-surface-variant">Total Customers</p>
                                <p class="text-2xl font-bold">${totalCustomers}</p>
                            </div>
                        </div>

                        <div class="bg-surface p-6 rounded-2xl shadow-sm border border-outline/30 flex items-center">
                            <div class="p-3 bg-products/10 rounded-xl mr-4 text-products">
                                <span class="material-symbols-outlined">inventory_2</span>
                            </div>
                            <div>
                                <p class="text-sm font-semibold text-on-surface-variant">Total Products</p>
                                <p class="text-2xl font-bold">${totalProducts}</p>
                            </div>
                        </div>
                    </div>

                    <!-- Charts Row -->
                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 mb-8">
                        <div class="lg:col-span-2 bg-surface p-6 rounded-2xl shadow-sm border border-outline/30">
                            <h3 class="text-lg font-bold mb-4 flex items-center">
                                <span class="material-symbols-outlined mr-2">trending_up</span> Revenue Trends
                            </h3>
                            <div class="h-64">
                                <canvas id="revenueChart"></canvas>
                            </div>
                        </div>

                        <div class="bg-surface p-6 rounded-2xl shadow-sm border border-outline/30">
                            <h3 class="text-lg font-bold mb-4 flex items-center">
                                <span class="material-symbols-outlined mr-2">pie_chart</span> Order Status
                            </h3>
                            <div class="h-64 flex justify-center">
                                <canvas id="statusChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <!-- Tables Row -->
                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                        <!-- Top Selling Products -->
                        <div class="bg-surface rounded-2xl shadow-sm border border-outline/30 overflow-hidden">
                            <div class="p-6 border-b border-outline/30 flex justify-between items-center">
                                <h3 class="text-lg font-bold flex items-center">
                                    <span class="material-symbols-outlined mr-2">workspace_premium</span> Top Selling Products
                                </h3>
                            </div>
                            <div class="overflow-x-auto">
                                <table class="w-full text-left">
                                    <thead class="bg-surface-container-low text-on-surface-variant text-sm font-semibold">
                                        <tr>
                                            <th class="px-6 py-4">Product Name</th>
                                            <th class="px-6 py-4 text-right">Total Sold</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-outline/20">
                                        <c:forEach var="item" items="${topSellingProducts}">
                                            <tr class="hover:bg-background transition-colors">
                                                <td class="px-6 py-4 font-medium">${item.product_name}</td>
                                                <td class="px-6 py-4 text-right">${item.total_sold}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Staff Performance -->
                        <div class="bg-surface rounded-2xl shadow-sm border border-outline/30 overflow-hidden">
                            <div class="p-6 border-b border-outline/30 flex justify-between items-center">
                                <h3 class="text-lg font-bold flex items-center">
                                    <span class="material-symbols-outlined mr-2">badge</span> Staff Performance
                                </h3>
                            </div>
                            <div class="overflow-x-auto">
                                <table class="w-full text-left">
                                    <thead class="bg-surface-container-low text-on-surface-variant text-sm font-semibold">
                                        <tr>
                                            <th class="px-6 py-4">Staff Name</th>
                                            <th class="px-6 py-4 text-center">Orders</th>
                                            <th class="px-6 py-4 text-right">Revenue</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-outline/20">
                                        <c:forEach var="item" items="${staffPerformance}">
                                            <tr class="hover:bg-background transition-colors">
                                                <td class="px-6 py-4 font-medium">${item.staff_name}</td>
                                                <td class="px-6 py-4 text-center">${item.total_orders}</td>
                                                <td class="px-6 py-4 text-right text-revenue font-semibold">
                                                    <fmt:formatNumber value="${item.total_revenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="bg-surface p-12 rounded-3xl shadow-xl border border-outline/30 text-center">
                        <div class="text-6xl mb-6">🥐</div>
                        <h2 class="text-2xl font-headline font-bold text-on-surface mb-2">Welcome, ${user.fullName}</h2>
                        <p class="text-on-surface-variant max-w-md mx-auto">
                            You are logged in as a <strong>${user.roleId == 3 ? 'Customer' : (user.roleId == 4 ? 'Sale Staff' : 'User')}</strong>. 
                            Use the menu above to navigate through the system.
                        </p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <script>
            // Revenue Chart
            const revenueCtx = document.getElementById('revenueChart').getContext('2d');
            const revenueData = {
                labels: [<c:forEach var="entry" items="${revenueByMonth}" varStatus="loop">'${entry.key}'${!loop.last ? ',' : ''}</c:forEach>].reverse(),
                datasets: [{
                    label: 'Revenue',
                    data: [<c:forEach var="entry" items="${revenueByMonth}" varStatus="loop">${entry.value}${!loop.last ? ',' : ''}</c:forEach>].reverse(),
                    borderColor: '#2a6038',
                    backgroundColor: 'rgba(42, 96, 56, 0.1)',
                    fill: true,
                    tension: 0.4
                }]
            };
            new Chart(revenueCtx, {
                type: 'line',
                data: revenueData,
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return value.toLocaleString('vi-VN') + ' ₫';
                                }
                            }
                        }
                    }
                }
            });

            // Status Pie Chart
            const statusCtx = document.getElementById('statusChart').getContext('2d');
            const statusData = {
                labels: [<c:forEach var="entry" items="${orderStatusStats}" varStatus="loop">'${entry.key}'${!loop.last ? ',' : ''}</c:forEach>],
                datasets: [{
                    data: [<c:forEach var="entry" items="${orderStatusStats}" varStatus="loop">${entry.value}${!loop.last ? ',' : ''}</c:forEach>],
                    backgroundColor: [
                        '#4a7c59', '#3b82f6', '#f59e0b', '#ef4444', '#8b5cf6', '#ec4899'
                    ]
                }]
            };
            new Chart(statusCtx, {
                type: 'doughnut',
                data: statusData,
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                usePointStyle: true,
                                padding: 20
                            }
                        }
                    }
                }
            });
        </script>
    </body>
</html>
