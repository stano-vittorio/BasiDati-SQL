DROP TABLE IF EXISTS Museo CASCADE;
DROP TABLE IF EXISTS Mostra CASCADE;
DROP TABLE IF EXISTS Opera CASCADE;
DROP TABLE IF EXISTS Orario CASCADE;
DROP DOMAIN IF EXISTS giorniSettimana;

-- ESERCIZIO 1 --
/*Scrivere il codice PostgreSQL che generi tutte le tabelle. Per gli attributi di cui non è stato specificato il tipo,
scegliere quello opportuno. Specificare tutti i vincoli possibili, sia intra- sia inter-relazionali.*/
CREATE DOMAIN giorniSettimana AS CHAR(3)
	CHECK(VALUE IN ('LUN', 'MAR', 'MER', 'GIO', 'VEN', 'SAB', 'DOM'));

CREATE TABLE Museo (
	nome VARCHAR(30) DEFAULT 'MuseoVeronese',
	città VARCHAR(20) DEFAULT 'Verona',
	indirizzo VARCHAR(100),
	numeroTelefono VARCHAR(20) CHECK (numeroTelefono SIMILAR TO '\+?[0-9]+'), -- CHECK OPZIONALE
	giornoChiusura giorniSettimana NOT NULL,
	prezzo DECIMAL(10,2) NOT NULL DEFAULT 10.00 CHECK (prezzo > 0), -- CHECK OPZIONALE
	PRIMARY KEY(nome, città)
);

CREATE TABLE Mostra(
	titolo VARCHAR(30),
	inizio DATE,
	fine DATE NOT NULL,
	museo VARCHAR(30),
	città VARCHAR(20),
	FOREIGN KEY(museo, città) REFERENCES Museo(nome, città),
	prezzo NUMERIC(10,2) CHECK (prezzo > 0), -- CHECK OPZIONALE
	PRIMARY KEY(titolo, inizio)
);

CREATE TABLE Opera(
	nome VARCHAR(30),
	cognomeAutore VARCHAR(20),
	nomeAutore VARCHAR(20),
	museo VARCHAR(30),
	città VARCHAR(20),
	FOREIGN KEY(museo, città) REFERENCES Museo(nome, città),
	epoca VARCHAR(20),
	anno INTEGER CHECK (anno > 0 AND anno < 2050), -- CHECK OPZIONALE
	PRIMARY KEY(nome, cognomeAutore, nomeAutore)
);

CREATE TABLE Orario(
	progressivo SERIAL PRIMARY KEY,
	museo VARCHAR(30) NOT NULL,
	città VARCHAR(20) NOT NULL,
	FOREIGN KEY(museo, città) REFERENCES Museo(nome, città),
	giorno giorniSettimana NOT NULL,
	orarioApertura TIME WITH TIME ZONE DEFAULT '09:00 CET',
	orarioChiusura TIME WITH TIME ZONE DEFAULT '19:00 CET'
);

-- ESERCIZIO 2 --
/*Inserire nell’entità Museo le seguenti tuple:
(Arena, Verona, piazza Bra, 045 8003204, martedì, 20),
(CastelVecchio, Verona, Corso Castelvecchio, 045 594734, lunedì, 15);*/
INSERT INTO Museo(nome, città, indirizzo, numeroTelefono, giornoChiusura, prezzo)
VALUES ('Arena', 'Verona', 'Piazza Bra', '0458003204', 'MAR', 20),
	   ('CastelVecchio', 'Verona', 'Corso Castelvecchio', '045594734', 'LUN', 15);
	
-- ESERCIZIO 3 --
-- Popolare le tabelle Opera e Mostra con almeno altre tre tuple ciascuna.
INSERT INTO Opera(nome, cognomeAutore, nomeAutore, museo, città, epoca, anno)
VALUES ('La notte stellata', 'Van Gogh', 'Vincent', 'CastelVecchio', 'Verona', 'Post-Impressionismo', 1889),
       ('Il David', 'Buonarroti', 'Michelangelo', 'CastelVecchio', 'Verona', 'Rinascimento', 1504),
       ('Il bacio', 'Klimt', 'Gustav', 'CastelVecchio', 'Verona', 'Simbolismo', 1908),
       ('La Gioconda', 'da Vinci', 'Leonardo', 'Arena', 'Verona', 'Rinascimento', 1503),
       ('Ragazza con orecchino di perla', 'Vermeer', 'Johannes', 'Arena', 'Verona', 'Barocco', 1665),
       ('La Primavera', 'Botticelli', 'Sandro', 'Arena', 'Verona', 'Rinascimento', 1482),
       ('Nascita di Venere', 'Botticelli', 'Sandro', 'Arena', 'Verona', 'Rinascimento', 1484);
	   
