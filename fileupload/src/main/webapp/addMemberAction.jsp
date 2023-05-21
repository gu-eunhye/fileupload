<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
	//Ansi코드 //콘솔창에서 글자배경색지정
	final String RESET = "\u001B[0m";	
	final String PURPLE = "\u001B[45m";
	final String CYAN = "\u001B[46m";
	
	//post방식 요청값 인코딩하기
	request.setCharacterEncoding("utf-8");
	
	//요청값 확인
	System.out.println(CYAN + request.getParameter("id") + " <--addMemberAction param id" + RESET);
	System.out.println(CYAN + request.getParameter("pw") + " <--addMemberAction param pw" + RESET); 
	
	//세션 유효성 검사: 로그인이 되어 있는 경우에는 이 페이지에 들어올 수 없다
	String msg = null;
	if(session.getAttribute("loginMemberId") != null) { 
		response.sendRedirect(request.getContextPath() + "/boardList.jsp"); 
		return;
	}
	
	//요청값 유효성 검사: null 이거나 공백일 경우에는 회원가입폼으로 리다이렉션
	if(request.getParameter("id") == null 
		|| request.getParameter("id").equals("")
		|| request.getParameter("pw") == null
		|| request.getParameter("pw").equals("")){
		
		msg = URLEncoder.encode("ID 또는 PW를 입력해주세요", "utf-8");
		response.sendRedirect(request.getContextPath() + "/addMember.jsp?msg="+msg);
		return;
	}
	
	//요청값 변수에 저장
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	//디버깅
	System.out.println(PURPLE + id + " <--addMemberAction id" + RESET); 
	System.out.println(PURPLE + pw + " <--addMemberAction pw" + RESET); 
	
	//변수에 저장한 요청값을 Member클래스로 묶는다
	Member signup = new Member();
	signup.setMemberId(id);
	signup.setMemberPw(pw);
	
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/fileupload", "root", "java1234");
	System.out.println(CYAN + conn + " <--addMemberAction db접속성공" + RESET);
	
	/*
		INSERT INTO member (member_id, member_pw, createdate, updatedate)
		VALUES (?, PASSWORD(?), NOW(), NOW())
	*/
	String sql = "INSERT INTO member (member_id, member_pw, createdate, updatedate) VALUES (?, PASSWORD(?), NOW(), NOW())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, signup.getMemberId());
	stmt.setString(2, signup.getMemberPw());
	//디버깅
	System.out.println("stmt addMemberAction--> " + stmt);
	
	//id(기본키)가 중복되는 경우 회원가입 불가
	String sql2 = "SELECT member_id memberId from member where member_id = ?";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, signup.getMemberId());
	//디버깅
	System.out.println("stmt2 addMemberAction--> " + stmt2);
	
	ResultSet rs = stmt2.executeQuery();	
	if(rs.next()){ // 중복된 ID가 있는 경우
		msg = URLEncoder.encode("중복된 ID입니다", "utf-8");
		response.sendRedirect(request.getContextPath() + "/addMember.jsp?msg="+msg);
		return;
	}
	
	int row = stmt.executeUpdate(); 
	System.out.println(PURPLE + row + " <--addMemberAction row" + RESET);
	
	if(row == 1){ 
		msg = URLEncoder.encode("회원가입 성공", "utf-8");
		response.sendRedirect(request.getContextPath()+"/boardList.jsp?msg="+msg);
	} else {
		msg = URLEncoder.encode("회원가입 실패", "utf-8");
		response.sendRedirect(request.getContextPath()+"/boardList.jsp?msg="+msg);
	}
%>