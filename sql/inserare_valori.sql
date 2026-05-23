-- 11.

-- Inserări pentru tabelul cusca
INSERT INTO cusca (capacitate, locatie) VALUES (2.00, 'interior');
INSERT INTO cusca (capacitate, locatie) VALUES (3.50, 'exterior');
INSERT INTO cusca (capacitate, locatie) VALUES (5.00, 'interior');
INSERT INTO cusca (capacitate, locatie) VALUES (4.25, 'exterior');
INSERT INTO cusca (capacitate, locatie) VALUES (6.00, 'interior');
INSERT INTO cusca (capacitate, locatie) VALUES (7.50, 'exterior');
INSERT INTO cusca (capacitate, locatie) VALUES (3.00, 'interior');
INSERT INTO cusca (capacitate, locatie) VALUES (8.00, 'exterior');

-- Inserări pentru tabelul angajat
INSERT INTO angajat (nume, prenume, telefon, email, data_angajare) VALUES ('Popescu', 'Andrei', '0712345678', 'andrei.popescu@email.com', TO_DATE('2022-01-10', 'YYYY-MM-DD'));
INSERT INTO angajat (nume, prenume, telefon, email, data_angajare) VALUES ('Ionescu', 'Maria', '0723456789', 'maria.ionescu@email.com', TO_DATE('2022-03-15', 'YYYY-MM-DD'));
INSERT INTO angajat (nume, prenume, telefon, email, data_angajare) VALUES ('Dumitru', 'Elena', '0734567890', 'elena.dumitru@email.com', TO_DATE('2023-02-20', 'YYYY-MM-DD'));
INSERT INTO angajat (nume, prenume, telefon, email, data_angajare) VALUES ('Georgescu', 'Vlad', '0745678901', 'vlad.georgescu@email.com', TO_DATE('2024-01-05', 'YYYY-MM-DD'));
INSERT INTO angajat (nume, prenume, telefon, email, data_angajare) VALUES ('Stan', 'Ioana', '0756789012', 'ioana.stan@email.com', TO_DATE('2024-05-01', 'YYYY-MM-DD'));
INSERT INTO angajat (nume, prenume, telefon, email, data_angajare) VALUES ('Moldovan', 'Roxana', '0765432198', 'roxana.moldovan@email.com', TO_DATE('2024-03-12', 'YYYY-MM-DD'));
INSERT INTO angajat (nume, prenume, telefon, email, data_angajare) VALUES ('Barbu', 'Cristian', '0776543219', 'cristian.barbu@email.com', TO_DATE('2023-11-30', 'YYYY-MM-DD'));

-- Inserări pentru tabelul veterinar
INSERT INTO veterinar (id_angajat, specializare) VALUES (1, 'canin');
INSERT INTO veterinar (id_angajat, specializare) VALUES (2, 'felin');
INSERT INTO veterinar (id_angajat, specializare) VALUES (6, 'exotic');

-- Inserări pentru tabelul receptioner
INSERT INTO receptioner (id_angajat, tura_preferata) VALUES (3, 'dimineata');
INSERT INTO receptioner (id_angajat, tura_preferata) VALUES (4, 'seara');
INSERT INTO receptioner (id_angajat, tura_preferata) VALUES (7, 'pranz');

-- Inserări pentru tabelul voluntar
INSERT INTO voluntar (id_angajat, ocupatie) VALUES (5, 'student');
INSERT INTO voluntar (id_angajat, ocupatie) VALUES (6, 'asistent');

