package controller.user;



import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dto.*;
import model.*;
import service.CustomerService;
import service.RoleService;
import service.UserService;

@WebServlet("/user/password")
public class PasswordController extends HttpServlet {
    
    private final CustomerService customerService = new CustomerService();
    private final UserService userService = new UserService();
    private final RoleService roleService = new RoleService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/user/change_pass.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
        // Đặt encoding tránh lỗi hiển thị tiếng Việt trên giao diện
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Lấy thông tin từ session (Ép kiểu thẳng về int)
        int userId = (int) request.getSession().getAttribute("userId"); 

        // Lấy dữ liệu từ Request Form
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // 1. Validation cơ bản ngay tại giao diện/Controller trước
        if (currentPassword == null || currentPassword.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {

            request.setAttribute("error", "Vui lòng nhập đầy đủ tất cả các trường!");
            request.getRequestDispatcher("/views/user/change_pass.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu mới và xác nhận mật khẩu không khớp!");
            request.getRequestDispatcher("/views/user/change_pass.jsp").forward(request, response);
            return;
        }

        // 2. Gọi xuống Service để xử lý và bọc try-catch lỗi kết nối Database
        try {
            // Gọi hàm và lấy về chuỗi thông báo kết quả
            String resultMessage = userService.changePassword(userId, currentPassword, newPassword);

            if (resultMessage == null) {
                // Nếu không có thông báo lỗi nào trả về -> Đổi thành công
                request.setAttribute("success", "Đổi mật khẩu thành công!");
            } else {
                // Nếu có chuỗi trả về -> Đó chính là thông báo lỗi nghiệp vụ
                request.setAttribute("error", resultMessage);
            }

        } catch (Exception e) {
            // Phòng trường hợp lỗi kết nối Database (Lỗi Driver, sập server DB...)
            request.setAttribute("error", "Đã xảy ra lỗi khi kết nối cơ sở dữ liệu!");
            request.setAttribute("errorDetail", e.getMessage());
        }

        // Tiếp tục ở lại trang để hiển thị thông báo lên thẻ c:if trên JSP
        request.getRequestDispatcher("/views/user/change_pass.jsp").forward(request, response);
    }
}