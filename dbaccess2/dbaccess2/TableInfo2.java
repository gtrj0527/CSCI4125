/*
 * Created on Jul 4, 2006
 */
package dbaccess2;

import java.sql.Connection; 
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.Types;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

/**
 * @author Shengru Tu
 */
public class TableInfo2 {

	private Connection conn;
	final String host = "dbsvcs.cs.uno.edu"; 
	final int port = 1521;
	final String sID = "orcl";

	public TableInfo2(	String host, 
						int port, 
						String sID, 
						String username, 
						String passwd) throws SQLException { 
		conn = new DBConnection(host, port, sID).getDBConnection(username, passwd); 
	}

	public TableInfo2(String username, String passwd) throws SQLException { 
		this.conn = new DBConnection(host, port, sID).getDBConnection(username, passwd);  // for Oracle 
		// this.conn = new DBConnection(sID).getDBConnection(username, passwd);  // for MS SQL 
	}

	public TableInfo2(Connection conn) throws SQLException { 
		this.conn = conn; 
	}

	/** list the user's table names	 */
	public String[] listTableName() throws SQLException {
		String str = "SELECT Table_Name FROM USER_TABLES";
		Statement stmt = conn.createStatement();
		ResultSet rs = stmt.executeQuery(str);
		ArrayList<String> al = new ArrayList<String>();
		while (rs.next()) {
			al.add(rs.getString("Table_Name"));
		}
		String[] tn = al.toArray(new String[1]);
		return tn;
	}

	/** return the columns' titles of a table as an array of String */
	public static String[] getColumnName(ResultSet rs) throws SQLException {
		ResultSetMetaData rmd = rs.getMetaData(); 
		int colNum = rmd.getColumnCount();
		String[] col = new String[colNum]; 
		for (int i = 0; i < colNum; i++) {
			col[i] = rmd.getColumnName(i+1); 
		}
		return col;
	}

	/** return the columns' types 
	 * wonder how types are in int?   https://docs.oracle.com/javase/7/docs/api/  */
	public static int[] getColumnType(ResultSet rs) throws SQLException {
		ResultSetMetaData rmd = rs.getMetaData(); 
		int colNum = rmd.getColumnCount();
		int[] colType = new int[colNum]; 
		for (int i = 0; i < colNum; i++) {
			colType[i] = rmd.getColumnType(i+1); 
		}
		return colType;
	}
 	
	/** convert a ResultSet to a two-dimensional array of String 
	 */
	public ArrayList<String[]> resultSet2DArray(ResultSet rs) throws SQLException {
		ResultSetMetaData rsmd = rs.getMetaData();
		int col = rsmd.getColumnCount();
		ArrayList<String[]> al = new ArrayList<String[]>(1); 
		while (rs.next()) { 
			String[] row = new String[col]; 
			for (int i = 0; i < col; i++) {
				Object obj = rs.getObject(i+1); 
				if (obj != null)
					row[i] = obj.toString();
				else 
					row[i] = "";
			}
			al.add(row);
		} 
		return al;
	} 
	
	/**
	 * return ResultSet from a table with one "WHERE col=val"  
	 * taking the table name and a column name colName as string parameters invites serious vulnerability, 
	 * NOT a good practice. 	*/
	public ResultSet getSelectedResultSet(String tn, String colName, 
							int colType, String val) throws Exception { 
		String sqlStr = "SELECT * FROM " + tn + " WHERE " + colName + "=?"; 
		PreparedStatement pstmt = conn.prepareStatement(sqlStr); 
		if (colType == Types.DATE) {
			SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yy");
			Date dat = sdf.parse(val); 
			// sdf.applyPattern("dd-MMM-yyyy");
			pstmt.setDate(1, new java.sql.Date(dat.getTime())); 
		} else if (colType==Types.INTEGER || colType==Types.NUMERIC || colType==Types.SMALLINT) { 
			pstmt.setInt(1, Integer.parseInt(val)); 
		} else if (colType==Types.REAL || colType==Types.DECIMAL || colType==Types.NUMERIC) {
			pstmt.setDouble(1, Double.parseDouble(val)); 
		} else if (colType==Types.BIGINT) { 
			pstmt.setLong(1, Long.parseLong(val)); 
		} else { // colType==Types.VARCHAR || colType==Types.CHAR || colType==Types.LONGVARCHAR
			pstmt.setString(1, val); 
		}
		return pstmt.executeQuery(); 
	}
	
