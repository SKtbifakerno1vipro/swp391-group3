package controller.user;



import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dto.*;
import java.util.Enumeration;
import model.*;
import service.CustomerService;
import service.RoleService;
import service.UserService;

@WebServlet("/user/password/change")
public class ChangePassController extends HttpServlet {
    
    private final CustomerService customerService = new CustomerService();
    private final UserService userService = new UserService();
    private final RoleService roleService = new RoleService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = null;
        if (session != null) {
            user = (User) session.getAttribute("user");
            if (user == null) {
                user = (User) session.getAttribute("userAuth");
            }
        }
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.getRequestDispatcher("/views/user/password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = null;
        if (session != null) {
            user = (User) session.getAttribute("user");
            if (user == null) {
                user = (User) session.getAttribute("userAuth");
            }
        }
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        Enumeration<String> attrs = request.getAttributeNames();

        while(attrs.hasMoreElements()) {
            String name = attrs.nextElement();
            System.out.println(name + " = " + request.getAttribute(name));
        }

        if(session != null) {
            Enumeration<String> names = session.getAttributeNames();

            while(names.hasMoreElements()) {
                String name = names.nextElement();
                System.out.println(name + " = " + session.getAttribute(name));
            }
        }
        
        boolean isForgetFlow = false;
        if (currentPassword == null || currentPassword.trim().isEmpty()) {
            String forgetPass = (String) session.getAttribute("forgetPass");
            if (forgetPass != null && !forgetPass.trim().isEmpty()) {
                currentPassword = forgetPass;
                isForgetFlow = true;
            }
        }
        
        if (currentPassword == null || currentPassword.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {

            request.setAttribute("error", "Vui lòng nhập đầy đủ tất cả các trường!");
            request.getRequestDispatcher("/views/user/password.jsp").forward(request, response);
            return;
        }
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu mới và xác nhận mật khẩu không khớp!");
            request.getRequestDispatcher("/views/user/password.jsp").forward(request, response);
            return;
        }
        try {     
            String resultMessage = userService.changePassword(user.getUserId(), currentPassword, newPassword);
            if (resultMessage == null) {
                request.setAttribute("success", "Đổi mật khẩu thành công!");
                if (isForgetFlow) {
                    request.setAttribute("isForgetFlowSuccess", true);
                    session.removeAttribute("forgetPass");
                    session.removeAttribute("userAuth");
                }
            } else {
                request.setAttribute("error", resultMessage);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Đã xảy ra lỗi khi kết nối cơ sở dữ liệu!");
            request.setAttribute("errorDetail", e.getMessage());
        }

        request.getRequestDispatcher("/views/user/password.jsp").forward(request, response);
    }
}