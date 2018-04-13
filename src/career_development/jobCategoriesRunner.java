/*UNFINISHED*/
package career_development;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;

public class jobCategoriesRunner {

    //TODO: Add close for statements and connection
    public static void main(String[] args) {
        try {
            String userName = "";
            String password = "";
            String hostName = "dbsvcs.cs.uno.edu";
            int port = 1521;
            String sid = "orcl";
            Connection conn = DriverManager.getConnection("jdbc:oracle:thin:" + userName + "/" + password + "@" + hostName + ":" + port + ":" + sid);

        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
            System.err.println("Connection failed");
        }
	// write your code here
    }
}
