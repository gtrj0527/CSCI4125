package career_development;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;

/**
 * Created by Gaby's Laptop on 4/19/2018.
 */
public class JobCategory_Test {
    public static void main(String[] args) {
        String userName = "gtswanso";
        String password = "sNNP9R9R";

        String hostName = "dbsvcs.cs.uno.edu";
        int port = 1521;
        String sid = "orcl";
        Connection conn = null;
        try {
            conn = DriverManager.getConnection("jdbc:oracle:thin:" + userName + "/" + password + "@" + hostName + ":" + port + ":" + sid);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        JobCategory jobCategory = JobCategory.retrieveJobCategory("1", conn);
        //System.out.println("Job Category Title: " + jobCategory.getJobCategoryTitle());
        List<JobCategory> listJobCategory = JobCategory.retrieveAllJobCategories(conn);
        Iterator<JobCategory> jobCategoryIterator = listJobCategory.iterator();
        while(jobCategoryIterator.hasNext()) {
            JobCategory jc = jobCategoryIterator.next();
            System.out.println("cat_code: " + jc.getCatCode() + " Job Category Title: " + jc.getJobCategoryTitle());
        }
        JobCategory jc = new JobCategory ("Sample Job General", "General Job", "Job Worker",
                "This is a job for a person who can do a job", 20000.00f, 10000.00f);
        jc.commit(conn);
        String newCatCode = jc.getCatCode();
        JobCategory testJobCategory = JobCategory.retrieveJobCategory(newCatCode, conn);
    }
}
