<%@ page import="java.sql.*" %>
<%@ page import="Database.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin | File Graphs</title>

<link rel="stylesheet"
 href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

<style>
/* FULL BACKGROUND */
body {
    font-family: 'Segoe UI', sans-serif;
    background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
    min-height: 100vh;
    margin: 0;
    padding: 0;
    color: #fff;
}

/* NAVBAR */
.navbar {
    background: rgba(0,0,0,0.75);
}

.navbar .nav-link {
    color: #fff !important;
    font-weight: 500;
}

/* PAGE TITLE */
.page-title {
    margin-top: 30px;
    margin-bottom: 25px;
    text-align: center;
}

/* TABLE CARD */
.table-card {
    background: rgba(255,255,255,0.96);
    color: #000;
    border-radius: 18px;
    padding: 25px;
    box-shadow: 0 15px 35px rgba(0,0,0,0.3);
}

/* TABLE STYLE */
.table thead {
    background: linear-gradient(135deg, #203a43, #2c5364);
    color: #fff;
}

.table tbody tr:hover {
    background-color: #f1f5f9;
    transition: 0.2s;
}

.btn-view {
    border-radius: 20px;
    padding: 6px 18px;
    font-weight: 600;
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
<div class="container page-title">
    <h2>Uploaded Files  Graphical View</h2>
    <p>Select a file to view Fog Node Hash Distribution</p>
</div>

<!-- TABLE SECTION -->
<div class="container mb-5">
    <div class="table-card">

        <table class="table table-bordered table-hover text-center">
            <thead>
                <tr>
                    <th>#</th>
                    <th>File Name</th>
                    <th>Graph Action</th>
                </tr>
            </thead>
            <tbody>

<%
Connection con = DBConnection.connect();
PreparedStatement ps = con.prepareStatement(
    "SELECT fid, file_name FROM uploaded_files"
);
ResultSet rs = ps.executeQuery();
int count = 1;

while (rs.next()) {
%>
                <tr>
                    <td><%= count++ %></td>
                    <td><%= rs.getString("file_name") %></td>
                    <td>
                        <a href="file_hash_pie.jsp?fid=<%= rs.getInt("fid") %>"
                           class="btn btn-primary btn-view">
                            View Hash Pie
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
