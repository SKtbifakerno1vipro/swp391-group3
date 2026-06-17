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
            String note = "Cap nhat detail: quantity=" + detail.getQuantity()
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
        boolean added = quotationDAO.addQuotationDetail(detail);

        if (added) {
            quotationDAO.addQuotationHistory(detail.getQuotationId(), userId, "Them san pham vao quotation");
        }

        return added;
    }

    /*
     * Xoa 1 san pham khoi quotation dang co va ghi lich su.
     */
    public boolean deleteProductFromQuotation(int quotationId, int quotationDetailId, Integer userId) {
        boolean deleted = quotationDAO.deleteQuotationDetail(quotationDetailId);

        if (deleted) {
            quotationDAO.addQuotationHistory(quotationId, userId, "Xoa san pham khoi quotation");
        }

        return deleted;
    }

    public void updateStatus(int quotationId, String status) {
        quotationDAO.updateStatus(quotationId, status);
    }

    // XHieu-begin - delete contact me
    public List<Quotation> getQuotationsByCustomerId(int customerId) {
        return quotationDAO.getQuotationsByCustomerId(customerId);
    }
    // Xhieu - end
}