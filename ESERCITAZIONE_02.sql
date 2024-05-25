-- ESERCIZIO 1 --
-- Visualizzare tutti i musei della città di Verona con il loro giorno di chiusura.
SELECT nome, città, giornoChiusura
FROM Museo
WHERE città = 'Verona';

-- ESERCIZIO 2 --
-- Visualizzare per ogni mostra che inizia con la lettera ’R’, una stringa composta dal titolo e dalla città in cui si svolge.
SELECT titolo || ' - ' || città AS mostra_città
FROM Mostra
WHERE titolo LIKE 'R%';

-- ESERCIZIO 3 --
/*Visualizzare i titolo di ogni mostra ancora in corso e quanti giorni rimane ancora aperta a partire dalla data
corrente. Usare la costante CURRENT_DATE per avere la data corrente.*/
SELECT titolo, (fine - CURRENT_DATE)
FROM Mostra
WHERE fine > CURRENT_DATE;

-- ESERCIZIO 4 --
/*Visualizzare per ogni museo l’orario di apertura e chiusura il martedì. Se per un museo il martedì è giorno di
chiusura, non mostrare nulla.*/

SELECT Museo.Nome, Museo.giornoChiusura, Orario.giorno, Orario.orarioApertura, Orario.orarioChiusura
FROM Museo, Orario
WHERE Museo.Nome = Orario.Museo AND Museo.giornoChiusura <> 'MAR' AND Orario.giorno = 'MAR';

-- oppure --

SELECT Museo.Nome, Museo.giornoChiusura, Orario.giorno, Orario.orarioApertura, Orario.orarioChiusura
FROM Museo
JOIN Orario ON Museo.Nome = Orario.Museo
WHERE Museo.giornoChiusura <> 'MAR' AND Orario.giorno = 'MAR';

-- ESERCIZIO 5 --
/*Assicurarsi che almeno una mostra abbia il prezzo ridotto non valorizzato (NULL) usando eventualmente il
comando UPDATE per modificare almeno una riga.*/
UPDATE Mostra SET prezzoRidotto = NULL WHERE titolo = 'Esposizione di Van Gogh';
SELECT * FROM Mostra WHERE prezzoRidotto = NULL; -- SINTASSI ERRATA
SELECT * FROM Mostra WHERE prezzoRidotto IS NULL; -- SINTASSI CORRETTA

-- ESERCIZIO 6 --
-- Visualizzare tutte le mostre non terminate in ordine di data inizio e, in caso di pari data inizio, data fine.
SELECT *
FROM Mostra
WHERE fine > CURRENT_DATE
ORDER BY inizio, fine;

-- ESERCIZIO 7 --
-- Visualizzare il numero totale di giorni di apertura del museo ’Arena’ di ’Verona’.
SELECT COUNT(*)
FROM ORARIO WHERE museo = 'Arena' AND città = 'Verona';

-- ESERCIZIO 8 --
/*Visualizzare le ore medie di apertura del museo ’Arena’ di ’Verona’.
Suggerimento: convertire orarioapertura e orariochiusure usando ’::time’.*/
SELECT AVG(orarioChiusura::time - orarioApertura::time)
FROM Orario
WHERE museo = 'Arena' AND città = 'Verona';

-- ESERCIZIO 9 --
-- Indicare il numero di autori distinti presenti in tutti i musei.
SELECT DISTINCT (nomeAutore)
FROM Opera;