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
		return;
	}
%>

<%@ page import="java.sql.*" 
	import="java.util.*"
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

String action = "";
List<String> cateList = new ArrayList<String>();
if(request.getParameter("action") != null)
	action = request.getParameter("action");
String cateName = "";
if(request.getParameter("cateName") != null)
	cateName = request.getParameter("cateName");
String partName = "%";
if(action != null && action.equals("insert")){
	String product_name = request.getParameter("product_name");
	int SKU = Integer.parseInt(request.getParameter("SKU"));
	int price = Integer.parseInt(request.getParameter("price"));
	int currId = 0; 
	String category = request.getParameter("cateName");
	
	try{
		pstmt = conn.prepareStatement("SELECT id from categories where name = ?");
		pstmt.setString(1, category);
		System.out.println("!!!!" + category);
		rs = pstmt.executeQuery();
		if(rs.next()){
			currId = rs.getInt(1);		
		}
		else{
			session.setAttribute("error", "No such category");
			response.sendRedirect("./error.jsp");
			return;	
		}
	}
	catch(SQLException e){
		session.setAttribute("error", "Connection failed");
		response.sendRedirect("./error.jsp");
		return;	
	}
	finally{
		if(pstmt != null)
			pstmt.close();
		if(rs != null)
			rs.close();
	}
	
	
	PreparedStatement pstmt1 = null;
	try{
		pstmt1 = conn.prepareStatement("INSERT INTO products (name, sku, category, price) values(?, ?, ?, ?)");
		pstmt1.setString(1, product_name);
		pstmt1.setInt(2, SKU);
		pstmt1.setInt(3, currId);
		pstmt1.setInt(4, price);
		int row = pstmt1.executeUpdate();		
	}
	catch(SQLException e){
		session.setAttribute("error", "failed to add product into category");
		response.sendRedirect("./error.jsp");
		return;	
	}
	finally{
		if(pstmt1 != null)
			pstmt1.close();
	}
}
else if(action != null && action.equals("update")){
	int currId = Integer.parseInt(request.getParameter("id"));
	String product_name = request.getParameter("product_name");
	int SKU = Integer.parseInt(request.getParameter("SKU"));
	int price = Integer.parseInt(request.getParameter("price"));
	String category = request.getParameter("cateName");
	PreparedStatement pstmt1 = null;
	try{
		pstmt1 = conn.prepareStatement("UPDATE products SET name = ?, sku = ?, category = ?, price = ? WHERE id = ?");
		pstmt1.setString(1, product_name);
		pstmt1.setInt(2, SKU);
		pstmt1.setString(3, category);
		pstmt1.setInt(4, price);
		pstmt1.setInt(5, currId);
		int row = pstmt1.executeUpdate();		
	}
	catch(SQLException e){
		session.setAttribute("error", "failed to add product into category");
		response.sendRedirect("./error.jsp");
		return;	
	}
	finally{
		if(pstmt1 != null)
			pstmt1.close();
	}	
}
else if(action != null && action.equals("delete")){
	int currId = Integer.parseInt(request.getParameter("id"));
	String category = request.getParameter("cateName");
	PreparedStatement pstmt1 = null;
	try{
		pstmt1 = conn.prepareStatement("DELETE FROM products WHERE id = ?");

		pstmt1.setInt(1, currId);
		int row = pstmt1.executeUpdate();		
	}
	catch(SQLException e){
		session.setAttribute("error", "failed to delete product from category");
		response.sendRedirect("./error.jsp");
		return;	
	}
	finally{
		if(pstmt1 != null)
			pstmt1.close();
	}	
}


