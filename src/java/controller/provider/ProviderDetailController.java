package controller.provider;
import service.ProviderService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import dto.ProviderDTO;
@WebServlet(name = "ProviderDetailController", urlPatterns = {"/ProviderDetail"})
public class ProviderDetailController extends HttpServlet {
    private final ProviderService providerService = new ProviderService();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            request.setAttribute("error", "Provider id is required.");
            request.getRequestDispatcher("/views/provider/detail.jsp").forward(request, response);
            return;
        }
        int providerId = Integer.parseInt(idParam);
        ProviderDTO provider = providerService.getProviderDTOByProviderId(providerId);
        request.setAttribute("provider", provider);
        request.getRequestDispatcher("/views/provider/detail.jsp").forward(request, response);
    }
}