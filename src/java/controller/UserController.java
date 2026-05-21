package controller;

import dal.UserDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.util.List;

public class UserController extends HttpServlet {

    UserDAO dao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            // 8. User List: Hiển thị danh sách user (có filter)
            case "list":
                String roleId = request.getParameter("roleId");
                String status = request.getParameter("status");
                request.setAttribute("roleId", roleId);
                request.setAttribute("status", status);
                request.setAttribute("users", dao.searchUsers(roleId, status));
                request.getRequestDispatcher("views/user/list.jsp").forward(request, response);
                break;

            // 9. User Detail: Hiển thị chi tiết 1 user
            case "view":
                int idView = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("u", dao.getUserById(idView));
                request.getRequestDispatcher("views/user/detail.jsp").forward(request, response);
                break;

            // 11. Edit User: Hiển thị form edit
            case "edit":
                int idEdit = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("u", dao.getUserById(idEdit));
                request.getRequestDispatcher("views/user/form.jsp").forward(request, response);
                break;

            // 10. Create User: Hiển thị form tạo mới
            case "create":
                request.getRequestDispatcher("views/user/form.jsp").forward(request, response);
                break;
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("userId");
        User u = new User();
        u.setUserName(request.getParameter("userName"));
        u.setPassword(request.getParameter("password"));
        u.setEmail(request.getParameter("email"));
        u.setFullName(request.getParameter("fullName"));
        u.setPhone(request.getParameter("phone"));
        u.setStatus(request.getParameter("status"));
        u.setRoleId(Integer.parseInt(request.getParameter("roleId")));

        // Nếu không có userId = tạo mới, nếu có = cập nhật
        if (idStr == null || idStr.isEmpty()) {
            dao.createUser(u); // 10. Create
        } else {
            u.setUserId(Integer.parseInt(idStr));
            dao.updateUser(u); // 11. Edit
        }

        request.setAttribute("users", dao.getAllUsers());
        request.getRequestDispatcher("views/user/list.jsp").forward(request, response);
    }
}
