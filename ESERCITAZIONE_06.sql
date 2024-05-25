-- ESERCIZIO 1 --
/* Visualizzare in nomi dei corsi di studio che finiscono con la stringa ’informatica’ senza considerare
maiuscole/minuscole. */
EXPLAIN SELECT nome
FROM corsostudi
WHERE nome ILIKE '%informatica';

-- NO INDICE CON % ALL'INIZIO

-- ESERCIZIO 2 --
/* Visualizzare in nomi degli insegnamenti che iniziano per ’Teoria...’ */
EXPLAIN SELECT nomeins
FROM insegn
WHERE nomeins LIKE 'Teoria%';

/* operatore LIKE può usare solo indici creati con l’opzione
varchar_pattern_ops quando il 'collate' del base di dati è diverso da 'C */
-- CREO INDICE SU nomeins

CREATE INDEX ON insegn(nomeins varchar_pattern_ops);
ANALYZE insegn;
EXPLAIN SELECT nomeins
FROM insegn
WHERE nomeins LIKE 'Teoria%';

-- ESERCIZIO 3 --
/* Trovare, per ogni insegnamento erogato dell’a.a. 2013/2014, il suo nome e id della facoltà che lo gestisce
usando la relazione assorbita con facoltà. */
EXPLAIN SELECT DISTINCT i.nomeins, ie.id_facolta
FROM insegn i
	JOIN inserogato ie ON(ie.id_insegn = i.id)
WHERE annoaccademico = '2013/2014';

-- CREO INDICE SU annoaccademico

CREATE INDEX ON inserogato(annoaccademico);
ANALYZE inserogato;

EXPLAIN SELECT DISTINCT i.nomeins, ie.id_facolta
FROM insegn i
	JOIN inserogato ie ON(ie.id_insegn = i.id)
WHERE annoaccademico = '2013/2014';

-- CREO INDICE TIPO HASH SU insegn.id

CREATE INDEX ON insegn USING hash(id);
ANALYZE insegn;

EXPLAIN SELECT DISTINCT i.nomeins, ie.id_facolta
FROM insegn i
	JOIN inserogato ie ON(ie.id_insegn = i.id)
WHERE annoaccademico = '2013/2014';

-- ESERCIZIO 4 --
/* Visualizzare il codice, il nome e l’abbreviazione di tutti corsi di studio che nel nome contengono la
sottostringa ’lingue’ (eseguire un test case-insensitive: usare ILIKE invece di LIKE). */
EXPLAIN SELECT cs.codice, cs.abbreviazione
FROM corsostudi cs
WHERE cs.nome ILIKE '%lingue%';

-- NO INDICE CON % ALL'INIZIO

-- ESERCIZIO 5 --
/* Visualizzare identificatori e numero modulo dei moduli reali (modulo>0) degli insegnamenti erogati nel
2010/2011 associati alla facoltà con id=7 tramite la relazione diretta. */
EXPLAIN SELECT ie.id, ie.modulo
FROM inserogato ie
WHERE ie.annoaccademico = '2010/2011'
	AND ie.id_facolta = 7
	AND ie.modulo > 0;

-- CREO INDICE SU if_facolta

CREATE INDEX ON inserogato(id_facolta);
ANALYZE inserogato;

EXPLAIN SELECT ie.id, ie.modulo
FROM inserogato ie
WHERE ie.annoaccademico = '2010/2011'
	AND ie.id_facolta = 7
	AND ie.modulo > 0;
	
-- CREO INDICE SU modulo

CREATE INDEX ON inserogato(modulo);
ANALYZE inserogato;

EXPLAIN SELECT ie.id, ie.modulo
FROM inserogato ie
WHERE ie.annoaccademico = '2010/2011'
	AND ie.id_facolta = 7
	AND ie.modulo > 0;
	
-- CREO INDICE SU 3 ATTRIBUTI

CREATE INDEX ON inserogato(annoaccademico, id_facolta, modulo);
ANALYZE inserogato;

EXPLAIN SELECT ie.id, ie.modulo
FROM inserogato ie
WHERE ie.annoaccademico = '2010/2011'
	AND ie.id_facolta = 7
	AND ie.modulo > 0;

-- ESERCIZIO 6 --
/* Visualizzare il nome e il discriminante (attributo descrizione della tabella Discriminante) degli insegnamenti
erogati nel 2009/2010 che non sono moduli e che hanno 3, 5 o 12 crediti. */
EXPLAIN SELECT DISTINCT i.nomeins, d.descrizione
FROM insegn i
	JOIN inserogato ie ON (ie.id_insegn = i.id)
	JOIN discriminante d ON (d.id = ie.id_discriminante)
WHERE ie.annoaccademico = '2009/2010'
	AND ie.modulo = 0
	AND ie.crediti IN (3,5,12);
	
-- CREO INDICE SU 3 ATTRIBUTI

CREATE INDEX ON inserogato(annoaccademico, crediti, modulo);
ANALYZE inserogato;

EXPLAIN SELECT DISTINCT i.nomeins, d.descrizione
FROM insegn i
	JOIN inserogato ie ON (ie.id_insegn = i.id)
	JOIN discriminante d ON (d.id = ie.id_discriminante)
WHERE ie.annoaccademico = '2009/2010'
	AND ie.modulo = 0
	AND ie.crediti IN (3,5,12);

-- CREO UN INDICE HASH SU insegn.id

CREATE INDEX ON insegn USING hash(id);
ANALYZE insegn;

