/*1. List a specific company?s workers by names.*/
SELECT DISTINCT last_name,first_name,mi
FROM works w
LEFT JOIN person pers ON w.pers_id = pers.pers_id
LEFT JOIN position p ON w.pos_code = p.pos_code
WHERE comp_id = 1113
AND end_date IS NULL
ORDER BY last_name;

/*2. List a specific company?s staff by salary in descending order.*/
SELECT last_name,first_name,mi,pay_rate
FROM works w
JOIN person pers ON w.pers_id = pers.pers_id
JOIN position p ON w.pos_code = p.pos_code
WHERE comp_id = 1111
AND end_date IS NULL
AND pay_type = 'S'
ORDER BY pay_rate DESC;

/*3. List companies' labor cost (total salaries and wage rates by 1920 hours) in descending order.*/
DROP VIEW total_cost;
DROP VIEW wage_cost;
DROP VIEW salary_cost;

CREATE VIEW salary_cost AS (
	SELECT comp_id,comp_name, SUM(pay_rate) AS cost
	FROM company
	NATURAL JOIN position 
	NATURAL JOIN works 
	--left join position p on c.comp_id = p.comp_id
	--left join works w on p.pos_code = w.pos_code
	WHERE pay_type = 'S' 
    AND end_date IS NULL
    GROUP BY comp_id, comp_name
);

CREATE VIEW wage_cost AS (
	SELECT comp_id,comp_name, SUM(pay_rate*1920) AS cost 
	FROM company 
	NATURAL JOIN position 
	NATURAL JOIN works 
	--left join position p on c.comp_id = p.comp_id
	--left join works w on p.pos_code = w.pos_code
	WHERE pay_type = 'W'
    AND end_date IS NULL
    GROUP BY comp_id, comp_name
);

/* This appears to work. */
WITH costs AS (
    SELECT * 
    FROM wage_cost 
    UNION 
    SELECT * 
    FROM salary_cost)
SELECT comp_id, comp_name, SUM(cost) AS labor_cost
FROM costs 
GROUP BY comp_id, comp_name
ORDER BY labor_cost DESC;

/*4. Given a person?s identifier, find all the job positions this person is currently holding and worked in the past.*/
SELECT pers_id,first_name,mi,last_name,pos_code, pos_title,start_date,end_date
FROM person 
NATURAL JOIN position 
NATURAL JOIN works
WHERE pers_id = 3;

/*5. Given a person?s identifier, list this person?s knowledge/skills in a readable format.*/
SELECT first_name,mi,last_name,ks_title,description,training_level
FROM person p
LEFT JOIN has_skill hs ON p.pers_id = hs.pers_id
LEFT JOIN know_skill ks ON hs.ks_code = ks.ks_code
WHERE p.pers_id = 7;

/*6. Given a person?s identifier, list the skill gap between the requirements of this worker?s job position(s) and his/her
skills.*/
(SELECT ks_code,ps.pos_code,prefer
FROM position_skills ps
LEFT JOIN works w ON ps.pos_code = w.pos_code
WHERE pers_id = 3
	AND end_date IS NULL)
MINUS 
(SELECT hs.ks_code,pos_code, prefer
FROM has_skill hs
LEFT JOIN know_skill ks ON hs.ks_code = ks.ks_code
LEFT JOIN position_skills ps ON hs.ks_code = ps.ks_code
WHERE pers_id = 3);

/*7. List the required knowledge/skills of a pos_code and a job category code in a readable format. 
     (Two queries)*/
/*First query*/
SELECT pos_code, pos_title, primary_skill, ks_title title, description
FROM   position p
LEFT JOIN know_skill ks ON p.primary_skill = ks.ks_code
WHERE  pos_code = 10;

/*Second query*/
SELECT  DISTINCT pos_code, pos_title, n.nwcet_code job_cat_code, n.nwcet_title cat_title, n.description 
FROM    nwcet n
LEFT JOIN know_skill ks ON n.nwcet_code = ks.nwcet_code 
LEFT JOIN position p ON ks.ks_code = p.primary_skill
WHERE   n.nwcet_code = 'WDA';

/*8. Given a person?s identifier, list a person?s missing knowledge/skills for a specific pos_code in a readable format.*/
DROP VIEW missing_skill;
CREATE VIEW missing_skill AS (
    (SELECT pers_id,first_name,mi,last_name,ks_code
    FROM position_skills 
    NATURAL JOIN PERSON
    WHERE prefer = 'R'
    AND pers_id = 1)
    MINUS
    (SELECT pers_id,first_name,mi,last_name,ks_code
    FROM has_skill 
    NATURAL JOIN person
    WHERE pers_id = 1));
    
