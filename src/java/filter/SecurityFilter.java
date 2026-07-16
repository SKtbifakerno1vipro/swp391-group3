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
            "/payment/return",
            "/export-pdf"
    );

    private static final List<String> LOGGED_IN_URLS = List.of(
            "/dashboard",
            "/user/password/change",
            "/realtime/notifications"
    );

    private static final List<String> SYSTEM_ADMIN_URLS = List.of(
            "/dashboard",
            "/admin-dashboard",
            "/role-list", "/role-detail",
            "/add-role",
            "/edit-role-permissions",
            "/user-list",
            "/create-user",
            "/edit-user",
            "/edit-user",
            "/user-detail",
            "/customer/list",
            "/customer-list",
            "/customer/create",
            "/customer/detail",
            "/customer-detail",
            "/customer/edit",
            "/customer-order-list",
            "/customer-order",
            "/create-order",
            "/category/list",
            "/category/create",
            "/category/edit",
            "/category/delete",
            "/product-list",
            "/create-product",
            "/edit-product",
            "/product-delete",
            "/quotation-list",
            "/quotation-create",
            "/quotation-detail",
            "/contract-list",
            "/contract-save",
            "/contract-create",
            "/contract-detail",
            "/invoice-list",
            "/invoice",
            "/preview",
            "/invoice/create",
            "/payment/list",
            "/payment",
            "/payment/detail",
            "/email/logs",
            "/admin/audit-logs",
            "/revenue-report",
            "/Signature",
            "/SignatureAcceptance",
            "/realtime/notifications",
            "/export-pdf"
    );

    private static final List<String> MANAGER_URLS = List.of(
            "/dashboard",
            "/role-list",
            "/role-detail",
            "/user-list",
            "/edit-user",
            "/customer/list",
            "/customer-list",
            "/customer-order-list",
            "/customer-order",
            "/create-order",
            "/product-list",
            "/edit-product",
            "/product-delete",
            "/contract-list",
            "/contract-detail",
            "/invoice-list",
            "/invoice",
            "/preview",
            "/payment/list",
            "/payment",
            "/payment/detail",
            "/revenue-report",
            "/Signature",
            "/SignatureAcceptance",
            "/realtime/notifications",
            "/export-pdf"
    );

    private static final List<String> CUSTOMER_URLS = List.of(
            "/dashboard",
            "/customer/detail",
            "/customer-detail",
            "/customer/edit",
            "/customer-order-list",
            "/customer-order",
            "/category/list",
            "/category/create",
            "/category/edit",
            "/category/delete",
            "/product-list",
            "/quotation-list",
            "/quotation-detail",
            "/contract-list",
            "/contract-detail",
            "/invoice-list",
            "/preview",
            "/payment/list",
            "/payment",
            "/realtime/notifications",
            "/Signature",
            "/SignatureAcceptance",
            "/export-pdf"
    );

    private static final List<String> SALE_STAFF_URLS = List.of(
            "/dashboard",
            "/edit-user",
            "/customer/list",
            "/customer-list",
            "/customer/create",
            "/customer/detail",
            "/customer-detail",
            "/customer/edit",
            "/customer-order-list",
            "/customer-order",
            "/create-order",
            "/category/list",
            "/category/create",
            "/category/edit",
            "/category/delete",
            "/product-list",
            "/edit-product",
            "/product-delete",
            "/quotation-list",
            "/quotation-create",
            "/quotation-detail",
            "/payment/list",
            "/payment",
            "/payment/detail",
            "/realtime/notifications",
            "/export-pdf"
    );

    private static final List<String> ADMIN_OFFICER_URLS = List.of(
            "/dashboard",
            "/edit-user",
            "/customer/list",
            "/customer-list",
            "/customer/detail",
            "/customer-detail",
            "/customer/edit",
            "/customer-order-list",
            "/customer-order",
            "/create-order",
            "/quotation-list",
            "/quotation-detail",
            "/contract-list",
            "/contract-save",
            "/contract-create",
            "/contract-detail",
            "/invoice-list",
            "/invoice",
            "/preview",
            "/invoice/create",
            "/payment/list",
            "/payment",
            "/payment/detail",
            "/Signature",
            "/SignatureAcceptance",
            "/realtime/notifications",
            "/export-pdf"
    );

    private static final List<String> WAREHOUSE_STAFF_URLS = List.of(
            "/dashboard",
            "/edit-user",
            "/customer-order-list",
            "/customer-order",
            "/category/list",
            "/category/create",
            "/category/edit",
            "/category/delete",
            "/product-list",
            "/create-product",
            "/edit-product",
            "/product-delete",
            "/realtime/notifications",
            "/export-pdf"
    );

    //
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        chain.doFilter(request, response);
//        HttpServletRequest req = (HttpServletRequest) request;
//        HttpServletResponse res = (HttpServletResponse) response;
//
//        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
//        res.setHeader("Pragma", "no-cache");
//        res.setDateHeader("Expires", 0);
//
//        HttpSession session = req.getSession(false);
//        User user = (session != null) ? (User) session.getAttribute("user") : null;
//
//        if (user != null) {
//            if (user.getRoleId() == 1) {
//                chain.doFilter(request, response);
//                return;
//            }
//        }
//
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
//        if ("/contract-detail".equals(path)) {
//            String token = req.getParameter("token");
//            String idStr = req.getParameter("id");
//            if (token != null && idStr != null) {
//                try {
//                    int contractId = Integer.parseInt(idStr);
//                    dal.ContractDAO cDAO = new dal.ContractDAO();
//                    if (cDAO.validateToken(contractId, token)) {
//                        chain.doFilter(request, response);
//                        return;
//                    }
//                } catch (Exception e) {
//                    res.sendRedirect(req.getContextPath() + "/login");
//                }
//            }
//        }
//
//        if (user == null) {
//            res.sendRedirect(req.getContextPath() + "/login");
//            return;
//        }
//
//        // Check if user has been banned/deactivated (INACTIVE status)
//        User dbUser = userDAO.getUserById(user.getUserId());
//        if (dbUser == null || "INACTIVE".equalsIgnoreCase(dbUser.getStatus())) {
//            if (session != null) {
//                session.invalidate();
//            }
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
//        String cleanPath = path.endsWith("/") && path.length() > 1 ? path.substring(0, path.length() - 1) : path;
//        if (getRequiredPermission(cleanPath, req) == null) {
//            res.sendError(HttpServletResponse.SC_NOT_FOUND, "Not Found");
//            return;
//        }
//
//        if (hasPermission(user.getRoleId(), path, req)) {
//            
//            return;
//        } else {
//            System.out.println("Access Denied: Role "
//                    + user.getRoleId()
//                    + " tried to access "
//                    + path);
//
//            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
//            return;
//        }
//    }
//
//    private boolean hasPermission(int roleId, String path, HttpServletRequest req) {
//        String cleanPath = path.endsWith("/") && path.length() > 1 ? path.substring(0, path.length() - 1) : path;
//        System.out.println("Checking permission for role " + roleId + " on path " + cleanPath);
//
//        // Check if the path is explicitly allowed by the hardcoded fallback lists first
//        if (roleId == ROLE_SYSTEM_ADMIN && SYSTEM_ADMIN_URLS.contains(cleanPath)) {
//            return true;
//        }
//        if (roleId == ROLE_MANAGER && MANAGER_URLS.contains(cleanPath)) {
//            return true;
//        }
//        if (roleId == ROLE_CUSTOMER && CUSTOMER_URLS.contains(cleanPath)) {
//            return true;
//        }
//        if (roleId == ROLE_SALE_STAFF && SALE_STAFF_URLS.contains(cleanPath)) {
//            return true;
//        }
//        if (roleId == ROLE_ADMIN_OFFICER && ADMIN_OFFICER_URLS.contains(cleanPath)) {
//            return true;
//        }
//        if (roleId == ROLE_WAREHOUSE_STAFF && WAREHOUSE_STAFF_URLS.contains(cleanPath)) {
//            return true;
//        }
//
//        String requiredPermission = getRequiredPermission(cleanPath, req);
//        if (requiredPermission != null) {
//            Role role = roleDAO.getRoleDetail(roleId);
//            if (role != null && role.getPermissions() != null) {
//                for (RolePermission p : role.getPermissions()) {
//                    if (p.getPermissionName() != null && p.getPermissionName().equalsIgnoreCase(requiredPermission)) {
//                        System.out.println("Role " + roleId + " HAS database permission: " + requiredPermission);
//                        return true;
//                    }
//                }
//                System.out.println("Role " + roleId + " DOES NOT HAVE database permission: " + requiredPermission);
//                return false;
//            }
//        }
//
//        return false;
    }

    private String getRequiredPermission(String path, HttpServletRequest req) {
        String cleanPath = path.endsWith("/") && path.length() > 1 ? path.substring(0, path.length() - 1) : path;
        switch (cleanPath) {
            case "/dashboard":
                return "Dashboard";
            case "/role-list":
            case "/role-detail":
                return "Role List";
            case "/add-role":
            case "/edit-role-permissions":
                return "Edit Role Permission";
            case "/user-list":
                return "User List";
            case "/create-user":
                return "User Create";
            case "/user-detail":
                return "User List";
            case "/edit-user":
                String idParam = req.getParameter("id");
                if (idParam == null || idParam.trim().isEmpty()) {
                    return "User Create";
                } else {
                    jakarta.servlet.http.HttpSession session = req.getSession(false);
                    model.User user = session != null ? (model.User) session.getAttribute("user") : null;
                    if (user != null && String.valueOf(user.getUserId()).equals(idParam)) {
                        return "Profile";
                    }
                    if ("POST".equalsIgnoreCase(req.getMethod())) {
                        return "User Edit";
                    } else {
                        return "User List";
                    }
                }
            case "/customer/list":
            case "/customer-list":
                return "Customer List";
            case "/customer/create":
                return "Customer Create";
            case "/customer/detail":
            case "/customer-detail":
            case "/customer/edit":
                return "Customer Detail";
            case "/customer-order-list":
                return "Order List";
            case "/create-order":
                return "Order Create";
            case "/customer-order":
                return "Order Detail";
            case "/category/list":
                return "Category List";
            case "/category/create":
            case "/category/edit":
            case "/category/delete":
                return "Category edit";
            case "/product-list":
                return "Product List";
            case "/create-product":
                return "Product Create";
            case "/edit-product":
            case "/product-delete":
                return "Product Detail";
            case "/quotation-list":
                return "Quotation List";
            case "/quotation-create":
                return "Create Quotation";
            case "/quotation-detail":
                return "Quotation Detail";
            case "/contract-list":
                return "Contract List";
            case "/contract-create":
            case "/contract-save":
                return "Contract Create";
            case "/contract-detail":
                return "Contract Detail(Edit)";
            case "/invoice-list":
                return "Invoice List";
            case "/invoice/create":
                return "Invoice Create";
            case "/invoice":
                return "Invoice Detail";
            case "/preview":
                return "Preview Invoice";
            case "/payment/list":
            case "/payment":
                return "Payment List";
            case "/payment/detail":
                return "Payment Detail";
            case "/email/logs":
                return "Email Logs";
            case "/admin/audit-logs":
                return "System Audit Logs";
            case "/revenue-report":
                return "Revenue Report";
            case "/Signature":
            case "/SignatureAcceptance":
                return "Acceptance Record";
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
