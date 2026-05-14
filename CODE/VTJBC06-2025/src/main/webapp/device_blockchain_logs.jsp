<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="Database.DBConnection" %>

<%
    // Session check
    if (session.getAttribute("device_email") == null) {
        response.sendRedirect("device_login.jsp");
        return;
    }

    String deviceEmail = session.getAttribute("device_email").toString();
%>

<!DOCTYPE html>
<html>
<head>
<title>My Blockchain Logs</title>

<!-- Bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

<style>
body{
    background: linear-gradient(135deg,#0f2027,#203a43,#2c5364);
    font-family: 'Segoe UI', sans-serif;
    min-height:100vh;
    color:#ffffff;
}

/* SIDEBAR */
.sidebar{
    width:260px;
    position:fixed;
    top:0;
    left:0;
    height:100vh;
    background:#0b1c26;
    padding:25px 15px;
    box-shadow:4px 0 15px rgba(0,0,0,0.5);
}

.sidebar h4{
    color:#00e5ff;
    text-align:center;
    margin-bottom:30px;
    font-weight:700;
}

.sidebar a{
    display:block;
    color:#ddd;
    padding:12px 15px;
    border-radius:10px;
    margin-bottom:8px;
    text-decoration:none;
    font-weight:500;
    transition:0.3s;
}

.sidebar a i{
    margin-right:8px;
    color:#1de9b6;
}

.sidebar a:hover,
.sidebar a.active{
    background: linear-gradient(135deg,#00e5ff,#1de9b6);
    color:#000;
}

/* MAIN */
.main{
    margin-left:280px;
    padding:40px 30px;
}

.main-card{
    background: rgba(255,255,255,0.12);
    backdrop-filter: blur(14px);
    border-radius: 20px;
    border: none;
    box-shadow: 0 12px 30px rgba(0,0,0,0.4);
}

.title{
    color:#00e5ff;
    font-weight:700;
    letter-spacing:1px;
}

table{
    color:#ffffff;
}

thead{
    background: rgba(0,0,0,0.6);
}

.hash{
    word-break: break-all;
    font-size: 13px;
}
</style>
</head>

<body>

<!-- DEVICE MODULE SIDEBAR -->
<div class="sidebar">
    <h4><i class="bi bi-cpu-fill"></i> Device Panel</h4>

    <a href="device_dashboard.jsp"><i class="bi bi-house"></i> Home</a>
    <a href="device_upload_file.jsp"><i class="bi bi-cloud-upload"></i> Upload Sensor Data</a>
    <a href="device_view_files.jsp"><i class="bi bi-folder2-open"></i> View Files</a>
    <a href="DeviceFileApprove.jsp"><i class="bi bi-check2-square"></i> View File Request</a>
    <a href="device_blockchain_logs.jsp" class="active"><i class="bi bi-link-45deg"></i> Blockchain Logs</a>
    <a href="owner_requests.jsp"><i class="bi bi-envelope-check"></i> Fog Requests</a>
    <a href="index.jsp" class="text-danger"><i class="bi bi-box-arrow-right"></i> Logout</a>
</div>

<!-- MAIN CONTENT -->
<div class="main">
    <div class="card main-card p-4">

        <h3 class="text-center title mb-4">
            <i class="bi bi-shield-lock-fill"></i> My Blockchain Event Logs
        </h3>

        <div class="table-responsive">
        <table class="table table-bordered table-hover align-middle text-center">

            <thead>
                <tr>
                    <th>BC ID</th>
                    <th>File ID</th>
                    <th>File Hash</th>
                    <th>Fog Node</th>
                    <th>Timestamp</th>
                </tr>
            </thead>

            <tbody>

<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DBConnection.connect();

        // 🔐 SECURE OWNERSHIP-BASED QUERY (UNCHANGED)
        ps = con.prepareStatement(
            "SELECT b.bc_id, b.fid, b.file_hash, b.fog_node, b.created_at " +
            "FROM blockchain_logs b " +
            "JOIN uploaded_files u ON b.fid = u.fid " +
            "WHERE u.device_email = ? " +
            "ORDER BY b.created_at DESC"
        );
        ps.setString(1, deviceEmail);

        rs = ps.executeQuery();

        boolean hasData = false;

        while (rs.next()) {
            hasData = true;
%>
                <tr>
                    <td><%= rs.getInt("bc_id") %></td>
                    <td><%= rs.getInt("fid") %></td>
                    <td class="hash text-info">
                        <%= rs.getString("file_hash") %>
                    </td>
                    <td><%= rs.getString("fog_node") %></td>
                    <td><%= rs.getTimestamp("created_at") %></td>
                </tr>
<%
        }

        if (!hasData) {
%>
                <tr>
                    <td colspan="5" class="text-center text-muted fw-bold">
                        No blockchain logs found for your uploaded files
                    </td>
                </tr>
<%
        }

    } catch (Exception e) {
%>
                <tr>
                    <td colspan="5" class="text-danger text-center fw-bold">
                        Error loading blockchain logs
                    </td>
                </tr>
<%
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>

            </tbody>
        </table>
        </div>

    </div>
</div>

</body>
</html>
