-- ESERCIZIO 1 --
-- Visualizzare il numero di corso studi presenti nella base di dati.
-- Soluzione: ci sono 635 corsi di studio.
SELECT COUNT(*)
FROM CorsoStudi;

-- ESERCIZIO 2 --
-- Visualizzare il nome, il codice, l’indirizzo e l’identificatore del preside di tutte le facoltà.
-- Soluzione: ci sono 8 facoltà.
SELECT nome, codice, indirizzo, id_preside_persona
FROM Facolta;

-- ESERCIZIO 3 --
/* Trovare per ogni corso di studi che ha erogato insegnamenti nel 2010/2011 il suo nome e il nome delle
facoltà che lo gestiscono (si noti che un corso può essere gestito da più facoltà). Non usare la relazione
diretta tra InsErogato e Facoltà. Porre i risultati in ordine di nome corso studi.
Soluzione: ci sono 211 righe. */
SELECT DISTINCT cs.nome, f.nome
FROM CorsoStudi AS cs
JOIN InsErogato AS ie ON cs.id = ie.id_corsostudi
JOIN CorsoInFacolta AS cif ON cs.id = cif.id_corsostudi
JOIN Facolta AS f ON cif.id_facolta = f.id
WHERE ie.annoaccademico = '2010/2011'
ORDER BY cs.nome;

-- ESERCIZIO 4 --
-- Visualizzare il nome, il codice e l’abbreviazione di tutti i corsi di studio gestiti dalla facoltà di Medicina e Chirurgia.
-- Soluzione: ci sono 236 righe.
SELECT cs.nome, cs.codice, cs.abbreviazione
FROM CorsoStudi AS cs
JOIN CorsoInFacolta AS cif ON cs.id = cif.id_corsostudi
JOIN Facolta AS f ON cif.id_facolta = f.id
WHERE f.nome = 'Medicina e Chirurgia';

-- ESERCIZIO 5 --
/* Visualizzare il codice, il nome e l’abbreviazione di tutti corsi di studio che nel nome contengono la
sottostringa ’lingue’ (eseguire il confronto usando ILIKE invece di LIKE: in questo modo i caratteri maiuscolo
e minuscolo non sono diversi).
Soluzione: ci sono 16 righe. */
SELECT codice, nome, abbreviazione
FROM CorsoStudi
WHERE nome ILIKE '%lingue%';

-- ESERCIZIO 6 --
-- Visualizzare le sedi dei corsi di studi in un elenco senza duplicati.
-- Soluzione: ci sono 48 righe.
SELECT DISTINCT sede
FROM CorsoStudi;

-- ESERCIZIO 7 --
/* Visualizzare solo i moduli degli insegnamenti erogati nel 2010/2011 nei corsi di studi della facoltà di Economia.
Si visualizzi il nome dell’insegnamento, il discriminante (attributo descrizione della tabella Discriminante), il
nome del modulo e l’attributo modulo.
Soluzione: ci sono 27 righe. */
SELECT i.nomeins, d.descrizione, ie.nomemodulo, ie.modulo
FROM InsErogato AS ie
JOIN Insegn AS i ON ie.id_insegn = i.id
JOIN CorsoInFacolta AS cif ON ie.id_corsostudi = cif.id_corsostudi
JOIN Facolta AS f ON cif.id_facolta = f.id
JOIN Discriminante AS d ON ie.id_discriminante = d.id
WHERE ie.annoaccademico = '2010/2011' AND f.nome = 'Economia' AND ie.modulo > 0;

-- ESERCIZIO 8 --
/* Visualizzare il nome e il discriminante (attributo descrizione della tabella Discriminante) degli insegnamenti
erogati nel 2009/2010 che non sono moduli o unità logistiche e che hanno 3, 5 o 12 crediti. Si ordini il
risultato per discriminante.
Soluzione: ci sono 724 righe distinte. */
SELECT DISTINCT i.nomeins, d.descrizione
FROM InsErogato AS ie
JOIN Insegn AS i ON i.id = ie.id_insegn
JOIN Discriminante AS d ON ie.id_discriminante = d.id
WHERE ie.annoaccademico = '2009/2010' AND ie.modulo = 0 AND ie.crediti IN (3,5,12)
ORDER BY d.descrizione;

