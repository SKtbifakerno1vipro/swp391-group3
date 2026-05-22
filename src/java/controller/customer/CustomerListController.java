package controller.customer;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;
import dal.CustomerDAO;

@WebServlet(name = "CustomerListController", urlPatterns = {"/customer-list"})
public class CustomerListController extends HttpServlet {

    private CustomerDAO customerDAO;

    @Override
    public void init() {
        customerDAO = new CustomerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // 1. Gá»i DAO láº¥y danh sÃ¡ch dá»¯ liá»‡u tá»« DB
            List<Customer> customers = customerDAO.getAllCustomers();
            
            // 2. LÆ°u danh sÃ¡ch vÃ o request attribute Ä‘á»ƒ Ä‘áº©y sang JSP
            request.setAttribute("customerList", customers);
            
            // 3. Chuyá»ƒn hÆ°á»›ng (Forward) sang trang hiá»ƒn thá»‹ JSP
            request.getRequestDispatcher("/customer-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lá»—i khi láº¥y danh sÃ¡ch khÃ¡ch hÃ ng!");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}