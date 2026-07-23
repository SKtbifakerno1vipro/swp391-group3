package service;

import dal.DashboardDAO;
import dto.*;
import model.*;
import java.util.*;

public class DashboardService {
    private final DashboardDAO dao = new DashboardDAO();

    public int count(String tableName) {
        return dao.count(tableName);
    }

    public int countWhere(String tableName, String columnName, String value) {
        return dao.countWhere(tableName, columnName, value);
    }

    public List<StatusStatisticDTO> countByStatus(String tableName, String statusColumn, Integer saleId) {
        return dao.countByStatus(tableName, statusColumn, saleId);
    }

    public List<StatusStatisticDTO> countByStatus(String tableName, String statusColumn, Integer saleId, String period) {
        return dao.countByStatus(tableName, statusColumn, saleId, period);
    }

    public List<Map<String, Object>> getRecentContracts(int limit) {
        return dao.getRecentContracts(limit);
    }

    public List<Map<String, Object>> getRecentContracts(int limit, Integer saleId) {
        return dao.getRecentContracts(limit, saleId);
    }

    public List<Map<String, Object>> getRecentOrders(int limit) {
        return dao.getRecentOrders(limit);
    }

    public List<Map<String, Object>> getRecentOrders(int limit, Integer saleId) {
        return dao.getRecentOrders(limit, saleId);
    }

    public List<Map<String, Object>> getRecentOrders(int limit, Integer saleId, String period) {
        return dao.getRecentOrders(limit, saleId, period);
    }

    public double getTotalRevenue() {
        return dao.getTotalRevenue();
    }

    public double getTotalRevenue(Integer saleId) {
        return dao.getTotalRevenue(saleId);
    }

    public double getTotalRevenue(Integer saleId, String period) {
        return dao.getTotalRevenue(saleId, period);
    }

    public int getTotalOrders() {
        return dao.getTotalOrders();
    }

    public int getTotalOrders(Integer saleId) {
        return dao.getTotalOrders(saleId);
    }

    public int getTotalOrders(Integer saleId, String period) {
        return dao.getTotalOrders(saleId, period);
    }

    public int getTotalCustomers() {
        return dao.getTotalCustomers();
    }

    public int getTotalCustomers(Integer saleId) {
        return dao.getTotalCustomers(saleId);
    }

    public int getTotalProducts() {
        return dao.getTotalProducts();
    }

    public int getTotalQuotations(Integer saleId) {
        return dao.getTotalQuotations(saleId);
    }

    public int getTotalQuotations(Integer saleId, String period) {
        return dao.getTotalQuotations(saleId, period);
    }

    public int getTotalContracts(Integer saleId) {
        return dao.getTotalContracts(saleId);
    }

    public int getTotalContracts(Integer saleId, String period) {
        return dao.getTotalContracts(saleId, period);
    }

    public Map<String, Double> getRevenueByMonth() {
        return dao.getRevenueByMonth();
    }

    public List<StatusStatisticDTO> getOrderStatusStats() {
        return dao.getOrderStatusStats();
    }

    public List<TopProductDTO> getTopSellingProducts(int limit) {
        return dao.getTopSellingProducts(limit);
    }

    public List<TopProductDTO> getTopSellingProducts(int limit, Integer saleId) {
        return dao.getTopSellingProducts(limit, saleId);
    }

    public List<TopProductDTO> getTopSellingProducts(int limit, Integer saleId, String period) {
        return dao.getTopSellingProducts(limit, saleId, period);
    }

    public List<TopCustomerDTO> getTopCustomersByOrderCount(int limit, Integer saleId) {
        return dao.getTopCustomersByOrderCount(limit, saleId);
    }

    public List<TopCustomerDTO> getTopCustomersByOrderCount(int limit, Integer saleId, String period) {
        return dao.getTopCustomersByOrderCount(limit, saleId, period);
    }

    public List<Map<String, Object>> getStaffPerformance() {
        return dao.getStaffPerformance();
    }

    public int countQuotationAwaitingContract() {
        return dao.countQuotationAwaitingContract();
    }

    public List<Quotation> getQuotationsAwaitingContract(int limit, String startDate, String endDate) {
        return dao.getQuotationsAwaitingContract(limit, startDate, endDate);
    }

    public int countContractInProgress() {
        return dao.countContractInProgress();
    }

    public List<ContractCustomerDTO> getContractNeedingAction(int limit, String startDate, String endDate) {
        return dao.getContractNeedingAction(limit, startDate, endDate);
    }

    public List<StatusStatisticDTO> countContractStatusForOfficer() {
        return dao.countContractStatusForOfficer();
    }

    public int countActiveContracts() {
        return dao.countActiveContracts();
    }

    public int countDraftContracts() {
        return dao.countDraftContracts();
    }

    public int getTotalUsers() {
        return dao.getTotalUsers();
    }

    public int getTotalContracts() {
        return dao.getTotalContracts();
    }

    public int getTotalInvoices() {
        return dao.getTotalInvoices();
    }

    public List<RoleStatisticDTO> getUsersByRole() {
        return dao.getUsersByRole();
    }

    public List<StatusStatisticDTO> getContractsByStatus() {
        return dao.getContractsByStatus();
    }

    public List<StatusStatisticDTO> getOrdersByStatus() {
        return dao.getOrdersByStatus();
    }

    public List<ActivityDTO> getRecentActivities() {
        return dao.getRecentActivities();
    }

    public InvoiceSummaryDTO getInvoiceSummaryForOfficer() {
        return dao.getInvoiceSummaryForOfficer();
    }

    public List<RecentInvoiceDTO> getRecentInvoicesForOfficer(int limit, String startDate, String endDate) {
        return dao.getRecentInvoicesForOfficer(limit, startDate, endDate);
    }

    public List<RecentInvoiceDTO> getRecentInvoicesForOfficer(int limit, String startDate, String endDate, String period) {
        return dao.getRecentInvoicesForOfficer(limit, startDate, endDate, period);
    }

    public int getPendingImportRequestsCount() {
        return dao.getPendingImportRequestsCount();
    }

    public int getPendingOrdersCount() {
        return dao.getPendingOrdersCount();
    }

    public int getLowStockProductsCount() {
        return dao.getLowStockProductsCount();
    }

    public List<Map<String, Object>> getLowStockProductsList() {
        return dao.getLowStockProductsList();
    }

    public List<Map<String, Object>> getPendingImportRequestsList(int limit) {
        return dao.getPendingImportRequestsList(limit);
    }

    public List<Map<String, Object>> getRecentOrdersList(int limit) {
        return dao.getRecentOrdersList(limit);
    }

    public List<ProductSalesItemDTO> getProductSalesReport(String startDate, String endDate, Integer staffId) {
        return dao.getProductSalesReport(startDate, endDate, staffId);
    }

    public List<Map<String, Object>> getAllStaffUsers() {
        return dao.getAllStaffUsers();
    }

}

