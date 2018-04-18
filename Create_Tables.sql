DROP TABLE works;
DROP TABLE takes;
DROP TABLE course_cert;
DROP TABLE has_cert;
DROP TABLE has_skill;
DROP TABLE position_cert;
DROP TABLE cert;    
DROP TABLE section;    
DROP TABLE position_skills;
DROP TABLE position;
DROP TABLE core_skill;
DROP TABLE job_category;    
DROP TABLE provides_skill;
DROP TABLE know_skill;    
DROP TABLE NWCET;
DROP TABLE training_provider;
DROP TABLE company_specialty;
DROP TABLE company;
DROP TABLE prerequisite;
DROP TABLE course;    
DROP TABLE person_phone_numbers;
DROP TABLE person;   
    
CREATE TABLE person (
    pers_id NUMBER GENERATED by default on null as IDENTITY PRIMARY KEY,
    last_name varchar(255) NOT NULL,
    first_name varchar(255) NOT NULL,
    mi varchar(1),
    address1 varchar(255) NOT NULL,
    address2 varchar(255),
    zip varchar(5) NOT NULL,
    email varchar(255),
    gender varchar(2),
    CONSTRAINT person_zip_fk FOREIGN KEY (zip) REFERENCES zip_code (zip)
    -- Person can have zero or more phone numbers, see person_phone_numbers
);

CREATE TABLE person_phone_numbers(
    pers_id number NOT NULL,
    phone varchar(10) NOT NULL,
    phone_number_type varchar(6) NOT NULL, -- Mobile, Home, Work
    CONSTRAINT person_ph_pk PRIMARY KEY (pers_id, phone),
    CONSTRAINT person_ph_fk FOREIGN KEY (pers_id) REFERENCES person(pers_id)
);
 
CREATE TABLE course(
    c_code NUMBER GENERATED by default on null as IDENTITY PRIMARY KEY,
    title varchar(255) NOT NULL,
    training_level varchar(12), -- Beginner, Intermediate, Advanced
    description varchar(255),
    status varchar(1) NOT NULL, -- A: Active, E: Expired
    retail_price number(10,2),
    train_type varchar(255) NOT NULL -- University, Training Company, Non-Profit
);

CREATE TABLE prerequisite (
    c_code number NOT NULL,
    prereq_code number NOT NULL,
    CONSTRAINT prereq_pk PRIMARY KEY (c_code, prereq_code),
    CONSTRAINT c_code_fk FOREIGN KEY (c_code) REFERENCES course (c_code),
    CONSTRAINT prereq_code FOREIGN KEY (prereq_code) REFERENCES course (c_code)
);

CREATE TABLE company(
    comp_id NUMBER GENERATED ALWAYS AS IDENTITY START WITH 1111 NOT NULL PRIMARY KEY,
    comp_name varchar(255) NOT NULL,
    address1 varchar(255) NOT NULL,
    address2 varchar(255),
    zip varchar(5) NOT NULL,
    primary_sector_code varchar(8) NOT NULL, --References GICS
    phone varchar(10),
    website varchar(255),
    CONSTRAINT sector_fk FOREIGN KEY (primary_sector_code) REFERENCES GICS(primary_sector_code),
    CONSTRAINT company_zip_fk FOREIGN KEY (zip) REFERENCES zip_code(zip)
);

CREATE TABLE company_specialty (
    comp_id number NOT NULL,
    specialty varchar(8) NOT NULL, 
    CONSTRAINT comp_spec_pk PRIMARY KEY (comp_id, specialty),
    CONSTRAINT comp_spec_fk FOREIGN KEY (comp_id) REFERENCES company(comp_id),
    CONSTRAINT specialty_fk FOREIGN KEY (specialty) REFERENCES GICS(primary_sector_code)
);

CREATE TABLE training_provider(
    comp_id number NOT NULL PRIMARY KEY,
    train_type varchar(255), -- University, Training Company, Non-Profit
    CONSTRAINT provider_comp_fk FOREIGN KEY (comp_id) REFERENCES company (comp_id)
);

CREATE TABLE NWCET(
    nwcet_code varchar (255) NOT NULL PRIMARY KEY,
    parent_nwcet_code varchar(255),
    nwcet_title varchar(255) NOT NULL,
    description varchar (255),
    CONSTRAINT parent_nwcet_fk FOREIGN KEY (parent_nwcet_code) REFERENCES NWCET (nwcet_code)
);

CREATE TABLE know_skill(
    ks_code varchar (255) NOT NULL PRIMARY KEY,
    nwcet_code varchar (255) NOT NULL,
    ks_title varchar(255) NOT NULL,
    description varchar(255),
    training_level varchar(255) NOT NULL, -- Beginner, Intermediate, Advanced
    CONSTRAINT ks_nwcet_fk FOREIGN KEY (nwcet_code) REFERENCES NWCET (nwcet_code)
);

CREATE TABLE provides_skill (
    ks_code varchar (255) NOT NULL,
    c_code NUMBER NOT NULL,
    CONSTRAINT provide_skill_pk PRIMARY KEY (ks_code, c_code),
    CONSTRAINT skill_provide_fk FOREIGN KEY (ks_code) REFERENCES know_skill(ks_code),
    CONSTRAINT course_provide_fk FOREIGN KEY (c_code) REFERENCES course(c_code)
);

