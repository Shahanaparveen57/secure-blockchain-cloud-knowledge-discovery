<%@ page import="java.sql.*" %>
<%@ page import="Database.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
<title>Admin | Device Approval</title>

<link rel="stylesheet"
 href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

<style>
/* BODY BACKGROUND */
body {
    font-family: 'Segoe UI', sans-serif;
    background: linear-gradient(135deg, #1f4037, #99f2c8); /* gradient green */
    min-height: 100vh;
    margin: 0;
    padding: 0;
}

/* NAVBAR */
.navbar {
    background: rgba(0,0,0,0.7);
}

.navbar .nav-link {
    color: #fff !important;
    font-weight: 500;
}

/* TITLE */
.page-title {
    margin-top: 30px;
    margin-bottom: 30px;
    text-align: center;
    color: #fff;
}

.page-title h2 {
    font-weight: 700;
}

.page-title p {
    font-size: 16px;
    opacity: 0.9;
}

/* CARD */
.card {
    border-radius: 16px;
    padding: 30px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.2);
    background: rgba(255,255,255,0.95);
}

/* TABLE */
.table th {
    background: linear-gradient(90deg, #0f2027, #203a43, #2c5364);
    color: #fff;
    text-align: center;
}

.table td {
    vertical-align: middle;
    text-align: center;
}

.badge-pending {
    background: #ffc107;
    color: #000;
}

.badge-approved {
    background: #28a745;
}

.btn-approve {
    border-radius: 25px;
    padding: 5px 20px;
    font-weight: 600;
}

/* FOOTER / OPTIONAL SHADOW EFFECT */
.container {
    margin-bottom: 50px;
}
</style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark">
  <div class="container">
    <a class="navbar-brand" href="AdminDashboard.jsp">Admin Panel</a>
    <ul class="navbar-nav ml-auto">
        <li class="nav-item active"><a class="nav-link" href="AdminDashboard.jsp">Home</a></li>
        <li class="nav-item"><a class="nav-link" href="admin_devices.jsp">Approve Devices</a></li>
        <li class="nav-item"><a class="nav-link" href="file_graph.jsp">Graphical Representation</a></li>
        <li class="nav-item"><a class="nav-link" href="index.jsp">Logout</a></li>
    </ul>
  </div>
</nav>

<!-- PAGE TITLE -->
<div class="page-title">
    <h2>Registered Device Management</h2>
    <p>Proof of Authority (PoA)  Secure Device Verification</p>
</div>

<!-- TABLE CARD -->
<div class="container">
<div class="card">

<table class="table table-bordered table-hover">
<tr>
    <th>ID</th>
    <th>Device Name</th>
    <th>Email</th>
    <th>Contact</th>
    <th>Location</th>
    <th>Status</th>
    <th>Action</th>
</tr>

<%
Connection con = DBConnection.connect();
PreparedStatement ps = con.prepareStatement("SELECT * FROM devices");
ResultSet rs = ps.executeQuery();

while(rs.next()) {
    String status = rs.getString("status");
%>
<tr>
    <td><%=rs.getInt("device_id")%></td>
    <td><%=rs.getString("device_name")%></td>
    <td><%=rs.getString("email")%></td>
    <td><%=rs.getString("contact")%></td>
    <td><%=rs.getString("location")%></td>
    <td>
        <span class="badge <%= status.equals("PENDING") ? "badge-pending" : "badge-approved" %>">
            <%= status %>
        </span>
    </td>
    <td>
        <% if(status.equals("PENDING")) { %>
        <form action="approveDevice" method="post">
            <input type="hidden" name="device_id" value="<%=rs.getInt("device_id")%>">
            <button type="submit" class="btn btn-success btn-approve">
                Approve
            </button>
        </form>
        <% } else { %>
            <span class="text-success font-weight-bold"> Approved</span>
        <% } %>
    </td>
</tr>
<% } con.close(); %>

</table>

</div>
</div>

</body>
</html>
