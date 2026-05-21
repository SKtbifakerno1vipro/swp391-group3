package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Customer;
import service.CustomerDAO;

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
            // 1. Gọi DAO lấy danh sách dữ liệu từ DB
            List<Customer> customers = customerDAO.getAllCustomers();
            
            // 2. Lưu danh sách vào request attribute để đẩy sang JSP
            request.setAttribute("customerList", customers);
            
            // 3. Chuyển hướng (Forward) sang trang hiển thị JSP
            request.getRequestDispatcher("/customer-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi lấy danh sách khách hàng!");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}