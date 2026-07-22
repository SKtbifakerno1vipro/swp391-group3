<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi tiết thanh toán - Po Bread Sales</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
        <style>
            .receipt-container {
                max-width: 600px;
                margin: 40px auto;
                background: #ffffff;
                border: 1px solid #e2e8f0;
                border-radius: 16px;
                box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.05), 0 10px 10px -5px rgba(0, 0, 0, 0.01);
                overflow: hidden;
            }
            .receipt-header {
                background: #f8fafc;
                border-bottom: 2px dashed #e2e8f0;
                padding: 30px;
                text-align: center;
                position: relative;
            }
            /* Simulated ticket jagged edge dots */
            .receipt-header::before, .receipt-header::after {
                content: '';
                position: absolute;
                bottom: -6px;
                width: 12px;
                height: 12px;
                background: #f1f5f9; /* Dashboard shell background color match */
                border-radius: 50%;
            }
            .receipt-header::before {
                left: -6px;
            }
            .receipt-header::after {
                right: -6px;
            }

            .receipt-title {
                font-family: 'Literata', serif;
                font-size: 1.6rem;
                font-weight: 700;
                color: #0f172a;
                margin: 10px 0 5px 0;
            }
            .receipt-subtitle {
                font-size: 0.9rem;
                color: #64748b;
                margin: 0;
            }
            .receipt-body {
                padding: 30px;
            }
            .receipt-row {
                display: flex;
                justify-content: space-between;
                padding: 12px 0;
                border-bottom: 1px solid #f1f5f9;
                font-size: 1rem;
                color: #475569;
            }
            .receipt-row:last-child {
                border-bottom: none;
            }
            .label {
                font-weight: 600;
            }
            .value {
                font-weight: 700;
                color: #0f172a;
                text-align: right;
            }
            .badge {
                display: inline-block;
                padding: 4px 12px;
                border-radius: 9999px;
                font-size: 0.85rem;
                font-weight: 700;
                text-transform: uppercase;
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
            .receipt-footer {
                padding: 0 30px 30px 30px;
                text-align: center;
            }
            .btn-back {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                background: #0284c7;
                color: #ffffff;
                text-decoration: none;
                padding: 12px 24px;
                border-radius: 8px;
                font-weight: 700;
                box-shadow: 0 4px 6px -1px rgba(2, 132, 199, 0.2);
                transition: background 0.2s;
            }
            .btn-back:hover {
                background: #0369a1;
            }
        </style>
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="payments"/>
            </jsp:include>
            <main class="main legacy-page">
                <h2>Xác nhận giao dịch</h2>

                <c:if test="${not empty sessionScope.successInvoice}">
                    <div style="color: #065f46; background-color: #d1fae5; border: 1px solid #10b981; padding: 12px; border-radius: 12px; margin-bottom: 20px; font-size: 14px; font-weight: bold; display: flex; align-items: center; gap: 8px; max-width: 600px; margin: 0 auto 20px auto;">
                        <span class="material-symbols-outlined" style="font-size: 20px;">check_circle</span>
                        ${sessionScope.successInvoice}
                        <% session.removeAttribute("successInvoice"); %>
                    </div>
                </c:if>
                <c:if test="${not empty sessionScope.successMessage}">
                    <div style="color: #065f46; background-color: #d1fae5; border: 1px solid #10b981; padding: 12px; border-radius: 12px; margin-bottom: 20px; font-size: 14px; font-weight: bold; display: flex; align-items: center; gap: 8px; max-width: 600px; margin: 0 auto 20px auto;">
                        <span class="material-symbols-outlined" style="font-size: 20px;">check_circle</span>
                        ${sessionScope.successMessage}
                        <% session.removeAttribute("successMessage"); %>
                    </div>
                </c:if>

                <c:if test="${not empty sessionScope.errorPaymentInvoice}">
                    <div style="color: #991b1b; background-color: #fee2e2; border: 1px solid #ef4444; padding: 12px; border-radius: 12px; margin-bottom: 20px; font-size: 14px; font-weight: bold; display: flex; align-items: center; gap: 8px; max-width: 600px; margin: 0 auto 20px auto;">
                        <span class="material-symbols-outlined" style="font-size: 20px;">error</span>
                        ${sessionScope.errorPaymentInvoice}
                        <% session.removeAttribute("errorPaymentInvoice"); %>
                    </div>
                </c:if>
                <div class="receipt-container">
                    <div class="receipt-header">
                        <span class="material-symbols-outlined" style="font-size: 3rem; color: #10b981;">check_circle</span>
                        <h3 class="receipt-title">Biên lai giao dịch</h3>
                        <p class="receipt-subtitle">Mã tham chiếu: PAY-${payment.paymentId}</p>
                    </div>

                    <div class="receipt-body">
                        <div class="receipt-row">
                            <span class="label">Mã thanh toán</span>
                            <span class="value">#${payment.paymentId}</span>
                        </div>

                        <div class="receipt-row">
                            <span class="label">Mã đơn hàng</span>
                            <span class="value">${payment.customerOrderId}</span>
                        </div>

                        <div class="receipt-row">
                            <span class="label">Mã hợp đồng</span>
                            <span class="value">
                                <c:choose>
                                    <c:when test="${not empty payment.contractNumber}">
                                        <a href="${pageContext.request.contextPath}/contract-detail?id=${payment.customerContractId}" style="color: #0284c7; text-decoration: none;">
                                            ${payment.contractNumber}
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        N/A
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div class="receipt-row">
                            <span class="label">Số tiền</span>
                            <span class="value" style="color: #10b981; font-size: 1.15rem;">
                                <fmt:formatNumber value="${payment.amount}" type="number"/> VNĐ
                            </span>
                        </div>

                        <div class="receipt-row">
                            <span class="label">Phương thức thanh toán</span>
                            <span class="value">${payment.paymentType}</span>
                        </div>

                        <div class="receipt-row">
                            <span class="label">Trạng thái</span>
                            <span class="value">
                                <c:choose>
                                    <c:when test="${payment.paymentStatus == 'PENDING'}">
                                        <span class="badge badge-warning">CHỜ THANH TOÁN</span>
                                    </c:when>
                                    <c:when test="${payment.paymentStatus == 'COMPLETED'}">
                                        <span class="badge badge-success">ĐÃ THANH TOÁN</span>
                                    </c:when>
                                    <c:when test="${payment.paymentStatus == 'FAILED'}">
                                        <span class="badge badge-danger">THẤT BẠI</span>
                                    </c:when>
                                    <c:when test="${payment.paymentStatus == 'CANCELLED'}">
                                        <span class="badge badge-danger">ĐÃ HỦY</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-warning">${payment.paymentStatus}</span>
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div class="receipt-row">
                            <span class="label">Ngày tạo</span>
                            <span class="value">${payment.formattedCreatedAt}</span>
                        </div>

                        <div class="receipt-row">
                            <span class="label">Ngày thanh toán</span>
                            <span class="value">${payment.formattedPaidAt}</span>
                        </div>

                        <%-- Thông tin khách hàng --%>
                        <div style="margin: 16px 0 8px 0; font-size: 0.8rem; font-weight: 800; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.08em;">
                            Thông tin khách hàng
                        </div>

                        <div class="receipt-row">
                            <span class="label">Họ tên</span>
                            <span class="value">
                                <c:choose>
                                    <c:when test="${not empty payment.customerNameSnapshot}">${payment.customerNameSnapshot}</c:when>
                                    <c:otherwise>—</c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div class="receipt-row">
                            <span class="label">Công ty</span>
                            <span class="value">
                                <c:choose>
                                    <c:when test="${not empty payment.companyNameSnapshot}">${payment.companyNameSnapshot}</c:when>
                                    <c:otherwise>—</c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div class="receipt-row">
                            <span class="label">Email</span>
                            <span class="value">
                                <c:choose>
                                    <c:when test="${not empty payment.customerEmailSnapshot}">${payment.customerEmailSnapshot}</c:when>
                                    <c:otherwise>—</c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div class="receipt-row">
                            <span class="label">Số điện thoại</span>
                            <span class="value">
                                <c:choose>
                                    <c:when test="${not empty payment.customerPhoneSnapshot}">${payment.customerPhoneSnapshot}</c:when>
                                    <c:otherwise>—</c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div class="receipt-row">
                            <span class="label">Địa chỉ</span>
                            <span class="value">
                                <c:choose>
                                    <c:when test="${not empty payment.customerAddressSnapshot}">${payment.customerAddressSnapshot}</c:when>
                                    <c:otherwise>—</c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div class="receipt-row">
                            <span class="label">Mã số thuế</span>
                            <span class="value">
                                <c:choose>
                                    <c:when test="${not empty payment.customerTaxCodeSnapshot}">${payment.customerTaxCodeSnapshot}</c:when>
                                    <c:otherwise>—</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>

                    <div class="receipt-footer">
                        <c:if test="${(payment.paymentStatus == 'PENDING' || payment.paymentStatus == 'FAILED' || payment.paymentStatus == 'CANCELLED') && sessionScope.user.roleId == 3}">
                            <form action="${pageContext.request.contextPath}/payment" method="POST" style="margin-top: 15px;">
                                <input type="hidden" name="paymentId" value="${payment.paymentId}">
                                <input type="hidden" name="amount" value="${payment.amount.longValue()}">
                                <button type="submit" class="btn-pay" style="display: inline-flex; align-items: center; justify-content: center; gap: 8px; background: #10b981; color: #ffffff; border: none; padding: 12px 24px; border-radius: 8px; font-weight: 700; cursor: pointer; transition: background 0.2s; box-shadow: 0 4px 6px -1px rgba(16, 185, 129, 0.2); width: 100%; box-sizing: border-box;">
                                    <span class="material-symbols-outlined">payment</span>
                                    <c:choose>
                                        <c:when test="${payment.paymentStatus == 'PENDING'}">
                                            Thanh toán qua VNPay
                                        </c:when>
                                        <c:otherwise>
                                            Thanh toán lại qua VNPay
                                        </c:otherwise>
                                    </c:choose>
                                </button>
                            </form>
                        </c:if>
                        <c:if test="${not empty invoice}"> 
                            <c:choose>
                                <c:when test="${payment.paymentStatus == 'COMPLETED' && canIssue == true}">
                                    <div style="margin-top: 15px;">
                                        <a href="javascript:void(0);" onclick="if (confirm('Bạn có chắc chắn muốn phát hành hóa đơn cho thanh toán này?')) {
                                                    document.getElementById('issueForm-detail').submit();
                                                }" style="color: #059669; text-decoration: none; font-weight: bold; font-size: 1rem; display: inline-block;" onmouseover="this.style.textDecoration = 'underline';" onmouseout="this.style.textDecoration = 'none';">Xuất hóa đơn</a>
                                        <form id="issueForm-detail" action="${pageContext.request.contextPath}/invoice" method="POST" style="display: none;">
                                            <input type="hidden" name="customerContractId" value="${payment.customerContractId}"/>
                                            <input type="hidden" name="action" value="notice"/>
                                        </form>
                                    </div>
                                </c:when>
                                <c:when test="${payment.paymentStatus == 'COMPLETED' && invoice.invoiceStatus == 'RELEASED'}">
                                    <div style="margin-top: 15px;">
                                        <a href="${pageContext.request.contextPath}/invoice?invoiceId=${invoice.invoiceId}" style="text-decoration: none; padding: 4px 10px; background-color: var(--primary-soft); color: var(--primary); border-radius: 6px; font-size: 11px; font-weight: 800; display: inline-flex; align-items: center; justify-content: center; min-width: 45px;">Xem hóa đơn</a>
                                    </div>
                                </c:when>
                            </c:choose>
                        </c:if>
                    </div>
                </div>
            </main>
        </div>
    </body>
</html>