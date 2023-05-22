<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<% 
	int currentPage = 1; //시작 페이지
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 2; //한페이지에 출력할 게시물 수
	int startRow = (currentPage -1)*rowPerPage; //한페이지에 출력될 첫번째 행 번호

	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/fileupload", "root", "java1234");
	
	/*
		SELECT 
			b.member_id memberId, 
			b.board_title boardTitle, 
			f.board_file_no boardFileNo, 
			f.origin_filename originFilename, 
			f.save_filename saveFilename, 
			f.path path, 
			b.createdate createdate
		FROM board b INNER JOIN board_file f
		ON b.board_no = f.board_no
		ORDER BY b.createdate DESC
		LIMIT ?, ?
	*/
	String sql = "SELECT b.board_no boardNo, b.member_id memberId, b.board_title boardTitle, f.board_file_no boardFileNo, f.origin_filename originFilename, f.save_filename saveFilename, f.path path, b.createdate createdate FROM board b INNER JOIN board_file f ON b.board_no = f.board_no ORDER BY b.createdate DESC LIMIT ?, ?";
	PreparedStatement stmt = conn.prepareStatement(sql); 
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, startRow);
	stmt.setInt(2, rowPerPage);
	ResultSet rs = stmt.executeQuery();
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<>();
	while(rs.next()){
		HashMap<String, Object> m = new HashMap<>();
		m.put("boardNo", rs.getInt("boardNo"));
		m.put("memberId", rs.getString("memberId"));
		m.put("boardTitle", rs.getString("boardTitle"));
		m.put("boardFileNo", rs.getInt("boardFileNo"));
		m.put("originFilename", rs.getString("originFilename"));
		m.put("saveFilename", rs.getString("saveFilename"));
		m.put("path", rs.getString("path"));
		m.put("createdate", rs.getString("createdate"));
		list.add(m);
	}	
	System.out.println(list.size() + " <-- list.size()");
	
	int totalRow = 0; //전체 행 수
	String totalRowSql = "SELECT COUNT(*) FROM board b INNER JOIN board_file f ON b.board_no = f.board_no";
	PreparedStatement totalRowStmt = conn.prepareStatement(totalRowSql);
	ResultSet totalRowRs = totalRowStmt.executeQuery();
	if(totalRowRs.next()){
		totalRow = totalRowRs.getInt("COUNT(*)");
	}
	//디버깅
	System.out.println(totalRow + " <--home totalRow"); 
		
	int lastPage = totalRow / rowPerPage; //마지막페이지
	if(totalRow % rowPerPage != 0){
		lastPage = lastPage + 1;
	}
	if(totalRow < currentPage){
		currentPage = lastPage;
	}
	
	int pagePerPage = 2; //한번에 출력될 페이징 버튼 수
	int startPage = ((currentPage - 1) / pagePerPage) * pagePerPage + 1; //페이징 버튼 시작 값
	int endPage = startPage + pagePerPage - 1; //페이징 버튼 종료 값
	if(endPage > lastPage){
		endPage = lastPage;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>boardList.jsp</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container">
		<!-- 메인메뉴 페이지 include -->
		<div>
			<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
		</div>
		
		<!-- 게시글 목록 -->
		<h1>PDF 자료 목록</h1>
		<table class="table table-sm text-center">
			<tr>
				<th>게시글 제목</th>
				<th>파일</th>
				<th>작성일</th>
				<th>다운로드</th>
				<th>수정</th>
				<th>삭제</th>
			</tr>
			<%
				for(HashMap<String, Object> m : list){
			%>
					<tr>
						<td><%=(String)m.get("boardTitle") %></td>
						<td><%=(String)m.get("originFilename") %></td>
						<td><%=(String)m.get("createdate") %></td>
						<td>
							<a href="<%=request.getContextPath() %>/<%=(String)m.get("path")%>/<%=(String)m.get("saveFilename")%>" download="<%=(String)m.get("originFilename") %>">
								<%=(String)m.get("originFilename") %>
							</a>
						</td>
			<%
						if(session.getAttribute("loginMemberId") != null){ 
							if(session.getAttribute("loginMemberId").equals(m.get("memberId"))){	
			%>					<!-- 로그인된 사용자와 댓글입력한 사용자가 일치하면 수정,삭제 가능 -->
								<td><a href="<%=request.getContextPath()%>/modifyBoard.jsp?boardNo=<%=m.get("boardNo") %>&boardFileNo=<%=m.get("boardFileNo")%>">수정</a></td>
								<td><a href="<%=request.getContextPath()%>/removeBoard.jsp?boardNo=<%=m.get("boardNo") %>">삭제</a></td>
			<%
							}else{
			%>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
			<%
							}
						}else{
			%>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
			<%
						}
			%>
					</tr>
			<%
				}
			%>
		</table>
		
		<!-- board list 페이징 -->
		<ul class="pagination justify-content-center" style="margin:20px 0">
			
				<%
					//이전 페이지 버튼
					if(startPage >1){
				%>
		    			<li class="page-item">
		    				<a class="page-link text-dark" href="<%=request.getContextPath()%>/boardList.jsp?currentPage=<%=startPage-pagePerPage %>">
		    					이전
		    				</a>
		    			</li>
		    	<%
					}
			        for(int i = startPage; i <= endPage; i++){
			        	if(i==currentPage){
			    %>
			        		<li class="page-item active">
			        			<a class="page-link text-dark" href="<%=request.getContextPath()%>/boardList.jsp?currentPage=<%=i %>">
			        				<%=i %>
			        			</a>
			        		</li>
			    <%
			        	}else{
		    	%>
		        		<li class="page-item">
		        			<a class="page-link text-dark" href="<%=request.getContextPath()%>/boardList.jsp?currentPage=<%=i %>">
		        				<%=i %>
		        			</a>
		        		</li>
		        <%
		        		}
			        }
			    	//다음 페이지 버튼
			    	if(endPage != lastPage){
		        %>
					<li class="page-item">
						<a class="page-link text-dark" href="<%=request.getContextPath()%>/boardList.jsp?currentPage=<%=startPage+pagePerPage %>">
							다음
						</a>
					</li>
				<%
					}
				%>
		</ul>
	</div>
</body>
</html>