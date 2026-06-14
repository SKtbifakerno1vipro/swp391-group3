package controller.quotation;

import dto.CustomerDTO;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;
import model.Quotation;
import model.QuotationDetail;
import service.QuotationService;

@WebServlet(name = "CreateQuotationController", urlPatterns = {"/quotation-create"})
public class CreateQuotationController extends HttpServlet {

    @Override
    // Má»Ÿ trang form táº¡o quotation -> browser gá»i GET /quotation-create
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        QuotationService quotationService = new QuotationService();

        // Láº¥y dá»¯ liá»‡u tá»« service Ä‘á»ƒ Ä‘á»• vÃ o dropdown
        List<CustomerDTO> customers = quotationService.getAllCustomers();
        List<Product> products = quotationService.getAllProducts();

        // Gá»­i dá»¯ liá»‡u sang JSP
        request.setAttribute("customers", customers);
        request.setAttribute("products", products);

        request.getRequestDispatcher("/views/quotation/create.jsp").forward(request, response);
    }

    @Override
    // Nháº­n dá»¯ liá»‡u khi user báº¥m nÃºt submit form
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Láº¥y dá»¯ liá»‡u tá»« form. request.getParameter luÃ´n tráº£ vá» String.
            String customerIdRaw = request.getParameter("customerId");
            String productIdRaw = request.getParameter("productId");
            String quantityRaw = request.getParameter("quantity");
            String sellingPriceRaw = request.getParameter("sellingPrice");
            String discountPercentRaw = request.getParameter("discountPercent");
            String taxPercentRaw = request.getParameter("taxPercent");

            // Chuyá»ƒn String sang int
            int customerId = Integer.parseInt(customerIdRaw);
            int productId = Integer.parseInt(productIdRaw);
            int quantity = Integer.parseInt(quantityRaw);

            // Chuyá»ƒn String sang BigDecimal vÃ¬ Ä‘Ã¢y lÃ  tiá»n/pháº§n trÄƒm
            BigDecimal sellingPrice = new BigDecimal(sellingPriceRaw);
            BigDecimal discountPercent = new BigDecimal(discountPercentRaw);
            BigDecimal taxPercent = new BigDecimal(taxPercentRaw);

            // Táº¡o object Ä‘á»ƒ lÆ°u báº£ng quotation
            Quotation quotation = new Quotation();
            quotation.setCustomerId(customerId);
            quotation.setQuotationDate(LocalDateTime.now());
            quotation.setQuotationStatus("DRAFT");

            // Táº¡m thá»i Ä‘á»ƒ lÃ  1. Sau nÃ y ná»‘i login/session thÃ¬ láº¥y userId tá»« session.
            quotation.setCreatedBy(1);

            // Táº¡o object Ä‘á»ƒ lÆ°u báº£ng quotation_detail
            QuotationDetail detail = new QuotationDetail();
            detail.setProductId(productId);
            detail.setQuantity(quantity);
            detail.setSellingPrice(sellingPrice);
            detail.setDiscountPercent(discountPercent);
            detail.setTaxPercent(taxPercent);

            // Gá»i service Ä‘á»ƒ xá»­ lÃ½ logic táº¡o quotation + detail
            QuotationService quotationService = new QuotationService();
            boolean success = quotationService.createQuotation(quotation, detail);

            if (success) {
                // ThÃ nh cÃ´ng thÃ¬ quay vá» trang danh sÃ¡ch
                response.sendRedirect("quotation-list");
            } else {
                // Tháº¥t báº¡i thÃ¬ quay láº¡i form vÃ  bÃ¡o lá»—i
                request.setAttribute("error", "Create quotation failed.");
                doGet(request, response);
            }

        } catch (Exception e) {
            // Náº¿u parse dá»¯ liá»‡u lá»—i hoáº·c thiáº¿u dá»¯ liá»‡u
            request.setAttribute("error", "Invalid input data.");
            doGet(request, response);
        }
    }
}