CREATE TABLE job_category( -- AKA SOC
    cat_code varchar (255) NOT NULL PRIMARY KEY,
    parent_cat_code varchar(255),
    core_skill varchar(255) NOT NULL,
    job_category_title varchar (255) NOT NULL,
    description varchar(255),
    pay_range_high float(15),
    pay_range_low float(15),
    CONSTRAINT cat_nwcet_fk FOREIGN KEY (core_skill) REFERENCES NWCET (nwcet_code),
    CONSTRAINT parent_cat_fk FOREIGN KEY (parent_cat_code) REFERENCES job_category (cat_code)
);

CREATE TABLE core_skill (
    nwcet_code varchar (255) NOT NULL,
    cat_code varchar (255) NOT NULL,
    CONSTRAINT core_skill_pk PRIMARY KEY (nwcet_code, cat_code),
    CONSTRAINT core_skill_nwcetcode_fk FOREIGN KEY (nwcet_code) REFERENCES NWCET (nwcet_code),
    CONSTRAINT core_skill_catcode_fk FOREIGN KEY (cat_code) REFERENCES job_category(cat_code)
);

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
);

CREATE TABLE position_skills (
    ks_code varchar (255) NOT NULL,
    pos_code number NOT NULL,
    prefer char(1) NOT NULL, -- R: Required, P: Preferred
    CONSTRAINT position_pk PRIMARY KEY (ks_code, pos_code),
    CONSTRAINT ps_ks_fk FOREIGN KEY (ks_code) REFERENCES know_skill(ks_code),
    CONSTRAINT ps_pos_fk FOREIGN KEY (pos_code) REFERENCES position(pos_code)
);

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
);

CREATE TABLE cert(
    cert_code NUMBER GENERATED by default on null as IDENTITY PRIMARY KEY,
    cert_name varchar(255) NOT NULL,
    issued_by number(8) NOT NULL,
    tool varchar(255), -- Description of what you're getting the cert in...
    CONSTRAINT cert_issued_by FOREIGN KEY (issued_by) REFERENCES training_provider (comp_id)
);

CREATE TABLE position_cert (
    cert_code number NOT NULL,
    pos_code number NOT NULL,
    prefer varchar(2), -- R: Required, P: Preferred
    CONSTRAINT position_cert_pk PRIMARY KEY (cert_code, pos_code),
    CONSTRAINT pc_cert_fk FOREIGN KEY (cert_code) REFERENCES cert (cert_code),
    CONSTRAINT pc_pos_fk FOREIGN KEY (pos_code) REFERENCES position (pos_code)
);

CREATE TABLE has_skill (
    pers_id number NOT NULL,
    ks_code varchar (255) NOT NULL,
    CONSTRAINT has_skill_pk PRIMARY KEY (pers_id, ks_code),
    CONSTRAINT pers_skill_fk FOREIGN KEY (pers_id) REFERENCES person (pers_id),
    CONSTRAINT ks_skill_fk FOREIGN KEY (ks_code) REFERENCES know_skill (ks_code)
);

CREATE TABLE has_cert (
    pers_id number NOT NULL,
    cert_code number NOT NULL,
    CONSTRAINT has_cert_pk PRIMARY KEY (pers_id, cert_code),
    CONSTRAINT pers_cert_fk FOREIGN KEY (pers_id) REFERENCES person (pers_id),
    CONSTRAINT has_cert_fk FOREIGN KEY (cert_code) REFERENCES cert (cert_code)
);

CREATE TABLE course_cert (
    cert_code number NOT NULL,
    c_code number NOT NULL,
    CONSTRAINT course_cert_pk PRIMARY KEY (cert_code, c_code),
    CONSTRAINT cert_requires_pk FOREIGN KEY (cert_code) REFERENCES cert (cert_code),
    CONSTRAINT course_required_pk FOREIGN KEY (c_code) REFERENCES course (c_code)
);

CREATE TABLE takes(
    c_code number NOT NULL,
    sec_code number(10) NOT NULL,
    complete_date date NOT NULL,
    pers_id number NOT NULL,
    CONSTRAINT takes_pk PRIMARY KEY (c_code, sec_code, complete_date, pers_id),
    CONSTRAINT sec_takes_fk FOREIGN KEY (c_code, sec_code, complete_date) REFERENCES section (c_code, sec_code, complete_date),
    CONSTRAINT pers_takes_fk FOREIGN KEY (pers_id) REFERENCES person (pers_id)
);
    
CREATE TABLE works(
    pos_code number NOT NULL,
    pers_id number NOT NULL,
    start_date varchar(255) NOT NULL,
    end_date varchar(255),
    CONSTRAINT works_pk PRIMARY KEY (pos_code, pers_id),
    CONSTRAINT pos_start_date_uniq UNIQUE (pos_code, start_date),
    CONSTRAINT pers_works_fk FOREIGN KEY (pers_id) REFERENCES person (pers_id),
    CONSTRAINT pos_works_fk FOREIGN KEY (pos_code) REFERENCES position (pos_code)
);
