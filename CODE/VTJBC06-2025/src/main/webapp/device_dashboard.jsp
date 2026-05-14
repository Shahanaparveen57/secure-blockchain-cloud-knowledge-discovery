<!DOCTYPE html>
<html lang="en">

    <!-- Basic -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">   
   
    <!-- Mobile Metas -->
    <meta name="viewport" content="width=device-width, initial-scale=1">
 
     <!-- Site Metas -->
    <title>QuickCloud - Hosting Responsive HTML5 Template</title>  
    <meta name="keywords" content="">
    <meta name="description" content="">
    <meta name="author" content="">

    <!-- Site Icons -->
    <link rel="shortcut icon" href="images/favicon.ico" type="image/x-icon" />
    <link rel="apple-touch-icon" href="images/apple-touch-icon.png">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <!-- Site CSS -->
    <link rel="stylesheet" href="style.css">
    <!-- ALL VERSION CSS -->
    <link rel="stylesheet" href="css/versions.css">
    <!-- Responsive CSS -->
    <link rel="stylesheet" href="css/responsive.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="css/custom.css">

    <!-- Modernizer for Portfolio -->
    <script src="js/modernizer.js"></script>

    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

</head>
<body class="host_version"> 

	<!-- Modal -->
	<div class="modal fade" id="login" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
		<div class="modal-content">
			<div class="modal-header tit-up">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title">Customer Login</h4>
			</div>
			<div class="modal-body customer-box">
				<!-- Nav tabs -->
				<ul class="nav nav-tabs">
					<li><a class="active" href="#Login" data-toggle="tab">Login</a></li>
					<li><a href="#Registration" data-toggle="tab">Registration</a></li>
				</ul>
				<!-- Tab panes -->
				<div class="tab-content">
					<div class="tab-pane active" id="Login">
						<form role="form" class="form-horizontal">
							<div class="form-group">
								<div class="col-sm-12">
									<input class="form-control" id="email1" placeholder="Name" type="text">
								</div>
							</div>
							<div class="form-group">
								<div class="col-sm-12">
									<input class="form-control" id="exampleInputPassword1" placeholder="Email" type="email">
								</div>
							</div>
							<div class="row">
								<div class="col-sm-10">
									<button type="submit" class="btn btn-light btn-radius btn-brd grd1">
										Submit
									</button>
									<a class="for-pwd" href="javascript:;">Forgot your password?</a>
								</div>
							</div>
						</form>
					</div>
					<div class="tab-pane" id="Registration">
						<form role="form" class="form-horizontal">
							<div class="form-group">
								<div class="col-sm-12">
									<input class="form-control" placeholder="Name" type="text">
								</div>
							</div>
							<div class="form-group">
								<div class="col-sm-12">
									<input class="form-control" id="email" placeholder="Email" type="email">
								</div>
							</div>
							<div class="form-group">
								<div class="col-sm-12">
									<input class="form-control" id="mobile" placeholder="Mobile" type="email">
								</div>
							</div>
							<div class="form-group">
								<div class="col-sm-12">
									<input class="form-control" id="password" placeholder="Password" type="password">
								</div>
							</div>
							<div class="row">							
								<div class="col-sm-10">
									<button type="button" class="btn btn-light btn-radius btn-brd grd1">
										Save &amp; Continue
									</button>
									<button type="button" class="btn btn-light btn-radius btn-brd grd1">
										Cancel</button>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	  </div>
	</div>

    <!-- LOADER -->
	<div id="preloader">
		<div class="loader-container">
			<div class="progress-br float shadow">
				<div class="progress__item"></div>
			</div>
		</div>
	</div>
	<!-- END LOADER -->	

    <!-- Start header -->
	<header class="top-navbar">
		<nav class="navbar navbar-expand-lg navbar-light bg-light">
			<div class="container-fluid">
				<a class="navbar-brand" href="index.html">
					<img src="images/logo-hosting.png" alt="" />
				</a>
				<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbars-host" aria-controls="navbars-rs-food" aria-expanded="false" aria-label="Toggle navigation">
					<span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
				</button>
				<div class="collapse navbar-collapse" id="navbars-host">
					<ul class="navbar-nav ml-auto">
						<li class="nav-item active"><a class="nav-link" href="device_dashboard.jsp">Home</a></li>
						<li class="nav-item"><a class="nav-link" href="device_upload_file.jsp">Upload Sensor Data</a></li>
						<li class="nav-item"><a class="nav-link" href="device_view_files.jsp">View Files  </a></li>
						<li class="nav-item"><a class="nav-link" href="DeviceFileApprove.jsp">View File Request  </a></li>
						<li class="nav-item"><a class="nav-link" href="device_blockchain_logs.jsp">View Blockchain  Events Logs  </a></li>
						<li class="nav-item"><a class="nav-link" href="owner_requests.jsp">View File Fog Request  </a></li>
						<li class="nav-item"><a class="nav-link" href="index.jsp">Logout  </a></li>
						
					</ul>
					
				</div>
			</div>
		</nav>
	</header>
	<!-- End header -->
	<style>
/* ===== GLOBAL BACKGROUND ===== */
body {
    margin: 0;
    min-height: 100vh;
    font-family: 'Segoe UI', sans-serif;
    background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
    color: #fff;
}

/* ===== TITLE SECTION ===== */
.all-title-box {
    padding: 60px 0 40px;
    text-align: center;
}

.all-title-box h1 {
    font-weight: 700;
    font-size: 34px;
}

.all-title-box .m_1 {
    display: block;
    margin-top: 10px;
    font-size: 15px;
    opacity: 0.85;
}