-- Inserări pentru tabelul animal
INSERT INTO animal (id_cusca, nume, data_nastere, specie, rasa, in_tratament, data_aducere) VALUES (1, 'Rex', TO_DATE('2021-05-10', 'YYYY-MM-DD'), 'caine', 'labrador', 0, TO_DATE('2021-06-01', 'YYYY-MM-DD'));
INSERT INTO animal (id_cusca, nume, data_nastere, specie, rasa, in_tratament, data_aducere) VALUES (2, 'Miti', TO_DATE('2022-03-15', 'YYYY-MM-DD'), 'pisica', 'siameza', 1, TO_DATE('2022-04-01', 'YYYY-MM-DD'));
INSERT INTO animal (id_cusca, nume, data_nastere, specie, rasa, in_tratament, data_aducere) VALUES (3, 'Azorel', TO_DATE('2020-11-20', 'YYYY-MM-DD'), 'caine', 'bichon', 0, TO_DATE('2020-12-01', 'YYYY-MM-DD'));
INSERT INTO animal (id_cusca, nume, data_nastere, specie, rasa, in_tratament, data_aducere) VALUES (4, 'Tom', TO_DATE('2021-08-01', 'YYYY-MM-DD'), 'pisica', 'persana', 0, TO_DATE('2021-09-01', 'YYYY-MM-DD'));
INSERT INTO animal (id_cusca, nume, data_nastere, specie, rasa, in_tratament, data_aducere) VALUES (5, 'Bella', TO_DATE('2023-01-05', 'YYYY-MM-DD'), 'caine', 'bulldog', 1, TO_DATE('2023-02-01', 'YYYY-MM-DD'));
INSERT INTO animal (id_cusca, nume, data_nastere, specie, rasa, in_tratament, data_aducere) VALUES (6, 'Oscar', TO_DATE('2022-07-12', 'YYYY-MM-DD'), 'caine', 'beagle', 0, TO_DATE('2022-08-01', 'YYYY-MM-DD'));
INSERT INTO animal (id_cusca, nume, data_nastere, specie, rasa, in_tratament, data_aducere) VALUES (7, 'Luna', TO_DATE('2021-12-25', 'YYYY-MM-DD'), 'pisica', 'birmaneza', 1, TO_DATE('2022-01-10', 'YYYY-MM-DD'));

-- Inserări pentru tabelul client
INSERT INTO client (nume, prenume, telefon, email) VALUES ('Marin', 'Cristina', '0767890123', 'cristina.marin@email.com');
INSERT INTO client (nume, prenume, telefon, email) VALUES ('Radu', 'Florin', '0778901234', 'florin.radu@email.com');
INSERT INTO client (nume, prenume, telefon, email) VALUES ('Ilie', 'Ana', '0789012345', 'ana.ilie@email.com');
INSERT INTO client (nume, prenume, telefon, email) VALUES ('Dobre', 'Mihai', '0790123456', 'mihai.dobre@email.com');
INSERT INTO client (nume, prenume, telefon, email) VALUES ('Petrescu', 'Gabriela', '0701234567', 'gabriela.petrescu@email.com');
INSERT INTO client (nume, prenume, telefon, email) VALUES ('Enache', 'Paul', '0711223344', 'paul.enache@email.com');
INSERT INTO client (nume, prenume, telefon, email) VALUES ('Tudor', 'Simona', '0722334455', 'simona.tudor@email.com');

