<%--
    Document   : change_pass
    Created on : Jun 3, 2026, 1:18:42 PM
    Author     : XHieu
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>${isForgot? 'Qun Mt Khu' : 'i Mt Khu'}</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 50px; background-color: #f4f4f9; }
            .form-container { max-width: 400px; margin: 0 auto; padding: 20px; border: 1px solid #ccc; border-radius: 5px; background: white; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
            .form-group { margin-bottom: 15px; }
            .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
            .form-group input { width: 100%; padding: 8px; box-sizing: border-box; border: 1px solid #ddd; border-radius: 4px; }
            .input-group { display: flex; gap: 10px; }
            .input-group input { flex: 1; }
            .btn-send { background-color: #008CBA; color: white; border: none; padding: 0 15px; border-radius: 4px; cursor: pointer; white-space: nowrap; }
            .btn-send:hover { background-color: #007B9E; }
            .btn-submit { background-color: #4CAF50; color: white; padding: 10px 15px; border: none; border-radius: 4px; cursor: pointer; width: 100%; font-size: 16px; }
            .btn-submit:hover { background-color: #45a049; }
            .alert { padding: 10px; margin-bottom: 15px; border-radius: 4px; }
            .alert-success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
            .alert-danger { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        </style>

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Literata:wght@600;700&amp;family=Nunito+Sans:wght@400;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,500,0,0&amp;display=block" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app-layout.css">
    </head>
    <body>
        <div class="dashboard-shell">
            <jsp:include page="/views/shared/sidebar.jsp">
                <jsp:param name="activeMenu" value="users"/>
            </jsp:include>
            <main class="main legacy-page">
        <div class="form-container">
            <h2>${isForgot ? 'Qun Mt Khu' : 'i Mt Khu'}</h2>

            <%-- Thong bao ket qua --%>
            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <strong>Li:</strong> ${error}
                    <c:if test="${not empty errorDetail}">
                        <br><small>${errorDetail}</small>
                    </c:if>
                </div>
            </c:if>

            <%-- Form gui yeu cau (oi mat khau HOAC Xac nhan ma e oi mat khau moi) --%>
            <form action="${pageContext.request.contextPath}/user/password/${isForgot ? 'forgot' : 'change'}" method="POST">
                <%-- Truyen ngam trang thai isForgot len Servlet --%>
                <input type="hidden" name="isForgot" value="${isForgot}">

                <c:choose>
                    <c:when test="${isForgot}">
                        <div class="form-group">
                            <label for="email">Email ng k:</label>
                            <div class="input-group">
                                <input type="email" id="email" name="email" value="${email}" required>
                                <%-- Nut gui ma OTP --%>
                                <button type="button" id="btnSendOtp" name="action" onclick="sendOtpAjax()" class="btn-send">Gi m</button>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="phone">S in thoi:</label>
                            <input type="text" id="phone" name="phone" value="${phone}" required>
                        </div>

                        <div class="form-group">
                            <label for="otpCode">M xc nhn (OTP):</label>
                            <input type="text" id="otpCode" name="otpCode" required placeholder="Nhp m t Email">
                        </div>
                    </c:when>

                    <c:otherwise>

                        <c:if test="${empty sessionScope.forgetPass}">
                            <div class="form-group">
                                <label for="currentPassword">Mt khu hin ti:</label>
                                <input type="password" id="currentPassword" name="currentPassword" required>
                            </div>
                        </c:if>
                        <div class="form-group">
                            <label for="newPassword">Mt khu mi:</label>
                            <input type="password" id="newPassword" name="newPassword" required>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">Nhp li mt khu mi:</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" required>
                        </div>
                    </c:otherwise>
                </c:choose>

                <c:choose>
                    <c:when test="${isForgot}">
                        <button type="submit" name="action" value="resetPassword" class="btn-submit">Gi yu cu</button>
                    </c:when>
                    <c:otherwise>
                        <button type="submit" name="action" value="changePassword" class="btn-submit">i mt khu</button>
                    </c:otherwise>
                </c:choose>
            </form>
        </div>

            </main>
        </div>
    </body>
</html>
<script>
function sendOtpAjax() {
    // 1. Lay du lieu tu cac o input
    const email = document.getElementById("email").value;
    const phone = document.getElementById("phone").value;
    const btn = document.getElementById("btnSendOtp");

    // Kiem tra nhanh xem nguoi dung a nhap u chua
    if (!email || !phone) {
        alert("Vui lng nhp y  Email v S in thoi trc khi nhn m!");
        return;
    }

    // Vo hieu hoa nut bam tam thoi e tranh nguoi dung click lien tuc
    btn.disabled = true;
    btn.innerText = "ang gi...";

    // 2. Tao URL va tham so e gui ngam len Servlet
    // Su dung URLSearchParams e ong goi du lieu giong nhu form submit
    const params = new URLSearchParams();
    params.append("action", "sendOtp");
    params.append("isForgot", "true");
    params.append("email", email);
    params.append("phone", phone);

    // 3. Tien hanh goi AJAX bang Fetch API
    fetch("${pageContext.request.contextPath}/user/password/forgot", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
        },
        body: params.toString()
    })
    .then(response => response.text()) // Nhn phn hi dng ch t Servlet
    .then(data => {
        // Khoi phuc lai trang thai nut bam
        btn.disabled = false;
        btn.innerText = "Gi m";

        // Xu ly ket qua tra ve tu Servlet (o Buoc 3 chung ta se cau hinh Servlet tra ve chu "OK" hoac loi)
        if (data.trim() === "SUCCESS") {
            alert("M xc nhn (OTP)  c gi ti Email ca bn!");
        } else {
            alert("Li: " + data); // Hin th thng bo li t h thng
        }
    })
    .catch(error => {
        btn.disabled = false;
        btn.innerText = "Gi m";
        console.error("Li AJAX:", error);
        alert(" xy ra li kt ni mng!");
    });
}
</script>
