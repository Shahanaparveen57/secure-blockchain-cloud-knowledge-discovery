<%@ page import="java.sql.*" %>
<%@ page import="Database.DBConnection" %>

<%
    // Owner login check
    if (session.getAttribute("device_email") == null) {
        response.sendRedirect("device_login.jsp");
        return;
    }

    String ownerEmail = session.getAttribute("device_email").toString();

    Connection con = DBConnection.connect();

    PreparedStatement ps = con.prepareStatement(
        "SELECT ar.request_id, uf.file_name, ar.session_id, ar.requested_at " +
        "FROM access_requests ar " +
        "JOIN uploaded_files uf ON ar.fid = uf.fid " +
        "WHERE uf.device_email = ? AND ar.status = 'PENDING'"
    );

    ps.setString(1, ownerEmail);
    ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
<title>Fog Access Requests</title>

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

thead{
    background: rgba(0,0,0,0.6);
}

.btn-approve{
    background: linear-gradient(135deg,#00e5ff,#1de9b6);
    border:none;
    color:#000;
    font-weight:600;
    border-radius:20px;
    padding:6px 16px;
    transition:0.3s;
}

.btn-approve:hover{
    transform:scale(1.05);
    background:#1de9b6;
}
</style>
</head>

<body>

<!-- SIDEBAR MODULES -->
<div class="sidebar">
    <h4><i class="bi bi-cpu-fill"></i> Device Panel</h4>

    <a href="device_dashboard.jsp"><i class="bi bi-house"></i> Home</a>
    <a href="device_upload_file.jsp"><i class="bi bi-cloud-upload"></i> Upload Sensor Data</a>
    <a href="device_view_files.jsp"><i class="bi bi-folder2-open"></i> View Files</a>
    <a href="DeviceFileApprove.jsp"><i class="bi bi-check2-square"></i> View File Request</a>
    <a href="device_blockchain_logs.jsp"><i class="bi bi-link-45deg"></i> Blockchain Logs</a>
    <a href="owner_requests.jsp" class="active"><i class="bi bi-envelope-check"></i> Fog Requests</a>
    <a href="index.jsp" class="text-danger"><i class="bi bi-box-arrow-right"></i> Logout</a>
</div>

<!-- MAIN CONTENT -->
<div class="main">
    <div class="card main-card p-4">

        <h3 class="text-center title mb-4">
            <i class="bi bi-shield-check"></i> Access Requests for Your Files
        </h3>

        <div class="table-responsive">
        <table class="table table-bordered table-hover align-middle text-center">

            <thead>
                <tr>
                    <th>File Name</th>
                    <th>Session ID</th>
                    <th>Requested At</th>
                    <th>Action</th>
                </tr>
            </thead>

            <tbody>

<%
    boolean hasData = false;

    while (rs.next()) {
        hasData = true;
%>
                <tr>
                    <td><%= rs.getString("file_name") %></td>
                    <td class="text-warning"><%= rs.getString("session_id") %></td>
                    <td><%= rs.getTimestamp("requested_at") %></td>
                    <td>
                        <a href="pproveRequest?request_id=<%= rs.getInt("request_id") %>"
                           class="btn btn-approve btn-sm">
                           <i class="bi bi-check-circle"></i> Approve
                        </a>
                    </td>
                </tr>
<%
    }

    if (!hasData) {
%>
                <tr>
                    <td colspan="4" class="text-center text-muted fw-bold">
                        No pending access requests found
                    </td>
                </tr>
<%
    }
%>

            </tbody>
        </table>
        </div>

    </div>
</div>

</body>
</html>
