package controllers;

import dao.ProviderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.ProviderDetail;

public class ProviderDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            request.setAttribute("error", "Provider id is required.");
            request.getRequestDispatcher("views/ProviderDetail.jsp").forward(request, response);
            return;
        }
        int providerId = Integer.parseInt(idParam);
        ProviderDAO dao = new ProviderDAO();
        ProviderDetail provider = dao.getProviderDetailByProviderId(providerId);
        request.setAttribute("provider", provider);
        request.getRequestDispatcher("views/ProviderDetail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "ProviderDetailController";
    }

}
