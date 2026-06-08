-- 14. Creare view
-- Sa se creeze o statistica a numarului de vizite pentru fiecare animal
-- si al statusului de adoptie
create view v_statistica_vizite_adoptie as
select animal.id_animal, nume, specie, rasa, count(id_vizita) as numar_vizite,
case when exists (
    select 'x' from adoptie
    where adoptie.id_animal = animal.id_animal
) then 'Adoptat'
else 'In adapost'
end as status_adoptie
from animal
left join vizita_animal on animal.id_animal = vizita_animal.id_animal
group by animal.id_animal, nume, specie, rasa;

-- operatie permisa
select nume, numar_vizite, status_adoptie 
from v_statistica_vizite_adoptie;

-- operatie nepermisa deoarece avem agregari
-- si valorile nu corespund direct unor randuri din tabele
update v_statistica_vizite_adoptie
set status_adoptie = 'Adoptat'
where id_animal = 7;
