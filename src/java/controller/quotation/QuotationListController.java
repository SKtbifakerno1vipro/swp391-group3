package controller.quotation;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.*;
import service.*;
import dto.*;

@WebServlet(name = "QuotationListController", urlPatterns = {"/quotation-list"})
public class QuotationListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String searchText = request.getParameter("search");
        if (searchText != null) {
            searchText = searchText.trim().replaceAll("\\s+", " ");
        }
               
        String status = request.getParameter("status");
        
        // Role Customer?
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        Integer cusID = null;
        if (user != null && user.getRoleId() == 3) { // Customer
            CustomerService customerService = new CustomerService();
            CustomerDTO cusDTO = customerService.getCustomerDTOByUserId(user.getUserId());
            if (cusDTO != null) {
                cusID = cusDTO.getCustomerId();
            } else {
                cusID = -1; // If user is a Customer but has no Customer profile, search returns empty list
            }
        }
        
        QuotationService quotationService = new QuotationService();
        List<Quotation> quotationList = quotationService.searchQuotations(searchText, status, cusID);
       
        request.setAttribute("searchText", searchText);
        request.setAttribute("status", status);
        request.setAttribute("quotationList", quotationList);
        request.getRequestDispatcher("/views/quotation/list.jsp").forward(request, response);
    } 
}
