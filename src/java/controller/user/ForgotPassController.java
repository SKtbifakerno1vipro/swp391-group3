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

    private final UserService userService = new UserService();
    
    // Hien thi Form khi goi GET
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setAttribute("isForgot", true);
        request.getRequestDispatcher("/views/user/password.jsp").forward(request, response);
    }

    // Xu ly du lieu Form gui len khi goi POST
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        
        String action = request.getParameter("action");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        if ("sendOtp".equals(action)) {
            // ---- LUONG 1: BAM NUT GUI MA QUA AJAX ----

            // CAU HINH AU RA: Tra ve chu thuan (text) chu khong tra ve trang HTML
            response.setContentType("text/plain");
            response.setCharacterEncoding("UTF-8");

            User u = userService.checkCorrectEmailAndPhone(phone, email); 

            if (u != null) {
                // 2. Tao ma OTP ngau nhien
                String otpCode = PasswordUtils.generateRandomText();

                // 3. Luu OTP va oi tuong User vao Session e kiem tra luc sau
                session.setAttribute("recoveryOtp", otpCode);
                session.setAttribute("userAuth", u);
                session.setMaxInactiveInterval(5 * 60); // Ht hn sau 5 pht

                String emailSubject = "[SWP391] M xc thc (OTP) khi phc mt khu";
                String emailBody = "<div style='font-family: Arial, sans-serif; line-height: 1.6; max-width: 500px; margin: 0 auto; padding: 20px; border: 1px solid #eee; border-radius: 5px;'>"
                                 + "<h2>Xc thc yu cu cp li mt khu</h2>"
                                 + "<p>Xin cho,</p>"
                                 + "<p>Chng ti nhn c yu cu khi phc mt khu cho ti khon lin kt vi Email ny trn h thng <strong>SWP391</strong>.</p>"
                                 + "<p>M xc thc (OTP) ca bn l:</p>"
                                 + "<div style='text-align: center; margin: 20px 0;'>"
                                 + "    <span style='font-size: 24px; font-weight: bold; color: #4CAF50; letter-spacing: 5px; border: 2px dashed #4CAF50; padding: 10px 20px; background-color: #f9f9f9;'>" + otpCode + "</span>"
                                 + "</div>"
                                 + "<p style='color: red;'><strong>Lu :</strong> M ny c hiu lc trong vng 5 pht.  bo mt, tuyt i KHNG chia s m ny vi bt k ai.</p>"
                                 + "<p>Nu bn khng thc hin yu cu ny, vui lng b qua email hoc lin h vi b phn h tr ca chng ti  m bo an ton cho ti khon.</p>"
                                 + "<hr style='border: none; border-top: 1px solid #eee;'/>"
                                 + "<p style='font-size: 12px; color: #888;'>Trn trng,<br/>i ng h tr k thut SWP391.</p>"
                                 + "</div>";

                // 4. Gui email chua ma OTP cho nguoi dung
//                boolean isSent = EmailUtils.sendEmail(email, emailSubject, emailBody);
//
//                if (isSent) {
//                    response.getWriter().write("SUCCESS");
//                } else {
//                    response.getWriter().write("Khong the gui Email. Vui long thu lai!");
//                }
            } else {
                response.getWriter().write("Email hoc S in thoi khng khp vi h thng!");
            }
            return; 

        } else if ("resetPassword".equals(action)) {
            // ---- LUONG 2: BAM NUT CAP NHAT MAT KHAU ----
            String userOtp = request.getParameter("otpCode");
            
            String sessionOtp = (String) session.getAttribute("recoveryOtp");
            // test
            userOtp = sessionOtp;
            User sessionUser = (User) session.getAttribute("userAuth");
            // Kiem tra ma OTP hop le
            if ( (sessionOtp != null && sessionOtp.equals(userOtp) && email.equals(sessionUser.getEmail()))) {
                
                String newPass = PasswordUtils.generateRandomText();
                // Cap nhat mat khau moi vao Database dua vao Email  sessionUser.getUserId()
                try {
                    String isUpdated = userService.changePassword(sessionUser.getUserId(), null, newPass); // Hm t vit  di
                    
                    if (isUpdated == null) {
                        request.setAttribute("success", "Xc nhn thnh cng!");
                        session.removeAttribute("recoveryOtp");
                        
                        session.setAttribute("forgetPass", newPass);
                        request.setAttribute("isForgot", false);
                        request.getRequestDispatcher("/views/user/password.jsp").forward(request, response);
                        return;
                    } else {
                        request.setAttribute("error", "t li mt khu tht bi. Vui lng th li!");
                    }
                } catch (Exception e) {
                    e.printStackTrace(); 
                    request.setAttribute("error", " xy ra li h thng khi cp nht mt khu.");
                    request.setAttribute("errorDetail", e.getMessage());
                }
            } else {
                request.setAttribute("error", "M xc nhn (OTP) khng chnh xc hoc  ht hn!");
            }
            request.setAttribute("isForgot", true);
            request.getRequestDispatcher("/views/user/password.jsp").forward(request, response);
        }
    }
}