package controller.dashboard;

import dal.DashboardDAO;
import dto.ProductSalesItemDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ProductSalesReportController", urlPatterns = {"/product-sales-report"})
public class ProductSalesReportController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Filter parameters
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        Integer staffId = null;
        String staffIdStr = request.getParameter("staffId");
        if (staffIdStr != null && !staffIdStr.trim().isEmpty()) {
            try {
                staffId = Integer.parseInt(staffIdStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        DashboardDAO dao = new DashboardDAO();

        // Get report items
        List<ProductSalesItemDTO> reportList = dao.getProductSalesReport(startDate, endDate, staffId);

        // Compute totals
        double grandTotalRevenue = 0;
        int totalQuantitySold = 0;
        for (ProductSalesItemDTO item : reportList) {
            grandTotalRevenue += item.getAmount();
            totalQuantitySold += item.getQuantity();
        }

        String action = request.getParameter("action");
        if ("export".equalsIgnoreCase(action)) {
            exportToExcel(response, reportList, grandTotalRevenue, totalQuantitySold);
            return;
        }

        // Fetch staff list for filter dropdown
        List<Map<String, Object>> staffList = dao.getAllStaffUsers();
        request.setAttribute("staffList", staffList);

        request.setAttribute("reportList", reportList);
        request.setAttribute("grandTotalRevenue", grandTotalRevenue);
        request.setAttribute("totalQuantitySold", totalQuantitySold);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("staffId", staffId);

        request.getRequestDispatcher("/views/report/product_sales_report.jsp").forward(request, response);
    }

    private void exportToExcel(HttpServletResponse response, List<ProductSalesItemDTO> reportList, double grandTotalRevenue, int totalQuantitySold) throws IOException {
        response.setContentType("application/vnd.ms-excel; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"Bao_Cao_Doanh_So_San_Pham_" + System.currentTimeMillis() + ".xls\"");

        DecimalFormat df = new DecimalFormat("#,##0");

        try (PrintWriter out = response.getWriter()) {
            out.println("\uFEFF"); // UTF-8 BOM
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<meta charset=\"UTF-8\">");
            out.println("<style>");
            out.println("body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }");
            out.println("table { border-collapse: collapse; width: 100%; }");
            out.println("th, td { border: 1px solid #000; padding: 8px 12px; text-align: left; }");
            out.println("th { background-color: #4a7c59; color: #ffffff; font-weight: bold; }");
            out.println(".amount { text-align: right; }");
            out.println(".number { text-align: center; }");
            out.println(".total-row { font-weight: bold; background-color: #f0ece4; }");
            out.println("h2 { color: #2e3230; text-align: center; }");
            out.println("</style>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h2>BÁO CÁO DOANH SỐ SẢN PHẨM</h2>");
            out.println("<table>");
            out.println("<thead>");
            out.println("<tr>");
            out.println("<th>STT</th>");
            out.println("<th>Tên Sản Phẩm</th>");
            out.println("<th class=\"number\">Số Lượng Bán</th>");
            out.println("<th class=\"amount\">Đơn Giá Trung Bình (đ)</th>");
            out.println("<th class=\"amount\">Thành Tiền / Doanh Thu (đ)</th>");
            out.println("</tr>");
            out.println("</thead>");
            out.println("<tbody>");

            int index = 1;
            for (ProductSalesItemDTO item : reportList) {
                out.println("<tr>");
                out.println("<td class=\"number\">" + (index++) + "</td>");
                out.println("<td>" + escapeHtml(item.getProductName()) + "</td>");
                out.println("<td class=\"number\">" + item.getQuantity() + "</td>");
                out.println("<td class=\"amount\">" + df.format(item.getPrice()) + "</td>");
                out.println("<td class=\"amount\">" + df.format(item.getAmount()) + "</td>");
                out.println("</tr>");
            }

            out.println("<tr class=\"total-row\">");
            out.println("<td colspan=\"2\" style=\"text-align: right;\">TỔNG CỘNG:</td>");
            out.println("<td class=\"number\">" + totalQuantitySold + "</td>");
            out.println("<td></td>");
            out.println("<td class=\"amount\">" + df.format(grandTotalRevenue) + " đ</td>");
            out.println("</tr>");

            out.println("</tbody>");
            out.println("</table>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    private String escapeHtml(String text) {
        if (text == null) return "";
        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;");
    }
}
