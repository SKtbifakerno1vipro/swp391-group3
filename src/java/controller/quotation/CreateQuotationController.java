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
    // Mo trang form tao quotation -> browser goi GET /quotation-create
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        QuotationService quotationService = new QuotationService();

        // Lay du lieu tu service de do vao dropdown
        List<CustomerDTO> customers = quotationService.getAllCustomers();
        List<Product> products = quotationService.getAllProducts();

        // Gui du lieu sang JSP
        request.setAttribute("customers", customers);
        request.setAttribute("products", products);

        request.getRequestDispatcher("/views/quotation/create.jsp").forward(request, response);
    }

    @Override
    // Nhan du lieu khi user bam nut submit form
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Lay du lieu tu form. request.getParameter luon tra ve String.
            String customerIdRaw = request.getParameter("customerId");
            String productIdRaw = request.getParameter("productId");
            String quantityRaw = request.getParameter("quantity");
            String sellingPriceRaw = request.getParameter("sellingPrice");
            String discountPercentRaw = request.getParameter("discountPercent");
            String taxPercentRaw = request.getParameter("taxPercent");

            // Chuyen String sang int
            int customerId = Integer.parseInt(customerIdRaw);
            int productId = Integer.parseInt(productIdRaw);
            int quantity = Integer.parseInt(quantityRaw);

            // Chuyen String sang BigDecimal vi day la tien/phan tram
            BigDecimal sellingPrice = new BigDecimal(sellingPriceRaw);
            BigDecimal discountPercent = new BigDecimal(discountPercentRaw);
            BigDecimal taxPercent = new BigDecimal(taxPercentRaw);

            // Tao object de luu bang quotation
            Quotation quotation = new Quotation();
            quotation.setCustomerId(customerId);
            quotation.setQuotationDate(LocalDateTime.now());
            quotation.setQuotationStatus("DRAFT");

            // Tam thoi de la 1. Sau nay noi login/session thi lay userId tu session.
            quotation.setCreatedBy(1);

            // Tao object de luu bang quotation_detail
            QuotationDetail detail = new QuotationDetail();
            detail.setProductId(productId);
            detail.setQuantity(quantity);
            detail.setSellingPrice(sellingPrice);
            detail.setDiscountPercent(discountPercent);
            detail.setTaxPercent(taxPercent);

            // Goi service de xu ly logic tao quotation + detail
            QuotationService quotationService = new QuotationService();
            boolean success = quotationService.createQuotation(quotation, detail);

            if (success) {
                // Thanh cong thi quay ve trang danh sach
                response.sendRedirect("quotation-list");
            } else {
                // That bai thi quay lai form va bao loi
                request.setAttribute("error", "Create quotation failed.");
                doGet(request, response);
            }

        } catch (Exception e) {
            // Neu parse du lieu loi hoac thieu du lieu
            request.setAttribute("error", "Invalid input data.");
            doGet(request, response);
        }
    }
}