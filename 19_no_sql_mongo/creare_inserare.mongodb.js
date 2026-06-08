use("adapost_animale");


// CUSCA

db.cusca.insertMany([
  { capacitate: 2.00, locatie: "interior" },
  { capacitate: 3.50, locatie: "exterior" },
  { capacitate: 5.00, locatie: "interior" },
  { capacitate: 4.25, locatie: "exterior" },
  { capacitate: 6.00, locatie: "interior" },
  { capacitate: 7.50, locatie: "exterior" },
  { capacitate: 3.00, locatie: "interior" },
  { capacitate: 8.00, locatie: "exterior" }
]);


// ANGAJAT

db.angajat.insertMany([
  { nume: "Popescu", prenume: "Andrei", telefon: "0712345678", email: "andrei.popescu@email.com", data_angajare: ISODate("2022-01-10") },
  { nume: "Ionescu", prenume: "Maria", telefon: "0723456789", email: "maria.ionescu@email.com", data_angajare: ISODate("2022-03-15") },
  { nume: "Dumitru", prenume: "Elena", telefon: "0734567890", email: "elena.dumitru@email.com", data_angajare: ISODate("2023-02-20") },
  { nume: "Georgescu", prenume: "Vlad", telefon: "0745678901", email: "vlad.georgescu@email.com", data_angajare: ISODate("2024-01-05") },
  { nume: "Stan", prenume: "Ioana", telefon: "0756789012", email: "ioana.stan@email.com", data_angajare: ISODate("2024-05-01") },
  { nume: "Moldovan", prenume: "Roxana", telefon: "0765432198", email: "roxana.moldovan@email.com", data_angajare: ISODate("2024-03-12") },
  { nume: "Barbu", prenume: "Cristian", telefon: "0776543219", email: "cristian.barbu@email.com", data_angajare: ISODate("2023-11-30") }
]);


// VETERINAR

db.veterinar.insertMany([
  { id_angajat: 1, specializare: "canin" },
  { id_angajat: 2, specializare: "felin" },
  { id_angajat: 6, specializare: "exotic" }
]);


//      RECEPTIONER

db.receptioner.insertMany([
  { id_angajat: 3, tura_preferata: "dimineata" },
  { id_angajat: 4, tura_preferata: "seara" },
  { id_angajat: 7, tura_preferata: "pranz" }
]);


// VOLUNTAR

db.voluntar.insertMany([
  { id_angajat: 5, ocupatie: "student" },
  { id_angajat: 6, ocupatie: "asistent" }
]);


//  ANIMAL

db.animal.insertMany([
  { id_cusca: 1, nume: "Rex", data_nastere: ISODate("2021-05-10"), specie: "caine", rasa: "labrador", in_tratament: false, data_aducere: ISODate("2021-06-01") },
  { id_cusca: 2, nume: "Miti", data_nastere: ISODate("2022-03-15"), specie: "pisica", rasa: "siameza", in_tratament: true, data_aducere: ISODate("2022-04-01") },
  { id_cusca: 3, nume: "Azorel", data_nastere: ISODate("2020-11-20"), specie: "caine", rasa: "bichon", in_tratament: false, data_aducere: ISODate("2020-12-01") },
  { id_cusca: 4, nume: "Tom", data_nastere: ISODate("2021-08-01"), specie: "pisica", rasa: "persana", in_tratament: false, data_aducere: ISODate("2021-09-01") },
  { id_cusca: 5, nume: "Bella", data_nastere: ISODate("2023-01-05"), specie: "caine", rasa: "bulldog", in_tratament: true, data_aducere: ISODate("2023-02-01") },
  { id_cusca: 6, nume: "Oscar", data_nastere: ISODate("2022-07-12"), specie: "caine", rasa: "beagle", in_tratament: false, data_aducere: ISODate("2022-08-01") },
  { id_cusca: 7, nume: "Luna", data_nastere: ISODate("2021-12-25"), specie: "pisica", rasa: "birmaneza", in_tratament: true, data_aducere: ISODate("2022-01-10") }
]);


//  CLIENT

db.client.insertMany([
  { nume: "Marin", prenume: "Cristina", telefon: "0767890123", email: "cristina.marin@email.com" },
  { nume: "Radu", prenume: "Florin", telefon: "0778901234", email: "florin.radu@email.com" },
  { nume: "Ilie", prenume: "Ana", telefon: "0789012345", email: "ana.ilie@email.com" },
  { nume: "Dobre", prenume: "Mihai", telefon: "0790123456", email: "mihai.dobre@email.com" },
  { nume: "Petrescu", prenume: "Gabriela", telefon: "0701234567", email: "gabriela.petrescu@email.com" },
  { nume: "Enache", prenume: "Paul", telefon: "0711223344", email: "paul.enache@email.com" },
  { nume: "Tudor", prenume: "Simona", telefon: "0722334455", email: "simona.tudor@email.com" }
]);


