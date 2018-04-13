DROP VIEW pay_change;
DROP VIEW pay_change_by_sector;
DROP VIEW previous_earnings_by_sector;
DROP VIEW last_ended_job_date;
DROP VIEW current_earnings_by_sector;
DROP VIEW sector_labor_cost;
DROP VIEW sector_employee_count;
DROP VIEW company_labor_cost;
DROP VIEW company_employee_count;
DROP VIEW unemployed_people;
DROP VIEW cert_qual;        --We never use this one.
DROP VIEW skill_qual;
DROP VIEW category_qual;
DROP VIEW missing_category_skills;
DROP VIEW relevant_category_skills;
DROP VIEW category_skills;
DROP VIEW satisfy_skills;
DROP VIEW missing_count;
DROP VIEW position_qual;
DROP VIEW missing_skills;
DROP VIEW relevant_skills;
DROP VIEW position_yearly_pay;
DROP VIEW pers_full_name;

--Test this view and implement into Query 1,2,15,16,21
CREATE VIEW pers_full_name AS(
    SELECT (first_name || ' ' ||  last_name) AS full_name
    FROM person);

/*Used in Query 2,3,14,23,25*/
CREATE VIEW position_yearly_pay AS (
    SELECT pos_code, primary_sector_code, pay_rate AS yearly_pay 
    FROM position 
    NATURAL JOIN company 
    WHERE pay_type = 'S' 
    UNION 
    SELECT pos_code, primary_sector_code, pay_rate*1920 AS pay_rate 
    FROM position
    NATURAL JOIN company
    WHERE pay_type = 'W');

/*Used in Query 6*/
CREATE VIEW relevant_skills AS (
    SELECT pers_id, pos_code, ks_code 
    FROM person 
    NATURAL JOIN has_skill 
    NATURAL JOIN position_skills);

/*Used in Query 6,8,9,17,20*/
CREATE VIEW missing_skills AS (
    SELECT pers_id, pos_code, ks_code 
    FROM person, position_skills 
    MINUS 
    SELECT pers_id, pos_code, ks_code
    FROM relevant_skills);
    
/*Used in Query 6,14*/
CREATE VIEW position_qual AS(
    SELECT pers_id, pos_code
    FROM person, position
    MINUS
    SELECT DISTINCT pers_id, pos_code
    FROM missing_skills);

/*Used in Query 6,16,17,18,19,20*/
CREATE VIEW missing_count AS (
    SELECT pers_id, pos_code, COUNT(*) AS num_missing 
    FROM missing_skills 
    GROUP BY pers_id, pos_code);

/*Used in Query 9,10,11*/
CREATE VIEW satisfy_skills AS (
      SELECT DISTINCT c_code
      FROM provides_skill ps1
      WHERE NOT EXISTS
        (SELECT ks_code
         FROM missing_skills ms1
         WHERE pos_code = 10 AND pers_id = 7
         AND NOT EXISTS
            (SELECT *
             FROM provides_skill ps2
             WHERE ps1.c_code = ps2.c_code
             AND   ps2.ks_code = ms1.ks_code)));

/*Used in Query 13*/          
CREATE VIEW category_skills AS (
    SELECT cat_code, ks_code 
    FROM know_skill 
    NATURAL JOIN nwcet
    JOIN job_category ON nwcet_code = job_category.core_skill);

/*Used in Query 13*/          
CREATE VIEW relevant_category_skills AS (
    SELECT pers_id, cat_code, ks_code 
    FROM person 
    NATURAL JOIN has_skill 
    NATURAL JOIN know_skill
    NATURAL JOIN nwcet 
    JOIN job_category ON nwcet_code = job_category.core_skill);

/*Used in Query 13*/          
CREATE VIEW missing_category_skills AS (
    SELECT pers_id, cat_code, ks_code 
    FROM person, category_skills 
    MINUS 
    SELECT pers_id, cat_code, ks_code
    FROM relevant_category_skills);

/*Used in Query 13*/          
CREATE VIEW category_qual AS (
    SELECT pers_id, cat_code 
    FROM person,job_category
    MINUS
    SELECT DISTINCT pers_id, cat_code 
    FROM missing_category_skills);

