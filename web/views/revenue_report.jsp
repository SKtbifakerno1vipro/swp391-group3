<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Revenue Analytics Report</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
    <style>
        .main { min-width:0; padding:26px 34px 38px; flex-grow: 1; }
        .topbar { display:flex; justify-content:space-between; gap:18px; align-items:center; margin-bottom:30px; }
        .eyebrow { margin:0 0 6px; color:var(--primary); font-weight:800; letter-spacing:.08em; text-transform:uppercase; font-size:12px; }
        .dashboard-shell { display:flex; min-height:100vh; }
        h1 { margin:0; font-family:'Literata',Georgia,serif; font-size:clamp(30px,4vw,44px); line-height:1.1; }
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
                    <h1>Revenue Analytics Report</h1>
                    <p>Track your business performance and revenue trends.</p>
                </div>
            </section>
            
            <section class="filter-section panel">
                <form action="${pageContext.request.contextPath}/revenue-report" method="get" style="display: flex; align-items: center; gap: 15px; flex-wrap: wrap;">
                    <div style="display: flex; flex-direction: column;">
                        <label class="eyebrow" style="margin-bottom: 5px;">Report Type</label>
                        <select name="type" onchange="this.form.submit()" style="padding: 8px; border-radius: 8px; border: 1px solid #ddd;">
                            <option value="day" ${type == 'day' ? 'selected' : ''}>By Day</option>
                            <option value="month" ${type == 'month' ? 'selected' : ''}>By Month</option>
                            <option value="year" ${type == 'year' ? 'selected' : ''}>By Year</option>
                        </select>
                    </div>
                    
                    <div style="display: flex; flex-direction: column;">
                        <label class="eyebrow" style="margin-bottom: 5px;">From</label>
                        <input type="date" name="startDate" value="${startDate}" style="padding: 7px; border-radius: 8px; border: 1px solid #ddd;">
                    </div>
                    
                    <div style="display: flex; flex-direction: column;">
                        <label class="eyebrow" style="margin-bottom: 5px;">To</label>
                        <input type="date" name="endDate" value="${endDate}" style="padding: 7px; border-radius: 8px; border: 1px solid #ddd;">
                    </div>
                    
                    <button type="submit" class="btn btn-primary" style="margin-top: 18px; padding: 10px 20px; border-radius: 20px; font-weight: bold; background: #4a7c59; border: none; color: white; cursor: pointer;">
                        <span class="material-symbols-outlined" style="vertical-align: middle; font-size: 18px; margin-right: 5px;">filter_list</span>Filter
                    </button>
                </form>
            </section>

            <c:if test="${not empty revenueData}">
                <section class="panel" style="padding: 25px; background: white; border-radius: 26px; box-shadow: 0 18px 45px rgba(46,50,48,.08); margin-bottom: 25px;">
                    <div style="height: 400px; width: 100%;">
                        <canvas id="revenueChart"></canvas>
                    </div>
                </section>
            </c:if>
            
            <section class="panel" style="padding: 20px; background: white; border-radius: 26px; box-shadow: 0 18px 45px rgba(46,50,48,.08);">
                <table class="report-table">
                    <thead>
                        <tr>
                            <th>Time Period (${type})</th>
                            <th style="text-align: right;">Revenue</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:set var="totalRevenue" value="0" />
                        <c:forEach items="${revenueData}" var="entry">
                            <tr>
                                <td style="font-weight: 700;">${entry.key}</td>
                                <td style="text-align: right; font-weight: 700; color: #4a7c59;">
                                    <fmt:formatNumber value="${entry.value}" type="currency" currencySymbol="VND" maxFractionDigits="0"/>
                                </td>
                            </tr>
                            <c:set var="totalRevenue" value="${totalRevenue + entry.value}" />
                        </c:forEach>
                    </tbody>
                    <tfoot>
                        <tr class="total-row">
                            <td style="font-size: 18px;">Total Revenue</td>
                            <td style="text-align: right; font-size: 20px; color: #b1812f;">
                                <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="VND" maxFractionDigits="0"/>
                            </td>
                        </tr>
                    </tfoot>
                </table>
                
                <c:if test="${empty revenueData}">
                    <div style="text-align: center; padding: 40px; color: #646b66;">
                        <span class="material-symbols-outlined" style="font-size: 48px; display: block; margin-bottom: 10px;">search_off</span>
                        <p>No revenue data found for the selected criteria.</p>
                    </div>
                </c:if>
            </section>
        </main>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const ctx = document.getElementById('revenueChart');
            if (!ctx) return;

            const labels = [];
            const dataValues = [];

            <c:forEach items="${revenueData}" var="entry">
                labels.push('${entry.key}');
                dataValues.push(${entry.value});
            </c:forEach>

            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Revenue (VND)',
                        data: dataValues,
                        backgroundColor: 'rgba(74, 124, 89, 0.6)',
                        borderColor: 'rgba(74, 124, 89, 1)',
                        borderWidth: 1,
                        borderRadius: 8,
                        hoverBackgroundColor: 'rgba(74, 124, 89, 0.8)'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return value.toLocaleString('vi-VN') + ' ₫';
                                }
                            }
                        }
                    },
                    plugins: {
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    let label = context.dataset.label || '';
                                    if (label) {
                                        label += ': ';
                                    }
                                    if (context.parsed.y !== null) {
                                        label += context.parsed.y.toLocaleString('vi-VN') + ' ₫';
                                    }
                                    return label;
                                }
                            }
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>
