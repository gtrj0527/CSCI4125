/*    pers_id NUMBER GENERATED ALWAYS AS IDENTITY START WITH 1000 NOT NULL PRIMARY KEY,
    last_name varchar(255) NOT NULL,
    first_name varchar(255) NOT NULL,
    mi varchar(1),
    address1 varchar(255) NOT NULL,
    address2 varchar(255),
    city varchar(255) NOT NULL,
    state varchar(2) NOT NULL, 
    zip varchar(9) NOT NULL,
    email varchar(255),
    gender varchar(2)*/
/*Insert five values into person*/
DELETE FROM person;
INSERT into person(last_name,first_name,mi, address1, city, state,zip,email,gender)
    VALUES('Adamus','Michael',null,'123 Washington Rd','New Orleans','LA','70110','mike_adam@gmail.com','M');
INSERT into person(last_name,first_name,mi, address1, city, state,zip,email,gender) 
    VALUES('Benavides', 'Ricardo', 'M', '564 Canal', 'New Orleans', 'LA', '70123', 'ricardo.benavides@hotmail.com', 'M');
INSERT into person(last_name,first_name,mi, address1, city, state,zip,email,gender) 
    VALUES('Chung', 'Connie', ' ', '123 Carlisle','New Orleans', 'LA', '70123', 'connie.chung@aol.com', 'F');
INSERT into person(last_name,first_name,mi, address1, city, state,zip,email,gender) 
    VALUES('Dumas', 'Alexandra', 'J', '3259 Manhattan','Gretna', 'LA', '70123', 'alexandra.dumas@gmail.com', 'F');
INSERT into person(last_name,first_name,mi, address1, city, state,zip,email,gender) 
    VALUES('Eccleston', 'Christoper', 'J', '5148 Napolean', 'New Orleans', 'LA', '70123', 'chris.eccleston@outlook.com', 'M');
/*Test person*/
select last_name
from person;

/*Insert 10 job positions into position
CREATE TABLE position(
    pos_code number(10) NOT NULL PRIMARY KEY,
    comp_id (8) NOT NULL
    emp_mode varchar(2),    --FT or PT
    ks_code varchar(10),    --Do we need various ks_codes? We'll need some overlap on some of these positions.
    pay_rate number(10,2),
    pay_type varchar(10),   --W (hr),S (ann)
    );
    */
    
    /*implement primary_skill varchar (10),*/
DELETE FROM position;
INSERT into position VALUES(451020100,37829,'FT',0156,56000,'S');  --general electric comp_id
INSERT into position VALUES(451020200,382939,'FT',0253,64000,'S'); --lucid comp_id
INSERT into position VALUES(451030100,89324987,'FT',0364,68000,'S'); --dxc comp id
INSERT into position VALUES(451030101,89324987,'PT',0452,12.50,'W');     --Sophomore intern, dxc
INSERT into position VALUES(451030102,89324987,'PT',0549,13.25,'W');     --Junior intern, dxc
INSERT into position VALUES(451030103,89324987,'PT',0655,14.00,'W');     --Senior intern, dxc
INSERT into position VALUES(202020100,384829,'FT',0748,72000,'S');     --Mgmt position, turbosquid
INSERT into position VALUES(202020101,384829,'FT',0896,96000,'S');     --Executive position, turbosquid
INSERT into position VALUES(202020102,74817,'FT',0948,45000,'S');     --Admin position, ibm
INSERT into position VALUES(402010201,74817,'FT',1076,63000,'S');     --Finance position, ibm
/*Test position*/
select * from position; 

