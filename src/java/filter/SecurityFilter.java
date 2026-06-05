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
//import java.util.HashSet;
//import java.util.Set;
//import model.User;
//
//@WebFilter(filterName = "SecurityFilter", urlPatterns = {"/*"})
//public class SecurityFilter implements Filter {
//
//    // Khai báo các tập hợp URL để kiểm tra nhanh
//    private final Set<String> publicUrls = new HashSet<>();
//    private final Set<String> sysAdminUrls = new HashSet<>();
//    private final Set<String> managerUrls = new HashSet<>();
//    private final Set<String> saleUrls = new HashSet<>();
//    private final Set<String> warehouseUrls = new HashSet<>();
//    private final Set<String> officierAdminUrls = new HashSet<>();
//    private final Set<String> customerUrls = new HashSet<>();
//
//    @Override
//    public void init(FilterConfig filterConfig) throws ServletException {
//        // global
//        publicUrls.add("/login");
//        publicUrls.add("/logout");
//
//        // System admin
//        sysAdminUrls.add("/user-list");
//        sysAdminUrls.add("/user-detail");
//        sysAdminUrls.add("/create-user");
//        sysAdminUrls.add("/edit-user");
//        sysAdminUrls.add("/role-list");
//        sysAdminUrls.add("/dashboard");
//
//        // manager
//        managerUrls.add("/dashboard");
//        managerUrls.add("/product-list");
//        managerUrls.add("/create-product");
//        managerUrls.add("/category-list");
//        managerUrls.add("/approve-quotation");
//
//        // sale
//        saleUrls.add("/customer-list");
//        saleUrls.add("/customer-detail");
//        saleUrls.add("/create-customer");
//        saleUrls.add("/quotation-list");
//        saleUrls.add("/create-quotation");
//
//        // wareshouse
//        warehouseUrls.add("");
//
//        // admin offcier
//        officierAdminUrls.add("");
//
//        //customer
//        customerUrls.add("");
//
//    }
//
//    @Override
//    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
//            throws IOException, ServletException {
//
//        HttpServletRequest req = (HttpServletRequest) request;
//        HttpServletResponse res = (HttpServletResponse) response;
//        String path = req.getServletPath();
//
//        //  (CSS, JS, Images)
//        if (path.contains("/css/") || path.contains("/js/") || path.contains("/assets/") || path.contains("/images/")) {
//            chain.doFilter(request, response);
//            return;
//        }
//
//        //  WHITELIST 
//        if (publicUrls.contains(path)) {
//            chain.doFilter(request, response);
//            return;
//        }
//
//        // AUTHENTICATION
//        HttpSession session = req.getSession(false);
//        User user = (session != null) ? (User) session.getAttribute("user") : null;
//
//        if (user == null) {
//            res.sendRedirect(req.getContextPath() + "/login");
//            return;
//        }
//
//        // AUTHORIZATION
//        int roleId = user.getRoleId();
//
//        // Check permission for Admin
//        if (sysAdminUrls.contains(path) && roleId != 1) {
//            accessDenied(req, res);
//            return;
//        }
//
//        // Check permission for  Manager (admin can do)
//        if (managerUrls.contains(path) && (roleId != 1 && roleId != 2)) {
//            accessDenied(req, res);
//            return;
//        }
//
//        // Check permission for Sales
//        if (saleUrls.contains(path) && (roleId != 4 && roleId != 1 && roleId != 2)) {
//            accessDenied(req, res);
//            return;
//        }
//
//        // Check permission for Warehouse
//        if (warehouseUrls.contains(path) && (roleId != 6 && roleId != 2 && roleId != 1)) {
//            accessDenied(req, res);
//            return;
//        }
//
//        //check permission for Customer
//        if (customerUrls.contains(path) && (roleId != 3 && roleId != 1)) {
//            accessDenied(req, res);
//            return;
//        }
//
//        // if not error then can do next
//        chain.doFilter(request, response);
//    }
//
//    /*
//    this func have task is denied role not have outer permision
//     */
//    private void accessDenied(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
//
//        req.setAttribute("error", "Cảnh báo: Bạn không có quyền truy cập vào chức năng này!");
//        req.getRequestDispatcher("/views/auth/login.jsp").forward(req, res);
//    }
//
//    @Override
//    public void destroy() {
//    }
//}
