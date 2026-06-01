package service;

import dal.CustomerContractDAO;
import java.util.List;
import model.CustomerContract;

public class CustomerContractService {
    private final CustomerContractDAO customerContractDAO = new CustomerContractDAO();

    public List<CustomerContract> getSignedContractsByCustomerId(int customerId) {
        return customerContractDAO.getContractsByCustomerId(customerId);
    }
}