/*Used in Query 15*/          
CREATE VIEW skill_qual AS (
    SELECT DISTINCT pers_id 
    FROM has_skill hs1
    WHERE NOT EXISTS
      (SELECT * 
       FROM position_skills ps1
       WHERE pos_code = 10 
       AND NOT EXISTS
          (SELECT * 
           FROM has_skill hs2
           WHERE hs1.pers_id = hs2.pers_id 
           AND   hs2.ks_code = ps1.ks_code))
);

/*Used in Query 15*/
--We never actually use this one.
CREATE VIEW cert_qual AS (
    SELECT DISTINCT pers_id 
    FROM has_cert hc1
    WHERE NOT EXISTS
      (SELECT * 
       FROM position_cert pc1
       WHERE pos_code = 10 
       AND NOT EXISTS
          (SELECT * 
           FROM has_cert hc2
           WHERE hc1.pers_id = hc2.pers_id 
           AND   hc2.cert_code = pc1.cert_code))
);

/*Used in Query 22*/
CREATE VIEW unemployed_people AS (
    SELECT pers_id 
    FROM person 
    MINUS 
    SELECT DISTINCT pers_id 
    FROM works 
    WHERE end_date IS NULL);

/*Used in Query 23*/
CREATE VIEW company_employee_count AS (
    SELECT comp_id, COUNT(*) AS empl_count 
    FROM works 
    NATURAL JOIN position 
    WHERE end_date IS NULL 
    GROUP BY comp_id);
    
/*Used in Query 23*/
CREATE VIEW company_labor_cost AS(
    SELECT comp_id, SUM(yearly_pay) AS labor_cost
    FROM company 
    NATURAL JOIN position
    NATURAL JOIN position_yearly_pay
    GROUP BY comp_id); 

/*Used in Query 24*/
CREATE VIEW sector_employee_count AS (
    SELECT primary_sector_code, SUM(empl_count) AS sec_empl_count 
    FROM company 
    NATURAL JOIN company_employee_count 
    GROUP BY primary_sector_code);

/*Used in Query 24*/
CREATE VIEW sector_labor_cost AS (
    SELECT primary_sector_code, SUM(labor_cost) AS sec_labor_cost 
    FROM company 
    NATURAL JOIN company_labor_cost 
    GROUP BY primary_sector_code);

/*Used in Query 25*/  
CREATE VIEW current_earnings_by_sector AS (
    SELECT pers_id, primary_sector_code, SUM(yearly_pay) AS current_earnings 
    FROM person 
    NATURAL JOIN works 
    NATURAL JOIN position 
    NATURAL JOIN position_yearly_pay 
    WHERE end_date IS NULL 
    GROUP BY pers_id, primary_sector_code);

/*Used in Query 25*/  
CREATE VIEW last_ended_job_date AS (
    SELECT pers_id, MAX(end_date) AS last_end_date 
    FROM person 
    NATURAL JOIN works 
    GROUP BY pers_id); 

/*Used in Query 25*/  
CREATE VIEW previous_earnings_by_sector AS (
    SELECT pers_id, primary_sector_code, SUM(yearly_pay) AS previous_earnings 
    FROM person 
    NATURAL JOIN works 
    NATURAL JOIN position 
    NATURAL JOIN position_yearly_pay 
    NATURAL JOIN last_ended_job_date 
    WHERE start_date <= last_end_date 
    AND (end_date IS NULL OR end_date >= last_end_date) 
    GROUP BY pers_id, primary_sector_code);

/*Used in Query 25*/  
CREATE VIEW pay_change_by_sector AS (
    SELECT pers_id, primary_sector_code, SUM(earnings) AS pay_diff
    FROM(
        SELECT pers_id, primary_sector_code, current_earnings AS earnings
        FROM current_earnings_by_sector
        UNION
        SELECT pers_id, primary_sector_code, -1*previous_earnings AS earnings
        FROM previous_earnings_by_sector)
    GROUP BY pers_id, primary_sector_code);

/*Used in Query 25*/  
CREATE VIEW pay_change AS (
    SELECT pers_id, SUM(pay_diff) AS diff 
    FROM pay_change_by_sector 
    GROUP BY pers_id);
