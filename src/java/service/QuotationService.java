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

    public void updateStatus(int quotationId, String status) {
        quotationDAO.updateStatus(quotationId, status);
    }

}