//   VIZITA

db.vizita.insertMany([
  { id_client: 1, data_ora: ISODate("2024-05-20T10:00:00"), detalii: "Vizita pentru adoptie" },
  { id_client: 2, data_ora: ISODate("2024-05-21T11:30:00"), detalii: "Vizita pentru donatie" },
  { id_client: 3, data_ora: ISODate("2024-05-22T09:15:00"), detalii: "Vizita informativa" },
  { id_client: 4, data_ora: ISODate("2024-05-23T14:45:00"), detalii: "Vizita pentru voluntariat" },
  { id_client: 5, data_ora: ISODate("2024-05-24T16:00:00"), detalii: "Vizita pentru consultatie" },
  { id_client: 6, data_ora: ISODate("2024-05-25T12:00:00"), detalii: "Vizita pentru informare" },
  { id_client: 7, data_ora: ISODate("2024-05-26T15:30:00"), detalii: "Vizita pentru donatie speciala" }
]);


//  ADOPTIE

db.adoptie.insertMany([
  { id_adoptator: 1, id_animal: 1, id_angajat: 1, data_adoptie: ISODate("2024-05-20") },
  { id_adoptator: 2, id_animal: 2, id_angajat: 2, data_adoptie: ISODate("2024-05-21") },
  { id_adoptator: 3, id_animal: 3, id_angajat: 3, data_adoptie: ISODate("2024-05-22") },
  { id_adoptator: 4, id_animal: 4, id_angajat: 4, data_adoptie: ISODate("2024-05-23") },
  { id_adoptator: 5, id_animal: 5, id_angajat: 5, data_adoptie: ISODate("2024-05-24") },
  { id_adoptator: 6, id_animal: 6, id_angajat: 6, data_adoptie: ISODate("2024-05-25") }
]);


// TRANZACTIE

db.tranzactie.insertMany([
  { id_angajat: 1, suma: 100.00, data_ora: ISODate("2024-05-20T12:05:00"), detalii: "Taxa adoptie" },
  { id_angajat: 2, suma: 200.00, data_ora: ISODate("2024-05-21T13:47:00"), detalii: "Donatie" },
  { id_angajat: 3, suma: -50.00, data_ora: ISODate("2024-05-22T09:30:00"), detalii: "Taxa consultatie" },
  { id_angajat: 4, suma: -75.00, data_ora: ISODate("2024-05-23T18:15:00"), detalii: "Taxa hrana" },
  { id_angajat: 5, suma: 120.00, data_ora: ISODate("2024-05-24T08:55:00"), detalii: "Taxa voluntariat" },
  { id_angajat: 6, suma: 80.00, data_ora: ISODate("2024-05-25T10:10:00"), detalii: "Taxa adoptii multiple" },
  { id_angajat: 2, suma: -200.00, data_ora: ISODate("2024-04-22T15:12:00"), detalii: "Impozit donatii" },
  { id_angajat: 5, suma: 25.00, data_ora: ISODate("2024-04-20T15:12:00"), detalii: "Donatie pentru hrana" }
]);


//   APROVIZIONARE HRANA

db.aprovizionare_hrana.insertMany([
  { id_tranzactie: 1, data_ora: ISODate("2024-05-20T13:00:00"), furnizor: "PetFood SRL" },
  { id_tranzactie: 2, data_ora: ISODate("2024-05-21T14:10:00"), furnizor: "AnimalShop SRL" },
  { id_tranzactie: 3, data_ora: ISODate("2024-05-22T15:25:00"), furnizor: "ZooMarket SRL" },
  { id_tranzactie: 4, data_ora: ISODate("2024-05-23T16:40:00"), furnizor: "PetStore SRL" },
  { id_tranzactie: 5, data_ora: ISODate("2024-05-24T17:55:00"), furnizor: "Animax SRL" },
  { id_tranzactie: 6, data_ora: ISODate("2024-05-25T18:00:00"), furnizor: "PetZone SRL" }
]);


//   HRANA

