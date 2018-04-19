package career_development;

import javax.tools.JavaCompiler;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.time.LocalDate;
import java.sql.Date;
import java.util.Iterator;
import java.util.List;



public class Main {

    //TODO: Add close for statements and connection
    public static void main(String[] args) {
        try {
            String userName = "";
            String password = "";

            String hostName = "dbsvcs.cs.uno.edu";
            int port = 1521;
            String sid = "orcl";
            Connection conn = DriverManager.getConnection("jdbc:oracle:thin:" + userName + "/" + password + "@" + hostName + ":" + port + ":" + sid);

            /*COURSE*/
            //Course course = Course.retrieveCourse(1, conn);
            List<Course> list = Course.retrieveAllCourses(conn);
            Iterator<Course> courseIterator = list.iterator();
            while (courseIterator.hasNext()) {
                Course c = courseIterator.next();
                System.out.println("c_code: " + c.getCCode() + " Title: " + c.getTitle());
            }
            Course c = new Course ("Sample Course2", "Intermediate", "E", 1234.54,
                    "Traditional", "Check to see if this is working.");
            c.commit(conn);
            Integer newCCode = c.getCCode();
            Course testCourse = Course.retrieveCourse(newCCode, conn);
            System.out.println("Retail Price: " + testCourse.getRetailPrice());








            /*PERSON*/
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

            //Skill testSkillB = Skill.retrieveSkill("Java", conn);

            System.out.println(testPerson.getFirstName());
            System.out.println(testPerson.getSkills(conn));   //RETURNS NULL FIX METHOD IN PERSON, FIX CLASS SKILL IF NEEDED


            /*POSITION*/
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



                                    /*SECTION*/
            //LocalDate date = new LocalDate (2018,5, 11);
            //LocalDate date = LocalDate.of(Integer.parseInt(2018), Integer.parseInt(5), Integer.parseInt(11));
            //java.sql.Date date = new java.sql.Date(2018, 4, 11);
            Section section = Section.retrieveSection(c, 4, Date.valueOf("2018-04-11"), conn);
            // System.out.println("ConpleteDate: " + section.getCompleteDate());
            List<Section> secList = Section.retrieveCourseSections(c,conn);
            Iterator<Section> sectionIterator = secList.iterator();
            while (sectionIterator.hasNext()) {
                Section section1 = sectionIterator.next();
                System.out.println("seccode: " + section1.getSecCode() + " teacher: " + section1.getTeacher());
            }
            Section section2 = new Section (c, 4, Date.valueOf("2018-04-11"), 1,
                    p, "Traditional", 19.00f );
             section2.commit();
            Integer newsecCode = section2.getSecCode();
            Section testSection = Section.retrieveSection(c, 4, Date.valueOf("2018-05-11"), conn);
            System.out.println(" Price: " + section2.getPrice());

//



            /*JOB CATEGORY*/
            JobCategory jobCategory = JobCategory.retrieveJobCategory("1", conn);
            //System.out.println("Job Category Title: " + jobCategory.getJobCategoryTitle());
            List<JobCategory> listJobCategory = JobCategory.retrieveAllJobCategories(conn);
            Iterator<JobCategory> jobCategoryIterator = listJobCategory.iterator();
            while(jobCategoryIterator.hasNext()) {
                JobCategory jc = jobCategoryIterator.next();
                System.out.println("cat_code: " + jc.getCatCode() + " Job Category Title: " + jc.getJobCategoryTitle());
            }
            JobCategory jc = new JobCategory ("Sample Job General", "General Job", "Job Worker",
                    "This is a job for a person who can do a job", 20000.00f, 10000.00f);
            jc.commit(conn);
            String newCatCode = jc.getCatCode();
            JobCategory testJobCategory = JobCategory.retrieveJobCategory(newCatCode, conn);

            /*SKILL*/
            Skill skill = Skill.retrieveSkill("Java", conn);
            System.out.println("KS_Code: " + skill.getKs_code());
            List<Skill> listSkill = Skill.retrieveAllSkills(conn);
            Iterator<Skill> skillIterator = listSkill.iterator();
            while (skillIterator.hasNext()){
                Skill s = skillIterator.next();
                System.out.println("KS Title: " + s.getKs_title() + ". KS Description: " + s.getDescription());
            }
            Skill s = new Skill("Java3","ESAI", "Systems Analysis",
                                "Enterprise systems analysis", "Intermediate");
            s.commit(conn);
            String newKsCode = s.getKs_code();
            Skill testSkill = Skill.retrieveSkill(newKsCode, conn);
            System.out.println(testSkill.getTraining_level());

            testPerson.addSkill(s, conn);

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