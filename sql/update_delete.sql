
-- Sa se actualizeze detaliile tranzactiilor care sunt donatii 
-- astfel incat sa apara 'Donatie' in campul detalii.
update tranzactie
set detalii = 'Donatie'
where id_tranzactie in (
    select id_tranzactie
    from donatie
);

-- Sa se actualizeze detaliile vizitelor care au dus la adoptie astfel incat sa apara 'Adoptie facuta' in campul detalii.
update vizita
set detalii = 'Adoptie facuta'
where id_vizita in (
    select id_vizita
    from adoptie join vizita_animal on adoptie.id_animal = vizita_animal.id_animal
    where adoptie.id_adoptator = vizita.id_client
);



-- Sa se sterga din tabela hrana toate alimentele care nu au fost aprovizionate in ultimele 6 luni.
delete comanda_hrana
where id_hrana in (
    select id_hrana
    from aprovizionare_hrana
    where data_ora < add_months(sysdate, -6)
);
delete hrana
where id_hrana in (
    select id_hrana
    from aprovizionare_hrana
    where data_ora < add_months(sysdate, -6)
);

-- Sa se stearga turele care s-au intamplat intr-o zi normala
delete tura
where trunc(data_ora) in (
    select data
    from program_zi
    where lower(tip_zi) = 'normala'
);

rollback;
commit;