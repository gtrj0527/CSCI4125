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

            String userName = "jtmarch1";
            String password = "Tg4zJWx7";

            String hostName = "dbsvcs.cs.uno.edu";
            int port = 1521;
            String sid = "orcl";
            Connection conn = DriverManager.getConnection("jdbc:oracle:thin:" + userName + "/" + password + "@" + hostName + ":" + port + ":" + sid);

            /*COURSE*/
            Course course = Course.retrieveCourse(1, conn);
//            System.out.println("Title: " + course.getTitle());
            List<Course> list = Course.retrieveAllCourses(conn);
            Iterator<Course> courseIterator = list.iterator();
            while (courseIterator.hasNext()) {
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

            /*PERSON*/
            Person person = Person.retrievePerson(1, conn);
//            System.out.println("Last Name: " + person.getLastName());
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
            //System.out.println(testPerson.hasSkill(testPerson, Java))

            System.out.println(testPerson.getFirstName());


            /*POSITION*/
            Position position = Position.retrievePosition(1, conn);
//            System.out.println("Position Title: " + position.getPosTitle());
            List<Position> listPosition = Position.retrieveAllPositions(conn);
            Iterator<Position> positionIterator = listPosition.iterator();
            while (positionIterator.hasNext()) {
                Position pos = positionIterator.next();
                System.out.println("pos_code: " + pos.getPosCode() + " Position Title: " + pos.getPosTitle());
            }
            Position pos = new Position("1116", "DB Administrator", "FT",
                    "15-1240", "98000", "S");
            pos.commit(conn);
            Integer newPosCode = pos.getPosCode();
            Position testPosition = Position.retrievePosition(newPosCode, conn);
            System.out.println(testPosition.getPosTitle());

            /*JOB CATEGORY*/
//            JobCategory jobCategory = JobCategory.retrieveJobCategory("1", conn);
//            System.out.println("Job Category Title: " + jobCategory.getJobCategoryTitle());
//            List<JobCategory> listJobCategory = JobCategory.retrieveAllJobCategories(conn);
//            Iterator<JobCategory> jobCategoryIterator = listJobCategory.iterator();
//            while(jobCategoryIterator.hasNext()) {
//                JobCategory jc = jobCategoryIterator.next();
//                System.out.println("cat_code: " + jc.getCatCode() + " Job Category Title: " + jc.getJobCategoryTitle());
//            }
//            JobCategory jc = new JobCategory ("Sample Job General", "General Job", "Job Worker",
//                    "This is a job for a person who can do a job", 20000.00f, 10000.00f);
//            jc.commit(conn);
//            String newcatCode = jc.getCatCode();
//            JobCategory testJobCategory = JobCategory.retrieveJobCategory(newcatCode, conn);
//            System.out.println(testJobCategory.getPayRangeHigh());

//        } catch (SQLException sqlEx) {
//            System.err.println(sqlEx.toString());
//            System.err.println("Connection failed");
//        }



        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
            System.err.println("Connection failed");
        }

    }
}