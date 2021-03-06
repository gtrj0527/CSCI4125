/*---DANGER! DROP AND CREATE TABLES EVERY TIME YOU TEST INSERTS SO WE MAINTAIN CONSISTENT AUTOGENERATED PRIMARY KEYS---------*/
/*PERSON: 
    CREATE TABLE person (
    pers_id NUMBER GENERATED by default on null as IDENTITY PRIMARY KEY,
    last_name varchar(255) NOT NULL,
    first_name varchar(255) NOT NULL,
    mi varchar(1),
    address1 varchar(255) NOT NULL,
    address2 varchar(255), 
    zip varchar(9) NOT NULL,
    email varchar(255),
    gender varchar(2)*/
INSERT INTO person (last_name, first_name, mi, address1, address2, zip, email, gender) 
    VALUES('Adamus','Michael',null,'123 Washington Rd','', '10196','mike_adam@gmail.com','M');
INSERT INTO person (last_name, first_name, mi, address1, address2, zip, email, gender) 
    VALUES('Edelstein','Morgan',null,'132 Worthington Rd', '','21044','medelstein@gmail.com','M');
INSERT INTO person (last_name, first_name, mi, address1, address2, zip, email, gender) 
    VALUES('Evasdotter','Eowyn',null,'384 Broad Ave','','32207','ee@gmail.com','F');
INSERT INTO person (last_name, first_name, mi, address1, address2, zip, email, gender) 
    VALUES('Benavides', 'Ricardo', 'M', '564 Canal', '','78553', 'ricardo.benavides@hotmail.com', 'M');
INSERT INTO person (last_name, first_name, mi, address1, address2, zip, email, gender) 
    VALUES('Chung', 'Connie', ' ', '123 Carlisle','','78586', 'connie.chung@aol.com', 'F');
INSERT INTO person (last_name, first_name, mi, address1, address2, zip, email, gender) 
    VALUES('Dumas', 'Alexandra', 'J', '3259 Manhattan','','78566', 'alexandra.dumas@gmail.com', 'F');
INSERT INTO person (last_name, first_name, mi, address1, address2, zip, email, gender) 
    VALUES('Eccleston', 'Christoper', 'J', '5148 Napolean','', '70065', 'chris.eccleston@outlook.com', 'M');
INSERT INTO person (last_name, first_name, mi, address1, address2, zip, email, gender) 
    VALUES('Dameron','Poe','','2187 Galactic Way','Ste A','27356','acehotshot@galaxy.com','M');
INSERT INTO person (last_name, first_name, mi, address1, address2, zip, email, gender) 
    VALUES('Trooper','Finn','T','2187 Galactic Way','Ste B','27356','formertrooper@galaxy.com','M');
INSERT INTO person (last_name, first_name, mi, address1, address2, zip, email, gender) 
    VALUES('Kenobi','Rey','','94 Freedoms Dr','','24892','jediintraining@galaxy.com','F');
INSERT INTO person (last_name, first_name, mi, address1, address2, zip, email, gender) 
    VALUES('Tico','Rose','','102 Cobalt St','','94108','freedom1@galaxy.com','F');
INSERT INTO person (last_name, first_name, mi, address1, address2, zip, email, gender) 
    VALUES('Erso','Jyn','','451 Stardust Ln','','28037','rogueone@galaxy.com','F');

/*Test person*/
SELECT *
FROM person;

/*NWCET*/
INSERT INTO NWCET (nwcet_code, parent_nwcet_code, nwcet_title, description) 
    VALUES ('Programming Language','', 'Programming Language Skills', 'Skills in modern programming language');
INSERT INTO NWCET (nwcet_code, parent_nwcet_code, nwcet_title, description) 
    VALUES ('DDA','', 'Database Development and Administration', 'Skills in database development and administration');
INSERT INTO NWCET (nwcet_code, parent_nwcet_code, nwcet_title, description) 
    VALUES ('DM','', 'Digital Media', 'Skills in digital media and communications');
INSERT INTO NWCET (nwcet_code, parent_nwcet_code, nwcet_title, description) 
    VALUES ('ESAI','', 'Enterprise Systems Analysis and Integration', 'Skills in enterprise systems analysis and integration');
INSERT INTO NWCET (nwcet_code, parent_nwcet_code, nwcet_title, description) 
    VALUES ('NDA','', 'Network Design and Administration', 'Skills in network design and administration');
INSERT INTO NWCET (nwcet_code, parent_nwcet_code, nwcet_title, description) 
    VALUES ('PSE','', 'Programming/Software Engineering', 'Skills software engineering and development');
INSERT INTO NWCET (nwcet_code, parent_nwcet_code, nwcet_title, description) 
    VALUES ('TS','', 'Technical Support', 'Skills in enterprise technical support');
INSERT INTO NWCET (nwcet_code, parent_nwcet_code, nwcet_title, description) 
    VALUES ('TW','', 'Technical Writing', 'Skills in technical writing');
