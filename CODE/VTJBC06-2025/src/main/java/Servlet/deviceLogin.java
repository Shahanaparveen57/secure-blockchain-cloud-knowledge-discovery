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
import javax.servlet.http.HttpSession;

import Database.DBConnection;
import Util.PasswordUtil;

@WebServlet("/deviceLogin")
public class deviceLogin extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        String hash = PasswordUtil.hashPassword(password);

        try {
            Connection con = DBConnection.connect();
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM devices WHERE email=? AND password_hash=? AND status='APPROVED'"
            );

            ps.setString(1, email);
            ps.setString(2, hash);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // ✅ CREATE SESSION
                HttpSession session = request.getSession();
                session.setAttribute("device_email", email);

                response.sendRedirect("device_dashboard.jsp");
            } else {
                response.sendRedirect("device_login.jsp?msg=Invalid Credentials or Not Approved");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
