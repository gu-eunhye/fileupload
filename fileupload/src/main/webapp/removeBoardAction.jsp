<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*"%>
<%@ page import = "vo.*"%>
<%@ page import="java.io.*" %>
<%
	//세션 유효성 검사 : 로그인이 되어있지 않으면 home으로 리다이렉션
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/boardList.jsp");
		return;
	}

	//프로젝트안에 있는 upload 폴더의 실제 물리적 위치
	String dir = request.getServletContext().getRealPath("/upload");
	
	//요청값 변수에 저장
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int boardFileNo = Integer.parseInt(request.getParameter("boardFileNo"));
	String memberId = request.getParameter("memberId");
	//디버깅
	System.out.println(boardNo + " <--removeBoardAction boardNo");
	System.out.println(boardFileNo + " <--removeBoardAction boardFileNo");
	System.out.println(memberId + " <--removeBoardAction memberId");
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/fileupload", "root", "java1234");
		
	//폴더 안 파일삭제
	/*
		SELECT save_filename saveFilename 
		FROM board_file 
		WHERE board_file_no = ?
	*/
	String saveFilenameSql = "SELECT save_filename saveFilename FROM board_file WHERE board_file_no = ?";
	PreparedStatement saveFilenameStmt = conn.prepareStatement(saveFilenameSql);
	saveFilenameStmt.setInt(1, boardFileNo);
	ResultSet saveFilenameRs = saveFilenameStmt.executeQuery();
	String preSaveFilename = "";
	if(saveFilenameRs.next()) {
		preSaveFilename = saveFilenameRs.getString("saveFilename");
	}
	File f = new File(dir+"/"+preSaveFilename);
	if(f.exists()) {
		f.delete();
	}
	
	//DB 안 데이터삭제
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