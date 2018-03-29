/*1. List a specific company’s workers by names.*/
SELECT last_name,first_name,mi
FROM works w
JOIN person pers on w.pers_id = pers.pers_id
JOIN position p on w.pos_code = p.pos_code
WHERE comp_id = 89324987
AND end_date IS NULL
ORDER BY last_name;

--We need to insert information into all the tables; this is just my brainstorming attempt at queries.
/*2. List a specific company’s staff by salary in descending order.*/
SELECT last_name,first_name,mi,pay_rate
FROM works w
JOIN person pers on w.pers_id = pers.pers_id
JOIN position p on w.pos_code = p.pos_code
WHERE comp_id = 89324987
AND end_date IS NULL
AND pay_type = 'S'
ORDER BY pay_rate DESC;

/*3. List companies’ labor cost (total salaries and wage rates by 1920 hours) in descending order.*/
/*Option 1: Doesn't return anything, and I think it needs works included.*/
--DROP VIEW comp_sal_exp;
--CREATE VIEW comp_sal_exp AS (
--    SELECT c.comp_id, c.comp_name, SUM(p.pay_rate) AS sal_cost
--    FROM   company c
--    LEFT JOIN position p on c.comp_id = p.comp_id
--    WHERE  p.pay_type = 'S'
--    GROUP BY c.comp_id,c.comp_name);
--/*Test the view*/
--select * from comp_sal_exp;    
----The wage rate is going to be more difficult because it's just for the PT emp.
----How do we determine how much time they'll work? Here, I'm assuming 20 hr/wk.
--DROP VIEW comp_wage_exp;
--CREATE VIEW comp_wage_exp AS (
--    SELECT comp_id, comp_name, SUM(pay_rate * (1920/2)) AS wage_cost
--    FROM   company NATURAL JOIN works NATURAL JOIN position
--    WHERE  pay_type = 'W'
--    GROUP BY comp_id,comp_name);
--/*Test the view */    
--select * from comp_wage_exp;    
--
--/*Final query*/
--SELECT comp_id, comp_name, (SUM(sal_cost) + SUM(wage_cost)) AS total_cost
--FROM comp_sal_exp NATURAL JOIN comp_wage_exp
--GROUP BY comp_id, comp_name
--ORDER BY final_cost DESC;

/*Option 2: Can't test because position isn't working*/
--create view salary_cost as (
--	select comp_id,select c.comp_id,comp_name,sum(pay_rate) total_cost
--	from company natural join works
--	where pay_type = 'S'
--);
--create view wage_cost as (
--	select comp_id,select c.comp_id,comp_name,sum(pay_rate*1920) total_cost 
--	from company natural join works
--	where pay_type = 'W'
--);
--select comp_id, comp_name, sum(total_cost) 
--from (wage_cost natural join salary_cost) comp_total_cost
--join position on comp_total_cost.comp_id = position.comp_id
--group by comp_id, comp_name
--order by total_cost desc;

/*4. Given a person’s identifier, find all the job positions this person is currently holding and worked in the past.*/
/*Option 1: Can't run b/c position isn't working*/
--SELECT pos_code, title
--FROM person NATURAL JOIN position NATURAL JOIN works
--WHERE pers_id = 10;

/*Option 2: Can't run b/c position isn't working*/
--select first_name,mi,last_name,pos_code
--from person p
--left join works w on p.pers_id = w.pers_id
--where pers_id = 10
--UNION
--select pos.pos_code,pos_title,start_date, end_date
--from position pos 
--left join works w on pos.pos_code = w.pos_code
--where pers_id = 10;

/*5. Given a person’s identifier, list this person’s knowledge/skills in a readable format.*/
/*Option 1: Can't run b/c position isn't working*/
--SELECT ks_code,description,training_level
--FROM position NATURAL JOIN know_skill
--WHERE pers_id = 10;

/*Option 2: Can't run because we haven't given has_skill values yet*/
--create view person_skills as(
--	select pers_id, first_name, mi, last_name, ks_code
--	from person p
--	left join has_skill h_s on p.pers_id = h_s.pers_id
--	where pers_id = 10
--);
--
--select ks_code,ks_title,description
--from know_skill k_s
--left join person_skills p_s on k_s.ks_code = p_s.ks_code
--where pers_id = 10;

/*6. Given a person’s identifier, list the skill gap between the requirements of this worker’s job position(s) and his/her
skills.*/
(SELECT ks_code,pos_code,prefer
FROM position_skills p_s
LEFT JOIN works w on p_s.pos_code = w.pos_code
WHERE pers_id = 10
	AND end_date IS NULL)
MINUS 
(SELECT ks_code
FROM has_skill h_s
LEFT JOIN know_skill k_s on h_s.ks_code = k_s.ks_code
WHERE pers_id = 10;
);

