package controller.role;

import service.RoleService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException; 

@WebServlet(name = "RoleListController", urlPatterns = {"/role-list"})
public class RoleListController extends HttpServlet {

    private final RoleService roleService = new RoleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setAttribute("roleList", roleService.getAllRoles());
        request.getRequestDispatcher("/views/role/list.jsp").forward(request, response);
    }
}