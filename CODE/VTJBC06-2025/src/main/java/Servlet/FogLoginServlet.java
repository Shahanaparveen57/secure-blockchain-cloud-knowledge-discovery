package Servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class FogLoginServlet
 */
@WebServlet("/FogLoginServlet")
public class FogLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public FogLoginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    private static final String STATIC_USER = "fogadmin";
    private static final String STATIC_PASS = "fog@123";
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
		String userid = request.getParameter("userid");
        String password = request.getParameter("password");

        if (STATIC_USER.equals(userid) && STATIC_PASS.equals(password)) {

            HttpSession session = request.getSession();
            session.setAttribute("fog_admin", userid);

            response.sendRedirect("fog_dashboard.jsp");

        } else {
            request.getSession().setAttribute(
                "msg", "Invalid Fog Admin Credentials"
            );
            response.sendRedirect("fog_login.jsp");
        }

	}

}
