<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="Database.DBConnection" %>

<%
    String fidParam = request.getParameter("fid");

    // --- Strong validation ---
    if (fidParam == null || fidParam.trim().equals("")) {
        out.println("<h3 style='color:red;text-align:center'>Invalid File ID (missing)</h3>");
        return;
    }

    fidParam = fidParam.trim();

    int fid = 0;
    try {
        fid = Integer.parseInt(fidParam);
    } catch (Exception e) {
        out.println("<h3 style='color:red;text-align:center'>Invalid File ID (not numeric)</h3>");
        return;
    }

    List<String> fogNodes = new ArrayList<String>();
    List<String> hashes = new ArrayList<String>();

    String fileName = "";
    Timestamp uploadTime = null;

    Connection con = null;

    try {
        con = DBConnection.connect();

        // --- Fetch file details ---
        PreparedStatement psFile = con.prepareStatement(
            "SELECT file_name, uploaded_at FROM uploaded_files WHERE fid=?"
        );
        psFile.setInt(1, fid);
        ResultSet rsFile = psFile.executeQuery();

        if (rsFile.next()) {
            fileName = rsFile.getString("file_name");
            uploadTime = rsFile.getTimestamp("uploaded_at");
        } else {
            out.println("<h3 style='color:red;text-align:center'>File not found</h3>");
            return;
        }

        // --- Fetch blockchain logs ---
        PreparedStatement ps = con.prepareStatement(
            "SELECT fog_node, file_hash FROM blockchain_logs WHERE fid=?"
        );
        ps.setInt(1, fid);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            fogNodes.add(rs.getString("fog_node"));
            hashes.add(rs.getString("file_hash"));
        }

    } catch (Exception e) {
        out.println("<h3 style='color:red;text-align:center'>Error: " + e.getMessage() + "</h3>");
        return;
    } finally {
        if (con != null) con.close();
    }

    // --- Generate IDs safely ---
    String txId = "TX_" + fid + "_" + uploadTime.getTime();
    String scId = "SC_" + fid + "_" + hashes.get(0).substring(0, 8);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>File Transaction Graph</title>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<link rel="stylesheet"
      href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

<style>
    body { background:#f4f6f9; font-family: Arial; }
    .card {
        border-radius: 14px;
        box-shadow: 0 6px 18px rgba(0,0,0,0.15);
    }
</style>
</head>

<body>

<div class="container mt-5">
    <div class="card p-4">

        <h3 class="text-center text-success">
             Blockchain File Transaction Proof
        </h3>

        <hr>

        <p><b>File Name:</b> <%= fileName %></p>
        <p><b>Transaction ID:</b> <span class="text-primary"><%= txId %></span></p>
        <p><b>Smart Contract ID:</b> <span class="text-danger"><%= scId %></span></p>

        <canvas id="txGraph" height="120"></canvas>

        <hr>

        <h5>Fog Server Hash Proof</h5>
        <table class="table table-bordered mt-3">
            <thead class="thead-dark">
                <tr>
                    <th>Fog Server</th>
                    <th>SHA-256 Hash</th>
                </tr>
            </thead>
            <tbody>
            <%
                for (int i = 0; i < fogNodes.size(); i++) {
            %>
                <tr>
                    <td><%= fogNodes.get(i) %></td>
                    <td style="word-break: break-all;"><%= hashes.get(i) %></td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>

        <div class="text-center mt-4">
            <a href="device_dashboard.jsp" class="btn btn-primary">
                Back to Dashboard
            </a>
        </div>

    </div>
</div>

<script>
var labels = [
    "Device Upload",
    "File Encrypted"
    <% for (int i = 0; i < fogNodes.size(); i++) { %>
        , "<%= fogNodes.get(i) %>"
    <% } %>
];

var ctx = document.getElementById("txGraph").getContext("2d");

new Chart(ctx, {
    type: "line",
    data: {
        labels: labels,
        datasets: [{
            label: "Transaction Flow",
            data: (function () {
                var arr = [];
                for (var i = 1; i <= labels.length; i++) arr.push(i);
                return arr;
            })(),
            tension: 0.4,
            pointRadius: 6,
            pointHoverRadius: 8,
            fill: false
        }]
    },
    options: {
        scales: {
            y: { display: false }
        }
    }
});
</script>

</body>
</html>
