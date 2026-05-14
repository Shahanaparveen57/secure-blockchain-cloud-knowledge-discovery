package Servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Database.DBConnection;
import Util.PasswordUtil;

/**
 * Servlet implementation class deviceRegister
 */
@WebServlet("/deviceRegister")
public class deviceRegister extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public deviceRegister() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
		 String name = request.getParameter("device_name");
	        String email = request.getParameter("email");
	        String contact = request.getParameter("contact");
	        String location = request.getParameter("location");
	        String password = request.getParameter("password");

	        String hashedPassword = PasswordUtil.hashPassword(password);

	        try {
	            Connection con = DBConnection.connect();
	            PreparedStatement ps = con.prepareStatement(
	                "INSERT INTO devices(device_name,email,contact,location,password_hash,status) VALUES(?,?,?,?,?,?)"
	            );

	            ps.setString(1, name);
	            ps.setString(2, email);
	            ps.setString(3, contact);
	            ps.setString(4, location);
	            ps.setString(5, hashedPassword);
	            ps.setString(6, "PENDING");

	            ps.executeUpdate();
	            response.sendRedirect("device_registered.jsp");

	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    
	}

}
