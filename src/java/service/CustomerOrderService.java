package service;

import dal.CustomerOrderDAO;
import dto.CustomerOrderDTO;
import java.util.List;

import service.*;
import model.*;

public class CustomerOrderService {

    private final CustomerOrderDAO customerOrderDAO = new CustomerOrderDAO();
    private final CustomerService customerService = new CustomerService();

    public List<CustomerOrderDTO> getAllCustomerOrders() {
        return customerOrderDAO.getAllCustomerOrders();
    }

    public CustomerOrderDTO getCustomerOrderById(int id) {
        return customerOrderDAO.getCustomerOrderDTOById(id);
    }

//    public CustomerOrderDTO getOrderByContractId(int contractId) {
//        return customerOrderDAO.getOrderByContractId(contractId);
//    }

//    public List<dto.CustomerOrderDTO> getOrderDetails(int orderId) {
//        return customerOrderDAO.getDetailsByOrderId(orderId);
//    }

    public List<dto.CustomerOrderDTO> getOrderDetails(int orderId) {
        return customerOrderDAO.getDetailsByOrderId(orderId);
    }

    public boolean createOrder(model.CustomerOrder order, List<model.CustomerOrderDetail> details) {
        System.out.println("[CustomerOrderService] Attempting to create order for Contract ID: " + order.getCustomerContractId());
        boolean success = customerOrderDAO.createOrder(order, details);
        // Xhieu - tu dong tao payment
        if (success) {
            System.out.println("[CustomerOrderService] Order created successfully. Triggering auto-payment creation.");
            try {
                int contractId = order.getCustomerContractId();
                PaymentService paymentService = new PaymentService();
                paymentService.createPendingPaymentForContractIfNotExists(contractId);
            } catch (Exception e) {
                System.err.println("[CustomerOrderService] Failed to automatically create pending payment for contract: " + e.getMessage());
                e.printStackTrace();
            }
        } else {
            System.err.println("[CustomerOrderService] Failed to create order in database.");
        }
        return success;
    }


    
    public List<CustomerOrderDTO> findbyNameOrTaxcode(String keyword) {
        return customerOrderDAO.getAllCustomerOrdersByName(keyword);
    }

    public int getTotalOrderCount(int userId, String roleName) {
        return customerOrderDAO.getTotalOrders(userId, roleName);
    }

    public List<CustomerOrderDTO> getOrdersByPage(int page, int size, String sortBy, String sortOrder, int userId, String roleName) {
        return customerOrderDAO.getOrdersWithPaging(page, size, sortBy, sortOrder, userId, roleName);
    }

    public int getTotalSearchCount(String keyword, int userId, String roleName) {
        return customerOrderDAO.getTotalOrdersBySearch(keyword, userId, roleName);
    }

    public List<CustomerOrderDTO> searchOrdersByPage(String kw, int p, int s, String sortBy, String sortOrder, int userId, String roleName) {
        return customerOrderDAO.searchOrdersWithPaging(kw, p, s, sortBy, sortOrder, userId, roleName);
    }
    public boolean updateOrderStatus(int orderId, String status) {
        return customerOrderDAO.updateOrderStatus(orderId, status);
    }
    
    public boolean deleteCustomerOrder(int orderId) {
        return customerOrderDAO.deleteCustomerOrder(orderId);
    }
    
    // -xoa thi nho bao xhieu
    public List<CustomerOrderDTO> getListCustomerOrderDTOByCusId(int cusId) {
        // Chuyen tiep (forward) tham so va xu ly logic xuong tang DAO
        return customerOrderDAO.getListCustomerOrderDTOByCusId(cusId);
    }
    // end
    
}
