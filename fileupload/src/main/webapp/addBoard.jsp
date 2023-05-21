<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath() + "/boardList.jsp");
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>addBoard + file</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container">
		<!-- 메인메뉴 페이지 include -->
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		
		<h1>PDF 자료 업로드</h1>
		<form action="<%=request.getContextPath()%>/addBoardAction.jsp" method="post" enctype="multipart/form-data">
			<table class="table">
				<!-- 자료 업로드 제목글 -->
				<tr>
					<th>게시글 제목</th>
					<td>
						<textarea rows="3" cols="50" name="boardTitle" required="required"></textarea>
					</td>
				</tr>
				<!-- 로그인 사용자 아이디 -->
				<%
					String memberId = (String)session.getAttribute("loginMemberId"); 
				%>
				<tr>
					<th>회원 ID</th>
					<td>
						<input type="text" name="memberId" value="<%=memberId %>" readonly="readonly"> 
					</td>
				</tr>
				<!-- 업로드할 자료 -->
				<tr>
					<th>파일</th>
					<td>
						<input type="file" name="boardFile" required="required"> 
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<button type="submit">자료 업로드</button>
					</td>
					<!-- <td></td> -->
				</tr>
			</table>
			
		</form>
	</div>
</body>
</html>