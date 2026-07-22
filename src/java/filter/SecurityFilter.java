package filter;

import dal.ContractDAO;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import model.User;
import dal.UserDAO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter(filterName = "SecurityFilter", urlPatterns = {"/*"})
public class SecurityFilter implements Filter {

    private final UserDAO userDAO = new UserDAO();

    private static final int ROLE_SYSTEM_ADMIN = 1;
    private static final int ROLE_MANAGER = 2;
    private static final int ROLE_CUSTOMER = 3;
    private static final int ROLE_SALE_STAFF = 4;
    private static final int ROLE_ADMIN_OFFICER = 5;
    private static final int ROLE_WAREHOUSE_STAFF = 6;

    private static final List<String> MANAGER_URLS = List.of(
            "/dashboard", "/admin-dashboard", "/role-list", "/role-detail", "/user-list", "/user-detail",
            "/create-user", "/customer/list", "/customer-order-list", "/create-order", "/customer-order",
            "/AcceptanceRecordController", "/product-list", "/edit-product", "/product-delete",
            "/product-review", "/contract-list", "/contract-detail", "/export-pdf", "/File",
            "/Signature", "/invoice-list", "/invoice/create", "/invoice", "/preview",
            "/payment/list", "/payment", "/payment/return", "/payment/ipn", "/payment/detail",
            "/revenue-report", "/revenue","/import-request-create", "/import-request-list", "/import-request-detail"
    );

    private static final List<String> CUSTOMER_URLS = List.of(
            "/dashboard", "/customer/dashboard", "/admin-dashboard", "/customer/detail", "/customer/edit", "/customer-order-list",
            "/customer-order", "/AcceptanceRecordController", "/category/list", "/product-list",
            "/quotation-list", "/quotation-detail", "/contract-list", "/contract-detail", "/export-pdf", "/File",
            "/Signature", "/invoice-list", "/invoice", "/preview", "/payment/list", "/payment",
            "/payment/return", "/payment/ipn", "/payment/detail"
    );

    private static final List<String> SALE_STAFF_URLS = List.of(
            "/dashboard", "/admin-dashboard", "/customer/list", "/customer/create", "/customer/detail", "/customer/edit",
            "/customer-order-list", "/create-order", "/customer-order", "/AcceptanceRecordController", "/category/list",
            "/category/create", "/category/edit", "/category/delete", "/product-list", "/edit-product",
            "/product-delete", "/product-review", "/quotation-list", "/quotation-create", "/quotation-detail",
            "/invoice/create", "/invoice", "/preview", "/payment/list", "/payment", "/payment/return",
            "/payment/ipn", "/payment/detail", "/import-request-list", "/import-request-detail","/import-request-create"
    );

    private static final List<String> ADMIN_OFFICER_URLS = List.of(
            "/dashboard", "/admin-dashboard", "/customer/list", "/customer/detail", "/customer-order-list", "/create-order",
            "/customer-order", "/AcceptanceRecordController", "/product-review", "/quotation-list",
            "/quotation-detail", "/contract-list", "/contract-create", "/contract-save", "/contract-detail",
            "/export-pdf", "/File", "/invoice-list", "/invoice/create", "/invoice", "/preview",
            "/payment/list", "/payment", "/payment/return", "/payment/ipn", "/payment/detail", "/import-request-create", "/import-request-list"
    );

    private static final List<String> WAREHOUSE_STAFF_URLS = List.of(
            "/dashboard", "/admin-dashboard", "/customer-order-list", "/customer-order", "/AcceptanceRecordController",
            "/category/list", "/category/create", "/category/edit", "/category/delete", "/product-list",
            "/create-product", "/edit-product", "/product-delete", "/product-review", "/contract-list",
            "/import-request-list", "/import-request-create", "/import-request-detail", "/warehouse-dashboard"
    );

