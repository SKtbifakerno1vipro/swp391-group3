<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Password - Terra Enterprise</title>
    <style>
        .form-container {
            max-width: 450px;
            margin: 40px auto;
        }
        .form-container h2 {
            font-family: 'Literata', Georgia, serif;
            font-size: 26px;
            color: var(--text);
            margin-top: 0;
            margin-bottom: 20px;
            text-align: center;
        }
        .form-group {
            margin-bottom: 18px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 800;
            font-size: 13px;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .form-group input {
            width: 100%;
            padding: 10px 14px;
            box-sizing: border-box;
            border: 1px solid var(--line);
            border-radius: 12px;
            color: var(--text);
            background-color: #fff;
            font-size: 14px;
            outline: none;
            transition: border-color 0.2s ease;
        }
        .form-group input:focus {
            border-color: var(--primary);
        }
        .btn-submit {
            background-color: var(--primary);
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 999px;
            cursor: pointer;
            width: 100%;
            font-weight: 800;
            font-size: 16px;
            box-shadow: var(--shadow);
            transition: all 0.2s ease;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            filter: brightness(1.1);
        }
        .alert {
            padding: 12px 16px;
            margin-bottom: 20px;
            border-radius: 12px;
            font-size: 14px;
        }
        .alert-success {
            background-color: var(--primary-soft);
            color: var(--primary);
            border: 1px solid rgba(74, 124, 89, 0.2);
        }
        .alert-danger {
            background-color: var(--danger-soft);
            color: var(--danger);
            border: 1px solid rgba(184, 50, 48, 0.2);
        }
    </style>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
</head>

<body style="min-height: 100vh; background-color: var(--bg); display: flex; align-items: center; justify-content: center; padding: 20px; font-family: 'Nunito Sans', sans-serif; margin: 0;">
    <div class="form-container" style="background: var(--surface); border: 1px solid rgba(221, 213, 201, 0.85); border-radius: 22px; box-shadow: var(--shadow); padding: 30px; width: 100%; max-width: 450px; margin: 0;">
        <h2>Update Password</h2>

        <%-- Result messages --%>
        <c:if test="${not empty success}">
            <div class="alert alert-success">
                ${success}
                <c:if test="${isForgetFlowSuccess}">
                    <br><a href="${pageContext.request.contextPath}/login" style="color: #155724; font-weight: bold; text-decoration: underline;">Log in now</a>
                </c:if>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <strong>Error:</strong> ${error}
                <c:if test="${not empty errorDetail}">
                    <br><small>${errorDetail}</small>
                </c:if>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/user/password/change" method="POST">
            <input type="hidden" name="isForgot" value="false">

            <c:if test="${empty sessionScope.forgetPass}">
                <div class="form-group">
                    <label for="currentPassword">Current Password:</label>
                    <input type="password" id="currentPassword" name="currentPassword" required>
                </div>
            </c:if>
            
            <div class="form-group">
                <label for="newPassword">New Password:</label>
                <input type="password" id="newPassword" name="newPassword" required>
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirm New Password:</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required>
            </div>

            <button type="submit" name="action" value="changePassword" class="btn-submit">Update Password</button>
        </form>
    </div>
</body>
</html>
