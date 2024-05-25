-- ESERCIZIO 1 --
ALTER TABLE Mostra
DROP CONSTRAINT IF EXISTS Mostra_museo_fkey, -- Elimina il vincolo esistente
ADD CONSTRAINT Mostra_museo_fkey -- Aggiunge un nuovo vincolo
FOREIGN KEY(museo, città)
REFERENCES Museo(nome, città)
ON DELETE CASCADE -- Quando una riga corrispondente in Museo viene cancellata, cancella anche le righe corrispondenti in Mostra
ON UPDATE CASCADE; -- Aggiorna il valore nelle colonne corrispondenti in Mostra quando viene aggiornata la riga corrispondente in Museo

ALTER TABLE Opera
DROP CONSTRAINT IF EXISTS Opera_museo_fkey, -- Elimina il vincolo esistente
ADD CONSTRAINT Opera_museo_fkey -- Aggiunge un nuovo vincolo
FOREIGN KEY(museo, città)
REFERENCES Museo(nome, città)
ON DELETE SET NULL -- Imposta a NULL i valori corrispondenti in Opera quando viene cancellata la riga corrispondente in Museo
ON UPDATE CASCADE; -- Aggiorna il valore nelle colonne corrispondenti in Opera quando viene aggiornata la riga corrispondente in Museo

ALTER TABLE Orario
DROP CONSTRAINT IF EXISTS Orario_museo_fkey, -- Elimina il vincolo esistente
ADD CONSTRAINT Orario_museo_fkey -- Aggiunge un nuovo vincolo
FOREIGN KEY(museo, città)
REFERENCES Museo(nome, città)
ON DELETE SET DEFAULT -- Imposta il valore di default nelle colonne corrispondenti in Orario quando viene aggiornata la riga corrispondente in Museo
ON UPDATE CASCADE; -- Aggiorna il valore nelle colonne corrispondenti in Orario quando viene aggiornata la riga corrispondente in Museo

-- ISTRUZIONI DI TEST -- 
--DELETE FROM Museo WHERE nome = 'Arena';
--UPDATE Museo SET nome = 'stefano' WHERE nome = 'Arena';

--SELECT * FROM Museo;
--SELECT * FROM Mostra;
SELECT * FROM Opera;
--SELECT * FROM Orario;