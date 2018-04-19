package career_development;

import java.sql.*;
import java.util.LinkedList;
import oracle.jdbc.OracleTypes;
import oracle.jdbc.internal.OraclePreparedStatement;


public class Section {

    private Course course;
    private Integer secCode;
    private Date completeDate;
    private Integer trainingProviderID;
    private Person teacher;
    private String format;
    private Float price;
    private boolean dirty;

    public static Section retrieveSection(Course course, Integer secCode, Date completeDate, Connection conn) {
        PreparedStatement retrSection;
        try {
            retrSection = conn.prepareStatement("SELECT offered_by, taught_by, format, price " +
                    " FROM section WHERE c_code = ?, sec_code = ?, complete_date = ?");
            retrSection.setInt(1, course.getCCode());
            retrSection.setInt(2, secCode);
            retrSection.setDate(3, completeDate);
            ResultSet rs = retrSection.executeQuery();
            if(rs.next()) {
                Integer trainingProvider = rs.getInt(1);
                Integer taughtBy = rs.getInt(2);
                Person teacher = Person.retrievePerson(taughtBy, conn);
                String format = rs.getString(3);
                Float price = rs.getFloat(4);
                return new Section(course, secCode, completeDate, trainingProvider, teacher, format, price, true);
            }
            return null;
        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
            return null;
        }
    }

    public static LinkedList<Section> retrieveCourseSections(Course course, Connection conn) {
        PreparedStatement getSections;
        LinkedList<Section> sectionLinkedList = new LinkedList<Section>();
        try {
            getSections = conn.prepareStatement("SELECT sec_code, complete_date FROM section WHERE c_code = ?");
            getSections.setInt(1, course.getCCode());
            ResultSet rs = getSections.executeQuery();
            while(rs.next()) {
                Integer secCode = rs.getInt(1);
                Date completeData = rs.getDate(2);
                Section sec = retrieveSection(course, secCode, completeData, conn);
                sectionLinkedList.add(sec);
            }
            return sectionLinkedList;
        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
            return null;
        }
    }

    private Section(Course course, Integer secCode, Date completeDate, Integer trainingProviderID, Person person,
                    String format, Float price, boolean dirty) {
        this.course = course;
        this.secCode = secCode;
        this.completeDate = completeDate;
        this.trainingProviderID = trainingProviderID;
        this.teacher = person;
        this.format = format;
        this.price = price;
        this.dirty = dirty;
    }

    public Section(Course course, Integer secCode, Date completeDate, Integer trainingProviderID, Person person,
                    String format, Float price) {
        this.course = course;
        this.secCode = secCode;
        this.completeDate = completeDate;
        this.trainingProviderID = trainingProviderID;
        this.teacher = person;
        this.format = format;
        this.price = price;
        this.dirty = true;
    }

    public Course getCourse() {
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
        this.dirty = true;
    }

    public Integer getSecCode() {
        return secCode;
    }

    public void setSecCode(Integer secCode) {
        this.secCode = secCode;
        this.dirty = true;
    }

    public Date getCompleteDate() {
        return completeDate;
    }

    public void setCompleteDate(Date completeDate) {
        this.completeDate = completeDate;
    }

    public Integer getTrainingProviderID() {
        return trainingProviderID;
    }

    public void setTrainingProviderID(Integer trainingProviderID) {
        this.trainingProviderID = trainingProviderID;
    }

    public Person getTeacher() {
        return teacher;
    }

    public void setTeacher(Person teacher) {
        this.teacher = teacher;
    }

    public String getFormat() {
        return format;
    }

    public void setFormat(String format) {
        this.format = format;
    }

    public Float getPrice() {
        return price;
    }

    public void setPrice(Float price) {
        this.price = price;
    }

    public void commit() {
        if(!dirty) {
            return;
        }
    }


    //*INSERT SECTION*//

    private void store (Connection conn) {
        try {
            OraclePreparedStatement preparedStatement =
                    (OraclePreparedStatement)conn.prepareStatement("INSERT INTO section (c_code, sec_code" +
                            "complete_date, offered_by, taught_by, format_price) VALUES(?,?,?,?,?,?,?,?)");
            preparedStatement.setInt(1,course.getCCode());
            preparedStatement.setInt(2, secCode);
            preparedStatement.setDate(3, completeDate);
            preparedStatement.setInt(4, trainingProviderID);
            preparedStatement.setInt(5, teacher.getPersID());
            preparedStatement.setString(6, format);
            preparedStatement.setFloat(7, price);
            preparedStatement.execute();

        }catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
        }
    }


    /*    private Course course;
    private Integer secCode;
    private Date completeDate;
    private Integer trainingProviderID;
    private Person teacher;
    private String format;
    private Float price;*/
}