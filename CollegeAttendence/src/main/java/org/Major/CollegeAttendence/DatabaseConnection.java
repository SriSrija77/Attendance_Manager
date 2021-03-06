package org.Major.CollegeAttendence;

import java.sql.Connection; 
import java.sql.DriverManager; 
import java.sql.SQLException; 
  
/*
 * Note: This file is used for Database connectivity with MySQL DB
 * Name: Viraj Panchal
 */
public class DatabaseConnection { 
    public static Connection initializeDatabase() 
        throws SQLException, ClassNotFoundException 
    { 
    	Connection con=null;
    	try {
    		// Added db driver
            String dbDriver = "com.mysql.cj.jdbc.Driver"; 
        	// Added db url
            String dbURL = "jdbc:mysql://localhost:3306/";
        	// Added db name
            String dbName = "attendancereport";
        	// Added db username
            String dbUsername = "root";
        	// Added db password
            String dbPassword = ""; 
      
            Class.forName(dbDriver);
            
            // Connection
            con = DriverManager.getConnection(dbURL + dbName, 
                                                         dbUsername,  
                                                         dbPassword); 
            
    	} catch(SQLException e) {
    		System.out.print("SQL Exception"+e);
			e.printStackTrace();
    	}
    	
    	return con; 
    } 
} 