db.hrana.insertMany([
  { tip_hrana: "uscata", firma: "Royal Canin", denumire: "Mini Adult", detalii: "Pentru caini adulti" },
  { tip_hrana: "umeda", firma: "Whiskas", denumire: "Plic Somon", detalii: "Pentru pisici adulte" },
  { tip_hrana: "uscata", firma: "Purina", denumire: "Pro Plan", detalii: "Pentru caini juniori" },
  { tip_hrana: "umeda", firma: "Sheba", denumire: "Plic Vita", detalii: "Pentru pisici juniori" },
  { tip_hrana: "uscata", firma: "Pedigree", denumire: "Vital Protection", detalii: "Pentru caini seniori" },
  { tip_hrana: "umeda", firma: "Friskies", denumire: "Plic Pui", detalii: "Pentru pisici pui" }
]);


//   COMANDA HRANA

db.comanda_hrana.insertMany([
  { id_hrana: 1, id_aprovizionare: 1, cantitate: 10.000, um: "kg" },
  { id_hrana: 2, id_aprovizionare: 2, cantitate: 5.500, um: "kg" },
  { id_hrana: 3, id_aprovizionare: 3, cantitate: 7.250, um: "kg" },
  { id_hrana: 4, id_aprovizionare: 4, cantitate: 500, um: "g" },
  { id_hrana: 5, id_aprovizionare: 5, cantitate: 8.750, um: "kg" },
  { id_hrana: 1, id_aprovizionare: 2, cantitate: 2.000, um: "kg" },
  { id_hrana: 2, id_aprovizionare: 3, cantitate: 1.500, um: "kg" },
  { id_hrana: 3, id_aprovizionare: 4, cantitate: 100, um: "g" },
  { id_hrana: 4, id_aprovizionare: 5, cantitate: 6.000, um: "kg" },
  { id_hrana: 5, id_aprovizionare: 1, cantitate: 9.000, um: "kg" },
  { id_hrana: 6, id_aprovizionare: 6, cantitate: 3.000, um: "kg" }
]);


//  DONATIE

db.donatie.insertMany([
  { id_client: 1, id_tranzactie: 1, id_aprovizionare: 1 },
  { id_client: 2, id_tranzactie: 2 },
  { id_client: 3, id_tranzactie: 3, id_aprovizionare: 3 },
  { id_client: 4, id_aprovizionare: 4 },
  { id_client: 5, id_tranzactie: 5, id_aprovizionare: 5 },
  { id_client: 6, id_tranzactie: 6, id_aprovizionare: 6 }
]);


// PROGRAM ZI

db.program_zi.insertMany([
  { data: ISODate("2024-05-20"), tip_zi: "eveniment" },
  { data: ISODate("2024-05-21"), tip_zi: "normala" },
  { data: ISODate("2024-05-22"), tip_zi: "inventar" },
  { data: ISODate("2024-05-23"), tip_zi: "normala" },
  { data: ISODate("2024-05-24"), tip_zi: "normala" },
  { data: ISODate("2024-05-25"), tip_zi: "speciala" }
]);


//      VIZITA ANIMAL

db.vizita_animal.insertMany([
  { id_vizita: 1, id_animal: 1 },
  { id_vizita: 1, id_animal: 2 },
  { id_vizita: 2, id_animal: 3 },
  { id_vizita: 2, id_animal: 4 },
  { id_vizita: 3, id_animal: 5 },
  { id_vizita: 4, id_animal: 1 },
  { id_vizita: 4, id_animal: 3 },
  { id_vizita: 5, id_animal: 2 },
  { id_vizita: 5, id_animal: 4 },
  { id_vizita: 5, id_animal: 5 },
  { id_vizita: 6, id_animal: 6 },
  { id_vizita: 7, id_animal: 7 },
  { id_vizita: 6, id_animal: 2 },
  { id_vizita: 7, id_animal: 1 }
]);


//    TURA

db.tura.insertMany([
  { id_angajat: 1, data_ora: ISODate("2024-05-20T08:00:00"), durata: 8.00 },
  { id_angajat: 2, data_ora: ISODate("2024-05-20T16:00:00"), durata: 8.00 },
  { id_angajat: 3, data_ora: ISODate("2024-05-21T08:00:00"), durata: 8.00 },
  { id_angajat: 4, data_ora: ISODate("2024-05-21T16:00:00"), durata: 8.00 },
  { id_angajat: 5, data_ora: ISODate("2024-05-22T08:00:00"), durata: 8.00 },
  { id_angajat: 6, data_ora: ISODate("2024-05-22T16:00:00"), durata: 8.00 },
  { id_angajat: 7, data_ora: ISODate("2024-05-23T08:00:00"), durata: 8.00 }
]);
