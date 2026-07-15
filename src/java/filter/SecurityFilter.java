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
import model.Role;
import model.RolePermission;
import dal.RoleDAO;
import dal.UserDAO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter(filterName = "SecurityFilter", urlPatterns = {"/*"})
public class SecurityFilter implements Filter {

    private final RoleDAO roleDAO = new RoleDAO();
    private final UserDAO userDAO = new UserDAO();

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
            "/user/password/change",
            "/payment/ipn",
            "/payment/return"
    );

    private static final List<String> LOGGED_IN_URLS = List.of(
            "/dashboard",
            "/user/password/change",
            "/realtime/notifications"
    );

    private static final List<String> SYSTEM_ADMIN_URLS = List.of(
            "/dashboard",
            "/admin-dashboard",
            "/user-list",
            "/user-detail",
            "/create-user",
            "/edit-user",
            "/role-list",
            "/role-detail",
            "/add-role",
            "/edit-role-permissions",
            "/product-list",
            "/create-product",
            "/edit-product",
            "/product-delete",
            "/email/logs",
            "/quotation-list",
            "/quotation-create",
            "/quotation-detail",
            "/contract-list",
            "/contract-detail",
            "/customer-order-list",
            "/customer-order",
            //nguyenkien
            "/invoice-list",
            "invoice",
            "/preview",
            //nguyenkien
            "/revenue-report",
            "/payment",
            "/payment/list",
            "/payment/detail",
            "/admin/audit-logs"
    );

    private static final List<String> MANAGER_URLS = List.of(
            "/dashboard",
            "/user-list",
            "/user-detail",
            "/role-list",
            "/role-detail",
            "/customer/list",
            "/customer/detail",
            "/customer/create",
            "/customer/edit",
            "/customer-order-list",
            "/customer-order",
            "/product-list",
            "/category/list",
            "/quotation-list",
            "/quotation-detail",
            "/contract-list",
            "/contract-detail",
            //nguyenkien
            "/invoice-list",
            "invoice",
            "/preview",
            //nguyenkien
            "/email/logs",
            "/revenue-report",
            "/Signature",
            "/SignatureAcceptance",
            "/payment",
            "/payment/list",
            "/payment/detail"
    );

    private static final List<String> CUSTOMER_URLS = List.of(
            "/dashboard",
            "/quotation-list",
            "/quotation-detail",
            "/contract-list",
            "/contract-detail",
            "/customer/detail",
            "/customer-order-list",
            //nguyenkien
            "/invoice-list",
            "/invoice",
            "/preview",
            //nguyenkien
            "/customer-order",
            "/payment",
            "/payment/list",
            "/payment/detail",
            "/Signature",
            "/SignatureAcceptance",
            "/customer/edit"
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
            "/customer-order-list",
            "/customer-order",
            "/product-list",
            "/category/list",
            "/revenue-report"
    );

    private static final List<String> ADMIN_OFFICER_URLS = List.of(
            "/dashboard",
            "/edit-user",
            "/user-detail",
            "/contract-list",
            "/contract-detail",
            "/contract-save",
            "/customer-order-list",
            "/customer-order",
            "/quotation-list",
            //nguyenkien
            "/invoice-list",
            "invoice",
            "/preview",
            //nguyenkien
            "/invoice",
            "/payment",
            "/payment/list",
            "/payment/detail"
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

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        res.setHeader("Pragma", "no-cache");
        res.setDateHeader("Expires", 0);

        String path = req.getServletPath();

        if (isStaticResource(path)) {
            chain.doFilter(request, response);
            return;
        }

        if (PUBLIC_URLS.contains(path) || path.equals("/") || path.equals("") || path.equals("/index.jsp")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if ("/contract-detail".equals(path)) {
            String token = req.getParameter("token");
            String idStr = req.getParameter("id");
            if (token != null && idStr != null) {
                try {
                    int contractId = Integer.parseInt(idStr);
                    dal.ContractDAO cDAO = new dal.ContractDAO();
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

        if (hasPermission(user.getRoleId(), path, req)) {
            chain.doFilter(request, response);
            return;
        } else {
            System.out.println("Access Denied: Role "
                    + user.getRoleId()
                    + " tried to access "
                    + path);

            res.sendRedirect(req.getContextPath()
                    + "/dashboard?error=denied");
            return;
        }
    }

    private boolean hasPermission(int roleId, String path, HttpServletRequest req) {
        String cleanPath = path.endsWith("/") && path.length() > 1 ? path.substring(0, path.length() - 1) : path;
        System.out.println("Checking permission for role " + roleId + " on path " + cleanPath);

        // Check if the path is explicitly allowed by the hardcoded fallback lists first
        if (roleId == ROLE_SYSTEM_ADMIN && SYSTEM_ADMIN_URLS.contains(cleanPath)) {
            return true;
        }
        if (roleId == ROLE_MANAGER && MANAGER_URLS.contains(cleanPath)) {
            return true;
        }
        if (roleId == ROLE_CUSTOMER && CUSTOMER_URLS.contains(cleanPath)) {
            return true;
        }
        if (roleId == ROLE_SALE_STAFF && SALE_STAFF_URLS.contains(cleanPath)) {
            return true;
        }
        if (roleId == ROLE_ADMIN_OFFICER && ADMIN_OFFICER_URLS.contains(cleanPath)) {
            return true;
        }
        if (roleId == ROLE_WAREHOUSE_STAFF && WAREHOUSE_STAFF_URLS.contains(cleanPath)) {
            return true;
        }

        String requiredPermission = getRequiredPermission(cleanPath, req);
        if (requiredPermission != null) {
            Role role = roleDAO.getRoleDetail(roleId);
            if (role != null && role.getPermissions() != null) {
                for (RolePermission p : role.getPermissions()) {
                    if (p.getPermissionName() != null && p.getPermissionName().equalsIgnoreCase(requiredPermission)) {
                        System.out.println("Role " + roleId + " HAS database permission: " + requiredPermission);
                        return true;
                    }
                }
                System.out.println("Role " + roleId + " DOES NOT HAVE database permission: " + requiredPermission);
                return false;
            }
        }

        return false;
    }

    private String getRequiredPermission(String path, HttpServletRequest req) {
        String cleanPath = path.endsWith("/") && path.length() > 1 ? path.substring(0, path.length() - 1) : path;
        switch (cleanPath) {
            case "/dashboard":
                return "View Dashboard";
            case "/revenue-report":
                return "View Dashboard";
            case "/user-list":
                return "View User List";
            case "/edit-user":
                String idParam = req.getParameter("id");
                if (idParam == null || idParam.trim().isEmpty()) {
                    return "Create User";
                } else {
                    if ("POST".equalsIgnoreCase(req.getMethod())) {
                        return "Edit User";
                    } else {
                        return "View User Detail";
                    }
                }
            case "/user-detail":
                return "View User Detail";
            case "/create-user":
                return "Create User";
            case "/role-list":
                return "View Role List";
            case "/role-detail":
                return "View Role Detail";
            case "/add-role":
                return "Add Role";
            case "/edit-role-permissions":
                return "Edit Role Permissions";
            case "/category/list":
                return "View Category List";
            case "/category/create":
                return "Create Category";
            case "/category/edit":
                return "Edit Category";
            case "/category/delete":
                return "Delete Category";
            case "/product-list":
                return "View Product List";
            case "/create-product":
                return "Create Product";
            case "/edit-product":
                return "Edit Product";
            case "/product-delete":
                return "Delete Product";
            case "/customer/list":
            case "/customer-list":
                return "View Customer List";
            case "/customer/detail":
            case "/customer-detail":
                return "View Customer Detail";
            case "/customer/create":
                return "Create Customer";
            case "/customer/edit":
                return "Edit Customer";
            case "/quotation-list":
                return "View Quotation List";
            case "/quotation-create":
                return "Create Quotation";
            case "/quotation-detail":
                return "View Quotation Detail";
            case "/contract-list":
                return "View Contract List";
            case "/contract-detail":
                return "View Contract List";
            case "/contract-save":
                return "Save Contract";
            case "/export-pdf":
                return "View Contract List";
            case "/customer-order-list":
                return "View Order List";
            case "/customer-order":
                return "View Order Detail";
            case "/invoice-list":
                return "View Invoice List";
            case "/invoice":
                return "View Invoice Detail";
            case "/preview":
                return "View Invoice Preview";
            default:
                return null;
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
