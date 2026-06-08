-- t2.sql

set transaction isolation level serializable;

update comanda_hrana
set cantitate = 99
where id_hrana = 1 and id_aprovizionare = 1;

commit;