-- Inserări pentru tabelul vizita
INSERT INTO vizita (id_client, data_ora, detalii) VALUES (1, TO_TIMESTAMP('2024-05-20 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Vizita pentru adoptie');
INSERT INTO vizita (id_client, data_ora, detalii) VALUES (2, TO_TIMESTAMP('2024-05-21 11:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Vizita pentru donatie');
INSERT INTO vizita (id_client, data_ora, detalii) VALUES (3, TO_TIMESTAMP('2024-05-22 09:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Vizita informativa');
INSERT INTO vizita (id_client, data_ora, detalii) VALUES (4, TO_TIMESTAMP('2024-05-23 14:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Vizita pentru voluntariat');
INSERT INTO vizita (id_client, data_ora, detalii) VALUES (5, TO_TIMESTAMP('2024-05-24 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Vizita pentru consultatie');
INSERT INTO vizita (id_client, data_ora, detalii) VALUES (6, TO_TIMESTAMP('2024-05-25 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Vizita pentru informare');
INSERT INTO vizita (id_client, data_ora, detalii) VALUES (7, TO_TIMESTAMP('2024-05-26 15:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Vizita pentru donatie speciala');

-- Inserări pentru tabelul adoptie
INSERT INTO adoptie (id_adoptator, id_animal, id_angajat, data_adoptie) VALUES (1, 1, 1, TO_DATE('2024-05-20', 'YYYY-MM-DD'));
INSERT INTO adoptie (id_adoptator, id_animal, id_angajat, data_adoptie) VALUES (2, 2, 2, TO_DATE('2024-05-21', 'YYYY-MM-DD'));
INSERT INTO adoptie (id_adoptator, id_animal, id_angajat, data_adoptie) VALUES (3, 3, 3, TO_DATE('2024-05-22', 'YYYY-MM-DD'));
INSERT INTO adoptie (id_adoptator, id_animal, id_angajat, data_adoptie) VALUES (4, 4, 4, TO_DATE('2024-05-23', 'YYYY-MM-DD'));
INSERT INTO adoptie (id_adoptator, id_animal, id_angajat, data_adoptie) VALUES (5, 5, 5, TO_DATE('2024-05-24', 'YYYY-MM-DD'));
INSERT INTO adoptie (id_adoptator, id_animal, id_angajat, data_adoptie) VALUES (6, 6, 6, TO_DATE('2024-05-25', 'YYYY-MM-DD'));

-- Inserări pentru tabelul tranzactie
INSERT INTO tranzactie (id_angajat, suma, data_ora, detalii) VALUES (1, 100.00, TO_TIMESTAMP('2024-05-20 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Taxa adoptie');
INSERT INTO tranzactie (id_angajat, suma, data_ora, detalii) VALUES (2, 200.00, TO_TIMESTAMP('2024-05-21 13:47:00', 'YYYY-MM-DD HH24:MI:SS'), 'Donatie');
INSERT INTO tranzactie (id_angajat, suma, data_ora, detalii) VALUES (3, -50.00, TO_TIMESTAMP('2024-05-22 09:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Taxa consultatie');
INSERT INTO tranzactie (id_angajat, suma, data_ora, detalii) VALUES (4, -75.00, TO_TIMESTAMP('2024-05-23 18:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Taxa hrana');
INSERT INTO tranzactie (id_angajat, suma, data_ora, detalii) VALUES (5, 120.00, TO_TIMESTAMP('2024-05-24 08:55:00', 'YYYY-MM-DD HH24:MI:SS'), 'Taxa voluntariat');
INSERT INTO tranzactie (id_angajat, suma, data_ora, detalii) VALUES (6, 80.00, TO_TIMESTAMP('2024-05-25 10:10:00', 'YYYY-MM-DD HH24:MI:SS'), 'Taxa adoptii multiple');
INSERT INTO tranzactie (id_angajat, suma, data_ora, detalii) VALUES (2, -200.00, TO_TIMESTAMP('2024-04-22 15:12:00', 'YYYY-MM-DD HH24:MI:SS'), 'Impozit donatii');
INSERT INTO tranzactie (id_angajat, suma, data_ora, detalii) VALUES (5, 25.00, TO_TIMESTAMP('2024-04-20 15:12:00', 'YYYY-MM-DD HH24:MI:SS'), 'Donatie pentru hrana');


-- Inserări pentru tabelul aprovizionare_hrana
INSERT INTO aprovizionare_hrana (id_tranzactie, data_ora, furnizor) VALUES (1, TO_TIMESTAMP('2024-05-20 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'PetFood SRL');
INSERT INTO aprovizionare_hrana (id_tranzactie, data_ora, furnizor) VALUES (2, TO_TIMESTAMP('2024-05-21 14:10:00', 'YYYY-MM-DD HH24:MI:SS'), 'AnimalShop SRL');
INSERT INTO aprovizionare_hrana (id_tranzactie, data_ora, furnizor) VALUES (3, TO_TIMESTAMP('2024-05-22 15:25:00', 'YYYY-MM-DD HH24:MI:SS'), 'ZooMarket SRL');
INSERT INTO aprovizionare_hrana (id_tranzactie, data_ora, furnizor) VALUES (4, TO_TIMESTAMP('2024-05-23 16:40:00', 'YYYY-MM-DD HH24:MI:SS'), 'PetStore SRL');
INSERT INTO aprovizionare_hrana (id_tranzactie, data_ora, furnizor) VALUES (5, TO_TIMESTAMP('2024-05-24 17:55:00', 'YYYY-MM-DD HH24:MI:SS'), 'Animax SRL');
INSERT INTO aprovizionare_hrana (id_tranzactie, data_ora, furnizor) VALUES (6, TO_TIMESTAMP('2024-05-25 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'PetZone SRL');

-- Inserări pentru tabelul hrana
INSERT INTO hrana (tip_hrana, firma, denumire, detalii) VALUES ('uscata', 'Royal Canin', 'Mini Adult', 'Pentru caini adulti');
INSERT INTO hrana (tip_hrana, firma, denumire, detalii) VALUES ('umeda', 'Whiskas', 'Plic Somon', 'Pentru pisici adulte');
INSERT INTO hrana (tip_hrana, firma, denumire, detalii) VALUES ('uscata', 'Purina', 'Pro Plan', 'Pentru caini juniori');
INSERT INTO hrana (tip_hrana, firma, denumire, detalii) VALUES ('umeda', 'Sheba', 'Plic Vita', 'Pentru pisici juniori');
INSERT INTO hrana (tip_hrana, firma, denumire, detalii) VALUES ('uscata', 'Pedigree', 'Vital Protection', 'Pentru caini seniori');
INSERT INTO hrana (tip_hrana, firma, denumire, detalii) VALUES ('umeda', 'Friskies', 'Plic Pui', 'Pentru pisici pui');

-- Inserări pentru tabelul comanda_hrana
INSERT INTO comanda_hrana (id_hrana, id_aprovizionare, cantitate, um) VALUES (1, 1, 10.000, 'kg');
INSERT INTO comanda_hrana (id_hrana, id_aprovizionare, cantitate, um) VALUES (2, 2, 5.500, 'kg');
INSERT INTO comanda_hrana (id_hrana, id_aprovizionare, cantitate, um) VALUES (3, 3, 7.250, 'kg');
INSERT INTO comanda_hrana (id_hrana, id_aprovizionare, cantitate, um) VALUES (4, 4, 500, 'g');
INSERT INTO comanda_hrana (id_hrana, id_aprovizionare, cantitate, um) VALUES (5, 5, 8.750, 'kg');
INSERT INTO comanda_hrana (id_hrana, id_aprovizionare, cantitate, um) VALUES (1, 2, 2.000, 'kg');
INSERT INTO comanda_hrana (id_hrana, id_aprovizionare, cantitate, um) VALUES (2, 3, 1.500, 'kg');
INSERT INTO comanda_hrana (id_hrana, id_aprovizionare, cantitate, um) VALUES (3, 4, 100, 'g');
INSERT INTO comanda_hrana (id_hrana, id_aprovizionare, cantitate, um) VALUES (4, 5, 6.000, 'kg');
INSERT INTO comanda_hrana (id_hrana, id_aprovizionare, cantitate, um) VALUES (5, 1, 9.000, 'kg');
INSERT INTO comanda_hrana (id_hrana, id_aprovizionare, cantitate, um) VALUES (6, 6, 3.000, 'kg');

-- Inserări pentru tabelul donatie
INSERT INTO donatie (id_client, id_tranzactie, id_aprovizionare) VALUES (1, 1, 1);
INSERT INTO donatie (id_client, id_tranzactie) VALUES (2, 2);
INSERT INTO donatie (id_client, id_tranzactie, id_aprovizionare) VALUES (3, 3, 3);
INSERT INTO donatie (id_client, id_aprovizionare) VALUES (4, 4);
INSERT INTO donatie (id_client, id_tranzactie, id_aprovizionare) VALUES (5, 5, 5);
INSERT INTO donatie (id_client, id_tranzactie, id_aprovizionare) VALUES (6, 6, 6);

-- Inserări pentru tabelul program_zi
INSERT INTO program_zi (data, tip_zi) VALUES (TO_DATE('2024-05-20', 'YYYY-MM-DD'), 'eveniment');
INSERT INTO program_zi (data, tip_zi) VALUES (TO_DATE('2024-05-21', 'YYYY-MM-DD'), 'normala');
INSERT INTO program_zi (data, tip_zi) VALUES (TO_DATE('2024-05-22', 'YYYY-MM-DD'), 'inventar');
INSERT INTO program_zi (data, tip_zi) VALUES (TO_DATE('2024-05-23', 'YYYY-MM-DD'), 'normala');
INSERT INTO program_zi (data, tip_zi) VALUES (TO_DATE('2024-05-24', 'YYYY-MM-DD'), 'normala');
INSERT INTO program_zi (data, tip_zi) VALUES (TO_DATE('2024-05-25', 'YYYY-MM-DD'), 'speciala');

-- Inserări pentru tabelul vizita_animal
INSERT INTO vizita_animal (id_vizita, id_animal) VALUES (1, 1);
INSERT INTO vizita_animal (id_vizita, id_animal) VALUES (1, 2);
INSERT INTO vizita_animal (id_vizita, id_animal) VALUES (2, 3);
INSERT INTO vizita_animal (id_vizita, id_animal) VALUES (2, 4);
INSERT INTO vizita_animal (id_vizita, id_animal) VALUES (3, 5);
INSERT INTO vizita_animal (id_vizita, id_animal) VALUES (4, 1);
INSERT INTO vizita_animal (id_vizita, id_animal) VALUES (4, 3);
INSERT INTO vizita_animal (id_vizita, id_animal) VALUES (5, 2);
INSERT INTO vizita_animal (id_vizita, id_animal) VALUES (5, 4);
INSERT INTO vizita_animal (id_vizita, id_animal) VALUES (5, 5);
INSERT INTO vizita_animal (id_vizita, id_animal) VALUES (6, 6);
INSERT INTO vizita_animal (id_vizita, id_animal) VALUES (7, 7);
INSERT INTO vizita_animal (id_vizita, id_animal) VALUES (6, 2);
INSERT INTO vizita_animal (id_vizita, id_animal) VALUES (7, 1);

-- Inserări pentru tabelul tura
INSERT INTO tura (id_angajat, data_ora, durata) VALUES (1, TO_TIMESTAMP('2024-05-20 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8.00);
INSERT INTO tura (id_angajat, data_ora, durata) VALUES (2, TO_TIMESTAMP('2024-05-21 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8.00);
INSERT INTO tura (id_angajat, data_ora, durata) VALUES (3, TO_TIMESTAMP('2024-05-22 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8.00);
INSERT INTO tura (id_angajat, data_ora, durata) VALUES (4, TO_TIMESTAMP('2024-05-23 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8.00);
INSERT INTO tura (id_angajat, data_ora, durata) VALUES (5, TO_TIMESTAMP('2024-05-24 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8.00);
INSERT INTO tura (id_angajat, data_ora, durata) VALUES (6, TO_TIMESTAMP('2024-05-25 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6.00);
INSERT INTO tura (id_angajat, data_ora, durata) VALUES (7, TO_TIMESTAMP('2024-05-26 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 4.00);

COMMIT;