package service;

import dal.CustomerOrderDAO;
import dto.CustomerOrderDTO;
import java.util.List;
import model.CustomerContract;

public class CustomerOrderService {

    private final CustomerOrderDAO customerOrderDAO = new CustomerOrderDAO();

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

    public List<CustomerContract> getSignedContractsByCustomerId(int customerId) {
        return customerOrderDAO.getContractsByCustomerId(customerId);
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
}
