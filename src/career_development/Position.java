package career_development;

import java.sql.*;
import java.util.LinkedList;
import oracle.jdbc.OracleTypes;
import oracle.jdbc.internal.OraclePreparedStatement;
import sun.awt.image.ImageWatched;

public class Position {
    private Integer pos_code;
    private String comp_id;
    private String pos_title;
    private String emp_mode;
    private String cat_code;
    private String pay_rate;
    private String pay_type;
    private boolean dirty; // potentially inconsistent with DB

    public static LinkedList<Position> retrieveAllPositions(Connection conn) {
        PreparedStatement retrPosition;
        LinkedList<Position> positionList = new LinkedList<Position>();
        try {
            retrPosition = conn.prepareStatement("SELECT pos_code, comp_id, pos_title, emp_mode, cat_code, " +
                                                      "pay_rate, pay_type FROM position");
            ResultSet rs = retrPosition.executeQuery();
            while (rs.next()) {
                Integer pos_code = rs.getInt(1);
                String comp_id = rs.getString(2);
                String pos_title = rs.getString(3);
                String emp_mode = rs.getString(4);
                String cat_code = rs.getString(5);
                String pay_rate = rs.getString(6);
                String pay_type = rs.getString(7);
                positionList.add(new Position(pos_code, comp_id, pos_title, emp_mode, cat_code, pay_rate, pay_type));
            }
            rs.close();
            retrPosition.close();
        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
            return null;
        }
        return positionList;
    }

    public static Position retrievePosition(Integer pos_code, Connection conn) {
        PreparedStatement retrPosition;
        try {
            retrPosition = conn.prepareStatement("SELECT pos_code, comp_id, pos_title, emp_mode, cat_code," +
                                                     "pay_rate, pay_type FROM position WHERE pos_code = ?");
            retrPosition.setInt(1, pos_code);
            ResultSet rs = retrPosition.executeQuery();
            if (rs.next()) {
                String comp_id = rs.getString(2);
                String pos_title = rs.getString(3);
                String emp_mode = rs.getString(4);
                String cat_code = rs.getString(5);
                String pay_rate = rs.getString(6);
                String pay_type = rs.getString(7);
                return new Position(pos_code, comp_id, pos_title, emp_mode, cat_code, pay_rate, pay_type);
            } else {
                return null;
            }
        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
            return null;
        }
    }

    public Position(String comp_id, String pos_title, String emp_mode, String cat_code, String pay_rate,
                    String pay_type) {
        this.comp_id = comp_id;
        this.pos_title = pos_title;
        this.emp_mode = emp_mode;
        this.cat_code = cat_code;
        this.pay_rate = pay_rate;
        this.pay_type = pay_type;
        this.dirty = true;
    }

    private Position(int pos_code, String comp_id, String pos_title, String emp_mode, String cat_code, String pay_rate,
                   String pay_type) {
        this(comp_id, pos_title, emp_mode, cat_code, pay_rate, pay_type);
        this.pos_code = pos_code;
        //this.cat_code = cat_code;
    }

    public Integer getPosCode() {
        return pos_code;
    }

    public String getCompID() {
        return comp_id;
    }

    public void setCompID(String comp_id) {
        this.dirty = this.comp_id.equals(comp_id);
        this.comp_id = comp_id;
    }

    public String getPosTitle() {
        return pos_title;
    }

    public void setPosTitle(String pos_title) {
        this.dirty = this.pos_title.equals(pos_title);
        this.pos_title = pos_title;
    }

    public String getEmpMode() {
        return emp_mode;
    }

    public void setEmpMode(String emp_mode) {
        this.dirty = this.emp_mode.equals(emp_mode);
        this.emp_mode = emp_mode;
    }

    public String getCatCode() {
        return cat_code;
    }

    public void setCatCode(String cat_code) {
        this.dirty = this.cat_code.equals(cat_code);
        this.cat_code = cat_code;
    }

    public String getPayRate() {
        return pay_rate;
    }

    public void setPayRate(String pay_rate) {
        this.dirty = this.pay_rate.equals(pay_rate);
        this.pay_rate = pay_rate;
    }

    public String getPayType() {
        return pay_type;
    }

    public void setPayType(String pay_type) {
        this.dirty = this.pay_type.equals(pay_type);
        this.pay_type = pay_type;
    }

