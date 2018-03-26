/*Insert five values into person*/
DELETE FROM person;
INSERT into person VALUES(10001, 'Adamus','Michael',null,123,'Washington Rd','New Orleans','LA',70110,'mike_adam@gmail.com','M',5043214567);
INSERT into person VALUES(10002, 'Benavides', 'Ricardo', 'M', 564, 'Canal', 'New Orleans', 'LA', 70123, 'ricardo.benavides@hotmail.com', 'M', 5045489723);
INSERT into person VALUES(10003, 'Chung', 'Connie', ' ', 123, 'Carlisle','New Orleans', 'LA', 70130, 'connie.chung@aol.com', 'F', 5049564785);
INSERT into person VALUES(10004, 'Dumas', 'Alexandra', 'J', 3259, 'Manhattan','Gretna', 'LA', 70124, 'alexandra.dumas@gmail.com', 'F', 5048725695);
INSERT into person VALUES(10005, 'Eccleston', 'Christoper', 'J', 5148, 'Napolean', 'New Orleans', 'LA', 70110, 'chris.eccleston@outlook.com', 'M', 5045697845);
/*Test person*/
select last_name
from person;

/*Insert 10 job positions into position
CREATE TABLE position(
    pos_code number(10) NOT NULL PRIMARY KEY,
    emp_mode varchar(2),    --FT or PT
    ks_code varchar(10),    --Do we need various ks_codes? We'll need some overlap on some of these positions.
    pay_rate number(10,2),
    pay_type varchar(10),   --W (hr),S (ann)
    );
    */
DELETE FROM position;
INSERT into position VALUES(451020100,'FT',0156,56000,'S');
INSERT into position VALUES(451020200,'FT',0253,64000,'S');
INSERT into position VALUES(451030100,'FT',0364,68000,'S');
INSERT into position VALUES(451030101,'PT',0452,12.50,'W');     --Sophomore intern
INSERT into position VALUES(451030102,'PT',0549,13.25,'W');     --Junior intern
INSERT into position VALUES(451030103,'PT',0655,14.00,'W');     --Senior intern
INSERT into position VALUES(202020100,'FT',0748,72000,'S');     --Mgmt position
INSERT into position VALUES(202020101,'FT',0896,96000,'S');     --Executive position
INSERT into position VALUES(202020102,'FT',0948,45000,'S');     --Admin position
INSERT into position VALUES(402010201,'FT',1076,63000,'S');     --Finance position
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
