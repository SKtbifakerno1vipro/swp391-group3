package controller.auth;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.HashSet;
import service.CustomerService;
import service.RoleService;
import service.UserService;
import utils.*;
import model.*;

@WebServlet("/auth/forgot")
public class ForgotPassController extends HttpServlet {

    private final UserService userService = new UserService();
    
    // Hien thi Form khi goi GET
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setAttribute("isForgot", true);
        request.getRequestDispatcher("/views/auth/forgot_pass.jsp").forward(request, response);
    }

    // Xu ly du lieu Form gui len khi goi POST
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        
        String action = request.getParameter("action");
        String email = request.getParameter("email");
        String username = request.getParameter("username");

        if ("sendOtp".equals(action)) {
            // ---- LUONG 1: BAM NUT GUI MA QUA AJAX ----

            // CAU HINH AU RA: Tra ve chu thuan (text) chu khong tra ve trang HTML
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");

            User u = userService.checkCorrectEmailAndUsername(username, email); 

            if (u != null) {
                // 2. Tạo mã OTP ngẫu nhiên
                String otpCode = PasswordUtils.generateRandomText();

                // 3. Lưu OTP và đối tượng User vào Session để kiểm tra lúc sau
                session.setAttribute("recoveryOtp", otpCode);
                session.setAttribute("otpCreationTime", System.currentTimeMillis());
                session.setAttribute("userAuth", u);

                String emailSubject = "[SWP391] Mã xác thực (OTP) khôi phục mật khẩu";
                String emailBody = "<div style='font-family: Arial, sans-serif; line-height: 1.6; max-width: 500px; margin: 0 auto; padding: 20px; border: 1px solid #eee; border-radius: 5px;'>"
                                 + "<h2>Xác thực yêu cầu cấp lại mật khẩu</h2>"
                                 + "<p>Xin chào,</p>"
                                 + "<p>Chúng tôi nhận được yêu cầu khôi phục mật khẩu cho tài khoản liên kết với Email này trên hệ thống <strong>SWP391</strong>.</p>"
                                 + "<p>Mã xác thực (OTP) của bạn là:</p>"
                                 + "<div style='text-align: center; margin: 20px 0;'>"
                                 + "    <span style='font-size: 24px; font-weight: bold; color: #4CAF50; letter-spacing: 5px; border: 2px dashed #4CAF50; padding: 10px 20px; background-color: #f9f9f9;'>" + otpCode + "</span>"
                                 + "</div>"
                                 + "<p style='color: red;'><strong>Lưu ý:</strong> Mã này có hiệu lực trong vòng 5 phút. Để bảo mật, tuyệt đối KHÔNG chia sẻ mã này với bất kỳ ai.</p>"
                                 + "<p>Nếu bạn không thực hiện yêu cầu này, vui lòng bỏ qua email hoặc liên hệ với bộ phận hỗ trợ của chúng tôi để đảm bảo an toàn cho tài khoản.</p>"
                                 + "<hr style='border: none; border-top: 1px solid #eee;'/>"
                                 + "<p style='font-size: 12px; color: #888;'>Trân trọng,<br/>Đội ngũ hỗ trợ kỹ thuật SWP391.</p>"
                                 + "</div>";

                //4. Gửi email chứa mã OTP cho người dùng
                boolean isSent = EmailUtils.sendEmail(email, emailSubject, emailBody);

                if (isSent) {
                    response.getWriter().write("SUCCESS");
                } else {
                    response.getWriter().write("Không thể gửi Email. Vui lòng thử lại!");
                }
            } else {
                response.getWriter().write("Email hoặc Tên đăng nhập không khớp với hệ thống!");
            }
            return; 

        } else if ("resetPassword".equals(action)) {
            // ---- LUỒNG 2: BẤM NÚT CẬP NHẬT MẬT KHẨU ----
            String userOtp = request.getParameter("otpCode");
            
            String sessionOtp = (String) session.getAttribute("recoveryOtp");
            Long otpCreationTime = (Long) session.getAttribute("otpCreationTime");
            User sessionUser = (User) session.getAttribute("userAuth");
                        
            boolean isValid = false;
            if (sessionOtp != null && otpCreationTime != null && sessionUser != null && userOtp != null && !userOtp.trim().isEmpty()) {
                long elapsedTime = System.currentTimeMillis() - otpCreationTime;
                // Kiểm tra mã OTP khớp và còn hiệu lực trong vòng 5 phút (5 * 60 * 1000 ms)
                if (elapsedTime <= 5 * 60 * 1000 && sessionOtp.equals(userOtp.trim()) && email != null && email.trim().equals(sessionUser.getEmail().trim())) {
                    isValid = true;
                    // Xóa mã OTP khỏi session ngay lập tức để đảm bảo sử dụng 1 lần duy nhất (One-time use)
                    session.removeAttribute("recoveryOtp");
                    session.removeAttribute("otpCreationTime");
                }
            }
            
            if (isValid) {
                String newPass = PasswordUtils.generateRandomText();
                // Cập nhật mật khẩu mới ngẫu nhiên vào Database
                try {
                    String isUpdated = userService.changePassword(sessionUser.getUserId(), null, newPass); // Hàm tự viết ở dưới
                    
                    if (isUpdated == null) {
                        session.setAttribute("forgetPass", newPass);
                        // Redirect người dùng đến trang đổi mật khẩu mới
                        response.sendRedirect(request.getContextPath() + "/user/password/change");
                        return;
                    } else {
                        session.removeAttribute("userAuth");
                        session.removeAttribute("recoveryOtp");
                        session.removeAttribute("otpCreationTime");
                        request.setAttribute("error", "Đặt lại mật khẩu thất bại. Vui lòng thử lại!");
                    }
                } catch (Exception e) {
                    e.printStackTrace(); 
                    session.removeAttribute("userAuth");
                    session.removeAttribute("recoveryOtp");
                    session.removeAttribute("otpCreationTime");
                    request.setAttribute("error", "Đã xảy ra lỗi hệ thống khi cập nhật mật khẩu.");
                    request.setAttribute("errorDetail", e.getMessage());
                }
            } else {
                // Xác định rõ nguyên nhân thất bại để hiển thị thông báo chi tiết và tránh xóa session bừa bãi
                if (sessionOtp == null || otpCreationTime == null || sessionUser == null) {
                    request.setAttribute("error", "Vui lòng yêu cầu gửi mã xác nhận trước!");
                } else if (userOtp == null || userOtp.trim().isEmpty()) {
                    request.setAttribute("error", "Vui lòng nhập mã xác nhận (OTP)!");
                } else {
                    long elapsedTime = System.currentTimeMillis() - otpCreationTime;
                    if (elapsedTime > 5 * 60 * 1000) {
                        // Quá hạn: Xóa các thông tin xác thực cũ
                        session.removeAttribute("userAuth");
                        session.removeAttribute("recoveryOtp");
                        session.removeAttribute("otpCreationTime");
                        request.setAttribute("error", "Mã xác nhận (OTP) đã hết hạn (quá 5 phút). Vui lòng gửi lại mã mới!");
                    } else if (email == null || !email.trim().equals(sessionUser.getEmail().trim())) {
                        request.setAttribute("error", "Email không khớp với yêu cầu khôi phục!");
                    } else {
                        // Sai mã xác nhận nhưng chưa hết hạn: Cho phép nhập lại (không xóa session)
                        request.setAttribute("error", "Mã xác nhận (OTP) không chính xác. Vui lòng nhập lại!");
                    }
                }
            }
            request.setAttribute("isForgot", true);
            request.getRequestDispatcher("/views/auth/forgot_pass.jsp").forward(request, response);
        }
    }
}