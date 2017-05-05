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

String action = "";
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
		System.out.println("testing category " + rs.getString("name"));
%>
				<tr>
					<form action = "products.jsp" method = "POST">
						<input type = "hidden" name = "action" value = "pickLink">
						<input type = "hidden" name = "cateName" value = "<%= rs.getString("name") %>">
						<input type = "submit" value = "<%= rs.getString(1) %>">
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
		pstmt.close();
		rs.close();
		
		pstmt = null;
		rs = null;
		if(request.getParameter("partName") != null){
			partName = "%" + request.getParameter("partName") + "%";
		}
		pstmt = conn.prepareStatement("SELECT id, name, sku, category, price from products");
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
			System.out.println("testing initial load " + rs.getString("name"));
%>
				<tr>	
					<td>
						<form action = "products.jsp" method = "POST">
							<input type = "text" value = "<%= rs.getString("name") %>" />
							<input type = "text" value = "<%= rs.getString("sku") %>" />	
							<input type = "text" value = "<%= rs.getString("price") %>" />
							<input type = "text" value = "<%= rs.getString("category") %>"/>
<%
			PreparedStatement pstmtD = null;
			ResultSet rsD = null;
			pstmtD = conn.prepareStatement("SELECT name from categories");
			rsD = pstmt.executeQuery();
%>
							<SELECT name = "cateName">
<%
			while(rs.next()){
%>
								<option value = "<%= rs.getString("name")%>"><%= rs.getString("name")%></option>
<%		
			}
%>
							</SELECT>
							<input type = "hidden" name = "action" value = "update"/>
							<input type = "hidden" name = "deleteId" value = "<%= rs.getInt("id") %>"/>
							
							<input type = "submit" value = "update"/>
						</form>
					</td>	
					<td>
						<form action = "products.jsp" method = "POST">
							<input type = "hidden" name = "action" value = "delete"/>
							<input type = "hidden" name = "deleteID" value = "<%= rs.getInt("id") %>"/>
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
	else if(!action.equals("")){
		System.out.println("action !");
		pstmt.close();
		rs.close();
		
		pstmt = null;
		rs = null;
		if(request.getParameter("partName") != null){
			partName = "%" + request.getParameter("partName") + "%";

		}
		System.out.println("partname is " + partName);
		System.out.println("category is " + cateName);
		
		
		
		PreparedStatement pstmt2 = null;
		ResultSet rs2 = null; 
		
		int currId = 0;
		
		pstmt2 = conn.prepareStatement("SELECT id from categories where name = ?");
		pstmt2.setString(1, cateName);
		System.out.println("!!!!" + cateName);
		rs2 = pstmt2.executeQuery();
		if(rs2.next()){
			currId = rs2.getInt(1);	
			pstmt2.close();
			rs2.close();
		}
		else{
			session.setAttribute("error", "No such category");
			response.sendRedirect("./error.jsp");
			return;	
		}
		
				
		pstmt = conn.prepareStatement("SELECT id, name, sku, category, price from products WHERE category = ? and name like ?");
		pstmt.setInt(1, currId);
		pstmt.setString(2, partName);
		rs = pstmt.executeQuery();
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
		while(rs.next()){
			System.out.println("in action " + action + " " + rs.getString(2));
%>
				<tr>	
					<td>
						<form action = "products.jsp" method = "POST">
							<input type = "text" value = "<%= rs.getString("name") %>" />
							<input type = "text" value = "<%= rs.getString("sku") %>" />	
							<input type = "text" value = "<%= rs.getString("price") %>" />
							<input type = "text" value = "<%= rs.getString("category") %>"/>
<%
			PreparedStatement pstmtD = null;
			ResultSet rsD = null;
			pstmtD = conn.prepareStatement("SELECT name from categories");
			rsD = pstmtD.executeQuery();
%>
							<SELECT name = "cateName">
<%
			while(rsD.next()){
%>
								<option value = "<%= rsD.getString("name")%>"><%= rsD.getString("name")%></option>
<%		
			}
%>
							</SELECT>
							<input type = "hidden" name = "action" value = "update"/>
							<input type = "hidden" name = "deleteId" value = "<%= rsD.getInt("id") %>"/>
							<input type = "submit" value = "update"/>
						</form>
					</td>	
					<td>
						<form action = "products.jsp" method = "POST">
							<input type = "hidden" name = "action" value = "delete"/>
							<input type = "hidden" name = "deleteID" value = "<%= rsD.getInt("id") %>"/>
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