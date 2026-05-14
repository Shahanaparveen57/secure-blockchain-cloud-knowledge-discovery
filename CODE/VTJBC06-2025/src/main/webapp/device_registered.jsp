<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Device Registration Success</title>

<!-- Bootstrap 5 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

<style>
    body{
        background: linear-gradient(135deg,#0f2027,#203a43,#2c5364);
        height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
        font-family: 'Segoe UI', sans-serif;
    }

    .card{
        background: rgba(255,255,255,0.15);
        backdrop-filter: blur(15px);
        border-radius: 20px;
        padding: 40px;
        width: 420px;
        text-align: center;
        color: #fff;
        box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        animation: fadeIn 1s ease-in-out;
    }

    @keyframes fadeIn{
        from{opacity:0; transform: translateY(20px);}
        to{opacity:1; transform: translateY(0);}
    }

    .success-icon{
        font-size: 70px;
        color: #00e676;
        margin-bottom: 20px;
    }

    h3{
        color: #00e5ff;
        margin-bottom: 10px;
        font-weight: 700;
    }

    p{
        color: #e0f7fa;
        margin-bottom: 25px;
    }

    .btn-login{
        background: linear-gradient(135deg,#00e5ff,#1de9b6);
        border: none;
        color: #000;
        padding: 10px 30px;
        border-radius: 25px;
        font-weight: 600;
        text-decoration: none;
        display: inline-block;
        transition: 0.3s;
        box-shadow: 0 4px 10px rgba(0,0,0,0.2);
    }

    .btn-login:hover{
        background: #1de9b6;
        transform: scale(1.05);
    }
</style>
</head>

<body>

<div class="card">
    <div class="success-icon">
        <i class="bi bi-check-circle-fill"></i>
    </div>

    <h3>Device Registered Successfully</h3>
    <p>
        Your device has been registered and is currently  
        <b>pending admin approval</b>.<br>
        You will be able to login once approval is granted.
    </p>

    <a href="device_login.jsp" class="btn-login">
        <i class="bi bi-box-arrow-in-right"></i> Go to Login
    </a>
</div>

</body>
</html>
