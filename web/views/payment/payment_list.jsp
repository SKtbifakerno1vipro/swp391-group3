<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Payment Records - Po Bread Sales</title>
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
        </style>
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="payments"/>
            </jsp:include>
            <main class="main legacy-page">
                <h2>Payment Log Management</h2>

                <table>
                    <thead>
                        <tr>
                            <th>Transaction ID</th>
                            <th>Contract Number</th>
                            <th>Customer Name</th>
                            <th>Amount</th>
                            <th>Payment Type</th>
                            <th>Status</th>
                            <th>Processed Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty list}">
                            <tr><td colspan="8" style="text-align:center;">No payment transactions recorded.</td></tr>
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
                                <td>${p.formattedPaidAt}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/payment/detail?id=${p.paymentId}" style="color: #0284c7; text-decoration: none; font-weight: bold;">View Details</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </main>
        </div>
    </body>
</html>
