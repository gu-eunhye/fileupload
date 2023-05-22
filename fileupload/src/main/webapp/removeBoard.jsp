<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*"%>
<%
	//세션 유효성 검사 : 로그인이 되어있지 않으면 home으로 리다이렉션
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	}

	//요청값 유효성 검사: null이거나 공백이면 홈으로 리다이렉션 후 코드진행 종료
	if(request.getParameter("boardNo") == null 
			|| request.getParameter("boardNo").equals("")){
		response.sendRedirect(request.getContextPath()+"/boardList.jsp");
		return;
	}

	//요청값 변수에 저장
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	//디버깅
	System.out.println(boardNo + "<--removeBoard boardNo");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>removeBoard.jsp</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container">
		<h1>게시글 삭제</h1>
		<form action="./removeBoardAction.jsp" method="post">
			<table class="table">
				<tr>
					<th>게시글 번호</th>
					<td>
						<input type="text" name="boardNo" value="<%=boardNo %>" readonly="readonly">
					</td>			
				</tr>
				<tr>
					<th>회원 ID</th>
					<td>
						<input type="text" name="memberId">
					</td>
				</tr>
			</table>
			<div>
				&nbsp;
				<button type="submit" class="btn btn-outline-secondary">삭제</button>
			</div>
		</form>
	</div>
</body>
</html>