DELETE FROM NWCET;
INSERT into NWCET (nwcet_code, parent_nwcet_code, nwcet_title, description) 
VALUES ('Programming Language','', 'Programming Language Skills', 'Skills in modern programming language');

INSERT into NWCET (nwcet_code, parent_nwcet_code, nwcet_title, description) 
VALUES ('DDA','', 'Database Development and Administration', 'Skills in database development and administration');

INSERT into NWCET (nwcet_code, parent_nwcet_code, nwcet_title, description) 
VALUES ('DM','', 'Digital Media', 'Skills in digital media and communications');

INSERT into NWCET (nwcet_code, parent_nwcet_code, nwcet_title, description) 
VALUES ('ESAI','', 'Enterprise Systems Analysis and Integration', 'Skills in enterprise systems analysis and integration');

INSERT into NWCET (nwcet_code, parent_nwcet_code, nwcet_title, description) 
VALUES ('NDA','', 'Network Design and Administration', 'Skills in network design and administration');

INSERT into NWCET (nwcet_code, parent_nwcet_code, nwcet_title, description) 
VALUES ('PSE','', 'Programming/Software Engineering', 'Skills software engineering and development');

INSERT into NWCET (nwcet_code, parent_nwcet_code, nwcet_title, description) 
VALUES ('TS','', 'Technical Support', 'Skills in enterprise technical support');

INSERT into NWCET (nwcet_code, parent_nwcet_code, nwcet_title, description) 
VALUES ('TW','', 'Technical Writing', 'Skills in technical writing');

INSERT into NWCET (nwcet_code, parent_nwcet_code, nwcet_title, description) 
VALUES ('WDA','', 'Web Development and Adminstration', 'Skills web applications development and adminstration');



/*GICS WORKING
CREATE TABLE GICS (
    primary_sector_code varchar(8) NOT NULL PRIMARY KEY,
    code_name varchar(255),
    code_description varchar(255),
    parent_sector_code varchar(8),
    CONSTRAINT parent_gics_sector_fk FOREIGN KEY (parent_sector_code) REFERENCES GICS (primary_sector_code)
);*/
DELETE FROM GICS;
INSERT into GICS VALUES ('IT', 'Information Technology', 'Anything to do with technology and computer stuff', '');
INSERT INTO GICS VALUES ('DBS','Database Systems','Database wizardry', 'IT');
INSERT into GICS VALUES ('DBA', 'Database Administration', 'Database administration ', 'DBS');

INSERT into GICS VALUES ('10', 'Energy', 'Energy-General', ''); --10, Energy
INSERT into GICS VALUES ('15', 'Materials', 'Materials - General ', ''); --15, Materials
INSERT into GICS VALUES ('45', 'Information Technology', 'Information Tech- General', ''); --45, information technolgy
INSERT into GICS VALUES ('4510', 'Software and Services', 'Software and Services--IT', '45'); --4510,Software and services
INSERT into GICS VALUES ('451010', 'Internet Services ', 'Software and Services--IT, internet softw and services', '4510'); --4510,Software and services
INSERT into GICS VALUES ('451030', 'Software', 'Software and Services--IT', '45'); --4510,Software and services


/*COMPANY WORKING
NOTE constraint: company references GICS, so make sure to insert into GICS before running*/
/*CREATE TABLE company(
    comp_id NUMBER GENERATED by default on null as IDENTITY PRIMARY KEY,
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
INSERT into company (comp_name, address1, address2, city, state, zip, primary_sector_code, website) 
    VALUES('General Electric','34 Edison Parkway','', 'Crotonville','NY','10562','IT','www.ge.com');
INSERT into company (comp_name, address1, address2, city, state, zip, primary_sector_code, website)  
    VALUES('Lucid','2839 St Charles Avenue', '','New Orleans','LA','70447','IT','lucid.com');
INSERT into company (comp_name, address1, address2, city, state, zip, primary_sector_code, website) 
    VALUES('Lucido','2839 St Charles Avenue', '','New Orleans','LA','70447','IT','lucid.com');
INSERT into company (comp_name, address1, address2, city, state, zip, primary_sector_code, website) 
    VALUES('Lucida','2839 St Charles Avenue', '','New Orleans','LA','70447','IT','lucid.com');
INSERT into company (comp_name, address1, address2, city, state, zip, primary_sector_code, website) 
    VALUES('Lucide','2839 St Charles Avenue', '','New Orleans','LA','70447','DBA','lucid.com');
INSERT into company (comp_name, address1, address2, city, state, zip, primary_sector_code, website) 
    VALUES('Lucidi','2839 St Charles Avenue', '','New Orleans','LA','70447','IT','lucid.com');
UPDATE company set PHONE = '9998887777' WHERE comp_name = 'Lucid';    
UPDATE company SET phone = '9565415172' WHERE comp_id = 1111;
UPDATE company SET phone = '9565415172' WHERE comp_id = 1112;
UPDATE company SET phone = '9565415172' WHERE comp_id = 1113;
UPDATE company SET phone = '9565415172' WHERE comp_id = 1114;
UPDATE company SET phone = '9565415172' WHERE comp_id = 1115;
UPDATE company SET phone = '9565415172' WHERE comp_id = 1116;
/*Test company*/
select comp_name
from company;

