-- ESERCIZIO 1 --
/* Trovare nome, cognome dei docenti che nell’anno accademico 2010/2011 erano docenti in almeno due
corsi di studio (vale a dire erano docenti in almeno due insegnamenti o moduli A e B dove A è del corso C1
e B è del corso C2 con C1 6= C2).
La soluzione ha 839 righe. Se si ordina la risposta per un opportuno attributo */
SELECT p.id, p.nome, p.cognome
FROM Persona AS p
	JOIN Docenza AS d ON (p.id = d.id_persona)
	JOIN InsErogato AS ie ON (d.id_inserogato = ie.id)
WHERE ie.annoaccademico = '2010/2011'
GROUP BY p.id, p.nome, p.cognome
HAVING COUNT(DISTINCT ie.id_corsostudi) > 1
ORDER BY p.id;

-- ESERCIZIO 2 --
/* Trovare identificatore, cognome e nome dei docenti che, nell’anno accademico 2010/2011, hanno tenuto
un insegnamento (l’attributo da confrontare è nomeins) che non hanno tenuto nell’anno accademico
precedente. Ordinare la soluzione per identificatore.
La soluzione ha 1031 righe */
SELECT DISTINCT p1.id, p1.nome, p1.cognome
FROM Persona AS p1
	JOIN Docenza AS d1 ON (p1.id = d1.id_persona)
	JOIN InsErogato AS ie1 ON (ie1.id = d1.id_inserogato)
	JOIN Insegn AS i1 ON (i1.id = ie1.id_insegn)
WHERE ie1.annoaccademico = '2010/2011' AND d1.id_persona NOT IN
	(SELECT d2.id_persona
	FROM Docenza AS d2
		JOIN InsErogato AS ie2 ON (ie2.id = d2.id_inserogato)
		JOIN Insegn AS i2 ON (i2.id = ie2.id_insegn)
	WHERE ie2.annoaccademico = '2009/2010' AND i2.nomeins = i1.nomeins)
ORDER BY p1.id;

-- ESERCIZIO 3 --
/* Trovare per ogni periodo di lezione del 2010/2011 la cui descrizione inizia con ’I semestre’ o ’Primo
semestre’ il numero di occorrenze di insegnamento allocate in quel periodo. Si visualizzi quindi:
l’abbreviazione, il discriminante, inizio, fine e il conteggio richiesto ordinati rispetto all’inizio e fine.
La soluzione ha 3 righe */
SELECT pl.abbreviazione, pd.discriminante, pd.inizio, pd.fine, COUNT(ip.id_inserogato) as numins
FROM PeriodoLez AS pl
	JOIN PeriodoDid AS pd ON (pl.id = pd.id)  
	JOIN InsInPeriodo AS ip ON (ip.id_periodolez = pd.id)
WHERE PD.descrizione IN ('I semestre','Primo semestre') AND pd.annoaccademico = '2010/2011'
GROUP BY pl.abbreviazione, pd.discriminante, pd.inizio, pd.fine 
ORDER BY pd.inizio, pd.fine;

-- ESERCIZIO 4 --
/* Trovare i corsi di studio che non sono gestiti dalla facoltà di “Medicina e Chirurgia” e che hanno insegnamenti
erogati con moduli nel 2010/2011. Si visualizzi il nome del corso e il numero di insegnamenti erogati con
moduli nel 2010/2011.
Soluzione: ci sono 33 righe */
SELECT cs.nome, COUNT(ie.id) as num_ins
FROM CorsoStudi AS cs
	JOIN InsErogato AS ie ON (ie.id_corsostudi = cs.id)
WHERE ie.annoaccademico = '2010/2011' AND ie.hamoduli <> '0' AND cs.id NOT IN
	(SELECT cs1.id
	 FROM CorsoStudi AS cs1 
     JOIN CorsoInFacolta AS cif ON (cs1.id = cif.id_corsostudi)
     JOIN Facolta AS f ON (f.id = cif.id_facolta)
     WHERE f.nome = 'Medicina e Chirurgia')
GROUP BY cs.nome
ORDER BY cs.nome;

-- ESERCIZIO 5 --
/* Trovare gli insegnamenti del corso di studi con id=4 che non sono mai stati offerti al secondo quadrimestre.
Per selezionare il secondo quadrimestre usare la condizione "abbreviazione LIKE '2%'".
La soluzione ha 14 righe */
SELECT DISTINCT i1.nomeins
FROM Insegn AS i1
	JOIN InsErogato AS ie1 ON (ie1.id_insegn = i1.id)
	JOIN CorsoStudi AS cs1 ON (ie1.id_corsostudi = cs1.id)
WHERE cs1.id = 4 AND i1.id NOT IN
	(SELECT i2.id
	 FROM Insegn AS i2
	 	JOIN InsErogato AS ie2 ON (ie2.id_insegn = i2.id)
     	JOIN CorsoStudi AS cs2 ON (ie2.id_corsostudi = cs2.id)
     	JOIN InsInPeriodo AS iip2 ON (iip2.id_inserogato = ie2.id)
     	JOIN PeriodoLez AS pl2 ON (iip2.id_periodolez = pl2.id)
	 WHERE cs2.id = 4 AND pl2.abbreviazione LIKE '2%');

-- ESERCIZIO 6 --
/* Trovare il nome dei corsi di studio che non hanno mai erogato insegnamenti che contengono nel nome la
stringa ’matematica’ (usare ILIKE invece di LIKE per rendere il test non sensibile alle maiuscole/minuscole
(case-insensitive)).
La soluzione ha 572 righe */
SELECT cs1.nome
FROM CorsoStudi AS cs1 
WHERE cs1.id NOT IN
	(SELECT cs2.id
	 FROM Insegn AS i2
   	 	JOIN InsErogato AS ie2 ON ie2.id_insegn = i2.id
     	JOIN CorsoStudi AS cs2 ON ie2.id_corsostudi = cs2.id
     WHERE i2.nomeins ILIKE '%matematica%');

-- ESERCIZIO 7 --
/* Trovare per ogni segreteria che serve almeno un corso di studi il numero di corsi di studi serviti, riportando il
nome della struttura, il suo numero di fax e il conteggio richiesto.
La soluzione ha 42 righe */
SELECT s.nomestruttura, s.fax, COUNT(cs.id) AS numcorsi
FROM StrutturaServizio AS s
	JOIN CorsoStudi AS cs ON (cs.id_segreteria = s.id)
GROUP BY s.nomestruttura, s.fax;