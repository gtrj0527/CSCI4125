package career_development;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.*;
import java.util.Iterator;
import java.util.LinkedList;

public class CompanyRecruiterApp {

    public static Integer loggedInCompanyID;
    public static Connection conn;
    public static BufferedReader in;
    public static LinkedList<Position> companyPositions;
    public static Position activePosition;

    public static void main(String[] args) {
        String userName = "jtmarch1";
        String password = "Tg4zJWx7";

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
                try {
                    String line = in.readLine();
                    choice = Integer.parseInt(line);
                    if (choice == 1) {
                        LinkedList<Person> people = activePosition.getQualifiedPeople(conn);
                        Iterator<Person> peopleIterator = people.iterator();
                        System.out.println("Qualified people:");
                        while (peopleIterator.hasNext()) {
                            Person person = peopleIterator.next();
                            System.out.println(person.getPersID() + "." + person.getLastName());
                        }
                        activePosition = null;
                    } else if (choice == 2) {
                        LinkedList<Person> people = new LinkedList<Person>();
                        Integer minMissingSkills = activePosition.findAlmostQualifiedPeople(conn, people);
                        System.out.println("Minimum missing skills: " + minMissingSkills);
                        Iterator<Person> peopleIterator = people.iterator();
                        System.out.println("Almost Qualified people:");
                        while (peopleIterator.hasNext()) {
                            Person person = peopleIterator.next();
                            System.out.println(person.getPersID() + "." + person.getLastName());
                        }
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
        while (loggedInCompanyID == null) {
            try {
                String line = in.readLine();
                loggedInCompanyID = Integer.parseInt(line);
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
        System.out.println("Welcome to Company Recruiter!");
        System.out.println("Active positions:");
        Iterator<Position> positionIterator = companyPositions.iterator();
        while (positionIterator.hasNext()) {
            Position position = positionIterator.next();
            System.out.println(position.getPosCode() + ". " + position.getPosTitle());
        }
        Integer positionID = null;
        while (activePosition == null && positionID == null) {
            try {
                String line = in.readLine();
                positionID = Integer.parseInt(line);
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
        System.out.println("1. Find qualified people");
        System.out.println("2. Find almost qualified people");
        System.out.println("0. Quit");
    }
}