select *
From company;



/*KNOW SKILL WORKING*/
/*Insert 30 skills into know_skill
    CREATE TABLE know_skill(
    ks_code varchar (255) NOT NULL PRIMARY KEY,
    nwcet_code varchar (255) NOT NULL,
    ks_title varchar(255) NOT NULL,
    description varchar(255),
    training_level varchar(255) NOT NULL, -- Beginner, Intermediate, Advanced
    CONSTRAINT ks_nwcet_fk FOREIGN KEY (nwcet_code) REFERENCES NWCET (nwcet_code)
);
*/
DELETE FROM know_skill;
INSERT into know_skill (ks_code, nwcet_code, ks_title, description, training_level) 
VALUES('Java', 'Programming Language', 'Java', 'Basics of Java programming language', 'Beginner');

INSERT into know_skill (ks_code, nwcet_code, ks_title, description, training_level) 
VALUES('Java2', 'Programming Language', 'Java', 'Basics of Java programming language', 'Intermediate');

INSERT into know_skill (ks_code, nwcet_code, ks_title, description, training_level) 
VALUES('Java3', 'Programming Language', 'Java', 'Basics of Java programming language', 'Advanced');


INSERT into know_skill (ks_code, nwcet_code, ks_title, description, training_level) 
VALUES('C1', 'PSE', 'C', 'Basics of C programming language', 'Intermediate');

INSERT into know_skill (ks_code, nwcet_code, ks_title, description, training_level) 
VALUES('.NET1', 'PSE', '.NET', 'Basics of .NE framework', 'Beginner');

INSERT into know_skill (ks_code, nwcet_code, ks_title, description, training_level) 
VALUES('SQL1', 'DDA', 'SQL', 'Basics of SQL', 'Beginner');

INSERT into know_skill (ks_code, nwcet_code, ks_title, description, training_level) 
VALUES('HTML1', 'WDA', 'HTML', 'Basics of html for web development', 'Beginner');

INSERT into know_skill (ks_code, nwcet_code, ks_title, description, training_level) 
VALUES('HTML2', 'WDA', 'HTML', 'intermediate of html for web development', 'intermediate');

INSERT into know_skill (ks_code, nwcet_code, ks_title, description, training_level) 
VALUES('3D Mod 2', 'DM', '3D Modeling', 'Skills in 3D modeling for digital media', 'Intermediate');

INSERT into know_skill (ks_code, nwcet_code, ks_title, description, training_level) 
VALUES('Angular1', 'WDA', 'Angular', 'Angular for Web Applications', 'Beginner');

INSERT into know_skill (ks_code, nwcet_code, ks_title, description, training_level) 
VALUES('Angular2', 'WDA', 'Angular', 'Angular for Web Applications', 'Intermediate');

INSERT into know_skill (ks_code, nwcet_code, ks_title, description, training_level) 
VALUES('Angular3', 'WDA', 'Angular', 'Angular for Web Applications', 'Advanced');
/*The above syntax is working. Update Insert statments below to match*/


/*Test know_skill*/
select * from know_skill;


/*PERSON WORKING*/

/*Insert five values into person*/
/*CREATE TABLE person (
    pers_id NUMBER GENERATED by default on null as IDENTITY PRIMARY KEY,
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
DELETE FROM person;
INSERT into person (last_name, first_name, mi, address1, city, state, zip, email, gender) 
VALUES('Adamus','Michael',null,'123 Washington Rd','New Orleans','LA','70110','mike_adam@gmail.com','M');

INSERT into person (last_name, first_name, mi, address1, address2, city, state, zip, email, gender) 
VALUES('Adamstein','Michael',null,'123 Washington Rd', '','New Orleans','LA','70110','mikastein@gmail.com','M');

INSERT into person (last_name, first_name, mi, address1, city, state, zip, email, gender) 
VALUES('Adamson','Michelle',null,'384 Broad Ave','New Orleans','LA','70110','madams@gmail.com','F');

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

select *
from person;


/*WORKING-- POSITION*/
/*NOTE: references company and know_skill; be sure to run GICS, NWCET, know_skill, and company
to generate comp_id and ks_code before inserting into position*/
/*Insert 10 job positions into position

    
    CREATE TABLE position(
    pos_code NUMBER GENERATED by default on null as IDENTITY PRIMARY KEY,
    comp_id number NOT NULL,
    pos_title varchar(255) NOT NULL,
    emp_mode varchar(2) NOT NULL,        --FT: full time, PT: part time
    primary_skill varchar(10) NOT NULL,
    pay_rate number(10,2) NOT NULL,
    pay_type varchar(1),        --W: wage, S: salary
    CONSTRAINT pos_company_fk FOREIGN KEY (comp_id) REFERENCES company(comp_id),
    CONSTRAINT primary_skill_fk FOREIGN KEY (primary_skill) REFERENCES know_skill(ks_code)
);
    */