INSERT INTO NWCET (nwcet_code, parent_nwcet_code, nwcet_title, description) 
    VALUES ('WDA','', 'Web Development and Adminstration', 'Skills web applications development and adminstration');
INSERT INTO NWCET (nwcet_code, parent_nwcet_code, nwcet_title, description) 
    VALUES ('COMPMATH','', 'General Computer and Mathematical Occupations', 'Skills in Computer and Mathematical Occupations');
/*Test NWCET*/
SELECT *
FROM NWCET;
/*GICS WORKING
CREATE TABLE GICS (
    primary_sector_code varchar(8) NOT NULL PRIMARY KEY,
    code_name varchar(255),
    code_description varchar(255),
    parent_sector_code varchar(8),
    CONSTRAINT parent_gics_sector_fk FOREIGN KEY (parent_sector_code) REFERENCES GICS (primary_sector_code)
);*/
--INSERT INTO GICS VALUES ('IT', 'Information Technology', 'Anything to do with technology and computer stuff', '');
--INSERT INTO GICS VALUES ('DBS','Database Systems','Database wizardry', 'IT');
--INSERT INTO GICS VALUES ('DBA', 'Database Administration', 'Database administration ', 'DBS');
INSERT INTO GICS VALUES ('10', 'Energy', 'Energy-General', ''); --10, Energy
INSERT INTO GICS VALUES ('15', 'Materials', 'Materials - General ', ''); --15, Materials
INSERT INTO GICS VALUES ('151010','Materials','Materials-Materials-Chemicals','15');
INSERT INTO GICS VALUES ('35', 'Health Care Equipment and Services', 'Health Care Equipment and Services-General', ''); 
INSERT INTO GICS VALUES ('35103010','Health Care Equipment and Services','Health Care Technology--Health Care Technology','35');
INSERT INTO GICS VALUES ('45', 'Information Technology', 'Information Tech- General', ''); --45, information technolgy
INSERT INTO GICS VALUES ('4510', 'Software and Services', 'Software and Services--IT', '45'); --4510,Software and services
INSERT INTO GICS VALUES ('451010', 'Internet Services ', 'Software and Services--IT, internet software and services', '4510'); --4510,Software and services
INSERT INTO GICS VALUES ('45102010', 'IT Services', 'Software and Services--IT Consulting and Other Services', '4510'); --4510,Software and services
INSERT INTO GICS VALUES ('45102020', 'IT Services', 'Software and Services--Data Processing and Outsourced Services', '4510'); --4510,Software and services
INSERT INTO GICS VALUES ('451030', 'Software', 'Software and Services--IT', '45'); --4510,Software and services
INSERT INTO GICS VALUES ('50', 'Telecommunication Services', 'Telecomm-General', ''); 
INSERT INTO GICS VALUES ('501020', 'Telecommunication Services ', 'Wireless Telecommunication Services', '50');
/*Test GICS*/
SELECT *
FROM GICS;

/*Company. NOTE about the constraint: company references GICS, so make sure to insert into GICS before running*/
/*CREATE TABLE company(
    comp_id NUMBER GENERATED by default on null as IDENTITY PRIMARY KEY,
    comp_name varchar(255) NOT NULL,
    address1 varchar(255) NOT NULL,
    address2 varchar(255),
    zip varchar(9) NOT NULL,
    primary_sector_code varchar(8) NOT NULL, --References GICS
    phone varchar(10),
    website varchar(255),
    CONSTRAINT sector_fk FOREIGN KEY (primary_sector_code) REFERENCES GICS(primary_sector_code)
);*/
INSERT into company (comp_name, address1, address2, zip, primary_sector_code,phone, website) 
    VALUES('General Electric','34 Edison Parkway','', '99551','45102010','9565415176','www.ge.com');
INSERT into company (comp_name, address1, address2, zip, primary_sector_code,phone, website) 
    VALUES('Lucid','2839 St Charles Avenue', '','72001','45102010','9565415175','lucid.com');
INSERT into company (comp_name, address1, address2, zip, primary_sector_code,phone, website) 
    VALUES('Texaco','2741 Freedom Way', 'Ste 6B','36310','45102010','9565415174','texaco.com');
INSERT into company (comp_name, address1, address2, zip, primary_sector_code,phone, website) 
    VALUES('Chevron','3476 Frenchman St', 'Apt 4A','39730','151010','9565415173','chevron.com'); 
INSERT into company (comp_name, address1, address2, zip, primary_sector_code,phone, website) 
    VALUES('Harvey Gulf Marine','173 Washington Ave', '','64166','45102020','5048257964','hgm.com');
INSERT into company (comp_name, address1, address2, zip, primary_sector_code,phone, website) 
    VALUES('Edison Chouest','437 Texas Hwy', '','68362','45102010','5124632983','chouest.com');
INSERT into company (comp_name, address1, address2, zip, primary_sector_code,phone, website) 
    VALUES('USA Quarry','18550 McDermott Fwy','','33427','451010','8005317822','usaa.com');
