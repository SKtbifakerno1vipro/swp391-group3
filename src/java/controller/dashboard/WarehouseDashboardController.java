package controller.dashboard;

import service.DashboardService;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "WarehouseDashboardController", urlPatterns = {"/warehouse-dashboard"})
public class WarehouseDashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Chỉ cho phép System Admin (1), Manager (2) và Warehouse Staff (6) vào xem
        if (user.getRoleId() != 1 && user.getRoleId() != 2 && user.getRoleId() != 6) {
            response.sendRedirect(request.getContextPath() + "/dashboard?error=unauthorized");
            return;
        }

        DashboardService DashboardService = new DashboardService();
        request.setAttribute("user", user);

        // 1. Thống kê số lượng yêu cầu nhập kho Pending
        int pendingImports = DashboardService.getPendingImportRequestsCount();
        request.setAttribute("pendingImports", pendingImports);

        // 2. Thống kê số lượng đơn hàng chưa hoàn thành
        int pendingOrders = DashboardService.getPendingOrdersCount();
        request.setAttribute("pendingOrders", pendingOrders);

        // 3. Tổng số sản phẩm
        int totalProducts = DashboardService.getTotalProducts();
        request.setAttribute("totalProducts", totalProducts);

        // 4. Số lượng sản phẩm sắp hết hàng (Low Stock Products)
        int lowStockCount = DashboardService.getLowStockProductsCount();
        request.setAttribute("lowStockCount", lowStockCount);

        // 5. Danh sách sản phẩm sắp hết hàng (Low Stock Products)
        List<Map<String, Object>> lowStockProductsList = DashboardService.getLowStockProductsList();
        request.setAttribute("lowStockProductsList", lowStockProductsList);

        // 6. Danh sách 5 yêu cầu nhập kho Pending mới nhất
        List<Map<String, Object>> pendingImportRequestsList = DashboardService.getPendingImportRequestsList(5);
        request.setAttribute("pendingImportRequestsList", pendingImportRequestsList);

        // 7. Danh sách 5 đơn hàng mới nhất
        List<Map<String, Object>> recentOrdersList = DashboardService.getRecentOrdersList(5);
        request.setAttribute("recentOrdersList", recentOrdersList);

        request.getRequestDispatcher("/views/dashboard/warehouse-dashboard.jsp").forward(request, response);
    }
}
