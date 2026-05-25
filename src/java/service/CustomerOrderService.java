package service;

import dal.CustomerOrderDAO;
import dto.CustomerOrderDTO;
import java.util.List;

public class CustomerOrderService {
    private final CustomerOrderDAO customerOrderDAO = new CustomerOrderDAO();

    public List<CustomerOrderDTO> getAllCustomerOrders() {
        return customerOrderDAO.getAllCustomerOrders();
    }
}
