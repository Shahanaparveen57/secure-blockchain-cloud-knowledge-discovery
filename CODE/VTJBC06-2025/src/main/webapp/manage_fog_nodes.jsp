<%@ page import="java.sql.*,Database.DBConnection" %>
<%
    if (session == null || session.getAttribute("fog_admin") == null) {
        response.sendRedirect("fog_login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Fog Admin | Manage Fog Nodes</title>

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

    .badge-active{
        background: #00e676;
        color: #000;
    }

    .badge-inactive{
        background: #ff5252;
    }

    .btn-toggle{
        background: #ffc107;
        border: none;
        font-weight: 600;
        color: #000;
    }

    .btn-toggle:hover{
        background: #ffca28;
    }
</style>
</head>

<body>

<!-- SIDEBAR -->
<div class="sidebar">
    <h4><i class="bi bi-cloud-lock-fill"></i> Fog Admin</h4>

    <a href="fog_dashboard.jsp"><i class="bi bi-house"></i> Home</a>
    <a href="client_approval.jsp"><i class="bi bi-person-check"></i> Approve Clients</a>
    <a href="manage_fog_nodes.jsp" class="active"><i class="bi bi-diagram-3"></i> Manage Fog Nodes</a>
    <a href="FogViewRequests.jsp"><i class="bi bi-key"></i> Key Management</a>
    <!-- <a href="blockchainevents.jsp"><i class="bi bi-link-45deg"></i> Blockchain Logs</a> -->
    <a href="ViewAccessLayer.jsp"><i class="bi bi-shield-lock"></i> Access Layer</a>
    <a href="approved_files.jsp"><i class="bi bi-hdd-network"></i> Approved Devices</a>
    <a href="index.jsp" class="text-danger"><i class="bi bi-box-arrow-right"></i> Logout</a>
</div>

<!-- CONTENT -->
<div class="content">
    <div class="card p-4">
        <h3 class="mb-3">
            <i class="bi bi-diagram-3-fill"></i> Fog Node Management
        </h3>
        <p class="text-light">
            AI-assisted fog node control for secure distributed infrastructure
        </p>

        <table class="table table-borderless align-middle mt-4">
            <thead>
                <tr>
                    <th>Fog ID</th>
                    <th>Fog Node Name</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>

            <tbody>
            <%
                Connection con = DBConnection.connect();
                PreparedStatement ps = con.prepareStatement(
                    "SELECT * FROM fog_nodes ORDER BY fog_id"
                );
                ResultSet rs = ps.executeQuery();

                while(rs.next()){
                    String status = rs.getString("status");
            %>
                <tr>
                    <td><%= rs.getInt("fog_id") %></td>
                    <td><%= rs.getString("fog_name") %></td>
                    <td>
                        <span class="badge <%= 
                            status.equalsIgnoreCase("ACTIVE") ? 
                            "badge-active" : "badge-inactive" %>">
                            <%= status %>
                        </span>
                    </td>
                    <td>
                        <a href="toggleFogNode?id=<%= rs.getInt("fog_id") %>"
                           class="btn btn-sm btn-toggle">
                           <i class="bi bi-arrow-repeat"></i> Toggle
                        </a>
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
