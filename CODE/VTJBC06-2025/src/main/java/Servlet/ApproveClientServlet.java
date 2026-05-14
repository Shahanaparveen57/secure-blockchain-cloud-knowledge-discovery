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
 * Servlet implementation class ApproveClientServlet
 */
@WebServlet("/ApproveClientServlet")
public class ApproveClientServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ApproveClientServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub

        int id = Integer.parseInt(request.getParameter("id"));

        try (Connection con = DBConnection.connect()) {

            PreparedStatement ps = con.prepareStatement(
                "UPDATE clients SET status='APPROVED' WHERE client_id=?"
            );
            ps.setInt(1, id);
            ps.executeUpdate();

            response.sendRedirect("client_approval.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
