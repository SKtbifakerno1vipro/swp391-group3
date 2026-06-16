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

@WebServlet("/contract-detail")
public class ContractDetailController extends HttpServlet {

    private ContractDAO contractDAO = new ContractDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");

        if (idStr != null && !idStr.isEmpty()) {
            try {
                int id = Integer.parseInt(idStr);
                Contract contract = contractDAO.getContractById(id);

                if (contract != null) {
                    // Lấy lịch sử phê duyệt để hiển thị trên Dashboard
                    List<ContractHistory> historyList = contractDAO.getHistoriesByContractId(id);
                    request.setAttribute("contract", contract);
                    request.setAttribute("historyList", historyList);

                    // Forward đến detail.jsp (Giao diện Dashboard)
                    request.getRequestDispatcher("views/contract/detail.jsp").forward(request, response);
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
        // Thiết lập Encoding để tránh lỗi font chữ tiếng Việt
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
        Contract contract = contractDAO.getContractById(contractId);
        if (contract == null) {
            response.sendRedirect("contract-list");
            return;
        }

        // 2. Xử lý các Action từ Dashboard
        if ("request_edit".equals(action)) {
            String[] types = request.getParameterValues("revision_type[]");
            String[] details = request.getParameterValues("revision_detail[]");

            // Tạo history record
            ContractHistory h = new ContractHistory();
            h.setContractId(contractId);
            h.setFromStatus(contract.getContractStatus());
            h.setToStatus("PENDING_REVIEW");
            h.setChangedBy(user.getUserId());
            int historyId = contractDAO.insertHistory(h);

            // Lưu các chi tiết (revision items)
            if (types != null && historyId > 0) {
                for (int i = 0; i < types.length; i++) {
                    // Bỏ qua nếu dòng đó trống
                    if (types[i] == null || types[i].trim().isEmpty()) {
                        continue;
                    }
                    ContractRevisionItem item = new ContractRevisionItem();
                    item.setHistoryId(historyId);
                    item.setContractId(contractId);
                    item.setRevisionType(types[i]);
                    item.setRevisionDetail(details[i]);
                    contractDAO.insertRevisionItem(item);
                }
            }

            // Cập nhật status hợp đồng
            contractDAO.updateStatus(contractId, "PENDING_REVIEW");
            response.sendRedirect("contract-detail?id=" + contractId);

        } else if ("approve".equals(action)) {
            // Cập nhật status
            contractDAO.updateStatus(contractId, "PENDING_SIGNATURE");

            // Lưu lịch sử
            ContractHistory h = new ContractHistory();
            h.setContractId(contractId);
            h.setFromStatus(contract.getContractStatus());
            h.setToStatus("PENDING_SIGNATURE");
            h.setNote("Manager đã phê duyệt hợp đồng.");
            h.setChangedBy(user.getUserId());
            contractDAO.insertHistory(h);

            // TODO: Bổ sung logic gửi Email cho Khách hàng tại đây
            // NotificationService notificationService = new NotificationService();
            // notificationService.sendContractReadyMail(contractId);
            response.sendRedirect("contract-detail?id=" + contractId);
        } else if ("send_to_manager".equals(action)) {
            // Cập nhật status
            contractDAO.updateStatus(contractId, "PENDING_REVIEW");

            // Lưu lịch sử
            ContractHistory h = new ContractHistory();
            h.setContractId(contractId);
            h.setFromStatus(contract.getContractStatus());
            h.setToStatus("PENDING_REVIEW");
            h.setNote("Admin Officer đã chỉnh sửa và gửi lại.");
            h.setChangedBy(user.getUserId());
            contractDAO.insertHistory(h);

            response.sendRedirect("contract-detail?id=" + contractId);
        } else {
            // Action không xác định
            response.sendRedirect("contract-detail?id=" + contractId);
        }
    }
}
