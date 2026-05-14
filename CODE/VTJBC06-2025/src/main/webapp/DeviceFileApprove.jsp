<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ page import="java.sql.*" %>
<%@ page import="Database.DBConnection" %>

<%
    // Session check
    String deviceEmail = (String) session.getAttribute("device_email");
    if (deviceEmail == null) {
        response.sendRedirect("device_login.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>File Requests Approval</title>

<!-- Bootstrap 5 -->
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

.badge{
    font-size: 13px;
    padding:6px 12px;
}

.btn-approve{
    background:#1de9b6;
    color:#000;
    border:none;
    font-weight:600;
}

.btn-reject{
    background:#ff5252;
    color:#fff;
    border:none;
    font-weight:600;
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
    <a href="DeviceFileApprove.jsp" class="active"><i class="bi bi-check2-square"></i> View File Request</a>
    <a href="device_blockchain_logs.jsp"><i class="bi bi-link-45deg"></i> Blockchain Logs</a>
    <a href="owner_requests.jsp"><i class="bi bi-envelope-check"></i> Fog Requests</a>
    <a href="index.jsp" class="text-danger"><i class="bi bi-box-arrow-right"></i> Logout</a>
</div>

<!-- MAIN CONTENT -->
<div class="main">
    <div class="card main-card p-4">

        <h3 class="text-center title mb-4">
            <i class="bi bi-shield-check"></i> File Access Requests
        </h3>

        <div class="table-responsive">
        <table class="table table-bordered table-hover align-middle text-center">

            <thead>
                <tr>
                    <th>Request ID</th>
                    <th>File Name</th>
                    <th>Client Email</th>
                    <th>Status</th>
                    <th>Requested At</th>
                    <th>Action</th>
                </tr>
            </thead>

            <tbody>

<%
    try {
        con = DBConnection.connect();

        String sql =
            "SELECT fr.request_id, fr.file_name, fr.client_email, " +
            "fr.request_status, fr.requested_at " +
            "FROM file_requests fr " +
            "JOIN uploaded_files uf ON fr.fid = uf.fid " +
            "WHERE uf.device_email = ?";

        ps = con.prepareStatement(sql);
        ps.setString(1, deviceEmail);
        rs = ps.executeQuery();

        boolean hasData = false;

        while (rs.next()) {
            hasData = true;
%>
                <tr>
                    <td><%= rs.getInt("request_id") %></td>
                    <td><i class="bi bi-file-earmark-text text-info"></i> <%= rs.getString("file_name") %></td>
                    <td><%= rs.getString("client_email") %></td>
                    <td>
                        <span class="badge
                            <%= "APPROVED".equals(rs.getString("request_status")) ? "bg-success" :
                                 "REJECTED".equals(rs.getString("request_status")) ? "bg-danger" :
                                 "bg-warning text-dark" %>">
                            <%= rs.getString("request_status") %>
                        </span>
                    </td>
                    <td><%= rs.getTimestamp("requested_at") %></td>
                    <td>

<%
    if ("PENDING".equals(rs.getString("request_status"))) {
%>
                        <form action="approveRequest" method="post" style="display:inline;">
                            <input type="hidden" name="request_id"
                                   value="<%= rs.getInt("request_id") %>">

                            <button name="action" value="APPROVED"
                                    class="btn btn-approve btn-sm me-1">
                                Approve
                            </button>

                            <button name="action" value="REJECTED"
                                    class="btn btn-reject btn-sm">
                                Reject
                            </button>
                        </form>
<%
    } else {
%>
                        <em class="text-muted">No Action</em>
<%
    }
%>
                    </td>
                </tr>
<%
        }

        if (!hasData) {
%>
                <tr>
                    <td colspan="6" class="text-center text-muted fw-bold">
                        No requests found
                    </td>
                </tr>
<%
        }

    } catch (Exception e) {
        e.printStackTrace();
%>
                <tr>
                    <td colspan="6" class="text-danger text-center fw-bold">
                        Error loading requests
                    </td>
                </tr>
<%
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
