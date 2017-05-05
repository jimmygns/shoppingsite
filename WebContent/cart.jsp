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
	<%@ page import="java.sql.*" import="cse135.DbConnection"
		import="cse135.Product" import="java.util.ArrayList" import="java.util.Calendar"%>
	<%
	if(session==null||session.getAttribute("username")==null){
		session.setAttribute("error", "No user logged in");
		response.sendRedirect("./error.jsp");
		return;
	}
		if (session.getAttribute("cart") != null) {
			ArrayList<Product> list = (ArrayList<Product>) session.getAttribute("cart");
			double total = 0;
	%>
	<table>
		<tr>
			<th>SKU</th>
			<th>Name</th>
			<th>Price</th>
			<th>Quantity</th>
			<th>Total</th>

		</tr>
		<%
			for (Product p : list) {
					total += (p.price * p.quantity);
		%>
		<tr>
			<td><%=p.sku%></td>
			<td><%=p.name%></td>
			<td><%=p.price%></td>
			<td><%=p.quantity%></td>
			<td><%=p.price * p.quantity%></td>
		</tr>
		<%
			}
		%>
	</table>
	<br>
	<br>
	<p>
		Total amount:
		<%=total%></p>
	<form action="./confirmation.jsp">
		<input type="hidden" name="action" value="buy" /> Credit Card Number:
		<input type="text" name="card">
		<button type="submit">Checkout</button>
	</form>
	<%
		} else {
	%>
	<h1>cart is empty</h1>
	<%
		}
	%>

</body>
</html>