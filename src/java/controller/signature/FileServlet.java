/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.signature;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.nio.file.Files;
import java.util.Base64;
/**
 *
 * @author ADMIN
 */
@WebServlet(name="FileServlet", urlPatterns={"/File"})
public class FileServlet extends HttpServlet {
   


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String fileName = request.getParameter("name");
        File projectFile = new File(new File(getServletContext().getRealPath("/")).getParentFile().getParentFile(), "uploads");
        File dataFile = new File(projectFile, fileName);
        String contentType = getServletContext().getMimeType(fileName);
        response.setContentType(contentType);
        Files.copy(dataFile.toPath(), response.getOutputStream());
    } 



    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}