INSERT into company (comp_name, address1, address2, zip, primary_sector_code,phone, website) 
    VALUES('Exxon','4532 Gas Fwy','','30703','4510','8884579513','exxon.com');
INSERT into company (comp_name, address1, address2, zip, primary_sector_code,phone, website) 
    VALUES('Univision','4365 Global Way','','27156','501020','8009542127','univision.com');  
INSERT into company (comp_name, address1, address2, zip, primary_sector_code,phone, website) 
    VALUES('Childrens Hospital New Orleans','200 Henry Clay Ave','','70118','35103010','5048999511',
            'chnola.org');
--UPDATE company SET phone = '9565415172' WHERE comp_id = 1116;

/*KNOW_SKILL:
    CREATE TABLE know_skill(
    ks_code varchar (255) NOT NULL PRIMARY KEY,
    nwcet_code varchar (255) NOT NULL,
    ks_title varchar(255) NOT NULL,
    description varchar(255),
    training_level varchar(255) NOT NULL, -- Beginner, Intermediate, Advanced
    CONSTRAINT ks_nwcet_fk FOREIGN KEY (nwcet_code) REFERENCES NWCET (nwcet_code)
);
*/
INSERT INTO know_skill (ks_code, nwcet_code, ks_title, description, training_level) 
    VALUES('Java', 'Programming Language', 'Java', 'Basics of Java programming language', 'Beginner');
INSERT INTO know_skill (ks_code, nwcet_code, ks_title, description, training_level) 
    VALUES('Java2', 'Programming Language', 'Java', 'Basics of Java programming language', 'Intermediate');
INSERT INTO know_skill (ks_code, nwcet_code, ks_title, description, training_level) 
    VALUES('Java3', 'Programming Language', 'Java', 'Basics of Java programming language', 'Advanced');
INSERT INTO know_skill (ks_code, nwcet_code, ks_title, description, training_level) 
    VALUES('C1', 'PSE', 'C', 'Basics of C programming language', 'Intermediate');
INSERT INTO know_skill (ks_code, nwcet_code, ks_title, description, training_level) 
    VALUES('.NET1', 'PSE', '.NET', 'Basics of .NE framework', 'Beginner');
INSERT INTO know_skill (ks_code, nwcet_code, ks_title, description, training_level) 
    VALUES('HTML1', 'WDA', 'HTML', 'Basics of html for web development', 'Beginner');
INSERT INTO know_skill (ks_code, nwcet_code, ks_title, description, training_level) 
    VALUES('HTML2', 'WDA', 'HTML', 'intermediate of html for web development', 'intermediate');
INSERT INTO know_skill (ks_code, nwcet_code, ks_title, description, training_level) 
    VALUES('3D Mod 2', 'DM', '3D Modeling', 'Skills in 3D modeling for digital media', 'Intermediate');
INSERT INTO know_skill (ks_code, nwcet_code, ks_title, description, training_level) 
    VALUES('Angular1', 'WDA', 'Angular', 'Angular for Web Applications', 'Beginner');
INSERT INTO know_skill (ks_code, nwcet_code, ks_title, description, training_level) 
    VALUES('Angular2', 'WDA', 'Angular', 'Angular for Web Applications', 'Intermediate');
INSERT INTO know_skill (ks_code, nwcet_code, ks_title, description, training_level) 
    VALUES('Angular3', 'WDA', 'Angular', 'Angular for Web Applications', 'Advanced');
INSERT INTO know_skill (ks_code, nwcet_code, ks_title, description, training_level) 
    VALUES('SQL1', 'DDA', 'SQL', 'Basics of SQL', 'Beginner');
/*Test know_skill*/
SELECT * 
FROM know_skill;

/*course:
CREATE TABLE course(
    c_code NUMBER GENERATED by default on null as IDENTITY PRIMARY KEY,
    title varchar(255) NOT NULL,
    training_level varchar(12), -- Beginner, Intermediate, Advanced
    description varchar(255),
    status varchar(1) NOT NULL, -- A: Active, E: Expired
    retail_price number(10,2),
    train_type varchar(255) NOT NULL -- University, Training Company, Online Course, Non-Profit
);*/
INSERT INTO course (title, training_level, description, status, retail_price, train_type) 
    VALUES('Java','Beginner','Learn the basics of programming in Java','A',1770.80 ,'University-Traditional');
INSERT INTO course (title, training_level, description, status, retail_price, train_type) 
    VALUES('Java2','Intermediate','Continue developing Java skills','A',1850.75,'University-Online');    
INSERT INTO course (title, training_level, description, status, retail_price, train_type) 
    VALUES('Java3','Advanced','Master Java with advanced concepts','E',2125.00,'University-Traditional');
INSERT INTO course (title, training_level, description, status, retail_price, train_type) 
    VALUES('C1','Beginner','Introduction to programming in C','A',650,'Non-profit Organization');
