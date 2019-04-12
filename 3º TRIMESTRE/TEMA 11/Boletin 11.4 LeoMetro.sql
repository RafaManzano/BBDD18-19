USE LeoMetroV2
SET DATEFORMAT YMD

--0. La dimisión de Esperanza Aguirre ha causado tal conmoción entre los directivos de LeoMetro que han decidido conceder 
--una amnistía a todos los pasajeros que tengan un saldo negativo en sus tarjetas.
--Crea un procedimiento que recargue la cantidad necesaria para dejar a 0 el saldo de las tarjetas que 
--tengan un saldo negativo y hayan sido recargadas al menos una vez en los últimos dos meses.
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

--1. Crea un procedimiento RecargarTarjeta que reciba como parámetros el ID de una tarjeta y un importe y actualice el 
--saldo de la tarjeta sumándole dicho importe, además de grabar la correspondiente recarga
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

--2. Crea un procedimiento almacenado llamado PasajeroSale que reciba como parámetros el ID de una tarjeta, el ID de una estación 
--y una fecha/hora (opcional). El procedimiento se llamará cuando un pasajero pasa su tarjeta por uno de los tornos de salida del metro. 
--Su misión es grabar la salida en la tabla LM_Viajes. Para ello deberá localizar la entrada que corresponda, que será la 
--última entrada correspondiente al mismo pasajero y hará un update de las columnas que corresponda. Si no existe la entrada, grabaremos 
--una nueva fila en LM_Viajes dejando a NULL la estación y el momento de entrada.
--Si se omite el parámetro de la fecha/hora, se tomará la actual.

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
--parámetro el ID de un pasajero y la fecha y hora de la entrada en el metro y anule ese viaje, actualizando además el 
--saldo de la tarjeta que utilizó.
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