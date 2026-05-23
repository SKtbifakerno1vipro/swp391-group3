package controller.role;

import service.RoleService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class AddRoleController extends HttpServlet {

    private final RoleService roleService = new RoleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/views/role/add-role.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            String roleName = request.getParameter("roleName");

            if (roleName == null || roleName.trim().isEmpty()) {
                request.setAttribute("error", "Tên nhóm quyền không được để trống!");
                request.getRequestDispatcher("/views/role/add-role.jsp").forward(request, response);
                return;
            }

            boolean isSuccess = roleService.insertRole(roleName.trim());

            if (isSuccess) {
                response.sendRedirect(request.getContextPath() + "/role-list?status=add_success");
            } else {
                request.setAttribute("error", "Thêm mới thất bại! Vui lòng thử lại.");
                request.getRequestDispatcher("/views/role/add-role.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống khi thêm Role!");
        }
    }
}
