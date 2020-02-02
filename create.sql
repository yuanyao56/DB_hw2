--Fangzheng Guo, Yuan Yao

--drop table if exists
declare
    c int;
begin
    select count(*) into c from user_tables where table_name = upper('TECH_PERSONNEL');
    if c = 1 then
        execute immediate 'drop table TECH_PERSONNEL cascade constraints';
    end if;
end;

declare
    c int;
begin
    select count(*) into c from user_tables where table_name = upper('USERS');
    if c = 1 then
        execute immediate 'drop table USERS cascade constraints';
    end if;
end;

declare
    c int;
begin
    select count(*) into c from user_tables where table_name = upper('USER_OFFICE');
    if c = 1 then
        execute immediate 'drop table USER_OFFICE cascade constraints';
    end if;
end;

declare
    c int;
begin
    select count(*) into c from user_tables where table_name = upper('CATEGORIES');
    if c = 1 then
        execute immediate 'drop table CATEGORIES cascade constraints';
    end if;
end;

declare
    c int;
begin
    select count(*) into c from user_tables where table_name = upper('INVENTORY');
    if c = 1 then
        execute immediate 'drop table INVENTORY cascade constraints';
    end if;
end;

declare
    c int;
begin
    select count(*) into c from user_tables where table_name = upper('LOCATIONS');
    if c = 1 then
        execute immediate 'drop table LOCATIONS cascade constraints';
    end if;
end;

declare
    c int;
begin
    select count(*) into c from user_tables where table_name = upper('TICKETS');
    if c = 1 then
        execute immediate 'drop table TICKETS cascade constraints';
    end if;
end;

declare
    c int;
begin
    select count(*) into c from user_tables where table_name = upper('ASSIGNMENT');
    if c = 1 then
        execute immediate 'drop table ASSIGNMENT cascade constraints';
    end if;
end;
commit;

--create tables
create table TECH_PERSONNEL
(
    pplSoft      Integer primary key deferrable,
    fname        char(20)    not null initially immediate deferrable,
    lname        char(20)    not null initially immediate deferrable,
    pittID       char(20)     not null initially immediate deferrable,
    expertise    char(20)    not null initially immediate deferrable,
    office_phone varchar(15) not null initially immediate deferrable
        check (regexp_like(office_phone, '^[0-9]{3}-[0-9]{3}-[0-9]{4}$'))

);

create table USERS
(
    pplSoft      Integer primary key deferrable,
    fname        char(20) not null initially immediate deferrable,
    lname        char(20) not null initially immediate deferrable,
    pittID       char(20)  not null initially immediate deferrable,
    office_phone varchar(15)
        check (regexp_like(office_phone, '^[0-9]{3}-[0-9]{3}-[0-9]{4}$'))
);

create table USER_OFFICE
(
    office_no INTEGER primary key deferrable,
    building char(30) not null initially immediate deferrable
);

create table CATEGORIES
(
    category_id INTEGER primary key deferrable,
    category    char(100) not null initially immediate deferrable,
    description char(100)
);

create table LOCATIONS
(
    location_id INTEGER primary key deferrable,
    location     char(50) not null initially immediate deferrable,
    building    char(30) not null initially immediate deferrable,
    notes       char(100)
);

create table INVENTORY
(
    machine_name char(30) not null initially immediate deferrable,
    IP           char(30),
    network_port  char(30),
    MACADDR      char(30)
        check (MACADDR like '%%:%%:%%:%%:%%:%%')
        primary key deferrable,
    location_id     INTEGER,
    FOREIGN KEY (location_id) references LOCATIONS (location_id)
        deferrable initially deferred
);

create table TICKETS
(
    ticket_number     INTEGER primary key deferrable,
    owner_pplSoft   INTEGER,
    FOREIGN KEY (owner_pplSoft) references USERS (pplSoft)
        deferrable initially deferred,
    date_submitted date not null initially immediate deferrable,
    date_closed    date,
    days_worked_on INTEGER,
    category_id    INTEGER,
    FOREIGN KEY (category_id) references CATEGORIES (category_id)
        deferrable initially deferred,
    machine_name   char(40),
    description    char(100)
);

create table ASSIGNMENT
       (
           ticket_number    INTEGER,
           pplSoft       INTEGER,
           date_assigned date,
           status        char(50),
           outcome       char(200),
           foreign key (ticket_number) references TICKETS (ticket_number)
               deferrable initially deferred,
           foreign key (pplSoft) references TECH_PERSONNEL (pplSoft)
               deferrable initially deferred,
           primary key (ticket_number, pplSoft),
           check (status in ('assigned', 'in_progress', 'delegated', 'closed_successful',
                             'closed_unsuccessful')) initially immediate deferrable
       );
commit;