	/**
	 * return the ResultSet object of a table 
	 * This is for illustration ONLY, NOT practically useful.  The string tn (suppose to be a table name) invites 
	 * grave vulnerability.  You can test on it. 
	 */
	public ResultSet getTable(String tn) throws SQLException {
		String str = "SELECT * FROM " + tn;
		Statement stmt = conn.createStatement();
		ResultSet rs = stmt.executeQuery(str);
		return rs;
	}
	
	/** Return an ordered, specified column of a table.
	 * taking the table name and a column name colName as string parameters invites serious vulnerability, 
	 * NOT a good practice. 	*/
	public ResultSet getOrderedColumn(String tn, String colName) throws SQLException{
		String str = "SELECT " + colName + " FROM " + tn + " ORDER BY " + colName;
		Statement stmt = conn.createStatement();
		return stmt.executeQuery(str); 
	}

	/** return a date column's dates in a SHORT format 	
	 * taking the table name and a column name colName as string parameters invites serious vulnerability, 
	 * NOT a good practice. 	*/
	public String[] getDateColumnInShort(String tableName, String dateColumn) throws SQLException {
		String[] result = getDateColumn(tableName, dateColumn, DateFormat.SHORT);
		return result;
	}

	/** return a date column's dates in a chosen format
	 * taking the table name and a column name colName as string parameters invites serious vulnerability, 
	 * NOT a good practice. 	*/
	public String[] getDateColumn(String tableName, String dateColumn, int form) throws SQLException {
		String sqlStr = "SELECT " + dateColumn + " FROM " + tableName + " ORDER BY " + dateColumn + " DESC"; 
		DateFormat df = DateFormat.getDateInstance(form);
		ArrayList<String> dList = new ArrayList<String>(); 
		Statement stmt = conn.createStatement(); 
		ResultSet rs = stmt.executeQuery(sqlStr); 
		while (rs.next()) { 
			String dat = df.format(rs.getDate(dateColumn));
			dList.add(dat);
		}
		String[] result = dList.toArray(new String[1]);
		return result;
	}
	
	/** tester
	 */
	public static void main(String[] args) throws SQLException {
		if (args.length < 2) {
			System.out.println("usage: java TableInfo db-username db-password"); 
			System.exit(1);
		}
		DBConnection tc = new DBConnection("dbsvcs.cs.uno.edu", 1521, "orcl"); 
		Connection conn = tc.getDBConnection(args[0], args[1]); 
		TableInfo2 ti = new TableInfo2(conn); 		// intentionally use DBConnection first  
		System.out.println("\nYour tables are listed below.\n"); 
		String[] names = ti.listTableName(); 
		if (names.length == 0) 
			System.out.println("You do not have any table.");
		else {
			for (int i=0; i<names.length; i++) {
				System.out.println(names[i]); 
			}
			System.out.println("\nList your first table contents.\n");
			ResultSet rs = ti.getTable(names[0]);
			String[] titles = TableInfo2.getColumnName(rs); 
			for (int i=0; i<titles.length; i++) {
				System.out.print(titles[i] + "\t|"); 
			}
			System.out.println("\n"); 
			ArrayList<String[]> table = ti.resultSet2DArray(rs); 
			for (String[] row : table) {
				for (String value : row) {
					System.out.print(value + "\t|");
				}
				System.out.println(); 
			}
		}
	}
}
