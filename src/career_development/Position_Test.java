package career_development;

import javafx.geometry.Pos;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by Gaby's Laptop on 4/19/2018.
 */
public class Position_Test {
        public static void main(String[] args) {
            try {
                String userName = "";
                String password = "";

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
                Position pos = new Position(1116, "DB Administrator", "FT",
                        "15-1250", "98000", "S");
                pos.commit(conn);
                Integer newPosCode = pos.getPosCode();
                Position testPosition = Position.retrievePosition(newPosCode, conn);
                System.out.println(testPosition.getPosTitle());
                Position p = Position.retrievePosition(7, conn);
                LinkedList<Person> qualPeople = p.getQualifiedPeople(conn);
                Iterator<Person> qualIterator = qualPeople.iterator();
                while(qualIterator.hasNext()) {
                    Person pers = qualIterator.next();
                    System.out.println(pers.getPersID());
                }
                Person chris = Person.retrievePerson(7, conn);
                Skill ang3 = Skill.retrieveSkill("Angular3", conn);
                boolean beforeAdd = p.isQualified(chris, conn);
                System.out.println(beforeAdd);
                chris.addSkill(ang3, conn);
                boolean afterAdd = p.isQualified(chris, conn);
                System.out.println(afterAdd);
                Person person = Person.retrievePerson(6, conn);
                boolean qualified = p.isQualified(person, conn);
                System.out.println(qualified);
                Position posTwelve = Position.retrievePosition(12, conn);
                LinkedList<Person> almostQualified = new LinkedList<Person>();
                Integer minMissingSkills = posTwelve.findAlmostQualifiedPeople(conn, almostQualified);
                System.out.println(minMissingSkills);
                Iterator<Person> almostIterator = almostQualified.iterator();
                while(almostIterator.hasNext()) {
                    Person person1 = almostIterator.next();
                    System.out.println(person1.getLastName());
                }
            }
        catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
        }
    }
}
