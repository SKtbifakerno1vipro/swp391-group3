package controller;

import dao.RoleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import models.Role;

public class RoleListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        RoleDAO dao = new RoleDAO();

        List<Role> roleList = dao.getAllRoles();

        request.setAttribute("roleList", roleList);

        request.getRequestDispatcher("views/role-list.jsp")
                .forward(request, response);
    }
}