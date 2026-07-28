package controller.contract;

import model.User;
import model.Contract;
import service.ContractService;
import service.AuditLogService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/contract-delete")
public class ContractDeleteController extends HttpServlet {

    private final ContractService contractService = new ContractService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

       
        if (currentUser.getRoleId() != 2) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền thực hiện chức năng này.");
            return;
        }

        try {
            int contractId = Integer.parseInt(request.getParameter("id"));
            Contract contract = contractService.getContractById(contractId);
            if (contract != null) {
                if ("DRAFT".equals(contract.getContractStatus())) {
                    boolean success = contractService.deleteContract(contractId);
                    if (success) {
                        session.setAttribute("successSig", "Đã xóa cứng hợp đồng thành công!");
                    } else {
                        session.setAttribute("errorSig", "Xóa hợp đồng thất bại!");
                    }
                } else {
                    session.setAttribute("errorSig", "Chỉ có thể xóa hợp đồng ở trạng thái DRAFT!");
                }
            } else {
                session.setAttribute("errorSig", "Không tìm thấy hợp đồng!");
            }
        } catch (NumberFormatException e) {
        }

        response.sendRedirect(request.getContextPath() + "/contract-list");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
