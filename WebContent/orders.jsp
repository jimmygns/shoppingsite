<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<%@ page import="java.sql.*" import="cse135.DbConnection" import="cse135.Product" import="java.util.ArrayList"%>
<body>
<jsp:include page="./links.jsp"></jsp:include>

<%

if(session==null||session.getAttribute("username")==null){
	session.setAttribute("error", "No user logged in");
	response.sendRedirect("./error.jsp");
	return;
}

String action = request.getParameter("action");
// Check if an insertion is requested
if (action != null && action.equals("add")) {
	String name = request.getParameter("name");
	int sku = Integer.parseInt(request.getParameter("sku"));
	int quantity = 0;
	try{
		quantity = Integer.parseInt(request.getParameter("quantity"));
	}
	catch(NumberFormatException e){
		response.sendRedirect("./product_browsing.jsp");
		return;
	}
	double price = Double.parseDouble(request.getParameter("price"));
	int id = Integer.parseInt(request.getParameter("id"));
	Product p = new Product(sku, name, price, quantity, id);
	ArrayList<Product> list;
	if(session.getAttribute("cart")==null){
		list = new ArrayList<Product>();
	}
	else{
		list = (ArrayList<Product>) session.getAttribute("cart");
	}
	list.add(p);
	session.setAttribute("cart", list);
	response.sendRedirect("./product_browsing.jsp");
	return;
}


   

    String sku = request.getParameter("sku");
    if(sku !=null){
    	String name = request.getParameter("name");
    	//int id = Integer.parseInt(sku);
    	int id = Integer.parseInt(request.getParameter("id"));
    	double price = Double.parseDouble(request.getParameter("price"));
    	%>
    	
    	<form action="./orders.jsp">
    	<input type="hidden" name="action" value="add"/>
    	<input type="hidden" name="id" value="<%=id%>"/>
    	sku: <input type="text" name="sku" value="<%=sku%>" readonly>
    	name: <input type="text" name="name" value="<%=name%>" readonly>
    	price: <input type="text" name="price" value="<%=price%>" readonly>
    	quantity: <input type="number" name="quantity">
    	<button type="submit">add to cart</button>
    	</form>
    	
    	<%
    }
    if(session.getAttribute("cart")!=null){
    	ArrayList<Product> list = (ArrayList<Product>) session.getAttribute("cart");
    	%>
    	<table>
    	<tr>
    			<th>SKU</th>
                <th>Name</th>
                <th>Price</th>
                <th>Quantity</th>
    	
    	</tr>
    	<%
    	for(Product p: list){
    		%>
    		<tr>
    		<td><%=p.sku %></td>
    		<td><%=p.name %></td>
    		<td><%=p.price %></td>
    		<td><%=p.quantity %></td>
    		</tr>
    		<%
    	}
    }
%>

</table>
</body>
</html>