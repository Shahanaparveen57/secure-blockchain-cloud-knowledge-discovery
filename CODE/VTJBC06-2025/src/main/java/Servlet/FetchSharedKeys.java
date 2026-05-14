package Servlet;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import Database.DBConnection;

@WebServlet("/fetchSharedKeys")
public class FetchSharedKeys extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        try {
            int shareId = Integer.parseInt(request.getParameter("share_id"));

            Connection con = DBConnection.connect();
            PreparedStatement ps = con.prepareStatement(
                "SELECT public_key, private_key FROM shared_keys WHERE share_id=?"
            );
            ps.setInt(1, shareId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String pub = rs.getString("public_key");
                String priv = rs.getString("private_key");

                pub = pub.replace("\\", "\\\\")
                         .replace("\"", "\\\"")
                         .replace("\n", "\\n");

                priv = priv.replace("\\", "\\\\")
                           .replace("\"", "\\\"")
                           .replace("\n", "\\n");

                out.print("{\"public_key\":\"" + pub +
                          "\",\"private_key\":\"" + priv + "\"}");
            } else {
                out.print("{}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{}");
        }
    }
}
