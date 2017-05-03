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
	%>

	<p>
		Hello
		<%=username%>
	</p>
	<%
		if (role.equals("user")) {
	%>
	<a href="./cart.jsp">shopping cart</a>
	<%
		}
	%>
	<form action="./product_browsing.jsp">
		<input type="text">
	</form>

		<ul>

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
	
	<%
		String search = request.getParameter("search");
			String link = request.getParameter("link");

			pstmt.close();
			rs.close();

			pstmt = conn.prepareStatement("SELECT * from products where category=? and name like ?");
			if (link == null) {
				pstmt.setString(1, "*");
			} else {
				pstmt.setString(1, link);
			}
			if (search == null) {
				pstmt.setString(2, "*");
			} else {
				pstmt.setString(2, search);
			}
			rs = pstmt.executeQuery();
			while (rs.next()) {
	%>
	<ul>

	</ul>
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

</body>
</html>