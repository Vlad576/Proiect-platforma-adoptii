-- Compatibil Oracle 23c (XE)

--a) subcereri sincronizate în care intervin cel puțin 3 tabele

--b) subcereri nesincronizate în clauza FROM

--c) grupări de date, funcții grup, filtrare la nivel de grupuri cu subcereri nesincronizate (în clauza de HAVING)

--d) ordonări și utilizarea funcțiilor NVL și DECODE (în cadrul aceleiași cereri)

--e) utilizarea a cel puțin 2 funcții pe șiruri de caractere, 2 funcții pe date calendaristice, a cel puțin unei expresii CASE

--f) utilizarea a cel puțin 1 bloc de cerere (clauza WITH)


--1.
--b), c)

-- Sa se afiseze obiectivele care au media ratingurilor
-- mai mare decat media tuturor ratingurilor.
-- Pentru fiecare obiectiv se va afisa si numarul de
-- turisti pentru care obiectivul este favorit
-- si media ratingurilor.

SELECT r.id_obiectiv        AS id_obiectiv,
       COUNT(*)             AS nr_ratinguri,
       AVG(rating)          AS medie_rating,
       f.nr_fav             AS nr_favorite
FROM rating r JOIN (SELECT id_obiectiv, COUNT(*) nr_fav
                 FROM favorite
                 GROUP BY id_obiectiv) f
ON r.id_obiectiv = f.id_obiectiv
GROUP BY r.id_obiectiv, nr_fav
HAVING AVG(rating) > (SELECT AVG(rating)
                      FROM rating);

--2.
--a), f)

-- Se se afiseze pentru fiecare utilizator
-- obiectivul care are ratingul maxim
-- dat de utilizatorii pe care ii urmareste
-- si pe care nu l-a adaugat inca in lista sa de favorite.

WITH rating_friends AS (
    SELECT u.id_utilizator,
           u.nume_user,
           o.id_obiectiv,
           f.id_followed,
           r.rating
    FROM utilizator u, obiectiv_turistic o,
         urmareste f,
         rating r
    WHERE u.id_utilizator = f.id_utilizator
    AND r.id_utilizator = f.id_followed
    AND r.id_obiectiv = o.id_obiectiv
    AND o.id_obiectiv NOT IN (SELECT fv.id_obiectiv
                              FROM favorite fv
                              WHERE fv.id_utilizator = u.id_utilizator)
)
SELECT id_utilizator        AS id_utilizator,
       nume_user           AS nume_user,
       id_obiectiv         AS id_obiectiv,
       rating              AS rating_maxim
FROM rating_friends r
WHERE rating = (SELECT MAX(rating)
                FROM rating_friends
                WHERE id_utilizator = r.id_utilizator);

--3.
--d), e)

SELECT NVL(comentariu, 'N/A')  AS comentariu,
  CASE
    WHEN data_rating > TO_DATE('01-01-2024', 'DD-MM-YYYY')
    THEN 'recent'
    WHEN data_rating < TO_DATE('20-02-2023', 'DD-MM-YYYY')
    THEN 'neactualizat'
    ELSE 'actual'
   END                          AS relevanta,
   s.status_user               AS status_user
FROM rating r JOIN
    (SELECT id_utilizator,
     DECODE(COUNT(DISTINCT id_obiectiv), nrmax, 'activ',
              nrmax - 1, 'activ',
              'N/A') status_user
    FROM rating, (SELECT MAX(COUNT(DISTINCT id_obiectiv)) nrmax
                    FROM rating
                    GROUP BY id_utilizator)
    GROUP BY id_utilizator, nrmax) s
ON r.id_utilizator = s.id_utilizator;

--4.
--e)

-- Sa se afiseze pentru fiecare obiectiv turistic vizitabil numele cu prima litera
-- majuscula si restul minuscule, primele 10 caractere din adresa,
-- numarul de ratinguri si media ratingurilor formatata cu 2 zecimale.

SELECT INITCAP(o.nume)                      AS nume,
       SUBSTR(o.adresa, 1, 10)              AS adresa_scurta,
       COUNT(r.rating)                      AS nr_ratinguri,
       TO_CHAR(AVG(r.rating), 'FM9990.00')  AS medie_formatata
FROM obiectiv_turistic o
JOIN rating r ON o.id_obiectiv = r.id_obiectiv
WHERE o.vizitabil = TRUE
GROUP BY o.id_obiectiv, o.nume, o.adresa;
