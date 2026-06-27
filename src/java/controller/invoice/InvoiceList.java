package controller.invoice;

import java.io.IOException;
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

@WebServlet(name="InvoiceList", urlPatterns={"/invoice-list"})
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

        String pageRaw = request.getParameter("page");
        int page = 1;
        if (pageRaw != null && !pageRaw.trim().isEmpty()) {
            try {
                page = Integer.parseInt(pageRaw);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int totalRow = invoiceService.countInvoices();
        int totalPage = productService.calculateTotalPage(totalRow, PAGE_SIZE);
        page = productService.nomalizePage(page, totalPage);

        List<Invoice> list = invoiceService.getInvoices(totalRow, page, totalPage, PAGE_SIZE);

        request.setAttribute("invoices", list);
        request.setAttribute("page", page);
        request.setAttribute("totalPage", totalPage);
        request.setAttribute("totalRow", totalRow);

        request.getRequestDispatcher("/views/invoice/list.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
