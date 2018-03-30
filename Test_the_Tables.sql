select * from position;
select * from gics;
select * from nwcet;

/*9. Given a person’s identifier and a pos_code, list the courses (course id and title) that each alone teaches all the
missing knowledge/skills for this person to pursue the specific job position.*/
DROP VIEW missing_skill;
CREATE VIEW missing_skill AS (
    (SELECT pers_id,first_name,mi,last_name,ks_code
    FROM position_skills NATURAL JOIN PERSON
    WHERE pos_code = 3
    AND prefer = 'R'
    AND pers_id = 1)
    MINUS
    (SELECT pers_id,first_name,mi,last_name,ks_code
    FROM has_skill NATURAL JOIN person
    WHERE pers_id = 1));
select * from missing_skill;   

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