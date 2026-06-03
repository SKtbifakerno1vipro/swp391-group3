package controller.customer;



import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/customer/password")
public class PasswordController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Kiểm tra xem user đã đăng nhập chưa (ví dụ qua Session)
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            // Nếu chưa đăng nhập, đá về trang login
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        // Nếu đã đăng nhập, forward sang trang JSP
        request.getRequestDispatcher("/views/customer/change_pass.jsp").forward(request, response);
    }

    // Xử lý logic đổi mật khẩu khi user submit form (POST)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Đặt encoding tránh lỗi tiếng Việt nếu cần thông báo
        request.setCharacterEncoding("UTF-8");
        
        // 1. Kiểm tra session đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Lấy thông tin user hiện tại từ session (ví dụ đối tượng User hoặc chuỗi Username)
        // String username = (String) session.getAttribute("currentUser");

        // 2. Lấy dữ liệu từ Request Form
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // 3. Validation Logic
        if (currentPassword == null || currentPassword.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ tất cả các trường!");
            request.getRequestDispatcher("/change-password.jsp").forward(request, response);
            return;
        }

        // Kiểm tra mật khẩu mới và mật khẩu xác nhận có khớp nhau không
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu mới và xác nhận mật khẩu không khớp!");
            request.getRequestDispatcher("/change-password.jsp").forward(request, response);
            return;
        }

        // Kiểm tra mật khẩu mới không được trùng mật khẩu cũ (tùy nghiệp vụ)
        if (currentPassword.equals(newPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu mới không được giống mật khẩu cũ!");
            request.getRequestDispatcher("/change-password.jsp").forward(request, response);
            return;
        }

        // 4. Gọi Service/DAO xử lý dữ liệu (Đoạn này bạn thay bằng logic DB của bạn)
        boolean isCurrentPasswordCorrect = checkOldPasswordInDatabase(currentPassword); 
        
        if (!isCurrentPasswordCorrect) {
            request.setAttribute("errorMessage", "Mật khẩu hiện tại không chính xác!");
            request.getRequestDispatcher("/change-password.jsp").forward(request, response);
            return;
        }

        // Thực hiện cập nhật vào DB
        boolean isUpdateSuccess = updatePasswordInDatabase(newPassword);

        // 5. Trả kết quả về giao diện
        if (isUpdateSuccess) {
            request.setAttribute("successMessage", "Đổi mật khẩu thành công!");
        } else {
            request.setAttribute("errorMessage", "Đã xảy ra lỗi hệ thống. Vui lòng thử lại sau!");
        }

        // Tiếp tục ở lại trang để hiển thị thông báo
        request.getRequestDispatcher("/change-password.jsp").forward(request, response);
    }

    // --- Mock các hàm tương tác DB (Bạn tự thay thế bằng code DAO thực tế) ---
    private boolean checkOldPasswordInDatabase(String oldPassword) {
        // Code kiểm tra mật khẩu cũ trong DB ở đây
        return true; 
    }

    private boolean updatePasswordInDatabase(String newPassword) {
        // Code UPDATE mật khẩu mới vào DB ở đây
        return true;
    }
}