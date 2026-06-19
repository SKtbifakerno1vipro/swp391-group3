package service;

import dal.QuotationDAO;
import dto.CustomerDTO;
import java.util.List;
import model.Product;
import model.Quotation;
import model.QuotationDetail;
import model.QuotationHistory;

public class QuotationService {

    private QuotationDAO quotationDAO;
    private CustomerService customerService;
    private ProductService productService;

    public QuotationService() {
        this.quotationDAO = new QuotationDAO();
        this.customerService = new CustomerService();
        this.productService = new ProductService();
    }

    public List<Quotation> getAllQuotations() {
        return quotationDAO.getAllQuotations();
    }

    public List<Quotation> searchQuotations(String search, String status) {
        return quotationDAO.searchQuotations(search, status);
    }

    public List<CustomerDTO> getAllCustomers() {
        return customerService.getAllCustomerDTOs();
    }

    public List<Product> getAllProducts() {
        return productService.getAllProducts();
    }

    /*
     * Tao quotation moi va ghi lich su tao moi.
     */
    public boolean createQuotation(Quotation quotation, QuotationDetail detail) {
        int quotationId = quotationDAO.createQuotation(quotation);

        if (quotationId == -1) {
            return false;
        }

        detail.setQuotationId(quotationId);
        boolean detailCreated = quotationDAO.addQuotationDetail(detail);

        if (detailCreated) {
            quotationDAO.addQuotationHistory(quotationId, quotation.getCreatedBy(), "Tao quotation moi");
        }

        return detailCreated;
    }

    /*
     * Lay thong tin chung cua 1 quotation.
     */
    public Quotation getQuotationById(int quotationId) {
        return quotationDAO.getQuotationById(quotationId);
    }

    /*
     * Lay danh sach san pham trong quotation.
     */
    public List<QuotationDetail> getQuotationDetailsByQuotationId(int quotationId) {
        return quotationDAO.getQuotationDetailsByQuotationId(quotationId);
    }

    /*
     * Lay lich su negotiation cua quotation.
     */
    public List<QuotationHistory> getHistoryByQuotationId(int quotationId) {
        return quotationDAO.getHistoryByQuotationId(quotationId);
    }

    /*
     * Cap nhat 1 dong chi tiet quotation va ghi lich su.
     */
    public boolean updateQuotationDetail(QuotationDetail detail, Integer userId) {
        boolean updated = quotationDAO.updateQuotationDetail(detail);

        if (updated) {
            String note = "Cap nhat san pham " + detail.getProductName() + ": quantity=" + detail.getQuantity()
                    + ", sellingPrice=" + detail.getSellingPrice()
                    + ", discount=" + detail.getDiscountPercent()
                    + ", tax=" + detail.getTaxPercent();
            quotationDAO.addQuotationHistory(detail.getQuotationId(), userId, note);
        }

        return updated;
    }
    /*
     * Tao quotation moi voi nhieu san pham.
     * Buoc 1: tao quotation de lay quotationId.
     * Buoc 2: lap qua tung detail va insert vao quotation_detail.
     */
    public boolean createQuotation(Quotation quotation, List<QuotationDetail> details) {
        int quotationId = quotationDAO.createQuotation(quotation);

        if (quotationId == -1) {
            return false;
        }

        boolean allDetailsCreated = true;

        for (QuotationDetail detail : details) {
            detail.setQuotationId(quotationId);
            boolean detailCreated = quotationDAO.addQuotationDetail(detail);

            if (!detailCreated) {
                allDetailsCreated = false;
            }
        }

        if (allDetailsCreated) {
            quotationDAO.addQuotationHistory(quotationId, quotation.getCreatedBy(), "Tao quotation moi voi " + details.size() + " san pham");
        }

        return allDetailsCreated;
    }
    /*
     * Them 1 san pham moi vao quotation dang co va ghi lich su.
     */
    public boolean addProductToQuotation(QuotationDetail detail, Integer userId) {
        QuotationDetail oldDetail = quotationDAO.getQuotationDetailByProduct(detail.getQuotationId(), detail.getProductId());

        if (oldDetail != null) {
            int oldQuantity = oldDetail.getQuantity();
            int newQuantity = oldQuantity + detail.getQuantity();

            oldDetail.setQuantity(newQuantity);
            oldDetail.setSellingPrice(detail.getSellingPrice());
            oldDetail.setDiscountPercent(detail.getDiscountPercent());
            oldDetail.setTaxPercent(detail.getTaxPercent());

            boolean updated = quotationDAO.updateQuotationDetail(oldDetail);

            if (updated) {
                quotationDAO.addQuotationHistory(detail.getQuotationId(), userId,
                        "Cap nhat san pham " + detail.getProductName() + " da co: quantity tu " + oldQuantity + " thanh " + newQuantity);
            }

            return updated;
        }

        boolean added = quotationDAO.addQuotationDetail(detail);

        if (added) {
            quotationDAO.addQuotationHistory(detail.getQuotationId(), userId, "Them san pham " + detail.getProductName() + " vao quotation");
        }

        return added;
    }

    /*
     * Xoa 1 san pham khoi quotation dang co va ghi lich su.
     */
    public boolean deleteProductFromQuotation(int quotationId, int quotationDetailId, String productName, Integer userId) {
        boolean deleted = quotationDAO.deleteQuotationDetail(quotationDetailId);

        if (deleted) {
            quotationDAO.addQuotationHistory(quotationId, userId, "Xoa san pham " + productName + " khoi quotation");
        }

        return deleted;
    }

    /*
     * Cap nhat discount va tax cho toan bo quotation_detail hien co.
     */
    public boolean applyDiscountAndTaxToAll(int quotationId, java.math.BigDecimal discount, java.math.BigDecimal tax, Integer userId) {
        boolean updated = quotationDAO.updateDiscountAndTaxForAll(quotationId, discount, tax);
        if (updated) {
            quotationDAO.addQuotationHistory(quotationId, userId, "Ap dung discount " + discount + "% va tax " + tax + "% cho toan bo san pham");
        }
        return updated;
    }

    public void updateStatus(int quotationId, String status, Integer userId) {
        quotationDAO.updateStatus(quotationId, status);
        quotationDAO.addQuotationHistory(quotationId, userId, "Cap nhat trang thai thanh: " + status);
    }

    // XHieu-begin - delete contact me
    public List<Quotation> getQuotationsByCustomerId(int customerId) {
        return quotationDAO.getQuotationsByCustomerId(customerId);
    }
    // Xhieu - end
}
