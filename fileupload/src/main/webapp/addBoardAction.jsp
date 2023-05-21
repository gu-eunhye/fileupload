<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<% 
	//프로젝트안 upload폴더의 실제 물리적 위치를 반환
	String dir = request.getServletContext().getRealPath("/upload");
	//디버깅
	System.out.println(dir + " <-- dir");
	
	int maxFileSize = 1024 * 1024 * 100; //100Mbyte
	
	//request객체를 MultipartRequest의 API를 사용할 수 있도록 랩핑
	//new DefaultFileRenamePolicy() : 업로드 폴더내 동일한 이름이 있으면 뒤에 숫자를 추가
	MultipartRequest mRequest = new MultipartRequest(request, dir, maxFileSize, "utf-8", new DefaultFileRenamePolicy());
	
	//MultipartRequest API를 사용하여 스트림내에서 문자값을 반환받을 수 있다
	
	//업로드 파일이 PDF파일이 아니면 삭제한 뒤 return
	if( mRequest.getContentType("boardFile").equals("application/pdf") == false){
		//이미 저장된 파일을 삭제 (db에는 아직 저장안됨)
		System.out.println("PDF파일이 아닙니다");
		String saveFilename = mRequest.getFilesystemName("boardFile");
		File f = new File(dir + "\\" + saveFilename); //파일이 존재하지 않으면 null ** "/"넣어도 가능
		//new File("D:/html_work/fileupload/src/main/webapp/uploadsign.gif")
		if(f.exists()){ //이 파일이 존재하고 있다면 삭제실행
			f.delete();
			System.out.println(saveFilename + "파일삭제");
		}
		response.sendRedirect(request.getContextPath()+"/addBoard.jsp");
		return;
	}
	
	//1) input type="text" 값 반환 API --> board 테이블에 저장
	String boardTitle = mRequest.getParameter("boardTitle");
	String memberId = mRequest.getParameter("memberId");
	//디버깅
	System.out.println(boardTitle + " <--boardTitle");
	System.out.println(memberId + " <--memberId");
	
	//변수에 저장한 boardTitle, memberId를 Board타입으로 묶어준다
	Board board = new Board();
	board.setBoardTitle(boardTitle);
	board.setMemberId(memberId);
	
	
	//2) input type="file" 값(파일 메타 정보) 반환 API(원본파일이름, 저장된파일이름, 컨텐츠타입)
	// --> board_file 테이블에 저장
	//기본파일(바이너리)은 이미 MultipartRequest객체생성시(reqest랩핑시) 먼저 저장
	String type = mRequest.getContentType("boardFile");
	String originFilename = mRequest.getOriginalFileName("boardFile");
	String saveFilename = mRequest.getFilesystemName("boardFile"); //new DefaultFileRenamePolicy()로 수정된 파일이름
	//디버깅
	System.out.println(type + " <--type");
	System.out.println(originFilename + " <--originFilename");
	System.out.println(saveFilename + " <--saveFilename");
			
	BoardFile boardFile = new BoardFile();
	//boardFile.setBoardNo(boardNo);
	boardFile.setType(type);
	boardFile.setOriginFilename(originFilename);
	boardFile.setSaveFilename(saveFilename);
	
	/*
		INSERT INTO board(board_title, member_id, updatedate, createdate)
		VALUES(?, ?, NOW(), NOW())
	
		INSERT INTO board_file(board_no, origin_filename, save_filename, type, path, createdate)
		VALUES(?, ?, ?, ?, ?, NOW())	
	*/
	
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/fileupload", "root", "java1234");
	
	String boardSql = "INSERT INTO board(board_title, member_id, updatedate, createdate) VALUES(?, ?, NOW(), NOW())";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql, PreparedStatement.RETURN_GENERATED_KEYS); //insert하면서 키값을 받을 수 있다
	//PreparedStatement.RETURN_GENERATED_KEYS : DB상에 AUTO_INCREMENT로 인해 자동으로 생성되어진 key(=id)를 가져오는 쿼리
	boardStmt.setString(1, boardTitle);
	boardStmt.setString(2, memberId);
	boardStmt.executeUpdate(); //board 입력 후 키값 저장
	
	ResultSet keyRs = boardStmt.getGeneratedKeys(); //방금 생성되서 저장된 기본키값을 반환
	int boardNo = 0;
	if(keyRs.next()){
		boardNo = keyRs.getInt(1);
	}
	
	String fileSql = "INSERT INTO board_file(board_no, origin_filename, save_filename, type, path, createdate) VALUES(?, ?, ?, ?, 'upload', NOW())";
	PreparedStatement fileStmt = conn.prepareStatement(fileSql);
	fileStmt.setInt(1, boardNo);
	fileStmt.setString(2, originFilename);
	fileStmt.setString(3, saveFilename);
	fileStmt.setString(4, type);
	fileStmt.executeUpdate(); //board_file 입력
	
	response.sendRedirect(request.getContextPath()+"/boardList.jsp");
%>