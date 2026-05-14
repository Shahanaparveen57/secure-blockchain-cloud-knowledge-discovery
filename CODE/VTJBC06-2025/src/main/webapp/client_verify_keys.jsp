<%@ page import="java.sql.*" %>
<%@ page import="Database.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Download Shared File</title>

<!-- Bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<script>
function loadKeys(shareId) {

    if (!shareId) {
        document.getElementById("public_key").value = "";
        document.getElementById("private_key").value = "";
        return;
    }

    fetch("<%=request.getContextPath()%>/fetchSharedKeys?share_id=" + shareId)
        .then(res => res.json())
        .then(data => {
            if (data.public_key) {
                document.getElementById("public_key").value = data.public_key;
                document.getElementById("private_key").value = data.private_key;
            } else {
                alert("Keys not found");
            }
        })
        .catch(err => {
            console.error(err);
            alert("Error loading keys");
        });
}
</script>

<style>
/* ================= BACKGROUND ================= */
body {
    min-height: 100vh;
    background: linear-gradient(270deg, #0f2027, #203a43, #2c5364, #1a2980);
    background-size: 600% 600%;
    animation: gradientBG 15s ease infinite;
    color: white;
    font-family: 'Segoe UI', sans-serif;
    margin: 0;
}

@keyframes gradientBG {
    0% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
    100% { background-position: 0% 50%; }
}

/* ================= SIDEBAR ================= */
.sidebar {
    width: 260px;
    position: fixed;
    top: 0;
    left: 0;
    height: 100vh;
    background: rgba(0,0,0,0.75);
    backdrop-filter: blur(12px);
    padding: 30px 20px;
    box-shadow: 4px 0 20px rgba(0,0,0,0.7);
}

.sidebar h4 {
    color: #00e5ff;
    text-align: center;
    margin-bottom: 35px;
    font-weight: 700;
    letter-spacing: 1px;
}

.sidebar a {
    display: block;
    color: #ddd;
    padding: 12px 18px;
    border-radius: 12px;
    margin-bottom: 10px;
    text-decoration: none;
    font-weight: 600;
    transition: 0.3s;
}

.sidebar a:hover,
.sidebar a.active {
    background: linear-gradient(135deg, #00e5ff, #1de9b6);
    color: #000;
}

.sidebar a.logout {
    background: linear-gradient(135deg, #ff5252, #ff1744);
    color: white;
}

.sidebar a.logout:hover {
    background: #ff1744;
}

/* ================= MAIN CONTENT ================= */
.main-content {
    margin-left: 280px;
    padding: 60px 30px;
}

/* GLASS CONTAINER */
.container-box {
    max-width: 600px;
    margin: auto;
    background: rgba(255,255,255,0.12);
    backdrop-filter: blur(14px);
    border-radius: 20px;
    padding: 40px;
    box-shadow: 0 15px 35px rgba(0,0,0,0.6);
    animation: fadeIn 1s ease;
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(15px); }
    to { opacity: 1; transform: translateY(0); }
}

/* TITLE */
h2 {
    text-align: center;
    margin-bottom: 30px;
    font-weight: 700;
}

/* FORM */
label {
    font-weight: 600;
}

textarea {
    resize: none;
    font-size: 12px;
}

/* BUTTON */
.btn-download {
    background: linear-gradient(135deg, #00b894, #009170);
    color: white;
    font-weight: 700;
    border-radius: 25px;
    padding: 10px;
    transition: 0.3s;
    box-shadow: 0 5px 15px rgba(0,0,0,0.4);
}

.btn-download:hover {
    background: #009170;
    transform: scale(1.05);
    color: white;
}
</style>
</head>

<body>

<!-- 🔷 SIDEBAR -->
<div class="sidebar">
    <h4> Client Panel</h4>

    <a href="client_dashboard.jsp"> Home</a>
    <a href="client_files.jsp"> View Shared Files</a>
    <a href="ClientViewKeys.jsp" > Client View Data</a>
    <a href="client_verify_keys.jsp" class="active"> Verify Data & Download</a>
    <a href="index.jsp" class="logout"> Logout</a>
</div>

<!-- 🔷 MAIN CONTENT -->
<div class="main-content">

    <div class="container-box">

        <h2> Download Shared File</h2>

        <form action="verifyKeys" method="post">

            <!-- FILE DROPDOWN -->
            <div class="mb-3">
                <label>Select File</label>
                <select name="share_id" class="form-control" required
                        onchange="loadKeys(this.value)">
                    <option value="">-- Select File --</option>

                    <%
                    String email = (String) session.getAttribute("client_email");
                    Connection con = DBConnection.connect();

                    PreparedStatement ps = con.prepareStatement(
                        "SELECT share_id, file_name FROM shared_keys WHERE client_email=?"
                    );
                    ps.setString(1, email);
                    ResultSet rs = ps.executeQuery();

                    while (rs.next()) {
                    %>
                    <option value="<%=rs.getInt("share_id")%>">
                        <%=rs.getString("file_name")%>
                    </option>
                    <%
                    }
                    %>
                </select>
            </div>

            <!-- PUBLIC KEY -->
            <div class="mb-3">
                <label>Public Key</label>
                <textarea id="public_key" name="public_key"
                          class="form-control" rows="4" readonly></textarea>
            </div>

            <!-- PRIVATE KEY -->
            <div class="mb-4">
                <label>Private Key</label>
                <textarea id="private_key" name="private_key"
                          class="form-control" rows="4" readonly></textarea>
            </div>

            <button type="submit" class="btn btn-download w-100">
                 Verify & Download File
            </button>

        </form>

    </div>

</div>

</body>
</html>
