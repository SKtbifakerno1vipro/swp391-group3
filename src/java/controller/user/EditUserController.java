package controller.user;

import service.UserService;
import dal.RoleDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import java.util.List;

@WebServlet(name = "EditUserController", urlPatterns = {"/edit-user"})
public class EditUserController extends HttpServlet {
    
    private final UserService userService = new UserService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                User u = userService.getUserById(Integer.parseInt(idStr));
                if (u == null) {
                    response.sendRedirect(request.getContextPath() + "/user-list");
                    return;
                }
                request.setAttribute("u", u);
                RoleDAO roleDAO = new RoleDAO();
                request.setAttribute("roleList", roleDAO.getAllRoles());
                request.getRequestDispatcher("/views/user/form.jsp").forward(request, response);
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/user-list");
        }
    }
    
    boolean isDuplicate(List<User> list, User u) {
        for (User t : list) {
            if (t.getUserId() != u.getUserId()) {
                if (t.getEmail().equals(u.getEmail()) || (t.getPhone() != null && t.getPhone().equals(u.getPhone()))) {
                    return true;
                }
            }
        }
        return false;
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User u = new User();
        
        String userIdStr = request.getParameter("userId");
        if (userIdStr != null && !userIdStr.isEmpty()) {
            u.setUserId(Integer.parseInt(userIdStr));
        }
        u.setUserName(request.getParameter("userName"));
        u.setPassword(request.getParameter("password"));
        u.setEmail(request.getParameter("email"));
        u.setFullName(request.getParameter("fullName"));
        u.setPhone(request.getParameter("phone"));
        u.setStatus(request.getParameter("status"));
        u.setRoleId(Integer.valueOf(request.getParameter("roleId")));
        
        List<User> list = userService.getAllUsers();
        if (isDuplicate(list, u)) {
            request.setAttribute("error", "Duplicate email or phone");
            request.setAttribute("u", u);
                RoleDAO roleDAO = new RoleDAO();
                request.setAttribute("roleList", roleDAO.getAllRoles());
                request.getRequestDispatcher("/views/user/form.jsp").forward(request, response);
            return;
        }
        userService.updateUser(u);
        response.sendRedirect(request.getContextPath() + "/user-list");
    }
}
