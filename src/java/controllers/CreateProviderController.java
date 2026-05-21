package controllers;

import dao.ProviderDAO;
import dao.CustomerDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.User;
import models.Provider;

public class CreateProviderController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CustomerDAO dao = new CustomerDAO();
        List<User> users = dao.getAllUsers();
        Integer providerRoleId = dao.getRoleIdByName("Provider");
        request.setAttribute("users", users);
        request.setAttribute("providerRoleId", providerRoleId);
        request.getRequestDispatcher("views/CreateProvider.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String userName = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String status = request.getParameter("status");
        String providerName = request.getParameter("providerName");
        String taxCode = request.getParameter("taxCode");
        String roleIdValue = request.getParameter("roleId");

        CustomerDAO cdao = new CustomerDAO();
        List<User> users = cdao.getAllUsers();
        Integer providerRoleId = cdao.getRoleIdByName("Provider");
        request.setAttribute("users", users);
        request.setAttribute("providerRoleId", providerRoleId);

        if (userName == null || userName.isBlank() || password == null || password.isBlank() || email == null || email.isBlank() || providerName == null || providerName.isBlank()) {
            request.setAttribute("error", "Create failed");
            request.getRequestDispatcher("views/CreateProvider.jsp").forward(request, response);
            return;
        }

        try {
            Integer roleId = providerRoleId != null ? providerRoleId : Integer.parseInt(roleIdValue);

            User user = new User();
            user.setUserName(userName);
            user.setPassword(password);
            user.setEmail(email);
            user.setFullName(fullName);
            user.setPhone(phone);
            user.setStatus(status != null && !status.isBlank() ? status : "Active");
            user.setRoleId(roleId);

            Provider provider = new Provider();
            provider.setProviderName(providerName);
            provider.setTaxCode(taxCode);

            ProviderDAO pdao = new ProviderDAO();
            Provider created = pdao.createUserAndProvider(user, provider);
            if (created == null || created.getProviderId() <= 0) {
                request.setAttribute("error", "Create failed");
            } else {
                request.setAttribute("success", "Create successful");
            }
        } catch (NumberFormatException ex) {
            request.setAttribute("error", "Create failed");
            request.setAttribute("errorDetail", ex.getMessage());
        }

        request.getRequestDispatcher("views/CreateProvider.jsp").forward(request, response);
    }
}
