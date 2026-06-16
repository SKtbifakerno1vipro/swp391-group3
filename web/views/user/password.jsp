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
        <title>${isForgot? 'Quên Mật Khẩu' : 'Đổi Mật Khẩu'}</title>
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
            <h2>${isForgot ? 'Quên Mật Khẩu' : 'Đổi Mật Khẩu'}</h2>

            <%-- Thông báo kết quả --%>
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    ${success}
                    <c:if test="${isForgetFlowSuccess}">
                        <br><a href="${pageContext.request.contextPath}/login" style="color: #155724; font-weight: bold; text-decoration: underline;">Đăng nhập ngay</a>
                    </c:if>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <strong>Lỗi:</strong> ${error}
                    <c:if test="${not empty errorDetail}">
                        <br><small>${errorDetail}</small>
                    </c:if>
                </div>
            </c:if>

            <%-- Form gửi yêu cầu (đổi mật khẩu HOẶC Xác nhận mã để đổi mật khẩu mới) --%>
            <form action="${pageContext.request.contextPath}/user/password/${isForgot ? 'forgot' : 'change'}" method="POST">
                <%-- Truyền ngầm trạng thái isForgot lên Servlet --%>
                <input type="hidden" name="isForgot" value="${isForgot}">

                <c:choose>
                    <c:when test="${isForgot}">
                        <div class="form-group">
                            <label for="email">Email đăng ký:</label>
                            <div class="input-group">
                                <input type="email" id="email" name="email" value="${email}" required>
                                <%-- Nút gửi mã OTP --%>
                                <button type="button" id="btnSendOtp" name="action" onclick="sendOtpAjax()" class="btn-send">Gửi mã</button>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="phone">Số điện thoại:</label>
                            <input type="text" id="phone" name="phone" value="${phone}" required>
                        </div>

                        <div class="form-group">
                            <label for="otpCode">Mã xác nhận (OTP):</label>
                            <input type="text" id="otpCode" name="otpCode" required placeholder="Nhập mã từ Email">
                        </div>
                    </c:when>

                    <c:otherwise>

                        <c:if test="${empty sessionScope.forgetPass}">
                            <div class="form-group">
                                <label for="currentPassword">Mật khẩu hiện tại:</label>
                                <input type="password" id="currentPassword" name="currentPassword" required>
                            </div>
                        </c:if>
                        <div class="form-group">
                            <label for="newPassword">Mật khẩu mới:</label>
                            <input type="password" id="newPassword" name="newPassword" required>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">Nhập lại mật khẩu mới:</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" required>
                        </div>
                    </c:otherwise>
                </c:choose>

                <c:choose>
                    <c:when test="${isForgot}">
                        <button type="submit" name="action" value="resetPassword" class="btn-submit">Gửi yêu cầu</button>
                    </c:when>
                    <c:otherwise>
                        <button type="submit" name="action" value="changePassword" class="btn-submit">Đổi mật khẩu</button>
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
    // 1. Lấy dữ liệu từ các ô input
    const email = document.getElementById("email").value;
    const phone = document.getElementById("phone").value;
    const btn = document.getElementById("btnSendOtp");

    // Kiểm tra nhanh xem người dùng đã nhập đủ chưa
    if (!email || !phone) {
        alert("Vui lòng nhập đầy đủ Email và Số điện thoại trước khi nhận mã!");
        return;
    }

    // Vô hiệu hóa nút bấm tạm thời để tránh người dùng click liên tục
    btn.disabled = true;
    btn.innerText = "Đang gửi...";

    // 2. Tạo URL và tham số để gửi ngầm lên Servlet
    // Sử dụng URLSearchParams để đóng gói dữ liệu giống như form submit
    const params = new URLSearchParams();
    params.append("action", "sendOtp");
    params.append("isForgot", "true");
    params.append("email", email);
    params.append("phone", phone);

    // 3. Tiến hành gọi AJAX bằng Fetch API
    fetch("${pageContext.request.contextPath}/user/password/forgot", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
        },
        body: params.toString()
    })
    .then(response => response.text()) // Nhận phản hồi dạng chữ từ Servlet
    .then(data => {
        // Khôi phục lại trạng thái nút bấm
        btn.disabled = false;
        btn.innerText = "Gửi mã";

        // Xử lý kết quả trả về từ Servlet (ở Bước 3 chúng ta sẽ cấu hình Servlet trả về chữ "OK" hoặc lỗi)
        if (data.trim() === "SUCCESS") {
            alert("Mã xác nhận (OTP) đã được gửi tới Email của bạn!");
        } else {
            alert("Lỗi: " + data); // Hiển thị thông báo lỗi từ hệ thống
        }
    })
    .catch(error => {
        btn.disabled = false;
        btn.innerText = "Gửi mã";
        console.error("Lỗi AJAX:", error);
        alert("Đã xảy ra lỗi kết nối mạng!");
    });
}
</script>
