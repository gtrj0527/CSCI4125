package career_development;

import java.sql.*;
import java.util.LinkedList;
import oracle.jdbc.OracleTypes;
import oracle.jdbc.internal.OraclePreparedStatement;



public class Skill {
    private String ks_code;
    private String nwcet_code;
    private String ks_title;
    private String ks_description;
    private String training_level;
    private boolean dirty; //potentially inconsistent with DB

    public static LinkedList<Skill> retrieveAllSkills(Connection conn) {
        PreparedStatement retrSkill;
        LinkedList<Skill> skillList = new LinkedList<Skill>();
        try {
            retrSkill = conn.prepareStatement("SELECT ks_code, nwcet_code, ks_title, ks_description, training_level " +
                                                    "FROM know_skill");
            ResultSet rs = retrSkill.executeQuery();
            while(rs.next()) {
                String nwcet_code = rs.getString(1);
                String ks_title = rs.getString(2);
                String ks_description = rs.getString(3;
                String training_level = rs.getString(4);
                String ks_code = rs.getString(5));
                skillList.add(new Skill(ks_code, nwcet_code, ks_title, ks_description, training_level));
            }

        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
            return null;
        }
        return skillList;
    }

    public static Skill retrieveSkill (String ks_code, Connection conn) {
        PreparedStatement retrSkill;
        try{
            retrSkill = conn.prepareStatement("SELECT nwcet_code, ks_title, ks_description, training_level FROM know_skill WHERE ks_code = ?");
            ResultSet rs = retrSkill.executeQuery();
            if(rs.next()) {
                String nwcet_code = r
            }

        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
            return null;
        }
    }

}
