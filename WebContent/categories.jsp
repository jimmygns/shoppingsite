<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<%@ page import="java.sql.*" import="cse135.DbConnection"%>
<jsp:include page="links.jsp"></jsp:include>
<%
	String role = (String)session.getAttribute("role");
	if(!role.equals("owner")){
		//session.setAttribute("error", "this page is available to owners only");
		//response.sendRedirect("./error.jsp");
%>
<p>This page is available to owners only</p>		
<%		
		return;
	}
	
	Connection conn = DbConnection.connect();
	if (conn == null) {
		session.setAttribute("error", "internal service error");
		response.sendRedirect("./error.jsp");
		return;
	}
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	
	String action = request.getParameter("action");
	if (action != null && action.equals("insert")) {
		if (request.getParameter("product_name") == null) {
%>
<p>Please name the product</p>
<%
			return;
		}
		else if(request.getParameter("description") == null) {
%>
<p>Please write the description for the product</p>
<%
			return;
		}
		
		
		// Create the prepared statement to INSERT student values
		pstmt = conn.prepareStatement("INSERT INTO categories (name, description) VALUES (?, ?)");
		pstmt.setString(1, request.getParameter("product_name"));
		pstmt.setString(2, request.getParameter("description"));
		int rowCount = pstmt.executeUpdate();
	}
	else if (action != null && action.equals("delete")) {
		if (request.getParameter("product_name") == null) {
%>
<p>Please select the product you want to delete</p>
<%
			return;
		}		
		try {
			pstmt = conn.prepareStatement("DELETE FROM categories WHERE name = ?");
			pstmt.setString(1, request.getParameter("product_name"));
			int rowCount = pstmt.executeUpdate();
		}
		catch(SQLException e){
%>
<p>Cannot delete the specific category</p>
<%
		}
	}
		
	try {

		pstmt = conn.prepareStatement("SELECT name, description from categories");
		rs = pstmt.executeQuery();
%>
	<table border=1>
		 <tr>
		 	<th>Name</th>
		 	<th>Description</th>
		 </tr>
		 <tr>
			<form action="categories.jsp" method="post">
				<input type="hidden" name="action" value="insert"/>
				<th><input value="" name="product_name" size="10"/></th>
				<th><input value="" name="description" size="25"/></th>
				<th><input type = "submit" value = "insert"></th>
			</form>
		 </tr>
		 
<%
		while(rs.next()) {
%>
		<tr>
			<form action = "categories.jsp" method = "POST">
				<input type = "hidden" name = "action" value = "update"/>
				<input type = "hidden" name = "product_name" value = "<%= rs.getString("name") %>"/>
				<input type = "hidden" name = "description" value = ""/>
				<%-- Get the name--%>
				<td><%=rs.getString("name")%></td>

				<%-- Get the description --%>
				<td><%=rs.getString("description")%></td>
				<td><input type = "submit" value = "update"></td>
			</form>
			
			<form action = "categories.jsp" method = "POST">
				<input type = "hidden" name = "action" value = "delete"/>
				<input type = "hidden" name = "product_name" value = "<%= rs.getString("name") %>" />
				<td><input type = "submit" value = "delete"/></td>
			</form>			
		</tr>
			
<%
		}
%>

	</table>
<%
	}
	catch(SQLException e){
    	e.printStackTrace();   	
    }
	finally {
		pstmt.close();
		rs.close();
	}
	
	
%>

</body>
</html>