package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import models.User;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("views/login.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");

        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();

        User user = dao.login(username, password);

        if (user != null) {

            HttpSession session = request.getSession();

            session.setAttribute("user", user);

            response.sendRedirect("role-list");

        } else {

            request.setAttribute("error",
                    "Invalid username or password");

            request.getRequestDispatcher("views/login.jsp")
                    .forward(request, response);
        }
    }
}