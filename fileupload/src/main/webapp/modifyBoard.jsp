<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath() + "/boardList.jsp");
		return;
	}

	//요청값 유효성 검사: null이거나 공백이면 홈으로 리다이렉션 후 코드진행 종료
	if(request.getParameter("boardNo") == null 
			|| request.getParameter("boardNo").equals("")
			|| request.getParameter("boardFileNo") == null 
			|| request.getParameter("boardFileNo").equals("")){
		response.sendRedirect(request.getContextPath()+"/boardList.jsp");
		return;
	}
	
	//요청값 변수에 저장
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int boardFileNo = Integer.parseInt(request.getParameter("boardFileNo"));
	//디버깅
	System.out.println(boardNo + "<--ㅡmodifyBoard boardNo");
	System.out.println(boardFileNo + "<--ㅡmodifyBoard boardFileNo");
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/fileupload", "root", "java1234");
	
	/*
		SELECT 
			b.board_no boardNo,
			b.board_title boardTitle, 
			f.board_file_no boardFileNo, 
			f.origin_filename originFilename,  
		FROM board b INNER JOIN board_file f
		ON b.board_no = f.board_no
		WHERE b.board_no=? AND f.board_file_no=?
	*/
	String boardsql = "SELECT b.board_no boardNo, b.board_title boardTitle, f.board_file_no boardFileNo, f.origin_filename originFilename FROM board b INNER JOIN board_file f ON b.board_no = f.board_no WHERE b.board_no=? AND f.board_file_no=?";
	PreparedStatement boardStmt = conn.prepareStatement(boardsql); 
	boardStmt = conn.prepareStatement(boardsql);
	boardStmt.setInt(1, boardNo);
	boardStmt.setInt(2, boardFileNo);
	ResultSet boardRs = boardStmt.executeQuery();
	
	HashMap<String, Object> map = null;
	while(boardRs.next()){
		map = new HashMap<>();
		map.put("boardNo", boardRs.getInt("boardNo"));
		map.put("boardTitle", boardRs.getString("boardTitle"));
		map.put("boardFileNo", boardRs.getInt("boardFileNo"));
		map.put("originFilename", boardRs.getString("originFilename"));
	}	
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>modifyBoard.jsp</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<!-- 메인메뉴 페이지 include -->
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	
	<div class="container">
		<div class="row">
			<div class="col-sm-8">
			<!-- 수정폼 -->
			<h1>board & boardFile 수정</h1>
			<form action="<%=request.getContextPath()%>/modifyBoardAction.jsp" method="post" enctype="multipart/form-data">
				<input type="hidden" name="boardNo" value="<%=map.get("boardNo")%>">
				<input type="hidden" name="boardFileNo" value="<%=map.get("boardFileNo")%>">
				
				<table class="table table-sm">
					<tr>
						<th>게시글 제목</th>
						<td>
							<textarea rows="3" cols="50" name="boardTitle" required="required">
								<%=map.get("boardTitle")%>
							</textarea>
						</td>
					</tr>
					<tr>
						<th>파일(수정전 파일 : <%=map.get("originFilename")%>)</th>
						<td>
							<input type="file" name="boardFile"> 
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<button type="submit" class="btn btn-outline-dark">수정</button>
						</td>
						<!-- <td></td> -->
					</tr>
				</table>		
			</form>
			</div>
		</div>	
	</div>
</body>
</html>