package controller.customerorder;

import dto.CustomerOrderDTO;
import service.CustomerOrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;
import model.Invoice;
import service.InvoiceService;

@WebServlet(name = "CustomerOrderListController", urlPatterns = {"/customer-order-list"})
public class CustomerOrderListController extends HttpServlet {

    private final CustomerOrderService customerOrderService = new CustomerOrderService();
    private final InvoiceService invoiceService = new InvoiceService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("search");
        String keyword = request.getParameter("keyword");
        String pageRaw = request.getParameter("page");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");
        String pagesize = request.getParameter("pagesize");
        // Defaults
        if (sortBy == null || sortBy.isEmpty()) sortBy = "orderId";
        if (sortOrder == null || sortOrder.isEmpty()) sortOrder = "desc";

        int pageIndex = (pageRaw != null && !pageRaw.isEmpty()) ? Integer.parseInt(pageRaw) : 1;
        int pageSize;
        if(pagesize == null || pagesize.isEmpty()){
            pageSize = 10;
        }else{
            pageSize = Integer.parseInt(pagesize);
        }
        List<CustomerOrderDTO> listOrder;
        int totalRecords;
        
        jakarta.servlet.http.HttpSession session = request.getSession();
        model.User currentUser = (model.User) session.getAttribute("user");
        int userId = 0;
        String roleName = "";
        if (currentUser != null) {
            userId = currentUser.getUserId();
            int roleId = currentUser.getRoleId();
            service.RoleService roleService = new service.RoleService();
            model.Role userRole = roleService.getRoleById(roleId);
            roleName = userRole != null ? userRole.getRoleName() : "";
        }

        if ("search".equals(action) && keyword != null && !keyword.trim().isEmpty()) {
            keyword = keyword.trim();           
            listOrder = customerOrderService.searchOrdersByPage(keyword, pageIndex, pageSize, sortBy, sortOrder, userId, roleName);
            totalRecords = customerOrderService.getTotalSearchCount(keyword, userId, roleName);
        } else {
            listOrder = customerOrderService.getOrdersByPage(pageIndex, pageSize, sortBy, sortOrder, userId, roleName);
            totalRecords = customerOrderService.getTotalOrderCount(userId, roleName);
        }
        for (CustomerOrderDTO customerOrderDTO : listOrder) {
            Invoice invoice = null;
            boolean isExistInvoice = false;
            invoice = invoiceService.getInvoiceByOrderId(customerOrderDTO.getCustomerOrder().getCustomerOrderId());
            if (invoice != null){
                isExistInvoice = true;
                if("CANCELED".equals(invoice.getInvoiceStatus())){
                    isExistInvoice = false;
                }
            } 
            customerOrderDTO.getCustomerOrder().setHasInvoice(isExistInvoice);
        }
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        
        
        request.setAttribute("orders", listOrder);
        request.setAttribute("currentPage", pageIndex);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword);
        request.setAttribute("action", action);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);
        request.setAttribute("pagesize", pageSize);

        request.getRequestDispatcher("/views/customer-order/list.jsp").forward(request, response);
    }
}