SELECT pers_id,first_name,mi,last_name,ks_title missing_skill, description missing_skill_desc
FROM know_skill ks 
LEFT JOIN missing_skill ms ON ks.ks_code = ms.ks_code
WHERE pers_id = 1;

/*9. Given a person?s identifier and a pos_code, list the courses (course id and title) that each alone teaches all the
missing knowledge/skills for this person to pursue the specific job position.*/
--I COMPILE, but has_skill isn't populated yet, so I can't be fully tested.
/*Set up the missing knowledge/skill set*/
DROP VIEW missing_skill;
CREATE VIEW missing_skill AS (
    (SELECT pers_id,first_name,mi,last_name,ks_code
    FROM position_skills 
    NATURAL JOIN PERSON
    WHERE pos_code = 3
    AND prefer = 'R'
    AND pers_id = 1)
    MINUS
    (SELECT pers_id,first_name,mi,last_name,ks_code
    FROM has_skill 
    NATURAL JOIN person
    WHERE pers_id = 1));
/*Final query*/
SELECT  c_code,course.title
FROM    course
WHERE NOT EXISTS(
                (SELECT ks_code
                 FROM   position_skills
                 WHERE prefer = 'R')
                MINUS
                (SELECT ks_code
                 FROM   missing_skill)
);

/*10. Suppose the skill gap of a worker and the requirement of a desired job position can be covered by one course.
Find the ?quickest? solution for this worker. Show the course, section information and the completion date.*/
/*I NEED has_skill AND course_cert DATA INSERTION FOR TESTING*/
DROP VIEW course_needed; 
DROP VIEW course2pos; 
DROP VIEW missing_ks;

/*Set up the missing knowledge/skill set*/
CREATE VIEW missing_ks AS(
                         (SELECT prefer ks_code
                          FROM   position_skills
                          WHERE  pos_code = 1)
                         MINUS
                         (SELECT ks_code
                          FROM   has_skill
                          WHERE  pers_id = 3)
);

/*Get the course-to-position information*/
CREATE VIEW course2pos AS(
    SELECT c.c_code,title,ps.pos_code,pos_title,ps.ks_code,ks_title
    FROM course_cert cc
    LEFT JOIN position_cert pc ON cc.cert_code = pc.cert_code
    LEFT JOIN position_skills ps ON pc.pos_code = ps.pos_code
    LEFT JOIN position p ON p.pos_code = pc.pos_code
    LEFT JOIN course c ON cc.c_code = c.c_code
    LEFT JOIN know_skill ks ON ps.ks_code = ks.ks_code);

/*Set up the courses needed for the position*/
CREATE VIEW course_needed AS (
                        (SELECT c_code,sec_code,complete_date
                         FROM   section
                         WHERE NOT EXISTS(
                                          (SELECT ks_code
                                           FROM course2pos)
                                          MINUS
                                          (SELECT ks_code
                                           FROM missing_ks)
                                          )
                        )
);
/*Final query*/
SELECT  c_code,sec_code,complete_date
FROM    course_needed NATURAL JOIN course
WHERE   complete_date = (
                         SELECT MIN(complete_date)
                         FROM course_needed);

/*11. Suppose the skill gap of a worker and the requirement of a desired job position can be covered by one course.
Find the cheapest course to make up one?s skill gap by showing the course to take and the cost (of the section
price).*/
--I COMPILE BUT NEED INSERTS FOR TESTING.
DROP VIEW course_needed; 
DROP VIEW course2pos; 
DROP VIEW missing_ks;
/*Set up the missing knowledge/skill set*/
CREATE VIEW missing_ks AS(
                         (SELECT prefer ks_code
                          FROM   position_skills
                          WHERE  pos_code = 1)
                         MINUS
                         (SELECT ks_code
                          FROM   has_skill
                          WHERE  pers_id = 3)
);

/*Get the course-to-position information*/
CREATE VIEW course2pos AS(
    SELECT c.c_code,title,ps.pos_code,pos_title,ps.ks_code,ks_title
    FROM course_cert cc
    LEFT JOIN position_cert pc ON cc.cert_code = pc.cert_code
    LEFT JOIN position_skills ps ON pc.pos_code = ps.pos_code
    LEFT JOIN position p ON p.pos_code = pc.pos_code
    LEFT JOIN course c ON cc.c_code = c.c_code
    LEFT JOIN know_skill ks ON ps.ks_code = ks.ks_code);

/*Set up the courses needed for the position*/
CREATE VIEW course_needed AS (
                        (SELECT c_code,sec_code,complete_date
                         FROM   section
                         WHERE NOT EXISTS(
                                          (SELECT ks_code
                                           FROM course2pos)
                                          MINUS
                                          (SELECT ks_code
                                           FROM missing_ks)
                                          )
                        )
);

