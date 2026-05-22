package controller;

import service.RoleDAO;
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

    // 1. Khi user bấm vào nút "Thêm mới" từ trang danh sách, hiển thị form nhập
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/add-role.jsp").forward(request, response);
    }

    // 2. Khi user điền tên Role xong bấm nút submit "Thêm mới" trên Form
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            String roleName = request.getParameter("roleName");

            // Kiểm tra dữ liệu đầu vào rỗng
            if (roleName == null || roleName.trim().isEmpty()) {
                request.setAttribute("error", "Tên nhóm quyền không được để trống!");
                request.getRequestDispatcher("/add-role.jsp").forward(request, response);
                return;
            }

            // Gọi DAO xử lý insert vào cơ sở dữ liệu
            boolean isSuccess = roleDAO.insertRole(roleName.trim());

            if (isSuccess) {
                // Thành công thì chuyển hướng về lại trang danh sách nhóm quyền
                response.sendRedirect(request.getContextPath() + "/role-list?status=add_success");
            } else {
                request.setAttribute("error", "Thêm mới thất bại! Vui lòng thử lại.");
                request.getRequestDispatcher("/add-role.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống khi thêm Role!");
        }
    }
}