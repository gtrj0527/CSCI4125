package career_development;

import java.sql.*;
import java.util.LinkedList;
import oracle.jdbc.OracleTypes;
import oracle.jdbc.internal.OraclePreparedStatement;



public class Skill {
    private String ks_code;
    private String nwcet_code;
    private String ks_title;
    private String description;
    private String training_level;
    private boolean dirty; //potentially inconsistent with DB

    public static LinkedList<Skill> retrieveAllSkills(Connection conn) {
        PreparedStatement retrSkill;
        LinkedList<Skill> skillList = new LinkedList<Skill>();
        try {
            retrSkill = conn.prepareStatement("SELECT ks_code, nwcet_code, ks_title, description, training_level " +
                                                    "FROM know_skill");
            ResultSet rs = retrSkill.executeQuery();
            while(rs.next()) {
                String ks_code = rs.getString(1);
                String nwcet_code = rs.getString(2);
                String ks_title = rs.getString(3);
                String description = rs.getString(4);
                String training_level = rs.getString(5);
                skillList.add(new Skill(ks_code, nwcet_code, ks_title, description, training_level, true));
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
            retrSkill = conn.prepareStatement("SELECT ks_code, nwcet_code, ks_title, description, training_level FROM know_skill WHERE ks_code = ?");
            retrSkill.setString(1, ks_code);
            ResultSet rs = retrSkill.executeQuery();
            if(rs.next()) {
                String nwcet_code = rs.getString(1);
                String ks_title = rs.getString(2);
                String description = rs.getString(3);
                String training_level = rs.getString(4);
                return new Skill(ks_code, nwcet_code, ks_title, description, training_level, true);
            } else {
                return null;
            }

        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
            return null;
        }
    }

    public Skill(String ks_code, String nwcet_code, String ks_title, String description, String training_level) {
        this.ks_code = ks_code;
        this.nwcet_code = nwcet_code;
        this.ks_title = ks_title;
        this.description = description;
        this.training_level = training_level;
        this.dirty = true;
    }

    private Skill(String ks_code, String nwcet_code, String ks_title, String description, String training_level, boolean dirty) {
        this(ks_code, nwcet_code, ks_title, description, training_level);
        this.dirty = dirty;
    }

    public String getKs_code() {
        return ks_code;
    }


    public String getNwcet_code() {
        return nwcet_code;
    }

    public void setNwcet_code(String nwcet_code) {
        this.dirty = this.nwcet_code.equals(nwcet_code);
        this.nwcet_code = nwcet_code;
    }

    public String getKs_title() {
        return ks_title;
    }

    public void setKs_title(String ks_title) {
        this.dirty = this.ks_title.equals(ks_title);
        this.ks_title = ks_title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.dirty=this.description.equals(description);
        this.description = description;
    }

    public String getTraining_level() {
        return training_level;
    }

    public void setTraining_level(String training_level) {
        this.dirty = this.training_level.equals(training_level);
        this.training_level = training_level;
    }

    public void commit (Connection conn) {
        if(!this.dirty) {
            return;
        }

        if(ks_code==null) {
            this.store(conn);
        }else {
            Skill dbSkill = Skill.retrieveSkill(ks_code, conn);
        }
    }

    private void store (Connection conn) {
        try {
            OraclePreparedStatement preparedStatement = (
                    OraclePreparedStatement)conn.prepareStatement("INSERT INTO skill(ks_code, nwcet_code, ks_title, description, training_level) VALUES (?,?,?,?)" +
                    "RETURNING ks_code INTO ?");
            preparedStatement.setString(1, ks_code);
            preparedStatement.setString(2, nwcet_code);
            preparedStatement.setString(3, ks_title);
            preparedStatement.setString(4, description);
            preparedStatement.setString(5, training_level);
            preparedStatement.execute();
            ResultSet lastKScoders = preparedStatement.getReturnResultSet();
            if (lastKScoders.next()) {
            String ks_code = lastKScoders.getString(1);
            System.out.println(ks_code);
            }
        }catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
        }
        this.dirty = false;

    }
}
