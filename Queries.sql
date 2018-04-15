/*TASKS*/
--Queries 12,26-28

/*1. List a specific company?s workers by names. ++++*/
SELECT DISTINCT full_name
FROM works
NATURAL JOIN person_full_name
NATURAL JOIN position
WHERE comp_id = 1113
AND end_date IS NULL
ORDER BY full_name ASC;

/*2. List a specific company?s staff by salary in descending order. ++++*/
SELECT full_name, yearly_pay
FROM works 
NATURAL JOIN pers_full_name
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
SELECT c_code, title, description
FROM satisfy_skills
NATURAL JOIN course;

/*10. Suppose the skill gap of a worker and the requirement of a desired job position can be covered by one course.
Find the ?quickest? solution for this worker. Show the course, section information and the completion date.*/
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
SELECT cat_code 
FROM category_qual 
WHERE pers_id = 7;

/*14. Given a person?s identifier, find the job position with the highest pay rate for this person according to his/her skill
possession.*/
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
SELECT full_name, email 
FROM pers_full_name 
NATURAL JOIN skill_qual; 
                                                    
/*16. When a company cannot find any qualified person for a job position, a secondary solution is to find a person who
is almost qualified to the job position. Make a ?missing-one? list that lists people who miss only one skill for a
specified pos_code. ++++Double check data, but appears to work. */
SELECT pers_id, full_name
FROM missing_count
NATURAL JOIN person
NATURAL JOIN pers_full_name
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
SELECT pers_id, full_name, pos_title, start_date, end_date 
FROM person
NATURAL JOIN pers_full_name 
NATURAL JOIN works 
NATURAL JOIN position 
WHERE cat_code = '15-1250' 
AND end_date IS NOT NULL;

/*22. Find all the unemployed people who once held a job position of the given pos_code. ++++*/
SELECT pers_id 
FROM unemployed_people 
NATURAL JOIN works
WHERE end_date IS NOT NULL 
AND pos_code = 12;

/*23. Find out the biggest employer in terms of number of employees and the total amount of salaries and wages paid to
employees. (Two queries) ++++*/
/*First query*/
SELECT comp_name, empl_count 
FROM company 
NATURAL JOIN company_employee_count 
WHERE empl_count = 
                (SELECT MAX(empl_count) 
                 FROM company_employee_count);

/*Second query*/
SELECT comp_id, comp_name, labor_cost
FROM company_labor_cost
NATURAL JOIN company
WHERE labor_cost = (SELECT MAX(labor_cost) 
                    FROM company_labor_cost);

/*24. Find out the job distribution among business sectors; find out the biggest sector in terms of number of employees
and the total amount of salaries and wages paid to employees. (Two queries) ++++*/
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
-- (SELECT SYSDATE FROM DUAL) == NOW
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