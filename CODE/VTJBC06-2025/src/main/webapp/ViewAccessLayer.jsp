<%@ page import="java.sql.*,Database.DBConnection" %>
<%
    if (session == null || session.getAttribute("fog_admin") == null) {
        response.sendRedirect("fog_login.jsp");
        return;
    }

    Connection con = DBConnection.connect();
    PreparedStatement ps = con.prepareStatement(
        "SELECT fid, file_name, uploaded_at FROM uploaded_files"
    );
    ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Fog Admin | Available Files</title>

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

    .btn-request{
        background: #00e5ff;
        border: none;
        color: #000;
        font-weight: 600;
        border-radius: 20px;
        padding: 6px 14px;
        font-size: 13px;
    }

    .btn-request:hover{
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
    <a href="approved_files.jsp"><i class="bi bi-hdd-network"></i> Approved Devices</a>
    <a href="index.jsp" class="text-danger"><i class="bi bi-box-arrow-right"></i> Logout</a>
</div>

<!-- CONTENT -->
<div class="content">
    <div class="card p-4">
        <h3 class="mb-3">
            <i class="bi bi-folder2-open"></i> Available Files
        </h3>
        <p class="text-light">
            AI-assisted secure file access control in fog computing environment
        </p>

        <table class="table table-borderless align-middle mt-4">
            <thead>
                <tr>
                    <th>File Name</th>
                    <th>Uploaded At</th>
                    <th>Action</th>
                </tr>
            </thead>

            <tbody>
            <%
                while (rs.next()) {
            %>
                <tr>
                    <td><%= rs.getString("file_name") %></td>
                    <td><%= rs.getTimestamp("uploaded_at") %></td>
                    <td>
                        <form action="requestFile" method="post" class="d-inline">
                            <input type="hidden" name="fid"
                                   value="<%= rs.getInt("fid") %>">
                            <button class="btn btn-request btn-sm">
                                <i class="bi bi-send-check-fill"></i> Request Access
                            </button>
                        </form>
                    </td>
                </tr>
            <%
                }
                con.close();
            %>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
