
drop database link site_link;

create database link site_link
 connect to system identified by "123456"
 using '(DESCRIPTION =
       (ADDRESS_LIST =
         (ADDRESS = (PROTOCOL = TCP)
		 (HOST = 192.168.0.104)
		 (PORT = 1522))
       )
       (CONNECT_DATA =
         (SID = XE)
       )
     )'
;  
