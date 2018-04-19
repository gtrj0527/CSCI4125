package career_development;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;

/**
 * Created by Gaby's Laptop on 4/19/2018.
 */
public class Skill_Test {
    public static void main(String[] args) {
        try {
            String userName = "gtswanso";
            String password = "sNNP9R9R";

            String hostName = "dbsvcs.cs.uno.edu";
            int port = 1521;
            String sid = "orcl";
            Connection conn = DriverManager.getConnection("jdbc:oracle:thin:" + userName + "/" + password + "@" + hostName + ":" + port + ":" + sid);

            Skill skill = Skill.retrieveSkill("Java", conn);
            System.out.println("KS_Code: " + skill.getKs_code());
            List<Skill> listSkill = Skill.retrieveAllSkills(conn);
            Iterator<Skill> skillIterator = listSkill.iterator();
            while (skillIterator.hasNext()){
                Skill s = skillIterator.next();
                System.out.println("KS Title: " + s.getKs_title() + ". KS Description: " + s.getDescription());
            }
            Skill s = new Skill("Java3","ESAI", "Systems Analysis",
                    "Enterprise systems analysis", "Intermediate");
            s.commit(conn);
            String newKsCode = s.getKs_code();
            Skill testSkill = Skill.retrieveSkill(newKsCode, conn);
            System.out.println(testSkill.getTraining_level());

    //        testPerson.addSkill(s, conn);
        }
        catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
        }
    }
}
