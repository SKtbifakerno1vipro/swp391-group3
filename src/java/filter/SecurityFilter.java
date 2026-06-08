package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

import jakarta.servlet.annotation.WebFilter;

@WebFilter(filterName = "SecurityFilter", urlPatterns = {"/*"})
public class SecurityFilter implements Filter {

    // Khai báo các tập hợp URL để kiểm tra nhanh
// 1. Công cộng: Ai cũng vào được
    private final String[] PUBLIC_PAGE = {
        "login", "logout"};

// 2. Admin (Role 1): Quản lý người dùng và phân quyền hệ thống
    private final String[] ADMIN_PAGE = {
        "user-list", "user-detail", "create-user", "edit-user",
        "role-list", "role-detail", "create-role", "edit-role-permissions",
        "dashboard","quotation-list",
        "customer"
    
    };

// 3. Manager (Role 2): Quản lý danh mục, sản phẩm và phê duyệt
    private final String[] MANAGE_PAGE = {
        "product-list", "product-detail", "create-product", "edit-product",
        "category/", "dashboard"
    };

// 4. Sale (Role 4): Quản lý khách hàng, báo giá và đơn hàng
    private final String[] SALE_PAGE = {
        "customer-list", "customer-detail", "create-customer", "edit-customer",
        "quotation-list", "create-quotation",
        "customer-order-list", "customer-order-detail", "create-customer-order"
    };

// 5. Customer (Role 3): Xem thông tin cá nhân và đơn hàng của chính mình
    private final String[] CUSTOMER_PAGE = {
        "customer-order-list", "customer-order-detail"
    };

// 6. Officier Admin (Role 5): Các công việc hành chính (bổ sung sau)
    private final String[] OFFICIER_PAGE = {
        "dashboard"
    };

// 7. Warehouse (Role 6): Quản lý kho, nhập xuất
    private final String[] WAREHOUSE_PAGE = {
        "product-list", "inventory"
    };

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String url = req.getRequestURI();

        // 1. Kiểm tra tài nguyên tĩnh (CSS, JS, Images) - CỰC KỲ QUAN TRỌNG
        if (url.contains("/css/") || url.contains("/js/") || url.contains("/images/") || url.contains("/assets/")) {
            chain.doFilter(request, response);
            return;
        }

        // 2. Kiểm tra trang công cộng
        boolean isAllowed = false;
        for (String page : PUBLIC_PAGE) {
            if (url.contains(page)) {
                isAllowed = true;
                break;
            }
        }

        // Nếu truy cập trang gốc "/" thì cũng coi là hợp lệ hoặc cho qua để Controller xử lý
        if (url.equals(req.getContextPath() + "/") || url.equals(req.getContextPath())) {
            isAllowed = true;
        }

        if (!isAllowed) {
            HttpSession session = req.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;

            if (user != null) {
                int roleId = user.getRoleId();
                String[] allowPages = {};

                // Phân loại mảng theo Role
                if (roleId == 1) {
                    allowPages = ADMIN_PAGE;
                } else if (roleId == 2) {
                    allowPages = MANAGE_PAGE;
                } else if (roleId == 3) {
                    allowPages = CUSTOMER_PAGE;
                } else if (roleId == 4) {
                    allowPages = SALE_PAGE;
                } else if (roleId == 5) {
                    allowPages = OFFICIER_PAGE;
                } else if (roleId == 6) {
                    allowPages = WAREHOUSE_PAGE;
                }

                // FIX LỖI: Kiểm tra URL thực tế có chứa từ khóa trong mảng không
                for (String page : allowPages) {
                    if (url.contains(page)) {
                        isAllowed = true;
                        break;
                    }
                }
            } else {
                // Nếu chưa đăng nhập mà vào trang cấm -> Đẩy về Login (để tránh loop trang chủ)
                res.sendRedirect(req.getContextPath() + "/login");
                return;
            }
        }

        // 3. Kết luận
        if (isAllowed) {
            chain.doFilter(request, response);
        } else {
            // Đã đăng nhập nhưng không có quyền -> Đẩy về trang báo lỗi hoặc trang chủ kèm thông báo
            req.setAttribute("error", "Bạn không có quyền truy cập chức năng này!");
            // Chuyển hướng về trang login hoặc một trang "Access Denied" cụ thể
            res.sendRedirect(req.getContextPath() + "/login");
        }
    }
}
