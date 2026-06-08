-- t1.sql

set transaction isolation level serializable;

select * 
from comanda_hrana
where id_hrana = 1 and id_aprovizionare = 1;
