package service;

import dal.CustomerOrderDAO;
import dto.CustomerOrderDTO;
import java.util.List;

import service.*;
import model.*;

public class CustomerOrderService {

    private final CustomerOrderDAO customerOrderDAO = new CustomerOrderDAO();
    private final CustomerService customerService = new CustomerService();

//    public List<CustomerOrderDTO> getAllCustomerOrders() {
//        return customerOrderDAO.getAllCustomerOrders();
//    }

    public CustomerOrderDTO getCustomerOrderById(int id) {
        return customerOrderDAO.getCustomerOrderDTOById(id);
    }

//    public CustomerOrderDTO getOrderByContractId(int contractId) {
//        return customerOrderDAO.getOrderByContractId(contractId);
//    }

//    public List<CustomerOrderDTO> getOrderDetails(int orderId) {
//        return customerOrderDAO.getDetailsByOrderId(orderId);
//    }

    public List<CustomerOrderDTO> getOrderDetails(int orderId) {
        return customerOrderDAO.getDetailsByOrderId(orderId);
    }

    public double getTotalPriceFromQuotationByOrderId(int orderId) {
        return customerOrderDAO.getTotalPriceFromQuotationByOrderId(orderId);
    }

    public boolean createOrder(CustomerOrder order, List<CustomerOrderDetail> details) {
        return customerOrderDAO.createOrder(order, details);
    }

    public CustomerOrderDTO getCustomerOrderDTOById(int id) {
        return customerOrderDAO.getCustomerOrderDTOById(id);
    }

    public int getTotalSearchCount(String keyword, int userId, String roleName) {
        return customerOrderDAO.getTotalOrdersBySearch(keyword, userId, roleName);
    }

    public List<CustomerOrderDTO> searchOrdersByPage(String kw, int p, int s, String sortBy, String sortOrder, int userId, String roleName) {
        return customerOrderDAO.searchOrdersWithPaging(kw, p, s, sortBy, sortOrder, userId, roleName);
    }

    public boolean updateOrderStatus(int orderId, String status) {
        boolean updated = customerOrderDAO.updateOrderStatus(orderId, status);
        if (updated && "SHIPPING".equalsIgnoreCase(status)) {
            System.out.println("Order status updated to SHIPPING for Order ID: " + orderId + ". Triggering auto-payment creation.");
            try {
                CustomerOrderDTO orderDto = customerOrderDAO.getCustomerOrderDTOById(orderId);
                if (orderDto != null && orderDto.getCustomerOrder() != null) {
                    PaymentService paymentService = new PaymentService();
                    paymentService.createPendingPaymentForOrder(orderDto.getCustomerOrder());
                }
            } catch (Exception e) {
                System.err.println("Failed to automatically create pending payment on SHIPPING status: " + e.getMessage());
                e.printStackTrace();
            }
        }
        return updated;
    }

    public boolean isValidStatusTransition(String currentStatus, String newStatus) {
        if (currentStatus == null || newStatus == null) {
            return false;
        }
        if (currentStatus.equalsIgnoreCase(newStatus)) {
            return true;
        }
        
        switch (currentStatus.toUpperCase()) {
            case "PENDING":
                return "SHIPPING".equalsIgnoreCase(newStatus) 
                    || "CANCELLED".equalsIgnoreCase(newStatus) 
                    || "DELETED".equalsIgnoreCase(newStatus);
            case "SHIPPING":
                return "COMPLETED".equalsIgnoreCase(newStatus) 
                    || "CANCELLED".equalsIgnoreCase(newStatus) 
                    || "DELETED".equalsIgnoreCase(newStatus);
            case "COMPLETED":
            case "CANCELLED":
            case "DELETED":
            default:
                return false;
        }
    }
    
    public boolean deleteCustomerOrder(int orderId) {
        return customerOrderDAO.deleteCustomerOrder(orderId);
    }
}
