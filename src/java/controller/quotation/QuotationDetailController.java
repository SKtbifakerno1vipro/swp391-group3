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
import service.ProductService;
import service.QuotationService;

@WebServlet(name = "QuotationDetailController", urlPatterns = {"/quotation-detail"})
public class QuotationDetailController extends HttpServlet {
    private final ProductService pService = new ProductService();
    /*
     * doGet chay khi user bam view: /quotation-detail?id=1
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

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
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    /*
     * doPost xu ly cac action: update detail, add product, delete product, accept quotation.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        int quotationId = 0;

        try {
            quotationId = Integer.parseInt(request.getParameter("quotationId"));
            String prodIdStr = request.getParameter("productId");
            int productId = (prodIdStr != null && !prodIdStr.isEmpty()) ? Integer.parseInt(prodIdStr) : 0;
            QuotationService quotationService = new QuotationService();
            Integer userId = getCurrentUserId(request);

            HttpSession session = request.getSession(false);
            User user = (session != null) ? (User) session.getAttribute("user") : null;
            if (user != null && user.getRoleId() == 3) {
                if (!"accept".equals(action)) {
                    response.sendRedirect(request.getContextPath() + "/quotation-detail?id=" + quotationId + "&message=unauthorized");
                    return;
                }
            }

            if ("accept".equals(action)) {
                quotationService.updateStatus(quotationId, "ACCEPTED", userId);
                response.sendRedirect(request.getContextPath() + "/quotation-detail?id=" + quotationId + "&message=accepted");
                return;
            }

            if ("applyAll".equals(action)) {
                BigDecimal discount = new BigDecimal(request.getParameter("discountPercent"));
                BigDecimal tax = new BigDecimal(request.getParameter("taxPercent"));
                
                boolean success = quotationService.applyDiscountAndTaxToAll(quotationId, discount, tax, userId);
                response.sendRedirect(request.getContextPath() + "/quotation-detail?id=" + quotationId 
                        + (success ? "&message=saveSuccess" : "&message=saveFailed"));
                return;
            }

            if ("addProduct".equals(action)) {
                Product prod = pService.getProductById(productId);
                if (prod == null) {
                    response.sendRedirect(request.getContextPath() + "/quotation-detail?id=" + quotationId + "&message=invalidInput");
                    return;
                }

                String qtyParam = request.getParameter("quantity");
                int requestedQty = (qtyParam != null && !qtyParam.isEmpty()) ? Integer.parseInt(qtyParam) : 1;

                int existingQty = 0;
                QuotationDetail oldDetail = quotationService.getQuotationDetailByProduct(quotationId, productId);
                if (oldDetail != null) {
                    existingQty = oldDetail.getQuantity();
                }
                int totalRequest = requestedQty + existingQty;
                int reserveTemp = prod.getQuantityReserve() + requestedQty;
                int difference = prod.getQuantityAvailable() - reserveTemp;
                if (difference < 0 ){
                    int maxAllowed = prod.getQuantityAvailable() - prod.getQuantityReserve();
                    response.sendRedirect(request.getContextPath() + "/quotation-detail?id=" + quotationId
                            + "&message=stockError");
                    return;
                }
                
                QuotationDetail detail = new QuotationDetail();
                detail.setProductId(productId);
                detail.setProductName(prod.getProductName());
                detail.setUnit(prod.getUnit());
                detail.setCostPrice(BigDecimal.valueOf(prod.getCostPrice()));
                detail.setSellingPrice(BigDecimal.valueOf(prod.getSellingPrice()));
                detail.setQuantity(requestedQty);
                
                String discountParam = request.getParameter("discountPercent");
                detail.setDiscountPercent(discountParam != null && !discountParam.isEmpty() ? new BigDecimal(discountParam) : BigDecimal.ZERO);
                
                String taxParam = request.getParameter("taxPercent");
                detail.setTaxPercent(taxParam != null && !taxParam.isEmpty() ? new BigDecimal(taxParam) : BigDecimal.ZERO);
                
                detail.setQuotationId(quotationId);

                boolean success = quotationService.addProductToQuotation(detail, userId);
                if (success) {
                    pService.updateQuantityReserve(prod.getProductId(), reserveTemp);
                }
                response.sendRedirect(request.getContextPath() + "/quotation-detail?id=" + quotationId
                        + (success ? "&message=addSuccess" : "&message=addFailed"));
                return;
            }

            if ("deleteProduct".equals(action)) {
                int quotationDetailId = Integer.parseInt(request.getParameter("quotationDetailId"));
                String productName = request.getParameter("productName");
                Product prod = pService.getProductById(productId);
                if (prod == null) {
                    response.sendRedirect(request.getContextPath() + "/quotation-detail?id=" + quotationId + "&message=invalidInput");
                    return;
                }
                QuotationDetail detail = quotationService.getQuotationDetailByProduct(quotationId, prod.getProductId());
                boolean success = quotationService.deleteProductFromQuotation(quotationId, quotationDetailId, productName, userId);
                if (success && detail != null) {
                    int newReserve = prod.getQuantityReserve() - detail.getQuantity();
                    pService.updateQuantityReserve(productId, newReserve < 0 ? 0 : newReserve);
                }
                response.sendRedirect(request.getContextPath() + "/quotation-detail?id=" + quotationId
                        + (success ? "&message=deleteSuccess" : "&message=deleteFailed"));
                return;
            }

            if ("updateDetail".equals(action)) {
                int quotationDetailId = Integer.parseInt(request.getParameter("quotationDetailId"));
                QuotationDetail detail = buildDetailFromRequest(request);
                detail.setQuotationDetailId(quotationDetailId);
                detail.setQuotationId(quotationId);

                Product prod = pService.getProductById(detail.getProductId());
                if (prod == null) {
                    response.sendRedirect(request.getContextPath() + "/quotation-detail?id=" + quotationId + "&message=invalidInput");
                    return;
                }

                // Check stock delta
                QuotationDetail oldDetail = quotationService.getQuotationDetailByProduct(quotationId, detail.getProductId());
                int oldQty = (oldDetail != null) ? oldDetail.getQuantity() : 0;
                int diff = detail.getQuantity() - oldQty;
                int reserveTemp = prod.getQuantityReserve() + diff;

                if (reserveTemp > prod.getQuantityAvailable()) {
                    int maxAllowed = prod.getQuantityAvailable() - (prod.getQuantityReserve() - oldQty);
                    response.sendRedirect(request.getContextPath() + "/quotation-detail?id=" + quotationId
                            + "&message=stockError");
                    return;
                }

                boolean success = quotationService.updateQuotationDetail(detail, userId);
                if (success) {
                    pService.updateQuantityReserve(detail.getProductId(), reserveTemp);
                }
                response.sendRedirect(request.getContextPath() + "/quotation-detail?id=" + quotationId
                        + (success ? "&message=saveSuccess" : "&message=saveFailed"));
                return;
            }

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
        detail.setProductName(request.getParameter("productName"));
        detail.setQuantity(Integer.parseInt(request.getParameter("quantity")));
        
        String priceParam = request.getParameter("sellingPrice");
        detail.setSellingPrice(priceParam != null && !priceParam.isEmpty() ? new BigDecimal(priceParam) : BigDecimal.ZERO);
        
        String discountParam = request.getParameter("discountPercent");
        detail.setDiscountPercent(discountParam != null && !discountParam.isEmpty() ? new BigDecimal(discountParam) : BigDecimal.ZERO);
        
        String taxParam = request.getParameter("taxPercent");
        detail.setTaxPercent(taxParam != null && !taxParam.isEmpty() ? new BigDecimal(taxParam) : BigDecimal.ZERO);
        
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
