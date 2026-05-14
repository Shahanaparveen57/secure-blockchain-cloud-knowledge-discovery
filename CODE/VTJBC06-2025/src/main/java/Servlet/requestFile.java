package Servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Database.DBConnection;

@WebServlet("/requestFile")
public class requestFile extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

       
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("fog_login.jsp");
            return;
        }

        // ✅ ONLY session id
        String sessionId = session.getId();

        String fidParam = request.getParameter("fid");
        if (fidParam == null) {
            response.getWriter().println("Invalid request");
            return;
        }

        int fid = Integer.parseInt(fidParam);

        try (Connection con = DBConnection.connect()) {

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO access_requests (fid, session_id) VALUES (?, ?)");

            ps.setInt(1, fid);
            ps.setString(2, sessionId);
            ps.executeUpdate();

            response.getWriter().println("Access request sent successfully.");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Database error");
        }
    }
}
