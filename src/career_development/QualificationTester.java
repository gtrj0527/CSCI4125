package career_development;

import javafx.geometry.Pos;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.LinkedList;

public class QualificationTester {

    public static void main(String[] args) {
        try {
            String userName = "gtswanso";
            String password = "sNNP9R9R";

            String hostName = "dbsvcs.cs.uno.edu";
            int port = 1521;
            String sid = "orcl";
            Connection conn = DriverManager.getConnection("jdbc:oracle:thin:" + userName + "/" + password + "@" + hostName + ":" + port + ":" + sid);

            LinkedList<Position> positions = Position.retrieveAllPositions(conn);
            Iterator<Position> positionIterator = positions.iterator();
            while(positionIterator.hasNext()) {
                Position pos = positionIterator.next();
                LinkedList<Person> qualifiedPeople = pos.getQualifiedPeople(conn);
                System.out.println(pos.getPosCode() + " " + pos.getPosTitle());
                System.out.println("Qualified people:");
                Iterator<Person> personIterator = qualifiedPeople.iterator();
                while(personIterator.hasNext()) {
                    Person pers = personIterator.next();
                    System.out.println("\t" + pers.getLastName() + ", " + pers.getFirstName());
                    LinkedList<JobCategory> catList = pers.listQualifiedJobCategories(conn);
                    Iterator<JobCategory> jobCategoryIterator = catList.iterator();
                    while(jobCategoryIterator.hasNext()) {
                        JobCategory jobCat = jobCategoryIterator.next();
                        System.out.println("\t\t" +jobCat.getCatCode() + "\n");
                    }
                }
            }
            conn.close();
        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
        }
    }
}
