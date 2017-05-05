<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<a href="./product_browsing.jsp">product_browsing</a>
<br>
<%@ page import="java.sql.*" import="cse135.DbConnection"
		import="cse135.Product" import="java.util.ArrayList" import="java.util.Calendar"%>
<% 
if(request.getParameter("card") == null){
	session.setAttribute("error", "wrong request");
	response.sendRedirect("./error.jsp");
	return;
}

if (session.getAttribute("cart") != null) {
	ArrayList<Product> list = (ArrayList<Product>) session.getAttribute("cart");

	String action = request.getParameter("action");
	if (action != null && action.equals("buy")) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		conn = DbConnection.connect();
		if (conn == null) {
			session.setAttribute("error", "internal service error");
			response.sendRedirect("./error.jsp");
			return;
		}
		int username = (Integer) session.getAttribute("id");
		Calendar cal = Calendar.getInstance();
		Timestamp timestamp = new Timestamp(cal.getTimeInMillis());
		conn.setAutoCommit(false);

		for (Product p : list) {

			try {
				pstmt = conn.prepareStatement("INSERT into orders (user_name, product, quantity, order_date, price, card) values (?,?,?,?,?,?)");
				pstmt.setInt(1, username);
				pstmt.setInt(2, p.id);
				pstmt.setInt(3, p.quantity);
				pstmt.setTimestamp(4, timestamp);
				pstmt.setDouble(5, p.price);
				pstmt.setString(6, request.getParameter("card"));
				
				int rowCount= pstmt.executeUpdate();
			} catch (SQLException e) {
				e.printStackTrace();

			}
		}
		conn.commit();
		conn.setAutoCommit(true);
		conn.close();
	
		session.removeAttribute("cart");


%>
<table>
	<tr>
		
		<th>Name</th>
		<th>Price</th>
		<th>Quantity</th>
		<th>Time</th>

	</tr>
	<%
		for (Product p : list) {
	%>
	<tr>
		
		<td><%=p.name%></td>
		<td><%=p.price%></td>
		<td><%=p.quantity%></td>
		<td><%=timestamp%></td>
	</tr>
	<%
		}
	}
}
else{
	response.sendRedirect("./cart.jsp");
	return;
}
	
%>
</table>
</body>
</html>