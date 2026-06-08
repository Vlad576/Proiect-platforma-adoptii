-- 15. Outer join, divison, top-n
-- OUTER JOIN
-- Sa se afiseze toate perechile animal - client pentru care a existat o vizita 
-- si datele de contact, impreuna cu clientii care nu au vizitat niciun animal 
-- si cu animalele care nu au fost vizitate de niciun client.
select animal.nume, animal.specie, animal.rasa, vizita.data_ora, 
client.nume || ' '|| client.prenume as nume_prenume, client.telefon
from animal
full outer join vizita_animal on animal.id_animal = vizita_animal.id_animal
full outer join vizita on vizita_animal.id_vizita = vizita.id_vizita
full outer join client on vizita.id_client = client.id_client
order by animal.nume, vizita.data_ora;

-- DIVISION
-- Sa se afiseze furnizorii care au livrat si hrana umeda si hrana uscata.
select furnizor
from aprovizionare_hrana 
join comanda_hrana on aprovizionare_hrana.id_aprovizionare = comanda_hrana.id_aprovizionare
join hrana on comanda_hrana.id_hrana = hrana.id_hrana
where lower(hrana.tip_hrana) in ('umeda', 'uscata')
group by aprovizionare_hrana.furnizor
having count(distinct hrana.tip_hrana) = 2;

-- subquerry ajutator
select furnizor, tip_hrana
from aprovizionare_hrana 
join comanda_hrana on aprovizionare_hrana.id_aprovizionare = comanda_hrana.id_aprovizionare
join hrana on comanda_hrana.id_hrana = hrana.id_hrana
order by furnizor;

--TOP-N
-- Sa se afiseze primii 3 angajati care au rulat cele mai mari sume
-- in tranzactii.
select id_angajat, sum(abs(suma)) as total_suma
from tranzactie
group by id_angajat
order by total_suma desc
fetch first 3 rows only;
