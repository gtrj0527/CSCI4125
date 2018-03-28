/*
 * Created on Jul 18, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package dbaccess2;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
// import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.Types;
import java.util.Vector;

/**
 * @author Shengru Tu
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class TableUpdate {

	private Connection conn;
	private TableInfo ti;
	
	public TableUpdate(	String host, 
						String port, 
						String sID, 
						String username, 
						String passwd) throws SQLException { 
		conn = new DBConnection(host, port, sID).getDBConnection(username, passwd); 
		ti = new TableInfo(conn);
	}

	public TableUpdate(Connection conn) throws SQLException { 
		this.conn = conn; 
		ti = new TableInfo(conn);
	}

	/**
	 * getter of the TableInfo object  
	 */
	public TableInfo getTableInfo() {
		return ti; 
	}
	
	/**
	 * insert a row into the table  
	 */
	public int insertRow(Vector dataRow, String tableName, ResultSet rs) throws SQLException {
		int[] cTypes = ti.getColumnTypes(rs);
		String stmt = "INSERT INTO " + tableName + " VALUES("; 
		for (int i=0; i<cTypes.length; i++) {
			if (i > 0) stmt = stmt + ", "; 
			if (cTypes[i] == java.sql.Types.NUMERIC) 
				stmt = stmt + dataRow.elementAt(i);
			else 
				stmt = stmt + "'" + dataRow.elementAt(i) + "'";
		}
		stmt = stmt + ")";
		Statement sqlStmt = conn.createStatement();
		return sqlStmt.executeUpdate(stmt);
	}
	
	public int copyTable(String fromTable, String toTable) throws SQLException {
		ResultSet rs = ti.runSQLQuery("SELECT * FROM " + fromTable); 
		int numRow = insertResultSet(rs, toTable); 
		return numRow;
	}

	public int insertResultSet(ResultSet rs, String toTable) throws SQLException {
		String pstmtStr = TableUpdate.formInsertPStmt(toTable, rs); 
		PreparedStatement pstmt = conn.prepareStatement(pstmtStr); 
		int[] colType = TableInfo.getColumnType(rs); 
		int counter = 0; 
		while (rs.next()) {
			for (int i = 0; i < colType.length; i++) {
				switch (colType[i]) {
				case Types.BOOLEAN: 	//16
				    pstmt.setBoolean(i+1, rs.getBoolean(i+1));
				    break;
				case Types.DATE:	//91
				case Types.TIMESTAMP:	//93
				    java.sql.Date date = rs.getDate(i+1);
				    if (date != null) 
				    	pstmt.setDate(i+1, date);
				    break;
				case Types.REAL:	//7		
				case Types.DOUBLE:	//8		
					pstmt.setDouble(i+1, rs.getDouble(i+1));
				    break;
				case Types.FLOAT:	//6
					pstmt.setFloat(i+1, rs.getFloat(i+1));
				    break;
				case Types.INTEGER:	//4
				case Types.NUMERIC:	//2
					int num = rs.getInt(i+1); 
					pstmt.setInt(i+1, rs.getInt(i+1));
				    break;
				case Types.BIGINT:	//-5
					pstmt.setLong(i+1,  rs.getLong(i+1));
				    break;
				case Types.VARCHAR:	//12
				case Types.LONGVARCHAR:	//-1
				case Types.CHAR:	//1
					String str = rs.getString(i+1);
					pstmt.setString(i+1, rs.getString(i+1));
				}
			}
			counter = counter + pstmt.executeUpdate();
		}
		return counter;
	}

	public static String formInsertPStmt(String tableName, ResultSet rs) throws SQLException {
		StringBuffer sb = new StringBuffer("INSERT INTO " + tableName + " ("); 
		String[] cols = TableInfo.getColumnName(rs); 
		for (int i = 0; i < cols.length; i++) {
			sb.append(cols[i]); 
			if (i < cols.length - 1) 
				sb.append(",");
		}
		sb.append(") VALUES(");
		for (int i = 0; i < cols.length; i++) {
			sb.append("?"); 
			if (i < cols.length - 1) 
				sb.append(",");
		}
		sb.append(")");
		return sb.toString();
	}
	
	public static void main(String[] args) throws SQLException {
		if (args.length < 3) {
			System.out.println("usage: java TableUpdate table-name new-table db-username db-password"); 
			System.exit(1);
		}		
		DBConnection tc = new DBConnection("nbdb"); 
		Connection conn = tc.getDBConnection(args[2], args[3]); 
		TableUpdate tu = new TableUpdate(conn); 
		int rowIns = tu.copyTable(args[0], args[1]);
		System.out.println(rowIns + " rows were inserted.");
	}
}
