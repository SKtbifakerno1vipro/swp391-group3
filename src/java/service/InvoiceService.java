package service;

import dal.InvoiceDAO;
import java.util.List;
import model.Invoice;

public class InvoiceService {

    private final InvoiceDAO invoiceDAO = new InvoiceDAO();

    public List<Invoice> getInvoices(int totalRow, int page, int totalPage, int pageSize) {
        return invoiceDAO.getInvoices(totalRow, page, totalPage, pageSize);
    }

    public int countInvoices() {
        return invoiceDAO.countInvoices();
    }
}
