package controller.contract;

import dal.ContractDAO;
import model.Contract;
import model.ContractHistory;
import model.ContractRevisionItem;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import service.ContractService;

@WebServlet("/contract-detail")
public class ContractDetailController extends HttpServlet {

    private ContractService contractService = new ContractService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String idStr = request.getParameter("id");

        if (idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                Contract contract = contractService.getContractById(id);

                if (contract != null) {
                    List<ContractHistory> historyList = contractService.getHistoriesByContractId(id);
                    request.setAttribute("contract", contract);
                    request.setAttribute("historyList", historyList);

                    String status = contract.getContractStatus();

                    // clear the status of contract
                    boolean canRequestEdit = "DRAFT".equals(status)
                            || "PENDING_REVIEW".equals(status);
                    boolean canCustomerCheck = "CUSTOMER_CHECK".equals(status);
                    boolean isApproved = "APPROVED".equals(status);

                    request.setAttribute("canRequestEdit", canRequestEdit);
                    request.setAttribute("canCustomerCheck", canCustomerCheck);
                    request.setAttribute("isApproved", isApproved);

                    request.getRequestDispatcher("views/contract/detail.jsp")
                            .forward(request, response);
                } else {
                    response.sendRedirect("contract-list");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("contract-list");
            }
        } else {
            response.sendRedirect("contract-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // 1. Khai báo các biến cần thiết từ Session/Request
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Nếu user chưa đăng nhập, redirect về trang login
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        int contractId = Integer.parseInt(request.getParameter("contractId"));

        // Lấy object Contract hiện tại để biết trạng thái cũ
        Contract contract = contractService.getContractById(contractId);
        if (contract == null) {
            response.sendRedirect("contract-list");
            return;
        }

        // 2. Xử lý các Action từ contract list
        if ("request_edit".equals(action)) {
            String[] types = request.getParameterValues("revision_type[]");
            String[] details = request.getParameterValues("revision_detail[]");

            // Tạo history record
            ContractHistory h = new ContractHistory();
            h.setContractId(contractId);
            h.setFromStatus(contract.getContractStatus());
            h.setToStatus("PENDING_REVIEW");
            h.setChangedBy(user.getUserId());
            int historyId = contractService.insertHistory(h);

            if (types != null && historyId > 0) {
                for (int i = 0; i < types.length; i++) {

                    if (types[i] == null || types[i].trim().isEmpty()) {
                        continue;
                    }
                    ContractRevisionItem item = new ContractRevisionItem();
                    item.setHistoryId(historyId);
                    item.setContractId(contractId);
                    item.setRevisionType(types[i]);
                    item.setRevisionDetail(details[i]);
                    contractService.insertRevisionItem(item);
                }
            }

            // Cập nhật status hợp đồng
            contractService.updateStatus(contractId, "PENDING_REVIEW");
            response.sendRedirect("contract-detail?id=" + contractId);

        } else if ("approve".equals(action)) {
            // Manager Approve: Chuyển sang cho khách hàng kiểm tra
            contractService.updateStatus(contractId, "CUSTOMER_CHECK");

            // Lưu lịch sử
            ContractHistory h = new ContractHistory();
            h.setContractId(contractId);
            h.setFromStatus(contract.getContractStatus());
            h.setToStatus("CUSTOMER_CHECK");
            h.setNote("Manager đã phê duyệt hợp đồng. Chờ khách hàng kiểm tra.");
            h.setChangedBy(user.getUserId());
            contractService.insertHistory(h);

            // TODO: Bổ sung logic gửi Email cho Khách hàng tại đây
            // NotificationService notificationService = new NotificationService();
            // notificationService.sendContractReadyMail(contractId);
            response.sendRedirect("contract-detail?id=" + contractId);

        } else if ("customer_approve".equals(action)) {
            // Khách hàng đồng ý: Chuyển trạng thái sang APPROVED
            contractService.updateStatus(contractId, "APPROVED");

            // Lưu lịch sử
            ContractHistory h = new ContractHistory();
            h.setContractId(contractId);
            h.setFromStatus(contract.getContractStatus());
            h.setToStatus("APPROVED");
            h.setNote("Khách hàng đã đồng ý với các điều khoản hợp đồng.");
            h.setChangedBy(user.getUserId());
            contractService.insertHistory(h);

            response.sendRedirect("contract-detail?id=" + contractId);

        } else if ("send_to_manager".equals(action)) {
            // Cập nhật status
            contractService.updateStatus(contractId, "PENDING_REVIEW");

            // Lưu lịch sử
            ContractHistory h = new ContractHistory();
            h.setContractId(contractId);
            h.setFromStatus(contract.getContractStatus());
            h.setToStatus("PENDING_REVIEW");
            h.setNote("Admin Officer đã chỉnh sửa và gửi lại cho Manager.");
            h.setChangedBy(user.getUserId());
            contractService.insertHistory(h);

            response.sendRedirect("contract-detail?id=" + contractId);

        } else {
            // Action không xác định
            response.sendRedirect("contract-detail?id=" + contractId);
        }
    }
}
