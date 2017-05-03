package cse135;

import java.sql.*;

public class DbConnection {
	
	public static Connection connect(){
		Connection conn = null;
        
        
        try {
            // Registering Postgresql JDBC driver with the DriverManager
            Class.forName("org.postgresql.Driver");

            // Open a connection to the database using DriverManager
            conn = DriverManager.getConnection(
                "jdbc:postgresql://localhost:5432/CSE135_DB?" +
                "user=postgres&password=postgres");
            return conn;
        }
        catch(SQLException | ClassNotFoundException e){
        	return null;
        }
	}

}
