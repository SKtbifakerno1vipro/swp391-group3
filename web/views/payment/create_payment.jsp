<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Create Payment - Po Bread Sales</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
        <style>
            .payment-card {
                background: #ffffff;
                border: 1px solid #e2e8f0;
                border-radius: 12px;
                box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.05), 0 4px 6px -2px rgba(0, 0, 0, 0.02);
                padding: 30px;
                max-width: 500px;
                margin: 40px auto;
            }
            .payment-card h3 {
                margin-top: 0;
                color: #1a202c;
                font-size: 1.5rem;
                font-family: 'Literata', serif;
                border-bottom: 2px solid #edf2f7;
                padding-bottom: 15px;
                margin-bottom: 20px;
            }
            .info-group {
                margin-bottom: 15px;
                display: flex;
                justify-content: space-between;
                font-size: 1rem;
                color: #4a5568;
            }
            .info-label {
                font-weight: 600;
            }
            .info-value {
                color: #2d3748;
                font-weight: 700;
            }
            .vnpay-logo {
                display: block;
                max-width: 150px;
                height: auto;
                margin: 20px auto;
            }
            .btn-pay {
                display: block;
                width: 100%;
                background: #10b981;
                color: #ffffff;
                text-align: center;
                padding: 12px;
                border: none;
                border-radius: 8px;
                font-size: 1.1rem;
                font-weight: 700;
                cursor: pointer;
                transition: background 0.2s ease-in-out;
                margin-top: 25px;
                box-shadow: 0 4px 6px -1px rgba(16, 185, 129, 0.2);
            }
            .btn-pay:hover {
                background: #059669;
            }
        </style>
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="createPayment"/>
            </jsp:include>
            <main class="main legacy-page">
                <h2>VNPAY Checkout Terminal</h2>
                
                <div class="payment-card">
                    <c:if test="${not empty param.error}">
                        <div class="alert alert-danger" style="background-color: #fee2e2; color: #b91c1c; padding: 12px; border-radius: 8px; margin-bottom: 20px; font-weight: 600; text-align: center; border: 1px solid #fca5a5; font-size: 0.95rem;">
                            ${param.error}
                        </div>
                    </c:if>
                    <form action="payment" method="POST">
                        <h3>Thanh toán Hợp đồng</h3>
                        
                        <div class="info-group">
                            <span class="info-label">Mã hóa đơn/Hợp đồng:</span>
                            <span class="info-value">HD88923</span>
                        </div>
                        
                        <div class="info-group">
                            <span class="info-label">Số tiền cần trả:</span>
                            <span class="info-value" style="color: #10b981; font-size: 1.2rem;">50,000 VNĐ</span>
                        </div>

                        <input type="hidden" name="orderId" value="HD88923">
                        <input type="hidden" name="amount" value="50000">

                        <img class="vnpay-logo" src="${pageContext.request.contextPath}/assets/img/logo-vnpay.png" alt="VNPAY logo">

                        <button type="submit" class="btn-pay">Thanh toán qua VNPAY</button>
                    </form>
                </div>
            </main>
        </div>
    </body>
</html>
