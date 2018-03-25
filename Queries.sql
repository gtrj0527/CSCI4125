/*1. List a specific company’s workers by names.*/
SELECT pers_id,last_name,first_name,mi
FROM person,works,company
WHERE comp_id = 012659 AND end_date IS NULL
ORDER BY last_name;
--We need to insert information into all the tables; this is just my brainstorming attempt at queries.
/*2. List a specific company’s staff by salary in descending order.*/
SELECT pers_id,last_name,first_name,mi
FROM person,works,company,position
WHERE comp_id = 012659 
    AND end_date IS NULL 
    AND pay_type = 'S'
ORDER BY pay_rate DESC;
/*3. List companies’ labor cost (total salaries and wage rates by 1920 hours) in descending order.*/
CREATE VIEW comp_sal_exp AS (
    SELECT comp_id, comp_name, SUM(pay_rate) AS sal_cost
    FROM   company,works,position
    WHERE  pay_type = 'S'
    GROUP BY comp_id;
--The wage rate is going to be more difficult because it's just for the PT emp.
--How do we determine how much time they'll work? Here, I'm assuming 20 hr/wk.
CREATE VIEW comp_wage_exp AS (
    SELECT comp_id, comp_name, SUM(pay_rate * (1920/2)) AS wage_cost
    FROM   company,works,position
    WHERE  pay_type = 'W'
    GROUP BY comp_id;
    
SELECT comp_id, comp_name, SUM(sal_cost + wage_cost) AS total_cost
FROM comp_sal_exp, comp_wage_exp
GROUP BY comp_id, comp_name
ORDER BY final_cost;
/*4. Given a person’s identifier, find all the job positions this person is currently holding and worked in the past.*/
SELECT pos_code, title
FROM person,position, works
WHERE pers_id = 012569;
/*5. Given a person’s identifier, list this person’s knowledge/skills in a readable format.*/
SELECT ks_code,description,training_level
FROM position, know_skill
WHERE pers_id = 012569;
/*6. Given a person’s identifier, list the skill gap between the requirements of this worker’ job position(s) and his/her
skills.*/
/*I think we need to include the "has_skill" relation as a table. I 
can't think of another way to make this work.*/
(SELECT ks_code,description
 FROM requires_ks,know_skill,works
 WHERE pers_id = 012569
    AND end_date IS NULL)
MINUS
(SELECT ks_code,description 
 FROM has_skill,know_skill
 WHERE pers_id = 012569);
/*7. List the required knowledge/skills of a pos_code and a job category code in a readable format. (Two queries)*/
/*8. Given a person’s identifier, list a person’s missing knowledge/skills for a specific pos_code in a readable format.*/
/*I think "has_skill" is another very useful table here.*/
SELECT ks_code,description
FROM know_skill,(
                (SELECT ks_code
                FROM requires_ks
                WHERE pos_id = 014532)
                MINUS
                (SELECT ks_code
                FROM has_skill
                WHERE pers_id = 012569);
/*9. Given a person’s identifier and a pos_code, list the courses (course id and title) that each alone teaches all the
missing knowledge/skills for this person to pursue the specific job position.*/

/*10. Suppose the skill gap of a worker and the requirement of a desired job position can be covered by one course.
Find the “quickest” solution for this worker. Show the course, section information and the completion date.*/

/*11. Suppose the skill gap of a worker and the requirement of a desired job position can be covered by one course.
Find the cheapest course to make up one’s skill gap by showing the course to take and the cost (of the section
price).*/

/*12. If query #9 returns nothing, then find the course sets that their combination covers all the missing knowledge/
skills for a person to pursue a pos_code. The considered course sets will not include more than three courses. If
multiple course sets are found, list the course sets (with their course IDs) in the order of the ascending order of the
course sets’ total costs.*/

/*13. Given a person’s identifier, list all the job categories that a person is qualified for.*/

/*14. Given a person’s identifier, find the job position with the highest pay rate for this person according to his/her skill
possession.*/

/*15. Given a position code, list all the names along with the emails of the persons who are qualified for this position.*/

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

/*BONUS*/
/*26. Find the leaf-node job categories that have the most openings due to lack of qualified workers. If there are many
opening positions of a job category but at the same time there are many qualified jobless people. Then training
cannot help fill up this type of job position. What we want to find is such a job category that has the largest
difference between vacancies (the unfilled job positions of this category) and the number of jobless people who
are qualified for the job positions of this category.*/

/*BONUS*/
/*27. Find the courses that can help most jobless people find a job position by training them toward the jobs of this
category that have the most openings due to lack of qualified workers.*/

/*Have fun with this one, Rachel!!! :)*/
/*28. List all the courses, directly or indirectly required, that a person has to take in order to be qualified for a job
position of the given category, according to his/her skills possessed and courses taken. (required for graduate
students only)*/