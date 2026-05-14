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

/**
 * Servlet implementation class ClientRegisterServlet
 */
@WebServlet("/ClientRegisterServlet")
public class ClientRegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ClientRegisterServlet() {
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

        String name = request.getParameter("name");
        String contact = request.getParameter("contact");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try (Connection con = DBConnection.connect()) {

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO clients (name, contact, email, password, status) VALUES (?,?,?,?,?)"
            );

            ps.setString(1, name);
            ps.setString(2, contact);
            ps.setString(3, email);
            ps.setString(4, password);   // later you can hash
            ps.setString(5, "PENDING");

            int i = ps.executeUpdate();

            if (i > 0) {
                request.getSession().setAttribute("msg", 
                    "Registration successful! Please wait for admin approval.");
            } else {
                request.getSession().setAttribute("msg", 
                    " Registration failed. Try again.");
            }

            response.sendRedirect("client_register.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("msg", 
                "❌ Error occurred. Email may already exist.");
            response.sendRedirect("client_register.jsp");
        }
    }
}
	
