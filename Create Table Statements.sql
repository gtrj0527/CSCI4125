DROP TABLE company;
CREATE TABLE company(
    comp_id number(8) NOT NULL PRIMARY KEY,
    comp_name varchar(255) NOT NULL,
    street_num number(20),
    street varchar(255),
    city varchar(255),
    state varchar(2), 
    zip number(9),
    primary_sector_code varchar(8), --References GICS
    specialty varchar(255),
    website varchar(255)
);

DROP TABLE position;
CREATE TABLE position(
    pos_code number(10) NOT NULL PRIMARY KEY,
    comp_id number(8) NOT NULL,
    primary_skill varchar (10),
    emp_mode varchar(2),        --FT: full time, PT: part time
    ks_code varchar(10),
    pay_rate number(10,2),
    pay_type varchar(1)        --W: wage, S: salary
);


DROP TABLE person;   
CREATE TABLE person(
    pers_id number(5) NOT NULL PRIMARY KEY,
    last_name varchar(255),
    first_name varchar(255),
    mi varchar(1),
    street_num number(20),
    street varchar(255),
    city varchar(255),
    state varchar(2), 
    zip number(9),
    email varchar(255),
    gender varchar(2),
    phone number(10)
);

DROP TABLE section;    
CREATE TABLE section(
    c_code number NOT NULL,
    sec_code number NOT NULL,
    complete_date varchar(9),
    year number(4),
    offered_by varchar(255),
    format varchar(255),
    price float(10)
);
 
DROP TABLE course;    
CREATE TABLE course(
    c_code number(10) NOT NULL PRIMARY KEY,
    title varchar(255),
    training_level varchar(12),
    description varchar(255),
    status varchar(10),
    retail_price number(10,2),
    train_type varchar(255)
);

DROP TABLE cert;    
CREATE TABLE cert(
    ks_code number(10) NOT NULL PRIMARY KEY,
    issued_by varchar(255),
    tool varchar(255)
);

DROP TABLE training_provider;
CREATE TABLE training_provider(
    prov_id varchar(10) NOT NULL PRIMARY KEY,
    train_type varchar(255)
);

DROP TABLE know_skill;    
CREATE TABLE know_skill(
    ks_code varchar (255)NOT NULL PRIMARY KEY,
    tool varchar(255),
    description varchar(255),
    training_level varchar(255)
);
    
DROP TABLE soc;    
CREATE TABLE soc(
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

DROP TABLE requires_cert;    
CREATE TABLE requires_cert(
    prefer varchar (255)
    );
    
DROP TABLE requires_ks;
CREATE TABLE requires_ks(
    prefer varchar (255)
    );
    
DROP TABLE takes;
CREATE TABLE takes(
    c_code varchar (255)NOT NULL,
    sec_code varchar (255)NOT NULL,
    PRIMARY KEY(c_code, sec_code)
    );
    
/*Added attribute "job_title" to this table*/
/*Added attribute "pos_code" to works -jtm */
/*Added attribute "pers_id" to works - jtm*/
DROP TABLE works;
CREATE TABLE works(
    pos_code number (10),
    pers_id number(5),
    job_title varchar(255),
	start_date varchar(255),
    end_date varchar(255),
    --PRIMARY KEY (start_date, end_date)  --CANNOT QUERY end_date IS NULL if end_date is primary key! -jtm
    PRIMARY KEY (start_date, pos_code)
    
    );
    
DROP TABLE requires_cert;    
CREATE TABLE requires_cert(
    prefer varchar (255)
);

DROP TABLE requires_ks;    
CREATE TABLE requires_ks(
    prefer varchar (255)
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
/*
 * NEED TO ADD GICS TABLE!!!!!!!
 */
