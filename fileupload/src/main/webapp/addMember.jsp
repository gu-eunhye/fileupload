<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//세션 유효성 검사 : 로그인되어있으면 회원가입폼에 들어올 수 없으므로 boardList로 리다이렉션
	if(session.getAttribute("loginMemberId") != null){
		response.sendRedirect(request.getContextPath() + "/boardList.jsp");
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>addMember.jsp</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<!-- 메인메뉴 페이지 include -->
	<div>
		<jsp:include page ="/inc/mainmenu.jsp"></jsp:include>
	</div>
		
	<div class="container">
		<!-- 리다이렉션 메시지 -->
		<div class="bg-warning">
			<%
				if(request.getParameter("msg") != null){
			%>
					<%=request.getParameter("msg")%>
			<%
				}
			%>
		</div>
		
		<!-- 회원가입 폼  -->
		<div class="row">
			<div class="col-sm-6">
				<h1>회원가입</h1>
				<form action = "<%=request.getContextPath()%>/addMemberAction.jsp" method="post">
					<div class="form-group">
						<label for="id">ID:</label>
						<input type="text" class="form-control" placeholder="Enter ID" name="id">
					</div>
					<div class="form-group">
						<label for="pw">Password:</label>
						<input type="password" class="form-control" placeholder="Enter Password" name="pw">
					</div>
					<div class="text-center"><button type="submit" class="btn btn-outline-dark">회원가입</button></div>	
				</form>
			</div>
		</div>
	</div>
</body>
</html>