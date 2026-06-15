/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.customer;

import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dto.*;
import model.*;
import java.util.List;
import service.*;
/**
 *
 * @author XHieu
 */
@WebServlet(name = "DetailCustomerController", urlPatterns = {"/customer/detail"})
public class DetailCustomerController extends HttpServlet {
    private final CustomerService customerService = new CustomerService();
    private final RoleService roleService = new service.RoleService();
    private final UserService userService = new UserService();
    private final CustomerOrderService customerOrderService = new CustomerOrderService();
    private final QuotationService quotationService = new QuotationService();
    private final ContractService contractService = new ContractService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        int id_cus = Integer.parseInt(request.getParameter("id_cus"));
        CustomerDTO cusDTO = customerService.getCustomerDTOByCusId(id_cus);
        List<CustomerOrderDTO> listOrdersCus = customerOrderService.getListCustomerOrderDTOByCusId(id_cus);
        List<Quotation> listQuotationsForCus = quotationService.getQuotationsByCustomerId(id_cus);
        List<Contract> listContractsForCus = contractService.getContractsByCustomerId(id_cus);
        
        request.setAttribute("listOrdersForCus", listOrdersCus);
        request.setAttribute("listQuotationsForCus", listQuotationsForCus);
        request.setAttribute("listContractsForCus", listContractsForCus);
        request.setAttribute("cusDTO", cusDTO);
        request.getRequestDispatcher("/views/customer/customer_detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
