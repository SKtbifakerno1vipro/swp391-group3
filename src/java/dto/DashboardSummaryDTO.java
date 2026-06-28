package dto;

public class DashboardSummaryDTO {
    private int totalUsers;
    private int totalCustomers;
    private int totalProducts;
    private int totalContracts;
    private int totalOrders;
    private int totalInvoices;

    public DashboardSummaryDTO() {
    }

    public DashboardSummaryDTO(int totalUsers, int totalCustomers, int totalProducts, int totalContracts, int totalOrders, int totalInvoices) {
        this.totalUsers = totalUsers;
        this.totalCustomers = totalCustomers;
        this.totalProducts = totalProducts;
        this.totalContracts = totalContracts;
        this.totalOrders = totalOrders;
        this.totalInvoices = totalInvoices;
    }

    public int getTotalUsers() {
        return totalUsers;
    }

    public void setTotalUsers(int totalUsers) {
        this.totalUsers = totalUsers;
    }

    public int getTotalCustomers() {
        return totalCustomers;
    }

    public void setTotalCustomers(int totalCustomers) {
        this.totalCustomers = totalCustomers;
    }

    public int getTotalProducts() {
        return totalProducts;
    }

    public void setTotalProducts(int totalProducts) {
        this.totalProducts = totalProducts;
    }

    public int getTotalContracts() {
        return totalContracts;
    }

    public void setTotalContracts(int totalContracts) {
        this.totalContracts = totalContracts;
    }

    public int getTotalOrders() {
        return totalOrders;
    }

    public void setTotalOrders(int totalOrders) {
        this.totalOrders = totalOrders;
    }

    public int getTotalInvoices() {
        return totalInvoices;
    }

    public void setTotalInvoices(int totalInvoices) {
        this.totalInvoices = totalInvoices;
    }
}
