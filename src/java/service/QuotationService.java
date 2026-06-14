package service;

import dal.QuotationDAO;
import dto.CustomerDTO;
import java.util.List;
import model.Product;
import model.Quotation;
import model.QuotationDetail;

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
    
    public List<Quotation> searchQuotations(String search, String status){
        return quotationDAO.searchQuotations(search, status);
    }
    
    public List<CustomerDTO> getAllCustomers(){
        return customerService.getAllCustomerDTOs();
    }
    
    public List<Product> getAllProducts(){
        return productService.getAllProducts();
    }
    
    public boolean  createQuotation(Quotation quotation, QuotationDetail detail){
        int quotationId= quotationDAO.createQuotation(quotation);
        
        if (quotationId == -1){
            return false;
        }
        detail.setQuotationId(quotationId);
        return quotationDAO.addQuotationDetail(detail);
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
}