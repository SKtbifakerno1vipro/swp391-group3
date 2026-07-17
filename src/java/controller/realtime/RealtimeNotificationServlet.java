package controller.realtime;

import dal.PaymentDAO;
import dal.CustomerDAO;
import dal.ContractDAO;
import model.Payment;
import model.ContractHistory;
import dal.CustomerOrderDAO;
import model.Invoice;
import model.User;
import dto.CustomerDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.List;
import model.ProductReview;
import service.InvoiceService;
import service.ProductReviewService;

@WebServlet(name = "RealtimeNotificationServlet", urlPatterns = {"/realtime/notifications"})
public class RealtimeNotificationServlet extends HttpServlet {

    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final CustomerDAO customerDAO = new CustomerDAO();
    private final ContractDAO contractDAO = new ContractDAO();
    private final InvoiceService iService = new InvoiceService();
    private final CustomerOrderDAO customerOrderDAO = new CustomerOrderDAO();
    private final ProductReviewService reviewService = new ProductReviewService();
    private final dal.QuotationDAO quotationDAO = new dal.QuotationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        response.setContentType("text/event-stream");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-cache");
        response.setHeader("Connection", "keep-alive");

        PrintWriter writer = response.getWriter();
        long startTime = System.currentTimeMillis() - 5000;
        Timestamp lastCheckedPayment = new Timestamp(startTime);
        Timestamp lastCheckedCustomer = new Timestamp(startTime);
        Timestamp lastCheckedInvoice = new Timestamp(startTime);
        Timestamp lastCheckedProductReview = new Timestamp(startTime);


        int lastContractHistoryId = contractDAO.getMaxContractHistoryId();
        int lastQuotationHistoryId = quotationDAO.getMaxQuotationHistoryId();
        System.out.println("[Realtime Servlet] Client connected: " + user.getUserName() + " (Role: " + user.getRoleId() + ")");

