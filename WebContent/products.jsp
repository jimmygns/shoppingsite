<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<jsp:include page="./links.jsp"></jsp:include>
<% 
	String role = (String)session.getAttribute("role");
	if(!role.equals("owner")){
		session.setAttribute("error", "this page is available to owners only");
		response.sendRedirect("./error.jsp");
		return;
	}
%>

<%@ page import="java.sql.*" 
	import="cse135.DbConnection"%>
	
<%
	Connection conn = DbConnection.connect();
if (conn == null) {
	session.setAttribute("error", "internal service error");
	response.sendRedirect("./error.jsp");
	return;
}
PreparedStatement pstmt = null;
ResultSet rs = null;

try {

	pstmt = conn.prepareStatement("SELECT role, age, state from users WHERE name=?");
	String name = request.getParameter("username");
	pstmt.setString(1, name);
	rs = pstmt.executeQuery();
}
catch(SQLException e){
	
}
finally{
	
}
%>

</body>
</html>