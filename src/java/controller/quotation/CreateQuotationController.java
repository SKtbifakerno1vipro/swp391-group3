package controller.quotation;

import dto.CustomerDTO;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
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
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

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
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            // Lay customer cua quotation.
            int customerId = Integer.parseInt(request.getParameter("customerId"));

            QuotationService quotationService = new QuotationService();
            if (quotationService.hasDraftQuotation(customerId)) {
                request.setAttribute("error", "Khách hàng này đã có một báo giá ở trạng thái Nháp (DRAFT).");
                doGet(request, response);
                return;
            }

            /*
             * Cac input san pham co cung name nen dung getParameterValues.
             * Moi mang se chua nhieu gia tri tu nhieu dong san pham.
             */
            String[] productIds = request.getParameterValues("productId");
            String[] quantities = request.getParameterValues("quantity");
            String[] sellingPrices = request.getParameterValues("sellingPrice");
            String[] discountPercents = request.getParameterValues("discountPercent");
            String[] taxPercents = request.getParameterValues("taxPercent");

            if (productIds == null || productIds.length == 0) {
                request.setAttribute("error", "Vui lòng thêm ít nhất một sản phẩm.");
                doGet(request, response);
                return;
            }

            model.User u = (model.User) request.getSession().getAttribute("user");
            if (u == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            int creatorId = u.getUserId();

            // Tao object de luu bang quotation
            Quotation quotation = new Quotation();
            quotation.setCustomerId(customerId);
            quotation.setQuotationDate(LocalDateTime.now());
            quotation.setQuotationStatus("DRAFT");
            quotation.setCreatedBy(creatorId);

            // Tao danh sach detail de luu nhieu dong quotation_detail.
            List<QuotationDetail> details = new ArrayList<>();

            dal.ProductDAO productDAO = new dal.ProductDAO();
            for (int i = 0; i < productIds.length; i++) {
                // Bo qua dong san pham bi rong.
                if (productIds[i] == null || productIds[i].trim().isEmpty()) {
                    continue;
                }

                int productId = Integer.parseInt(productIds[i]);
                Product prod = productDAO.getProductById(productId);
                if (prod == null) {
                    continue;
                }

                int requestedQty = Integer.parseInt(quantities[i]);
                if (requestedQty > prod.getQuantityAvailable()) {
                    request.setAttribute("error", "Sản phẩm '" + prod.getProductName()
                            + "' không đủ số lượng trong kho. (Hiện tại trong kho chỉ còn "
                            + prod.getQuantityAvailable() + " sản phẩm, nhưng bạn yêu cầu "
                            + requestedQty + " sản phẩm).");
                    doGet(request, response);
                    return;
                }

                QuotationDetail detail = new QuotationDetail();
                detail.setProductId(productId);
                detail.setProductName(prod.getProductName());
                detail.setUnit(prod.getUnit());
                detail.setCostPrice(BigDecimal.valueOf(prod.getCostPrice()));
                detail.setSellingPrice(BigDecimal.valueOf(prod.getSellingPrice()));
                detail.setQuantity(requestedQty);
                detail.setDiscountPercent(new BigDecimal(discountPercents[i]));
                detail.setTaxPercent(new BigDecimal(taxPercents[i]));

                details.add(detail);
            }

            if (details.isEmpty()) {
                request.setAttribute("error", "Vui lòng thêm ít nhất một sản phẩm hợp lệ.");
                doGet(request, response);
                return;
            }

            // Goi service de xu ly logic tao quotation + nhieu detail
            boolean success = quotationService.createQuotation(quotation, details);

            if (success) {
                service.AuditLogService.log(creatorId, "CREATE", "Quotation", "Tạo báo giá mới (Draft) cho khách hàng ID: " + customerId);
                // Thanh cong thi quay ve trang danh sach
                response.sendRedirect("quotation-list");
            } else {
                // That bai thi quay lai form va bao loi
                request.setAttribute("error", "Tạo báo giá thất bại.");
                doGet(request, response);
            }

        } catch (Exception e) {
            // Neu parse du lieu loi hoac thieu du lieu
            request.setAttribute("error", "Dữ liệu nhập vào không hợp lệ.");
            doGet(request, response);
        }
    }
}