/*Insert 10 courses into course
CREATE TABLE course(
    c_code number(10) NOT NULL PRIMARY KEY,
    title varchar(255),
    training_level varchar(12),     --Beginnner, Intermediate, Advanced
    description varchar(255),
    status varchar(10),             --Active, Expired
    retail_price number(10,2),
    train_type varchar(255)         --Online, Classroom
    );
*/
DELETE FROM course; 
INSERT into course VALUES(014568,'Advanced DB Design Principles','Advanced','How to improve existing DB with minimal disruption to 
    your business','Active',560,'Class');
INSERT into course VALUES(021977,'SQL for Beginners','Beginner','Learn how to query your work database','Expired',475,'Online');
INSERT into course VALUES(038264,'Writing Grants','Intermediate','Learn to write grants the RIGHT way','Active', 1340,'Online');
INSERT into course VALUES(047619,'JDBC and Your Organization','Intermediate','Make your database safer by using JDBC to pull 
    information','Active',1050,'Online');
INSERT into course VALUES(054153,'MySQL in the Workplace','Beginner','Use mySQL to supercharge your database','Expired',890,
    'Classroom');
INSERT into course VALUES(067498,'Python and the Database','Intermediate','Incorporate Python-based programming with your
    database','Active',1460,'Classroom');
INSERT into course VALUES(075476,'Depracation and the Database','Advanced','Common sense steps to preserve the modernity of 
    your database','Expired',1230,'Classroom');
INSERT into course VALUES(084286,'Cybersecurity in Your Workplace','Intermediate','Working with the NSA and FBI to ensure your
    workplace remains secure and protects your proprietary information','Active',2200,'Online');
INSERT into course VALUES(091137,'Improve Your Telecommunications','Beginner','Course for executives/decision makers who are
    responsible for telework agreements and connectivity','Expired',3500,'Classroom');
INSERT into course VALUES(109884,'Execute Your Goals','Advanced','Learn how to motivate your employees and provide
    them with direction','Expired',750,'Online');
/*Test course*/
select * from course;

/*Insert 30 skills into know_skill
CREATE TABLE know_skill(
    ks_code varchar (255)NOT NULL PRIMARY KEY,
    title varchar(255),
    description varchar(255),
    training_level varchar(255) --Beginner, Intermediate, Advanced
    );
*/
DELETE FROM know_skill;
INSERT into know_skill VALUES(601, 'Java', 'Basics of Java programming language', 'Beginner');
INSERT into know_skill VALUES(602, 'Java', 'Intermediate skills of Java programming language', 'Intermediate');
INSERT into know_skill VALUES(603,'C', 'Basics of C programming language', 'Beginner' );
INSERT into know_skill VALUES(604,'C', 'Intermediate skills of C programming language', 'Intermediate' );
INSERT into know_skill VALUES(605, 'JavaScript','Basics of JavaScript language','Beginner');
INSERT into know_skill VALUES(606,'JavaScript','Intermediate skills of JavaScript ','Intermediate');
INSERT into know_skill VALUES(607, '.NET', 'Understands basic .NET development', 'Beginner');
INSERT into know_skill VALUES(608,'.NET', 'Understands interemediate .NET development', 'Intermediate');
INSERT into know_skill VALUES(609,'.NET', 'Understands advanced .NET development', 'Advanced');
INSERT into know_skill VALUES(610,'SQL', 'Basic SQL skills', 'Beginner' );
INSERT into know_skill VALUES(611, 'SQL', 'Intermediate SQL skills', 'Intermediate');
INSERT into know_skill VALUES(612, 'SQL', 'Advanced SQL skills', 'Advanced');
INSERT into know_skill VALUES(613, 'Git', 'Experience with git version control','Advanced' );
INSERT into know_skill VALUES(614, 'AWS', 'Experience with AWS', 'Advanced');
INSERT into know_skill VALUES(615, 'REST', 'Experience with RESTful Web Services', 'Intermediate');
INSERT into know_skill VALUES(616,'OOP','Basic experience with any Object Oriented Programming Language','Beginner');
INSERT into know_skill VALUES(617, 'OOP','Intermediate experience with any Object Oriented Programming Language','Intermediate' );
INSERT into know_skill VALUES(618,'OOP','Advanced experience with any Object Oriented Programming Language','Intermediate');
INSERT into know_skill VALUES(619, 'Agile', 'Knowledge of Agile Development methodologies','Beginner');
INSERT into know_skill VALUES(620, 'Angular','Basic knowledge of Angular development','Beginner');
INSERT into know_skill VALUES(621, 'Angular','Intermediate knowledge of Angular development','Intermediate');
INSERT into know_skill VALUES(622,'Angular', 'Advanced knowledge of Angular development', 'Advanced');
INSERT into know_skill VALUES(623, 'Spring','Basic knowledge of Spring framework','Beginner');
INSERT into know_skill VALUES(624, 'Spring','Intermediate knowledge of Spring framework','Intermediate');
INSERT into know_skill VALUES(625, 'Spring','Advanced knowledge of Spring framework','Advanced');
INSERT into know_skill VALUES(626, 'HTML','Basic knowledge of HTML','Beginner');
INSERT into know_skill VALUES(627, 'HTML','Intermediate knowledge of HTML','Intermediate');
INSERT into know_skill VALUES(628, 'HTML','Advanced knowledge of HTML','Advanced' );
INSERT into know_skill VALUES(629, 'Unix','Basic knowledge of Unix systems','Beginner');
INSERT into know_skill VALUES(630, 'Unix','Intermediate knowledge of Unix systems','Intermediate');
INSERT into know_skill VALUES(631, 'Unix', 'Advanced knowledge of Unix systems', 'Advanced');
INSERT into know_skill VALUES(632, 'Python', 'Basic knowledge of Python programming language','Beginner');

/*Test know_skill*/
select * from know_skill;


/*CREATE TABLE company(
    comp_id number(8) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    comp_name varchar(255) NOT NULL,
    address1 varchar(255) NOT NULL,
    address2 varchar(255),
    city varchar(255) NOT NULL,
    state varchar(2) NOT NULL, 
    zip varchar(9) NOT NULL,
    primary_sector_code varchar(8) NOT NULL, --References GICS
    phone varchar(10),
    website varchar(255),
    CONSTRAINT sector_fk FOREIGN KEY (primary_sector_code) REFERENCES GICS(primary_sector_code)
);

/*Insert five values into company*/
DELETE FROM company;
INSERT into company (comp_name, address1, address2, city, state, zip, website) 
    VALUES('General Electric','34 Edison Parkway','', 'Crotonville','NY','10562','www.ge.com');
INSERT into company (comp_name, address1, address2, city, state, zip, website) 
    VALUES('Lucid','2839 St Charles Avenue', '','New Orleans','LA','70447','lucid.com');
INSERT into company (comp_name, address1, address2, city, state, zip, website) 
    VALUES('Lucido','2839 St Charles Avenue', '','New Orleans','LA','70447','lucid.com');
INSERT into company (comp_name, address1, address2, city, state, zip, website) 
    VALUES('Lucida','2839 St Charles Avenue', '','New Orleans','LA','70447','lucid.com');
INSERT into company (comp_name, address1, address2, city, state, zip, website) 
    VALUES('Lucide','2839 St Charles Avenue', '','New Orleans','LA','70447','lucid.com');
INSERT into company (comp_name, address1, address2, city, state, zip, website) 
    VALUES('Lucidi','2839 St Charles Avenue', '','New Orleans','LA','70447','lucid.com');
UPDATE company SET phone = '9565415172' WHERE comp_id = 1111;
UPDATE company SET phone = '9565415172' WHERE comp_id = 1112;
UPDATE company SET phone = '9565415172' WHERE comp_id = 1113;
UPDATE company SET phone = '9565415172' WHERE comp_id = 1114;
UPDATE company SET phone = '9565415172' WHERE comp_id = 1115;
UPDATE company SET phone = '9565415172' WHERE comp_id = 1116;
/*Test company*/
select comp_name
from company;

INSERT into company_specialty(comp_id,specialty) VALUES ('IA');
select * from company_specialty;
/*
DROP TABLE works;
CREATE TABLE works(
    pos_code number (10),
    pers_id number(5),
    job_title varchar(255),
	start_date varchar(255),
    end_date varchar(255),
    --PRIMARY KEY (start_date, end_date)  --CANNOT QUERY end_date IS NULL if end_date is primary key! -jtm
    PRIMARY KEY (start_date, pos_code)
    
    ); */

---I think we need pos_code in works
/*Insert 5 values into works*/
DELETE FROM works;
INSERT into works VALUES(838,null,'Junior Software Developer','11/06/2010', '');--we've got to do some thinking about end date as a primary key - jtm
INSERT into works VALUES(839,null, 'Entry Level Software Developer','9/2/2016', '3/2/2017'); 
INSERT into works VALUES(840,null,'Database Administrator II','3/06/2006', ''); 
INSERT into works VALUES(850, null,'Senior Quality Assurance Engineer','8/18/2012', '10/09/2017'); 
INSERT into works VALUES(860,10001,'DevOps Engineer','7/09/2017', ''); 
INSERT into works VALUES (451030100,10002,'DevOps Engineer', '7/09/2017','');
INSERT into works VALUES (451030101,10003,'Sophomore Intern', '7/09/2017','');
INSERT into works VALUES (451030102,10004,'Junior Intern', '7/09/2017','');

/*INSERT into position VALUES(451030100,89324987,'FT',0364,68000,'S'); --dxc comp id
INSERT into position VALUES(451030101,89324987,'PT',0452,12.50,'W');     --Sophomore intern, dxc
INSERT into position VALUES(451030102,89324987,'PT',0549,13.25,'W');     --Junior intern, dxc
INSERT into position VALUES(451030103,89324987,'PT',0655,14.00,'W');     --Senior intern, dxc*/



/*Test works*/
select job_title
from works;

select * from works;

/*SELECT pers_id,last_name,first_name,mi
FROM person NATURAL JOIN works NATURAL JOIN position NATURAL JOIN company
WHERE comp_id = 89324987 AND end_date IS NULL
ORDER BY last_name;*/

/*query1*/
SELECT *
FROM works w
JOIN person pers on pers.pers_id = w.pers_id
JOIN position p on w.pos_code = p.pos_code
WHERE comp_id = 89324987
AND end_date IS NULL
ORDER BY last_name;


