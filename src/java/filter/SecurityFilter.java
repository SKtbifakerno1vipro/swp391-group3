package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import java.io.IOException;
import java.util.List;
import model.User;

@WebFilter(filterName = "SecurityFilter", urlPatterns = {"/*"})
public class SecurityFilter implements Filter {

    private static final int ROLE_SYSTEM_ADMIN = 1;
    private static final int ROLE_MANAGER = 2;
    private static final int ROLE_CUSTOMER = 3;
    private static final int ROLE_SALE_STAFF = 4;
    private static final int ROLE_ADMIN_OFFICER = 5;
    private static final int ROLE_WAREHOUSE_STAFF = 6;

    private static final List<String> PUBLIC_URLS = List.of(
            "/login",
            "/logout",
            "/register",
            "/auth/forgot",
            "/forgot-password"
    );

    private static final List<String> LOGGED_IN_URLS = List.of(
            "/dashboard",
            "/user/password/change",
            "/user/password/forgot"
    );

    private static final List<String> SYSTEM_ADMIN_URLS = List.of(
            "/dashboard",
            "/user-list",
            "/user-detail",
            "/create-user",
            "/edit-user",
            "/role-list",
            "/role-detail",
            "/add-role",
            "/edit-role-permissions",
            "/category/list",
            "/category/create",
            "/category/edit",
            "/category/delete",
            "/product-list",
            "/create-product",
            "/edit-product",
            "/product-delete",
            "/customer/list",
            "/customer/detail",
            "/customer/create",
            "/customer/edit",
            "/quotation-list",
            "/quotation-create",
            "/quotation-detail",
            "/contract-list",
            "/contract-detail",
            "/contract-save",
            "/customer-order-list",
            "/customer-order-detail",
            "/create-customer-order",
            "/Invoice",
            "/invoice",
            "/revenue-report"
    );

    private static final List<String> MANAGER_URLS = List.of(
            "/dashboard",
            "/user-list",
            "/user-detail",
            "/role-list",
            "/role-detail",
            "/customer/list",
            "/customer/detail",
            "/customer-order-list",
            "/customer-order-detail",
            "/product-list",
            "/category/list",
            "/quotation-list",
            "/quotation-detail",
            "/contract-list",
            "/contract-detail",
            "/Invoice",
            "/invoice",
            "/revenue-report"
    );

    private static final List<String> CUSTOMER_URLS = List.of(
            "/dashboard",
            "/quotation-detail",
            "/contract-detail"
    );

    private static final List<String> SALE_STAFF_URLS = List.of(
            "/dashboard",
            "/customer/list",
            "/customer/detail",
            "/customer/create",
            "/customer/edit",
            "/quotation-list",
            "/quotation-create",
            "/quotation-detail",
            "/contract-list",
            "/contract-detail",
            "/customer-order-list",
            "/customer-order-detail",
            "/create-customer-order",
            "/product-list",
            "/category/list",
            "/revenue-report"
    );

    private static final List<String> ADMIN_OFFICER_URLS = List.of(
            "/dashboard",
            "/contract-list",
            "/contract-detail",
            "/contract-save",
            "/customer-order-list",
            "/customer-order-detail",
            "/Invoice",
            "/invoice"
    );

    private static final List<String> WAREHOUSE_STAFF_URLS = List.of(
            "/dashboard",
            "/product-list",
            "/create-product",
            "/edit-product",
            "/product-delete",
            "/category/list",
            "/category/create",
            "/category/edit",
            "/category/delete"
    );
//update security bo comment di 

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
//        if (PUBLIC_URLS.contains(path) || path.equals("/") || path.equals("") || path.equals("/index.jsp")) {
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
//        if (LOGGED_IN_URLS.contains(path)) {
//            chain.doFilter(request, response);
//            return;
//        }
//        
//        if (path.startsWith("/views/")) {
//            chain.doFilter(request, response);
//            return;
//        }
//
//        if (hasPermission(user.getRoleId(), path)) {
//            chain.doFilter(request, response);
//        } else {
//            System.out.println("Access Denied: Role " + user.getRoleId() + " tried to access " + path);
//            res.sendRedirect(req.getContextPath() + "/dashboard?error=denied");
//        }
        chain.doFilter(request, response);
    }

    private boolean hasPermission(int roleId, String path) {
        String cleanPath = path.endsWith("/") && path.length() > 1 ? path.substring(0, path.length() - 1) : path;
        System.out.println("Checking permission for role " + roleId + " on path " + cleanPath);
        if (roleId == ROLE_SYSTEM_ADMIN) {
            return SYSTEM_ADMIN_URLS.contains(cleanPath);
        }
        if (roleId == ROLE_MANAGER) {
            return MANAGER_URLS.contains(cleanPath);
        }
        if (roleId == ROLE_CUSTOMER) {
            return CUSTOMER_URLS.contains(cleanPath);
        }
        if (roleId == ROLE_SALE_STAFF) {
            return SALE_STAFF_URLS.contains(cleanPath);
        }
        if (roleId == ROLE_ADMIN_OFFICER) {
            return ADMIN_OFFICER_URLS.contains(cleanPath);
        }
        if (roleId == ROLE_WAREHOUSE_STAFF) {
            return WAREHOUSE_STAFF_URLS.contains(cleanPath);
        }

        return false;
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