/*Final query*/
SELECT  c_code,course.title,sec_code,retail_price
FROM    course_needed 
NATURAL JOIN course
WHERE   retail_price = 
                (SELECT MIN(retail_price)
                 FROM   course_needed);
                 
/*12. NOT REQUIRED FOR 05APR18 TURN IN
If query #9 returns nothing, then find the course sets that their combination covers all the missing knowledge/
skills for a person to pursue a pos_code. The considered course sets will not include more than three courses. If
multiple course sets are found, list the course sets (with their course IDs) in the order of the ascending order of the
course sets? total costs.*/


/*13. Given a person?s identifier, list all the job categories that a person is qualified for.*/
DROP VIEW pers_skills;
CREATE VIEW pers_skills AS(
    SELECT hs.ks_code,ps.pos_code
    FROM has_skill hs
    LEFT JOIN person p ON hs.pers_id = p.pers_id 
    LEFT JOIN position_skills ps ON hs.ks_code = ps.ks_code
    LEFT JOIN position_cert pc ON ps.pos_code = pc.pos_code
    WHERE p.pers_id = 2
    AND ps.prefer = 'R'
    AND pc.prefer = 'R');
    
SELECT job_category_title,description
FROM job_category jc
LEFT JOIN position p ON jc.core_skill = p.primary_skill
NATURAL JOIN pers_skills;

/*14. Given a person?s identifier, find the job position with the highest pay rate for this person according to his/her skill
possession.*/
--I COMPILE BUT NEED INSERTS SO I CAN PRODUCE DATA
DROP VIEW qualified_job_skills;
CREATE VIEW qualified_job_skills AS(
                                    SELECT	pos_code, pos_title, pay_rate
                                    FROM	position
                                    WHERE NOT EXISTS (
                                            (SELECT	ks_code      
                                            FROM	position_skills
                                            WHERE	pos_code = 3)
                                            MINUS
                                            (SELECT	ks_code
                                            FROM	has_skill
                                            WHERE	pers_id = 3)
                                            )
                                    );
/*Set up the wage cost for the company*/
DROP VIEW wage_cost;
CREATE VIEW wage_cost AS(    
                        SELECT		pos_code, pos_title, (pay_rate * 1920) pay_rate
                        FROM		position
                        WHERE       pay_type = 'W' 
                        );
/*Set up the salary_cost for the company*/    
DROP VIEW salary_cost;
CREATE VIEW salary_cost AS(    
                        SELECT		pos_code, pos_title, pay_rate
                        FROM		position
                        WHERE       pay_type = 'S' 
                        );
/*Final query*/  
SELECT  pos_code, pos_title,pay_rate     
FROM    qualified_job_skills 
NATURAL JOIN wage_cost 
NATURAL JOIN salary_cost 
WHERE   pay_rate = 
                    (SELECT MAX(pay_rate) 
                     FROM qualified_job_skills);

/*15. Given a position code, list all the names along with the emails of the persons who are qualified for this position.*/
INSERT INTO has_skill VALUES (1, 'Java2');

DROP VIEW skill_qual;
CREATE VIEW skill_qual AS (
    SELECT DISTINCT pers_id 
    FROM has_skill hs1)
    WHERE NOT EXISTS
      (SELECT * 
       FROM position_skills ps1
       WHERE pos_code = 10 
       AND NOT EXISTS
          (SELECT * 
           FROM has_skill hs2
           WHERE hs1.pers_id = hs2.pers_id 
           AND   hs2.ks_code = ps1.ks_code));
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
           AND   hc2.cert_code = pc1.cert_code));
                 
SELECT last_name, first_name, mi, email 
FROM person 
NATURAL JOIN skill_qual; 
                                                    
/*16. When a company cannot find any qualified person for a job position, a secondary solution is to find a person who
is almost qualified to the job position. Make a ?missing-one? list that lists people who miss only one skill for a
specified pos_code.*/
DROP VIEW missing_count;
DROP VIEW missing_skills;
DROP VIEW missing_skills2;
DROP VIEW rev_skills_count;
DROP VIEW relevant_skills;
DROP VIEW relevant_skills2;
DROP VIEW skills_count;
CREATE VIEW relevant_skills AS (
    SELECT person.pers_id, position.pos_code, has_skill.ks_code AS pers_skill, position_skills.ks_code AS pos_skill 
    FROM person 
    FULL OUTER JOIN has_skill ON person.pers_id = has_skill.pers_id 
    FULL OUTER JOIN position_skills ON has_skill.ks_code = position_skills.ks_code 
    FULL OUTER JOIN position ON position.pos_code = position_skills.pos_code);
