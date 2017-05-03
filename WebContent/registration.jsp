<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>RegJSP</title>
</head>
<body>
	<%@ page import = "java.sql.*" import = "cse135.DbConnection"%>
	<form action = "registration.jsp">
		User name:<input type = "text" NAME = "username"/><p>
		Role:<SELECT name = "role">
			<option value = "owner">owner</option>
			<option value = "customer">customer</option>
		</SELECT>
		<p>
		Age:<input type = "number" NAME = "age"/><p>
		State:<SELECT name = "state">
			<OPTION value="CA">CA</OPTION>
			<OPTION value="IL">IL</OPTION>
			<OPTION value="IN">IN</OPTION>
		</SELECT>
		<button type = "submit">SIGNUP</button>
	</form>
	<form action = "login.jsp" method = "post">
		<button type = "submit">CANCEL</button>
	</form>
	<%
	
	
		if (request.getParameter("username").isEmpty() || request.getParameter("role").isEmpty() || request.getParameter("age").isEmpty() || request.getParameter("state").isEmpty()) {
			//session.setAttribute("error", "please fill all the fields");
			//response.sendRedirect("./error.jsp");
			%>
			<p>please fill in all the fields</p>
			<%
			return;
		}
		String user = request.getParameter("username");
		//session.putValue("username", user);
		String role = request.getParameter("role");
		//session.putValue("role", role);
		String age = request.getParameter("age");
		int ageInt;
		try {
			ageInt = Integer.parseInt(age);
		}
		catch(NumberFormatException e) {
%>
<p>Please insert number in the age field</p>
<%
			return;
		}
		//session.putValue("age", age);
		String state = request.getParameter("state");
		//session.putValue("state", state);
		//Class.forName("");
		
		Connection conn = DbConnection.connect();
		
		if (conn == null) {
			session.setAttribute("error", "Connection failed");
			response.sendRedirect("./error.jsp");
			return;
		}
		
		PreparedStatement pstmt = null, pstmt1 = null;
		ResultSet rs = null, rs1 = null;
		
		try {
			pstmt = conn.prepareStatement("SELECT role, age, state from users WHERE name=?");
			String name = request.getParameter("username");
			pstmt.setString(1, name);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				session.setAttribute("error", "Your Signup failed");
				response.sendRedirect("./error.jsp");
				return;
			} 
			else {
				pstmt1 = conn.prepareStatement("INSERT INTO users (name, role, age, state) values(?, ?, ?, ?)");
				String username = request.getParameter("username");
				pstmt1.setString(1, user);
				pstmt1.setString(2, role);
				pstmt1.setInt(3, ageInt);
				pstmt1.setString(4, state);
				int row = pstmt1.executeUpdate();
				%>
				<p>You have successfully signed up!</p>
				<%
				//response.sendRedirect("./login.jsp");
				return;
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
	            	if(rs1 != null){
	            		try{
	            			rs1.close();
	            		} catch (SQLException e) {}
	            		rs1 = null;
	            	}
	            	
	                if (pstmt != null) {
	                    try {
	                        pstmt.close();
	                    } catch (SQLException e) { } // Ignore
	                    pstmt = null;
	                }
	                
	                if (pstmt1 != null) {
	                    try {
	                        pstmt1.close();
	                    } catch (SQLException e) { } // Ignore
	                    pstmt1 = null;
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
