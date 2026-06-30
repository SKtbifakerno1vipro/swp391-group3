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

//    public List<dto.CustomerOrderDTO> getOrderDetails(int orderId) {
//        return customerOrderDAO.getDetailsByOrderId(orderId);
//    }

    public List<dto.CustomerOrderDTO> getOrderDetails(int orderId) {
        return customerOrderDAO.getDetailsByOrderId(orderId);
    }

    public boolean createOrder(model.CustomerOrder order, List<model.CustomerOrderDetail> details) {
        return customerOrderDAO.createOrder(order, details);
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
