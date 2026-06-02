package controller.user;

import service.UserService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import service.RoleService;

@WebServlet(name = "UserListController", urlPatterns = {"/user-list"})
public class UserListController extends HttpServlet {

    private final UserService userService = new UserService();
    private final RoleService roleService = new RoleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String roleIdString = request.getParameter("roleId");
        String status = request.getParameter("status");
        String keyword = request.getParameter("keyword");
        int roleId = 0;
        if (roleIdString != null && !roleIdString.trim().isEmpty()) {
            try {
                roleId = Integer.parseInt(roleIdString);
            } catch (Exception e) {
                roleId = 0;
            }
        }

        int pageSize = 10; // defaut 10 user one page
        int pageIndex = 1; //default is page one

        String page = request.getParameter("page");
        if (page != null) {
            pageIndex = Integer.parseInt(page);
        }
        int totalRecord = userService.getTotalUsers(roleId, status, keyword);
        int endPage = (int) Math.ceil((double) totalRecord / pageSize);

        request.setAttribute("roleId", roleId);
        request.setAttribute("status", status);
        request.setAttribute("users", userService.searchUsers(roleId, status, keyword, pageIndex, pageSize));
        request.setAttribute("roles", roleService.getAllRoles());

        request.setAttribute("endPage", endPage);
        request.setAttribute("currentPage", pageIndex);
        request.getRequestDispatcher("/views/user/list.jsp").forward(request, response);
    }
}
