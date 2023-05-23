<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>mainmenu.jsp</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.4/dist/jquery.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<nav class="navbar navbar-expand-sm bg-dark navbar-dark">
	<!-- Brand/logo -->
	<a class="navbar-brand" href="#">자료게시판</a>
	
	<!-- Links -->
	<ul class="navbar-nav">
		<!-- 
			로그인전 : 회원가입
			로그인후 : 회원정보 / 로그아웃 (로그인정보 세션 loginMemberId) /카테고리
		-->
		<%
			if(session.getAttribute("loginMemberId") == null) { // 로그인전
		%>
				<li class="nav-item"><a href="<%=request.getContextPath()%>/login.jsp" class="nav-link">로그인</a></li>
				<li class="nav-item"><a href="<%=request.getContextPath()%>/addMember.jsp" class="nav-link">회원가입</a></li>
		<%	
			} else { //로그인후
		%>
				<li class="nav-item"><a href="<%=request.getContextPath()%>/logoutAction.jsp" class="nav-link" >로그아웃</a></li>
				<li class="nav-item"><a href="<%=request.getContextPath()%>/addBoard.jsp" class="nav-link">게시글 등록</a></li>
		<%		
			}
		%>
		<li class="nav-item"><a href="<%=request.getContextPath()%>/boardList.jsp" class="nav-link">자료 게시판</a></li>
	</ul>
</nav>
<br>
</body>
</html>