INSERT INTO course (title, training_level, description, status, retail_price, train_type) 
    VALUES('.NET1','Beginner','Introduction to programming in .NET','E',775,'Non-profit Organization');
INSERT INTO course (title, training_level, description, status, retail_price, train_type) 
    VALUES('HTML1','Beginner','Learn how to create websites in this course','A',1875.90,'University-Online');
INSERT INTO course (title, training_level, description, status, retail_price, train_type) 
    VALUES('HTML2','Intermediate','Expand your HTML skills','E',2125.00,'University-Traditional');
INSERT INTO course (title, training_level, description, status, retail_price, train_type) 
    VALUES('3D Mod 2','Intermediate','Learn more about programming in 3D Mod','A',995.95,'Training Company');
INSERT INTO course (title, training_level, description, status, retail_price, train_type) 
    VALUES('Angular1','Beginner','Learn the basics of programming in Angular','A',1200,'Training Company');
INSERT INTO course (title, training_level, description, status, retail_price, train_type) 
    VALUES('Angular2','Intermediate','Enhance your Angular skills in this course','A',1350,'University-Traditional');
INSERT INTO course (title, training_level, description, status, retail_price, train_type) 
    VALUES('Angular3','Advanced','Master-level course for programming in Angular','E',1895,'Online course');
INSERT INTO course (title, training_level, description, status, retail_price, train_type) 
    VALUES('SQL1','Beginner','Learn the basics of database programming in SQL','A',1870.80 ,'University-Traditional');
/*Test course*/
SELECT * 
FROM course 
ORDER BY c_code;

/*training_provider: Run company first!
    CREATE TABLE training_provider(
    comp_id number NOT NULL PRIMARY KEY,
    train_type varchar(255), -- University, Training Company, Non-Profit
    CONSTRAINT provider_comp_fk FOREIGN KEY (comp_id) REFERENCES company (comp_id)*/
INSERT INTO training_provider VALUES(1111, 'Training Company');
INSERT INTO training_provider VALUES(1114, 'Non-Profit');
INSERT INTO training_provider VALUES(1117, 'Training Company');
 /*Test training_provider*/   
SELECT * 
FROM training_provider;

/*section. NOTE: Run person, course and training_provider inserts first!
    CREATE TABLE section (
    c_code number NOT NULL,
    sec_code number(10) NOT NULL,
    complete_date date NOT NULL, -- DD-MMM-YY
    offered_by number NOT NULL,
    taught_by number NOT NULL,
    format varchar(255),
    price number(10,2),
    CONSTRAINT section_pk PRIMARY KEY (c_code, sec_code, complete_date), 
    CONSTRAINT sect_offered_by_fk FOREIGN KEY (offered_by) REFERENCES training_provider (comp_id),
    CONSTRAINT sect_taught_by_fk FOREIGN KEY (taught_by) REFERENCES person (pers_id),
    CONSTRAINT sec_course_fk FOREIGN KEY (c_code) REFERENCES course (c_code)
);*/

INSERT INTO section VALUES(1,4,'11-MAY-18',1111,11,'In-class',1500.00);
INSERT INTO section VALUES(2,6,'25-JUN-18',1117,10,'Online',1650.50);
INSERT INTO section VALUES(3,4,'06-MAR-18',1114,9,'In-class',2000);
INSERT INTO section VALUES(4,3,'31-DEC-18',1114,8,'In-class',595.99);
INSERT INTO section VALUES(5,4,'15-NOV-18',1117,7,'Online',700);
INSERT INTO section VALUES(6,2,'05-SEP-18',1111,6,'Online',1500.75);
INSERT INTO section VALUES(7,5,'15-MAY-18',1117,5,'In-class',2000);
INSERT INTO section VALUES(8,6,'17-JUL-18',1111,4,'In-class',925.25);
INSERT INTO section VALUES(9,3,'31-JAN-18',1114,3,'Online',999.99);
INSERT INTO section VALUES(10,4,'19-AUG-18',1111,2,'In-class',1000);
INSERT INTO section VALUES(11,1,'21-MAY-18',1114,1,'Online',1650.75);
 /*Test section*/   
SELECT * 
FROM section;

/*cert: Run training_provider first!!!
    CREATE TABLE cert(
    cert_code NUMBER GENERATED by default on null as IDENTITY PRIMARY KEY,
    cert_name varchar(255) NOT NULL,
    issued_by number(8) NOT NULL,
    tool varchar(255), -- Description of what you're getting the cert in...
    CONSTRAINT cert_issued_by FOREIGN KEY (issued_by) REFERENCES training_provider (comp_id)
);*/
INSERT INTO cert(cert_name,issued_by,tool) VALUES('Oracle Database',1111,'SQL for Oracle DB 12c');
INSERT INTO cert(cert_name,issued_by,tool) VALUES('jCert 1',1117,'Certified Java Programmer');
INSERT INTO cert(cert_name,issued_by,tool) VALUES('CLA',1114,'C Programming Language Certified Associate');
INSERT INTO cert(cert_name,issued_by,tool) VALUES('Oracle Java',1114,'Certified Profession Java SE Programmer');
--INSERT INTO cert(cert_name,issued_by,tool) VALUES('',1117,'');
--INSERT INTO cert(cert_name,issued_by,tool) VALUES('',1111,'');
/*Test cert*/
SELECT *
FROM cert;

