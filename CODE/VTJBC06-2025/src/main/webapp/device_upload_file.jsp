<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
    if (session.getAttribute("device_email") == null) {
        response.sendRedirect("device_login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Device Dashboard | Upload Sensor Data</title>

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
        width: 270px;
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
        font-size: 15px;
    }

    .sidebar a:hover,
    .sidebar a.active{
        background: #00e5ff;
        color: #000;
        font-weight: 600;
    }

    /* Content */
    .content{
        margin-left: 290px;
        padding: 40px;
    }

    .card{
        background: rgba(255,255,255,0.15);
        backdrop-filter: blur(15px);
        border-radius: 20px;
        border: none;
        color: #fff;
        max-width: 600px;
        margin: auto;
        box-shadow: 0 10px 30px rgba(0,0,0,0.3);
    }

    label{
        font-weight: 600;
        color: #e0f7fa;
    }

    .form-control{
        background: rgba(255,255,255,0.2);
        border: none;
        color: #fff;
    }

    .form-control::placeholder{
        color: #cfd8dc;
    }

    .btn-upload{
        background: linear-gradient(135deg,#00e5ff,#1de9b6);
        border: none;
        color: #000;
        font-weight: 600;
        border-radius: 25px;
        padding: 10px 30px;
        transition: 0.3s;
        box-shadow: 0 4px 10px rgba(0,0,0,0.2);
    }

    .btn-upload:hover{
        background: #1de9b6;
        transform: scale(1.05);
    }
</style>
</head>

<body>

<!-- SIDEBAR -->
<div class="sidebar">
    <h4><i class="bi bi-cpu-fill"></i> Device Panel</h4>

    <a href="device_dashboard.jsp"><i class="bi bi-house"></i> Home</a>
    <a href="device_upload_file.jsp" class="active"><i class="bi bi-cloud-upload"></i> Upload Sensor Data</a>
    <a href="device_view_files.jsp"><i class="bi bi-folder2-open"></i> View Files</a>
    <a href="DeviceFileApprove.jsp"><i class="bi bi-check2-square"></i> View File Request</a>
    <a href="device_blockchain_logs.jsp"><i class="bi bi-link-45deg"></i> Blockchain Logs</a>
    <a href="owner_requests.jsp"><i class="bi bi-envelope-check"></i> Fog Requests</a>
    <a href="index.jsp" class="text-danger"><i class="bi bi-box-arrow-right"></i> Logout</a>
</div>

<!-- CONTENT -->
<div class="content">
    <div class="card p-4">

        <h3 class="mb-3 text-center">
            <i class="bi bi-cloud-arrow-up-fill"></i> Upload Device Data
        </h3>
        <p class="text-light text-center mb-4">
            secure sensor data upload to fog computing layer
        </p>

        <!-- FORM (LOGIC UNCHANGED) -->
        <form action="uploadFile" method="post" enctype="multipart/form-data">

            <div class="mb-3">
                <label>File Name</label>
                <input type="text" name="file_name" class="form-control" required>
            </div>

            <div class="mb-3">
                <label>Select File</label>
                <input type="file" name="uploadFile" class="form-control" required>
            </div>

            <div class="mb-3">
                <label>Controller Content</label>
                <textarea name="controller_content"
                          rows="4"
                          class="form-control"
                          placeholder="Example: A;B;C;D;E;F"
                          required></textarea>
            </div>

            <div class="text-center mt-4">
                <button type="submit" class="btn btn-upload">
                    <i class="bi bi-upload"></i> Upload Data
                </button>
            </div>

        </form>

    </div>
</div>

</body>
</html>
