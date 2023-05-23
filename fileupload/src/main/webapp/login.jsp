<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>login.jsp</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<!-- 메인메뉴 페이지 include -->
	<div>
		<jsp:include page ="/inc/mainmenu.jsp"></jsp:include>
	</div>
		
	<!-- member_id, member_pw를 이용하여 로그인  -->
	<div class="container">
		<div class="row">
			<div class="col-sm-6">
				<!-- 로그인 폼 -->
				<h1>로그인</h1>
				<form action="<%=request.getContextPath()%>/loginAction.jsp" method="post">
					<div class="form-group">
						<label for="memberId">ID:</label>
						<input type="text" class="form-control" placeholder="Enter ID" name="memberId">
					</div>
					<div class="form-group">
						<label for="memberPw">Password:</label>
						<input type="password" class="form-control" placeholder="Enter Password" name="memberPw">
					</div>
					<div class="text-center"><button type="submit" class="btn btn-outline-dark">Login</button></div>	
				</form>
			</div>
		</div>
	</div>
</body>
</html>