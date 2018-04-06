/*1. List a specific company?s workers by names. ++++*/
SELECT DISTINCT last_name, first_name, mi
FROM works
NATURAL JOIN person
NATURAL JOIN position
WHERE comp_id = 1113
AND end_date IS NULL
ORDER BY last_name;

/*2. List a specific company?s staff by salary in descending order. ++++*/
DROP VIEW position_yearly_pay;
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

SELECT last_name, first_name, mi, yearly_pay
FROM works 
NATURAL JOIN person
NATURAL JOIN position
NATURAL JOIN position_yearly_pay
WHERE comp_id = 1112
AND end_date IS NULL
ORDER BY yearly_pay DESC;

/*3. List companies' labor cost (total salaries and wage rates by 1920 hours) in descending order. ++++Both++++*/
SELECT comp_id, comp_name, SUM(yearly_pay) AS labor_cost
FROM company
NATURAL JOIN works
NATURAL JOIN position
NATURAL JOIN position_yearly_pay
WHERE end_date IS NULL
GROUP BY comp_id, comp_name
ORDER BY labor_cost DESC;

/*4. Given a person?s identifier, find all the job positions this person is currently holding and worked in the past. ++++*/
SELECT pos_code, pos_title, start_date, end_date
FROM person 
NATURAL JOIN position 
NATURAL JOIN works
WHERE pers_id = 3;

/*5. Given a person?s identifier, list this person?s knowledge/skills in a readable format. ++++*/
SELECT ks_title, description, training_level
FROM person
NATURAL JOIN has_skill
NATURAL JOIN know_skill
WHERE pers_id = 7;

/*6. Given a person?s identifier, list the skill gap between the requirements of this worker?s job position(s) and his/her
skills. +++Both+++*/
DROP VIEW missing_count;
DROP VIEW missing_skills;
DROP VIEW relevant_skills;
CREATE VIEW relevant_skills AS (
    SELECT pers_id, pos_code, ks_code 
    FROM person 
    NATURAL JOIN has_skill 
    NATURAL JOIN position_skills);
CREATE VIEW missing_skills AS (
    SELECT pers_id, pos_code, ks_code 
    FROM person, position_skills 
    MINUS 
    SELECT pers_id, pos_code, ks_code
    FROM relevant_skills);
CREATE VIEW position_qual AS(
    SELECT pers_id, pos_code
    FROM person, position
    MINUS
    SELECT DISTINCT pers_id, pos_code
    FROM missing_skills);
CREATE VIEW missing_count AS (
    SELECT pers_id, pos_code, COUNT(*) AS num_missing 
    FROM missing_skills 
    GROUP BY pers_id, pos_code);

-- LISTAGG concatenates all the ks_codes into one row.
SELECT pos_code, ks_code
FROM missing_skills
NATURAL JOIN works
WHERE pers_id = 1
AND end_date IS NULL;

/*7. List the required knowledge/skills of a pos_code and a job category code in a readable format. 
     (Two queries) +++Both+++*/
/*First query*/
SELECT pos_code, pos_title, ks_title, description
FROM  position 
NATURAL JOIN position_skills 
NATURAL JOIN know_skill 
WHERE  pos_code = 10;

/* Second query.*/
--SELECT job_category_title, nwcet_title, LISTAGG(ks_title, ', ') 
SELECT job_category_title, nwcet_title, ks_title 
FROM job_category jc
JOIN nwcet ON jc.core_skill = nwcet.nwcet_code
NATURAL JOIN know_skill
WHERE cat_code = '15-1250';

/*8. Given a person?s identifier, list a person?s missing knowledge/skills for a specific pos_code in a readable format. +++*/
SELECT pos_code, ks_title
FROM missing_skills 
NATURAL JOIN know_skill
WHERE pers_id = 7 
AND pos_code = 10;

/*9. Given a person?s identifier and a pos_code, list the courses (course id and title) that each alone teaches all the
missing knowledge/skills for this person to pursue the specific job position.*/
DROP VIEW satisfy_skills;
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
SELECT c_code, title, description
FROM satisfy_skills
NATURAL JOIN course;

