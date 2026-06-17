package controller.user;

import service.UserService;
import service.RoleService;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.annotation.WebServlet;

@WebServlet(name = "UserListController", urlPatterns = {"/user-list"})
public class UserListController extends HttpServlet {

    private final UserService userService = new UserService();
    private final RoleService roleService = new RoleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        String roleIdString = request.getParameter("roleId");
        String status = request.getParameter("status");
        String searchEmail = request.getParameter("searchEmail");
        String searchPhone = request.getParameter("searchPhone");
        String searchName = request.getParameter("searchName");
        int roleId = 0;
        if (roleIdString != null && !roleIdString.trim().isEmpty()) {
            try {
                roleId = Integer.parseInt(roleIdString);
            } catch (Exception e) {
                roleId = 0;
            }
        }

        int pageSize = 10;
        int pageIndex = 1;

        String page = request.getParameter("page");
        if (page != null) {
            try {
                pageIndex = Integer.parseInt(page);
            } catch (NumberFormatException e) {
                pageIndex = 1;
            }
        }

        int totalRecord = userService.getTotalUsers(roleId, status, searchName, searchPhone, searchEmail);
        int endPage = (int) Math.ceil((double) totalRecord / pageSize);

        // Prevent page out of range
        if (pageIndex > endPage && endPage > 0) {
            pageIndex = endPage;
        }

        request.setAttribute("roleId", roleId);
        request.setAttribute("status", status);
        request.setAttribute("users", userService.searchUsers(roleId, status, searchName, searchPhone, searchEmail, pageIndex, pageSize));
        request.setAttribute("roles", roleService.getAllRoles());
        request.setAttribute("searchEmail", searchEmail);
        request.setAttribute("searchPhone", searchPhone);
        request.setAttribute("searchName", searchName);
        request.setAttribute("endPage", endPage);
        request.setAttribute("currentPage", pageIndex);
        request.getRequestDispatcher("/views/user/list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String currentStatus = request.getParameter("status");

            if ("ACTIVE".equals(currentStatus)) {
                userService.banUser(userId, "INACTIVE");
            } else if ("INACTIVE".equals(currentStatus)) {
                userService.banUser(userId, "ACTIVE");
            } else {
                userService.banUser(userId, currentStatus);
            }
        } catch (NumberFormatException e) {

        }

        response.sendRedirect(request.getContextPath() + "/user-list");
    }
}
