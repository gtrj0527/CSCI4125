drop table company;
CREATE TABLE company(
    comp_id number NOT NULL PRIMARY KEY,
    comp_name varchar(255) NOT NULL,
    street_num number(20),
    street varchar(255),
    city varchar(255),
    state varchar(2), 
    zip number(9),
    industry varchar(255),
    specialty varchar(255),
    website varchar(255)
    );
/*Need to decide on what types each of the empty ones will be.*/
CREATE TABLE position(
    pos_code number(10) NOT NULL PRIMARY KEY,
    emp_mode number(10),
    ks_code varchar(10),
    pay_rate number(10),
    pay_type varchar(10),
    pers_id number(10) NOT NULL
    );
    
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
    phone number(9)
);
    
CREATE TABLE section(
    c_code number NOT NULL,
    sec_code number NOT NULL,
    complete_date varchar(9),
    year number(4),
    offered_by varchar(255),
    format varchar(255),
    price float(10)
    );
    
CREATE TABLE course(
    c_code number(10) NOT NULL PRIMARY KEY,
    title varchar(255),
    training_level varchar(10),
    description varchar(255),
    status varchar(10),
    retail_price number(10,2),
    train_type varchar(255)
    );
    
CREATE TABLE cert(
    ks_code number(10) NOT NULL PRIMARY KEY,
    issued_by varchar(255),
    tool varchar(255)
    );

CREATE TABLE training_provider(
    prov_id varchar(10) NOT NULL PRIMARY KEY,
    train_type varchar(255)
    );
    
CREATE TABLE know_skill(
    ks_code varchar NOT NULL PRIMARY KEY,
    tool varchar,
    description varchar,
    level varchar
    );
    
CREATE TABLE soc(
    cat_code varchar NOT NULL PRIMARY KEY,
    description varchar
    );
    
CREATE TABLE job_cat(
    cat_code varchar NOT NULL PRIMARY KEY,
    title varchar,
    description varchar,
    pay_range_high float(15),
    pay_range_low float(15),
    ks_code varchar
    );
    
CREATE TABLE requires_cert(
    prefer varchar
    );
    
CREATE TABLE requires_ks(
    prefer varchar
    );
    
CREATE TABLE takes(
    c_code varchar NOT NULL PRIMARY KEY,
    sec_code varchar NOT NULL PRIMARY KEY
    );
    
CREATE TABLE works(
    start_date varchar(9) PRIMARY KEY,
    end_date varchar(9) PRIMARY KEY
    );
    

CREATE TABLE prerequisite(
    c_code varchar NOT NULL PRIMARY KEY,
    requires_code varchar NOT NULL PRIMARY KEY
    );
