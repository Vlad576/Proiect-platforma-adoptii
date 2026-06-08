set serveroutput on;

-- Cursor
-- Sa se afiseze lista animalelor din adapost
declare
    cursor c_animal is
        select nume, specie, rasa, data_aducere
        from animal;
    v_nume animal.nume%type;
    v_specie animal.specie%type;
    v_rasa animal.rasa%type;
    v_data_aducere animal.data_aducere%type;

begin
    open c_animal;
    dbms_output.put_line('Lista animalelor din adapost:');
    loop
        fetch c_animal into v_nume, v_specie, v_rasa, v_data_aducere;
        exit when c_animal%notfound;

        dbms_output.put_line( v_nume || ', ' || v_specie || ' ' || v_rasa || ', adus la data de ' || to_char(v_data_aducere, 'DD-MM-YYYY') || '.' );
    end loop;
    close c_animal;
end;
/
    
-- Procedura
-- Sa se modifice spatiul unei custi
create or replace procedure spatiu_cusca (
    p_id_cusca number,
    p_spatiu_nou number
)
as
begin
    update cusca
    set capacitate = p_spatiu_nou
    where id_cusca = p_id_cusca;
end;
/

select id_cusca, capacitate 
from cusca 
where id_cusca = 1;

begin
    spatiu_cusca(1, 5);
end;
/

-- Functie
-- Sa se calculeze spatiul unei custi marite cu x metri patrati
create or replace function marire_cusca (
    p_id_cusca number,
    p_spatiu_adaugat number
)
return number
as
    v_spatiu_curent number;
    v_spatiu_total number;
begin
    select capacitate into v_spatiu_curent
    from cusca
    where id_cusca = p_id_cusca;

    v_spatiu_total := v_spatiu_curent + p_spatiu_adaugat;

    return v_spatiu_total;
end;
/

select marire_cusca(1, 2) as spatiu_dupa_marire
from cusca
where id_cusca = 1;


-- trigger
-- Sa se afiseze un mesaj sugestiv cand se adauga un animal

create or replace trigger trg_adaugare_animal
after insert 
on animal
for each row
begin
    dbms_output.put_line('A fost adaugat un nou animal: ' || :new.nume || ', ' || :new.specie || ' ' || :new.rasa || ', nascut la data de ' || to_char(:new.data_nastere, 'DD-MM-YYYY') || '.' );
end;
/

insert into animal (id_animal, id_cusca, nume, specie, rasa, data_nastere, data_aducere)
values (animale_seq.nextval, 1, 'Buddy', 'Caine', 'Golden Retriever', TO_DATE('01-01-2020', 'DD-MM-YYYY'), TO_DATE('01-01-2020', 'DD-MM-YYYY'));
