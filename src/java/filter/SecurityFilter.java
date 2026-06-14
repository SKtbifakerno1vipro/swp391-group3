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

    private static final List<String> PUBLIC_URLS = List.of(
            "/login",
            "/logout",
            "/register",
            "/forgot-password",
            "/reset-password",
            "/user/password/forgot"
    );

    private static final List<String> AUTHENTICATED_URLS = List.of(
            "/dashboard",
            "/profile",
            "/user/password/change",
            "/quotation-create",
            "/quotation-detail"
    );

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

//        HttpServletRequest req = (HttpServletRequest) request;
//        HttpServletResponse res = (HttpServletResponse) response;
//        String path = req.getServletPath();
//
//        if (isStaticResource(path)) {
//            chain.doFilter(request, response);
//            return;
//        }
//
//        if (PUBLIC_URLS.contains(path) || path.equals("/") || path.equals("")) {
//            chain.doFilter(request, response);
//            return;
//        }
//
//        HttpSession session = req.getSession(false);
//        User user = (session != null) ? (User) session.getAttribute("user") : null;
//
//        if (user == null) {
//            res.sendRedirect(req.getContextPath() + "/login");
//            return;
//        }
//
//        if (AUTHENTICATED_URLS.contains(path)) {
//            chain.doFilter(request, response);
//            return;
//        }
//
//        PermissionDAO permissionDAO = new PermissionDAO();
//        List<String> allowedUrls = permissionDAO.getPermissionsByRoleId(user.getRoleId());
//
//        if (allowedUrls.contains(path)) {
//            chain.doFilter(request, response);
//        } else {
//            res.sendRedirect(req.getContextPath() + "/dashboard");
//        }
        chain.doFilter(request, response);
    }

    private boolean isStaticResource(String path) {
        return path.startsWith("/assets/")
                || path.startsWith("/css/")
                || path.startsWith("/js/")
                || path.startsWith("/images/")
                || path.startsWith("/fonts/")
                || path.endsWith(".css")
                || path.endsWith(".js")
                || path.endsWith(".png")
                || path.endsWith(".jpg")
                || path.endsWith(".jpeg")
                || path.endsWith(".gif")
                || path.endsWith(".svg")
                || path.endsWith(".ico")
                || path.endsWith(".woff")
                || path.endsWith(".woff2");
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void destroy() {
    }
}
