<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Giao dịch đang xử lý - Po Bread Sales</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&family=Nunito+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
        <style>
            body {
                display: flex;
                align-items: center;
                justify-content: center;
                min-height: 100vh;
                background: linear-gradient(135deg, #faf6f0 0%, #eef5ed 100%);
                padding: 20px;
                margin: 0;
            }

            .processing-card {
                background: #ffffff;
                border: 1px solid var(--line, #ddd5c9);
                border-radius: 20px;
                padding: 40px 30px;
                max-width: 480px;
                width: 100%;
                text-align: center;
                box-shadow: 0 20px 45px rgba(46, 50, 48, 0.1);
                animation: fadeIn 0.4s ease-out;
            }

            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(15px); }
                to { opacity: 1; transform: translateY(0); }
            }

            .icon-wrapper {
                position: relative;
                width: 90px;
                height: 90px;
                margin: 0 auto 24px auto;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .spinner-ring {
                position: absolute;
                inset: 0;
                border: 4px solid #dcefe1;
                border-top-color: var(--primary, #4a7c59);
                border-radius: 50%;
                animation: spin 1.2s cubic-bezier(0.5, 0, 0.5, 1) infinite;
            }

            @keyframes spin {
                0% { transform: rotate(0deg); }
                100% { transform: rotate(360deg); }
            }

            .icon-wrapper .material-symbols-outlined {
                font-size: 42px;
                color: var(--primary, #4a7c59);
                z-index: 1;
            }

            .processing-title {
                font-family: 'Literata', serif;
                font-size: 1.6rem;
                font-weight: 700;
                color: var(--text, #2e3230);
                margin: 0 0 12px 0;
            }

            .processing-message {
                font-size: 1.05rem;
                color: var(--muted, #646b66);
                line-height: 1.6;
                margin: 0 0 24px 0;
            }

            .badge-tx {
                display: inline-block;
                background: #f0ece4;
                color: #555;
                font-weight: 700;
                font-size: 0.88rem;
                padding: 6px 14px;
                border-radius: 20px;
                margin-bottom: 24px;
            }

            .actions-group {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            .btn-primary-custom {
                background: var(--primary, #4a7c59);
                color: #ffffff;
                font-weight: 700;
                padding: 12px 24px;
                border-radius: 10px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                transition: background 0.2s ease, transform 0.1s ease;
                border: none;
                cursor: pointer;
            }

            .btn-primary-custom:hover {
                background: #3b6447;
                transform: translateY(-1px);
            }

            .btn-secondary-custom {
                background: transparent;
                color: var(--muted, #646b66);
                font-weight: 600;
                padding: 10px 20px;
                border-radius: 10px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                border: 1px solid var(--line, #ddd5c9);
                transition: background 0.2s ease;
            }

            .btn-secondary-custom:hover {
                background: var(--surface-soft, #f0ece4);
            }
        </style>
    </head>
    <body>
        <div class="processing-card">
            <div class="icon-wrapper">
                <div class="spinner-ring"></div>
                <span class="material-symbols-outlined">hourglass_top</span>
            </div>

            <h1 class="processing-title">Giao dịch đang xử lý</h1>

            <p class="processing-message">
                Giao dịch đang xử lý, vui lòng chờ vài phút.<br>
                Hệ thống đang đồng bộ kết quả thanh toán từ VNPay.
            </p>

            <c:if test="${paymentId > 0}">
                <div class="badge-tx">Mã giao dịch: #${paymentId}</div>
            </c:if>

            <div class="actions-group">
                <c:choose>
                    <c:when test="${paymentId > 0}">
                        <a href="${pageContext.request.contextPath}/payment/detail?id=${paymentId}" class="btn-primary-custom">
                            <span class="material-symbols-outlined">receipt_long</span>
                            Xem chi tiết thanh toán
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/payment/list" class="btn-primary-custom">
                            <span class="material-symbols-outlined">payments</span>
                            Xem danh sách thanh toán
                        </a>
                    </c:otherwise>
                </c:choose>
                <a href="${pageContext.request.contextPath}/dashboard" class="btn-secondary-custom">
                    <span class="material-symbols-outlined">home</span>
                    Về trang chủ
                </a>
            </div>
        </div>
    </body>
</html>
