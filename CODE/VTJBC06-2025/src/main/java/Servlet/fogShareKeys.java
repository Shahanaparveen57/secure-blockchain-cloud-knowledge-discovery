package Servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Database.DBConnection;

@WebServlet("/fogShareKeys")
public class fogShareKeys extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int requestId = Integer.parseInt(request.getParameter("request_id"));

        try (Connection con = DBConnection.connect()) {

            PreparedStatement ps1 = con.prepareStatement(
                "SELECT fid, file_name, client_email " +
                "FROM file_requests WHERE request_id=? AND request_status='APPROVED'");
            ps1.setInt(1, requestId);
            ResultSet rs1 = ps1.executeQuery();

            if (!rs1.next()) {
                response.sendRedirect("FogViewRequests.jsp?msg=invalid");
                return;
            }

            int fid = rs1.getInt("fid");
            String fileName = rs1.getString("file_name");
            String clientEmail = rs1.getString("client_email");

            PreparedStatement ps2 = con.prepareStatement(
                "SELECT public_key, private_key FROM uploaded_files WHERE fid=?");
            ps2.setInt(1, fid);
            ResultSet rs2 = ps2.executeQuery();

            if (rs2.next()) {

                PreparedStatement ps3 = con.prepareStatement(
                    "INSERT INTO shared_keys " +
                    "(request_id, fid, file_name, client_email, public_key, private_key) " +
                    "VALUES (?,?,?,?,?,?)");

                ps3.setInt(1, requestId);
                ps3.setInt(2, fid);
                ps3.setString(3, fileName);
                ps3.setString(4, clientEmail);
                ps3.setString(5, rs2.getString("public_key"));
                ps3.setString(6, rs2.getString("private_key"));

                ps3.executeUpdate();
            }

            response.sendRedirect("FogViewRequests.jsp?msg=shared");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("FogViewRequests.jsp?msg=error");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
