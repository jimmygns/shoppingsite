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
%>
<p>This page is available to owners only</p>
<%
	//	session.setAttribute("error", "this page is available to owners only");
	//	response.sendRedirect("./error.jsp");
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

String action = request.getParameter("action");

if(action != null && action.equals("insert")){
	String product_name = request.getParameter("product_name");
	int SKU = Integer.parseInt(request.getParameter("SKU"));
	int price = Integer.parseInt(request.getParameter("price"));
	String category = request.getParameter("");
	PreparedStatement pstmt1 = null;
	ResultSet rs1 = null;
	try{
		pstmt1 = conn.prepareStatement("INSERT INTO products (name, sku, category, price) values(?, ?, ?, ?)");
		String username = request.getParameter("username");
		pstmt1.setString(1, product_name);
		pstmt1.setInt(2, SKU);
		pstmt1.setString(3, category);
		pstmt1.setInt(4, price);
		int row = pstmt1.executeUpdate();
		
		
	}
	catch(SQLException e){
		
	}
	finally{
		pstmt1.close();
		rs1.close();
	}
}

try {	
%>	
	<table>
		<tr>
			<form action="products.jsp" method="post">
			<input type="hidden" name="action" value="insert"/>
			<th><input type = "text" value="" name="product_name" size="10"/></th>
			<th><input type = "number" value="" name="SKU" size="15"/></th>
			<th><input type = "number" value="" name="Price" size="10"/></th>
			<th>

<%

	pstmt = conn.prepareStatement("SELECT name from categories");
	rs = pstmt.executeQuery();
%>
				<SELECT name = "category">
<%
	while(rs.next()){
%>
					<option value = "<%= rs.getString("name")%>"></option>
<%		
	}
%>
				</SELECT>
			</th>
			<th><input type = "submit" value = "insert"></th>																	
			</form>
		</tr>
	</table>
	
<%
	pstmt.close();
	rs.close();
	pstmt = null;
	rs = null;
	
	pstmt = conn.prepareStatement("SELECT name from categories");
	rs = pstmt.executeQuery();

	
%>
<table>
	<tr>
		<td>Categories</td>
		<td>Products</td>
	</tr>
	<tr>
		<td>
			<table>
<%
	while(rs.next()){
%>
				<tr>
					<form action = "products.jsp" method = "POST">
						<input type = "hidden" name = "action" value = "pickLink">
						<input type = "hidden" name = "dropCate" value = "<%= rs.getString("") %>">
						<input type = "hidden" name = "catePicked" value = "<%= rs.getString("name") %>>">
						<input type = "submit" value = "<%= rs.getString("name") %>">
					</form>
				</tr>		
<%
	}
%>

				<tr>
					<form action = "products.jsp" method = "POST">
						<input type = "hidden" name = "action" value = "search"/>
						<input type = "hidden" name = "catePicked" value = "<%= cateName %>"/>
						search for:<input type = "text" name = "searchName" size = "10" value = ""/>
						<input type = "submit" value = "search">
					</form>
				</tr>
			</table>
		</td>
<%
	//String action = request.getParameter("action");
	if(action != null && action.equals("pickLink")){
		pstmt.close();
		rs.close();
		
		pstmt = null;
		rs = null;
		
		pstmt = conn.prepareStatement("SELECT name, sku, category, price from products WHERE category = ?");
		String cateName = " ";
		if(request.getParameter("catePicked") != null){
			cateName = request.getParameter("catePicked");
		}
		pstmt.setString(1, cateName);
		rs = pstmt.executeQuery();
%>
		<td>
			<table>
				<tr>
					<th>Product</th>
					<td>SKU</th>	
					<td>Price</th>
					<td>Category</th>					
				</tr>	
<%
		while(rs.next()){
%>
				<tr>
					<td><%= rs.getString("name") %></td>
					<td><%= rs.getString("sku") %></td>	
					<td><%= rs.getString("price") %></td>
					<td><%= rs.getString("category") %></td>	
					<td>
						<form action = "products.jsp" method = "POST">
							<input type = "hidden" name = "action" value = "delete"/>
							<input type = "hidden" name = "deleteProduct" value = "<%= rs.getString("name") %>"/>
							<input type = "submit" value = "delete"/>
						</form>				
					</td>
				</tr>
<%
		}
%>
			</table>
				<tr>
					
				</tr>
			</table>
		</td>
	</tr>
</table>
<%
	}
%>

<%
	
	
}
catch(SQLException e){
	
}
finally{
	
}
%>

</body>
</html>