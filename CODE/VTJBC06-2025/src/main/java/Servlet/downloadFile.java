package Servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import Database.DBConnection;

@WebServlet("/downloadFile")
public class downloadFile extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("client_email") == null) {
            response.sendRedirect("client_login.jsp");
            return;
        }

        int fid = Integer.parseInt(request.getParameter("fid"));
        String mode = request.getParameter("mode"); // enc | dec
        String clientEmail = session.getAttribute("client_email").toString();

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.connect();

            /* =========================
               🔐 ENCRYPTED DOWNLOAD
               ========================= */
            if ("enc".equals(mode)) {

                ps = con.prepareStatement(
                    "SELECT file_name, file_data FROM uploaded_files WHERE fid=?"
                );
                ps.setInt(1, fid);
                rs = ps.executeQuery();

                if (rs.next()) {
                    response.setContentType("application/octet-stream");
                    response.setHeader(
                        "Content-Disposition",
                        "attachment; filename=\"ENC_" + rs.getString("file_name") + "\""
                    );
                    response.getOutputStream().write(rs.getBytes("file_data"));
                } else {
                    response.getWriter().println("Encrypted file not found.");
                }
                return;
            }

            /* =========================
               🔓 DECRYPTED DOWNLOAD (APPROVAL REQUIRED)
               ========================= */
            if ("dec".equals(mode)) {

                PreparedStatement psCheck = con.prepareStatement(
                    "SELECT request_status FROM file_requests " +
                    "WHERE fid=? AND client_email=? " +
                    "ORDER BY requested_at DESC LIMIT 1"
                );
                psCheck.setInt(1, fid);
                psCheck.setString(2, clientEmail);
                ResultSet rsCheck = psCheck.executeQuery();

                if (!rsCheck.next() ||
                    !"APPROVED".equals(rsCheck.getString("request_status"))) {

                    response.getWriter().println("Decryption request not approved.");
                    return;
                }

                ps = con.prepareStatement(
                    "SELECT file_name, file_data FROM uploaded_files WHERE fid=?"
                );
                ps.setInt(1, fid);
                rs = ps.executeQuery();

                if (rs.next()) {

                    byte[] encryptedData = rs.getBytes("file_data");

                    /* 🔐 PLACE YOUR DECRYPTION LOGIC HERE */
                    byte[] decryptedData = encryptedData; 
                    // Example:
                    // decryptedData = AESUtil.decrypt(encryptedData, secretKey);

                    response.setContentType("application/octet-stream");
                    response.setHeader(
                        "Content-Disposition",
                        "attachment; filename=\"" + rs.getString("file_name") + "\""
                    );
                    response.getOutputStream().write(decryptedData);

                } else {
                    response.getWriter().println("Original file not found.");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Server error.");
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}
