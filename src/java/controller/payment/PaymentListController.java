package controller.payment;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import model.Invoice;

import model.Payment;
import model.User;
import service.InvoiceService;
import service.PaymentService;

@WebServlet(name = "PaymentListController", urlPatterns = {"/payment/list"})
public class PaymentListController extends HttpServlet {

    private final PaymentService paymentService = new PaymentService();
    private final InvoiceService invoiceService = new InvoiceService();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Parse search & pagination params
        String customerName = request.getParameter("customerName");
        String contractNumber = request.getParameter("contractNumber");
        String status = request.getParameter("status");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        
        String minAmountRaw = request.getParameter("minAmount");
        BigDecimal minAmount = null;
        if (minAmountRaw != null && !minAmountRaw.isBlank()) {
            try {
                minAmount = new BigDecimal(minAmountRaw.trim());
            } catch (Exception e) {}
        }

        String maxAmountRaw = request.getParameter("maxAmount");
        BigDecimal maxAmount = null;
        if (maxAmountRaw != null && !maxAmountRaw.isBlank()) {
            try {
                maxAmount = new BigDecimal(maxAmountRaw.trim());
            } catch (Exception e) {}
        }

        String pageRaw = request.getParameter("page");
        int page = 1;
        if (pageRaw != null && !pageRaw.isBlank()) {
            try {
                page = Integer.parseInt(pageRaw.trim());
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        String pageSizeRaw = request.getParameter("pageSize");
        int pageSize = 5;
        if (pageSizeRaw != null && !pageSizeRaw.isBlank()) {
            try {
                pageSize = Integer.parseInt(pageSizeRaw.trim());
                if (pageSize < 1) pageSize = 5;
            } catch (NumberFormatException e) {
                pageSize = 5;
            }
        }

        Integer customerUserId = null;
        if (user.getRoleId() == 3) {
            // Customer - restrict search to their own payments
            customerUserId = user.getUserId();
        }

        List<Payment> list = paymentService.searchPayments(
            customerUserId, customerName, contractNumber, status, startDate, endDate, minAmount, maxAmount, page, pageSize
        );
        int totalRecords = paymentService.getSearchPaymentsCount(
            customerUserId, customerName, contractNumber, status, startDate, endDate, minAmount, maxAmount
        );
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        if (totalPages < 1) {
            totalPages = 1;
        }

        request.setAttribute("list", list);
        if (list != null) {
            for (Payment p : list) {
                Invoice invoice = invoiceService.getInvoiceByContractId(p.getCustomerContractId());
                p.setInvoice(invoice);
            }
        }
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("pageSize", pageSize);

        // Keep values in form inputs
        request.setAttribute("customerName", customerName);
        request.setAttribute("contractNumber", contractNumber);
        request.setAttribute("status", status);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("minAmount", minAmountRaw);
        request.setAttribute("maxAmount", maxAmountRaw);

        request.getRequestDispatcher("/views/payment/payment_list.jsp").forward(request, response);
    }
}