try {	
	System.out.println("action is " + action);
%>	
	<table>
		<tr>
			<form action="products.jsp" method="post">
			<input type="hidden" name="action" value="insert"/>
			product name:<input type = "text" value="" name="product_name"/>
			SKU:<input type = "number" value="" name="SKU"/>
			price:<input type = "number" value="" name="price"/>

<%

	pstmt = conn.prepareStatement("SELECT name, id from categories");
	rs = pstmt.executeQuery();
%>
				<SELECT name = "cateName">
<%
	while(rs.next()){
		System.out.println("testing insert category " + rs.getString("name"));
		cateList.add(rs.getString("name"));
%>
					<option value = "<%= rs.getString("name")%>"><%= rs.getString(1)%></option>
<%		
	}
%>
				</SELECT>
			<input type = "submit" value = "insert">
			</form>
		</tr>
		<tr>
			<form action = "products.jsp" method = "POST">
				<input type = "hidden" name = "action" value = "search"/>
				<input type = "hidden" name = "cateName" value = "<%= cateName %>"/>
				search for:<input type = "text" name = "partName" size = "10" value = ""/>
				<input type = "submit" value = "search">
			</form>
		</tr>
	</table>
	
<%
	pstmt.close();
	rs.close();
	PreparedStatement pstmt1 = null;
	ResultSet rs1 = null;
	
	pstmt1 = conn.prepareStatement("SELECT name from categories");
	rs1 = pstmt1.executeQuery();

	
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
	while(rs1.next()){
		System.out.println("testing category " + rs1.getString("name"));
%>
				<tr>
					<form action = "products.jsp" method = "POST">
						<input type = "hidden" name = "action" value = "pickLink">
						<input type = "hidden" name = "cateName" value = "<%= rs1.getString("name") %>">
						<input type = "submit" value = "<%= rs1.getString(1) %>">
					</form>
				</tr>		
<%
	}
%>
			</table>
		</td>
<%
	//String action = request.getParameter("action");
	if(action.equals("")){
		System.out.println("null action");
		pstmt1.close();
		rs1.close();
		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null;
		
		pstmt2 = null;
		rs2 = null;
		if(request.getParameter("partName") != null){
			partName = "%" + request.getParameter("partName") + "%";
		}
		pstmt2 = conn.prepareStatement("SELECT p.id, p.name, p.sku, p.category, categories.name, p.price from products p INNER JOIN categories ON categories.id = p.category");
		rs2 = pstmt2.executeQuery();
%>
		<td>
			<table>
				<tr>
					<th>Product</th>
					<th>SKU</th>	
					<th>Price</th>
					<th>Category</th>					
				</tr>	
<%
		while(rs2.next()){
			System.out.println("testing initial load " + rs2.getString("p.name"));
%>
				<tr>	
					
						<form action = "products.jsp" method = "POST">
							<td><input type = "text" value = "<%= rs2.getString("p.name") %>" /></td>
							<td><input type = "number" value = "<%= rs2.getInt("p.sku") %>" /></td>
							<td><input type = "number" value = "<%= rs2.getInt("p.price") %>" /></td>
							<td><SELECT name = "cateName" value = "<%= rs2.getString("categories.name") %>>">
<%
			for(String cate: cateList){
%>
								<option value = "<%= cate%>">cate</option>
<%		
			}
%>
							</SELECT></td>
							<input type = "hidden" name = "action" value = "update"/>
							<input type = "hidden" name = "id" value = "<%= rs2.getInt("p.id") %>"/>
							
							<td><input type = "submit" value = "update"/></td>
						</form>	
						<form action = "products.jsp" method = "POST">
							<input type = "hidden" name = "action" value = "delete"/>
							<input type = "hidden" name = "id" value = "<%= rs2.getInt("p.id") %>"/>
							<td><input type = "submit" value = "delete"/></td>
						</form>				
				</tr>
<%
		}
		pstmt2.close();
		rs2.close();
%>
			</table>
		</td>
<%
	}
	else if(!action.equals("")){
		System.out.println("action !");
		PreparedStatement pstmt3 = null;
		ResultSet rs3 = null;
		
		if(request.getParameter("partName") != null){
			partName = "%" + request.getParameter("partName") + "%";

		}
		System.out.println("partname is " + partName);
		System.out.println("category is " + cateName); 
		
		int currId = 0;
		
		pstmt3 = conn.prepareStatement("SELECT id from categories where name = ?");
		pstmt3.setString(1, cateName);
		System.out.println("!!!!" + cateName);
		rs3 = pstmt3.executeQuery();
		if(rs3.next()){
			currId = rs3.getInt(1);	
			pstmt3.close();
			rs3.close();
		}
		else{
			session.setAttribute("error", "No such category");
			response.sendRedirect("./error.jsp");
			return;	
		}
		
				
		pstmt3 = conn.prepareStatement("SELECT p.id, p.name, p.sku, categories.name, p.price from products p INNER JOIN categories ON categories.id = products.category categories.name = ? and p.name like ?");
		pstmt3.setInt(1, currId);
		pstmt3.setString(2, partName);
		rs3 = pstmt3.executeQuery();
%>
		<td>
			<table>
				<tr>
					<th>Product</th>
					<th>SKU</th>	
					<th>Price</th>
					<th>Category</th>					
				</tr>	
<%
		while(rs3.next()){
			System.out.println("in action " + action + " " + rs3.getString(2));
%>
				<tr>	
					<td>
						<form action = "products.jsp" method = "POST">
							<input type = "text" value = "<%= rs3.getString("p.name") %>" />
							<input type = "number" value = "<%= rs3.getInt("p.sku") %>" />	
							<input type = "number" value = "<%= rs3.getInt("p.price") %>" />
							<SELECT name = "cateName" value = "<%= rs3.getString("categories.name") %>">
<%
			for(String cate:cateList){
%>
								<option value = "<%= cate%>"><%= cate%></option>
<%		
			}
%>
							</SELECT>
							<input type = "hidden" name = "action" value = "update"/>
							<input type = "hidden" name = "id" value = "<%= rs3.getInt("p.id")%>"/>
							<input type = "submit" value = "update"/>
						</form>
					</td>	
					<td>
						<form action = "products.jsp" method = "POST">
							<input type = "hidden" name = "action" value = "delete"/>
							<input type = "hidden" name = "id" value = "<%= rs3.getInt("p.id")%>"/>
							<input type = "submit" value = "delete"/>
						</form>				
					</td>
				</tr>
<%
		}
%>
			</table>
		</td>
	</tr>
</table>
<%
	}
}
catch(SQLException e){
	session.setAttribute("error", "this page is available to owners only");
	response.sendRedirect("./error.jsp");
	return;
}
finally{
	if(rs != null)
		rs.close();
	if(pstmt != null)
		pstmt.close();
}
%>
</body>
</html>