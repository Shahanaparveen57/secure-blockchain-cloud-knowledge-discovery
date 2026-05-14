package Servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import Database.DBConnection;

@WebServlet("/requestDownload")
public class requestDownload extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("client_email") == null) {
            response.sendRedirect("client_login.jsp");
            return;
        }

        int fid = Integer.parseInt(request.getParameter("fid"));
        String clientEmail = session.getAttribute("client_email").toString();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.connect();

            /* 🔍 FETCH FILE NAME SAFELY FROM uploaded_files */
            ps = con.prepareStatement(
                "SELECT file_name FROM uploaded_files WHERE fid=?"
            );
            ps.setInt(1, fid);
            rs = ps.executeQuery();

            if (!rs.next()) {
                session.setAttribute("msg", "File not found.");
                response.sendRedirect("client_files.jsp");
                return;
            }

            String fileName = rs.getString("file_name");

            rs.close();
            ps.close();

            /* 📥 INSERT REQUEST */
            ps = con.prepareStatement(
                "INSERT INTO file_requests (fid, file_name, client_email, request_status) VALUES (?,?,?,?)"
            );
            ps.setInt(1, fid);
            ps.setString(2, fileName);
            ps.setString(3, clientEmail);
            ps.setString(4, "PENDING");

            ps.executeUpdate();

            session.setAttribute("msg", "Decryption request sent successfully.");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msg", "Failed to send request.");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }

        response.sendRedirect("client_files.jsp");
    }
}
