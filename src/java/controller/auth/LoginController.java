package controller.auth;

import service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

import jakarta.servlet.annotation.WebServlet;
import service.AuditLogService;

@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    private final UserService userService = new UserService();
    private static final int MAX_FAILED_ATTEMPTS = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        // If user already logged in, redirect to dashboard
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if (user.getRoleId() == 6) {
                response.sendRedirect(request.getContextPath() + "/product-list");
            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard");
            }
            return;
        }

        request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        HttpSession session = request.getSession();

        // 1. Validate Input
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Username and password cannot be empty.");
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            return;
        }

        // 2. Validate Failed Attempts (Brute-force protection)
        Integer failedAttempts = (Integer) session.getAttribute("failedAttempts");
        if (failedAttempts == null) {
            failedAttempts = 0;
        }

        if (failedAttempts >= MAX_FAILED_ATTEMPTS) {
            request.setAttribute("error", "Too many failed attempts. Please try again later or contact support.");
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            return;
        }

        // 3. Check for BAN status
        User user = userService.findUserByUsername(username);
        if (user != null) {
            if ("INACTIVE".equals(user.getStatus())) {
                request.setAttribute("error", "Your account has been locked by the administrator.");
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
                return;
            }
        } else {
            // User does not exist, treat as invalid login
            request.setAttribute("error", "Invalid username or password.");
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            return;
        }

        // 4. Authenticate User
        User authenticatedUser = userService.login(username, password);
        if (authenticatedUser != null) {
            // Login Success: Reset attempts and set user session
            session.setAttribute("failedAttempts", 0);
            session.setAttribute("user", authenticatedUser);
            AuditLogService.log(user.getUserId(), "LOGIN", "Auth", authenticatedUser.getUserName() + " vừa đăng nhập  vào hệ thống");
            if (authenticatedUser.getRoleId() == 6) {
                response.sendRedirect(request.getContextPath() + "/product-list");
            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard");
            }
            return;
        } else {
            // Login Failed: Increment attempts
            failedAttempts++;
            session.setAttribute("failedAttempts", failedAttempts);
            int attemptsLeft = MAX_FAILED_ATTEMPTS - failedAttempts;
            request.setAttribute("error", "Invalid username or password. Attempts left: " + attemptsLeft);
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
        }
    }
}
