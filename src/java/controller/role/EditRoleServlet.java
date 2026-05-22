package controller.role;

import dal.RoleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Role;

public class EditRoleServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        int roleId = Integer.parseInt(request.getParameter("id"));
        
        RoleDAO dao = new RoleDAO();
        Role role = dao.getRoleById(roleId);
        
        request.setAttribute("role", role);
        
        request.getRequestDispatcher("views/role/edit-role.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        int roleId = Integer.parseInt(request.getParameter("roleId"));
        String roleName = request.getParameter("roleName");
        
        Role role = new Role();
        role.setRoleId(roleId);
        role.setRoleName(roleName);
        
        RoleDAO dao = new RoleDAO();
        dao.updateRole(role);
        
        response.sendRedirect(request.getContextPath() + "/role-list");
        
    }
}
