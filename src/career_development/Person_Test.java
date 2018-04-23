package career_development;

import java.sql.*;
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

            Course c = Course.retrieveCourse(12,conn);
            Section s = Section.retrieveSection(c,2,Date.valueOf("2018-05-11"),conn);
            System.out.println(s);
            p.personTakes(s,conn);
//
//            PreparedStatement ps = conn.prepareStatement("SELECT * FROM SECTION");
//            ResultSet rs = ps.executeQuery();
//            while(rs.next()){
//                Integer cCode = rs.getInt("c_code");
//                Integer secCode = rs.getInt("sec_code");
//                Date d = rs.getDate("complete_date");
//                System.out.println(d);
//                Course c = Course.retrieveCourse(cCode,conn);
//                Date today = Date.valueOf("2018-05-11");
//                Section s = Section.retrieveSection(c,secCode,today,conn);
//                System.out.println(secCode);
//                System.out.println(today.equals(d));
//            }


//            Date d = Date.valueOf("2018-05-11");
//            System.out.println(d);

//            System.out.println(s.getFirst().getSecCode());



        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println(e.toString());
        }
    }
}