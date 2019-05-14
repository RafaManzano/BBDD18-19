USE Ejemplos
GO
CREATE TABLE Palabras (
ID SmallInt Not Null Identity Constraint PK_Palabras Primary Key
,Palabra VarChar(30) Null
)

--1. Queremos que cada vez que se actualice la tabla Palabras aparezca un mensaje diciendo si
--se han añadido, borrado o actualizado filas.
--Pista: Crea tres triggers diferentes
GO
CREATE TRIGGER Insertado ON Palabras
	AFTER INSERT AS
	BEGIN 
		PRINT 'Se ha insertado correctamente'
	END
GO

GO
CREATE TRIGGER Eliminado ON Palabras
	AFTER DELETE AS
	BEGIN 
		PRINT 'Se ha eliminado correctamente'
	END
GO

GO
CREATE TRIGGER Actualizacion ON Palabras
	AFTER UPDATE AS
	BEGIN 
		PRINT 'Se ha actualizado correctamente'
	END
GO

--Pruebas
INSERT Palabras (Palabra)
VALUES ('Futbol'), ('Baloncesto')

DELETE Palabras
WHERE Palabra = 'Futbol'

UPDATE Palabras
SET Palabra = 'Balonmano'
WHERE Palabra = 'Baloncesto'

SELECT * FROM Palabras

--2. Haz un trigger que cada vez que se aumente o disminuya el número de filas de la tabla
--Palabras nos diga cuántas filas hay.
GO
CREATE TRIGGER ContarFilas ON Palabras
	AFTER INSERT, DELETE AS
	BEGIN 
	DECLARE @Filas INT
		SET @Filas = (SELECT COUNT(*) FROM Palabras)
		PRINT CONCAT( 'Hay ', @Filas ,' filas')
	END
GO

--Pruebas
INSERT Palabras (Palabra)
VALUES ('Futbol'), ('Baloncesto')

DELETE Palabras
WHERE Palabra = 'Futbol'

--3. Cada vez que se inserte una fila queremos que se muestre un mensaje indicando
--“Insertada la palabra ________”
GO
CREATE TRIGGER FilaIntroducida ON Palabras
	AFTER INSERT AS
	BEGIN
		DECLARE @IDMaximo INT 
		SET @IDMaximo = (SELECT MAX(ID) FROM Palabras) 
		DECLARE @Nombre VARCHAR(30)
		SET @Nombre = (SELECT Palabra FROM Palabras WHERE ID = @IDMaximo)
		PRINT CONCAT( 'Insertada la palabra ', @Nombre)
	END
GO

--Pruebas
INSERT Palabras (Palabra)
VALUES ('Waterpolo')

INSERT Palabras (Palabra)
VALUES ('BalonVolea')

INSERT Palabras (Palabra)
VALUES ('Futbol')

SELECT * FROM Palabras

--4. Cada vez que se inserten filas que nos diga “XX filas insertadas”
GO
CREATE TRIGGER ContarFilasInsertadas ON Palabras
	AFTER INSERT AS
	BEGIN 
	DECLARE @Filas INT
		SET @Filas = (SELECT COUNT(*) FROM inserted)
		PRINT CONCAT( @Filas ,' filas insertadas')
	END
GO

--Pruebas
INSERT Palabras (Palabra)
VALUES ('Futbol'), ('Baloncesto')


INSERT Palabras (Palabra)
VALUES ('Futbol'), ('Baloncesto'), ('Sumo')

--5. Que no permita introducir palabras repetidas (sin usar UNIQUE).
GO
CREATE TRIGGER RestringirNombreRepetidos ON Palabras
	AFTER INSERT AS
	BEGIN
		DECLARE @IDMaximo INT 
		SET @IDMaximo = (SELECT MAX(ID) FROM Palabras) 
		DECLARE @Insertado VARCHAR(30)
		SET @Insertado = (SELECT Palabra FROM inserted WHERE ID = @IDMaximo) 
		IF EXISTS (SELECT COUNT(ID) FROM Palabras WHERE Palabra = @Insertado HAVING COUNT(ID) > 1)
			BEGIN
				ROLLBACK
			END
	END
GO

--Pruebas
INSERT Palabras (Palabra)
VALUES ('Futbol')

INSERT Palabras (Palabra)
VALUES ('Parapente')

INSERT Palabras (Palabra)
VALUES ('Ala Delta')

INSERT Palabras (Palabra)
VALUES ('Rafting')

SELECT * FROM Palabras

--BBDD LeoMetro
USE LeoMetroV2
--6. Comprueba que un pasajero no pueda entrar o salir por la misma estación más de tres
--veces el mismo día
SELECT * FROM LM_Viajes
GO
CREATE TRIGGER ImpedirPasajero ON LM_Viajes 
	AFTER INSERT AS
	BEGIN
	IF EXISTS(
			SELECT COUNT(LMV.ID) AS Veces, LMT.ID, LMV.IDEstacionEntrada, DAY(MomentoEntrada) FROM LM_Viajes AS LMV
			INNER JOIN LM_Tarjetas AS LMT ON LMV.IDTarjeta = LMT.ID
			WHERE DATEDIFF(DAY, LMV.MomentoEntrada, LMV.MomentoSalida) <= 0
			GROUP BY LMT.ID, LMV.IDEstacionEntrada, DAY(MomentoEntrada)
			HAVING COUNT(LMV.ID) > 3)
			OR
			EXISTS(
			SELECT COUNT(LMV.ID) AS Veces, LMT.ID, LMV.IDEstacionSalida, DAY(MomentoSalida) FROM LM_Viajes AS LMV
			INNER JOIN LM_Tarjetas AS LMT ON LMV.IDTarjeta = LMT.ID
			WHERE DATEDIFF(DAY, LMV.MomentoEntrada, LMV.MomentoSalida) <= 0
			GROUP BY LMT.ID, LMV.IDEstacionSalida, DAY(MomentoSalida)
			HAVING COUNT(LMV.ID) > 3)
			BEGIN
				ROLLBACK
			END
	END
GO

--Pruebas
INSERT INTO LM_Viajes (IDTarjeta, IDEstacionEntrada, IDEstacionSalida, MomentoEntrada, MomentoSalida)
     VALUES (1, 5, 8, SMALLDATETIMEFROMPARTS(2017,02,25,20,30), SMALLDATETIMEFROMPARTS(2017,02,25,21,30))
GO

--7. Haz un trigger que al insertar un viaje compruebe que no hay otro viaje simultáneo
--Cuando se hace un select de inserted o deleted en la tabla que se hace existe el objeto insertado o borrado
SELECT * FROM LM_Viajes
GO
CREATE TRIGGER ViajesSimultaneosNoGracias ON LM_Viajes
	AFTER INSERT AS
	BEGIN
		IF EXISTS(SELECT * FROM LM_Viajes AS LMV
				  --INNER JOIN inserted AS I ON LMV.ID <> LMV.ID
				  WHERE ID NOT IN (SELECT ID FROM inserted WHERE MomentoEntrada BETWEEN LMV.MomentoEntrada AND LMV.MomentoSalida AND MomentoSalida BETWEEN LMV.MomentoEntrada AND LMV.MomentoSalida))
				  BEGIN
					ROLLBACK
				  END
	END
GO

BEGIN TRANSACTION 
--Pruebas
INSERT INTO LM_Viajes (IDTarjeta, IDEstacionEntrada, IDEstacionSalida, MomentoEntrada, MomentoSalida)
     VALUES (1, 5, 8, CURRENT_TIMESTAMP, DATEADD(HH,2,CURRENT_TIMESTAMP))
GO
--ROLLBACK
--COMMIT