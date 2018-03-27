DROP TABLE company;
CREATE TABLE company(
    comp_id number(8) NOT NULL PRIMARY KEY,
    comp_name varchar(255) NOT NULL,
    address1 varchar(255),
    address2 varchar(255),
    city varchar(255),
    state varchar(2), 
    zip varchar(9),
    primary_sector_code varchar(8) NOT NULL, --References GICS
    website varchar(255),
    CONSTRAINT sector_fk FOREIGN KEY (primary_sector_code) REFERENCES GICS(primary_sector_code)
);

DROP TABLE company_specialty;
CREATE TABLE company_specialty (
    comp_id number(8) NOT NULL PRIMARY KEY,
    specialty varchar(8) NOT NULL, 
    CONSTRAINT comp_fk FOREIGN KEY (comp_id) REFERENCES company(comp_id),
    CONSTRAINT specialty_fk FOREIGN KEY (specialty) REFERENCES GICS(primary_sector_code)
);

DROP TABLE position;
CREATE TABLE position(
    pos_code number(10) NOT NULL PRIMARY KEY,
    comp_id number(8) NOT NULL,
    pos_title varchar(255) NOT NULL,
    emp_mode varchar(2) NOT NULL,        --FT: full time, PT: part time
    primary_skill varchar(10) NOT NULL,
    pay_rate number(10,2) NOT NULL,
    pay_type varchar(1),        --W: wage, S: salary
    CONSTRAINT company_fk FOREIGN KEY (comp_id) REFERENCES company(comp_id),
    CONSTRAINT primary_skill_fk FOREIGN KEY (comp_id) REFERENCES know_skill(primary_skill)
);

DROP TABLE position_skills; --instead of requires_ks
CREATE TABLE position_skills (
    ks_code varchar (255) NOT NULL,
    pos_code number(10) NOT NULL,
    prefer varchar(2)
    CONSTRAINT position_pk PRIMARY KEY (ks_code, pos_code),
    CONSTRAINT ks_fk FOREIGN KEY (ks_code) REFERENCES know_skill(ks_code),
    CONSTRAINT pos_fk FOREIGN KEY (pos_code) REFERENCES position(pos_code)
);

DROP TABLE person;   
CREATE TABLE person(
    pers_id number(5) NOT NULL PRIMARY KEY,
    last_name varchar(255),
    first_name varchar(255),
    mi varchar(1),
    address1 varchar(255),
    address2 varchar(255),
    city varchar(255),
    state varchar(2), 
    zip varchar(9),
    email varchar(255),
    gender varchar(2)
    -- Person can have zero or more phone numbers, see person_phone_numbers
);

DROP TABLE person_phone_numbers;
CREATE TABLE person_phone_numbers(
    pers_id number(5) NOT NULL PRIMARY KEY,
    phone varchar(10) NOT NULL,
    phone_number_type varchar(6) -- Mobile, Home, Work
    CONSTRAINT person_ph_pk PRIMARY KEY (pers_id, phone),
    CONSTRAINT person_ph_fk FOREIGN KEY (pers_id) REFERENCES person(pers_id)
);

DROP TABLE section;    
CREATE TABLE section(
    c_code number NOT NULL,
    sec_code number NOT NULL,
    complete_date varchar(9) NOT NULL,
    year number(4),
    offered_by varchar(255),
    format varchar(255),
    price float(10),
    CONSTRAINT section_pk PRIMARY KEY (c_code, sec_code, complete_date), 
    CONSTRAINT offered_by_fk FOREIGN KEY REFERENCES training_provider (comp_id),
    CONSTRAINT course_fk FOREIGN KEY REFERENCES course (c_code)
);
 
DROP TABLE course;    
CREATE TABLE course(
    c_code number(10) NOT NULL PRIMARY KEY,
    title varchar(255) NOT NULL,
    training_level varchar(12),
    description varchar(255),
    status varchar(1) NOT NULL,
    retail_price number(10,2),
    train_type varchar(255) NOT NULL -- Possible values?
);

DROP TABLE prerequisite;
CREATE TABLE prerequisite (
    c_code number(10) NOT NULL,
    prereq_code number(10) NOT NULL,
    CONSTRAINT prereq_pk PRIMARY KEY (c_code, prereq_code),
    CONSTRAINT c_code FOREIGN KEY REFERENCES course (c_code),
    CONSTRAINT prereq_code FOREIGN KEY REFERENCES course (c_code)
);

DROP TABLE cert;    
CREATE TABLE cert(
    cert_code number(10) NOT NULL PRIMARY KEY,
    issued_by number(8),
    tool varchar(255),
    CONSTRAINT issued_by FOREIGN KEY issued_by REFERENCES training_provider (comp_id)
);

DROP TABLE position_cert;
CREATE TABLE position_cert (
    cert_code number(10) NOT NULL PRIMARY KEY,
    pos_code number(10) NOT NULL PRIMARY KEY,
    prefer varchar(2),
    CONSTRAINT position_cert PRIMARY KEY (cert_code, pos_code) 
);

DROP TABLE training_provider;
CREATE TABLE training_provider(
    comp_id number(8) NOT NULL PRIMARY KEY,
    train_type varchar(255)
    CONSTRAINT comp_fk FOREIGN KEY comp_id REFERENCES company (comp_id)
);

DROP TABLE know_skill;    
CREATE TABLE know_skill(
    ks_code varchar (255) NOT NULL PRIMARY KEY,
    ks_title varchar(255) NOT NULL,
    ks_description varchar(255),
    training_level varchar(255) NOT NULL -- Beginner, Intermediate, Advanced
);

DROP TABLE NWCET;  -- Talk to Tu, info only in PDF   
CREATE TABLE NWCET(
    cat_code varchar (255) NOT NULL PRIMARY KEY,
    description varchar (255)
);

DROP TABLE job_cat;    
CREATE TABLE job_cat(
    cat_code varchar (255) NOT NULL PRIMARY KEY,
    title varchar (255),
    description varchar(255),
    pay_range_high float(15),
    pay_range_low float(15),
    ks_code varchar (255)
);

DROP TABLE takes;
CREATE TABLE takes(
    c_code varchar (255)NOT NULL,
    sec_code varchar (255)NOT NULL,
    PRIMARY KEY(c_code, sec_code)
);
    
/*Added attribute "job_title" to this table*/	
DROP TABLE works;
CREATE TABLE works(
    job_title varchar(255),
    start_date varchar(255),
    end_date varchar(255),
    PRIMARY KEY (start_date, end_date)
    );
    
DROP TABLE takes;    
CREATE TABLE takes(
    c_code varchar (255)NOT NULL,
    sec_code varchar (255)NOT NULL,
    PRIMARY KEY(c_code, sec_code)
);
    
/*Added attribute "job_title" to this table*/	
DROP TABLE works;
CREATE TABLE works(
    job_title varchar(255),
	start_date varchar(255),
    end_date varchar(255),
    PRIMARY KEY (start_date, end_date)
);
    
DROP TABLE prerequisite;
CREATE TABLE prerequisite(
    c_code varchar (255) NOT NULL,
    requires_code varchar(255) NOT NULL,
    PRIMARY KEY (c_code, requires_code)
);

CREATE TABLE GICS (
    primary_sector_code varchar(8) NOT NULL PRIMARY KEY,
    code_name varchar(255),
    code_description varchar(255),
    parent_code varchar(8) NOT NULL
);