CREATE VIEW relevant_skills2 AS (
    SELECT pers_id, pos_code, ks_code AS pers_skill, ks_code AS pos_skill 
    FROM person 
    NATURAL JOIN has_skill 
    NATURAL JOIN position_skills 
    NATURAL JOIN position);
CREATE VIEW rev_skills_count AS (
    SELECT pers_id, pos_code, COUNT(pers_skill) AS skills 
    FROM relevant_skills 
    GROUP BY pers_id, pos_code);
CREATE VIEW skills_count AS (
    SELECT pos_code, COUNT(*) AS req_skills 
    FROM position_skills 
    GROUP BY pos_code);
CREATE VIEW missing_skills2 AS (
    SELECT pers_id, pos_code, (req_skills-skills) AS num_missing 
    FROM rev_skills_count NATURAL JOIN skills_count 
    WHERE req_skills-skills > 0);
CREATE VIEW missing_skills AS (
    SELECT pers_id, pos_code, ks_code 
    FROM person, position_skills 
    MINUS 
    SELECT pers_id, pos_code, pos_skill 
    FROM relevant_skills2);
CREATE VIEW missing_count AS (
    SELECT pers_id, pos_code, COUNT(*) AS num_missing 
    FROM missing_skills 
    GROUP BY pers_id, pos_code);
SELECT pers_id 
FROM missing_count 
WHERE pos_code = 10 
AND num_missing = 1;

/*17. List each of the skill code and the number of people who misses the skill and are in the missing-one list for a
given position code in the ascending order of the people counts.*/
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
that are required by this pos_code and report the ?least number?.*/
SELECT pers_id, num_missing 
FROM missing_count 
WHERE num_missing = 
                (SELECT MIN(num_missing) 
                 FROM missing_count 
                 WHERE pos_code = 10) 
                 AND pos_code = 10;

/*19. For a specified position code and a given small number k, make a ?missing-k? list that lists the people?s IDs and
the number of missing skills for the people who miss only up to k skills in the ascending order of missing skills.*/
SELECT pers_id, num_missing 
FROM missing_count 
WHERE num_missing <= 10 
AND pos_code = 10;

/*20. Given a position code and its corresponding missing-k list specified in Question 19. Find every skill that is
needed by at least one person in the given missing-k list. List each skill code and the number of people who need
it in the descending order of the people counts.*/
SELECT DISTINCT ks_code 
FROM missing_skills 
WHERE pos_code = 10;

/*21. In a local or national crisis, we need to find all the people who once held a job position of the special job category
identifier. List per_id, name, job position title and the years the person worked (starting year and ending year).*/
/*This should work once we change the schema*/
--SELECT pers_id, last_name, first_name, mi, start_date, end_date FROM person NATURAL JOIN works NATURAL JOIN position WHERE cat_code = ? AND end_date IS NOT NULL;

/*22. Find all the unemployed people who once held a job position of the given pos_code.*/
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
JOIN works 
WHERE end_date IS NOT NULL 
AND pos_code = 10;

/*23. Find out the biggest employer in terms of number of employees and the total amount of salaries and wages paid to
employees. (Two queries)*/
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
--Using company_labor_cost from Query 3
SELECT comp_name, labor_cost 
FROM company 
NATURAL JOIN company_labor_cost 
WHERE labor_cost = (
                SELECT MAX(labor_cost) 
                FROM company_labor_cost);

/*24. Find out the job distribution among business sectors; find out the biggest sector in terms of number of employees
and the total amount of salaries and wages paid to employees. (Two queries)*/
CREATE VIEW sector_employee_count AS (
    SELECT primary_sector, SUM(empl_count) AS sec_empl_count 
    FROM company 
    NATURAL JOIN company_employee_count 
    GROUP BY primary_sector);
CREATE VIEW sector_labor_cost AS (
    SELECT primary_sector, SUM(labor_cost) AS sec_labor_cost 
    FROM company 
    NATURAL JOIN company_labor_cost 
    GROUP BY primary_sector);
SELECT primary_sector 
FROM sector_employee_count 
WHERE sec_empl_count = (
                    SELECT MAX(sec_empl_count) 
                    FROM sector_employee_count);
SELECT primary_sector 
FROM sector_labor_cost 
WHERE sec_labor_cost = (
                    SELECT MAX(sec_labor_cost) 
                    FROM sector_labor_cost);

/*25. Find out (1) the number of the people whose earnings increased, (2) the number of those whose earnings
decreased, (3) the ratio of (# of earning increased : # of earning decreased), (4) the average earning changing rate
of for the workers in a specific business sector (use attribute ?primary sector? in table Company. [Hint: earning
change = the sum of a person?s current income ? the sum of the person?s earning when he/she was holding his/her
the latest previous job position. For (4), only count the earning from the specified sector (companies? ?primary
sector?)]*/


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