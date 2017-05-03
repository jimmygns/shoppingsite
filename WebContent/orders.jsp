<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<%@ page import="java.sql.*" import="cse135.DbConnection" import="cse135.Product"%>
<body>
<% 
	if(session==null||session.getAttribute("username")==null){
		response.sendRedirect("./login.jsp");
		return;
	}
	String username = (String)session.getAttribute("username");
	String role = (String)session.getAttribute("role");
%>

<p align="right">
		Hello <%=username%>     
	<%
		if (role.equals("customer")) {
	%>
	<a href="./cart.jsp">   Buy Shopping Cart</a>
	<%
		}
	%>
</p>

<%
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

String action = request.getParameter("action");
// Check if an insertion is requested
if (action != null && action.equals("add")) {
	String name = request.getParameter("name");
	int sku = Integer.parseInt(request.getParameter("sku"));
	int quantity = Integer.parseInt(request.getParameter("quantity"));
	Product p = new Product(sku, name, quantity);
	if(session.getAttribute("cart")==null){
		
	}
}


    
    conn = DbConnection.connect();

    String sku = request.getParameter("sku");
    if(sku !=null){
    	String name = request.getParameter("name");
    	
    }
%>

</body>
</html>