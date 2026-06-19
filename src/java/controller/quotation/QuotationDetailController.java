package controller.quotation;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Product;
import model.Quotation;
import model.QuotationDetail;
import model.QuotationHistory;
import model.User;
import service.QuotationService;

@WebServlet(name = "QuotationDetailController", urlPatterns = {"/quotation-detail"})
public class QuotationDetailController extends HttpServlet {

    /*
     * doGet chay khi user bam view: /quotation-detail?id=1
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int quotationId = Integer.parseInt(request.getParameter("id"));

            QuotationService quotationService = new QuotationService();

            // Lay thong tin chung, san pham trong quotation, history va list product de add them.
            Quotation quotation = quotationService.getQuotationById(quotationId);
            List<QuotationDetail> details = quotationService.getQuotationDetailsByQuotationId(quotationId);
            List<QuotationHistory> histories = quotationService.getHistoryByQuotationId(quotationId);
            List<Product> products = quotationService.getAllProducts();

            if (quotation == null) {
                response.sendRedirect(request.getContextPath() + "/quotation-list");
                return;
            }

            request.setAttribute("message", request.getParameter("message"));
            request.setAttribute("quotation", quotation);
            request.setAttribute("details", details);
            request.setAttribute("histories", histories);
            request.setAttribute("products", products);
            request.getRequestDispatcher("/views/quotation/detail.jsp").forward(request, response);

        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/quotation-list");
        }
    }

    /*
     * doPost xu ly cac action: update detail, add product, delete product, accept quotation.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        int quotationId = 0;

        try {
            quotationId = Integer.parseInt(request.getParameter("quotationId"));
            QuotationService quotationService = new QuotationService();
            Integer userId = getCurrentUserId(request);

            if ("accept".equals(action)) {
                quotationService.updateStatus(quotationId, "ACCEPTED");
                response.sendRedirect(request.getContextPath() + "/quotation-detail?id=" + quotationId + "&message=accepted");
                return;
            }

            if ("addProduct".equals(action)) {
                QuotationDetail detail = buildDetailFromRequest(request);
                detail.setQuotationId(quotationId);

                boolean success = quotationService.addProductToQuotation(detail, userId);
                response.sendRedirect(request.getContextPath() + "/quotation-detail?id=" + quotationId
                        + (success ? "&message=addSuccess" : "&message=addFailed"));
                return;
            }

            if ("deleteProduct".equals(action)) {
                int quotationDetailId = Integer.parseInt(request.getParameter("quotationDetailId"));

                boolean success = quotationService.deleteProductFromQuotation(quotationId, quotationDetailId, userId);
                response.sendRedirect(request.getContextPath() + "/quotation-detail?id=" + quotationId
                        + (success ? "&message=deleteSuccess" : "&message=deleteFailed"));
                return;
            }

            // Mac dinh la update 1 dong product detail.
            int quotationDetailId = Integer.parseInt(request.getParameter("quotationDetailId"));
            QuotationDetail detail = buildDetailFromRequest(request);
            detail.setQuotationDetailId(quotationDetailId);
            detail.setQuotationId(quotationId);

            boolean success = quotationService.updateQuotationDetail(detail, userId);
            response.sendRedirect(request.getContextPath() + "/quotation-detail?id=" + quotationId
                    + (success ? "&message=saveSuccess" : "&message=saveFailed"));

        } catch (Exception e) {
            if (quotationId > 0) {
                response.sendRedirect(request.getContextPath() + "/quotation-detail?id=" + quotationId + "&message=invalidInput");
            } else {
                response.sendRedirect(request.getContextPath() + "/quotation-list");
            }
        }
    }

    /*
     * Tao QuotationDetail tu cac input trong form.
     */
    private QuotationDetail buildDetailFromRequest(HttpServletRequest request) {
        QuotationDetail detail = new QuotationDetail();
        detail.setProductId(Integer.parseInt(request.getParameter("productId")));
        detail.setQuantity(Integer.parseInt(request.getParameter("quantity")));
        detail.setSellingPrice(new BigDecimal(request.getParameter("sellingPrice")));
        detail.setDiscountPercent(new BigDecimal(request.getParameter("discountPercent")));
        detail.setTaxPercent(new BigDecimal(request.getParameter("taxPercent")));
        return detail;
    }

    /*
     * Lay userId dang dang nhap de ghi history.
     */
    private Integer getCurrentUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        return (user != null) ? user.getUserId() : null;
    }
}