package controller.role;

import service.RoleService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AddRoleController", urlPatterns = {"/add-role"})
public class AddRoleController extends HttpServlet {

    private final RoleService roleService = new RoleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        // Lay danh sach permissions đe hien thi checkbox
        request.setAttribute("permissionList", roleService.getAllPermissions());
        request.getRequestDispatcher("/views/role/add-role.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            // Lay role name
            String roleName = request.getParameter("roleName");

            // Validate: Kiem tra rong
            if (roleName == null || roleName.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập tên Role!");
                request.setAttribute("roleName", roleName);
                request.setAttribute("permissionList", roleService.getAllPermissions());
                request.getRequestDispatcher("/views/role/add-role.jsp").forward(request, response);
                return;
            }

            roleName = roleName.trim();

            // Validate: Kiem tra trung ten
            if (roleService.isRoleNameExists(roleName)) {
                request.setAttribute("error", "Tên Role này đã tồn tại!");
                request.setAttribute("roleName", roleName);
                request.setAttribute("permissionList", roleService.getAllPermissions());
                request.getRequestDispatcher("/views/role/add-role.jsp").forward(request, response);
                return;
            }

            // Tao role moi va lay ID
            int newRoleId = roleService.createRole(roleName);

            // Lay danh sach permission IDs tu checkbox
            String[] permissionIdValues = request.getParameterValues("permissionIds");
            List<Integer> permissionIds = new ArrayList<>();

            if (permissionIdValues != null) {
                for (String val : permissionIdValues) {
                    permissionIds.add(Integer.parseInt(val));
                }
            }
            
            if (newRoleId > 0) {
                // Them permissions cho role vua tao
                if (!permissionIds.isEmpty()) {
                    roleService.updateRolePermissions(newRoleId, permissionIds);
                }

                response.sendRedirect(request.getContextPath() + "/role-list?status=add_success");
            } else {
                request.setAttribute("error", "Lỗi khi thêm Role vào database!");
                request.setAttribute("roleName", roleName);
                request.setAttribute("permissionList", roleService.getAllPermissions());
                request.getRequestDispatcher("/views/role/add-role.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi không xác định khi thêm Role!");
        }
    }
}