DELETE FROM position;
/**NOTE: IN ORDER TO INSERT INTO POSITION, TABLES MUST BE DROPPD AND CREATED TO START AGAIN FROM VALUE 1111,
IN ORDER TO MATCH AUTO GENERATED PRIMARY KEYS**//
--INSERT into position (pos_code,comp_id, pos_title, emp_mode, primary_skill, pay_rate, pay_type)VALUES('',31, 'Junior developer','FT','Java',56000,'S'); --ge comp _id
INSERT into position (comp_id, pos_title, emp_mode, primary_skill, pay_rate) VALUES ('1111','junior','ft', 'Java',56000); ----Working, when comp_id matches with ge(comp id 1111)
INSERT into position (comp_id, pos_title, emp_mode, primary_skill, pay_rate) VALUES ('1112','junior','ft', 'Java',56000);
INSERT into position (comp_id, pos_title, emp_mode, primary_skill, pay_rate) VALUES ('1113','junior','ft', 'Java',56000);
INSERT into position (comp_id, pos_title, emp_mode, primary_skill, pay_rate) VALUES ('1114','junior','ft', 'Java',56000);

INSERT into position (comp_id, pos_title, emp_mode, primary_skill, pay_rate) VALUES ('1111','Entry Lev Angular Dev','ft', 'Angular1',26000); ----Working, when comp_id matches with ge(comp id 1111)
INSERT into position (comp_id, pos_title, emp_mode, primary_skill, pay_rate) VALUES ('1112','Intermediate Angular Dev','ft', 'Angular2',56000);
INSERT into position (comp_id, pos_title, emp_mode, primary_skill, pay_rate) VALUES ('1113','Senior Angular Dev','ft', 'Angular3',96000);
INSERT into position (comp_id, pos_title, emp_mode, primary_skill, pay_rate) VALUES ('1114','Entry Lev Angular Dev','ft', 'Angular1',56000);


INSERT into position (comp_id, pos_title, emp_mode, primary_skill, pay_rate, pay_type) VALUES ('1111','Sr JavaDev','ft', 'Java2',56000, 'S');
INSERT into position (comp_id, pos_title, emp_mode, primary_skill, pay_rate, pay_type) VALUES ('1112','Sr JavaDev','ft', 'Java2',56000, 'S');
INSERT into position (comp_id, pos_title, emp_mode, primary_skill, pay_rate, pay_type) VALUES ('1113','Sr JavaDev','ft', 'Java2',56000, 'S');
INSERT into position (comp_id, pos_title, emp_mode, primary_skill, pay_rate, pay_type) VALUES ('1113','jr HTML dev','ft', 'HTML2',16000, 'S');

INSERT into position (comp_id, pos_title, emp_mode, primary_skill, pay_rate, pay_type) VALUES ('1111','Sr JavaDev','ft', 'Java2',56.00, 'W');
INSERT into position (comp_id, pos_title, emp_mode, primary_skill, pay_rate, pay_type) VALUES ('1112','Sr JavaDev','ft', 'Java2',5.00, 'W');
INSERT into position (comp_id, pos_title, emp_mode, primary_skill, pay_rate, pay_type) VALUES ('1113','Sr JavaDev','ft', 'Java2',18.0, 'W');
INSERT into position (comp_id, pos_title, emp_mode, primary_skill, pay_rate, pay_type) VALUES ('1113','jr HTML dev','ft', 'HTML2',16.0, 'W');


select * from position;


/*TESTING*/
SELECT comp_name, comp_id, pos_title
FROM position NATURAL JOIN company;


--INSERT into position VALUES(451020100,37829,'FT',0156,56000,'S');  --general electric comp_id
--INSERT into position VALUES(451020200,382939,'FT',0253,64000,'S'); --lucid comp_id
--INSERT into position VALUES(451030100,89324987,'FT',0364,68000,'S'); --dxc comp id
--INSERT into position VALUES(451030101,89324987,'PT',0452,12.50,'W');     --Sophomore intern, dxc
--INSERT into position VALUES(451030102,89324987,'PT',0549,13.25,'W');     --Junior intern, dxc
--INSERT into position VALUES(451030103,89324987,'PT',0655,14.00,'W');     --Senior intern, dxc
--INSERT into position VALUES(202020100,384829,'FT',0748,72000,'S');     --Mgmt position, turbosquid
--INSERT into position VALUES(202020101,384829,'FT',0896,96000,'S');     --Executive position, turbosquid
--INSERT into position VALUES(202020102,74817,'FT',0948,45000,'S');     --Admin position, ibm
--INSERT into position VALUES(402010201,74817,'FT',1076,63000,'S');     --Finance position, ibm
/*Test position*/
select * from position;



