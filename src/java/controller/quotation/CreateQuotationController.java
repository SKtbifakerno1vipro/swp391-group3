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
    // cleaned comment
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        QuotationService quotationService = new QuotationService();

        // cleaned comment
        List<CustomerDTO> customers = quotationService.getAllCustomers();
        List<Product> products = quotationService.getAllProducts();

        // cleaned comment
        request.setAttribute("customers", customers);
        request.setAttribute("products", products);

        request.getRequestDispatcher("/views/quotation/create.jsp").forward(request, response);
    }

    @Override
    // cleaned comment
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // cleaned comment
            String customerIdRaw = request.getParameter("customerId");
            String productIdRaw = request.getParameter("productId");
            String quantityRaw = request.getParameter("quantity");
            String sellingPriceRaw = request.getParameter("sellingPrice");
            String discountPercentRaw = request.getParameter("discountPercent");
            String taxPercentRaw = request.getParameter("taxPercent");

            // cleaned comment
            int customerId = Integer.parseInt(customerIdRaw);
            int productId = Integer.parseInt(productIdRaw);
            int quantity = Integer.parseInt(quantityRaw);

            // cleaned comment
            BigDecimal sellingPrice = new BigDecimal(sellingPriceRaw);
            BigDecimal discountPercent = new BigDecimal(discountPercentRaw);
            BigDecimal taxPercent = new BigDecimal(taxPercentRaw);

            // cleaned comment
            Quotation quotation = new Quotation();
            quotation.setCustomerId(customerId);
            quotation.setQuotationDate(LocalDateTime.now());
            quotation.setQuotationStatus("DRAFT");

            // cleaned comment
            quotation.setCreatedBy(1);

            // cleaned comment
            QuotationDetail detail = new QuotationDetail();
            detail.setProductId(productId);
            detail.setQuantity(quantity);
            detail.setSellingPrice(sellingPrice);
            detail.setDiscountPercent(discountPercent);
            detail.setTaxPercent(taxPercent);

            // cleaned comment
            QuotationService quotationService = new QuotationService();
            boolean success = quotationService.createQuotation(quotation, detail);

            if (success) {
                // cleaned comment
                response.sendRedirect("quotation-list");
            } else {
                // cleaned comment
                request.setAttribute("error", "Create quotation failed.");
                doGet(request, response);
            }

        } catch (Exception e) {
            // cleaned comment
            request.setAttribute("error", "Invalid input data.");
            doGet(request, response);
        }
    }
}