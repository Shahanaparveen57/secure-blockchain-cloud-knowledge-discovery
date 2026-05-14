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

/**
 * Servlet implementation class ClientLoginServlet
 */
@WebServlet("/ClientLoginServlet")
public class ClientLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ClientLoginServlet() {
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
		   String email = request.getParameter("email");
	        String password = request.getParameter("password");

	        try (Connection con = DBConnection.connect()) {

	            PreparedStatement ps = con.prepareStatement(
	                "SELECT * FROM clients WHERE email=? AND password=? AND status='APPROVED'"
	            );

	            ps.setString(1, email);
	            ps.setString(2, password);

	            ResultSet rs = ps.executeQuery();

	            if (rs.next()) {
	                HttpSession session = request.getSession();
	                session.setAttribute("client_email", email);
	                session.setAttribute("client_name", rs.getString("name"));

	                response.sendRedirect("client_dashboard.jsp");

	            } else {
	                request.getSession().setAttribute(
	                    "msg", "Account not approved or invalid login"
	                );
	                response.sendRedirect("client_login.jsp");
	            }

	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	 
	}

}
