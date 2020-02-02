--a,b
alter table TICKETS
    modify days_worked_on integer default 0
        check (DAYS_WORKED_ON >=0);
commit ;
--c
alter table TECH_PERSONNEL
    add supervisor_pplsoft INTEGER default 1110001
    add foreign key (supervisor_pplsoft)
        references TECH_PERSONNEL(PPLSOFT);
commit ;
--d
alter table USER_OFFICE
    add pplSoft Integer
    constraint FK_USER_OFFICE
        references USERS(pplSoft) NOT DEFERRABLE;
commit ;
--e
alter table USER_OFFICE
    drop constraint  FK_USER_OFFICE;
alter table USER_OFFICE
    add constraint FK_USER_OFFICE
        foreign key (pplSoft)
            references USERS(pplSoft) DEFERRABLE initially deferred;
commit ;



