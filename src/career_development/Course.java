package career_development;

import java.sql.*;
import java.util.LinkedList;

public class Course {

    private Integer cCode;
    private String title;
    private String trainingLevel;
    private String status;
    private Double retailPrice;
    private String trainingType;
    private String description;
    private boolean dirty; // potentially inconsistent with DB

    public static LinkedList<Course> retrieveAllCourses(Connection conn) {
        PreparedStatement retrCourse;
        LinkedList<Course> courseList = new LinkedList<Course>();
        try {
            retrCourse = conn.prepareStatement("SELECT title, training_level, status, retail_price, " +
                                                    "train_type, description, c_code FROM course");
            ResultSet rs = retrCourse.executeQuery();
            while(rs.next()) {
                String title = rs.getString(1);
                String trainingLevel = rs.getString(2);
                String status = rs.getString(3);
                Double retailPrice = rs.getDouble(4);
                String trainingType = rs.getString(5);
                String description = rs.getString(6);
                Integer cCode = rs.getInt(7);
                courseList.add(new Course(cCode, title, trainingLevel, status, retailPrice, trainingType, description));
            }
        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
            return null;
        }
        return courseList;
    }

    public static Course retrieveCourse(Integer cCode, Connection conn) {
        PreparedStatement retrCourse;
        try {
            retrCourse = conn.prepareStatement("SELECT title, training_level, status, retail_price, " +
                                                    "train_type, description FROM course WHERE c_code = ?");
            retrCourse.setInt(1, cCode);
            ResultSet rs = retrCourse.executeQuery();
            rs.next();
            String title = rs.getString(1);
            String trainingLevel = rs.getString(2);
            String status = rs.getString(3);
            Double retailPrice = rs.getDouble(4);
            String trainingType = rs.getString(5);
            String description = rs.getString(6);
            return new Course(cCode, title, trainingLevel, status, retailPrice, trainingType, description);
        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
            return null;
        }
    }

    public Course(String title, String trainingLevel, String status, Double retailPrice,
                  String trainingType, String description) {
        this.title = title;
        this.trainingLevel = trainingLevel;
        this.status = status;
        this.retailPrice = retailPrice;
        this.trainingType = trainingType;
        this.description = description;
    }

    private Course(int cCode, String title, String trainingLevel, String status, double retailPrice,
                   String trainingType, String description) {
        this(title, trainingLevel, status, retailPrice, trainingType, description);
        this.cCode = cCode;
    }

    public int getCCode() {
        return cCode;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.dirty = this.title.equals(title);
        this.title = title;
    }

    public String getTrainingLevel() {
        return trainingLevel;
    }

    public void setTrainingLevel(String trainingLevel) {
        this.dirty = this.trainingLevel.equals(trainingLevel);
        this.trainingLevel = trainingLevel;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.dirty = this.description.equals(description);
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.dirty = this.status.equals(status);
        this.status = status;
    }

    public double getRetailPrice() {
        return retailPrice;
    }

    public void setRetailPrice(Double retailPrice) {
        this.dirty = this.retailPrice.equals(retailPrice);
        this.retailPrice = retailPrice;
    }

    public String getTrainingType() {
        return trainingType;
    }

    public void setTrainingType(String trainingType) {
        this.dirty = this.trainingType.equals(trainingType);
        this.trainingType = trainingType;
    }

    // TODO -- not tested
    public void commit(Connection conn) {
        if(!this.dirty) {
            return;
        }

        Course dbCourse = Course.retrieveCourse(cCode, conn);
        if(dbCourse != null) {

        } else {
            this.store(conn);
        }
    }

    // TODO
    private void update(Connection conn) {

    }

    // TODO -- not tested
    private void store(Connection conn) {
        try {
            PreparedStatement preparedStatement =
                    conn.prepareStatement("INSERT INTO course (title, training_level, description, status, retail_price, train_type) " +
                                               "VALUES (?, ?, ?, ?, ?, ?)");
            preparedStatement.setString(1, title);
            preparedStatement.setString(2, trainingLevel);
            preparedStatement.setString(3, description);
            preparedStatement.setString(4, status);
            preparedStatement.setDouble(5, retailPrice);
            preparedStatement.setString(6, trainingType);
            preparedStatement.execute();
        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
        }
        this.dirty = false;
    }
}
