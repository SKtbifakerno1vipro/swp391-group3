package dto;

public class TopCustomerDTO {
    private String companyName;
    private int totalOrders;

    public TopCustomerDTO() {
    }

    public TopCustomerDTO(String companyName, int totalOrders) {
        this.companyName = companyName;
        this.totalOrders = totalOrders;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public int getTotalOrders() {
        return totalOrders;
    }

    public void setTotalOrders(int totalOrders) {
        this.totalOrders = totalOrders;
    }
}
