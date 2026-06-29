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

                String emailSubject = "[SWP391] Verification code (OTP) for password recovery";
                String emailBody = "<div style='font-family: Arial, sans-serif; line-height: 1.6; max-width: 500px; margin: 0 auto; padding: 20px; border: 1px solid #eee; border-radius: 5px;'>"
                                 + "<h2>Reset Password Verification</h2>"
                                 + "<p>Hello,</p>"
                                 + "<p>We received a request to recover the password for the account associated with this email address on <strong>SWP391</strong>.</p>"
                                 + "<p>Your verification code (OTP) is:</p>"
                                 + "<div style='text-align: center; margin: 20px 0;'>"
                                 + "    <span style='font-size: 24px; font-weight: bold; color: #4CAF50; letter-spacing: 5px; border: 2px dashed #4CAF50; padding: 10px 20px; background-color: #f9f9f9;'>" + otpCode + "</span>"
                                 + "</div>"
                                 + "<p style='color: red;'><strong>Note:</strong> This code is valid for 5 minutes. For security reasons, please do NOT share this code with anyone.</p>"
                                 + "<p>If you did not make this request, please ignore this email or contact support to ensure your account security.</p>"
                                 + "<hr style='border: none; border-top: 1px solid #eee;'/>"
                                 + "<p style='font-size: 12px; color: #888;'>Best regards,<br/>SWP391 Technical Support Team.</p>"
                                 + "</div>";

                //4. Gửi email chứa mã OTP cho người dùng (bất đồng bộ)
                EmailUtils.sendEmailAsync(email, emailSubject, emailBody);
                response.getWriter().write("SUCCESS");
            } else {
                response.getWriter().write("Email or Username does not match our records!");
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
                        request.setAttribute("error", "Resetting password failed. Please try again!");
                    }
                } catch (Exception e) {
                    e.printStackTrace(); 
                    session.removeAttribute("userAuth");
                    session.removeAttribute("recoveryOtp");
                    session.removeAttribute("otpCreationTime");
                    request.setAttribute("error", "A system error occurred while updating the password.");
                    request.setAttribute("errorDetail", e.getMessage());
                }
            } else {
                // Xác định rõ nguyên nhân thất bại để hiển thị thông báo chi tiết và tránh xóa session bừa bãi
                if (sessionOtp == null || otpCreationTime == null || sessionUser == null) {
                    request.setAttribute("error", "Please request a verification code first!");
                } else if (userOtp == null || userOtp.trim().isEmpty()) {
                    request.setAttribute("error", "Please enter the verification code (OTP)!");
                } else {
                    long elapsedTime = System.currentTimeMillis() - otpCreationTime;
                    if (elapsedTime > 5 * 60 * 1000) {
                        // Quá hạn
                        session.removeAttribute("userAuth");
                        session.removeAttribute("recoveryOtp");
                        session.removeAttribute("otpCreationTime");
                        request.setAttribute("error", "The verification code (OTP) has expired (exceeded 5 minutes). Please request a new code!");
                    } else if (email == null || !email.trim().equals(sessionUser.getEmail().trim())) {
                        request.setAttribute("error", "Email does not match the recovery request!");
                    } else {
                        // Sai mã xác nhận nhưng chưa hết hạn: Cho phép nhập lại (không xóa session)
                        request.setAttribute("error", "Incorrect verification code (OTP). Please try again!");
                    }
                }
            }
            request.setAttribute("isForgot", true);
            request.getRequestDispatcher("/views/auth/forgot_pass.jsp").forward(request, response);
        }
    }
}