/*position_cert: Run cert first!!!
    CREATE TABLE position_cert (
    cert_code number NOT NULL,
    pos_code number NOT NULL,
    prefer varchar(2), -- R: Required, P: Preferred
    CONSTRAINT position_cert_pk PRIMARY KEY (cert_code, pos_code),
    CONSTRAINT pc_cert_fk FOREIGN KEY (cert_code) REFERENCES cert (cert_code),
    CONSTRAINT pc_pos_fk FOREIGN KEY (pos_code) REFERENCES position (pos_code)
);*/
--INSERT
/*Test position_cert*/
SELECT *
FROM position_cert;

/*has_cert: Run person and cert first!
    CREATE TABLE has_cert (
    pers_id number NOT NULL,
    cert_code number NOT NULL,
    CONSTRAINT has_cert_pk PRIMARY KEY (pers_id, cert_code),
    CONSTRAINT pers_cert_fk FOREIGN KEY (pers_id) REFERENCES person (pers_id),
    CONSTRAINT has_cert_fk FOREIGN KEY (cert_code) REFERENCES cert (cert_code));*/
--INSERT
/*Test has_cert*/
SELECT *
FROM has_cert;

/*course_cert: Run cert and course first!
    CREATE TABLE course_cert (
    cert_code number NOT NULL,
    c_code number NOT NULL,
    CONSTRAINT course_cert_pk PRIMARY KEY (cert_code, c_code),
    CONSTRAINT cert_requires_pk FOREIGN KEY (cert_code) REFERENCES cert (cert_code),
    CONSTRAINT course_required_pk FOREIGN KEY (c_code) REFERENCES course (c_code));*/
--INSERT
/*Test course_cert*/
SELECT *
FROM course_cert;

/*provides_skill:
 CREATE TABLE provides_skill (
    ks_code varchar (255) NOT NULL,
    c_code NUMBER NOT NULL,
    CONSTRAINT provide_skill_pk PRIMARY KEY (ks_code, c_code),
    CONSTRAINT skill_provide_fk FOREIGN KEY (ks_code) REFERENCES know_skill(ks_code),
    CONSTRAINT course_provide_fk FOREIGN KEY (c_code) REFERENCES course(c_code));*/
INSERT INTO provides_skill VALUES('Java',1);
INSERT INTO provides_skill VALUES('Java2',2);
INSERT INTO provides_skill VALUES('Java3',3);
INSERT INTO provides_skill VALUES('C1',4);
INSERT INTO provides_skill VALUES('.NET1',5);
INSERT INTO provides_skill VALUES('HTML1',6);
INSERT INTO provides_skill VALUES('HTML2',7);
INSERT INTO provides_skill VALUES('3D Mod 2',8);
INSERT INTO provides_skill VALUES('Angular1',9);
INSERT INTO provides_skill VALUES('Angular2',10);
INSERT INTO provides_skill VALUES('Angular3',11);
INSERT INTO provides_skill VALUES('SQL1',12);
/*Test provides_skill*/
SELECT *
FROM provides_skill;

/*job_category
    CREATE TABLE job_category( 
    cat_code varchar (255) NOT NULL PRIMARY KEY,
    parent_cat_code varchar(255),
    core_skill varchar(255) NOT NULL,
    job_category_title varchar (255) NOT NULL,
    description varchar(255),
    pay_range_high float(15),
    pay_range_low float(15),
    CONSTRAINT cat_nwcet_fk FOREIGN KEY (core_skill) REFERENCES NWCET (nwcet_code),
    CONSTRAINT parent_cat_fk FOREIGN KEY (parent_cat_code) REFERENCES job_category (cat_code)
);*/
INSERT into job_category VALUES ('15-1200',null,'COMPMATH','Computer and Mathematical Occupations','Occupations specializing in computers and math',20000.00,300000.00);--SOC is parent 15-0000 Computer & Math Occupations, no parent
INSERT into job_category VALUES ('15-1250','15-1200','PSE','Software and Web Developers, Programmers, and Testers','Occupations specializing in Software and Web Development',20000.00,300000.00);
INSERT into job_category VALUES ('15-1254','15-1250','WDA','Web Developers','Web Development Occupations',23000.00,100000.00);
INSERT into job_category VALUES ('15-1240','15-1200','DDA','Database and Network Administratiors and Architects','Occupations specializing Databases',50000.00,250000.00);
--INSERT into job_category VALUES ('15-0000',null,'COMPMATH','Computer and Mathematical Occupations','Occupations specializing in computers and math',20000.00,300000.00);
--INSERT into job_category VALUES ('15-0000',null,'COMPMATH','Computer and Mathematical Occupations','Occupations specializing in computers and math',20000.00,300000.00);



