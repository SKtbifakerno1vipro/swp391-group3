package controller.role;





import service.RoleService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet(name = "AddRoleController", urlPatterns = {"/add-role"})
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
                request.setAttribute("error", "TÃƒÂªn nhÃƒÂ³m quyÃ¡Â»Ân khÃƒÂ´ng Ã„â€˜Ã†Â°Ã¡Â»Â£c Ã„â€˜Ã¡Â»Æ’ trÃ¡Â»â€˜ng!");
                request.getRequestDispatcher("/views/role/add-role.jsp").forward(request, response);
                return;
            }

            boolean isSuccess = roleService.insertRole(roleName.trim());

            if (isSuccess) {
                response.sendRedirect(request.getContextPath() + "/role-list?status=add_success");
            } else {
                request.setAttribute("error", "ThÃƒÂªm mÃ¡Â»â€ºi thÃ¡ÂºÂ¥t bÃ¡ÂºÂ¡i! Vui lÃƒÂ²ng thÃ¡Â»Â­ lÃ¡ÂºÂ¡i.");
                request.getRequestDispatcher("/views/role/add-role.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "LÃ¡Â»â€”i hÃ¡Â»â€¡ thÃ¡Â»â€˜ng khi thÃƒÂªm Role!");
        }
    }
}




