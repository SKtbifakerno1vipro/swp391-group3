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
            "/user/password/change",
            "/realtime/notifications",
            "/File"
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
            // Đếm số lượng yêu cầu nhập kho Pending để hiển thị ở sidebar
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
        if (getRequiredPermission(cleanPath, req) == null) {
            res.sendError(HttpServletResponse.SC_NOT_FOUND, "Not Found");
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

            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
    }

    private void logDebug(String message) {
        try {
            java.io.File file = new java.io.File("e:/Half 5/SWP391/swp391-group3/build/debug.log");
            java.io.FileWriter fw = new java.io.FileWriter(file, true);
            fw.write(new java.util.Date() + " - " + message + "\n");
            fw.close();
        } catch (Exception e) {
            // ignore
        }
    }

    private boolean hasPermission(int roleId, String path, HttpServletRequest req) {
        // Chuẩn hóa đường dẫn bằng cách bỏ dấu / ở cuối (nếu có)
        String cleanPath = path.endsWith("/") && path.length() > 1 ? path.substring(0, path.length() - 1) : path;
        String requiredPermission = getRequiredPermission(cleanPath, req);
        logDebug("Checking permission for roleId: " + roleId + ", path: " + cleanPath + ", required: " + requiredPermission);

        if (requiredPermission == null) {
            logDebug("Required permission is null for path: " + cleanPath);
            return false;
        }

        // Bước 2: Lấy danh sách quyền hạn từ Session (bộ nhớ đệm) để tránh truy vấn DB nhiều lần
        HttpSession session = req.getSession(false);
        List<RolePermission> permissions = null;
        if (session != null) {
            permissions = (List<RolePermission>) session.getAttribute("userPermissions");
            logDebug("Permissions loaded from session: " + (permissions != null ? permissions.size() : "null"));
        }

        // Bước 3: Nếu trong Session chưa có danh sách quyền, ta mới truy vấn Database để lấy lên
        if (permissions == null) {
            logDebug("Session cache miss. Querying DB for roleId: " + roleId);
            Role role = roleDAO.getRoleDetail(roleId);
            if (role != null) {
                permissions = role.getPermissions();
                logDebug("Role loaded from DB: " + role.getRoleName() + ", permissions size: " + (permissions != null ? permissions.size() : "null"));
                // Lưu vào Session để tái sử dụng ở các request tiếp theo
                if (session != null && permissions != null) {
                    session.setAttribute("userPermissions", permissions);
                }
            } else {
                logDebug("Role loaded from DB is NULL for roleId: " + roleId);
            }
        }

        // Bước 4: So sánh quyền yêu cầu với các quyền mà User này đang sở hữu
        if (permissions != null) {
            for (RolePermission p : permissions) {
                // Nếu tìm thấy quyền trong danh sách trùng khớp với quyền yêu cầu
                if (p.getPermissionName() != null && p.getPermissionName().equalsIgnoreCase(requiredPermission)) {
                    logDebug("Permission MATCHED: " + p.getPermissionName());
                    return true; // Cho phép đi qua
                }
            }
            logDebug("Permission NOT matched. Required was: " + requiredPermission);
        }

        return false; // Không khớp quyền nào, từ chối truy cập
    }

    private String getRequiredPermission(String path, HttpServletRequest req) {
        String cleanPath = path.endsWith("/") && path.length() > 1 ? path.substring(0, path.length() - 1) : path;
        switch (cleanPath) {
            case "/dashboard":
            case "/admin-dashboard":
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
                    HttpSession session = req.getSession(false);
                    User user = session != null ? (model.User) session.getAttribute("user") : null;
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
                return "Customer List";
            case "/customer/create":
                return "Customer Create";
            case "/customer/detail":
                return "Customer Detail";
            case "/customer/edit":
                return "Customer Edit";
            case "/customer-order-list":
                return "Order List";
            case "/create-order":
                return "Order Create";
            case "/customer-order":
            case "/AcceptanceRecordController":
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
            case "/product-review":
                return "Product Review";
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
            case "/export-pdf":
            case "/File":
                return "Contract Detail(Edit)";
            case "/Signature":
                return "Signature Contract";
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
            case "/payment/return":
            case "/payment/ipn":
                return "Payment List";
            case "/payment/detail":
                return "Payment Detail";
            case "/email/logs":
                return "Email Logs";
            case "/admin/audit-logs":
                return "System Audit Logs";
            case "/revenue-report":
            case "/revenue":
                return "Revenue Report";
            case "/warehouse-dashboard":
                return "Warehouse Dashboard";
            case "/import-request-list":
                return "Import Request List";
            case "/import-request-create":
                return "Import Request Create";
            case "/import-request-detail":
                return "Import Request Detail";
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