/*10. Suppose the skill gap of a worker and the requirement of a desired job position can be covered by one course.
Find the ?quickest? solution for this worker. Show the course, section information and the completion date.*/
/*I NEED has_skill AND course_cert DATA INSERTION FOR TESTING*/
SELECT title, sec_code, complete_date, format
  FROM section
  NATURAL JOIN course
  NATURAL JOIN satisfy_skills
  WHERE complete_date = (SELECT MIN(complete_date) 
                         FROM section 
                         NATURAL JOIN satisfy_skills 
                         WHERE complete_date > (SELECT SYSDATE FROM DUAL));

/*11. Suppose the skill gap of a worker and the requirement of a desired job position can be covered by one course.
Find the cheapest course to make up one?s skill gap by showing the course to take and the cost (of the section
price).*/
SELECT title, sec_code, complete_date, format
  FROM section
  NATURAL JOIN course
  NATURAL JOIN satisfy_skills
  WHERE price = (SELECT MIN(price) 
                        FROM satisfy_skills 
                        NATURAL JOIN section
                        WHERE complete_date > (SELECT SYSDATE FROM DUAL));
                 
/*12. NOT REQUIRED FOR 05APR18 TURN IN
If query #9 returns nothing, then find the course sets that their combination covers all the missing knowledge/
skills for a person to pursue a pos_code. The considered course sets will not include more than three courses. If
multiple course sets are found, list the course sets (with their course IDs) in the order of the ascending order of the
course sets? total costs.*/

/*13. Given a person?s identifier, list all the job categories that a person is qualified for. ++++*/
DROP VIEW category_qual;
DROP VIEW missing_category_skills;
DROP VIEW category_skills;
DROP VIEW relevant_category_skills;
CREATE VIEW category_skills AS (
    SELECT cat_code, ks_code 
    FROM know_skill 
    NATURAL JOIN nwcet
    JOIN job_category ON nwcet_code = job_category.core_skill);
CREATE VIEW relevant_category_skills AS (
    SELECT pers_id, cat_code, ks_code 
    FROM person 
    NATURAL JOIN has_skill 
    NATURAL JOIN know_skill
    NATURAL JOIN nwcet 
    JOIN job_category ON nwcet_code = job_category.core_skill);
CREATE VIEW missing_category_skills AS (
    SELECT pers_id, cat_code, ks_code 
    FROM person, category_skills 
    MINUS 
    SELECT pers_id, cat_code, ks_code
    FROM relevant_category_skills);
CREATE VIEW category_qual AS (
    SELECT pers_id, cat_code 
    FROM person,job_category
    MINUS
    SELECT DISTINCT pers_id, cat_code 
    FROM missing_category_skills);
SELECT cat_code 
FROM category_qual 
WHERE pers_id = 7;

/*14. Given a person?s identifier, find the job position with the highest pay rate for this person according to his/her skill
possession.*/
--position_qual view in query #6
--position_yearly_pay view in query #2
SELECT pos_code, pos_title, yearly_pay
FROM position_qual 
NATURAL JOIN position_yearly_pay
NATURAL JOIN position
WHERE pers_id = 7
AND yearly_pay = (SELECT MAX(yearly_pay)
                  FROM position_qual 
                  NATURAL JOIN position_yearly_pay
                  WHERE pers_id = 7);

/*15. Given a position code, list all the names along with the emails of the persons who are qualified for this position. ++++ BUT could be better (more generic)*/
DROP VIEW skill_qual;
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
DROP VIEW cert_qual;
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
                 
SELECT last_name, first_name, mi, email 
FROM person 
NATURAL JOIN skill_qual; 
                                                    
/*16. When a company cannot find any qualified person for a job position, a secondary solution is to find a person who
is almost qualified to the job position. Make a ?missing-one? list that lists people who miss only one skill for a
specified pos_code. ++++Double check data, but appears to work. */
-- missing_count, missing_skills, and relevant_skills moved up to... ?
SELECT pers_id, (first_name || ' ' || last_name) AS name
FROM missing_count
NATURAL JOIN person
WHERE pos_code = 10 
AND num_missing = 1;

/*17. List each of the skill code and the number of people who misses the skill and are in the missing-one list for a
given position code in the ascending order of the people counts. ++++*/
WITH missing_one AS (
    SELECT pers_id 
    FROM missing_count 
    WHERE pos_code = 10 
    AND num_missing = 1)
