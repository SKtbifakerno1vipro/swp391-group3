package service;

import dal.QuotationDAO;
import java.util.List;
import model.Quotation;

public class QuotationService {

    private QuotationDAO quotationDAO;

    public QuotationService() {
        this.quotationDAO = new QuotationDAO();
    }

    public List<Quotation> getAllQuotations() {
        return quotationDAO.getAllQuotations();
    }
    
    public List<Quotation> searchQuotations(String search, String status){
        return quotationDAO.searchQuotations(search, status);
    }
}