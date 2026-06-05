package controller.user;

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

@WebServlet("/user/password/forgot")
public class ForgotPassController extends HttpServlet {
    
    private final CustomerService customerService = new CustomerService();
    private final UserService userService = new UserService();
    private final RoleService roleService = new RoleService();
    
    // Hiển thị Form khi gọi GET
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setAttribute("isForgot", true);
        request.getRequestDispatcher("/views/user/password.jsp").forward(request, response);
    }

    // Xử lý dữ liệu Form gửi lên khi gọi POST
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        
        String action = request.getParameter("action");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        if ("sendOtp".equals(action)) {
            // ---- LUỒNG 1: BẤM NÚT GỬI MÃ QUA AJAX ----

            // CẤU HÌNH ĐẦU RA: Trả về chữ thuần (text) chứ không trả về trang HTML
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");

            User u = userService.checkCorrectEmailAndPhone(phone, email); 

            if (u != null) {
                // 2. Tạo mã OTP ngẫu nhiên
                String otpCode = PasswordUtils.generateRandomText();

                // 3. Lưu OTP và Đối tượng User vào Session để kiểm tra lúc sau
                session.setAttribute("recoveryOtp", otpCode);
                session.setAttribute("userAuth", u);
                session.setMaxInactiveInterval(5 * 60); // Hết hạn sau 5 phút

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

                // 4. Gửi email chứa mã OTP cho người dùng
//                boolean isSent = EmailUtils.sendEmail(email, emailSubject, emailBody);
//
//                if (isSent) {
//                    response.getWriter().write("SUCCESS");
//                } else {
//                    response.getWriter().write("Không thể gửi Email. Vui lòng thử lại!");
//                }
            } else {
                response.getWriter().write("Email hoặc Số điện thoại không khớp với hệ thống!");
            }
            return; 

        } else if ("resetPassword".equals(action)) {
            // ---- LUỒNG 2: BẤM NÚT CẬP NHẬT MẬT KHẨU ----
            String userOtp = request.getParameter("otpCode");
            
            String sessionOtp = (String) session.getAttribute("recoveryOtp");
            // test
            userOtp = sessionOtp;
            User sessionUser = (User) session.getAttribute("userAuth");
            // Kiểm tra mã OTP hợp lệ
            if ( (sessionOtp != null && sessionOtp.equals(userOtp) && email.equals(sessionUser.getEmail()))) {
                
                String newPass = PasswordUtils.generateRandomText();
                // Cập nhật mật khẩu mới vào Database dựa vào Email  sessionUser.getUserId()
                try {
                    String isUpdated = userService.changePassword(sessionUser.getUserId(), null, newPass); // Hàm tự viết ở dưới
                    
                    if (isUpdated == null) {
                        request.setAttribute("success", "Xác nhận thành công!");
                        session.removeAttribute("recoveryOtp");
                        
                        session.setAttribute("forgetPass", newPass);
                        request.setAttribute("isForgot", false);
                        request.getRequestDispatcher("/views/user/password.jsp").forward(request, response);
                        return;
                    } else {
                        request.setAttribute("error", "Đặt lại mật khẩu thất bại. Vui lòng thử lại!");
                    }
                } catch (Exception e) {
                    e.printStackTrace(); 
                    request.setAttribute("error", "Đã xảy ra lỗi hệ thống khi cập nhật mật khẩu.");
                    request.setAttribute("errorDetail", e.getMessage());
                }
            } else {
                request.setAttribute("error", "Mã xác nhận (OTP) không chính xác hoặc đã hết hạn!");
            }
            request.setAttribute("isForgot", true);
            request.getRequestDispatcher("/views/user/password.jsp").forward(request, response);
        }
    }
}