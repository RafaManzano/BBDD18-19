USE LeoMetroV2
SET DATEFORMAT YMD

--0. La dimisi�n de Esperanza Aguirre ha causado tal conmoci�n entre los directivos de LeoMetro que han decidido conceder 
--una amnist�a a todos los pasajeros que tengan un saldo negativo en sus tarjetas.
--Crea un procedimiento que recargue la cantidad necesaria para dejar a 0 el saldo de las tarjetas que 
--tengan un saldo negativo y hayan sido recargadas al menos una vez en los �ltimos dos meses.
SELECT * FROM LM_Tarjetas
SELECT * FROM LM_Recargas

GO
CREATE PROCEDURE RecargarTarjetas AS
BEGIN
	UPDATE LM_Tarjetas
	SET Saldo = 0
	FROM LM_Tarjetas AS LMT
	INNER JOIN LM_Recargas AS LMR ON LMT.ID = LMR.ID_Tarjeta
	WHERE LMT.Saldo < 0 AND (MONTH(CURRENT_TIMESTAMP) - MONTH(LMR.Momento_Recarga)) < 2 
END
GO

BEGIN TRANSACTION
EXECUTE RecargarTarjetas
--ROLLBACK
--COMMIT 

--1. Crea un procedimiento RecargarTarjeta que reciba como par�metros el ID de una tarjeta y un importe y actualice el 
--saldo de la tarjeta sum�ndole dicho importe, adem�s de grabar la correspondiente recarga
SELECT * FROM LM_Tarjetas
SELECT * FROM LM_Recargas
GO
CREATE PROCEDURE RecargarTarjeta

	@IDTarjeta INT,
	@Importe SMALLMONEY AS

BEGIN
	UPDATE LM_Tarjetas
	SET Saldo = Saldo + @Importe
	WHERE ID = @IDTarjeta
	
	INSERT INTO LM_Recargas (ID, ID_Tarjeta, Cantidad_Recarga, Momento_Recarga, SaldoResultante)
	SELECT NEWID(), @IDTarjeta, @Importe, CURRENT_TIMESTAMP, Saldo FROM LM_Tarjetas AS LMT
	WHERE ID = @IDTarjeta
	--INNER JOIN LM_Recargas AS LMR ON LMT.ID = LMR.ID_Tarjeta
END
GO

BEGIN TRANSACTION
DECLARE @IDTarjeta INT
SET @IDTarjeta = 1
DECLARE @Importe SMALLMONEY
SET @Importe = 2.5
EXECUTE RecargarTarjeta @IDTarjeta, @Importe
--ROLLBACK
--COMMIT

--2. Crea un procedimiento almacenado llamado PasajeroSale que reciba como par�metros el ID de una tarjeta, el ID de una estaci�n 
--y una fecha/hora (opcional). El procedimiento se llamar� cuando un pasajero pasa su tarjeta por uno de los tornos de salida del metro. 
--Su misi�n es grabar la salida en la tabla LM_Viajes. Para ello deber� localizar la entrada que corresponda, que ser� la 
--�ltima entrada correspondiente al mismo pasajero y har� un update de las columnas que corresponda. Si no existe la entrada, grabaremos 
--una nueva fila en LM_Viajes dejando a NULL la estaci�n y el momento de entrada.
--Si se omite el par�metro de la fecha/hora, se tomar� la actual.

--Insertamos una nueva tarjeta para probar el else
INSERT INTO LM_Tarjetas (Saldo, IDPasajero)
VALUES (100, 2)

SELECT * FROM LM_Viajes
SELECT * FROM LM_Tarjetas

GO
CREATE PROCEDURE PasajeroSale
	@IDTarjeta INT,
	@IDEstacion INT AS
BEGIN
	IF (SELECT MAX(ID) FROM LM_Viajes WHERE IDTarjeta = @IDTarjeta AND MomentoSalida IS NOT NULL) IS NOT NULL
		BEGIN
			UPDATE LM_Viajes
			SET IDEstacionSalida = @IDEstacion,
			MomentoSalida = CURRENT_TIMESTAMP
			WHERE ID = (SELECT MAX(ID) FROM LM_Viajes WHERE IDTarjeta = @IDTarjeta)
		END
	ELSE
		BEGIN
			INSERT INTO LM_Viajes (IDTarjeta, IDEstacionEntrada, IDEstacionSalida, MomentoEntrada, MomentoSalida)
			VALUES (@IDTarjeta, NULL, @IDEstacion, NULL, CURRENT_TIMESTAMP)
			
		END
END
GO

BEGIN TRANSACTION
EXECUTE PasajeroSale 45, 2
--ROLLBACK
--COMMIT

SELECT * FROM LM_Viajes
SELECT DISTINCT IDTarjeta FROM LM_Viajes
ORDER BY IDTarjeta

--3. A veces, un pasajero reclama que le hemos cobrado un viaje de forma indebida. Escribe un procedimiento que reciba como 
--par�metro el ID de un pasajero y la fecha y hora de la entrada en el metro y anule ese viaje, actualizando adem�s el 
--saldo de la tarjeta que utiliz�.
--Revisar la fecha esta dando problemas, aunque la actualizacion no se ha revisado
GO
CREATE PROCEDURE ClienteInsatisfecho 
	@IDPasajero INT,
	@FechaEntrada SMALLDATETIME AS
