<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="Database.DBConnection" %>

<%
    String clientEmail = (String) session.getAttribute("client_email");
    if (clientEmail == null) {
        response.sendRedirect("client_login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Client Dashboard - Files</title>

    <!-- Bootstrap CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
/* ================= BACKGROUND ================= */
body {
    min-height: 100vh;
    background: linear-gradient(270deg, #0f2027, #203a43, #2c5364, #1a2980);
    background-size: 600% 600%;
    animation: gradientBG 15s ease infinite;
    color: white;
    font-family: 'Segoe UI', sans-serif;
    margin: 0;
}

@keyframes gradientBG {
    0% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
    100% { background-position: 0% 50%; }
}

/* ================= SIDEBAR ================= */
.sidebar {
    width: 260px;
    position: fixed;
    top: 0;
    left: 0;
    height: 100vh;
    background: rgba(0,0,0,0.75);
    backdrop-filter: blur(12px);
    padding: 30px 20px;
    box-shadow: 4px 0 20px rgba(0,0,0,0.7);
}

.sidebar h4 {
    color: #00e5ff;
    text-align: center;
    margin-bottom: 35px;
    font-weight: 700;
    letter-spacing: 1px;
}

.sidebar a {
    display: block;
    color: #ddd;
    padding: 12px 18px;
    border-radius: 12px;
    margin-bottom: 10px;
    text-decoration: none;
    font-weight: 600;
    transition: 0.3s;
}

.sidebar a:hover,
.sidebar a.active {
    background: linear-gradient(135deg, #00e5ff, #1de9b6);
    color: #000;
}

.sidebar a.logout {
    background: linear-gradient(135deg, #ff5252, #ff1744);
    color: white;
}

.sidebar a.logout:hover {
    background: #ff1744;
}

/* ================= MAIN CONTENT ================= */
.main-content {
    margin-left: 280px;
    padding: 40px 30px;
}

/* GLASS CONTAINER */
.container-box {
    background: rgba(255,255,255,0.12);
    backdrop-filter: blur(14px);
    border-radius: 20px;
    padding: 35px;
    box-shadow: 0 15px 35px rgba(0,0,0,0.6);
    animation: fadeIn 1s ease;
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(15px); }
    to { opacity: 1; transform: translateY(0); }
}

/* TITLE */
h2 {
    text-align: center;
    margin-bottom: 30px;
    font-weight: 700;
    letter-spacing: 1px;
}

/* TABLE */
table {
    background: rgba(255,255,255,0.96);
    border-radius: 14px;
    overflow: hidden;
    color: black;
}

th {
    background: linear-gradient(135deg, #1f3c88, #3a5fd8);
    color: white;
    text-align: center;
    font-weight: 600;
}

td {
    text-align: center;
    vertical-align: middle;
    font-weight: 500;
}

/* BUTTONS */
.btn-custom {
    padding: 7px 18px;
    border-radius: 25px;
    font-size: 14px;
    font-weight: 600;
    transition: 0.3s;
}

.btn-enc {
    background: linear-gradient(135deg, #6c5ce7, #4834d4);
    color: white;
    box-shadow: 0 5px 12px rgba(0,0,0,0.4);
}

.btn-dec {
    background: linear-gradient(135deg, #00b894, #009170);
    color: white;
    box-shadow: 0 5px 12px rgba(0,0,0,0.4);
}

.btn-enc:hover {
    transform: scale(1.05);
    background: #4834d4;
    color: white;
}

.btn-dec:hover {
    transform: scale(1.05);
    background: #009170;
    color: white;
}

/* MESSAGE BOX */
.msg-box {
    background: linear-gradient(135deg, #d4edda, #c3f0d4);
    color: #155724;
    padding: 12px;
    border-radius: 10px;
    margin-bottom: 25px;
    text-align: center;
    font-weight: 600;
    box-shadow: 0 0 12px rgba(0,0,0,0.3);
}
    </style>
</head>

<body>

<!-- 🔷 SIDEBAR -->
<div class="sidebar">
    <h4>🔐 Client Panel</h4>

    <a href="client_dashboard.jsp">🏠 Home</a>
    <a href="client_files.jsp" class="active">📂 View Shared Files</a>
   
    <a href="ClientViewKeys.jsp">🔑 Client View Data</a>
    <a href="client_verify_keys.jsp">⬇️ Verify & Download</a>
    <a href="index.jsp" class="logout">🚪 Logout</a>
</div>

<!-- 🔷 MAIN CONTENT -->
<div class="main-content">

    <div class="container">
        <div class="container-box">

            <h2>📂 Available Files</h2>

            <%
                String msg = (String) session.getAttribute("msg");
                if (msg != null) {
            %>
                <div class="msg-box"><%= msg %></div>
            <%
                    session.removeAttribute("msg");
                }
            %>

            <div class="table-responsive">
            <table class="table table-bordered table-hover">
                <tr>
                    <th>File ID</th>
                    <th>File Name</th>
                    <th>Encrypted Download</th>
                    <th>Decrypted Request</th>
                </tr>

            <%
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    con = DBConnection.connect();
                    ps = con.prepareStatement(
                        "SELECT fid, file_name FROM uploaded_files ORDER BY uploaded_at DESC"
                    );
                    rs = ps.executeQuery();

                    while (rs.next()) {
            %>
                <tr>
                    <td><%= rs.getInt("fid") %></td>
                    <td><%= rs.getString("file_name") %></td>

                    <!-- 🔐 Encrypted download -->
                    <td>
                        <form action="downloadFile" method="get">
                            <input type="hidden" name="fid" value="<%= rs.getInt("fid") %>">
                            <input type="hidden" name="mode" value="enc">
                            <button type="submit" class="btn btn-custom btn-enc">
                                🔐 Download
                            </button>
                        </form>
                    </td>

                    <!-- 🔓 Request decrypted -->
                    <td>
                        <form action="requestDownload" method="post">
                            <input type="hidden" name="fid" value="<%= rs.getInt("fid") %>">
                            <input type="hidden" name="client_email" value="<%= clientEmail %>">
                            <button type="submit" class="btn btn-custom btn-dec">
                                🔓 Request
                            </button>
                        </form>
                    </td>
                </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
            %>
                <tr>
                    <td colspan="4" class="text-danger">Error loading files</td>
                </tr>
            <%
                } finally {
                    try { if (rs != null) rs.close(); } catch (Exception e) {}
                    try { if (ps != null) ps.close(); } catch (Exception e) {}
                    try { if (con != null) con.close(); } catch (Exception e) {}
                }
            %>

            </table>
            </div>

        </div>
    </div>

</div>

</body>
</html>
