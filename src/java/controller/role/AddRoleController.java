package controller.role;

import dal.RoleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "AddRoleController", urlPatterns = {"/add-role"})
public class AddRoleController extends HttpServlet {

    private RoleDAO roleDAO;

    @Override
    public void init() {
        roleDAO = new RoleDAO();
    }

    // 1. Khi user báº¥m vÃ o nÃºt "ThÃªm má»›i" tá»« trang danh sÃ¡ch, hiá»ƒn thá»‹ form nháº­p
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/add-role.jsp").forward(request, response);
    }

    // 2. Khi user Ä‘iá»n tÃªn Role xong báº¥m nÃºt submit "ThÃªm má»›i" trÃªn Form
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            String roleName = request.getParameter("roleName");

            // Kiá»ƒm tra dá»¯ liá»‡u Ä‘áº§u vÃ o rá»—ng
            if (roleName == null || roleName.trim().isEmpty()) {
                request.setAttribute("error", "TÃªn nhÃ³m quyá»n khÃ´ng Ä‘Æ°á»£c Ä‘á»ƒ trá»‘ng!");
                request.getRequestDispatcher("/add-role.jsp").forward(request, response);
                return;
            }

            // Gá»i DAO xá»­ lÃ½ insert vÃ o cÆ¡ sá»Ÿ dá»¯ liá»‡u
            boolean isSuccess = roleDAO.insertRole(roleName.trim());

            if (isSuccess) {
                // ThÃ nh cÃ´ng thÃ¬ chuyá»ƒn hÆ°á»›ng vá» láº¡i trang danh sÃ¡ch nhÃ³m quyá»n
                response.sendRedirect(request.getContextPath() + "/role-list?status=add_success");
            } else {
                request.setAttribute("error", "ThÃªm má»›i tháº¥t báº¡i! Vui lÃ²ng thá»­ láº¡i.");
                request.getRequestDispatcher("/add-role.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lá»—i há»‡ thá»‘ng khi thÃªm Role!");
        }
    }
}