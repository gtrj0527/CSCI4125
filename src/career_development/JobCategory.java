
package career_development;

import java.sql.*;
import java.util.LinkedList;
import oracle.jdbc.OracleTypes;
import oracle.jdbc.internal.OraclePreparedStatement;


public class JobCategory {

    private String catCode;
    private String parentCatCode;
    private String jobCategoryTitle;
    private String jobCategoryDescription;
    private Float payRangeHigh;
    private Float payRangeLow;
    private boolean dirty;

    public static LinkedList<JobCategory> retrieveAllJobCategories(Connection conn) {
        PreparedStatement retrJobCategory;
        LinkedList<JobCategory> jobCategoryList = new LinkedList<JobCategory>();
        try {
            retrJobCategory = conn.prepareStatement("SELECT cat_Code, parent_Cat_Code, job_Category_Title, " +
                    "description, pay_Range_High, pay_Range_Low FROM job_category");
            ResultSet rs = retrJobCategory.executeQuery();
            while (rs.next()) {
                String catCode = rs.getString(1);
                String parentCatCode = rs.getString(2);
                String jobCategoryTitle = rs.getString(3);
                String jobCategoryDescription = rs.getString(4);
                Float payRangeHigh = rs.getFloat(5);
                Float payRangeLow = rs.getFloat(6);
                jobCategoryList.add(new JobCategory(catCode, parentCatCode, jobCategoryTitle, jobCategoryDescription, payRangeHigh, payRangeLow));
            }
            rs.close();
            retrJobCategory.close();
        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
            return null;
        }
        return jobCategoryList;
    }

    public static JobCategory retrieveJobCategory (String catCode, Connection conn) {
        PreparedStatement retrJobCategory;
        try {
            retrJobCategory = conn.prepareStatement("SELECT cat_Code, parent_Cat_Code, job_Category_Title," +
                    "description, pay_Range_High, pay_Range_Low FROM job_category WHERE cat_code = ?");
            retrJobCategory.setString(1,catCode);
            ResultSet rs = retrJobCategory.executeQuery();
            if(rs.next()) {
                String parentCatCode = rs.getString(2);
                String jobCategoryTitle = rs.getString(3);
                String jobCategoryDescription = rs.getString(4);
                Float payRangeHigh = rs.getFloat(5);
                Float payRangeLow = rs.getFloat(6);
                rs.close();
                retrJobCategory.close();
                return new JobCategory(catCode, parentCatCode, jobCategoryTitle, jobCategoryDescription, payRangeHigh, payRangeLow);
            }
            else{
                return null;
            }
        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
            return null;
        }
    }

    public JobCategory(String parentCatCode, String jobCategoryTitle,
                       String jobCategoryDescription, Float payRangeHigh, Float payRangeLow) {
        this.parentCatCode = parentCatCode;
        this.jobCategoryTitle = jobCategoryTitle;
        this.jobCategoryDescription = jobCategoryDescription;
        this.payRangeHigh = payRangeHigh;
        this.payRangeLow = payRangeLow;
    }

    public JobCategory(String catCode, String parentCatCode, String jobCategoryTitle,
                       String jobCategoryDescription, Float payRangeHigh, Float payRangeLow) {
       this(parentCatCode, jobCategoryTitle, jobCategoryDescription, payRangeHigh, payRangeLow);
       this.catCode = catCode;
    }

    public String getCatCode() {
        return catCode;
    }

    public String getParentCatCode() {
        return parentCatCode;
    }

    public void setParentCatCode(String parentCatCode) {
        this.dirty = this.parentCatCode.equals(parentCatCode);
        this.parentCatCode = parentCatCode;
    }


    public String getJobCategoryTitle() {
        return jobCategoryTitle;
    }

    public void setJobCategoryTitle(String jobCategoryTitle) {
        this.dirty = this.jobCategoryTitle.equals(jobCategoryTitle);
        this.jobCategoryTitle = jobCategoryTitle;
    }

    public String getJobCategoryDescription() {
        return jobCategoryDescription;
    }

    public void setJobCategoryDescription(String jobCategoryDescription) {
        this.dirty = this.jobCategoryDescription.equals(jobCategoryDescription);
        this.jobCategoryDescription = jobCategoryDescription;
    }

    public Float getPayRangeHigh() {
        return payRangeHigh;
    }

    public void setPayRangeHigh(Float payRangeHigh) {
        this.dirty = this.payRangeHigh.equals(payRangeHigh);
        this.payRangeHigh = payRangeHigh;
    }

    public Float getPayRangeLow() {
        return payRangeLow;
    }

    public void setPayRangeLow(Float payRangeLow) {
        this.dirty = this.payRangeLow.equals(payRangeLow);
        this.payRangeLow = payRangeLow;
    }

    public void commit (Connection conn) {
        if(!this.dirty) {
            return;
        }
        if(catCode==null) {
            this.store(conn);
        } else {
            JobCategory dbJobCategory = JobCategory.retrieveJobCategory(catCode, conn);
        }
    }


    // TODO  -jtm
    private void update(Connection conn, JobCategory dbJobCategory ) {
        PreparedStatement updateJobCategory;
        try{
            updateJobCategory=conn.prepareStatement("UPDATE job_category SET cat_code = ?, parent_cat_code=?," +
                    "job_category_title = ?, description = ?, pay_range_high=?, pay_range_low=?");
            int rowsAffected = updateJobCategory.executeUpdate();
            System.out.println(rowsAffected + "these job categories were updated.");
            updateJobCategory.close();

        } catch(SQLException sqlEx) {
            System.err.println(sqlEx.toString());
        }
    }

    private void store (Connection conn) {
        try {
            OraclePreparedStatement preparedStatement =
                    (OraclePreparedStatement)conn.prepareStatement("INSERT INTO job_category (parent_cat_code,job_category_title, " +
                            "job_description, pay_range_high, pay_range_low) VALUES (?,?,?,?,?,?,?) returning cat_code INTO ?");
            preparedStatement.registerReturnParameter(6, OracleTypes.INTEGER);
            //preparedStatement.setString(1, catCode);
            preparedStatement.setString(1, parentCatCode);
            preparedStatement.setString(2, jobCategoryTitle);
            preparedStatement.setString(3, jobCategoryDescription);
            preparedStatement.setFloat(4, payRangeHigh);
            preparedStatement.setFloat(5, payRangeLow);
            ResultSet lastIDrs = preparedStatement.getReturnResultSet();
            if(lastIDrs.next()) {
                String catCode = lastIDrs.getString(1);
                System.out.println(catCode);
                this.catCode=catCode;
            }
            lastIDrs.close();
            preparedStatement.close();
        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
        }
        this.dirty=false;
    }
}