/*Position. NOTE: references company and know_skill; be sure to run GICS, NWCET, know_skill, and company
to generate comp_id and ks_code before inserting into position.
    CREATE TABLE position(
    pos_code NUMBER GENERATED by default on null as IDENTITY PRIMARY KEY,
    comp_id number NOT NULL,
    pos_title varchar(255) NOT NULL,
    emp_mode varchar(2) NOT NULL,        --FT: full time, PT: part time
    cat_code varchar (255) NOT NULL,
    pay_rate number(10,2) NOT NULL,
    pay_type varchar(1),        --W: wage, S: salary
    CONSTRAINT pos_company_fk FOREIGN KEY (comp_id) REFERENCES company(comp_id),
    CONSTRAINT pos_category_fk FOREIGN KEY (cat_code) REFERENCES job_category(cat_code)
);    */

--INSERT into position (pos_code,comp_id, pos_title, emp_mode, primary_skill, pay_rate, pay_type)VALUES('',31, 'Junior developer','FT','Java',56000,'S');
INSERT INTO position (comp_id, pos_title, emp_mode, cat_code, pay_rate) VALUES ('1111','junior','ft', '15-1250',56000);
INSERT INTO position (comp_id, pos_title, emp_mode, cat_code, pay_rate) VALUES ('1112','junior','ft', '15-1250',56000);
INSERT INTO position (comp_id, pos_title, emp_mode, cat_code, pay_rate) VALUES ('1113','junior','ft', '15-1250',56000);
INSERT INTO position (comp_id, pos_title, emp_mode, cat_code, pay_rate) VALUES ('1114','junior','ft', '15-1250',56000);

INSERT INTO position (comp_id, pos_title, emp_mode, cat_code, pay_rate) 
    VALUES ('1111','Entry Lev Angular Dev','ft', '15-1254',26000); 
INSERT INTO position (comp_id, pos_title, emp_mode, cat_code, pay_rate) 
    VALUES ('1112','Intermediate Angular Dev','ft', '15-1254',56000);
INSERT INTO position (comp_id, pos_title, emp_mode, cat_code, pay_rate) 
    VALUES ('1113','Senior Angular Dev','ft', '15-1254',96000);
INSERT INTO position (comp_id, pos_title, emp_mode, cat_code, pay_rate) 
    VALUES ('1114','Entry Lev Angular Dev','ft', '15-1254',56000);
--
--
INSERT INTO position (comp_id, pos_title, emp_mode, cat_code, pay_rate, pay_type) 
    VALUES ('1111','Sr JavaDev','ft', '15-1250',56000, 'S');
INSERT INTO position (comp_id, pos_title, emp_mode, cat_code, pay_rate, pay_type) 
    VALUES ('1112','Sr JavaDev','ft', '15-1250',56000, 'S');
INSERT INTO position (comp_id, pos_title, emp_mode, cat_code, pay_rate, pay_type) 
    VALUES ('1113','Sr JavaDev','ft', '15-1250',56000, 'S');
INSERT INTO position (comp_id, pos_title, emp_mode, cat_code, pay_rate, pay_type) 
    VALUES ('1114','jr HTML dev','ft', '15-1254',16000, 'S');

INSERT INTO position (comp_id, pos_title, emp_mode, cat_code, pay_rate, pay_type) 
    VALUES ('1111','Sr JavaDev','ft', '15-1250',56.00, 'W');
INSERT INTO position (comp_id, pos_title, emp_mode, cat_code, pay_rate, pay_type) 
    VALUES ('1112','Sr JavaDev','ft', '15-1250',5.00, 'W');
INSERT INTO position (comp_id, pos_title, emp_mode, cat_code, pay_rate, pay_type) 
    VALUES ('1113','Sr JavaDev','ft', '15-1250',18.0, 'W');
INSERT INTO position (comp_id, pos_title, emp_mode, cat_code, pay_rate, pay_type) 
    VALUES ('1114','jr HTML dev','ft', '15-1254',16.0, 'W');
/*Test position*/
SELECT * 
FROM position;
/*TESTING*/
SELECT comp_name, comp_id, pos_title
FROM position NATURAL JOIN company;
    
