USE Colegas
SET DATEFORMAT 'DMY'

INSERT INTO Carros
	VALUES (1, 'Seat', 'Ibiza', 2014, 'Blanco', NULL),
		   (2, 'Ford', 'Focus', 2016, 'Rojo', 1),
		   (3, 'Toyota', 'Prius','2017', 'Blanco', 4),
		   (5, 'Renault', 'Megane', 2004, 'Azul', 2),
		   (8, 'Mitsubishi', 'Colt', 2011, 'Rojo', 6)

INSERT INTO People
	VALUES (1, 'Eduardo', 'Mingo', '14/07/1990'),
		   (2, 'Margarita', 'Padera', '11/11/1992'),
		   (4, 'Eloisa', 'Lamandra', '02/03/2000'),
		   (5, 'Jordi', 'Videndo', '28/05/1989'),
		   (6, 'Alfonso', 'Sito', '10/10/1978')

INSERT INTO Libros
	VALUES (2, 'El corazón de las Tinieblas', 'Joseph Conrad'),
		   (4, 'Cien años de soledad', 'Gabriel García Márquez'),
		   (8, 'Harry Potter y la cámara de los secretos', 'J. K. Rowling'),
		   (16, 'Evangelio del Flying Spaguetti Monster', 'Bobby Henderson')

--4. Eduardo Mingo ha leído Cien años de Soledad, Margarita ha leído El corazón de las tinieblas, 
--Eloisa ha leído Cien años de soledad y Harry Potter. Jordi y Alfonso han leído El Evangelio del FSM.
INSERT INTO Lecturas
	VALUES (4,1),
		   (2,2),
		   (4,4),
		   (8,4),
		   (16,5),
		   (16,6)

--5. Margarita le ha vendido su coche a Alfonso.
UPDATE Carros
SET IDPropietario = 2
WHERE IDPropietario = 5

--6. Queremos saber los nombres y apellidos de todos los que tienen 30 años o más
SELECT Nombre, Apellidos FROM People
	WHERE YEAR(CURRENT_TIMESTAMP - CAST(FechaNac AS DATETIME) ) - 1900 > 30

--7. Marca, año y modelo de todos los coches que no sean blancos ni verdes
SELECT Marca, Modelo, Anho FROM Carros
	WHERE Color <> 'Blanco' AND Color <> 'Verde'









