
package career_development;

import java.sql.*;
import java.util.LinkedList;
import oracle.jdbc.OracleTypes;
import oracle.jdbc.internal.OraclePreparedStatement;


public class JobCategory {

    private String catCode;
    private String parentCatCode;
    private String coreSkillCode;
    private String jobCategoryTitle;
    private String jobCategoryDescription;
    private Float payRangeHigh;
    private Float payRangeLow;
    private boolean dirty; //potentially inconsistent with DB

    public static LinkedList<JobCategory> retrieveAllJobCategories(Connection conn) {
        PreparedStatement retrJobCategory;
        LinkedList<JobCategory> jobCategoryList = new LinkedList<JobCategory>();
        try {
            retrJobCategory = conn.prepareStatement("SELECT cat_Code, parent_Cat_Code, core_Skill, job_Category_Title, " +
                    "description, pay_Range_High, pay_Range_Low FROM job_category");
            ResultSet rs = retrJobCategory.executeQuery();
            while (rs.next()) {
                String catCode = rs.getString(1);
                String parentCatCode = rs.getString(2);
                String coreSkillCode = rs.getString(3);
                String jobCategoryTitle = rs.getString(4);
                String jobCategoryDescription = rs.getString(5);
                Float payRangeHigh = rs.getFloat(6);
                Float payRangeLow = rs.getFloat(7);
                jobCategoryList.add(new JobCategory(catCode, parentCatCode, coreSkillCode, jobCategoryTitle, jobCategoryDescription, payRangeHigh, payRangeLow));
            }

        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
            return null;
        }
        return jobCategoryList;
    }

    public static JobCategory retrieveJobCategory (String catCode, Connection conn) {
        PreparedStatement retrJobCategory;
        try {
            retrJobCategory = conn.prepareStatement("SELECT cat_Code, parent_Cat_Code, core_Skill, job_Category_Title," +
                    "description, pay_Range_High, pay_Range_Low FROM job_category WHERE cat_code = ?");
            retrJobCategory.setString(1,catCode);
            ResultSet rs = retrJobCategory.executeQuery();
            if(rs.next()) {
                String parentCatCode = rs.getString(2);
                String coreSkillCode = rs.getString(3);
                String jobCategoryTitle = rs.getString(4);
                String jobCategoryDescription = rs.getString(5);
                Float payRangeHigh = rs.getFloat(6);
                Float payRangeLow = rs.getFloat(7);
                return new JobCategory(catCode, parentCatCode, coreSkillCode, jobCategoryTitle, jobCategoryDescription, payRangeHigh, payRangeLow);
            }
            else{
                return null;
            }
        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
            return null;
        }
    }


    public JobCategory(String parentCatCode, String coreSkillCode, String jobCategoryTitle, String jobCategoryDescription, Float payRangeHigh, Float payRangeLow) {
        //this.catCode = catCode;
        this.parentCatCode = parentCatCode;
        this.coreSkillCode = coreSkillCode;
        this.jobCategoryTitle = jobCategoryTitle;
        this.jobCategoryDescription = jobCategoryDescription;
        this.payRangeHigh = payRangeHigh;
        this.payRangeLow = payRangeLow;
    }

    private JobCategory(String catCode, String parentCatCode, String coreSkillCode, String jobCategoryTitle,
                       String jobCategoryDescription, Float payRangeHigh, Float payRangeLow) {
       this(parentCatCode, coreSkillCode, jobCategoryTitle, jobCategoryDescription, payRangeHigh, payRangeLow);
       this.catCode = catCode;
    }


    public String getCatCode() {
        return catCode;
    }

//    public void setCatCode(String catCode) {
//        this.dirty = this.catCode.equals(catCode);
//        this.catCode = catCode;
//    }

    public String getParentCatCode() {
        return parentCatCode;
    }

    public void setParentCatCode(String parentCatCode) {
        this.dirty = this.parentCatCode.equals(parentCatCode);
        this.parentCatCode = parentCatCode;
    }

    public String getCoreSkillCode() {
        return coreSkillCode;
    }

    public void setCoreSkillCode(String coreSkillCode) {
        this.dirty = this.coreSkillCode.equals(coreSkillCode);
        this.coreSkillCode = coreSkillCode;
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

    // Needs to be listQualifiedJobCategories
    public LinkedList<JobCategory> listQualifiedJobCategories(Person person, Connection conn){
        LinkedList<JobCategory> qualifiedJobCategories = new LinkedList<>();
        try {
            String query = "WITH category_qual AS (\n" +
                    "        (SELECT pers_id, cat_code\n" +
                    "        FROM person, JOB_CATEGORY)\n" +
                    "        MINUS\n" +
                    "        (SELECT distinct pers_id, cat_code\n" +
                    "        FROM (SELECT pers_id, cat_code, ks_code\n" +
                    "              FROM person, (SELECT cat_code, ks_code \n" +
                    "                            FROM know_skill ks\n" +
                    "                            JOIN nwcet n ON ks.nwcet_code = n.nwcet_code\n" +
                    "                            JOIN job_category j ON n.nwcet_code = j.core_skill)\n" +
                    "             MINUS \n" +
                    "             SELECT pers_id, cat_code, ks_code\n" +
                    "             FROM ( SELECT p.pers_id, j.cat_code, ks.ks_code \n" +
                    "                    FROM person p\n" +
                    "                    JOIN has_skill hs ON p.pers_id = hs.pers_id\n" +
                    "                    JOIN know_skill ks ON hs.ks_code = ks.ks_code\n" +
                    "                    JOIN nwcet n ON ks.nwcet_code = n.nwcet_code\n" +
                    "                    JOIN job_category j ON n.nwcet_code = j.core_skill))))\n" +
                    "SELECT cat_code\n" +
                    "FROM category_qual\n" +
                    "WHERE pers_id = ?;";
            PreparedStatement listQualifiedJobCategories = conn.prepareStatement(query);
            listQualifiedJobCategories.setInt(1,person.getPersID());
            ResultSet rs = listQualifiedJobCategories.executeQuery();
        }
        catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
        }
        return qualifiedJobCategories;
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

    // TODO
    private void update(Connection conn) {

    }


    private void store (Connection conn) {
        try {
            OraclePreparedStatement preparedStatement =
                    (OraclePreparedStatement)conn.prepareStatement("INSERT INTO job_category (parent_cat_code, core_skill, job_category_title, " +
                            "job_description, pay_range_high, pay_range_low) VALUES (?,?,?,?,?,?,?) returning cat_code INTO ?");
            preparedStatement.registerReturnParameter(7, OracleTypes.INTEGER);
            //preparedStatement.setString(1, catCode);
            preparedStatement.setString(1, parentCatCode);
            preparedStatement.setString(2, coreSkillCode);
            preparedStatement.setString(3, jobCategoryTitle);
            preparedStatement.setString(4, jobCategoryDescription);
            preparedStatement.setFloat(5, payRangeHigh);
            preparedStatement.setFloat(6, payRangeLow);
            ResultSet lastIDrs = preparedStatement.getReturnResultSet();
            if(lastIDrs.next()) {
                String catCode = lastIDrs.getString(1);
                System.out.println(catCode);
                this.catCode=catCode;
            }


        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
        }
        this.dirty=false;
    }
}