INSERT INTO Mostra(titolo, inizio, fine, museo, città, prezzo)
VALUES ('Esposizione di Van Gogh', '2024-07-01', '2024-09-30', 'CastelVecchio', 'Verona', 25.00),
       ('Capolavori Rinascimentali', '2024-10-01', '2024-12-31', 'CastelVecchio', 'Verona', 30.00),
       ('Mostra di Gustav Klimt', '2025-01-01', '2025-03-31', 'CastelVecchio', 'Verona', 20.00),
       ('Mostra di Leonardo da Vinci', '2024-05-01', '2024-08-31', 'Arena', 'Verona', 25.00),
       ('Esposizione di Vermeer', '2024-09-01', '2024-12-31', 'Arena', 'Verona', 30.00),
       ('Mostra di Sandro Botticelli', '2025-01-01', '2025-04-30', 'Arena', 'Verona', 20.00),
       ('Mostra di Botticelli', '2025-05-01', '2025-08-31', 'Arena', 'Verona', 25.00);
	   
-- ESERCIZIO 4 --
-- Provare ad inserire nella relazione Museo tuple che violino i vincoli specificati.
/*INSERT INTO Museo(nome, città, indirizzo, numeroTelefono, giornoChiusura, prezzo)
VALUES ('Arena', 'Verona', 'Nuova piazza', '0458003204', 'giovedì', 20), -- DUPLICATO
	   ('Museo di Storia Naturale di Verona', 'Verona', 'Via Lunga, 123', '0458003204', 'martedì', 20); -- > LIMITE*/
	   
-- ESERCIZIO 5 --
-- Nell’entità Museo, aggiungere l’attributo sitoInternet e inserire gli opportuni valori.
ALTER TABLE Museo ADD COLUMN sitoInternet VARCHAR(100);
UPDATE Museo SET sitoInternet = 'http://www.museoarena.it' WHERE nome = 'Arena' AND città = 'Verona';
UPDATE Museo SET sitoInternet = 'http://www.museocastelvecchio.it' WHERE nome = 'CastelVecchio' AND città = 'Verona';
	
-- ESERCIZIO 6 --
/*Nell’entità Mostra modificare l’attributo prezzo in prezzoIntero ed aggiungere l’attributo prezzoRidotto con
valore di default 5. Aggiungere il vincolo (di tabella o di attributo?) che garantisca che Mostra.prezzoRidotto
sia minore di Mostra.prezzoIntero.*/
ALTER TABLE Mostra RENAME COLUMN prezzo TO prezzoIntero;
ALTER TABLE Mostra ADD COLUMN prezzoRidotto NUMERIC(8,2) DEFAULT 5.00;
ALTER TABLE Mostra ADD CONSTRAINT prezzo_ridotto_inferiore CHECK (prezzoRidotto < prezzoIntero);

-- ESERCIZIO 7 --
-- Nell’entità Museo aggiornare il prezzo aggiungendo 1 Euro alle tuple esistenti.
UPDATE Museo SET prezzo = prezzo + 1.00;

-- ESERCIZIO 8 --
/*Nell’entità Mostra aggiornare il prezzoRidotto aumentandolo di 1 Euro per quelle mostre che hanno
prezzoIntero inferiore a 15 Euro.*/
UPDATE Mostra SET prezzoRidotto = prezzoRidotto + 1.00 WHERE prezzoIntero < 15.00;

-- EXTRA --
INSERT INTO Orario(museo, città, giorno, orarioApertura, orarioChiusura)
VALUES ('Arena', 'Verona', 'LUN', '09:00', '19:00'),
	   ('Arena', 'Verona', 'MAR', '09:00', '12:30'),
	   ('Arena', 'Verona', 'MER', '14:30', '19:00'),
       ('CastelVecchio', 'Verona', 'MAR', '09:00', '17:30'),
	   ('CastelVecchio', 'Verona', 'GIO', '10:00', '15:00');
	
--SELECT * FROM Museo;
--SELECT * FROM Mostra;
--SELECT * FROM Opera;
SELECT * FROM Orario;