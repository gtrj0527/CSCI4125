/* Query 16. */
DROP VIEW missing_skills;
DROP VIEW rev_skills_count;
DROP VIEW relevant_skills;
DROP VIEW skills_count;
CREATE VIEW relevant_skills AS (SELECT person.pers_id, position.pos_code, has_skill.ks_code AS pers_skill, position_skills.ks_code AS pos_skill FROM person FULL OUTER JOIN has_skill ON person.pers_id = has_skill.pers_id FULL OUTER JOIN position_skills ON has_skill.ks_code = position_skills.ks_code FULL OUTER JOIN position ON position.pos_code = position_skills.pos_code);
CREATE VIEW rev_skills_count AS (SELECT pers_id, pos_code, COUNT(pers_skill) AS skills FROM relevant_skills GROUP BY pers_id, pos_code);
CREATE VIEW skills_count AS (SELECT pos_code, COUNT(*) AS req_skills FROM position_skills GROUP BY pos_code);
CREATE VIEW missing_skills AS (SELECT pers_id, pos_code, (req_skills-skills) AS num_missing FROM rev_skills_count NATURAL JOIN skills_count WHERE req_skills-skills > 0);
SELECT * FROM missing_skills WHERE num_missing = 1;


/* Query 18 */
SELECT pers_id, num_missing FROM missing_skills WHERE num_missing = (SELECT MIN(num_missing) FROM missing_skills WHERE pos_code = 10) AND pos_code = 10;

/* Query 19 */
SELECT pers_id, num_missing FROM missing_skills WHERE num_missing <= 1 AND pos_code = 10;

/* Query 20, not working. */
WITH pers_skill_missing AS (SELECT pers_id FROM missing_skills WHERE num_missing <= 1 AND pos_code = 10)
SELECT DISTINCT position_skills.ks_code FROM position_skills JOIN has_skill ON position_skills.ks_code <> has_skill.ks_code NATURAL JOIN pers_skill_missing;