/*7. List the required knowledge/skills of a pos_code and a job category code in a readable format. (Two queries)*/
/*First query*/
SELECT prefer, title, description
FROM   know_skill NATURAL JOIN position NATURAL JOIN requires_ks
WHERE  pos_code = 451020100;

/*Second query*/
--I ***think*** this is the way we'll use these tables.
SELECT  prime_sector_code,code_name,code_description
FROM    gics NATURAL JOIN nwcet
WHERE   prime_sector_code = 999999;

/*8. Given a person’s identifier, list a person’s missing knowledge/skills for a specific pos_code in a readable format.*/
/*I think "has_skill" is another very useful table here.*/
SELECT ks_code,description
FROM know_skill NATURAL JOIN (
                              (SELECT prefer
                               FROM requires_ks
                               WHERE pos_id = 014532)
                               MINUS
                              (SELECT ks_code
                               FROM has_skill
                               WHERE pers_id = 012569);

/*9. Given a person’s identifier and a pos_code, list the courses (course id and title) that each alone teaches all the
missing knowledge/skills for this person to pursue the specific job position.*/
--I'm going to use views as the execution method for this. I'm sure there's a better way, but I can't think of it.
--I'm using the has_skill & provides_skill relations because I can't think of how else to do this (again).
CREATE VIEW AS missing_ks(
                         (SELECT prefer
                          FROM   requires_ks
                          WHERE  pos_code = 99999;)
                         MINUS
                         (SELECT ks_code
                          FROM   has_skill
                          WHERE  pers_id = 9999;)
);

SELECT  c_code,course.title
FROM    course
WHERE NOT EXISTS(
                (SELECT ks_code
                 FROM   provides_skill
                 WHERE  provides_skill.c_code = course.c_code)
                MINUS
                (SELECT *
                 FROM   missing_ks)
);

/*10. Suppose the skill gap of a worker and the requirement of a desired job position can be covered by one course.
Find the “quickest” solution for this worker. Show the course, section information and the completion date.*/
--I'm going to use views as the execution method for this. I'm sure there's a better way, but I can't think of it.
/*Set up the missing knowledge/skill set*/
CREATE VIEW AS missing_ks(
                         (SELECT prefer
                          FROM   requires_ks
                          WHERE  pos_code = 99999;)
                         MINUS
                         (SELECT ks_code
                          FROM   has_skill
                          WHERE  pers_id = 9999;)
);
/*Set up the courses needed for the position*/
CREATE VIEW AS course_needed(
                        (SELECT c_code,sec_code,complete_date
                         FROM   section
                         WHERE NOT EXISTS(
                                          (SELECT ks_code
                                           FROM provides_skill
                                           WHERE provides_skill.c_code = section.c_code)
                                          MINUS
                                          (SELECT *
                                           FROM missing_ks)
                                          )
                        )
);
/*Final query*/
SELECT  course.c_code,sec_code,complete_date
FROM    course_needed NATURAL JOIN course
WHERE   complete_date = (
                         SELECT MIN(complete_date)
                         FROM course_needed);

/*11. Suppose the skill gap of a worker and the requirement of a desired job position can be covered by one course.
Find the cheapest course to make up one’s skill gap by showing the course to take and the cost (of the section
price).*/
--I'm going to use views as the execution method for this. I'm sure there's a better way, but I can't think of it.
/*Set up the missing knowledge/skill set*/
CREATE VIEW AS missing_ks(
                         (SELECT prefer
                          FROM   requires_ks
                          WHERE  pos_code = 99999;)
                         MINUS
                         (SELECT ks_code
                          FROM   has_skill
                          WHERE  pers_id = 9999;)
);
/*Set up the courses needed for the position*/
CREATE VIEW AS course_needed(
                        (SELECT c_code,sec_code,price
                         FROM   section
                         WHERE NOT EXISTS(
                                          (SELECT ks_code
                                           FROM provides_skill
                                           WHERE provides_skill.c_code = section.c_code)
                                          MINUS
                                          (SELECT *
                                           FROM missing_ks)
                                          )
                        )
);
/*Final query*/
SELECT  c_code,course.title,sec_code,price
FROM    course_needed NATURAL JOIN course
WHERE   price = (
                 SELECT MIN(price)
                 FROM   course_needed);
                 
/*12. NOT REQUIRED FOR 05APR18 TURN IN
If query #9 returns nothing, then find the course sets that their combination covers all the missing knowledge/
skills for a person to pursue a pos_code. The considered course sets will not include more than three courses. If
multiple course sets are found, list the course sets (with their course IDs) in the order of the ascending order of the
course sets’ total costs.*/


/*13. Given a person’s identifier, list all the job categories that a person is qualified for.*/
--I'm not 100% on this one. The GICS table is still a bit nebulous in my head.
SELECT  ks_code,title
FROM    know_skill
WHERE NOT EXISTS(
                 (SELECT    ks_code
                  FROM      has_skill NATURAL JOIN know_skill
                  WHERE     pers_id = 99999)
                 MINUS
                 (SELECT    cat_code
                  FROM      job_cat NATURAL JOIN gics
                  WHERE     job_cat.cat_code = gics.prime_sector_code)
                 );

/*14. Given a person’s identifier, find the job position with the highest pay rate for this person according to his/her skill
possession.*/
/*Using views again. I ***COULD*** use "WITH", but those things scare me.*/
/*Set up the person's job skills*/
CREATE VIEW AS qualified_job_skills(
                                    SELECT	pos_code, pos_title, pay_rate
                                    FROM	position
                                    WHERE NOT EXISTS (
                                            SELECT	prefer      --AKA the ks_code
                                            FROM	requires_ks
                                            WHERE	req_ks.job_ID = jobs.job_ID
                                            MINUS
                                            SELECT	ks_code
                                            FROM	has_skill
                                            WHERE	per_ID = 99999)
                                    );
/*Set up the wage cost for the company*/
CREATE VIEW AS wage_cost(    
                        SELECT		pos_code, pos_title, SUM(pay_rate * 1920)
                        FROM		position
                        WHERE       pay_type = 'W' 
                        GROUP BY    pos_code, pos_title
                        );
/*Set up the salary_cost for the company*/    
CREATE VIEW AS salary_cost(    
                        SELECT		pos_code, pos_title, SUM(pay_rate * 1920)
                        FROM		position
                        WHERE       pay_type = 'S' 
                        GROUP BY    pos_code, pos_title
                        );
/*Final query*/  
--I'm not sure I got the final WHERE statement correct. Something looks wonky there.
SELECT  pos_code, pos_title,pay_rate     
FROM    qualified_job_skills NATURAL JOIN wage_cost NATURAL JOIN salary_cost 
WHERE   pay_rate = (
                    SELECT MAX(pay_rate) 
                    FROM qualified_job_skills
                    );

/*15. Given a position code, list all the names along with the emails of the persons who are qualified for this position.*/
SELECT  first_name,mi,last_name,email
FROM    person 
/*This gives the person's qualifiers for the job*/
WHERE EXISTS(
             (SELECT ks_code
              FROM   has_skill NATURAL JOIN person
              WHERE  has_skill.pers_id = person.pers_id)
             MINUS
             (SELECT prefer
              FROM   requires_ks
              WHERE  pos_code = 9999)
            )
/*This takes away anything that a person is missing from the job skills*/
--Did I overthink this? Do we even need this bit of the query?
AND NOT EXISTS(
               (SELECT    ks_code
                FROM      cert NATURAL JOIN person)
               MINUS
               (SELECT    ks_code
                FROM      requires_ks NATURAL JOIN position
                WHERE     pos_code = 9999;)
              );

/*16. When a company cannot find any qualified person for a job position, a secondary solution is to find a person who
is almost qualified to the job position. Make a “missing-one” list that lists people who miss only one skill for a
specified pos_code.*/


/*17. List each of the skill code and the number of people who misses the skill and are in the missing-one list for a
given position code in the ascending order of the people counts.*/


/*18. Suppose there is a new position that has nobody qualified. List the persons who miss the least number of skills
that are required by this pos_code and report the “least number”.*/


/*19. For a specified position code and a given small number k, make a “missing-k” list that lists the people’s IDs and
the number of missing skills for the people who miss only up to k skills in the ascending order of missing skills.*/


/*20. Given a position code and its corresponding missing-k list specified in Question 19. Find every skill that is
needed by at least one person in the given missing-k list. List each skill code and the number of people who need
it in the descending order of the people counts.*/


/*21. In a local or national crisis, we need to find all the people who once held a job position of the special job category
identifier. List per_id, name, job position title and the years the person worked (starting year and ending year).*/


/*22. Find all the unemployed people who once held a job position of the given pos_code.*/


/*23. Find out the biggest employer in terms of number of employees and the total amount of salaries and wages paid to
employees. (Two queries)*/


/*24. Find out the job distribution among business sectors; find out the biggest sector in terms of number of employees
and the total amount of salaries and wages paid to employees. (Two queries)*/


/*25. Find out (1) the number of the people whose earnings increased, (2) the number of those whose earnings
decreased, (3) the ratio of (# of earning increased : # of earning decreased), (4) the average earning changing rate
of for the workers in a specific business sector (use attribute “primary sector” in table Company. [Hint: earning
change = the sum of a person’s current income – the sum of the person’s earning when he/she was holding his/her
the latest previous job position. For (4), only count the earning from the specified sector (companies’ “primary
sector”)]*/


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
