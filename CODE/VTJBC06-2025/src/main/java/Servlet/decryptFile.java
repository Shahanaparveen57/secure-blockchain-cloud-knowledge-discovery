package Servlet;

import java.io.*;
import java.security.*;
import java.security.spec.*;
import java.sql.*;
import java.util.Base64;
import javax.crypto.*;
import javax.crypto.spec.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import Database.DBConnection;

@WebServlet("/decryptFile")
public class decryptFile extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    	int fid = Integer.parseInt(request.getParameter("fid"));
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("fog_admin") == null) {
            response.sendRedirect("fog_login.jsp");
            return;
        }

        try (Connection con = DBConnection.connect()) {
            PreparedStatement ps = con.prepareStatement(
                    "SELECT file_name, controller_content, judge_content FROM uploaded_files WHERE fid=?");
            ps.setInt(1, fid);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) {
                response.getWriter().println("Content not found");
                return;
            }

            String fileName = rs.getString("file_name");
            String controllerContent = rs.getString("controller_content");
            String judgeContent = rs.getString("judge_content");

            
            StringBuilder sb = new StringBuilder();
            sb.append("Controller Content:\n");
            sb.append(controllerContent).append("\n\n");
            sb.append("Judge Content:\n");
            sb.append(judgeContent).append("\n");

            byte[] contentBytes = sb.toString().getBytes("UTF-8");

            // Send as text file
            response.reset();
            response.setContentType("text/plain");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "_content.txt\"");
            response.setContentLength(contentBytes.length);
            response.getOutputStream().write(contentBytes);
            response.getOutputStream().flush();

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Download failed: " + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}