SELECT ks_code, COUNT(pers_id) AS person_count 
FROM missing_skills 
NATURAL JOIN missing_one 
WHERE pos_code = 10  
GROUP BY ks_code 
ORDER BY person_count;

/* For not just missing one... */
/*SELECT ks_code, COUNT(pers_id) AS person_count 
FROM missing_skills 
WHERE pos_code = 10
GROUP BY ks_code 
ORDER BY person_count;*/

/*18. Suppose there is a new position that has nobody qualified. List the persons who miss the least number of skills
that are required by this pos_code and report the ?least number?. ++++ */
SELECT pers_id, num_missing 
FROM missing_count 
WHERE num_missing = 
        (SELECT MIN(num_missing) 
         FROM missing_count 
         WHERE pos_code = 10) 
AND pos_code = 10;

/*19. For a specified position code and a given small number k, make a ?missing-k? list that lists the people?s IDs and
the number of missing skills for the people who miss only up to k skills in the ascending order of missing skills. ++++*/
SELECT pers_id, num_missing 
FROM missing_count 
WHERE num_missing <= 10 
AND pos_code = 7
ORDER BY num_missing;

/*20. Given a position code and its corresponding missing-k list specified in Question 19. Find every skill that is
needed by at least one person in the given missing-k list. List each skill code and the number of people who need
it in the descending order of the people counts. ++++*/
SELECT DISTINCT ks_code 
FROM missing_skills 
NATURAL JOIN missing_count
WHERE pos_code = 7
AND num_missing <= 10;

/*21. In a local or national crisis, we need to find all the people who once held a job position of the special job category
identifier. List per_id, name, job position title and the years the person worked (starting year and ending year). ++++*/
SELECT pers_id, last_name, first_name, mi, pos_title, start_date, end_date 
FROM person 
NATURAL JOIN works 
NATURAL JOIN position 
WHERE cat_code = '15-1250' 
AND end_date IS NOT NULL;

/*22. Find all the unemployed people who once held a job position of the given pos_code. ++++*/
DROP VIEW unemployed_people;
CREATE VIEW unemployed_people AS (
    SELECT pers_id 
    FROM person 
    MINUS 
    SELECT DISTINCT pers_id 
    FROM works 
    WHERE end_date IS NULL);
SELECT pers_id 
FROM unemployed_people 
NATURAL JOIN works
WHERE end_date IS NOT NULL 
AND pos_code = 12;

/*23. Find out the biggest employer in terms of number of employees and the total amount of salaries and wages paid to
employees. (Two queries) ++++*/
/*First query*/
DROP VIEW company_employee_count;
CREATE VIEW company_employee_count AS (
    SELECT comp_id, COUNT(*) AS empl_count 
    FROM works 
    NATURAL JOIN position 
    WHERE end_date IS NULL 
    GROUP BY comp_id);
SELECT comp_name, empl_count 
FROM company 
NATURAL JOIN company_employee_count 
WHERE empl_count = 
                (SELECT MAX(empl_count) 
                 FROM company_employee_count);

/*Second query*/
DROP VIEW company_labor_cost;
CREATE VIEW company_labor_cost AS(
    SELECT comp_id, SUM(yearly_pay) AS labor_cost
    FROM company 
    NATURAL JOIN position
    NATURAL JOIN position_yearly_pay
    GROUP BY comp_id); 
SELECT comp_id, comp_name, labor_cost
FROM company_labor_cost
NATURAL JOIN company
WHERE labor_cost = (SELECT MAX(labor_cost) 
                    FROM company_labor_cost);

/*24. Find out the job distribution among business sectors; find out the biggest sector in terms of number of employees
and the total amount of salaries and wages paid to employees. (Two queries) ++++*/
CREATE VIEW sector_employee_count AS (
    SELECT primary_sector_code, SUM(empl_count) AS sec_empl_count 
    FROM company 
    NATURAL JOIN company_employee_count 
    GROUP BY primary_sector_code);
CREATE VIEW sector_labor_cost AS (
    SELECT primary_sector_code, SUM(labor_cost) AS sec_labor_cost 
    FROM company 
    NATURAL JOIN company_labor_cost 
    GROUP BY primary_sector_code);
