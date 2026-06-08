select * from animal;
select * from vizita_animal;
select * from adoptie;
select * from client;

select * from aprovizionare_hrana;
select * from comanda_hrana;
select * from hrana;

update comanda_hrana
set cantitate = 10
where id_hrana = 1 and id_aprovizionare = 1;

commit;

drop view v_statistica_vizite_adoptie;