    public LinkedList<Person> getQualifiedPeople(Connection conn) {
        LinkedList<Person> qualifiedPeople = new LinkedList<Person>();
        try {
            String query = "SELECT DISTINCT pers_id " +
                           "FROM has_skill hs1 " +
                           "WHERE NOT EXISTS " +
                           "   (SELECT * " +
                           "    FROM position_skills ps1 " +
                           "    WHERE pos_code = ? " +
                           "    AND NOT EXISTS " +
                           "         (SELECT * " +
                           "          FROM has_skill hs2 " +
                           "          WHERE hs1.pers_id = hs2.pers_id " +
                           "          AND   hs2.ks_code = ps1.ks_code))";
            PreparedStatement getQualifiedPeople = conn.prepareStatement(query);
            getQualifiedPeople.setInt(1,this.pos_code);
            ResultSet rs = getQualifiedPeople.executeQuery();
            while(rs.next()) {
                Integer pers_id = rs.getInt(1);
                Person p = Person.retrievePerson(pers_id, conn);
                qualifiedPeople.add(p);
            }
            rs.close();
            getQualifiedPeople.close();
        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
        }
        return qualifiedPeople;
    }

    public boolean isQualified(Person p, Connection conn){
        try {
            String query = "SELECT DISTINCT pers_id\n" +
                    "       FROM has_skill hs1\n" +
                    "       WHERE pers_id = ? AND NOT EXISTS (\n" +
                    "           (SELECT ks_code\n" +
                    "            FROM position_skills ps1\n" +
                    "            WHERE pos_code = ?)\n" +
                    "            MINUS\n" +
                    "           (SELECT ks_code\n" +
                    "            FROM has_skill hs2\n" +
                    "            WHERE hs1.pers_id = hs2.pers_id))";
            PreparedStatement isQualified = conn.prepareStatement(query);
            isQualified.setInt(1, p.getPersID());
            isQualified.setInt(2,this.pos_code);
            ResultSet rs = isQualified.executeQuery();
            boolean qualified = rs.next();
            rs.close();
            isQualified.close();
            return qualified;
        }
        catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
        }
        return false;
    }

    // On commit, if there's a new insert, the pos_code, etc will be set to the actual value
    public void commit(Connection conn) {
        if (!this.dirty) {
            return;
        }

        if (pos_code == null) {
            this.store(conn);
        } else {
            Position dbPosition = Position.retrievePosition(pos_code, conn);
            update(conn, dbPosition);
        }
    }

    // TODO
    private void update(Connection conn, Position dbPosition) {
        PreparedStatement updatePosition;
        boolean unequal = true;
        try {
            updatePosition = conn.prepareStatement("UPDATE position SET comp_id = ?, pos_title = ?, emp_mode = ?, " +
                "cat_code = ?, pay_rate = ?,pay_tpe = ? WHERE pos_code = ?");
            int rowsAffected = updatePosition.executeUpdate();
            System.out.println(rowsAffected + " were updated.");
            updatePosition.close();
        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
        }
    }

    // TODO -- not tested
    private void store(Connection conn) {
        try {
            OraclePreparedStatement preparedStatement =
                    (OraclePreparedStatement) conn.prepareStatement("INSERT INTO Position(comp_id, pos_title, " +
                            "emp_mode, cat_code, pay_rate, pay_type) VALUES (?, ?, ?, ?, ?, ?) " +
                            "RETURNING pos_code INTO ?");
            preparedStatement.registerReturnParameter(7, OracleTypes.INTEGER);
            preparedStatement.setString(1, comp_id);
            preparedStatement.setString(2, pos_title);
            preparedStatement.setString(3, emp_mode);
            preparedStatement.setString(4, cat_code);
            preparedStatement.setString(5, pay_rate);
            preparedStatement.setString(6, pay_type);
            preparedStatement.execute();
            ResultSet lastCodeRS = preparedStatement.getReturnResultSet();
            if (lastCodeRS.next()) {
                // The generated id
                Integer pos_code = lastCodeRS.getInt(1);
                System.out.println(pos_code);
                this.pos_code = pos_code;
            }
            lastCodeRS.close();
            preparedStatement.close();
        } catch (SQLException sqlEx) {
            System.err.println(sqlEx.toString());
        }
        this.dirty = false;
    }
}