/*Query 1*/
SELECT primary_sector_code 
FROM sector_employee_count 
WHERE sec_empl_count = (
                    SELECT MAX(sec_empl_count) 
                    FROM sector_employee_count);
/*Query 2*/
SELECT primary_sector_code 
FROM sector_labor_cost 
WHERE sec_labor_cost = (
                    SELECT MAX(sec_labor_cost) 
                    FROM sector_labor_cost);

/*25. Find out (1) the number of the people whose earnings increased, (2) the number of those whose earnings
decreased, (3) the ratio of (# of earning increased : # of earning decreased), (4) the average earning changing rate
of for the workers in a specific business sector (use attribute ?primary sector? in table Company. [Hint: earning
change = the sum of a person?s current income ? the sum of the person?s earning when he/she was holding his/her
the latest previous job position. For (4), only count the earning from the specified sector (companies? ?primary
sector?)] ++++*/
-- position_yearly_pay moved up to Query 2
-- (SELECT SYSDATE FROM DUAL) == NOW
DROP VIEW current_earnings_by_sector;
CREATE VIEW current_earnings_by_sector AS (
    SELECT pers_id, primary_sector_code, SUM(yearly_pay) AS current_earnings 
    FROM person 
    NATURAL JOIN works 
    NATURAL JOIN position 
    NATURAL JOIN position_yearly_pay 
    WHERE end_date IS NULL 
    GROUP BY pers_id, primary_sector_code);
CREATE VIEW last_ended_job_date AS (
    SELECT pers_id, MAX(end_date) AS last_end_date 
    FROM person 
    NATURAL JOIN works 
    GROUP BY pers_id); 
DROP VIEW previous_earnings_by_sector;
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
DROP VIEW pay_change_by_sector;
CREATE VIEW pay_change_by_sector AS (
    SELECT pers_id, primary_sector_code, SUM(earnings) AS pay_diff
    FROM(
        SELECT pers_id, primary_sector_code, current_earnings AS earnings
        FROM current_earnings_by_sector
        UNION
        SELECT pers_id, primary_sector_code, -1*previous_earnings AS earnings
        FROM previous_earnings_by_sector)
    GROUP BY pers_id, primary_sector_code);
DROP VIEW pay_change;
CREATE VIEW pay_change AS (
    SELECT pers_id, SUM(pay_diff) AS diff 
    FROM pay_change_by_sector 
    GROUP BY pers_id);
/* 25.1 */
SELECT COUNT(*) AS increase_count 
FROM pay_change 
WHERE diff > 0;
/* 25.2 */
SELECT COUNT(*) AS decrease_count 
FROM pay_change 
WHERE diff < 0;
/* 25.3 */
WITH inc_count AS (
        SELECT COUNT(*) AS increase_count 
        FROM pay_change 
        WHERE diff > 0),
     dec_count AS (
        SELECT COUNT(*) AS decrease_count 
        FROM pay_change 
        WHERE diff < 0)
SELECT increase_count / decrease_count AS ratio 
FROM inc_count, dec_count;
/* 25.4 */
SELECT AVG(pay_diff) 
FROM pay_change_by_sector 
WHERE primary_sector_code = '45102010';

/*BONUS: NOT REQUIRED FOR 05APR18 TURN IN*/
/*26. Find the leaf-node job categories that have the most openings due to lack of qualified workers. If there are many
opening positions of a job category but at the same time there are many qualified jobless people. Then training
cannot help fill up this type of job position. What we want to find is such a job category that has the largest
difference between vacancies (the unfilled job positions of this category) and the number of jobless people who
are qualified for the job positions of this category.*/


/*BONUS: NOT REQUIRED FOR 05APR18 TURN IN*/
/*27. Find the courses that can help most jobless people find a job position by training them toward the jobs of this
category that have the most openings due to lack of qualified workers.*/


/*Have fun with this one, Rachel!!! :)*/
/*28. NOT REQUIRED FOR 05APR18 TURN IN
List all the courses, directly or indirectly required, that a person has to take in order to be qualified for a job
position of the given category, according to his/her skills possessed and courses taken. (required for graduate
students only)*/