select * from person;
    
/*CREATE TABLE works(
    pos_code number NOT NULL,
    pers_id number NOT NULL,
    start_date varchar(255) NOT NULL,
    end_date varchar(255),
    CONSTRAINT works_pk PRIMARY KEY (pos_code, pers_id),
    CONSTRAINT pos_start_date_uniq UNIQUE (pos_code, start_date),
    CONSTRAINT pers_works_fk FOREIGN KEY (pers_id) REFERENCES person (pers_id),
    CONSTRAINT pos_works_fk FOREIGN KEY (pos_code) REFERENCES position (pos_code)
);*/

INSERT into works VALUES (1,1,'11/06/2010', '');
INSERT into works VALUES (2,2,'9/2/2016','3/2/2017');
INSERT into works VALUES (3,7,'3/06/2006','');
INSERT into works VALUES (4,6,'3/06/2006','3/2/2017');
INSERT into works VALUES (5,5,'3/2/2017','7/09/2017');
INSERT into works VALUES (6,4,'8/18/2012','');
INSERT into works VALUES (7,3,'3/2/2017','');
INSERT into works VALUES (8,2,'8/18/2012','');

INSERT into works VALUES (9,1,'11/06/2010', '');
INSERT into works VALUES (10,2,'9/2/2016','3/2/2017');
INSERT into works VALUES (11,7,'3/06/2006','');
INSERT into works VALUES (12,6,'3/06/2006','3/2/2017');
INSERT into works VALUES (13,5,'3/2/2017','7/09/2017');
INSERT into works VALUES (14,4,'8/18/2012','');
INSERT into works VALUES (15,3,'3/2/2017','');
INSERT into works VALUES (16,2,'8/18/2012','');







/*CREATE TABLE position_skills (
    ks_code varchar (255) NOT NULL,
    pos_code number NOT NULL,
    prefer char(1) NOT NULL, -- R: Required, P: Preferred
    CONSTRAINT position_pk PRIMARY KEY (ks_code, pos_code),
    CONSTRAINT ps_ks_fk FOREIGN KEY (ks_code) REFERENCES know_skill(ks_code),
    CONSTRAINT ps_pos_fk FOREIGN KEY (pos_code) REFERENCES position(pos_code)*/
    
    INSERT into position_skills VALUES ('Java2','10','R');
    INSERT into position_skills VALUES ('Java2','15','R');
    INSERT into position_skills VALUES ('Angular3','7','R');
    INSERT into position_skills VALUES ('Angular1','8','P');     I
    INSERT into position_skills VALUES ('HTML2','12','P');
    
    Select* from position_skills;









/*COURSES NOT YET UPDATED*/
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
--DELETE FROM course; 
--INSERT into course VALUES(014568,'Advanced DB Design Principles','Advanced','How to improve existing DB with minimal disruption to 
--    your business','Active',560,'Class');
--INSERT into course VALUES(021977,'SQL for Beginners','Beginner','Learn how to query your work database','Expired',475,'Online');
--INSERT into course VALUES(038264,'Writing Grants','Intermediate','Learn to write grants the RIGHT way','Active', 1340,'Online');
--INSERT into course VALUES(047619,'JDBC and Your Organization','Intermediate','Make your database safer by using JDBC to pull 
--    information','Active',1050,'Online');
--INSERT into course VALUES(054153,'MySQL in the Workplace','Beginner','Use mySQL to supercharge your database','Expired',890,
--    'Classroom');
--INSERT into course VALUES(067498,'Python and the Database','Intermediate','Incorporate Python-based programming with your
--    database','Active',1460,'Classroom');
--INSERT into course VALUES(075476,'Depracation and the Database','Advanced','Common sense steps to preserve the modernity of 
--    your database','Expired',1230,'Classroom');
--INSERT into course VALUES(084286,'Cybersecurity in Your Workplace','Intermediate','Working with the NSA and FBI to ensure your
--    workplace remains secure and protects your proprietary information','Active',2200,'Online');
--INSERT into course VALUES(091137,'Improve Your Telecommunications','Beginner','Course for executives/decision makers who are
--    responsible for telework agreements and connectivity','Expired',3500,'Classroom');
--INSERT into course VALUES(109884,'Execute Your Goals','Advanced','Learn how to motivate your employees and provide
--    them with direction','Expired',750,'Online');
--/*Test course*/
--select * from course;

