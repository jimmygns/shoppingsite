<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<%@ page import="java.sql.*" import="cse135.DbConnection"%>
<body>
	<%
		if (session == null || session.getAttribute("username") == null) {
			session.setAttribute("error", "No user logged in");
			response.sendRedirect("./error.jsp");
			return;
		}
		String username = (String) session.getAttribute("username");
		String role = (String) session.getAttribute("role");
		String action = request.getParameter("action");
        // Check if an insertion is requested
        String link = "";
        if (request.getParameter("link") != null) {
        	link = request.getParameter("link");
        }
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
	
	<form action="./product_browsing.jsp" method="post">
		<input type="hidden" name="action" value="search"/>
		search: <input type="text" name="search"/>
		<input type="hidden" name="link" value="<%=link%>"/>
		<button type="submit"> search</button>
	</form>
<table>
<tr>
<td>
		<ul>
		<li><a href="./product_browsing.jsp">all</a></li>

			<%
				Connection conn = DbConnection.connect();
				if (conn == null) {
					session.setAttribute("error", "internal service error");
					response.sendRedirect("./error.jsp");
					return;
				}
				PreparedStatement pstmt = null;
				ResultSet rs = null;

				try {

					pstmt = conn.prepareStatement("SELECT name from categories");

					rs = pstmt.executeQuery();
					while (rs.next()) {
			%>
			<li><a href="./product_browsing.jsp?link=<%=rs.getString(1)%>"><%=rs.getString(1)%></a>
			</li>
			<%
				}
			%>

		</ul>
		</td>
		<td>
		<table border="1">
            <tr>
                <th>Name</th>
                <th>SKU</th>
                <th>Category</th>
                <th>Price</th>
            </tr>
	
	<%
			String search = request.getParameter("search");

			pstmt.close();
			rs.close();
			if(action!=null && action.equals("search")){
				if(link.isEmpty()){
					pstmt = conn.prepareStatement("SELECT * from products where name like ?");
					pstmt.setString(1, "%"+search+"%");
				}
				else{
					pstmt = conn.prepareStatement("SELECT * from products where category = ? name like ?");
					pstmt.setString(1, link);
					pstmt.setString(2, "%"+search+"%");
				}
				
			}
			else{
				if(link.isEmpty()){
					pstmt = conn.prepareStatement("SELECT * from products");
				}
				else{
					pstmt = conn.prepareStatement("SELECT * from products where category = ?");
					pstmt.setString(1, link);
				}
			}

			rs = pstmt.executeQuery();
			while (rs.next()) {
	%>
	<tr>
	<td>
	<form action="./orders.jsp" method="POST">
    	<input type="hidden" name="sku" value="<%=rs.getInt(2) %>"/>
    	<input type="hidden" name="name" value="<%=rs.getString(1) %>"/>
    	<input type="hidden" name="price" value="<%=rs.getDouble(4) %>">
    	<input type="submit" value="<%=rs.getString(1)%>" readonly="readonly"/>
    </form>
	
	</td>
	<td>
	<%=rs.getInt(2) %>
	</td>
	<td>
	<%=rs.getString(3) %>
	</td>
	<td>
	<%=rs.getDouble(4) %>
	</td>
	</tr>
	<%
		}

		} catch (SQLException e) {

		} finally {
			if (rs != null) {
				try {
					rs.close();
				} catch (SQLException e) {
				} // Ignore
				rs = null;
			}
			if (pstmt != null) {
				try {
					pstmt.close();
				} catch (SQLException e) {
				} // Ignore
				pstmt = null;
			}
			if (conn != null) {
				try {
					conn.close();
				} catch (SQLException e) {
				} // Ignore
				conn = null;
			}
		}
	%>
	</table>
	</td>
	</tr>
</table>
</body>
</html>