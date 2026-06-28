package service;

import dal.InvoiceDAO;
import dto.InvoiceItemDTO;
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

    public List<InvoiceItemDTO> getInvoiceItemsByOrderId(int orderId) {
        return invoiceDAO.getInvoiceItemsByOrderId(orderId);
    }

    public double calculateGoodsAmount(List<InvoiceItemDTO> details) {
        double totalGoodsAmt = 0;
        if (details != null) {
            for (InvoiceItemDTO item : details) {
                totalGoodsAmt += item.getLineAmount();
            }
        }
        return Double.parseDouble(String.format("%.2f", totalGoodsAmt));
    }

    public double calculateDiscountAmount(List<InvoiceItemDTO> details) {
        double discountAmount = 0.0;
        if (details != null) {
            for (InvoiceItemDTO item : details) {
                discountAmount += item.getLineDiscount();
            }
        }
        return Double.parseDouble(String.format("%.2f", discountAmount));
    }

    public double calculateTaxAmount(List<InvoiceItemDTO> details) {
        double totalTaxAmt = 0;
        if (details != null) {
            for (InvoiceItemDTO item : details) {
                totalTaxAmt += item.getLineTax();
            }
        }
        return Double.parseDouble(String.format("%.2f", totalTaxAmt));
    }

    public Invoice getInvoiceById(int id) {
        return invoiceDAO.getInvoiceById(id);
    }

    public Invoice getInvoiceByOrderId(int orderId) {
        return invoiceDAO.getInvoiceByOrderId(orderId);
    }

    public String getNextInvoiceNo(int year) {
        return invoiceDAO.getNextInvoiceNo(year);
    }

    public String validateInvoice(Invoice invoice, String buyerPhone) {
        return invoiceDAO.validateInvoice(invoice, buyerPhone);
    }

    public boolean updateInvoice(Invoice invoice) {
        return invoiceDAO.updateInvoice(invoice);
    }

    public boolean insertInvoice(Invoice invoice) {
        return invoiceDAO.insertInvoice(invoice);
    }
}
