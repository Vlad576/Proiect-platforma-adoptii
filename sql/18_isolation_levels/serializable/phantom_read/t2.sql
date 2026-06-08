-- t2.sql

set transaction isolation level serializable;

insert into hrana (tip_hrana, firma, denumire, detalii) values ('uscata', 'Royal Canin', 'Adult 7+', 'fara detalii');
commit;