EXPLAIN SELECT DISTINCT i.nomeins, d.descrizione
FROM insegn i
	JOIN inserogato ie ON (ie.id_insegn = i.id)
	JOIN discriminante d ON (d.id = ie.id_discriminante)
WHERE ie.annoaccademico = '2009/2010'
	AND ie.modulo = 0
	AND ie.crediti IN (3,5,12);
	
-- CREO 3 INDICI SEPARATI MA NON SI OTTENGONO LE STESSE PRESTAZIONI

EXPLAIN SELECT DISTINCT i.nomeins, d.descrizione
FROM insegn i
	JOIN inserogato ie ON (ie.id_insegn = i.id)
	JOIN discriminante d ON (d.id = ie.id_discriminante)
WHERE ie.annoaccademico = '2009/2010'
	AND ie.modulo = 0
	AND ie.crediti IN (3,5,12);
	
-- ESERCIZIO 7 --
/* Visualizzare il nome e il discriminante degli insegnamenti erogati nel 2008/2009 senza moduli e con crediti
maggiore di 9. */
SELECT DISTINCT i.nomeins, d.descrizione
FROM inserogato ie
	JOIN discriminante d ON (d.id = ie.id_discriminante)
	JOIN insegn i ON (i.id = ie.id_insegn)
WHERE ie.annoaccademico = '2008/2009'
	AND ie.hamoduli = '0'
	AND ie.crediti > 9;
	
-- INDICI

CREATE INDEX ON inserogato(annoaccademico, hamoduli, crediti);
ANALYZE inserogato;

CREATE INDEX ON insegn USING hash(id);
ANALYZE insegn;

-- ESERCIZIO 8 --
/* Visualizzare in ordine alfabetico di nome degli insegnamenti (esclusi di moduli e le unità logistiche) erogati
nel 2013/2014 nel corso di 'Laurea in Informatica', riportando il nome, il discriminante, i crediti e gli anni di
erogazione. */
SELECT I.nomeins, D.descrizione, IE.crediti, IE.annierogazione
FROM InsErogato IE
	JOIN Discriminante D ON IE.id_discriminante = D.id
	JOIN Insegn I ON IE. id_insegn = I.id
	JOIN CorsoStudi CS ON CS.id = IE.id_corsostudi
WHERE IE.modulo = 0
	AND IE.annoaccademico = '2013/2014'
	AND CS.nome = 'Laurea in informatica'
ORDER BY I. nomeins;

-- INDICI

CREATE INDEX ON InsErogato USING hash( id_corsostudi );
ANALYZE InsErogato;

CREATE INDEX ON Insegn USING hash(id);
ANALYZE Insegn;

CREATE INDEX ON Discriminante USING hash(id);
ANALYZE Discriminante;

CREATE INDEX ON InsErogato( annoaccademico , modulo );
ANALYZE InsErogato;

CREATE INDEX ON CorsoStudi( nome );
ANALYZE CorsoStudi;

-- ESERCIZIO 9 --
-- Trovare il massimo numero di crediti degli insegnamenti erogati dall’ateneo nell’a.a. 2013/2014.
SELECT MAX(IE.crediti)
FROM InsErogato IE
WHERE IE.annoaccademico = '2013/2014';

-- INDICI

CREATE INDEX ON InsErogato ( annoaccademico );
ANALYZE InsErogato;

-- ESERCIZIO 10 --
-- Trovare, per ogni anno accademico, il massimo e il minimo numero di crediti erogati in un insegnamento.
SELECT IE.annoaccademico, MAX(IE.crediti), MIN(IE.crediti)
FROM InsErogato IE
GROUP BY IE.annoaccademico
ORDER BY IE.annoaccademico;

-- INDICI

EXPLAIN SELECT IE.annoaccademico, MAX(IE.crediti), MIN(IE.crediti)
FROM InsErogato IE
GROUP BY IE.annoaccademico
ORDER BY IE.annoaccademico;

-- ESERCIZIO 11 --
/* Trovare il nome dei corsi di studio che non hanno mai erogato insegnamenti che contengono nel nome la
stringa 'matematica' (usare ILIKE invece di LIKE per rendere il test non sensibile alle maiuscole/minuscole). */
SELECT DISTINCT CS.nome
FROM CorsoStudi CS
WHERE CS.id NOT IN (
	SELECT DISTINCT IE.id_corsostudi
	FROM InsErogato IE JOIN INSEGN I ON I.id = IE.id_insegn
	WHERE I. nomeins ILIKE '% matematica %');
	
-- INDICI

CREATE INDEX ON Insegn USING hash(id);
ANALYZE Insegn;

CREATE INDEX ON InsErogato USING hash(id_insegn);
ANALYZE InsErogato;

-- ESERCIZIO 12 --
/* Trovare, per ogni anno accademico e per ogni corso di laurea, la somma dei crediti erogati (esclusi i moduli e
le unità logistiche: vedi nota sopra) e il massimo e minimo numero di crediti degli insegnamenti erogati
sempre escludendo i moduli e le unità logistiche. */
EXPLAIN SELECT IE.annoaccademico, CS.nome , SUM(IE.crediti), MAX(IE.crediti), MIN(IE.crediti)
FROM InsErogato IE
	JOIN CorsoStudi CS ON IE.id_corsostudi = CS.id
WHERE IE.modulo = 0
GROUP BY IE.annoaccademico, CS.nome;