package dto;

import java.math.BigDecimal;

public class InvoiceSummaryDTO {
    private int totalInvoices;
    private BigDecimal paidAmount;
    private BigDecimal unpaidAmount;

    public InvoiceSummaryDTO() {}

    public InvoiceSummaryDTO(int totalInvoices, BigDecimal paidAmount, BigDecimal unpaidAmount) {
        this.totalInvoices = totalInvoices;
        this.paidAmount = paidAmount;
        this.unpaidAmount = unpaidAmount;
    }

    public int getTotalInvoices() { return totalInvoices; }
    public void setTotalInvoices(int totalInvoices) { this.totalInvoices = totalInvoices; }

    public BigDecimal getPaidAmount() { return paidAmount; }
    public void setPaidAmount(BigDecimal paidAmount) { this.paidAmount = paidAmount; }

    public BigDecimal getUnpaidAmount() { return unpaidAmount; }
    public void setUnpaidAmount(BigDecimal unpaidAmount) { this.unpaidAmount = unpaidAmount; }
}
