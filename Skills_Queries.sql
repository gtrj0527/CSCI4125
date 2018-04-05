/* Query 16. */
DROP VIEW missing_count;
DROP VIEW missing_skills;
DROP VIEW missing_skills2;
DROP VIEW rev_skills_count;
DROP VIEW relevant_skills;
DROP VIEW relevant_skills2;
DROP VIEW skills_count;
CREATE VIEW relevant_skills AS (SELECT person.pers_id, position.pos_code, has_skill.ks_code AS pers_skill, position_skills.ks_code AS pos_skill FROM person FULL OUTER JOIN has_skill ON person.pers_id = has_skill.pers_id FULL OUTER JOIN position_skills ON has_skill.ks_code = position_skills.ks_code FULL OUTER JOIN position ON position.pos_code = position_skills.pos_code);
CREATE VIEW relevant_skills2 AS (SELECT pers_id, pos_code, ks_code AS pers_skill, ks_code AS pos_skill FROM person NATURAL JOIN has_skill NATURAL JOIN position_skills NATURAL JOIN position);
CREATE VIEW rev_skills_count AS (SELECT pers_id, pos_code, COUNT(pers_skill) AS skills FROM relevant_skills GROUP BY pers_id, pos_code);
CREATE VIEW skills_count AS (SELECT pos_code, COUNT(*) AS req_skills FROM position_skills GROUP BY pos_code);
CREATE VIEW missing_skills2 AS (SELECT pers_id, pos_code, (req_skills-skills) AS num_missing FROM rev_skills_count NATURAL JOIN skills_count WHERE req_skills-skills > 0);
CREATE VIEW missing_skills AS (SELECT pers_id, pos_code, ks_code FROM person, position_skills MINUS SELECT pers_id, pos_code, pos_skill FROM relevant_skills2);
CREATE VIEW missing_count AS (SELECT pers_id, pos_code, COUNT(*) AS num_missing FROM missing_skills GROUP BY pers_id, pos_code);
SELECT pers_id FROM missing_count WHERE pos_code = 10 AND num_missing = 1;

/* Query 17 */
WITH missing_one AS (SELECT pers_id FROM missing_count WHERE pos_code = 10 AND num_missing = 1)
SELECT ks_code, COUNT(pers_id) AS person_count FROM missing_skills NATURAL JOIN missing_one WHERE pos_code = 10  GROUP BY ks_code ORDER BY person_count;

/* For not just missing one... */
--SELECT ks_code, COUNT(pers_id) AS person_count FROM missing_skills WHERE pos_code = 10  GROUP BY ks_code ORDER BY person_count;

/* Query 18 */
SELECT pers_id, num_missing FROM missing_count WHERE num_missing = (SELECT MIN(num_missing) FROM missing_count WHERE pos_code = 10) AND pos_code = 10;

/* Query 19 */
SELECT pers_id, num_missing FROM missing_count WHERE num_missing <= 10 AND pos_code = 10;

/* Query 20 */
SELECT DISTINCT ks_code FROM missing_skills WHERE pos_code = 10;

/* Query 21, This should work once we change the schema */
--SELECT pers_id, last_name, first_name, mi, start_date, end_date FROM person NATURAL JOIN works NATURAL JOIN position WHERE cat_code = ? AND end_date IS NOT NULL;

/* Query 22 */
DROP VIEW unemployed_people;
CREATE VIEW unemployed_people AS (SELECT pers_id FROM person MINUS SELECT DISTINCT pers_id FROM works WHERE end_date IS NULL);
SELECT pers_id FROM unemployed_people JOIN works WHERE end_date IS NOT NULL AND pos_code = 10;

/* Query 23 */
DROP VIEW company_employee_count;
CREATE VIEW company_employee_count AS (SELECT comp_id, COUNT(*) AS empl_count FROM works NATURAL JOIN position WHERE end_date IS NULL GROUP BY comp_id);
SELECT comp_name, empl_count FROM company NATURAL JOIN company_employee_count WHERE empl_count = (SELECT MAX(empl_count) FROM company_employee_count);
-- company_labor_cost from Query 3
SELECT comp_name, labor_cost FROM company NATURAL JOIN company_labor_cost WHERE labor_cost = (SELECT MAX(labor_cost) FROM company_labor_cost);

/* Query 24 */
CREATE VIEW sector_employee_count AS (SELECT primary_sector, SUM(empl_count) AS sec_empl_count FROM company NATURAL JOIN company_employee_count GROUP BY primary_sector);
CREATE VIEW sector_labor_cost AS (SELECT primary_sector, SUM(labor_cost) AS sec_labor_cost FROM company NATURAL JOIN company_labor_cost GROUP BY primary_sector);
SELECT primary_sector FROM sector_employee_count WHERE sec_empl_count = (SELECT MAX(sec_empl_count) FROM sector_employee_count);
SELECT primary_sector FROM sector_labor_cost WHERE sec_labor_cost = (SELECT MAX(sec_labor_cost) FROM sector_labor_cost);

/* Query 25 */
CREATE VIEW position_yearly_pay AS (SELECT pos_code, primary_sector, pay_rate AS yearly_pay FROM position NATURAL JOIN company WHERE pay_type = 'S' UNION SELECT pos_code, primary_sector, pay_rate*1920 AS pay_rate FROM position WHERE pay_type = 'W');
-- (SELECT SYSDATE FROM DUAL) == NOW
CREATE VIEW current_earnings_by_sector AS (SELECT pers_id, primary_sector, SUM(yearly_pay) AS curr_earnings FROM person NATURAL JOIN works NATURAL JOIN position NATURAL JOIN position_yearly_pay WHERE end_date IS NULL OR end_date > (SELECT SYSDATE FROM DUAL) GROUP BY pers_id, primary_sector);
CREATE VIEW last_ended_job_date AS (SELECT pers_id, MAX(end_date) AS last_end_date FROM person NATURAL JOIN works GROUP BY pers_id); 
CREATE VIEW previous_earnings_by_sector AS (SELECT pers_id, primary_sector, SUM(yearly_pay) AS old_earnings FROM person NATURAL JOIN works NATURAL JOIN position NATURAL JOIN position_yearly_pay NATURAL JOIN last_ended_job_date WHERE start_date > last_end_date AND (end_date IS NULL OR end_date > last_end_date) GROUP BY pers_id, primary_sector);
CREATE VIEW pay_change_by_sector AS (SELECT pers_id, primary_sector, current_earnings.earnings-previous_earnings AS pay_diff FROM current_earnings_by_sector NATURAL JOIN previous_earnings_by_sector GROUP BY pers_id);
CREATE VIEW pay_change AS (SELECT pers_id, SUM(pay_diff) AS diff FROM pay_change_by_sector GROUP BY pers_id);
/* 25.1 */
SELECT COUNT(*) AS increase_count FROM pay_change WHERE diff > 0;
/* 25.2 */
SELECT COUNT(*) AS decrease_count FROM pay_change WHERE diff < 0;
/* 25.3 */
WITH inc_count AS (SELECT COUNT(*) AS increase_count FROM pay_change WHERE diff > 0),
dec_count AS (SELECT COUNT(*) AS decrease_count FROM pay_change WHERE diff < 0)
SELECT increase_count / decrease_count AS ratio FROM increase_count, decrease_count;
/* 25.4 */
SELECT AVG(pay_diff) FROM pay_change_by_sector WHERE primary_sector = ?;
