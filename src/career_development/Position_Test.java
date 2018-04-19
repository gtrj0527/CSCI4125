package career_development;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;

/**
 * Created by Gaby's Laptop on 4/19/2018.
 */
public class Position_Test {public static void main(String[] args) {
    try {
        String userName = "gtswanso";
        String password = "sNNP9R9R";

        String hostName = "dbsvcs.cs.uno.edu";
        int port = 1521;
        String sid = "orcl";
        Connection conn = DriverManager.getConnection("jdbc:oracle:thin:" + userName + "/" + password + "@" + hostName + ":" + port + ":" + sid);

        Position position = Position.retrievePosition(1, conn);
        List<Position> listPosition = Position.retrieveAllPositions(conn);
        Iterator<Position> positionIterator = listPosition.iterator();
        while (positionIterator.hasNext()) {
            Position pos = positionIterator.next();
            System.out.println("pos_code: " + pos.getPosCode() + " Position Title: " + pos.getPosTitle());
        }
        Position pos = new Position("1116", "DB Administrator", "FT",
                "15-1250", "98000", "S");
        pos.commit(conn);
        Integer newPosCode = pos.getPosCode();
        Position testPosition = Position.retrievePosition(newPosCode, conn);
        System.out.println(testPosition.getPosTitle());
    }
    catch (SQLException sqlEx) {
        System.err.println(sqlEx.toString());
    }
}
}
