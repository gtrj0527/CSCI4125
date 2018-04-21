package career_development;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.LinkedList;

public class JobHuntingApp {

    public static Person loggedInUser;
    public static Connection conn;
    public static BufferedReader in;

    public static void main(String[] args) {
        String userName = "tbourg";
        String password = "K3LWXCPt";

        String hostName = "dbsvcs.cs.uno.edu";
        int port = 1521;
        String sid = "orcl";
        in = new BufferedReader(new InputStreamReader(System.in));
        try {
            conn = DriverManager.getConnection("jdbc:oracle:thin:" + userName + "/" + password + "@" + hostName + ":" + port + ":" + sid);
            printLogIn();
            int choice = 99;
            while(choice > 0) {
                printMenu();
                try {
                    String line = in.readLine();
                    choice = Integer.parseInt(line);
                    if(choice == 1) {
                        Position position = loggedInUser.findHighestPayingQualifiedPosition(conn);
                        System.out.println("Highest Paying Position:");
                        System.out.println("Position code: " + position.getPosCode());
                        System.out.println("Job Title: " + position.getPosTitle());
                    } else if(choice == 2) {
                        LinkedList<JobCategory> jobCats = loggedInUser.listQualifiedJobCategories(conn);
                        Iterator<JobCategory> iterator = jobCats.iterator();
                        System.out.println("Qualified Job Categories:");
                        while(iterator.hasNext()) {
                            JobCategory jobCategory = iterator.next();
                            System.out.println(jobCategory.getCatCode() + "\t" + jobCategory.getJobCategoryTitle());
                        }
                    }
                } catch(IOException ioEx) {

                } catch(NumberFormatException nfe) {

                }
            }
        } catch (SQLException sqlEx) {
            System.err.println(sqlEx);
        }

    }

    public static void printLogIn() {
        LinkedList<Person> people = Person.retrieveAllPeople(conn);
        Iterator<Person> peopleIterator = people.iterator();
        System.out.println("Choose person:");
        while(peopleIterator.hasNext()) {
            Person person = peopleIterator.next();
            System.out.println(person.getPersID() + "." + person.getFullName());
        }
        Integer persID = null;
        while(persID == null && loggedInUser == null) {
            try {
                String line = in.readLine();
                persID = Integer.parseInt(line);
                loggedInUser = Person.retrievePerson(persID, conn);
                if(loggedInUser == null) {
                    System.err.println("Enter valid user.");
                }
            } catch (IOException e) {
                System.err.println(e.toString());
            } catch (NumberFormatException nfe) {
                System.err.println("Enter valid number.");
            }
        }
    }

    public static void printMenu() {
        System.out.println("Welcome to Job Hunter!");
        System.out.println("1. Find max paying qualified position");
        System.out.println("2. Find qualified category");
        System.out.println("0. Quit");
    }
}