-- ESERCIZIO 9 --
/* Visualizzare l’identificatore, il nome e il discriminante degli insegnamenti erogati nel 2008/2009 che non
sono moduli o unità logistiche e con peso maggiore di 9 crediti. Ordinare per nome.
Soluzione : ci sono 1218 righe. */
SELECT i.id, i.nomeins, d.descrizione
FROM InsErogato AS ie
JOIN Insegn AS i ON i.id = ie.id_insegn
JOIN Discriminante AS d ON d.id = ie.id_discriminante
WHERE ie.annoaccademico = '2008/2009' AND ie.crediti > 9 AND ie.modulo = 0
ORDER BY i.nomeins;

-- ESERCIZIO 10 --
/* Visualizzare in ordine alfabetico di nome degli insegnamenti (esclusi i moduli e le unità logistiche) erogati nel
2010/2011 nel corso di studi in Informatica, riportando il nome, il discriminante, i crediti e gli anni di erogazione.
Soluzione: ci sono 26 righe. */
SELECT i.nomeins, d.descrizione, ie.crediti, ie.annierogazione
FROM InsErogato AS ie
JOIN Insegn AS i ON i.id = ie.id_insegn
JOIN Discriminante AS d ON d.id = ie.id_discriminante
JOIN CorsoStudi AS cs ON cs.id = ie.id_corsostudi
WHERE ie.annoaccademico = '2010/2011' AND cs.nome = 'Laurea in Informatica' AND ie.modulo = 0
ORDER BY i.nomeins;

-- ESERCIZIO 11 --
-- Trovare il massimo numero di crediti associato a un insegnamento fra quelli erogati nel 2010/2011.
-- Soluzione: 180
SELECT MAX(crediti)
FROM InsErogato AS ie
WHERE ie.annoaccademico = '2010/2011';

-- ESERCIZIO 12 --
-- Trovare, per ogni anno accademico, il massimo e il minimo numero di crediti erogati tra gli insegnamenti dell’anno.
-- Soluzione: ci sono 16 righe.
SELECT annoaccademico, MAX(crediti), MIN(crediti)
FROM InsErogato
GROUP BY annoaccademico
ORDER BY annoaccademico;

-- ESERCIZIO 13 --
/* Trovare, per ogni anno accademico e per ogni corso di studi la somma dei crediti erogati (esclusi i moduli e
le unità logistiche: vedi nota sopra) e il massimo e minimo numero di crediti degli insegnamenti erogati
sempre escludendo i moduli e le unità logistiche.
Soluzione: ci sono 1587 righe. Le riga relativa alla "Scuola di Specializzazione in Urologia (Vecchio
ordinamento)" nell’anno 2011/2012 ha valori 52.00, 10.00 e 162.00. */
SELECT ie.annoaccademico, cs.nome, SUM(crediti), MAX(crediti), MIN(crediti)
FROM InsErogato AS ie
JOIN CorsoStudi AS cs ON cs.id = ie.id_corsostudi
WHERE ie.modulo = 0
GROUP BY ie.annoaccademico, cs.id, cs.nome;

-- ESERCIZIO 14 --
/* Trovare per ogni corso di studi della facoltà di Scienze Matematiche Fisiche e Naturali il numero di
insegnamenti (esclusi i moduli e le unità logistiche) erogati nel 2009/2010.
Soluzione: ci sono 19 righe. */
SELECT cs.nome, COUNT(*)
FROM InsErogato AS ie
JOIN CorsoStudi AS cs ON cs.id = ie.id_corsostudi
JOIN CorsoInFacolta AS cif ON cif.id_corsostudi = cs.id
JOIN Facolta AS f ON f.id = cif.id_facolta
WHERE LOWER(F.nome) = 'scienze matematiche fisiche e naturali' AND ie.modulo = 0 AND ie.annoaccademico = '2009/2010'
GROUP BY cs.nome;

-- ESERCIZIO 15 --
/* Trovare i corsi di studi che nel 2010/2011 hanno erogato insegnamenti con un numero di crediti pari a 4 o
6 o 8 o 10 o 12 o un numero di crediti di laboratorio tra 10 e 15 escluso, riportando il nome del corso di
studi e la sua durata. Si ricorda che i crediti di laboratorio sono rappresentati dall’attributo creditilab della
tabella InsErogato.
Soluzione: ci sono 197 righe. */
SELECT DISTINCT cs.nome, cs.durataAnni
FROM InsErogato AS ie
JOIN CorsoStudi AS cs ON cs.id = ie.id_corsostudi
WHERE ie.annoaccademico = '2010/2011' AND (ie.crediti IN (4,6,8,10,12) OR (ie.creditiLab >= 10 AND ie.creditiLab <= 15));