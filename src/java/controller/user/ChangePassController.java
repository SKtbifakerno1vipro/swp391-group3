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
        request.getRequestDispatcher("/views/user/password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        User user = (User) request.getSession().getAttribute("user"); 
        if (user==null) user = (User) request.getSession().getAttribute("userAuth");
        
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
                        Enumeration<String> attrs = request.getAttributeNames();

                            while(attrs.hasMoreElements()) {
                                String name = attrs.nextElement();
                                System.out.println(name + " = " + request.getAttribute(name));
                            }

                        HttpSession session = request.getSession(false);

                            if(session != null) {
                                Enumeration<String> names = session.getAttributeNames();

                                while(names.hasMoreElements()) {
                                    String name = names.nextElement();
                                    System.out.println(name + " = " + session.getAttribute(name));
                                }
                            }
        
        if(currentPassword == null || currentPassword.trim().isEmpty()){
            currentPassword = (String)request.getSession().getAttribute("forgetPass");
            
            request.getSession().removeAttribute("forgetPass");
            request.getSession().removeAttribute("userAuth");
        }
        if (currentPassword == null || currentPassword.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {

            request.setAttribute("error", "Vui lng nhp y  tt c cc trng!");
            request.getRequestDispatcher("/views/user/password.jsp").forward(request, response);
            return;
        }
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mt khu mi v xc nhn mt khu khng khp!");
            request.getRequestDispatcher("/views/user/password.jsp").forward(request, response);
            return;
        }
        try {     
            String resultMessage = userService.changePassword(user.getUserId(), currentPassword, newPassword);
            if (resultMessage == null) {
                request.setAttribute("success", "i mt khu thnh cng!");
            } else {
                request.setAttribute("error", resultMessage);
            }
        } catch (Exception e) {
            request.setAttribute("error", " xy ra li khi kt ni c s d liu!");
            request.setAttribute("errorDetail", e.getMessage());
        }

        request.getRequestDispatcher("/views/user/password.jsp").forward(request, response);
    }
}