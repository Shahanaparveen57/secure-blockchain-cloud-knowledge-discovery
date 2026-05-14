<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="Database.DBConnection" %>

<%
    // Session validation
    if (session.getAttribute("device_email") == null) {
        response.sendRedirect("device_login.jsp");
        return;
    }

    String deviceEmail = session.getAttribute("device_email").toString();
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Blockchain Events</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f9;
        }
        table {
            width: 95%;
            margin: 30px auto;
            border-collapse: collapse;
            background: white;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ccc;
            text-align: center;
        }
        th {
            background: #2c3e50;
            color: white;
        }
        tr:nth-child(even) {
            background: #f2f2f2;
        }
        h2 {
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>

<body>

<h2>My Blockchain Event Logs</h2>

<table>
    <tr>
        <th>BC ID</th>
        <th>File ID</th>
        <th>Device Email</th>
        <th>File Hash</th>
        <th>Fog Node</th>
        <th>Timestamp</th>
    </tr>

<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        con = DBConnection.connect();

        // 🔒 FILTER BY DEVICE OWNER
        ps = con.prepareStatement(
            "SELECT * FROM blockchain_logs WHERE device_email=? ORDER BY created_at DESC"
        );
        ps.setString(1, deviceEmail);

        rs = ps.executeQuery();

        boolean hasData = false;

        while (rs.next()) {
            hasData = true;
%>
    <tr>
        <td><%= rs.getInt("bc_id") %></td>
        <td><%= rs.getInt("fid") %></td>
        <td><%= rs.getString("device_email") %></td>
        <td style="word-break: break-all;">
            <%= rs.getString("file_hash") %>
        </td>
        <td><%= rs.getString("fog_node") %></td>
        <td><%= rs.getTimestamp("created_at") %></td>
    </tr>
<%
        }

        if (!hasData) {
%>
    <tr>
        <td colspan="6">No blockchain events found for your account</td>
    </tr>
<%
        }

    } catch (Exception e) {
%>
    <tr>
        <td colspan="6">Error loading blockchain events</td>
    </tr>
<%
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    }
%>

</table>

</body>
</html>
