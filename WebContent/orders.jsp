<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<% 
	if(session==null||session.getAttribute("username")==null){
		response.sendRedirect("./login.jsp");
		return;
	}
	String username = (String)session.getAttribute("username");
	String role = (String)session.getAttribute("role");
%>

<p>
Hello <%=username %>
</p>
<% 
	if(role.equals("user")){
		%>
		<a href="./cart.jsp">shopping cart</a>
		<%
	}
%>

</body>
</html>