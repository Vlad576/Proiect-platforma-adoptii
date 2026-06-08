-- Sa se afiseze numele si prenumele clientilor care au cel putin o vizita si o donatie

-- cerere initiala
select distinct client.nume, client.prenume
from client
join vizita on client.id_client = vizita.id_client
where client.id_client in (
    select id_client
    from donatie
);

-- cerere optimizata
create index idx_donatie_id_client on donatie(id_client);
create index idx_vizita_id_client on vizita(id_client);
create index idx_client_id_client on client(id_client);

select client.nume, client.prenume
from client
join vizita on client.id_client = vizita.id_client
join donatie on client.id_client = donatie.id_client;