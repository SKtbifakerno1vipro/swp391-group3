package controller.user;

import service.*;
import utils.Validation;
import dal.RoleDAO;
import model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;

@WebServlet(name = "EditUserController", urlPatterns = {"/edit-user"})
public class EditUserController extends HttpServlet {

    private final UserService userService = new UserService();
    private final RoleService roleService = new RoleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        request.setAttribute("roles", roleService.getAllRoles());

        // Nếu có ID -> Chế độ EDIT -> vào detail.jsp
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                User u = userService.getUserById(Integer.parseInt(idStr));
                if (u != null) {
                    request.setAttribute("u", u);
                    request.setAttribute("mode", "edit");
                    request.getRequestDispatcher("/views/user/detail.jsp").forward(request, response);
                } else {
                    response.sendRedirect("user-list");
                }
            } catch (Exception e) {
                response.sendRedirect("user-list");
            }
        } // Không có ID -> Chế độ CREATE -> vào create.jsp
        else {
            request.setAttribute("mode", "create");
            request.getRequestDispatcher("/views/user/create.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String idStr = request.getParameter("id");
        boolean isEdit = (idStr != null && !idStr.isEmpty());

        User u = new User();
        if (isEdit) {
            u.setUserId(Integer.parseInt(idStr));
        }

        // 1. Lấy dữ liệu chung
        u.setUserName(request.getParameter("userName"));
        u.setEmail(request.getParameter("email"));
        u.setFullName(request.getParameter("fullName"));
        u.setPhone(request.getParameter("phone"));
        u.setStatus(request.getParameter("status"));
        u.setGender(request.getParameter("gender"));
        u.setAddress(request.getParameter("address"));

        try {
            u.setRoleId(Integer.parseInt(request.getParameter("roleId")));
        } catch (Exception e) {
            u.setRoleId(0);
        }

        // 2. Validation
        String error = Validation.validateEmpty(u.getFullName(), "Full Name");
        if (error == null) {
            error = Validation.validateEmail(u.getEmail());
        }
        if (error == null) {
            error = Validation.validatePhone(u.getPhone());
        }

        if (error == null) {
            if (userService.isEmailDuplicate(u.getEmail(), u.getUserId())) {
                error = "Email duplicated!";
            }
            if (userService.isPhoneDuplicate(u.getPhone(), u.getUserId())) {
                error = "Phone duplicated!";
            }
            if (userService.isUsernameDuplicate(u.getUserName(), u.getUserId())) {
                error = "Username duplicated!";
            }
        }

        // Nếu là Create thì check thêm mật khẩu
        String password = request.getParameter("password");
        if (!isEdit && error == null) {
            if (password == null || password.trim().isEmpty()) {
                error = "Password is required!";
            } else {
                u.setPassword(password);
            }
        }

        // 3. Xử lý lỗi (Trả về đúng trang tương ứng)
        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("u", u);
            request.setAttribute("roles", roleService.getAllRoles());
            String targetJSP = isEdit ? "/views/user/detail.jsp" : "/views/user/create.jsp";
            request.getRequestDispatcher(targetJSP).forward(request, response);
            return;
        }

        // 4. Lưu vào Database
        boolean success = isEdit ? userService.updateUser(u) : userService.createUser(u);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/user-list");
        } else {
            request.setAttribute("error", "Database error!");
            String targetJSP = isEdit ? "/views/user/detail.jsp" : "/views/user/create.jsp";
            request.getRequestDispatcher(targetJSP).forward(request, response);
        }
    }
}
