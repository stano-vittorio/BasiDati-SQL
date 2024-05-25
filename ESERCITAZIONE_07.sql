-- ESERCIZIO 1 --
/* Si assume che la tabella Museo possa essere aggiornata da applicazioni diverse, non sincronizzate fra loro.
Scrivere una transazione che aggiunga un museo e dimostrare cosa succede se due applicazioni aggiungono
lo stesso museo nello stesso istante usando lo schema della transazione proposta. */
BEGIN ;
INSERT INTO Museo( id, nome, citta, prezzo, prezzoRidotto ) VALUES
(5, 'Museo di Verona', 'Verona', 40.00 , 15.00);
COMMIT;

-- ESERCIZIO 2 --
/* Si assuma che una transazione deve visualizzare i prezzi dei musei di Verona che hanno parte decimale
diversa da 0 e, poi, aggiornare tali prezzi del 10% arrotondando alla seconda cifra decimale. L’altra
transazione (concorrente) deve aggiornare il prezzo dei musei di Verona aumentandoli del 10% e
arrotondando alla seconda cifra decimale. */
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM Museo
WHERE prezzo <> ceil ( prezzo ) AND citta ILIKE 'Verona';

UPDATE Museo SET prezzo = round( prezzo * 1.10, 2 )
WHERE prezzo <> ceil ( prezzo ) AND citta ILIKE 'Verona' ;

COMMIT;

BEGIN;
UPDATE Museo SET prezzo = round ( prezzo * 1.10, 2 )
WHERE citta ILIKE 'Verona';
COMMIT;

-- ESERCIZIO 3 --
/* In una transazione si deve inserire una nuova mostra al museo di Castelvecchio di Verona con prezzo
d’ingresso a 40 euro e prezzo ridotto a 20. Nell’altra transazione (concorrente) si deve calcolare il prezzo
medio delle mostre di Verona prima considerando solo i prezzi ordinari e, in un’interrogazione separata,
considerando solo i prezzi ridotti. */
INSERT INTO Mostra( titolo, inizio, fine, museo, citta, prezzoIntero, prezzoRidotto )
VALUES( 'Mostra Scaligera', '2017-02-12', '2017-11-30', 'CastelVecchio', 'Verona', 40.00 , 20.00) ;

BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT AVG ( prezzoIntero ) FROM Mostra WHERE citta ILIKE 'Verona';
SELECT AVG ( prezzoRidotto ) FROM Mostra WHERE citta ILIKE 'Verona';
COMMIT;

-- ESERCIZIO 4 --
/* In una transazione si deve aumentare il prezzo intero di tutte le mostre di Verona del 10% mentre, nell’altra,
si devono ridurre i prezzi ridotti di tutte le mostre del 5%. In entrambi i casi, l’importo finale si deve
arrotondare alla seconda cifra decimale. */
UPDATE Mostra SET prezzoIntero = round ( prezzoIntero * 1.10 , 2)
WHERE citta ILIKE 'Verona';

UPDATE Mostra SET prezzoRidotto = round ( prezzoRidotto * 0.95 , 2)
WHERE citta ILIKE 'Verona';

-- ESERCIZIO 5 --
/* In una transazione, calcolare la media dei prezzi dei musei di Vicenza ed aggiungere un nuovo museo a
Verona (’Museo moderno’) con prezzo uguale alla media calcolata. In un’altra transazione calcolare la media
dei prezzi dei musei di Verona e aggiungere un nuovo museo a Vicenza con prezzo uguale alla media
calcolata sui musei di Verona.

Si segnala che:
1. Con SELECT si possono anche creare colonne con valori costanti.
Esempio: SELECT ’Museo Moderno’, ’Verona’, ecc FROM ...
2. INSERT accetta di inserire anche risultati ottenuti da SELECT interne.
Esempio: INSERT INTO Museo (nome, citta, ...) SELECT ’Museo Moderno’, ’Verona’, ... FROM... */
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
INSERT INTO Museo( nome, citta, prezzo )
	SELECT 'Museo Preistorico di Verona', 'Verona', AVG( prezzo )
	FROM Museo WHERE citta ILIKE 'Vicenza';
COMMIT;

BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
INSERT INTO Musei( nome, citta, prezzo )
	SELECT 'Museo provinciale di Vicenza', 'Vicenza', AVG ( prezzo )
	FROM Musei WHERE citta ILIKE 'Verona';
COMMIT;