    private static final List<String> PUBLIC_URLS = List.of(
            "/login",
            "/logout",
            "/register",
            "/auth/forgot",
            "/user/password/change",
            "/payment/ipn",
            "/payment/return"
    );

    private static final List<String> LOGGED_IN_URLS = List.of(
            "/user/password/change",
            "/realtime/notifications",
            "/File",
            "/tool/auto-generate"
    );

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        res.setHeader("Pragma", "no-cache");
        res.setDateHeader("Expires", 0);

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user != null) {
            dal.ImportRequestDAO importRequestDAOForCount = new dal.ImportRequestDAO();
            int pendingImportsCount = importRequestDAOForCount.countPendingRequests();
            req.setAttribute("pendingImportsCount", pendingImportsCount);

            if (userDAO.checkBanUser(user)) { //check user banned by admin, if that is true, cannot do anything
                session.invalidate();
                ((HttpServletResponse) response).sendRedirect("login.jsp");
                return;
            }
            if (user.getRoleId() == 1) {
                chain.doFilter(request, response);
                return;
            }
        }

        String path = req.getServletPath();

        if (isStaticResource(path)) {
            chain.doFilter(request, response);
            return;
        }

        if (PUBLIC_URLS.contains(path) || path.equals("/") || path.equals("") || path.equals("/index.jsp")) {
            chain.doFilter(request, response);
            return;
        }

        if ("/contract-detail".equals(path) || "/export-pdf".equals(path)) {
            String token = req.getParameter("token");
            String idStr = req.getParameter("id");
            if (token != null && idStr != null) {
                try {
                    int contractId = Integer.parseInt(idStr);
                    ContractDAO cDAO = new ContractDAO();
                    if (cDAO.validateToken(contractId, token)) {
                        chain.doFilter(request, response);
                        return;
                    }
                } catch (Exception e) {
                    res.sendRedirect(req.getContextPath() + "/login");
                }
            }
        }

        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Check if user has been banned/deactivated (INACTIVE status)
        User dbUser = userDAO.getUserById(user.getUserId());
        if (dbUser == null || "INACTIVE".equalsIgnoreCase(dbUser.getStatus())) {
            if (session != null) {
                session.invalidate();
            }
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if (LOGGED_IN_URLS.contains(path)) {
            chain.doFilter(request, response);
            return;
        }

        if (path.startsWith("/views/")) {
            chain.doFilter(request, response);
            return;
        }

        String cleanPath = path.endsWith("/") && path.length() > 1 ? path.substring(0, path.length() - 1) : path;

        if (hasPermission(user.getRoleId(), cleanPath, req)) {
            chain.doFilter(request, response);
            return;
        } else {
            System.out.println("Access Denied: Role "
                    + user.getRoleId()
                    + " tried to access "
                    + path);
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
    }

    private boolean hasPermission(int roleId, String cleanPath, HttpServletRequest req) {
        if (cleanPath.equals("/edit-user")) {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.trim().isEmpty()) {
                HttpSession session = req.getSession(false);
                User user = session != null ? (model.User) session.getAttribute("user") : null;
                if (user != null && String.valueOf(user.getUserId()).equals(idParam)) {
                    if (roleId != ROLE_CUSTOMER) return true;
                }
            }
        }

        if (cleanPath.equals("/edit-user") && roleId == ROLE_MANAGER) {
            return true;
        }

        switch (roleId) {
            case ROLE_MANAGER: return MANAGER_URLS.contains(cleanPath);
            case ROLE_CUSTOMER: return CUSTOMER_URLS.contains(cleanPath);
            case ROLE_SALE_STAFF: return SALE_STAFF_URLS.contains(cleanPath);
            case ROLE_ADMIN_OFFICER: return ADMIN_OFFICER_URLS.contains(cleanPath);
            case ROLE_WAREHOUSE_STAFF: return WAREHOUSE_STAFF_URLS.contains(cleanPath);
            default: return false;
        }
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