/*works:
    CREATE TABLE works(
    pos_code number NOT NULL,
    pers_id number NOT NULL,
    start_date varchar(255) NOT NULL,
    end_date varchar(255),
    CONSTRAINT works_pk PRIMARY KEY (pos_code, pers_id),
    CONSTRAINT pos_start_date_uniq UNIQUE (pos_code, start_date),
    CONSTRAINT pers_works_fk FOREIGN KEY (pers_id) REFERENCES person (pers_id),
    CONSTRAINT pos_works_fk FOREIGN KEY (pos_code) REFERENCES position (pos_code)
);*/
INSERT INTO works VALUES (1,1,'11/06/2010', '');
INSERT INTO works VALUES (2,2,'9/2/2016','3/2/2017');
INSERT INTO works VALUES (3,7,'3/06/2006','');
INSERT INTO works VALUES (4,6,'3/06/2006','3/2/2017');
INSERT INTO works VALUES (5,5,'3/2/2017','7/09/2017');
INSERT INTO works VALUES (6,4,'8/18/2012','');
INSERT INTO works VALUES (7,3,'3/2/2017','');
INSERT INTO works VALUES (8,2,'8/18/2012','');
INSERT INTO works VALUES (9,1,'11/06/2010', '');
INSERT INTO works VALUES (10,2,'9/2/2016','3/2/2017');
INSERT INTO works VALUES (11,7,'3/06/2006','');
INSERT INTO works VALUES (12,6,'3/06/2006','3/2/2017');
INSERT INTO works VALUES (13,5,'3/2/2017','7/09/2017');
INSERT INTO works VALUES (14,4,'8/18/2012','');
INSERT INTO works VALUES (15,3,'3/2/2017','');
INSERT INTO works VALUES (16,2,'8/18/2012','');
/*Test works*/
SELECT * 
FROM works;

/*position_skills:
    CREATE TABLE position_skills (
    ks_code varchar (255) NOT NULL,
    pos_code number NOT NULL,
    prefer char(1) NOT NULL, -- R: Required, P: Preferred
    CONSTRAINT position_pk PRIMARY KEY (ks_code, pos_code),
    CONSTRAINT ps_ks_fk FOREIGN KEY (ks_code) REFERENCES know_skill(ks_code),
    CONSTRAINT ps_pos_fk FOREIGN KEY (pos_code) REFERENCES position(pos_code)*/ 
INSERT INTO position_skills VALUES ('Java2','10','R');
INSERT INTO position_skills VALUES ('Java2','15','R');
INSERT INTO position_skills VALUES ('Angular3','7','R');
INSERT INTO position_skills VALUES ('Angular1','8','P');     I
INSERT INTO position_skills VALUES ('HTML2','12','P');
 /*Test position_skills*/   
SELECT * 
FROM position_skills;

/*has_skill:
    CREATE TABLE has_skill (
    pers_id number NOT NULL,
    ks_code varchar (255) NOT NULL,
    CONSTRAINT has_skill_pk PRIMARY KEY (pers_id, ks_code),
    CONSTRAINT pers_skill_fk FOREIGN KEY (pers_id) REFERENCES person (pers_id),
    CONSTRAINT ks_skill_fk FOREIGN KEY (ks_code) REFERENCES know_skill (ks_code)
);*/
INSERT INTO has_skill VALUES ('1','Java');
INSERT INTO has_skill VALUES ('1','Java2');
INSERT INTO has_skill VALUES ('1','Java3');
INSERT INTO has_skill VALUES ('1','C1');
INSERT INTO has_skill VALUES ('1','.NET1');
INSERT INTO has_skill VALUES ('2','Java');
INSERT INTO has_skill VALUES ('2','Java2');
INSERT INTO has_skill VALUES ('2','Java3');
INSERT INTO has_skill VALUES ('2','C1');
INSERT INTO has_skill VALUES ('2','.NET1');
INSERT INTO has_skill VALUES ('2','SQL1');
INSERT INTO has_skill VALUES ('2','HTML1');
INSERT INTO has_skill VALUES ('2','HTML2');
INSERT INTO has_skill VALUES ('2','Angular1');
INSERT INTO has_skill VALUES ('2','Angular2');
INSERT INTO has_skill VALUES ('3','Java');
INSERT INTO has_skill VALUES ('3','Java2');
INSERT INTO has_skill VALUES ('3','Java3');
INSERT INTO has_skill VALUES ('3','SQL1');
INSERT INTO has_skill VALUES ('3','HTML1');
INSERT INTO has_skill VALUES ('3','HTML2');
INSERT INTO has_skill VALUES ('3','Angular1');
INSERT INTO has_skill VALUES ('3','Angular2');
INSERT INTO has_skill VALUES ('4','Java');
INSERT INTO has_skill VALUES ('4','Java2');
INSERT INTO has_skill VALUES ('4','Java3');
INSERT INTO has_skill VALUES ('4','SQL1');
INSERT INTO has_skill VALUES ('5','HTML1');
INSERT INTO has_skill VALUES ('5','HTML2');
INSERT INTO has_skill VALUES ('5','Angular1');
INSERT INTO has_skill VALUES ('5','Angular2');
INSERT INTO has_skill VALUES ('6','Java');
INSERT INTO has_skill VALUES ('6','3D Mod 2');
INSERT INTO has_skill VALUES ('6','C1');
INSERT INTO has_skill VALUES ('6','SQL1');
INSERT INTO has_skill VALUES ('6','HTML1');
INSERT INTO has_skill VALUES ('6','HTML2');
INSERT INTO has_skill VALUES ('7','Angular1');
INSERT INTO has_skill VALUES ('7','Angular2');
INSERT INTO has_skill VALUES ('7','SQL1');
INSERT INTO has_skill VALUES ('7','HTML1');
INSERT INTO has_skill VALUES ('7','HTML2');
 /*Test has_skill*/   
