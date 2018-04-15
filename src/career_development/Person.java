package career_development;

import java.sql.*;
import java.util.LinkedList;
import oracle.jdbc.OracleTypes;
import oracle.jdbc.internal.OraclePreparedStatement;

public class Person {
    private Integer pers_id;
    private String last_name;
    private String first_name;
    private String mi;
    private String address1;
    private String address2;
    private String city;
    private String state;
    private String zip;
    private String email;
    private String gender;
    private boolean dirty; // potentially inconsistent with DB

    public static LinkedList<Person> retrieveAllPeople(Connection conn) {
        PreparedStatement retrPerson;
        LinkedList<Person> personList = new LinkedList<Person>();
        try {
            retrPerson = conn.prepareStatement("SELECT pers_id, last_name, first_name, mi, address1, address2, " +
                    "city, state, zip, email, gender FROM person NATURAL JOIN zip_code");
            ResultSet rs = retrPerson.executeQuery();
            while(rs.next()) {
                String last_name = rs.getString(1);
                String first_name = rs.getString(2);
                String mi = rs.getString(3);
                String address1 = rs.getString(4);
                String address2 = rs.getString(5);
                String city = rs.getString(6);
                String state = rs.getString(7);
                String zip = rs.getString(8);
                String email = rs.getString(9);
                String gender = rs.getString(10);
                Integer pers_id = rs.getInt(11);
                personList.add(new Person(pers_id, last_name, first_name, mi, address1, address2, city, state,
                                          zip, email, gender));
            }
        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
            return null;
        }
        return personList;
    }

    public static Person retrievePerson(Integer pers_id, Connection conn) {
        PreparedStatement retrPerson;
        try {
            retrPerson = conn.prepareStatement("SELECT pers_id, last_name, first_name, mi, address1, address2, " +
                    "city, state, zip, email, gender FROM person NATURAL JOIN zip_code WHERE pers_id = ?");
            retrPerson.setInt(1, pers_id);
            ResultSet rs = retrPerson.executeQuery();
            if(rs.next()){
                String last_name = rs.getString(1);
                String first_name = rs.getString(2);
                String mi = rs.getString(3);
                String address1 = rs.getString(4);
                String address2 = rs.getString(5);
                String city = rs.getString(6);
                String state = rs.getString(7);
                String zip = rs.getString(8);
                String email = rs.getString(9);
                String gender = rs.getString(10);
                return new Person(pers_id, last_name, first_name, mi, address1, address2, city, state, zip, email,
                        gender);
            }
            else {
                return null;
            }
        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
            return null;
        }
    }

    public Person(String last_name, String first_name, String mi, String address1, String address2, String zip,
                  String email, String gender) {
        this.last_name = last_name;
        this.first_name = first_name;
        this.mi = mi;
        this.address1 = address1;
        this.address2 = address2;
        this.zip = zip;
        this.email = email;
        this.gender = gender;
        this.dirty = true;
    }

    private Person(int pers_id, String last_name, String first_name, String mi, String address1, String address2,
                   String city, String state, String zip, String email, String gender) {
        this(last_name, first_name, mi, address1, address2, zip, email, gender);
        this.pers_id = pers_id;
        this.city = city;
        this.state = state;
    }

    public Integer getPersID() {
        return pers_id;
    }

    public String getLastName() {
        return last_name;
    }

    public void setLastName(String last_name) {
        this.dirty = this.last_name.equals(last_name);
        this.last_name = last_name;
    }

    public String getFirstName() {
        return first_name;
    }

    public void setFirstName(String first_name) {
        this.dirty = this.first_name.equals(first_name);
        this.first_name = first_name;
    }

    public String getMI() {
        return mi;
    }

    public void setMI(String mi) {
        this.dirty = this.mi.equals(mi);
        this.mi = mi;
    }

    public String getAddress1() {
        return address1;
    }

    public void setAddress1(String address1) {
        this.dirty = this.address1.equals(address1);
        this.address1 = address1;
    }

    public String getAddress2() {
        return address2;
    }

    public void setAddress2(String address1) {
        this.dirty = this.address2.equals(address2);
        this.address2 = address2;
    }

    public String getCity() {
        return city;
    }

//    public void setCity(String city) {
//        this.dirty = this.city.equals(city);
//        this.city = city;
//    }

    public String getState() {
        return state;
    }

//    public void setState(String state) {
//        this.dirty = this.state.equals(state);
//        this.state = state;
//    }

    public String getZip() {
        return zip;
    }

    public void setZip(String zip) {
        this.dirty = this.zip.equals(zip);
        this.zip = zip;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.dirty = this.email.equals(email);
        this.email = email;
    }

    public String getGender(){
        return gender;
    }

    public void setGender(String gender){
        this.dirty = this.gender.equals(gender);
        this.gender = gender;
    }


    // TODO -- not tested && add "UPDATES" function
    // On commit, if there's a new insert, the pers_id, etc will be set to the actual value
    public void commit(Connection conn) {
        if(!this.dirty) {
            return;
        }

        if(pers_id == null){
            this.store(conn);
        } else {
            Person dbPerson = Person.retrievePerson(pers_id, conn);
        }
    }

    // TODO
    private void update(Connection conn) {

    }

    // TODO -- not tested
    private void store(Connection conn) {
        try {
            OraclePreparedStatement preparedStatement =
                    (OraclePreparedStatement)conn.prepareStatement("INSERT INTO person(last_name, first_name, mi," +
                                    "address1, address2, zip, email, gender) VALUES (?, ?, ?, ?, ?, ?, ?, ?) " +
                                    "RETURNING pers_id INTO ?");
            preparedStatement.registerReturnParameter(9, OracleTypes.INTEGER);
            preparedStatement.setString(1, last_name);
            preparedStatement.setString(2, first_name);
            preparedStatement.setString(3, mi);
            preparedStatement.setString(4, address1);
            preparedStatement.setString(5, address2);
            preparedStatement.setString(6, zip);
            preparedStatement.setString(7, email);
            preparedStatement.setString(8, gender);
            preparedStatement.execute();
            ResultSet lastIDrs = preparedStatement.getReturnResultSet();
            if (lastIDrs.next() ) {
                // The generated id
                Integer pers_id = lastIDrs.getInt(1);
                System.out.println (pers_id);
                this.pers_id = pers_id;
            }
        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
        }
        this.dirty = false;
    }
}