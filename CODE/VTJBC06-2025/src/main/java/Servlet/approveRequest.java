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
 * Servlet implementation class approveRequest
 */
@WebServlet("/approveRequest")
public class approveRequest extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public approveRequest() {
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
		  String requestId = request.getParameter("request_id");
	        String action = request.getParameter("action"); // APPROVED / REJECTED
	        String deviceEmail = (String) request.getSession().getAttribute("device_email");

	        try {
	            Connection con = DBConnection.connect();

	            String sql =
	                "UPDATE file_requests fr " +
	                "JOIN uploaded_files uf ON fr.fid = uf.fid " +
	                "SET fr.request_status = ? " +
	                "WHERE fr.request_id = ? AND uf.device_email = ?";

	            PreparedStatement ps = con.prepareStatement(sql);
	            ps.setString(1, action);
	            ps.setInt(2, Integer.parseInt(requestId));
	            ps.setString(3, deviceEmail);

	            int updated = ps.executeUpdate();

	            if (updated > 0) {
	                response.sendRedirect("DeviceFileApprove.jsp?msg=success");
	            } else {
	                response.sendRedirect("DeviceFileApprove.jsp?msg=unauthorized");
	            }

	        } catch (Exception e) {
	            e.printStackTrace();
	            response.sendRedirect("DeviceFileApprove.jsp?msg=error");
	        }
	
	}

}
