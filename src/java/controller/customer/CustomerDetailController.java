package controller.customer;
import service.CustomerService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import dto.CustomerDTO;
@WebServlet(name = "CustomerDetailController", urlPatterns = {"/CustomerDetail"})
public class CustomerDetailController extends HttpServlet {
    private final CustomerService customerService = new CustomerService();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int cusId = Integer.parseInt(request.getParameter("id"));
        CustomerDTO cus = customerService.getCustomerDTOByCustomerId(cusId);
        request.setAttribute("customerDTO", cus);
        request.getRequestDispatcher("/views/customer/detail.jsp").forward(request, response);
    }
}