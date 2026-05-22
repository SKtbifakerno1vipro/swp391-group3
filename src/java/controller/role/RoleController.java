package controller.role;

import model.Permission;
import model.Role;
import dal.RoleDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "RoleController", urlPatterns = {"/role-detail"})
public class RoleController extends HttpServlet {

    private RoleDAO roleDAO;

    @Override
    public void init() {
        roleDAO = new RoleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String roleIdParam = request.getParameter("roleId");
            if (roleIdParam == null || roleIdParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/role-list");
                return;
            }
            
            int roleId = Integer.parseInt(roleIdParam);
            
            // Láº¥y chi tiáº¿t vai trÃ² (Role) kÃ¨m quyá»n hiá»‡n táº¡i
            Role role = roleDAO.getRoleDetail(roleId);
            // Láº¥y tá»•ng táº¥t cáº£ cÃ¡c quyá»n cÃ³ trong há»‡ thá»‘ng
            List<Permission> allPermissions = roleDAO.getAllPermissions();


            if (role != null) {
                request.setAttribute("role", role);
                request.setAttribute("allPermissions", allPermissions);
                request.getRequestDispatcher("/index.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/role-list");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID cá»§a vai trÃ² khÃ´ng há»£p lá»‡!");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int roleId = Integer.parseInt(request.getParameter("roleId"));
            
            // Láº¥y táº¥t cáº£ cÃ¡c ID cá»§a quyá»n cÃ³ trong há»‡ thá»‘ng
            List<Permission> allPermissions = roleDAO.getAllPermissions();
            List<Integer> selectedPermissionIds = new ArrayList<>();

            // Duyá»‡t qua danh sÃ¡ch quyá»n, kiá»ƒm tra xem checkbox tÆ°Æ¡ng á»©ng cÃ³ Ä‘Æ°á»£c tÃ­ch chá»n khÃ´ng
            for (Permission p : allPermissions) {
                String paramName = "permission_" + p.getPermissionId();
                String paramValue = request.getParameter(paramName);
                
                if (paramValue != null) { // Náº¿u parameter khÃ¡c null nghÄ©a lÃ  checkbox Ä‘Ã£ Ä‘Æ°á»£c tick chá»n
                    selectedPermissionIds.add(p.getPermissionId());
                }
            }

            // Gá»i hÃ m thá»±c thi xÃ³a cÅ© - thÃªm má»›i trong DB
            roleDAO.updateRolePermissions(roleId, selectedPermissionIds);

            // Quay trá»Ÿ vá» trang chi tiáº¿t kÃ¨m tráº¡ng thÃ¡i cáº­p nháº­t thÃ nh cÃ´ng
            response.sendRedirect(request.getContextPath() + "/role-detail?roleId=" + roleId + "&status=success");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "ÄÃ£ xáº£y ra lá»—i trong quÃ¡ trÃ¬nh lÆ°u quyá»n!");
        }
    }
}