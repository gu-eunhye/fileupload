<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
	//Ansi코드 //콘솔창에서 글자배경색지정
	final String RESET = "\u001B[0m";	
	final String PURPLE = "\u001B[45m";
	final String CYAN = "\u001B[46m";

	//세션 유효성 검사	
	if(session.getAttribute("loginMemberId") != null) {
		response.sendRedirect(request.getContextPath()+"/boardList.jsp");
		return;
	}
	
	//요청값 변수에 저장
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	//디버깅
	System.out.println(PURPLE + memberId + " <--loginAcion memberId" + RESET); 
	System.out.println(PURPLE + memberPw + " <--loginAcion memberPw" + RESET); 

	//변수에 저장한 요청값을 Member클래스로 묶는다
	Member paramMember = new Member();
	paramMember.setMemberId(memberId);
	paramMember.setMemberPw(memberPw);
	
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/fileupload", "root", "java1234");
	
	/*
		SELECT member_id memberId FROM member 
		WHERE member_id = ? AND member_pw = PASSWORD(?)"
	*/
	String sql = "SELECT member_id memberId FROM member WHERE member_id = ? AND member_pw = PASSWORD(?)";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, paramMember.getMemberId());
	stmt.setString(2, paramMember.getMemberPw());
	//디버깅
	System.out.println("stmt loginAction--> " + stmt);
	
	ResultSet rs = stmt.executeQuery();
	if(rs.next()) { //로그인 성공 - 세션에 로그인 정보(memberId) 저장
		session.setAttribute("loginMemberId", rs.getString("memberId"));
		System.out.println("로그인 성공 세션정보 : " + session.getAttribute("loginMemberId"));
	} else { //로그인 실패
		System.out.println("로그인 실패");
	}
	response.sendRedirect(request.getContextPath()+"/boardList.jsp");
%>