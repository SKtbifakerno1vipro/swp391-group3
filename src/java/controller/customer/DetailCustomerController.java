/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.customer;
import java.io.IOException;
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
    private static final CustomerService customerService = new CustomerService();
    private static final CustomerOrderService customerOrderService = new CustomerOrderService();
    private static final QuotationService quotationService = new QuotationService();
    private static final ContractService contractService = new ContractService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        // check deactive customer truoc 
        if ("deactivate".equals(action)) {
            try {
                int idCus = Integer.parseInt(request.getParameter("id_cus"));
                customerService.deactivateCustomer(idCus);
                response.sendRedirect(request.getContextPath() + "/customer/detail?id_cus=" + idCus);
                return;
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/customer/list");
                return;
            }
        } else if ("activate".equals(action)) {
            try {
                int idCus = Integer.parseInt(request.getParameter("id_cus"));
                customerService.activateCustomer(idCus);
                response.sendRedirect(request.getContextPath() + "/customer/detail?id_cus=" + idCus);
                return;
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/customer/list");
                return;
            }
        }

        try {
            int idCus = Integer.parseInt(request.getParameter("id_cus"));
            CustomerDTO cusDTO = customerService.getCustomerDTOByCusId(idCus);
            if (cusDTO == null) {
                response.sendRedirect(request.getContextPath() + "/customer/list");
                return;
            }
            List<CustomerOrderDTO> listOrdersCus = customerOrderService.getListCustomerOrderDTOByCusId(idCus);
            List<Quotation> listQuotationsForCus = quotationService.getQuotationsByCustomerId(idCus);
            List<ContractCustomerDTO> listContractsForCus = contractService.searchContracts(
                    null, null, null, null, 1, 1000, cusDTO.getUserId(), 3,
                    null, null, null, null, null
            );
            
            request.setAttribute("listOrdersForCus", listOrdersCus);
            request.setAttribute("listQuotationsForCus", listQuotationsForCus);
            request.setAttribute("listContractsForCus", listContractsForCus);
            request.setAttribute("cusDTO", cusDTO);
            request.getRequestDispatcher("/views/customer/customer_detail.jsp").forward(request, response);
        } catch (NumberFormatException | NullPointerException e) {
            response.sendRedirect(request.getContextPath() + "/customer/list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
