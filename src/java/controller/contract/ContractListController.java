/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.contract;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.util.List;
import model.*;
import service.*;
import dto.*;
import jakarta.servlet.http.HttpSession;

@WebServlet("/contract-list")
public class ContractListController extends HttpServlet {

    private ContractService contractService = new ContractService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }
        if ((String) session.getAttribute("errorSig") != null) {
            request.setAttribute("errorSig", (String) session.getAttribute("errorSig"));
            session.removeAttribute("errorSig");
        }

        // 1. Take value to filter
        String contractNumber = request.getParameter("contractNumber");
        String customerName = request.getParameter("customerName");
        String status = request.getParameter("status");
        String storageType = request.getParameter("storageType");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        String taxcode = request.getParameter("customerTaxCode");
        String phone = request.getParameter("customerPhone");
        String email = request.getParameter("customerEmail");
        
        // 2. validate page index
        int pageIndex = 1;
        try {
            String pageRaw = request.getParameter("page");
            if (pageRaw != null && !pageRaw.isEmpty()) {
                pageIndex = Integer.parseInt(pageRaw);
                if (pageIndex < 1) {
                    pageIndex = 1;
                }
            }
        } catch (NumberFormatException e) {
            pageIndex = 1;
        }
        //defaul page size is 10
        int pageSize = 10;

        List<ContractCustomerDTO> list = contractService.searchContracts(contractNumber, customerName, status, storageType, pageIndex,
                pageSize, currentUser.getUserId(), currentUser.getRoleId(), fromDate, toDate, taxcode, phone, email);

        int totalRecord = contractService.getTotalContracts(contractNumber, customerName, status, storageType, pageIndex,
                pageSize, currentUser.getUserId(), currentUser.getRoleId(),
                fromDate, toDate, taxcode, phone, email);

        // calculate to the end page
        int endPage = (int) Math.ceil((double) totalRecord / pageSize);

        if (pageIndex > endPage && endPage > 0) {
            pageIndex = endPage;
        }

        request.setAttribute("list", list);
        request.setAttribute("endPage", endPage);
        request.setAttribute("currentPage", pageIndex);
        request.setAttribute("contractNumber", contractNumber);
        request.setAttribute("customerName", customerName);
        request.setAttribute("status", status);
        request.setAttribute("storageType", storageType);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.setAttribute("customerTaxCode", taxcode);
        request.setAttribute("customerPhone", phone);
        request.setAttribute("customerEmail", email);

        request.getRequestDispatcher("views/contract/list.jsp").forward(request, response);
    }

}
