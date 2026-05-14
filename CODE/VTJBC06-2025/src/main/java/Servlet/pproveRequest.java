package Servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import Database.DBConnection;

@WebServlet("/pproveRequest")
public class pproveRequest extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Use GET to handle link clicks
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("device_email") == null) {
            response.sendRedirect("device_login.jsp");
            return;
        }

        String ownerEmail = session.getAttribute("device_email").toString();

        // Get request_id from query string
        int requestId = Integer.parseInt(request.getParameter("request_id"));

        try (Connection con = DBConnection.connect()) {

            PreparedStatement ps = con.prepareStatement(
                "UPDATE access_requests ar " +
                "JOIN uploaded_files uf ON ar.fid = uf.fid " +
                "SET ar.status='APPROVED', ar.approved_at=NOW() " +
                "WHERE ar.request_id=? AND uf.device_email=?"
            );

            ps.setInt(1, requestId);
            ps.setString(2, ownerEmail);

            int updated = ps.executeUpdate();

            if (updated > 0) {
                response.sendRedirect("owner_requests.jsp?msg=approved");
            } else {
                response.getWriter().println("Unauthorized approval attempt or request not found");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Approval failed");
        }
    }

    // Optional: forward POST to GET if you want
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
