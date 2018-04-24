package career_development;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.*;
import java.util.Iterator;
import java.util.LinkedList;

public class NewEmployeeApp {

    public static Integer loggedInCompanyID;
    public static Connection conn;
    public static BufferedReader in;
    public static LinkedList<Position> companyPositions;
    public static Position activePosition;
    public static Person activePerson;

    public static void main(String[] args) {
        String userName = "gtswanso";
        String password = "sNNP9R9R";

        String hostName = "dbsvcs.cs.uno.edu";
        int port = 1521;
        String sid = "orcl";
        in = new BufferedReader(new InputStreamReader(System.in));
        try {
            conn = DriverManager.getConnection("jdbc:oracle:thin:" + userName + "/" + password + "@" + hostName + ":" + port + ":" + sid);
            printLogIn();
            int choice = 99;
            while (choice > 0) {
                printMenu();
                /*NEED TO ADD preTrngPlan() from Person, which is Query 9 and handles just one course filling the need*/
                try {
                    String line = in.readLine();
                    choice = Integer.parseInt(line);
                    if (choice == 2) {              //verify qualified people
                        boolean qualled = activePosition.isQualified(activePerson,conn);
                        if(qualled){
                            System.out.println("Person is qualified for this position.");
                        }
                        else{
                            System.out.println("Person is not qualified for this position.");
                        }
                        activePosition = null;
                        activePerson = null;
                    } else if (choice == 3) {       //training plan
                        boolean qualled = activePosition.isQualified(activePerson,conn);
                        if(qualled){
                            System.out.println("Person is qualified for this position.");
                        }
                        else{
                            LinkedList<Course> trainingPlan = activePerson.trainingPlan(activePosition, conn);
                            Iterator<Course> trainingPlanIterator = trainingPlan.iterator();
                            System.out.println("Suggested training plan: ");
                            Double totalPrice = 0.00;
                            while(trainingPlanIterator.hasNext()){
                                Course course = trainingPlanIterator.next();
                                totalPrice += course.getRetailPrice();
                                System.out.println("Course title: " + course.getTitle() + ". Course cost: " +
                                        course.getRetailPrice() + ".");
                            }
                            System.out.println("Total price for required courses: " + totalPrice);
                        }
                        activePosition = null;
                        activePerson = null;
                    } else if (choice == 1){        //upload transcripts
                        LinkedList<Course> allCourses = Course.retrieveAllCourses(conn);
                        Iterator<Course> courseIterator = allCourses.iterator();
                        System.out.println("Available courses:");
                        Course c = null;
                        while (courseIterator.hasNext()) {
                            Course course = courseIterator.next();
                            System.out.println("Course Code: " + course.getCCode() + "." +
                                    "Course Title: " + course.getTitle() + ".");
                        }
                        Integer courseID = null;
                        LinkedList<Section> allSections = null;
                        while (c == null || courseID == null) {
                            try {
                                String line1 = in.readLine();
                                courseID = Integer.parseInt(line1);
                                c = Course.retrieveCourse(courseID, conn);
                                allSections = Section.retrieveCourseSections(c, conn);
                                if (activePerson == null || allSections.isEmpty()) {
                                    c = null;
                                    System.err.println("Invalid course code; select again.");
                                }
                            } catch (IOException e) {
                                System.err.println(e.toString());
                            } catch (NumberFormatException nfe) {
                                System.err.println("Enter valid number.");
                            }
                        }

                        Iterator<Section> sectionIterator = allSections.iterator();
                        System.out.println("Available sections for this course:");
                        int count = 0;
                        while (sectionIterator.hasNext()) {
                            count ++;
                            Section section = sectionIterator.next();
                            System.out.println(count + " Section Code: " + section.getSecCode() + "." +
                                    "Complete Date: " + section.getCompleteDate() + ".");
                        }
                        Section s = null;
                        Integer sectionID = null;
                        while (s == null && sectionID == null) {
                            try {
                                String line1 = in.readLine();
                                sectionID = Integer.parseInt(line1);
                                s = allSections.get(count - 1);
                                if (activePerson == null) {
                                    System.err.println("Invalid section code; select again.");
                                }
                            } catch (IOException e) {
                                System.err.println(e.toString());
                            } catch (NumberFormatException nfe) {
                                System.err.println("Enter valid number.");
                            }
                        }
                        activePerson.personTakes(s, conn);
                        activePerson = null;
                        activePosition = null;
                    }
                } catch (IOException ioEx) {

                } catch (NumberFormatException nfe) {

                }
            }
        } catch (SQLException sqlEx) {
            System.err.println(sqlEx);
        }

    }

    public static void printLogIn() throws SQLException {
        PreparedStatement companyList = conn.prepareStatement("SELECT comp_id, comp_name FROM company");
        ResultSet rs = companyList.executeQuery();
        System.out.println("Select company:");
        while (rs.next()) {
            System.out.println(rs.getInt(1) + ". " + rs.getString(2));
        }
        System.out.println("Press 0 to exit.");
        while (loggedInCompanyID == null) {
            try {
                String line = in.readLine();
                loggedInCompanyID = Integer.parseInt(line);
                if(loggedInCompanyID == 0){
                    System.exit(0);
                }
                companyPositions = Position.retrievePositionsByCompany(loggedInCompanyID, conn);
                if (companyPositions.isEmpty()) {
                    System.err.println("Non-existent company or company has no positions, select again.");
                    loggedInCompanyID = null;
                }
            } catch (IOException e) {
                System.err.println(e.toString());
            } catch (NumberFormatException nfe) {
                System.err.println("Enter valid number.");
            }
        }
    }

    public static void printMenu() {
        System.out.println("Welcome to New Employee App!");
        System.out.println("Active positions:");
        Iterator<Position> positionIterator = companyPositions.iterator();
        while (positionIterator.hasNext()) {
            Position position = positionIterator.next();
            System.out.println(position.getPosCode() + ". " + position.getPosTitle());
        }
        System.out.println("Press 0 to exit.");
        Integer positionID = null;
        while (activePosition == null && positionID == null) {
            try {
                String line = in.readLine();
                positionID = Integer.parseInt(line);
                if(positionID == 0){
                    System.exit(0);
                }
                activePosition = Position.retrievePosition(positionID, conn);
                if (activePosition == null || activePosition.getCompID().equals(loggedInCompanyID) == false) {
                    System.err.println("Invalid position code, select again.");
                    activePosition = null;
                }
            } catch (IOException e) {
                System.err.println(e.toString());
            } catch (NumberFormatException nfe) {
                System.err.println("Enter valid number.");
            }
        }
        LinkedList<Person> allPeople = Person.retrieveAllPeople(conn);
        Iterator<Person> personIterator = allPeople.iterator();
        while (personIterator.hasNext()) {
            Person person = personIterator.next();
            System.out.println(person.getPersID() + ". " + person.getFullName());
        }
        Integer personID = null;
        System.out.println("Press 0 to exit.");
        while (activePerson == null || personID == null) {
            try {
                String line = in.readLine();
                personID = Integer.parseInt(line);
                if(personID == 0){
                    System.exit(0);
                }
                activePerson = Person.retrievePerson(personID, conn);
                if (activePerson == null) {
                    System.err.println("Invalid person code, select again.");
                }
            } catch (IOException e) {
                System.err.println(e.toString());
            } catch (NumberFormatException nfe) {
                System.err.println("Enter valid number.");
            }
        }
        System.out.println("1. Upload new employee transcripts");
        System.out.println("2. Verify new employee is qualified for the position");
        System.out.println("3. Print training plan");
        System.out.println("0. Quit");
    }
}
