package career_development;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by Gaby's Laptop on 4/19/2018.
 */
public class Person_Test {
    public static void main(String[] args) {
        try {
            String userName = "gtswanso";
            String password = "sNNP9R9R";

            String hostName = "dbsvcs.cs.uno.edu";
            int port = 1521;
            String sid = "orcl";
            Connection conn = DriverManager.getConnection("jdbc:oracle:thin:" + userName + "/" + password + "@" + hostName + ":" + port + ":" + sid);

            Person person = Person.retrievePerson(1, conn);
            List<Person> listPerson = Person.retrieveAllPeople(conn);
            Iterator<Person> personIterator = listPerson.iterator();
            while (personIterator.hasNext()) {
                Person p = personIterator.next();
                System.out.println("pers_id: " + p.getPersID() + " Last Name: " + p.getLastName());
            }
            Person p = new Person("Organa", "Leia", "S",
                    "87 Republic Way", "Suite 27A", "70447", "leia.organa@republic.org",
                    "F");
            p.commit(conn);
            Integer newPersID = p.getPersID();
            Person testPerson = Person.retrievePerson(newPersID, conn);

            System.out.println(testPerson.getEmail());

            Course course = new Course();
            Section section = new Section();
            Person test2 = new Person("Skywalker", "Luke", "", "Middle of Nowhere", "Rock 3", "04496",
                    "very_lonely_luke@galaxy.com", "M");
            test2.retrievePerson(newPersID, conn);
            test2.personTakes(course, section, date, test2, conn);


        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println(e.toString());
        }
    }
}