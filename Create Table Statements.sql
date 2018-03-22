CREATE TABLE company(
    comp_id int NOT NULL PRIMARY KEY,
    comp_name varchar(255) NOT NULL,
    street_num int(20),
    street varchar(255),
    city varchar(255),
    state varchar(2), 
    zip int(9),
    industry varchar(255),
    specialty varchar(255),
    website varchar(255)
    );
/*Need to decide on what types each of the empty ones will be.*/
CREATE TABLE position(
    pos_code int NOT NULL PRIMARY KEY,
    emp_mode int,
    {ks_code} varchar,
    pay_rate int,
    pay_type varchar,
    pers_id int NOT NULL
    );
    
CREATE TABLE person(
    pers_id int(5) NOT NULL PRIMARY KEY,
    last_name varchar(255),
    first_name varchar(255),
    mi varchar (1),
    street_num int(20),
    street varchar(255),
    city varchar(255),
    state varchar(2), 
    zip int(9),
    email varchar(255),
    gender varchar(2),
    {phone}
    );
    
CREATE TABLE section(
    c_code int NOT NULL,
    sec_code int NOT NULL,
    complete_date varchar(9),
    year int(4),
    offered_by varchar(255),
    format varchar(255),
    price float(10)
    );
    
CREATE TABLE course(
    c_code int NOT NULL PRIMARY KEY,
    title varchar(255),
    level varchar(10),
    description varchar,
    status varchar,
    retail_price float(10),
    train_type varchar
    );
    
CREATE TABLE cert(
    ks_code int NOT NULL PRIMARY KEY,
    issued_by varchar,
    tool varchar
    );

CREATE TABLE training_provider(
    prov_id varchar NOT NULL PRIMARY KEY,
    train_type varchar
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
    {ks_code}
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
