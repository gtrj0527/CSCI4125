/*
 * Created on Jul 18, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package dbaccess2;

import java.sql.DriverManager;

import java.sql.SQLException;
import java.sql.Connection;

//import java.sql.*;
/**
 * @author Shengru Tu
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class DBConnection {

	private String dbLocation;
	final String oraThinProtocol = "jdbc:oracle:thin"; 
	final String msSQLProtocol = "jdbc:sqlserver"; 
	//final String dbLocation = "@dbsvcs.cs.uno.edu:1521:cs4620";
	//final String dbLocation = "@dbsvcs.cs.uno.edu:1521:rdbs";

	/** two constructors 
	 */
	public DBConnection (String sID) {
		this.dbLocation = "@localhost:1521:" + sID;
	}
	
	public DBConnection (String host, int port, String sID) {
		this.dbLocation = "@" + host + ":" + port + ":" + sID; // for Oracle 
		// this.dbLocation = "//" + host + ":" + port + ";" + sID; // for MS SQL 
	} 
	
	/** create a JDBC connection 	 */
	public Connection getDBConnection(String username, String password) throws SQLException {
		// register the JDBC driver.
		DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver()); // for Oracle
		String url = oraThinProtocol + ':' + dbLocation;
		// DriverManager.registerDriver(new com.microsoft.sqlserver.jdbc.SQLServerDriver()); // for MS SQL 
		// Create the connection
		// String url = msSQLProtocol + ':' + dbLocation;
		System.out.println("[TableInfo:] url = " + url);
		Connection conn = DriverManager.getConnection(url, username, password);
		return conn;
	}
}
