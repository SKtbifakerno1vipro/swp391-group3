<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${isForgot ? 'Forgot Password' : 'Change Password'} - Po Bread Sales</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
        <style>
            .page-top{display:flex;align-items:flex-end;justify-content:space-between;gap:20px;margin-bottom:26px}.eyebrow{margin:0 0 6px;color:var(--primary);font-weight:800;letter-spacing:.08em;text-transform:uppercase;font-size:12px}h1{margin:0;font-family:'Literata',Georgia,serif;font-size:clamp(32px,4vw,46px);line-height:1.08}.page-top p{margin:8px 0 0;color:var(--muted)}.panel{max-width:680px;background:var(--surface);border:1px solid rgba(221,213,201,.85);border-radius:28px;box-shadow:var(--shadow);overflow:hidden}.panel-head{padding:22px 24px;border-bottom:1px solid var(--line);background:linear-gradient(135deg,#fffaf3,#f0ece4);display:flex;justify-content:space-between;align-items:center;gap:16px}.panel-head h2{margin:0;font-family:'Literata',Georgia,serif}.panel-body{padding:24px}.field{margin-bottom:16px}.field label{display:block;margin-bottom:8px;color:var(--muted);font-weight:900;font-size:12px;text-transform:uppercase;letter-spacing:.04em}.field input{width:100%;padding:12px 13px;border:1px solid var(--line);border-radius:15px;background:#fff;color:var(--text);font:inherit;font-weight:700}.input-group{display:flex;gap:10px}.input-group input{flex:1}.actions{display:flex;gap:10px;flex-wrap:wrap}.button,.btn-send,.btn-submit{display:inline-flex;align-items:center;justify-content:center;gap:8px;padding:11px 16px;border:1px solid var(--line);border-radius:999px;background:var(--surface);color:var(--text);font-weight:800;text-decoration:none;cursor:pointer;font-family:inherit}.button.primary,.btn-submit,.btn-send{background:var(--primary);border-color:var(--primary);color:#fff}.button.danger{background:var(--danger-soft);border-color:var(--danger-soft);color:var(--danger)}.btn-submit{width:100%;margin-top:8px}.alert{padding:14px 16px;border-radius:16px;margin-bottom:18px;font-weight:800}.alert-success{background:var(--primary-soft);color:var(--primary)}.alert-danger{background:var(--danger-soft);color:var(--danger)}@media(max-width:760px){.page-top,.panel-head{align-items:flex-start;flex-direction:column}.input-group{flex-direction:column}}
        </style>
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp"><jsp:param name="activeMenu" value="users"/></jsp:include>
            <main class="main legacy-page">
                <section class="page-top">
                    <div><p class="eyebrow">Account Security</p><h1>${isForgot ? 'Forgot Password' : 'Change Password'}</h1><p>${isForgot ? 'Verify your email and phone to reset your password.' : 'Update your current password securely.'}</p></div>
                    <div class="actions"><a class="button" href="${pageContext.request.contextPath}/dashboard"><span class="material-symbols-outlined">arrow_back</span>Dashboard</a></div>
                </section>

                <form class="panel" action="${pageContext.request.contextPath}/user/password/${isForgot ? 'forgot' : 'change'}" method="POST">
                    <input type="hidden" name="isForgot" value="${isForgot}">
                    <div class="panel-head"><h2>${isForgot ? 'Reset password' : 'Password details'}</h2><span class="button"><span class="material-symbols-outlined">lock_reset</span>Security</span></div>
                    <div class="panel-body">
                        <c:if test="${not empty success}"><div class="alert alert-success"><c:out value="${success}"/></div></c:if>
                        <c:if test="${not empty error}"><div class="alert alert-danger"><c:out value="${error}"/><c:if test="${not empty errorDetail}"><br><small><c:out value="${errorDetail}"/></small></c:if></div></c:if>

                        <c:choose>
                            <c:when test="${isForgot}">
                                <div class="field"><label>Email</label><div class="input-group"><input type="email" id="email" name="email" value="${email}" required><button type="button" id="btnSendOtp" name="action" onclick="sendOtpAjax()" class="btn-send">Send OTP</button></div></div>
                                <div class="field"><label>Phone</label><input type="text" id="phone" name="phone" value="${phone}" required></div>
                                <div class="field"><label>OTP Code</label><input type="text" id="otpCode" name="otpCode" required placeholder="Enter the OTP from email"></div>
                            </c:when>
                            <c:otherwise>
                                <c:if test="${empty sessionScope.forgetPass}"><div class="field"><label>Current Password</label><input type="password" id="currentPassword" name="currentPassword" required></div></c:if>
                                <div class="field"><label>New Password</label><input type="password" id="newPassword" name="newPassword" required></div>
                                <div class="field"><label>Confirm New Password</label><input type="password" id="confirmPassword" name="confirmPassword" required></div>
                            </c:otherwise>
                        </c:choose>

                        <c:choose>
                            <c:when test="${isForgot}"><button type="submit" name="action" value="resetPassword" class="btn-submit">Submit reset request</button></c:when>
                            <c:otherwise><button type="submit" name="action" value="changePassword" class="btn-submit">Change password</button></c:otherwise>
                        </c:choose>
                    </div>
                </form>
            </main>
        </div>
        <script>
            function sendOtpAjax() {
                const email = document.getElementById("email").value;
                const phone = document.getElementById("phone").value;
                const btn = document.getElementById("btnSendOtp");

                if (!email || !phone) {
                    alert("Please enter both email and phone before requesting OTP.");
                    return;
                }

                btn.disabled = true;
                btn.innerText = "Sending...";

                const params = new URLSearchParams();
                params.append("action", "sendOtp");
                params.append("isForgot", "true");
                params.append("email", email);
                params.append("phone", phone);

                fetch("${pageContext.request.contextPath}/user/password/forgot", {
                    method: "POST",
                    headers: { "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8" },
                    body: params.toString()
                })
                .then(response => response.text())
                .then(data => {
                    btn.disabled = false;
                    btn.innerText = "Send OTP";
                    if (data.trim() === "SUCCESS") {
                        alert("OTP has been sent to your email.");
                    } else {
                        alert("Error: " + data);
                    }
                })
                .catch(error => {
                    btn.disabled = false;
                    btn.innerText = "Send OTP";
                    console.error("AJAX error:", error);
                    alert("Network error while sending OTP.");
                });
            }
        </script>
    </body>
</html>
