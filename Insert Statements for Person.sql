/*
 *CREATE TABLE person(
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
 */
DELETE FROM person;
--INSERT INTO person VALUES('10001','Tu','Shengru',' ',123,'TU','Tu','TU',70121,'stu@gmail.com','Tu',5041236987);
INSERT into person VALUES(10001, 'Tu','Shengru',null,123,'Washington Rd','New Orleans','LA',70110,'stu@gmail.com','M',5043214567);
INSERT into person VALUES(10002, 'Benavides', 'Ricardo', 'M', 564, 'Canal', 'New Orleans', 'LA', 70123, 'ricardo.benavides@hotmail.com', 'M', 5045489723);
INSERT into person VALUES(10003, 'Chung', 'Connie', ' ', 123, 'Carlisle','New Orleans', 'LA', 70130, 'connie.chung@aol.com', 'F', 5049564785);
INSERT into person VALUES(10004, 'Dumas', 'Alexandra', 'J', 3259, 'Manhattan','Gretna', 'LA', 70124, 'alexandra.dumas@gmail.com', 'F', 5048725695);
INSERT into person VALUES(10005, 'Eccleston', 'Christoper', 'J', 5148, 'Napolean', 'New Orleans', 'LA', 70110, 'chris.eccleston@outlook.com', 'M', 5045697845);


select last_name
from person;