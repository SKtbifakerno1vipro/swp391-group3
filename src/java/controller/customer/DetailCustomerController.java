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
            jakarta.servlet.http.HttpSession session = request.getSession(false);
            User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
            if (currentUser == null || (currentUser.getRoleId() != 1 && currentUser.getRoleId() != 2 && currentUser.getRoleId() != 4)) {
                response.sendRedirect(request.getContextPath() + "/dashboard?error=unauthorized");
                return;
            }
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
            jakarta.servlet.http.HttpSession session = request.getSession(false);
            User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
            if (currentUser == null || (currentUser.getRoleId() != 1 && currentUser.getRoleId() != 2 && currentUser.getRoleId() != 4)) {
                response.sendRedirect(request.getContextPath() + "/dashboard?error=unauthorized");
                return;
            }
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

        jakarta.servlet.http.HttpSession session = request.getSession(false);
        model.User user = (session != null) ? (model.User) session.getAttribute("user") : null;

        try {
            String idCusParam = request.getParameter("id_cus");
            int idCus = -1;
            if (idCusParam == null || idCusParam.trim().isEmpty()) {
                if (user != null && user.getRoleId() == 3) {
                    dto.CustomerDTO customer = customerService.getCustomerDTOByUserId(user.getUserId());
                    if (customer != null) {
                        idCus = customer.getCustomer().getCustomerId();
                    }
                }
            } else {
                idCus = Integer.parseInt(idCusParam);
            }

            if (idCus == -1) {
                response.sendRedirect(request.getContextPath() + "/dashboard");
                return;
            }

            // Security check: Customer can only view their own profile
            if (user != null && user.getRoleId() == 3) {
                dto.CustomerDTO customer = customerService.getCustomerDTOByUserId(user.getUserId());
                if (customer == null || customer.getCustomer().getCustomerId() != idCus) {
                    response.sendRedirect(request.getContextPath() + "/dashboard?error=unauthorized");
                    return;
                }
            }

            CustomerDTO cusDTO = customerService.getCustomerDTOByCusId(idCus);
            if (cusDTO == null) {
                if (user != null && user.getRoleId() == 3) {
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/customer/list");
                }
                return;
            }
            List<CustomerOrderDTO> listOrdersCus = customerOrderService.getListCustomerOrderDTOByCusId(idCus);
            List<Quotation> listQuotationsForCus = quotationService.getQuotationsByCustomerId(idCus);
            List<ContractCustomerDTO> listContractsForCus = contractService.searchContracts(
                    null, null, null, null, 1, 1000, cusDTO.getUser().getUserId(), 3,
                    null, null, null, null, null
            );
            
            request.setAttribute("listOrdersForCus", listOrdersCus);
            request.setAttribute("listQuotationsForCus", listQuotationsForCus);
            request.setAttribute("listContractsForCus", listContractsForCus);
            request.setAttribute("cusDTO", cusDTO);
            request.setAttribute("listSales", customerService.getAllSalesExecutiveUsers());
            request.getRequestDispatcher("/views/customer/customer_detail.jsp").forward(request, response);
        } catch (NumberFormatException | NullPointerException e) {
            if (user != null && user.getRoleId() == 3) {
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/customer/list");
            }
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