SELECT * 
FROM has_skill;

/*person_phone_numbers:
    CREATE TABLE person_phone_numbers(
    pers_id number NOT NULL,
    phone varchar(10) NOT NULL,
    phone_number_type varchar(6) NOT NULL, -- Mobile, Home, Work
    CONSTRAINT person_ph_pk PRIMARY KEY (pers_id, phone),
    CONSTRAINT person_ph_fk FOREIGN KEY (pers_id) REFERENCES person(pers_id)
);*/
INSERT INTO person_phone_numbers VALUES (1, '5048493849', 'Mobile');
INSERT INTO person_phone_numbers VALUES (1, '5048734839', 'Home');
INSERT INTO person_phone_numbers VALUES (1, '5048394030', 'Work');
INSERT INTO person_phone_numbers VALUES (2, '5048493849', 'Mobile');
INSERT INTO person_phone_numbers VALUES (2, '5048734839', 'Home');
INSERT INTO person_phone_numbers VALUES (3, '5048394030', 'Work');
INSERT INTO person_phone_numbers VALUES (4, '5048493849', 'Mobile');
INSERT INTO person_phone_numbers VALUES (5, '5048734839', 'Home');
INSERT INTO person_phone_numbers VALUES (5, '5048394030', 'Work');
INSERT INTO person_phone_numbers VALUES (6, '5048493849', 'Mobile');
INSERT INTO person_phone_numbers VALUES (6, '5048734839', 'Home');
INSERT INTO person_phone_numbers VALUES (7, '9856378483', 'Work');
INSERT INTO person_phone_numbers VALUES (7, '9834738284', 'Home');
INSERT INTO person_phone_numbers VALUES (7, '5045003849', 'Work');
 /*Test person_phone_numbers*/   
SELECT * 
FROM person_phone_numbers;

/*prerequisite:
    CREATE TABLE prerequisite (
    c_code number NOT NULL,
    prereq_code number NOT NULL,
    CONSTRAINT prereq_pk PRIMARY KEY (c_code, prereq_code),
    CONSTRAINT c_code_fk FOREIGN KEY (c_code) REFERENCES course (c_code),
    CONSTRAINT prereq_code FOREIGN KEY (prereq_code) REFERENCES course (c_code)
);*/
INSERT INTO prerequisite VALUES (1, 5);
INSERT INTO prerequisite VALUES (9, 7);
INSERT INTO prerequisite VALUES (3, 1);
INSERT INTO prerequisite VALUES (1, 6);
INSERT INTO prerequisite VALUES (1, 7);
INSERT INTO prerequisite VALUES (2, 5);
INSERT INTO prerequisite VALUES (4, 1);
INSERT INTO prerequisite VALUES (2, 4);
 /*Test prerequisite*/   
SELECT * 
FROM prerequisite;

/*company_specialty:
    CREATE TABLE company_specialty (
    comp_id number NOT NULL PRIMARY KEY,
    specialty varchar(8) NOT NULL, 
    CONSTRAINT comp_spec_fk FOREIGN KEY (comp_id) REFERENCES company(comp_id),
    CONSTRAINT specialty_fk FOREIGN KEY (specialty) REFERENCES GICS(primary_sector_code)
);*/
INSERT INTO company_specialty VALUES ('1111','10');
INSERT INTO company_specialty VALUES ('1112','45');
INSERT INTO company_specialty VALUES ('1113','10');
INSERT INTO company_specialty VALUES ('1114','10');
INSERT INTO company_specialty VALUES ('1115','15');
INSERT INTO company_specialty VALUES ('1116','15');  
INSERT INTO company_specialty VALUES ('1117','15');  
INSERT INTO company_specialty VALUES ('1118','10');  
INSERT INTO company_specialty VALUES ('1119','50');  
INSERT INTO company_specialty VALUES ('1120','35');  
 /*Test company_specialty*/   
SELECT * 
FROM company_specialty;

/*takes: Run after person and position!
    CREATE TABLE takes(
    c_code number NOT NULL,
    sec_code number(10) NOT NULL,
    complete_date date NOT NULL,
    pers_id number NOT NULL,
    CONSTRAINT takes_pk PRIMARY KEY (c_code, sec_code, complete_date, pers_id),
    CONSTRAINT sec_takes_fk FOREIGN KEY (c_code, sec_code, complete_date) REFERENCES section (c_code, sec_code, complete_date),
    CONSTRAINT pers_takes_fk FOREIGN KEY (pers_id) REFERENCES person (pers_id));*/
--INSERT
/*Test takes*/
SELECT *
FROM takes;
