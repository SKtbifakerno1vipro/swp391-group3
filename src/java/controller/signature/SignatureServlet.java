package controller.signature;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import service.SignatureService;
import dal.SignatureDAO;
import jakarta.servlet.ServletContext;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileOutputStream;
import java.util.Base64;
import java.util.List;
import model.Signature;
import service.SignatureService;
/**
 *
 * @author ADMIN
 */
@WebServlet(urlPatterns = {"/Signature"})
public class SignatureServlet extends HttpServlet {
    SignatureService sService = new SignatureService();
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet Signature</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Signature at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        SignatureDAO dao = new SignatureDAO();

        List<Signature> list = dao.getAllSignature();

        Signature sigA = dao.getLatestSignatureBySigner("Ben A");
        Signature sigB = dao.getLatestSignatureBySigner("Ben B");
        request.setAttribute("signatures", list);
        request.setAttribute("signatureA", sigA.getFileName());
        
        request.setAttribute("signatureB", sigB.getFileName());
        request.getRequestDispatcher("/views/signature/index.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fileUrlA = request.getParameter("signatureA");
        String fileUrlB = request.getParameter("signatureB");
        File projectPath = new File(getServletContext().getRealPath("/")).getParentFile().getParentFile();
        
        File uploadFile = new File(projectPath, "uploads");
        if (!uploadFile.exists()) {
            uploadFile.mkdir();
        }
        
        SignatureDAO dao = new SignatureDAO();
        if (fileUrlA != null && !fileUrlA.isEmpty()) {
            String nameA = "A_"+System.currentTimeMillis()+".png";
            sService.storeSignature(fileUrlA, uploadFile, nameA);
            Signature s = new Signature();
                s.setFileName(nameA);
                s.setFileUrl( nameA);
                s.setSignerName("Ben A");
                dao.insertSignature(s);
        }
        
        if (fileUrlB != null && !fileUrlB.isEmpty()) {
            String nameB = "B_"+System.currentTimeMillis()+".png";
            sService.storeSignature(fileUrlB, uploadFile, nameB);
            Signature s = new Signature();
                s.setFileName(nameB);
                s.setFileUrl( nameB);
                s.setSignerName("Ben B");
                dao.insertSignature(s);
        }
        response.sendRedirect("Signature");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
