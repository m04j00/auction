<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="java.sql.*"%>
<%@include file="dbconn.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");

	String filename = "";
	String realFolder = "C:\\upload";	//웹 애플리케이션상의 절대 경로 //파일명이 너무 길면 파일을 못 찾는다.
	int maxSize = 5 * 1024 * 1024;		//한번에 올릴수 있는 최대 업로드될 최대 용량 5MB
	String encType = "UTF-8";
	String id = request.getParameter("id");
	MultipartRequest multi = new MultipartRequest(request, realFolder, maxSize, encType, new DefaultFileRenamePolicy());
	//new DefaultFileRenamePolicy() 같은 이름의 파일이 있을 경우 어떻게 할것인지 -> 파일이름이 바뀜 p1, p2, p3...
	//원래는 request로 처리, 만약 파일 중복과 같은 값을 처리해야한다면 request뒤의 내용들로 처리
	//파일 저장용도
	
	String name = multi.getParameter("name");
	String description = multi.getParameter("description");
	String sellPrice = multi.getParameter("sellPrice");
		
	
	
	Enumeration files = multi.getFileNames();	//Enumeration files에 파일을 담는다.
	//파일을 list형태로 files에 담음
	String fname = (String)files.nextElement(); //files에 있는 파일의 이름을 가져온다.
	String fileName = multi.getFilesystemName(fname); //서버에 실제 저장된 파일이름(원 파일 명)을 가져옴 -> 이후 중복되면 파일명 바꿈
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	String sql = "SELECT * FROM product WHERE p_id = ?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, id);
	rs = pstmt.executeQuery();
	
	if(rs.next()){
		if(fileName != null){
			sql = "UPDATE product SET p_name = ?, p_description = ?, p_sell_price = ?, p_file_name =? WHERE p_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, name);
			pstmt.setString(2, description);
			pstmt.setString(3, sellPrice);
			pstmt.setString(4, fileName);
			pstmt.setString(5, id);
			pstmt.executeUpdate();
		}else{
			sql = "UPDATE product SET p_name = ?, p_description = ?, p_sell_price = ?WHERE p_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, name);
			pstmt.setString(2, description);
			pstmt.setString(3, sellPrice);
			pstmt.setString(4, id);
			pstmt.executeUpdate();
		}
		
	}
	if(rs != null) rs.close();
	if(pstmt != null) pstmt.close();
	if(conn != null) conn.close();

	response.sendRedirect("editProduct.jsp?edit=update");
%>
