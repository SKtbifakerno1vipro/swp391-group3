

package filter;




import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;


import model.Account;

public class AdminFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain) throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        // 1️ Chưa login
        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect(req.getContextPath() + "/Login");
            return;
        }

        // 2️ Có login nhưng không phải admin
        Account acc = (Account) session.getAttribute("user");

        if (!acc.getRoleId().equalsIgnoreCase("admin")) {
            res.sendRedirect(req.getContextPath() + "/Login");
            return;
        }

        // 3️ Hợp lệ → đi tiếp
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}