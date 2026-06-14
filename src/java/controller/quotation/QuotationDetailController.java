package controller.quotation;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Quotation;
import model.QuotationDetail;
import service.QuotationService;

@WebServlet(name = "QuotationDetailController", urlPatterns = {"/quotation-detail"})
public class QuotationDetailController extends HttpServlet {

    /*
     * doGet chay khi user bam view:
     * /quotation-detail?id=1
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Lay id tu URL. Vi du: /quotation-detail?id=1
            String idRaw = request.getParameter("id");

            // request.getParameter tra ve String nen can parse sang int.
            int quotationId = Integer.parseInt(idRaw);

            QuotationService quotationService = new QuotationService();

            // Lay thong tin chung cua quotation.
            Quotation quotation = quotationService.getQuotationById(quotationId);

            // Lay danh sach san pham cua quotation.
            List<QuotationDetail> details = quotationService.getQuotationDetailsByQuotationId(quotationId);

            // Neu khong tim thay quotation thi quay ve list.
            if (quotation == null) {
                response.sendRedirect(request.getContextPath() + "/quotation-list");
                return;
            }

            // Gui du lieu sang JSP.
            request.setAttribute("quotation", quotation);
            request.setAttribute("details", details);

            // Forward sang trang detail.
            request.getRequestDispatcher("/views/quotation/detail.jsp").forward(request, response);

        } catch (Exception e) {
            // Neu id bi thieu hoac sai format thi quay ve list.
            response.sendRedirect(request.getContextPath() + "/quotation-list");
        }
    }
}