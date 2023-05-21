<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>mainmenu.jsp</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container">
		&nbsp;
		<ul class="list-group list-group-horizontal">			
			<!-- 
				로그인전 : 회원가입
				로그인후 : 회원정보 / 로그아웃 (로그인정보 세션 loginMemberId) /카테고리
			-->
			<%
				if(session.getAttribute("loginMemberId") == null) { // 로그인전
			%>
					<li class="list-group-item"><a href="<%=request.getContextPath()%>/login.jsp" class="text-body" style="text-decoration : none;">로그인</a></li>
					<li class="list-group-item"><a href="<%=request.getContextPath()%>/addMember.jsp" class="text-body" style="text-decoration : none;">회원가입</a></li>
			<%	
				} else { //로그인후
			%>
					<li class="list-group-item"><a href="<%=request.getContextPath()%>/logoutAction.jsp" class="text-body" style="text-decoration : none;">로그아웃</a></li>
					<li class="list-group-item"><a href="<%=request.getContextPath()%>/addBoard.jsp" class="text-body" style="text-decoration : none;">게시글 등록</a></li>
			<%		
				}
			%>
			<li class="list-group-item"><a href="<%=request.getContextPath()%>/boardList.jsp" class="text-body" style="text-decoration : none;">자료 게시판</a></li>
		</ul>
		&nbsp;
	</div>
</body>
</html>