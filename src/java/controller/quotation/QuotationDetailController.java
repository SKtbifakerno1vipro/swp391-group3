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
            // Lay id tu URL.
            int quotationId = Integer.parseInt(request.getParameter("id"));

            QuotationService quotationService = new QuotationService();

            // Lay thong tin chung, chi tiet san pham va lich su cua quotation.
            Quotation quotation = quotationService.getQuotationById(quotationId);
            List<QuotationDetail> details = quotationService.getQuotationDetailsByQuotationId(quotationId);
            List<QuotationHistory> histories = quotationService.getHistoryByQuotationId(quotationId);

            // Neu khong tim thay quotation thi quay ve list.
            if (quotation == null) {
                response.sendRedirect(request.getContextPath() + "/quotation-list");
                return;
            }

            // Nhan message tu redirect sau khi bam Save.
            String message = request.getParameter("message");
            request.setAttribute("message", message);

            // Gui du lieu sang JSP.
            request.setAttribute("quotation", quotation);
            request.setAttribute("details", details);
            request.setAttribute("histories", histories);
            request.getRequestDispatcher("/views/quotation/detail.jsp").forward(request, response);

        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/quotation-list");
        }
    }

    /*
     * doPost chay khi user bam Save tren tung dong san pham hoac bam Accept Quotation
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String quotationIdStr = request.getParameter("quotationId");

        // Xu ly Action: Accept Quotation
        if ("accept".equals(action) && quotationIdStr != null) {
            int qId = Integer.parseInt(quotationIdStr);
            QuotationService service = new QuotationService();
            service.updateStatus(qId, "ACCEPTED");
            response.sendRedirect(request.getContextPath() + "/quotation-detail?id=" + qId + "&message=accepted");
            return;
        }

        // Xu ly Action: Update Quotation Detail
        int quotationId = 0;
        try {
            quotationId = Integer.parseInt(quotationIdStr);
            int quotationDetailId = Integer.parseInt(request.getParameter("quotationDetailId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            BigDecimal sellingPrice = new BigDecimal(request.getParameter("sellingPrice"));
            BigDecimal discountPercent = new BigDecimal(request.getParameter("discountPercent"));
            BigDecimal taxPercent = new BigDecimal(request.getParameter("taxPercent"));

            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;
            Integer userId = (user != null) ? user.getUserId() : null;

            QuotationDetail detail = new QuotationDetail();
            detail.setQuotationDetailId(quotationDetailId);
            detail.setQuotationId(quotationId);
            detail.setQuantity(quantity);
            detail.setSellingPrice(sellingPrice);
            detail.setDiscountPercent(discountPercent);
            detail.setTaxPercent(taxPercent);

            QuotationService quotationService = new QuotationService();
            boolean success = quotationService.updateQuotationDetail(detail, userId);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/quotation-detail?id=" + quotationId + "&message=saveSuccess");
            } else {
                response.sendRedirect(request.getContextPath() + "/quotation-detail?id=" + quotationId + "&message=saveFailed");
            }

        } catch (Exception e) {
            if (quotationId > 0) {
                response.sendRedirect(request.getContextPath() + "/quotation-detail?id=" + quotationId + "&message=invalidInput");
            } else {
                response.sendRedirect(request.getContextPath() + "/quotation-list");
            }
        }
    }
}
