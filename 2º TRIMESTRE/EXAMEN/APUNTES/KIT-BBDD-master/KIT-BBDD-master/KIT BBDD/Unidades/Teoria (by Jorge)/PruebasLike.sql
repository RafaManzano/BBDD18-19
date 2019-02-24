Use Ejemplos
GO
-- Creamos una tabla para guardar Palabras
CREATE TABLE Palabras (
	ID SmallInt Not Null Identity (1,1)	
		CONSTRAINT PK_Palabras PRIMARY KEY
	,Palabra VarChar (15) Not Null
)
GO
INSERT INTO Palabras (Palabra) VALUES ('pera')
	,('mesa'), ('palo'), ('condesa');
INSERT INTO Palabras (Palabra) VALUES ('banco')
	,('perdón'), ('pendón'),('medida');
INSERT INTO Palabras (Palabra) VALUES ('receta'),
	('justicia'), ('mentira'),('medicina');
INSERT INTO Palabras (Palabra) VALUES ('revolución')
	,('libertad'), ('democracia'), ('solidaridad');
INSERT INTO Palabras (Palabra) VALUES ('igualdad')
	,('derecho'), ('pino'), ('pato');
INSERT INTO Palabras (Palabra) VALUES ('mercado')
	,('piso'), ('hipoteca'), ('sanidad');
INSERT INTO Palabras (Palabra) VALUES ('educación');
GO
CREATE PROCEDURE PruebaLike (@patron AS Varchar(20)) AS 
	SELECT Palabra FROM Palabras WHERE Palabra LIKE @patron
GO

-- Las pruebas deben tener el siguiente formato:

EXECUTE PruebaLike 'p__o'
-- Donde 'p__o' es el patrón que queremos probar
-- Para obtener la lista completa usa EXECUTE PruebaLike '%'