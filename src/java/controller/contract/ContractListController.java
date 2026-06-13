/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.contract;

import java.io.PrintWriter;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.util.List;
import model.*;
import dal.*;

@WebServlet("/contract-list")
public class ContractListController extends HttpServlet {

    private ContractDAO dao = new ContractDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. LAY THAM SO TIM KIEM
        String contractNumber = request.getParameter("contractNumber");
        String customerName = request.getParameter("customerName");
        String status = request.getParameter("status");
        String storageType = request.getParameter("storageType");

        // 2. VALIDATE PAGE INDEX (Tranh loi NumberFormatException)
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

        int pageSize = 10;

        // 3. THUC THI DAO (Đung thu tu: lay pageIndex xong moi search)
        List<Contract> list = dao.searchContracts(contractNumber, customerName, status, storageType, pageIndex, pageSize);
        int totalRecord = dao.getTotalContracts(contractNumber, customerName, status, storageType);

        // Tinh toan trang cuoi
        int endPage = (int) Math.ceil((double) totalRecord / pageSize);
        // Validate lai pageIndex đe khong vuot qua trang cuoi
        if (pageIndex > endPage && endPage > 0) {
            pageIndex = endPage;
        }

        // 4. GIU TRANG THAI (State Preservation)
        request.setAttribute("list", list);
        request.setAttribute("endPage", endPage);
        request.setAttribute("currentPage", pageIndex);
        request.setAttribute("contractNumber", contractNumber);
        request.setAttribute("customerName", customerName);
        request.setAttribute("status", status);
        request.setAttribute("storageType", storageType);

        // 5. CHUYEN HUONG TOI VIEW
        request.getRequestDispatcher("views/contract/list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

}
