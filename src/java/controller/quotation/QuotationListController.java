package controller.quotation;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Quotation;
import service.QuotationService;

@WebServlet(name = "QuotationListController", urlPatterns = {"/quotation-list"})
public class QuotationListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String searchText = request.getParameter("search");
               
        String status = request.getParameter("status");
        
        QuotationService quotationService = new QuotationService();
        List<Quotation> quotationList = quotationService.searchQuotations(searchText, status);
       
        request.setAttribute("searchText", searchText);
        request.setAttribute("status", status);
        request.setAttribute("quotationList", quotationList);
        request.getRequestDispatcher("/views/quotation/list.jsp").forward(request, response);
    } 
}