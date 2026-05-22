-- Compatibil Oracle 21c (XE)

-- Sa se actualizeze media ratingurilor pentru toate obiectivele turistice
-- de tip parc astfel incat sa reprezinte media ratingurilor
-- din ultimele 15 luni.

UPDATE obiectiv_turistic o
SET medie_rating = (SELECT AVG(rating)
                    FROM rating
                    WHERE id_obiectiv = o.id_obiectiv
                    AND MONTHS_BETWEEN(SYSDATE, data_rating) <= 15)
WHERE tip_obiectiv = 'Parc';

-- Sa se stearga din tabela fotografii
-- fotografiile obiectivelor care nu se regasesc in lista de favorite
-- ale utilizatorilor care au inregistrat cele mai multe ratinguri.

DELETE fotografii_obiectiv f
WHERE NOT EXISTS (
    SELECT 'x' FROM favorite fv
    WHERE fv.id_obiectiv = f.id_obiectiv
    AND fv.id_utilizator = (SELECT id_utilizator
                            FROM rating GROUP BY id_utilizator
                            HAVING COUNT(*) =
                                (SELECT MAX(COUNT(*))
                                FROM rating
                                GROUP BY id_utilizator))
);

COMMIT;
