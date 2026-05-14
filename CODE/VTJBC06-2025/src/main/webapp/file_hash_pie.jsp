<%@ page import="java.sql.*" %>
<%@ page import="Database.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Fog Hash Pie Chart</title>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<link rel="stylesheet"
 href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

<style>
/* BODY BACKGROUND */
body {
    font-family: 'Segoe UI', sans-serif;
    background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
    min-height: 100vh;
    margin: 0;
    padding: 0;
    color: #fff;
}

/* PAGE TITLE */
.page-title {
    text-align: center;
    margin-top: 30px;
    margin-bottom: 30px;
}

.page-title h2 {
    font-weight: 700;
}

.page-title h4 {
    font-weight: 500;
    opacity: 0.85;
}

/* CARD CONTAINER */
.chart-card {
    max-width: 700px;
    margin: auto;
    background: rgba(255,255,255,0.95);
    color: #000;
    border-radius: 20px;
    padding: 30px;
    box-shadow: 0 12px 25px rgba(0,0,0,0.25);
    transition: transform 0.3s, box-shadow 0.3s;
}

.chart-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 20px 40px rgba(0,0,0,0.35);
}

/* CANVAS */
canvas {
    margin-top: 20px;
}

/* BACK BUTTON */
.btn-back {
    border-radius: 25px;
    padding: 8px 25px;
    font-weight: 600;
    margin-top: 20px;
    display: block;
    margin-left: auto;
    margin-right: auto;
}
</style>
</head>

<body>

<%
    Connection con = DBConnection.connect();

    /* -------- GET LATEST FILE ID -------- */
    int fid = 0;
    String fileName = "";

    PreparedStatement psLatest = con.prepareStatement(
        "SELECT fid, file_name FROM uploaded_files ORDER BY fid DESC LIMIT 1"
    );
    ResultSet rsLatest = psLatest.executeQuery();

    if (rsLatest.next()) {
        fid = rsLatest.getInt("fid");
        fileName = rsLatest.getString("file_name");
    } else {
%>
    <h3 style="color:red;text-align:center;">No files found in database</h3>
</body>
</html>
<%
        return;
    }

    /* -------- GET HASHES FOR THAT FILE -------- */
    PreparedStatement ps = con.prepareStatement(
        "SELECT fog_node, file_hash FROM blockchain_logs WHERE fid=?"
    );
    ps.setInt(1, fid);
    ResultSet rs = ps.executeQuery();

    String labels = "";
    String tooltips = "";
    String values = "";
    boolean hasData = false;

    while (rs.next()) {
        hasData = true;
        String fog = rs.getString("fog_node");
        String hash = rs.getString("file_hash");

        labels += "'" + fog + "',";
        values += "1,";
        tooltips += "'File: " + fileName + "\\nFog Node: " + fog + "\\nHash: " + hash + "',";
    }

    if (!hasData) {
%>
    <h3 style="color:red;text-align:center;">No blockchain hashes found for file: <%= fileName %></h3>
</body>
</html>
<%
        return;
    }

    labels = labels.substring(0, labels.length() - 1);
    values = values.substring(0, values.length() - 1);
    tooltips = tooltips.substring(0, tooltips.length() - 1);
%>

<div class="container page-title">
    <h2>Fog Node Hash Distribution</h2>
    <h4>File: <%= fileName %> (ID: <%= fid %>)</h4>
</div>

<div class="chart-card">
    <canvas id="pieChart"></canvas>
    <a href="file_graph.jsp" class="btn btn-primary btn-back">Back to Files</a>
</div>

<script>
    const tooltipData = [<%= tooltips %>];

    new Chart(document.getElementById("pieChart"), {
        type: 'pie',
        data: {
            labels: [<%= labels %>],
            datasets: [{
                data: [<%= values %>],
                backgroundColor: [
                    '#FF6384',
                    '#36A2EB',
                    '#FFCE56',
                    '#4BC0C0',
                    '#9966FF',
                    '#FF9F40'
                ]
            }]
        },
        options: {
            plugins: {
                tooltip: {
                    callbacks: {
                        label: function(ctx) {
                            return tooltipData[ctx.dataIndex];
                        }
                    }
                },
                legend: {
                    position: 'bottom'
                }
            }
        }
    });
</script>

</body>
</html>
