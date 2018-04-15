package career_development;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;

public class Main {

    //TODO: Add close for statements and connection
    public static void main(String[] args) {
        try {
            String userName = "gtswanso";
            String password = "sNNP9R9R";
            String hostName = "dbsvcs.cs.uno.edu";
            int port = 1521;
            String sid = "orcl";
            Connection conn = DriverManager.getConnection("jdbc:oracle:thin:" + userName + "/" + password + "@" + hostName + ":" + port + ":" + sid);

            /**/
            Course course = Course.retrieveCourse(1, conn);
            System.out.println("Title: " + course.getTitle());
            List<Course> list = Course.retrieveAllCourses(conn);
            Iterator<Course> courseIterator = list.iterator();
            while(courseIterator.hasNext()) {
                Course c = courseIterator.next();
                System.out.println("c_code: " + c.getCCode() + " Title: " + c.getTitle());
            }
//
//            /*Test Course */
//            Course c = new Course ("Sample Course2", "Intermediate", "E", 1234.54,
//                    "Traditional", "Check to see if this is working.");
//            c.commit(conn);
//            Integer newCCode = c.getCCode();
//            Course testCourse = Course.retrieveCourse(newCCode, conn);
//            System.out.println(testCourse.getRetailPrice());
//        } catch (SQLException sqlEx) {
//            System.err.println(sqlEx.toString());
//            System.err.println("Connection failed");
//        }
//	// write your code here
//    }
//}

            /*Test Person */
            Person person = Person.retrievePerson(1, conn);
            System.out.println("Last Name: " + person.getLastName());
            List<Person> listPerson = Person.retrieveAllPeople(conn);
            Iterator<Person> personIterator = listPerson.iterator();
            while(personIterator.hasNext()) {
                Person p = personIterator.next();
                System.out.println("pers_id: " + p.getPersID() + " Last Name: " + p.getLastName());
            }
            Person p = new Person ("Organa", "Leia", "S",
                    "87 Republic Way", "Suite 27A", "84392", "leia.organa@republic.org",
                    "F");
            p.commit(conn);
            Integer newPersID = p.getPersID();
            Person testPerson = Person.retrievePerson(newPersID, conn);
            System.out.println(testPerson.getEmail());
        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
            System.err.println("Connection failed");
        }
	// write your code here
    }
}

