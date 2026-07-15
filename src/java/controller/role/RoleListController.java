package controller.role;

import service.RoleService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.Collections;
import java.util.List;
import model.Role;

@WebServlet(name = "RoleListController", urlPatterns = {"/role-list"})
public class RoleListController extends HttpServlet {

    private final RoleService roleService = new RoleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        // chuc nang cua searchtext
        String searchText = request.getParameter("search");

        if (searchText != null) {
            searchText = searchText.trim().replaceAll("\\s+", " ");
        }

        List<Role> roles;
        // neu searchtext khong null va ko rong thi thuc hien chuc nang cua search role
        if (searchText != null && !searchText.isBlank()) {
            roles = roleService.searchRoles(searchText);
        } //neu khong thi van hien thi getAllRoles 
        else {
            roles = roleService.getAllRoles();
        }
        //chuc nang chia trang, 1 trang size bao nhieu
        int page = 1;
        int pageSize = 5;
        String pageParam = request.getParameter("page");

        if (pageParam != null && !pageParam.isBlank()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
// thuat toan chia trang 
        int totalRoles = roles.size();
        //tinh tong trang
        int totalPages = (int) Math.ceil((double) totalRoles / pageSize);
        if (totalPages == 0) {
            totalPages = 1;
        }
        if (page < 1) {
            page = 1;
        }
        if (page > totalPages) {
            page = totalPages;
        }
//tinh vi tri cat 
        int fromIndex = Math.min((page - 1) * pageSize, totalRoles);
        int toIndex = Math.min(fromIndex + pageSize, totalRoles);
        List<Role> roleList = totalRoles == 0 ? Collections.emptyList() : roles.subList(fromIndex, toIndex);

        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRoles", totalRoles);
        request.setAttribute("searchText", searchText);
        request.setAttribute("roleList", roleList);

        request.getRequestDispatcher("/views/role/list.jsp").forward(request, response);
    }
}
