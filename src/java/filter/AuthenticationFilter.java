package filter;

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

@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {"/*"})
public class AuthenticationFilter implements Filter {

    private static final List<String> PUBLIC_URLS = List.of(
            "/login",
            "/logout",
            "/register",
            "/reset-password",
            "/user/password/forgot"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        
        // Fix character encoding/font issues for all requests and responses
        req.setCharacterEncoding("UTF-8");
        res.setCharacterEncoding("UTF-8");
        
        String path = req.getServletPath();
        HttpSession session = req.getSession(false);

        // Check if user is trying to access static resources
        boolean isStaticResource = path.startsWith("/assets/")
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
        
        // Check if user is logged in
        boolean loggedIn = session != null && session.getAttribute("user") != null;
        boolean isPublicUrl = PUBLIC_URLS.contains(path) || path.equals("/") || path.equals("");

        if (loggedIn || isPublicUrl || isStaticResource) {
            // Allow the request to pass
            chain.doFilter(request, response);
        } else {
            // Redirect to login page
            res.sendRedirect(req.getContextPath() + "/login");
        }
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}