package career_development;

import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

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
                Integer pers_id = rs.getInt(1);
                String last_name = rs.getString(2);
                String first_name = rs.getString(3);
                String mi = rs.getString(4);
                String address1 = rs.getString(5);
                String address2 = rs.getString(6);
                String city = rs.getString(7);
                String state = rs.getString(8);
                String zip = rs.getString(9);
                String email = rs.getString(10);
                String gender = rs.getString(11);
                personList.add(new Person(pers_id, last_name, first_name, mi, address1, address2, city, state,
                                          zip, email, gender));
            }
            rs.close();
            retrPerson.close();
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
                String last_name = rs.getString(2);
                String first_name = rs.getString(3);
                String mi = rs.getString(4);
                String address1 = rs.getString(5);
                String address2 = rs.getString(6);
                String city = rs.getString(7);
                String state = rs.getString(8);
                String zip = rs.getString(9);
                String email = rs.getString(10);
                String gender = rs.getString(11);
                rs.close();
                retrPerson.close();
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

    public void setAddress2(String address2) {
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

    private void update(Connection conn, Position dbPerson) {
        PreparedStatement updatePerson;
        try {
            updatePerson = conn.prepareStatement("UPDATE person SET last_name = ?, first_name = ?, mi = ?, " +
                    "address1 = ?, address2 = ?,zip = ?, email = ?, gender = ? WHERE pos_code = ?");
            int rowsAffected = updatePerson.executeUpdate();
            System.out.println(rowsAffected + " were updated.");
        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
        }
    }

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


    public LinkedList<String> getSkills (Connection conn) {
        PreparedStatement retrPersonSkills;
        LinkedList<String> personSkillsList = new LinkedList<>();

        try{
            retrPersonSkills=conn.prepareStatement("SELECT ks_code FROM has_skill WHERE pers_id=?");
            retrPersonSkills.setInt(1, pers_id);
            ResultSet rs = retrPersonSkills.executeQuery();
            if(rs.next()) {
                String pers_id = rs.getString(1);

               String ks_code = rs.getString(2);
                personSkillsList.add(new String (ks_code));
               System.out.println(pers_id);
               System.out.println(ks_code);
               rs.close();
               retrPersonSkills.close();
            }
        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
            return null;
        }
        return personSkillsList;
    }

    public void addSkill (Skill skill, Connection conn) {
        PreparedStatement addSkill;
        try{
            addSkill = conn.prepareStatement("INSERT INTO has_skill(pers_id, ks_code) VALUES (?, ?)");
            addSkill.setInt(1,pers_id);
            addSkill.setString(2, skill.getKs_code());
            addSkill.execute();
            addSkill.close();
        }
        catch (SQLException sqlEx){
            System.err.println(sqlEx.toString());
        }
    }

    // Needs to be listQualifiedJobCategories
    public LinkedList<JobCategory> listQualifiedJobCategories(Connection conn){
        LinkedList<JobCategory> qualifiedJobCategories = new LinkedList<>();
        try {
            String query = "WITH category_qual AS (\n" +
                    "        (SELECT pers_id, cat_code\n" +
                    "        FROM person, job_category)\n" +
                    "        MINUS\n" +
                    "        (SELECT distinct pers_id, cat_code\n" +
                    "        FROM (SELECT pers_id, cat_code, ks_code\n" +
                    "              FROM person, (SELECT cat_code, ks_code \n" +
                    "                            FROM know_skill ks\n" +
                    "                            JOIN nwcet n ON ks.nwcet_code = n.nwcet_code\n" +
                    "                            JOIN job_category j ON n.nwcet_code = j.core_skill)\n" +
                    "              MINUS \n" +
                    "              SELECT pers_id, cat_code, ks_code\n" +
                    "              FROM ( SELECT p.pers_id, j.cat_code, ks.ks_code \n" +
                    "                     FROM person p\n" +
                    "                     JOIN has_skill hs ON p.pers_id = hs.pers_id\n" +
                    "                     JOIN know_skill ks ON hs.ks_code = ks.ks_code\n" +
                    "                     JOIN nwcet n ON ks.nwcet_code = n.nwcet_code\n" +
                    "                     JOIN job_category j ON n.nwcet_code = j.core_skill))))\n" +
                    "SELECT cat_code\n" +
                    "FROM category_qual\n" +
                    "WHERE pers_id = ?";
            PreparedStatement listQualifiedJobCategories = conn.prepareStatement(query);
            listQualifiedJobCategories.setInt(1,this.pers_id);
            ResultSet rs = listQualifiedJobCategories.executeQuery();
            while(rs.next()) {
                JobCategory category = JobCategory.retrieveJobCategory(rs.getString(1), conn);
                qualifiedJobCategories.add(category);
            }
            rs.close();
            listQualifiedJobCategories.close();
        }
        catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
        }
        return qualifiedJobCategories;
    }
}