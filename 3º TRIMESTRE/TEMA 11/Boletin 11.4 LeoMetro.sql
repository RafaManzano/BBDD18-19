USE LeoMetroV2
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
SELECT * FROM LM_Viajes
GO
CREATE PROCEDURE PasajeroSale
	@IDTarjeta INT,
	@IDEstacion INT AS
BEGIN
	INSERT INTO LM_Viajes (IDTarjeta, IDEstacionEntrada, IDEstacionSalida, MomentoEntrada, MomentoSalida, Importe_Viaje)
	VALUES (@IDTarjeta, NULL, @IDEstacion, NULL, CURRENT_TIMESTAMP, NULL)
END
GO