/* ===== LOGIN SECTION ===== */
.login-section {
    padding: 40px 0 80px;
}

/* ===== LOGIN CARD ===== */
.login-card {
    background: rgba(255,255,255,0.96);
    border-radius: 18px;
    padding: 35px 30px;
    box-shadow: 0 15px 45px rgba(0,0,0,0.35);
    color: #000;
}

/* ===== CARD TITLE ===== */
.login-card h2 {
    font-weight: 700;
    margin-bottom: 25px;
    color: #203a43;
    text-align: center;
}

/* ===== INPUTS ===== */
.login-card input {
    width: 100%;
    padding: 12px 15px;
    margin-bottom: 15px;
    border-radius: 10px;
    border: 1px solid #ccc;
    transition: 0.3s;
}

.login-card input:focus {
    border-color: #2c5364;
    box-shadow: 0 0 8px rgba(44,83,100,0.4);
    outline: none;
}

/* ===== BUTTONS ===== */
.login-card button {
    width: 48%;
    padding: 10px;
    border-radius: 25px;
    border: none;
    font-weight: 600;
}

.login-card button[type="submit"] {
    background: linear-gradient(135deg, #0f2027, #2c5364);
    color: #fff;
}

.login-card button[type="reset"] {
    background: #ddd;
}

.login-card button:hover {
    opacity: 0.9;
}

/* ===== ERROR MESSAGE ===== */
.error-msg {
    margin-top: 15px;
    color: red;
    font-weight: 600;
    text-align: center;
}
</style>
	
	<div class="all-title-box">
    <div class="container">
        <h1>
           Device 
            <span class="m_1">
                 we ensure the fair functioning of the Blockchain nodes.
            </span>
        </h1>
    </div>
</div>
<%
    HttpSession session1 = request.getSession(false);
    if (session1 == null || session1.getAttribute("device_email") == null) {
        response.sendRedirect("device_login.jsp");
        return;
    }

    String deviceEmail = (String) session1.getAttribute("device_email");
%>

<!-- ===== LOGIN CARD ===== -->
<div class="login-section">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5 col-lg-4">

                <div class="login-card">
                       <h2>Device Dashboard</h2>

    <p><strong>Logged in as:</strong> <%= deviceEmail %></p>


            </div>
        </div>
    </div>
</div>
    

    <footer class="footer">
        <div class="container">
            <div class="row">
                <div class="col-lg-4 col-md-4 col-xs-12">
                    <div class="widget clearfix">
                        <div class="widget-title">
                            <h3>About US</h3>
                        </div>
                        <p> Additionally, we implemented secure knowledge discovery to understand the significance of the developed scheme. The results show that the exchange can be implemented in an industrial environment and operate with a reasonable amount of resource consumption.</p>
                        <p>Blockchain integration is one of the suggested applications of technology that could help secure data during transmission, storage, and knowledge discovery.</p>
                    </div><!-- end clearfix -->
                </div><!-- end col -->

				<div class="col-lg-4 col-md-4 col-xs-12">
                    <div class="widget clearfix">
                        <div class="widget-title">
                            <h3>Information Link</h3>
                        </div>
                        <ul class="footer-links">
                            <li><a href="#">Home</a></li>
                            <li><a href="#">Blog</a></li>
                            <li><a href="#">Pricing</a></li>
							<li><a href="#">About</a></li>
							<li><a href="#">Faq</a></li>
							<li><a href="#">Contact</a></li>
                        </ul><!-- end links -->
                    </div><!-- end clearfix -->
                </div><!-- end col -->
				
                <div class="col-lg-4 col-md-4 col-xs-12">
                    <div class="widget clearfix">
                        <div class="widget-title">
                            <h3>Contact Details</h3>
                        </div>

                        <ul class="footer-links">
                            <li><a href="mailto:#">info@yoursite.com</a></li>
                            <li><a href="#">www.yoursite.com</a></li>
                            <li>PO Box 16122 Collins Street West Victoria 8007 Australia</li>
                            <li>+61 3 8376 6284</li>
                        </ul><!-- end links -->
                    </div><!-- end clearfix -->
                </div><!-- end col -->
				
            </div><!-- end row -->
        </div><!-- end container -->
    </footer><!-- end footer -->

    <div class="copyrights">
        <div class="container">
            <div class="footer-distributed">
                <div class="footer-left">                   
                    <p class="footer-company-name">All Rights Reserved. &copy; 2026 <a href="#">Blockchain</a> Design By : <a href="####">Ahmed Bawazeer</a></p>
                </div>

                <div class="footer-right">
                    <ul class="footer-links-soi">
						<li><a href="#"><i class="fa fa-facebook"></i></a></li>
						<li><a href="#"><i class="fa fa-github"></i></a></li>
						<li><a href="#"><i class="fa fa-twitter"></i></a></li>
						<li><a href="#"><i class="fa fa-dribbble"></i></a></li>
						<li><a href="#"><i class="fa fa-pinterest"></i></a></li>
					</ul><!-- end links -->
                </div>
            </div>
        </div><!-- end container -->
    </div><!-- end copyrights -->

    <a href="#" id="scroll-to-top" class="dmtop global-radius"><i class="fa fa-angle-up"></i></a>

    <!-- ALL JS FILES -->
    <script src="js/all.js"></script>
    <!-- ALL PLUGINS -->
    <script src="js/custom.js"></script>
	<script src="js/timeline.min.js"></script>
	<script>
		timeline(document.querySelectorAll('.timeline'), {
			forceVerticalMode: 700,
			mode: 'horizontal',
			verticalStartPosition: 'left',
			visibleItems: 4
		});
	</script>
</body>
</html>