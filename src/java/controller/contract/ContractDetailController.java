package controller.contract;

import dal.ContractDAO;
import model.Contract;
import model.ContractHistory;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/contract-detail")
public class ContractDetailController extends HttpServlet {

    private ContractDAO contractDAO = new ContractDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");

        try {
            Contract contract = null;
            if (idStr != null && !idStr.isEmpty()) {
                contract = contractDAO.getContractById(Integer.parseInt(idStr));
            } else {
                String qIdStr = request.getParameter("quotationId");
                if (qIdStr != null && !qIdStr.isEmpty()) {
                    contract = contractDAO.getContractByQuotationId(Integer.parseInt(qIdStr));
                }
            }

            if (contract != null) {
                int id = contract.getContractId();
                List<ContractHistory> historyList = contractDAO.getHistoriesByContractId(id);
                request.setAttribute("contract", contract);
                request.setAttribute("historyList", historyList);

                String status = contract.getContractStatus();
                boolean canRequestEdit = "DRAFT".equals(status) || "PENDING_REVIEW".equals(status);
                boolean canApprove = "PENDING_REVIEW".equals(status);
                boolean canCustomerCheck = "CUSTOMER_CHECK".equals(status);
                boolean isApproved = "APPROVED".equals(status);

                request.setAttribute("canRequestEdit", canRequestEdit);
                request.setAttribute("canApprove", canApprove);
                request.setAttribute("canCustomerCheck", canCustomerCheck);
                request.setAttribute("isApproved", isApproved);

                request.getRequestDispatcher("views/contract/detail.jsp").forward(request, response);
            } else {
                response.sendRedirect("contract-list");
            }
        } catch (Exception e) {
            response.sendRedirect("contract-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        String contractIdStr = request.getParameter("contractId");
        
        if (contractIdStr != null && !contractIdStr.isEmpty()) {
            int contractId = Integer.parseInt(contractIdStr);
            if ("updateStatus".equals(action)) {
                String newStatus = request.getParameter("status");
                contractDAO.updateStatus(contractId, newStatus);
            }
            response.sendRedirect("contract-detail?id=" + contractId);
        } else {
            response.sendRedirect("contract-list");
        }
    }
}
