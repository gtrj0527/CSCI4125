package career_development;

import java.sql.Connection;
import java.sql.Date;
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
            String userName = "tbourg";
            String password = "K3LWXCPt";

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
            Course c = new Course ("Testing", "Intermediate", "E", 854.72,
                    "Online", "Checking the testPerson method.");
            Section s = new Section (c, 7, Date.valueOf("2018-05-11"), 3,
                    p, "Online", 23.00f );
            //testPerson.personTakes(c,s,testPerson,conn);
            System.out.println(s.getSecCode());



        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println(e.toString());
        }
    }
}