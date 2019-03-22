clear screen;

drop table Account_Information cascade constraints;

create table Account_Information
(
id  INT Not Null,
Br_Name varchar2(20),
H_Name varchar2(20),
Address varchar2(20),
Phn varchar2(20),
Nid varchar2(20),
Blnc number(20),
primary key(id)
);

