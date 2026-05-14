<%@ page import="java.sql.*,Database.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session == null || session.getAttribute("fog_admin") == null) {
        response.sendRedirect("fog_login.jsp");
        return;
    }

    String sessionId = session.getId();
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Fog Admin | Approved Files</title>

<!-- Bootstrap 5 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

<style>
    body{
        background: linear-gradient(135deg,#0f2027,#203a43,#2c5364);
        font-family: 'Segoe UI', sans-serif;
        min-height: 100vh;
    }

    /* Sidebar */
    .sidebar{
        width: 260px;
        position: fixed;
        height: 100%;
        background: rgba(255,255,255,0.08);
        backdrop-filter: blur(15px);
        padding: 20px;
    }

    .sidebar h4{
        color: #00e5ff;
        text-align: center;
        margin-bottom: 30px;
    }

    .sidebar a{
        display: block;
        color: #fff;
        padding: 10px 15px;
        margin-bottom: 10px;
        border-radius: 8px;
        text-decoration: none;
        transition: 0.3s;
    }

    .sidebar a:hover,
    .sidebar a.active{
        background: #00e5ff;
        color: #000;
        font-weight: 600;
    }

    /* Content */
    .content{
        margin-left: 280px;
        padding: 30px;
    }

    .card{
        background: rgba(255,255,255,0.15);
        backdrop-filter: blur(15px);
        border-radius: 18px;
        border: none;
        color: #fff;
    }

    table{
        color: #fff;
    }

    thead{
        background: rgba(0,229,255,0.25);
    }

    tbody tr:hover{
        background: rgba(255,255,255,0.1);
        transition: 0.3s;
    }

    .btn-download{
        background: #00e676;
        border: none;
        color: #000;
        font-weight: 600;
        border-radius: 20px;
        padding: 6px 14px;
        font-size: 13px;
    }

    .btn-download:hover{
        background: #1de9b6;
    }
</style>
</head>

<body>

<!-- SIDEBAR -->
<div class="sidebar">
    <h4><i class="bi bi-cloud-lock-fill"></i> Fog Admin</h4>

    <a href="fog_dashboard.jsp"><i class="bi bi-house"></i> Home</a>
    <a href="client_approval.jsp"><i class="bi bi-person-check"></i> Approve Clients</a>
    <a href="manage_fog_nodes.jsp"><i class="bi bi-diagram-3"></i> Manage Fog Nodes</a>
    <a href="FogViewRequests.jsp"><i class="bi bi-key"></i> Key Management</a>
    <a href="ViewAccessLayer.jsp"><i class="bi bi-shield-lock"></i> Access Layer</a>
    <a href="approved_files.jsp" class="active"><i class="bi bi-hdd-network"></i> Approved Devices</a>
    <a href="index.jsp" class="text-danger"><i class="bi bi-box-arrow-right"></i> Logout</a>
</div>

<!-- CONTENT -->
<div class="content">
    <div class="card p-4">
        <h3 class="mb-3">
            <i class="bi bi-check-circle-fill"></i> Approved Files
        </h3>
        <p class="text-light">
            AI-assisted secure access to decrypted files in fog computing layer
        </p>

<%
    try {
        con = DBConnection.connect();
        ps = con.prepareStatement(
            "SELECT u.fid, u.file_name " +
            "FROM uploaded_files u " +
            "JOIN access_requests r ON u.fid = r.fid " +
            "WHERE r.session_id = ? AND r.status = 'APPROVED'"
        );
        ps.setString(1, sessionId);
        rs = ps.executeQuery();
%>

        <table class="table table-borderless align-middle mt-4">
            <thead class="text-center">
                <tr>
                    <th style="width:70%;">File Name</th>
                    <th style="width:30%;">Action</th>
                </tr>
            </thead>

            <tbody>
            <%
                boolean hasData = false;
                while(rs.next()) {
                    hasData = true;
            %>
                <tr>
                    <td>
                        <i class="bi bi-file-earmark-text me-2"></i>
                        <%= rs.getString("file_name") %>
                    </td>
                    <td class="text-center">
                        <a href="decryptFile?fid=<%= rs.getInt("fid") %>" 
                           class="btn btn-download btn-sm">
                           <i class="bi bi-download"></i> Decrypt & Download
                        </a>
                    </td>
                </tr>
            <%  
                } 
                if(!hasData) { 
            %>
                <tr>
                    <td colspan="2" class="text-center text-muted fw-bold">
                        No approved files found
                    </td>
                </tr>
            <%  } %>
            </tbody>
        </table>

<%
    } catch(Exception e) {
        e.printStackTrace();
%>
        <div class="alert alert-danger text-center mt-3">
            Error fetching data: <%= e.getMessage() %>
        </div>
<%
    } finally {
        if(rs != null) try { rs.close(); } catch(Exception e) {}
        if(ps != null) try { ps.close(); } catch(Exception e) {}
        if(con != null) try { con.close(); } catch(Exception e) {}
    }
%>

    </div>
</div>

</body>
</html>
