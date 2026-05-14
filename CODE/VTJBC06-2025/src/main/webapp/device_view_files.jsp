<%@ page import="java.sql.*" %>
<%@ page import="Database.DBConnection" %>

<%
String email = (String) session.getAttribute("device_email");
Connection con = DBConnection.connect();
PreparedStatement ps = con.prepareStatement(
    "SELECT * FROM uploaded_files WHERE device_email=?"
);
ps.setString(1, email);
ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Uploaded Files</title>

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

.file-icon{
    color:#1de9b6;
    margin-right:6px;
}

.empty-text{
    color:#ccc;
    font-weight:600;
}

.btn-back{
    background: linear-gradient(135deg,#00e5ff,#1de9b6);
    border:none;
    color:#000;
    font-weight:600;
    border-radius:25px;
    padding:10px 30px;
    transition:0.3s;
}

.btn-back:hover{
    transform:scale(1.05);
    background:#1de9b6;
}
</style>
</head>

<body>

<!-- DEVICE MODULE SIDEBAR -->
<div class="sidebar">
    <h4><i class="bi bi-cpu-fill"></i> Device Panel</h4>

    <a href="device_dashboard.jsp"><i class="bi bi-house"></i> Home</a>
    <a href="device_upload_file.jsp"><i class="bi bi-cloud-upload"></i> Upload Sensor Data</a>
    <a href="device_view_files.jsp" class="active"><i class="bi bi-folder2-open"></i> View Files</a>
    <a href="DeviceFileApprove.jsp"><i class="bi bi-check2-square"></i> View File Request</a>
    <a href="device_blockchain_logs.jsp"><i class="bi bi-link-45deg"></i> Blockchain Logs</a>
    <a href="owner_requests.jsp"><i class="bi bi-envelope-check"></i> Fog Requests</a>
    <a href="index.jsp" class="text-danger"><i class="bi bi-box-arrow-right"></i> Logout</a>
</div>

<!-- MAIN CONTENT -->
<div class="main">
    <div class="card main-card p-4">

        <h3 class="text-center title mb-4">
            <i class="bi bi-folder-check"></i> Your Uploaded Files
        </h3>

        <div class="table-responsive">
        <table class="table table-bordered table-hover align-middle text-center">

            <thead>
                <tr>
                    <th>File ID</th>
                    <th>File Name</th>
                    <th>Upload Time</th>
                </tr>
            </thead>

            <tbody>
            <%
                boolean found = false;
                while(rs.next()) {
                    found = true;
            %>
                <tr>
                    <td><%=rs.getInt("fid")%></td>
                    <td>
                        <i class="bi bi-file-earmark-text file-icon"></i>
                        <%=rs.getString("file_name")%>
                    </td>
                    <td><%=rs.getTimestamp("uploaded_at")%></td>
                </tr>
            <%
                }
                if(!found){
            %>
                <tr>
                    <td colspan="3" class="empty-text">No files uploaded yet</td>
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
