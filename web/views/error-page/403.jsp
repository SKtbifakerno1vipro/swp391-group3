<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>403 - Forbidden</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&family=Nunito+Sans:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&display=block" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
    <style>
        .error-container {
            text-align: center;
            margin-top: 10vh;
        }
        .error-container h1 {
            font-size: 100px;
            color: var(--danger);
            margin: 0;
            font-family: 'Literata', Georgia, serif;
            line-height: 1;
        }
        .error-container h2 {
            font-size: 32px;
            margin: 10px 0 20px;
            color: var(--text);
            font-family: 'Literata', Georgia, serif;
        }
        .error-container p {
            color: var(--muted);
            margin-bottom: 30px;
            font-size: 18px;
        }
        .error-icon {
            font-size: 80px;
            color: var(--danger);
            margin-bottom: 10px;
        }
        .button-center {
            display: inline-flex;
            justify-content: center;
        }
    </style>
</head>
<body>
    <div class="dashboard-shell">
        <c:if test="${not empty sessionScope.user}">
            <jsp:include page="/views/shared/sidebar.jsp" />
        </c:if>
        <main class="main legacy-page">
            <div class="error-container">
                <span class="material-symbols-outlined error-icon">block</span>
                <h1>403</h1>
                <h2>Từ chối truy cập</h2>
                <p>Bạn không có quyền xem nội dung này. Vui lòng liên hệ quản trị viên nếu bạn nghĩ đây là một sai sót.</p>
                <div class="button-center">
                    <a class="button" href="${pageContext.request.contextPath}/dashboard">
                        <span class="material-symbols-outlined">home</span>
                        Về trang chủ
                    </a>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
