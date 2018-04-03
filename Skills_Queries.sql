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
