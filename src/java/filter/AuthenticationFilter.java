//package filter;
//
//import jakarta.servlet.Filter;
//import jakarta.servlet.FilterChain;
//import jakarta.servlet.FilterConfig;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.ServletRequest;
//import jakarta.servlet.ServletResponse;
//import jakarta.servlet.annotation.WebFilter;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//import java.io.IOException;
//
//@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {"/*"})
//public class AuthenticationFilter implements Filter {
//
//    @Override
//    public void init(FilterConfig filterConfig) throws ServletException {
//        // Initialization if needed
//    }
//
//    @Override
//    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
//            throws IOException, ServletException {
//
//        HttpServletRequest req = (HttpServletRequest) request;
//        HttpServletResponse res = (HttpServletResponse) response;
//        HttpSession session = req.getSession(false);
//
//        String loginURI = req.getContextPath() + "/login";
//        String forgotPassURI = req.getContextPath() + "/user/password/forgot";
//
//        // Check if user is trying to access static resources
//        boolean isStaticResource = req.getRequestURI().matches(".*(css|jpg|png|gif|js)");
//
//        // Check if user is logged in
//        boolean loggedIn = session != null && session.getAttribute("user") != null;
//        boolean loginRequest = req.getRequestURI().equals(loginURI);
//        boolean forgotPassRequest = req.getRequestURI().equals(forgotPassURI);
//
//        if (loggedIn || loginRequest || forgotPassRequest || isStaticResource) {
//            // Allow the request to pass
//            chain.doFilter(request, response);
//        } else {
//            // Redirect to login page
//            res.sendRedirect(loginURI);
//        }
//    }
//
//    @Override
//    public void destroy() {
//        // Cleanup if needed
//    }
//}