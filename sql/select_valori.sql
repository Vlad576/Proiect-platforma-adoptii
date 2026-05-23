
/*
a)	subcereri sincronizate în care intervin cel puțin 3 tabele
b)	subcereri nesincronizate în clauza FROM
c)	grupări de date, funcții grup, filtrare la nivel de grupuri cu subcereri nesincronizate (în clauza de HAVING)
d)	ordonări și utilizarea funcțiilor NVL și DECODE (în cadrul aceleiași cereri)
e)	utilizarea a cel puțin 2 funcții pe șiruri de caractere, 2 funcții pe date calendaristice,  a cel puțin unei expresii CASE
f)	utilizarea a cel puțin 1 bloc de cerere (clauza WITH)
*/

select * from tranzactie;
select * from hrana;
select * from cusca;
select * from animal;
select * from adoptie;
select * from angajat;
select * from donatie;
select * from client;

-- b)	subcereri nesincronizate în clauza FROM
-- Sa se afiseze capacitatea medie a custilor in care se afla animale care au fost vizitate.
select avg(capacitate) 
from cusca join (
    select id_animal, id_cusca
    from animal
    where id_animal in (
        select id_animal
        from vizita_animal
    )
) a on cusca.id_cusca = a.id_cusca;


-- a)	subcereri sincronizate în care intervin cel puțin 3 tabele
-- f)	utilizarea a cel puțin 1 bloc de cerere (clauza WITH)
-- Sa se afiseze numele, prenumele si data vizitei pentru toti clientii care au facut cel putin o donatie.
with vizite_clienti as (
    select vizita.id_client, nume, prenume, data_ora
    from vizita join client on vizita.id_client = client.id_client
)
select vizite_clienti.nume || ' ' || vizite_clienti.prenume, vizite_clienti.data_ora
from vizite_clienti
where (
    select count(id_donatie)
    from donatie
    where id_client = vizite_clienti.id_client
) > 0;

/*
select client.nume || ' ' || client.prenume, vizita.data_ora
from vizita join client on vizita.id_client = client.id_client
where (
    select count(id_donatie)
    from donatie
    where id_client = vizita.id_client
) > 0;
*/



-- c)	grupări de date, funcții grup, filtrare la nivel de grupuri cu subcereri nesincronizate (în clauza de HAVING)
-- Sa se afiseze bilantul financiar din lunile peste media tuturor tranzactiilor. 
select sum(suma)
from tranzactie
group by trunc(data_ora, 'MM')
having sum(suma) > (
    select avg(suma)
    from tranzactie
);

-- d)	ordonări și utilizarea funcțiilor NVL și DECODE (în cadrul aceleiași cereri)
-- Pentru calcularea bonusurilor, sa se afiseze pentru fiecare angajat numele complet, numarul de zile pana la prima adoptie si o clasificare a vechimii in functie de anul angajarii.
-- Rezultatele se vor ordona descrescator dupa numarul de zile pana la prima adoptie si alfabetic dupa clasificarea vechimii.
select 
    angajat.nume || ' ' || angajat.prenume as nume_complet, 
    nvl(to_char(min(adoptie.data_adoptie) - angajat.data_angajare), 'Nu a avut adoptii') as zile_pana_la_prima_adoptie,
    decode(
        to_number(to_char(angajat.data_angajare, 'YYYY')), 
        2026, 'vechime mica',
        2025, 'vechime mica',
        2024, 'vechime medie',
        2023, 'vechime medie',
        2022, 'vechime mare',
        2021, 'vechime mare',
        'vechime foarte mare'
    ) 
    as vechime
from angajat 
left join adoptie on angajat.id_angajat = adoptie.id_angajat
group by angajat.id_angajat, angajat.nume, angajat.prenume, angajat.data_angajare
order by 
    decode(
        zile_pana_la_prima_adoptie, 
        'Nu a avut adoptii', 0, 
        to_number(zile_pana_la_prima_adoptie)
    ) desc, 
    vechime;


-- e)	utilizarea a cel puțin 2 funcții pe șiruri de caractere, 2 funcții pe date calendaristice,  a cel puțin unei expresii CASE
-- Sa se genereze pentru fiecare angajat un username si o parola unica
select 
    lower(nume || '.' || prenume) as "user", 
    to_char(id_angajat) || 
    initcap(nume) ||
    case
        when upper(substr(prenume, 1, 1)) in ('A', 'E', 'I', 'O', 'U') then '!'
        when data_angajare > to_date('2023-06-01', 'YYYY-MM-DD') then '@'
        else '#'
    end ||
    67*mod(trunc(months_between(data_angajare, to_date('2005-08-03', 'YYYY-MM-DD'))), 42) as "parola"
from angajat;

