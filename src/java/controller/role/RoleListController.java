package controller.role;

import service.RoleService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException; 
import java.util.List;

import model.Role;

@WebServlet(name = "RoleListController", urlPatterns = {"/role-list"})
public class RoleListController extends HttpServlet {

    private final RoleService roleService = new RoleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String searchText = request.getParameter("search");
       
        if (searchText != null){
            searchText = searchText.trim();
            searchText = searchText.replaceAll("\\s+", " ");
        }
       
        List<Role> roles = roleService.searchRoles(searchText);
        
        int page = 1;
        int pageSize =2;
        
        String pageParam = request.getParameter("page");
        
        if (pageParam != null && !pageParam.isBlank()){
            page = Integer.parseInt(pageParam);
        }
        
        int totalRoles = roleService.countRoles();
        int totalPages = (int) Math.ceil((double) totalRoles / pageSize);
        // Lấy danh sách theo trang
        List<Role> roleList =roleService.getRolesByPage(page, pageSize);
        
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchText", searchText);
        // Gửi danh sách đã phân trang sang JSP
        request.setAttribute("roleList", roleList); 
        
       
      
        request.getRequestDispatcher("/views/role/list.jsp").forward(request, response);
    }
}