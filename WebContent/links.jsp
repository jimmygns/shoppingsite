<% 
	if(session==null||session.getAttribute("username")==null){
		session.setAttribute("error", "No user logged in");
		response.sendRedirect("./error.jsp");
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

<nav>
<a href="./product_browsing.jsp">products browsing</a>

<a href="./orders.jsp">orders</a>
<%
	if(role.equals("owner")){
%>
		
		<a href="./products.jsp">products</a>
		
		<a href="./categories.jsp">categories</a>
		
<% 
	}
%>
</nav>