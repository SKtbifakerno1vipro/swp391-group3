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

    public List<dto.CustomerOrderDTO> getOrderDetails(int orderId) {
        return customerOrderDAO.getDetailsByOrderId(orderId);
    }

    public boolean createOrder(model.CustomerOrder order, List<model.CustomerOrderDetail> details) {
        return customerOrderDAO.createOrder(order, details);
    }


    
    public List<CustomerOrderDTO> findbyNameOrTaxcode(String keyword) {
        return customerOrderDAO.getAllCustomerOrdersByName(keyword);
    }

    public int getTotalOrderCount() {
        return customerOrderDAO.getTotalOrders();
    }

    public List<CustomerOrderDTO> getOrdersByPage(int page, int size) {
        return customerOrderDAO.getOrdersWithPaging(page, size);
    }

    public int getTotalSearchCount(String keyword) {
        return customerOrderDAO.getTotalOrdersBySearch(keyword);
    }

    public List<CustomerOrderDTO> searchOrdersByPage(String kw, int p, int s) {
        return customerOrderDAO.searchOrdersWithPaging(kw, p, s);
    }
    public boolean updateOrderStatus(int orderId, String status) {
        return customerOrderDAO.updateOrderStatus(orderId, status);
    }
    public boolean updateOrderDetailQuantity(int detailId, int quantity) {
        return customerOrderDAO.updateOrderDetailQuantity(detailId, quantity);
    }

    public boolean deleteOrderDetail(int detailId) {
        return customerOrderDAO.deleteOrderDetail(detailId);
    }
    
    // -xoa thi nho bao xhieu 
    
    public int getTotalOrdersCountByCusId(int cusId) {
        if (cusId <= 0) {
            return 0;
        }

        // validate xem co khach hang ko
        Customer customer = customerService.getCustomerByCusId(cusId);

        if (customer == null) {
            return 0;
        }

        return customerOrderDAO.getTotalOrdersCountByCusId(cusId);
    }
    public List<CustomerOrderDTO> getListCustomerOrderDTOByCusId(int cusId) {
        // Chuyen tiep (forward) tham so va xu ly logic xuong tang DAO
        return customerOrderDAO.getListCustomerOrderDTOByCusId(cusId);
    }
    // end
    
}
