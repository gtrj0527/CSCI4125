package career_development;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;

/**
 * Created by Gaby's Laptop on 4/19/2018.
 */
public class Section_Test {    public static void main(String[] args) {
    try {
        String userName = "gtswanso";
        String password = "sNNP9R9R";

        String hostName = "dbsvcs.cs.uno.edu";
        int port = 1521;
        String sid = "orcl";
        Connection conn = DriverManager.getConnection("jdbc:oracle:thin:" + userName + "/" + password + "@" + hostName + ":" + port + ":" + sid);


    }
    catch (SQLException sqlEx) {
        System.err.println(sqlEx.toString());
    }
}
}
