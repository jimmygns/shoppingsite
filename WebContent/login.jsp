<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>login page</title>
</head>
<body>

	<%@ page import="java.sql.*" 
	import="cse135.DbConnection"%>
	<form action="login.jsp">
		username: <input type="text" name="username"><br>
		<button type="submit">login</button>
	</form>
	<form action="registration.jsp"><input type="submit" name = "register"></form>
	<%
	if (request.getParameter("username") == null) {
		return;
	}
	Connection conn = DbConnection.connect();
	if (conn == null) {
		session.setAttribute("error", "internal service error");
		response.sendRedirect("./error.jsp");
		return;
	}
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	try {

		pstmt = conn.prepareStatement("SELECT role, age, state from users WHERE name=?");
		String name = request.getParameter("username");
		pstmt.setString(1, name);
		rs = pstmt.executeQuery();

		if (rs.next()) {
			
			session.setAttribute("username", name);
			session.setAttribute("role", rs.getString(1));
			session.setAttribute("age", rs.getInt(2));
			session.setAttribute("state", rs.getString(3));
			response.sendRedirect("./home.jsp");
			return;
		} else {
%>
	<p>The provided name <%=name%> is not known</p>

	<%
    			}
                
            }
            catch(SQLException e){
            	e.printStackTrace();
            	
            }
            finally{
            	if (rs != null) {
                    try {
                        rs.close();
                    } catch (SQLException e) { } // Ignore
                    rs = null;
                }
                if (pstmt != null) {
                    try {
                        pstmt.close();
                    } catch (SQLException e) { } // Ignore
                    pstmt = null;
                }
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) { } // Ignore
                    conn = null;
                }
            }
%>


</body>
</html>
