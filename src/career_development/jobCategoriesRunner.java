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
            String userName = "jtmarch1";
            String password = "Tg4zJWx7";
            String hostName = "dbsvcs.cs.uno.edu";
            int port = 1521;
            String sid = "orcl";
            Connection conn = DriverManager.getConnection("jdbc:oracle:thin:" + userName + "/" + password + "@" + hostName + ":" + port + ":" + sid);
            Course course = Course.retrieveCourse(1, conn);
            System.out.println("Title: " + course.getTitle());
            List<Course> list = Course.retrieveAllCourses(conn);
            Iterator<Course> courseIterator = list.iterator();
            while(courseIterator.hasNext()) {
                Course c = courseIterator.next();
                System.out.println("c_code: " + c.getCCode() + " Title: " + c.getTitle());
            }
            Course c = new Course ("Sample Course2", "Intermediate", "E", 1234.54,
                    "Traditional", "Check to see if this is working.");
            c.commit(conn);
            Integer newCCode = c.getCCode();
            Course testCourse = Course.retrieveCourse(newCCode, conn);
            System.out.println(testCourse.getRetailPrice());
        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
            System.err.println("Connection failed");
        }
	// write your code here
    }
}
