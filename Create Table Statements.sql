DROP TABLE company;
CREATE TABLE company(
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

DROP TABLE company_specialty;
CREATE TABLE company_specialty (
    comp_id number(8) NOT NULL PRIMARY KEY,
    specialty varchar(8) NOT NULL, 
    CONSTRAINT comp_fk FOREIGN KEY (comp_id) REFERENCES company(comp_id),
    CONSTRAINT specialty_fk FOREIGN KEY (specialty) REFERENCES GICS(primary_sector_code)
);

DROP TABLE position;
CREATE TABLE position(
    pos_code number(10) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    comp_id number(8) NOT NULL,
    pos_title varchar(255) NOT NULL,
    emp_mode varchar(2) NOT NULL,        --FT: full time, PT: part time
    primary_skill varchar(10) NOT NULL,
    pay_rate number(10,2) NOT NULL,
    pay_type varchar(1),        --W: wage, S: salary
    CONSTRAINT company_fk FOREIGN KEY (comp_id) REFERENCES company(comp_id),
    CONSTRAINT primary_skill_fk FOREIGN KEY (primary_skill) REFERENCES know_skill(ks_code)
);

DROP TABLE position_skills; --instead of requires_ks
CREATE TABLE position_skills (
    ks_code varchar (255) NOT NULL,
    pos_code number(10) NOT NULL,
    prefer char(1) NOT NULL, -- R: Required, P: Preferred
    CONSTRAINT position_pk PRIMARY KEY (ks_code, pos_code),
    CONSTRAINT ks_fk FOREIGN KEY (ks_code) REFERENCES know_skill(ks_code),
    CONSTRAINT pos_fk FOREIGN KEY (pos_code) REFERENCES position(pos_code)
);

DROP TABLE person;   
CREATE TABLE person(
    pers_id number(5) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    last_name varchar(255) NOT NULL,
    first_name varchar(255) NOT NULL,
    mi varchar(1),
    address1 varchar(255) NOT NULL,
    address2 varchar(255),
    city varchar(255) NOT NULL,
    state varchar(2) NOT NULL, 
    zip varchar(9) NOT NULL,
    email varchar(255),
    gender varchar(2)
    -- Person can have zero or more phone numbers, see person_phone_numbers
);

DROP TABLE person_phone_numbers;
CREATE TABLE person_phone_numbers(
    pers_id number(5) NOT NULL,
    phone varchar(10) NOT NULL,
    phone_number_type varchar(6) NOT NULL, -- Mobile, Home, Work
    CONSTRAINT person_ph_pk PRIMARY KEY (pers_id, phone),
    CONSTRAINT person_ph_fk FOREIGN KEY (pers_id) REFERENCES person(pers_id)
);

DROP TABLE section;    
CREATE TABLE section(
    c_code number(10) NOT NULL,
    sec_code number(10) NOT NULL,
    complete_date date NOT NULL, -- YYYY-MM-DD
    --year number(4),
    offered_by varchar(255) NOT NULL,
    format varchar(255),
    CONSTRAINT section_pk PRIMARY KEY (c_code, sec_code, complete_date), 
    CONSTRAINT offered_by_fk FOREIGN KEY REFERENCES training_provider (comp_id),
    CONSTRAINT course_fk FOREIGN KEY REFERENCES course (c_code)
);
 
DROP TABLE course;    
CREATE TABLE course(
    c_code number(10) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    title varchar(255) NOT NULL,
    training_level varchar(12), -- Beginner, Intermediate, Advanced
    description varchar(255),
    status varchar(1) NOT NULL, -- A: Active, E: Expired
    retail_price number(10,2),
    train_type varchar(255) NOT NULL -- University, Training Company, Non-Profit
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
    cert_code number(10) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    cert_name varchar(255) NOT NULL,
    issued_by number(8) NOT NULL,
    tool varchar(255), -- Description of what you're getting the cert in...
    CONSTRAINT issued_by FOREIGN KEY issued_by REFERENCES training_provider (comp_id)
);

DROP TABLE position_cert;
CREATE TABLE position_cert (
    cert_code number(10) NOT NULL,
    pos_code number(10) NOT NULL,
    prefer varchar(2), -- R: Required, P: Preferred
    CONSTRAINT position_cert PRIMARY KEY (cert_code, pos_code),
    CONSTRAINT cert_fk FOREIGN KEY cert_code REFERENCES cert (cert_code),
    CONSTRAINT pos_fk FOREIGN KEY pos_code REFERENCES position (pos_code)
);

DROP TABLE training_provider;
CREATE TABLE training_provider(
    comp_id number(8) NOT NULL PRIMARY KEY,
    train_type varchar(255), -- University, Training Company, Non-Profit
    CONSTRAINT comp_fk FOREIGN KEY comp_id REFERENCES company (comp_id)
);

DROP TABLE know_skill;    
CREATE TABLE know_skill(
    ks_code varchar (255) NOT NULL PRIMARY KEY,
    nwcet_code varchar (255) NOT NULL,
    ks_title varchar(255) NOT NULL,
    ks_description varchar(255),
    training_level varchar(255) NOT NULL, -- Beginner, Intermediate, Advanced
    CONSTRAINT ks_nwcet_fk FOREIGN KEY nwcet_code REFERENCES NWCET (nwcet_code)
);

DROP TABLE has_skill;
CREATE TABLE has_skill (
    pers_id number(5) NOT NULL,
    ks_code varchar (255) NOT NULL,
    CONSTRAINT has_skill_pk PRIMARY KEY (pers_id, ks_code),
    CONSTRAINT pers_skill_fk FOREIGN KEY pers_id REFERENCES person (pers_id),
    CONSTRAINT ks_skill_fk FOREIGN KEY ks_code REFERENCES know_skill (ks_code)
);

DROP TABLE has_cert;
CREATE TABLE has_cert (
    pers_id number(5) NOT NULL,
    cert_code varchar (255) NOT NULL,
    CONSTRAINT has_cert_pk PRIMARY KEY (pers_id, cert_code),
    CONSTRAINT pers_cert_fk FOREIGN KEY pers_id REFERENCES person (pers_id),
    CONSTRAINT has_cert_fk FOREIGN KEY cert_code REFERENCES cert (cert_code)
);

DROP TABLE course_cert;
CREATE TABLE course_cert (
    cert_code number(10) NOT NULL,
    c_code number(10) NOT NULL,
    CONSTRAINT course_cert_pk PRIMARY KEY (cert_code, c_code),
    CONSTRAINT cert_requires_pk FOREIGN KEY cert_code REFERENCES cert (cert_code),
    CONSTRAINT course_required_pk FOREIGN KEY c_code REFERENCES course (c_code)
);

DROP TABLE NWCET;  -- Manually entering
CREATE TABLE NWCET(
    nwcet_code varchar (255) NOT NULL PRIMARY KEY,
    parent_nwcet_code varchar(255),
    nwcet_title varchar(255) NOT NULL,
    description varchar (255),
    CONSTRAINT parent_nwcet_fk FOREIGN KEY parent_nwcet_code REFERENCES NWCET (nwcet_code)
);

DROP TABLE job_category;    
CREATE TABLE job_category( -- AKA SOC
    cat_code varchar (255) NOT NULL PRIMARY KEY,
    parent_cat_code varchar(255),
    core_skill varchar(255) NOT NULL,
    job_category_title varchar (255) NOT NULL,
    description varchar(255),
    pay_range_high float(15),
    pay_range_low float(15),
    CONSTRAINT cat_nwcet_fk FOREIGN KEY core_skill REFERENCES NWCET (nwcet_code),
    CONSTRAINT parent_cat_fk FOREIGN KEY parent_cat_code REFERENCES job_category (cat_code)
);

DROP TABLE takes;
CREATE TABLE takes(
    c_code number(10) NOT NULL,
    sec_code number(10) NOT NULL,
    complete_date varchar(9) NOT NULL,
    pers_id number(5) NOT NULL,
    CONSTRAINT takes_pk PRIMARY KEY (c_code, sec_code, complete_date, pers_id),
    CONSTRAINT sec_takes_fk FOREIGN KEY (c_code, sec_code, complete_date) REFERENCES section (c_code, sec_code, complete_date),
    CONSTRAINT pers_takes_fk FOREIGN KEY pers_id REFERENCES person (pers_id)
);
    
DROP TABLE works;
CREATE TABLE works(
    pos_code number(10) NOT NULL,
    pers_id number(5) NOT NULL,
    start_date varchar(255) NOT NULL,
    end_date varchar(255),
    CONSTRAINT works_pk PRIMARY KEY (pos_code, pers_id),
    CONSTRAINT pos_start_date_uniq UNIQUE (pos_code, start_date),
    CONSTRAINT pers_works_fk FOREIGN KEY pers_id REFERENCES person (pers_id),
    CONSTRAINT pos_works_fk FOREIGN KEY pos_code REFERENCES position (pos_code)
);
 
DROP TABLE GICS;
CREATE TABLE GICS (
    primary_sector_code varchar(8) NOT NULL PRIMARY KEY,
    code_name varchar(255),
    code_description varchar(255),
    parent_sector_code varchar(8),
    CONSTRAINT parent_GICS_sector_fk FOREIGN KEY parent_sector_code REFERENCES GICS (primary_sector_code)
);
