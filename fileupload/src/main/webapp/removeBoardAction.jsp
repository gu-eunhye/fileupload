<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*"%>
<%
	//세션 유효성 검사 : 로그인이 되어있지 않으면 home으로 리다이렉션
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/boardList.jsp");
		return;
	}
	
	//요청값 변수에 저장
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String memberId = request.getParameter("memberId");
	//디버깅
	System.out.println(boardNo + " <--removeBoardAction boardNo");
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/fileupload", "root", "java1234");
		
	/* 삭제쿼리
		DELETE FROM board
		WHERE board_no = ?
	*/
	String sql = "DELETE FROM board WHERE board_no = ? and member_id=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	stmt.setString(2, memberId);
	
	System.out.println(stmt + " <--removeBoardAction stmt");
	
	int row = stmt.executeUpdate();
	System.out.println(row + " <--removeBoardAction row");
	
	response.sendRedirect(request.getContextPath()+"/boardList.jsp");
%>