        while (!writer.checkError()) {
            int roleId = user.getRoleId();

            // 1. Payments Notifications
            List<Payment> myPayments = paymentDAO.getPaymentsSince(lastCheckedPayment, (roleId == 3 ? user.getUserId() : null));

            for (Payment p : myPayments) {
                boolean shouldNotify = false;
                String type = "success";
                String title = "";
                String msg = "";
                String link = request.getContextPath() + "/payment/detail?id=" + p.getPaymentId();
                String btnText = null;

                double amt = p.getAmount() != null ? p.getAmount().doubleValue() : 0.0;
                String contractNo = p.getContractNumber() != null ? p.getContractNumber() : "";

                // a. Contract Signed (new pending payments)
                if ("PENDING".equals(p.getPaymentStatus())) {
                    if (roleId == 3) {
                        shouldNotify = true;
                        title = "Ký hợp đồng thành công";
                        msg = String.format("Hợp đồng số %s trị giá %,.0f VNĐ vừa được ký.<br>Hãy nhấn vào 'Thanh toán' để hoàn tất thủ tục.", contractNo, amt);
                        btnText = "Thanh toán";
                    }

                    if (p.getCreatedAt() != null) {
                        Timestamp pTime = Timestamp.valueOf(p.getCreatedAt());
                        if (pTime.after(lastCheckedPayment)) {
                            lastCheckedPayment = pTime;
                        }
                    }
                } // b. Payment Completed
                else if ("COMPLETED".equals(p.getPaymentStatus())) {
                    if (roleId == 3) {
                        shouldNotify = true;
                        title = "Thanh toán thành công";
                        msg = String.format("Bạn đã thanh toán thành công %,.0f VNĐ cho hợp đồng số %s.", amt, contractNo);
                        btnText = "Chi tiết";
                    } else if (roleId == 2 || roleId == 4 || roleId == 5) { // Manager (2), Sale (4), or Admin Officer (5)
                        String name = p.getCustomerName() != null ? p.getCustomerName() : "Khách hàng";
                        shouldNotify = true;
                        title = "Thanh toán thành công";
                        msg = String.format("Khách hàng %s đã thanh toán %,.0f VNĐ cho hợp đồng số %s.", name, amt, contractNo);
                        btnText = "Chi tiết";
                    }

                    if (p.getPaidAt() != null) {
                        Timestamp pTime = Timestamp.valueOf(p.getPaidAt());
                        if (pTime.after(lastCheckedPayment)) {
                            lastCheckedPayment = pTime;
                        }
                    }
                }

                // Chuyển đổi định dạng và gửi đi
                if (shouldNotify) {
                    StringBuilder sb = new StringBuilder();
                    sb.append("{\"type\":\"").append(escapeJson(type)).append("\"");
                    sb.append(",\"title\":\"").append(escapeJson(title)).append("\"");
                    sb.append(",\"message\":\"").append(escapeJson(msg)).append("\"");
                    sb.append(",\"link\":\"").append(escapeJson(link)).append("\"");
                    if (btnText != null) {
                        sb.append(",\"btnText\":\"").append(escapeJson(btnText)).append("\"");
                    }
                    sb.append("}");

                    writer.write("event: notification\n");
                    writer.write("data: " + sb.toString() + "\n\n");
                }
            }

            // 2. Customer Notifications (Admin: 1, Staff: 2)
            if (roleId == 1 || roleId == 2) {
                List<CustomerDTO> newCustomers = customerDAO.getCustomersSince(lastCheckedCustomer);
                for (CustomerDTO c : newCustomers) {
                    boolean shouldNotify = false;
                    String type = "info";
                    String title = "";
                    String msg = "";
                    String link = request.getContextPath() + "/customer/list";

                    if (c.getUser() != null && c.getUser().getCreateAt() != null) {
                        shouldNotify = true;
                        title = "Thành viên mới";
                        String name = c.getUser().getFullName() != null ? c.getUser().getFullName() : "Khách hàng mới";
                        msg = String.format("Khách hàng %s vừa đăng ký tài khoản thành công.", name);

                        Timestamp cTime = Timestamp.valueOf(c.getUser().getCreateAt());
                        if (cTime.after(lastCheckedCustomer)) {
                            lastCheckedCustomer = cTime;
                        }
                    }

                    // Chuyển đổi định dạng và gửi đi
                    if (shouldNotify) {
                        StringBuilder sb = new StringBuilder();
                        sb.append("{\"type\":\"").append(escapeJson(type)).append("\"");
                        sb.append(",\"title\":\"").append(escapeJson(title)).append("\"");
                        sb.append(",\"message\":\"").append(escapeJson(msg)).append("\"");
                        sb.append(",\"link\":\"").append(escapeJson(link)).append("\"");
                        sb.append("}");

                        writer.write("event: notification\n");
                        writer.write("data: " + sb.toString() + "\n\n");
                    }
                }
            }

            // 3. Contract Workflow Notifications
            List<ContractHistory> newHistories = contractDAO.getContractHistoriesSinceId(lastContractHistoryId);
            for (ContractHistory h : newHistories) {
                if (h.getCreatedAt() != null) {
                    boolean shouldNotify = false;
                    String title = "";
                    String msg = "";
                    String link = request.getContextPath() + "/contract-detail?id=" + h.getContractId();

                    // user had just clicked button
                    int changerRole = h.getChangerRoleId();

                    // A. Officer submits to Manager (DRAFT/PENDING_REVIEW -> PENDING_REVIEW by Officer)
                    if ("PENDING_REVIEW".equals(h.getToStatus()) && changerRole == 5) {
                        if (roleId == 2) {
                            shouldNotify = true;
                            title = "Hợp đồng cần duyệt";
                            msg = "Officer vừa gửi hợp đồng " + h.getContractNumber() + " để duyệt.";
                        }
                    } // B. Manager requests edit (-> PENDING_REVIEW by Manager)
                    else if ("PENDING_REVIEW".equals(h.getToStatus()) && changerRole == 2) {
                        if (roleId == 5) {
                            shouldNotify = true;
                            title = "Yêu cầu sửa hợp đồng";
                            msg = "Manager yêu cầu sửa hợp đồng " + h.getContractNumber() + ".";
                        }
                    } // C. Customer requests edit (-> PENDING_REVIEW by Customer)
                    else if ("PENDING_REVIEW".equals(h.getToStatus()) && changerRole == 3) {
                        if (roleId == 2 || roleId == 5) {
                            shouldNotify = true;
                            title = "Khách hàng yêu cầu sửa";
                            msg = "Khách hàng yêu cầu sửa hợp đồng " + h.getContractNumber() + ".";
                        }
                    } // D. Manager approves (-> CUSTOMER_CHECK)
                    else if ("CUSTOMER_CHECK".equals(h.getToStatus())) {
                        if (roleId == 2) {
                            shouldNotify = true;
                            title = "Duyệt thành công";
                            msg = "Đã gửi hợp đồng " + h.getContractNumber() + " cho khách hàng.";
                        } else if (roleId == 3 && user.getUserId() == h.getCustomerUserId()) { // Customer
                            shouldNotify = true;
                            title = "Quý khách có hợp đồng cần xem";
                            msg = "Hợp đồng " + h.getContractNumber() + " đã sẵn sàng. Vui lòng kiểm tra lại thông tin!";
                        }
                    } // E. Customer approves (-> APPROVED )
                    else if ("APPROVED".equals(h.getToStatus()) && changerRole == 3) {
                        if (roleId == 2 || roleId == 5) {
                            shouldNotify = true;
                            title = "Khách hàng đã chốt hợp đồng";
                            msg = "Khách hàng đã chốt " + h.getContractNumber() + ".";
                        }
                    } // F. Customer and Manager signs (-> SIGNED)
                    else if ("SIGNED".equals(h.getToStatus())) {
                        if (roleId == 2 || roleId == 5 || roleId == 6) {
                            shouldNotify = true;
                            title = "Cả hai bên đã ký hợp đồng";
                            msg = "Cả khách hàng và quản lý đã ký hợp đồng " + h.getContractNumber() + " thành công! "
                                    + "Vui lòng chuẩn bị hàng cho khách hàng! ";
                        }
                    }

                    if (shouldNotify) {
                        writer.write("event: notification\n");
                        writer.write("data: {\"type\":\"info\",\"title\":\"" + escapeJson(title)
                                + "\",\"message\":\"" + escapeJson(msg)
                                + "\",\"link\":\"" + escapeJson(link) + "\"}\n\n");
                    }

                    if (h.getHistoryId() > lastContractHistoryId) {
                        lastContractHistoryId = h.getHistoryId();
                    }

                }
            }

            // Quotation Notifications
            List<model.QuotationHistory> newQHistories = quotationDAO.getQuotationHistoriesSinceId(lastQuotationHistoryId);
            for (model.QuotationHistory qh : newQHistories) {
                if (qh.getCreatedAt() != null) {
                    boolean shouldNotify = false;
                    String title = "";
                    String msg = "";
                    String type = "info";
                    String link = request.getContextPath() + "/quotation-detail?id=" + qh.getQuotationId();
                    String btnText = "Xem chi tiết";

                    String editHistory = qh.getEditHistory();
                    if (editHistory != null && editHistory.contains("Cap nhat trang thai thanh: ")) {
                        String newStatus = editHistory.replace("Cap nhat trang thai thanh: ", "").trim();

                        model.Quotation quo = quotationDAO.getQuotationById(qh.getQuotationId());
                        int customerUserId = -1;
                        if (quo != null) {
                            service.CustomerService custSvc = new service.CustomerService();
                            dto.CustomerDTO cDTO = custSvc.getCustomerDTOByCusId(quo.getCustomerId());
                            if (cDTO != null && cDTO.getUser() != null) {
                                customerUserId = cDTO.getUser().getUserId();
                            }
                        }

                        if ("ACCEPTED".equals(newStatus)) {
                            if (roleId == 5) {
                                shouldNotify = true;
                                type = "success";
                                title = "Báo giá được duyệt";
                                msg = "Báo giá #" + qh.getQuotationId() + " đã được Sale duyệt. Hãy tạo Hợp đồng nháp.";
                            } else if (roleId == 3 && user.getUserId() == customerUserId) {
                                shouldNotify = true;
                                type = "success";
                                title = "Báo giá đã chốt";
                                msg = "Báo giá #" + qh.getQuotationId() + " của bạn đã chốt thành công. Hợp đồng sẽ sớm được gửi đến.";
                            }
                        }
                    }

                    if (shouldNotify) {
                        StringBuilder sb = new StringBuilder();
                        sb.append("{\"type\":\"").append(escapeJson(type)).append("\"");
                        sb.append(",\"title\":\"").append(escapeJson(title)).append("\"");
                        sb.append(",\"message\":\"").append(escapeJson(msg)).append("\"");
                        sb.append(",\"link\":\"").append(escapeJson(link)).append("\"");
                        sb.append(",\"btnText\":\"").append(escapeJson(btnText)).append("\"");
                        sb.append("}");

                        writer.write("event: notification\n");
                        writer.write("data: " + sb.toString() + "\n\n");
                    }

                    if (qh.getQuotationHistoryId() > lastQuotationHistoryId) {
                        lastQuotationHistoryId = qh.getQuotationHistoryId();
                    }
                }
            }

            //Invoice Notification - Begin
            List<Invoice> invoiceList = iService.getInvoicesSince(lastCheckedInvoice, (roleId == 3 ? user.getUserId() : null));
            for (Invoice iv : invoiceList) {
                boolean shouldNotify = false;
                String type = "info";
                String title = "";
                String msg = "";
                String link = request.getContextPath() + "/invoice?invoiceId=" + iv.getInvoiceId();
                String btnText = "";

                String status = iv.getInvoiceStatus();

                // A. Nếu là Nhân viên / Quản lý
                if (roleId != 3) {
                    btnText = "Xem chi tiết";
                    if ("UNRELEASED".equals(status)) {
                        shouldNotify = true;
                        title = "Hóa đơn được chỉnh sửa";
                        msg = "Hóa đơn nháp số " + iv.getInvoiceNo() + " vừa được cập nhật.";
                    } else if ("READY".equals(status)) {
                        shouldNotify = true;
                        type = "success";
                        title = "Hóa đơn sẵn sàng";
                        msg = "Hóa đơn cho khách hàng " + iv.getBuyerName() + " đã sẵn sàng gửi.";
                    } else if ("RELEASED".equals(status)) {
                        shouldNotify = true;
                        type = "success";
                        title = "Đã phát hành hóa đơn";
                        msg = "Hóa đơn số " + iv.getInvoiceNo() + " đã được phát hành thành công.";
                    }
                } else {
                    btnText = "Xem hóa đơn";
                    if ("RELEASED".equals(status)) {
                        shouldNotify = true;
                        type = "success";
                        title = "Hóa đơn điện tử mới";
                        msg = "Quý khách có hóa đơn điện tử số " + iv.getInvoiceNo() + " cần xem.";
                    }
                }

                if (shouldNotify) {
                    writer.write("event: notification\n");
                    writer.write("data: {\"type\":\"" + type
                            + "\",\"title\":\"" + escapeJson(title)
                            + "\",\"message\":\"" + escapeJson(msg)
                            + "\",\"link\":\"" + escapeJson(link)
                            + "\",\"btnText\":\"" + escapeJson(btnText) + "\"}\n\n");
                }

                // Cập nhật lại mốc thời gian quét dựa trên thời gian tạo hoặc thời gian phát hành của hóa đơn vừa duyệt qua
                if (iv.getCreatedAt() != null) {
                    Timestamp cTime = Timestamp.valueOf(iv.getCreatedAt());
                    if (cTime.after(lastCheckedInvoice)) {
                        lastCheckedInvoice = new Timestamp(cTime.getTime() + 1000);
                    }
                }
                if (iv.getUpdatedAt() != null) {
                    Timestamp uTime = Timestamp.valueOf(iv.getUpdatedAt());
                    if (uTime.after(lastCheckedInvoice)) {
                        lastCheckedInvoice = new Timestamp(uTime.getTime() + 1000);
                    }
                }
                if (iv.getIssueDate() != null) {
                    Timestamp iTime = Timestamp.valueOf(iv.getIssueDate());
                    if (iTime.after(lastCheckedInvoice)) {
                        lastCheckedInvoice = new Timestamp(iTime.getTime() + 1000);
                    }
                }
            }

            // 5. Product Review Notifications
            List<ProductReview> newReviews = reviewService.getReviewsSince(lastCheckedProductReview, (roleId == 3 ? user.getUserId() : null));
            for (ProductReview pr : newReviews) {
                boolean shouldNotify = false;
                String type = "info";
                String title = "";
                String msg = "";
                String link = "";
                String btnText = "Xem ngay";

                // A. Nếu khách hàng mới gửi đánh giá (chưa phản hồi) -> Báo cho nhân viên (Staff/Manager/Admin)
                if (pr.getRepliedBy() == null) {
                    if (roleId != 3) { // Nhân viên
                        shouldNotify = true;
                        title = "Đánh giá sản phẩm mới";
                        msg = String.format("Khách hàng %s đã đánh giá %d sao cho sản phẩm %s.", 
                                           pr.getCompanyName(), pr.getRating(), pr.getProductName());
                        link = request.getContextPath() + "/product-review";
                    }
                } 
                // B. Nếu nhân viên đã phản hồi đánh giá -> Báo cho chính khách hàng gửi đánh giá đó
                else {
                    if (roleId == 3 && user.getUserId() == pr.getUserId()) { // Đúng khách hàng viết đánh giá
                        shouldNotify = true;
                        type = "success";
                        title = "Phản hồi đánh giá";
                        msg = String.format("Cửa hàng đã phản hồi nhận xét của bạn về sản phẩm %s.", pr.getProductName());
                        link = request.getContextPath() + "/edit-product?id=" + pr.getProductId() + "&action=detail";
                    }
                }

                if (shouldNotify) {
                    writer.write("event: notification\n");
                    writer.write("data: {\"type\":\"" + type
                            + "\",\"title\":\"" + escapeJson(title)
                            + "\",\"message\":\"" + escapeJson(msg)
                            + "\",\"link\":\"" + escapeJson(link)
                            + "\",\"btnText\":\"" + escapeJson(btnText) + "\"}\n\n");
                }

                // Cập nhật lại mốc thời gian quét
                if (pr.getCreatedAt() != null) {
                    Timestamp rTime = new Timestamp(pr.getCreatedAt().getTime());
                    if (rTime.after(lastCheckedProductReview)) {
                        lastCheckedProductReview = new Timestamp(rTime.getTime() + 1000);
                    }
                }
                if (pr.getRepliedAt() != null) {
                    Timestamp repTime = new Timestamp(pr.getRepliedAt().getTime());
                    if (repTime.after(lastCheckedProductReview)) {
                        lastCheckedProductReview = new Timestamp(repTime.getTime() + 1000);
                    }
                }
            }

            writer.flush();
            response.flushBuffer();
            try {
                Thread.sleep(4000);
            } catch (InterruptedException e) {
                break;
            }

        }
        System.out.println("[Realtime Servlet] Connection closed for user: " + user.getUserName());
    }

    private String escapeJson(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
