package filter;

import dal.PermissionDAO;
import model.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebFilter(filterName = "SecurityFilter", urlPatterns = {"/*"})
public class SecurityFilter implements Filter {

    // Danh sách các trang ai cũng vào được (không cần đăng nhập)
    private static final List<String> PUBLIC_URLS = List.of(
            "/login", "/logout", "/register", "/forgot-password", "/reset-password"
    );

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String path = req.getServletPath();

        // 1. Cho phép các file tĩnh (CSS, JS, Hình ảnh) đi qua
        if (path.contains(".") && !path.endsWith(".jsp")) {
            chain.doFilter(request, response);
            return;
        }

        // 2. Cho phép các trang Public đi qua
        if (PUBLIC_URLS.contains(path) || path.equals("/") || path.equals("")) {
            chain.doFilter(request, response);
            return;
        }

        // 3. Kiểm tra đăng nhập
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 4. Kiểm tra quyền qua Database
        int roleId = user.getRoleId();
        
        // Trang Dashboard, Profile, Change Password mặc định cho phép khi đã đăng nhập
        if (path.equals("/dashboard") || path.equals("/profile") || path.equals("/change-password")) {
            chain.doFilter(request, response);
            return;
        }

        // Lấy danh sách URL được phép từ Database
        PermissionDAO pDao = new PermissionDAO();
        List<String> allowedUrls = pDao.getPermissionsByRoleId(roleId);

        // Kiểm tra quyền
        if (allowedUrls.contains(path)) {
            chain.doFilter(request, response);
        } else {
            // CÁCH 2: Nếu không có quyền, quay về Dashboard
            res.sendRedirect(req.getContextPath() + "/dashboard");
        }
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}