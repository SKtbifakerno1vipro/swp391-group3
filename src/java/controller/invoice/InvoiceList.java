package controller.invoice;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Invoice;
import model.User;
import service.InvoiceService;
import service.ProductService;

@WebServlet(name = "InvoiceList", urlPatterns = {"/invoice-list"})
public class InvoiceList extends HttpServlet {

    private final InvoiceService invoiceService = new InvoiceService();
    private final ProductService productService = new ProductService();
    private final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String errorInvoice = null;
        errorInvoice = (String) session.getAttribute("errorInvoice");
        session.removeAttribute("errorInvoice");

        String searchBuyerName = request.getParameter("searchBuyerName");
        String status = request.getParameter("status");
        String type = request.getParameter("type");
        String startDateRaw = request.getParameter("startDate");
        String endDateRaw = request.getParameter("endDate");

        LocalDateTime startDate = null;
        LocalDateTime endDate = null;
        if (startDateRaw != null && !startDateRaw.trim().isEmpty()) {
            try {
                String sStr = startDateRaw.trim();
                if (sStr.length() == 10) {
                    sStr += "T00:00:00";
                }
                startDate = LocalDateTime.parse(sStr);
            } catch (Exception ignored) {
            }
        }
        if (endDateRaw != null && !endDateRaw.trim().isEmpty()) {
            try {
                String eStr = endDateRaw.trim();
                if (eStr.length() == 10) {
                    eStr += "T23:59:59";
                }
                endDate = LocalDateTime.parse(eStr);
            } catch (Exception ignored) {
            }
        }

        String pageSizeRaw = request.getParameter("pageSize");
        int pageSize = PAGE_SIZE;
        if (pageSizeRaw != null && !pageSizeRaw.trim().isEmpty()) {
            try {
                pageSize = Integer.parseInt(pageSizeRaw.trim());
            } catch (Exception e) {
            }
        }

        String pageRaw = request.getParameter("page");
        int page = 1;
        if (pageRaw != null && !pageRaw.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageRaw);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        boolean forCustomer = (user.getRoleId() == 3);
        int totalRow = forCustomer
                ? invoiceService.countInvoicesForCustomer(searchBuyerName, status, type, startDate, endDate, user.getUserId())
                : invoiceService.countInvoices(searchBuyerName, status, type, startDate, endDate);
        int totalPage = productService.calculateTotalPage(totalRow, pageSize);
        page = productService.nomalizePage(page, totalPage);

        List<Invoice> list = forCustomer
                ? invoiceService.getInvoicesForCustomer(searchBuyerName, status, type, startDate, endDate, totalRow, page, totalPage, pageSize, user.getUserId())
                : invoiceService.getInvoices(searchBuyerName, status, type, startDate, endDate, totalRow, page, totalPage, pageSize);

        request.setAttribute("invoices", list);
        request.setAttribute("errorInvoice", errorInvoice);
        request.setAttribute("page", page);
        request.setAttribute("totalPage", totalPage);
        request.setAttribute("totalRow", totalRow);

        request.setAttribute("searchBuyerName", searchBuyerName);
        request.setAttribute("status", status);
        request.setAttribute("type", type);
        request.setAttribute("startDate", startDateRaw);
        request.setAttribute("endDate", endDateRaw);
        request.setAttribute("pageSize", pageSize);

        request.getRequestDispatcher("/views/invoice/list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (user.getRoleId() == 3) {
            session.setAttribute("errorInvoice", "Quý khách không có tính năng này");
            response.sendRedirect(request.getContextPath() + "/invoice-list");
            return;
        }
        String action = request.getParameter("action");
        if ("cancel".equals(action)) {
            String invoiceIdRaw = request.getParameter("invoiceId");
            if (invoiceIdRaw != null && !invoiceIdRaw.trim().isEmpty()) {
                try {
                    int invoiceId = Integer.parseInt(invoiceIdRaw);
                    Invoice iv = invoiceService.getInvoiceById(invoiceId);

                    if ("CANCELED".equals(iv.getInvoiceStatus())) {
                        session.setAttribute("errorInvoice", "Hóa đơn này đã bị hủy trước đó.");
                    } else if ("RELEASED".equals(iv.getInvoiceStatus())) {
                        session.setAttribute("errorInvoice", "Hóa đơn đã phát hành, không thể hủy!");
                    } else {
                        invoiceService.updateInvoiceStatus(invoiceId, "CANCELED");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        response.sendRedirect(request.getContextPath() + "/invoice-list");
    }
}