BEGIN
	--Actualizacion de saldo del viaje
	UPDATE LM_Tarjetas
	SET Saldo = Saldo + LMV.Importe_Viaje
	FROM LM_Tarjetas AS LMT
	INNER JOIN LM_Viajes AS LMV ON LMT.ID = LMV.IDTarjeta
	WHERE LMT.IDPasajero = @IDPasajero AND LMV.MomentoEntrada = @FechaEntrada

	--Eliminacion del billete
	DELETE FROM LM_Viajes
	WHERE MomentoEntrada = (SELECT MomentoEntrada FROM LM_Viajes AS LMV
					   INNER JOIN LM_Tarjetas AS LMT ON LMV.IDTarjeta = LMT.ID
					   WHERE LMT.IDPasajero = @IDPasajero AND LMV.MomentoEntrada = @FechaEntrada)
END
GO

BEGIN TRANSACTION
DECLARE @Fecha SMALLDATETIME
SET @Fecha = SMALLDATETIMEFROMPARTS(2017, 02, 27, 10, 03)
EXECUTE ClienteInsatisfecho 27, @Fecha
--ROLLBACK
--COMMIT

SELECT * FROM LM_Viajes

--4. La empresa de Metro realiza una campa�a de promoci�n para pasajeros fieles.
--Crea un procedimiento almacenado que recargue saldo a los pasajeros que cumplan determinados requisitos. 
--Se recargar�n N1 euros a los pasajeros que hayan consumido m�s de 30 euros en el mes anterior (considerar mes completo, 
--del d�a 1 al fin) y N2 euros a los que hayan utilizado m�s de 10 veces alguna estaci�n de las zonas 3 o 4. 
--Los valores de N1 y N2 se pasar�n como par�metros. Si se omiten, se tomar� el valor 5.
--Ambos premios son excluyentes. Si alg�n pasajero cumple ambas condiciones se le aplicar� la que suponga mayor 
--bonificaci�n de las dos.
GO
CREATE PROCEDURE PasajerosFieles 
	@N1 SMALLMONEY,
	@N2 SMALLMONEY AS

	SELECT SUM(Importe_Viaje) AS Total, IDTarjeta FROM LM_Viajes
	WHERE MONTH(MomentoEntrada) = MONTH(MomentoSalida)
	GROUP BY IDTarjeta
	HAVING SUM(Importe_Viaje) > 30

	SELECT COUNT(LMV.ID) AS Veces, IDTarjeta FROM LM_Viajes AS LMV 
	INNER JOIN LM_Estaciones AS LME ON LMV.IDEstacionEntrada = LME.ID OR LMV.IDEstacionSalida = LME.ID
	WHERE LME.Zona_Estacion = 3 OR LME.Zona_Estacion = 4
	GROUP BY IDTarjeta
	HAVING COUNT(LMV.ID) > 10
GO

--5. Crea una funci�n que nos devuelva verdadero si es posible que un pasajero haya subido a un tren en un 
--determinado viaje. Se pasar� como par�metro el c�digo del viaje y la matr�cula del tren.
CREATE FUNCTION PasajeroSubidoTren (@CodigoViaje INT, @Matricula INT)
RETURNS BIT AS 
BEGIN
DECLARE @Subida BIT
	IF (SELECT * FROM LM_Trenes AS LMT
	   INNER JOIN LM_Recorridos AS LMR ON LMT.ID = LMR.Tren
	   INNER JOIN LM_Estaciones AS LME ON LMR.estacion = LME.ID
	   INNER JOIN LM_Viajes AS LMV ON LME.ID = LMV.IDEstacionEntrada
	   WHERE LMV.ID = @CodigoViaje AND LMT.Matricula = @Matricula) IS NOT NULL
	   BEGIN
		  SET @Subida = 1
	   END
	ELSE
		BEGIN
		SET @Subida = 0
		END
RETURN @Subida	  
END

--6. Crea un procedimiento SustituirTarjeta que Cree una nueva tarjeta y la asigne al mismo usuario y 
--con el mismo saldo que otra tarjeta existente. El c�digo de la tarjeta a sustituir se pasar� como par�metro.
SELECT * FROM LM_Tarjetas
GO
CREATE PROCEDURE SustituirTarjeta
	@IDTarjeta INT AS
BEGIN
	INSERT INTO LM_Tarjetas (Saldo, IDPasajero)
	SELECT Saldo, IDPasajero FROM LM_Tarjetas
	WHERE ID = @IDTarjeta
END
GO

BEGIN TRANSACTION
EXECUTE SustituirTarjeta 44
--ROLLBACK
--COMMIT

--7. Las estaciones de la zona 3 tienen ciertas deficiencias, lo que nos ha obligado a introducir una serie de 
--modificaciones en los trenes  para cumplir las medidas de seguridad.
--A consecuencia de estas modificaciones, la capacidad de los trenes se ha visto reducida en 6 plazas 
--para los trenes de tipo 1 y 4 plazas para los trenes de tipo 2.
--Realiza un procedimiento al que se pase un intervalo de tiempo y modifique la capacidad de todos los 
--trenes que hayan circulado m�s de una vez por alguna estaci�n de la zona 3 en ese intervalo.



