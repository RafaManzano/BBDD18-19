USE LeoMetroV2
SET Dateformat 'ymd'
--1.Crea un procedimiento RecargarTarjeta que reciba como parámetros el ID de una tarjeta y un importe y actualice 
--el saldo de la tarjeta sumándole dicho importe, además de grabar la correspondiente recarga
GO
ALTER PROCEDURE RecargarTarjeta @ID_Tarjeta int, @Importe smallmoney
AS
BEGIN

	IF @Importe <= 0
	BEGIN
		RAISERROR('El importe debe ser positivo',12,4) 
	END
	ELSE
	BEGIN
		BEGIN TRANSACTION
		-- Insertamos el importe en la tarjeta
		UPDATE LM_Tarjetas
		SET Saldo = Saldo + @importe
		FROM LM_Tarjetas 
		WHERE ID = @id_Tarjeta

		-- Insertamos en recargas
		INSERT INTO LM_Recargas(ID, ID_Tarjeta, Cantidad_Recarga, Momento_Recarga, SaldoResultante)
		SELECT NEWID(),@ID_Tarjeta, @Importe, CURRENT_TIMESTAMP, Saldo
		FROM LM_Tarjetas
		WHERE ID = @ID_Tarjeta
		COMMIT TRANSACTION
	END
END
GO

DECLARE @ID_Tarjeta int = 10
DECLARE @Importe smallmoney = 1	

EXECUTE RecargarTarjeta @ID_Tarjeta,@Importe



--0. La dimisión de Esperanza Aguirre ha causado tal conmoción entre los directivos de LeoMetro que han decidido
-- conceder una amnistía a todos 
--los pasajeros que tengan un saldo negativo en sus tarjetas.
--Crea un procedimiento que racargue la cantidad necesaria para dejar a 0 el saldo de las tarjetas 
--que tengan un saldo negativo y hayan 
--sido recargadas al menos una vez en los últimos dos meses.

GO
ALTER PROCEDURE RecargarCantidadPositiva 
AS
BEGIN
--Guardamos en una variable tipo tabla que tienen menos de 0 euros y han sido recargadas en los dos ultimos meses
	DECLARE @SaldoPositivo TABLE (ID_Tarjeta int,Saldo smallmoney)
	
	INSERT INTO @SaldoPositivo 
	SELECT ID_Tarjeta, Saldo
	FROM LM_Tarjetas AS T
	INNER JOIN LM_Recargas AS R
	ON T.ID = R.ID_Tarjeta
	Where Saldo < 0 AND R.Momento_Recarga > DATEADD(MONTH, -2,  CURRENT_TIMESTAMP)


	BEGIN TRANSACTION
	UPDATE LM_Tarjetas         -- Actualizamos LM_Tarjetas
	SET Saldo = 0  -- Cogemos el saldo negativo, lo convertimos en positivo y se lo sumamos al saldo de la tarjeta
	FROM LM_Tarjetas AS T
	INNER JOIN @SaldoPositivo AS S
	ON T.ID = S.ID_Tarjeta
	
	
   -- Insertamos en recargas
	INSERT INTO LM_Recargas(ID, ID_Tarjeta, Cantidad_Recarga, Momento_Recarga, SaldoResultante)
	SELECT NEWID(),T.ID, (-S.Saldo), CURRENT_TIMESTAMP, T.Saldo -- Cogemos la cantidad de la recarga de la variable porque en la tabla T ya esta actualizado
	FROM LM_Tarjetas AS T
	INNER JOIN @SaldoPositivo AS S
	ON T.ID = S.ID_Tarjeta
	COMMIT TRANSACTION
END
GO				

BEGIN TRANSACTION
EXECUTE RecargarCantidadPositiva 
ROLLBACK TRANSACTION

select * from LM_Tarjetas
SELECT * FROM LM_Recargas
ORDER BY ID_Tarjeta
-- 2.Crea un procedimiento almacenado llamado PasajeroSale que reciba como parámetros el ID de una tarjeta, el ID de una estación y una fecha/hora(salida)
--(opcional).
--El procedimiento se llamará cuando un pasajero pasa su tarjeta por uno de los tornos de salida del metro.
--Su misión es grabar la salida en la tabla LM_Viajes. 
--Para ello deberá localizar la entrada que corresponda, que será la última entrada correspondiente al mismo pasajero y hará un 
--update de las columnas que corresponda.(estacion de salida y momento de salida y saldo)
--Si no existe la entrada, grabaremos una nueva fila en LM_Viajes dejando a NULL la estación de entrada y el momento de entrada.
--Si se omite el parámetro de la fecha/hora, se tomará la actual.
GO
ALTER PROCEDURE PasajeroSale @ID_Tarjeta int, @ID_Estacion smallint, @FechaHoraSalida smalldateTime = NULL
AS
BEGIN
	BEGIN TRANSACTION

	-- Creamos una variable para almacenar la ultima entrada 
	DECLARE @ultimaEntrada Smalldatetime

	-- Asignamos a la variable la ultima entrada
	SET @ultimaEntrada =
	(
		SELECT MAX(V.MomentoEntrada) AS MomentoEntrada
		FROM LM_Viajes AS V
		INNER JOIN LM_Tarjetas AS T
		ON V.IDTarjeta = T.ID
		INNER JOIN LM_Pasajeros AS P
		ON T.IDPasajero = P.ID
		WHERE T.ID = @ID_Tarjeta AND V.IDEstacionEntrada = @ID_Estacion AND T.IDPasajero = P.ID
	)

	IF @FechaHoraSalida IS NULL
		BEGIN
			-- Si no existe la entrada
			IF @ultimaEntrada IS NULL
				BEGIN
					BEGIN TRANSACTION

					/*INSERT INTO LM_Viajes(ID, IDTarjeta, IDEstacionEntrada, IDEstacionSalida, MomentoEntrada, MomentoSalida, Importe_Viaje)
					VALUES(200, @id_Tarjeta, NULL, NULL, NULL, CURRENT_TIMESTAMP, 2)*/--DUDA

					COMMIT TRANSACTION
				END
		END
	ELSE
		BEGIN
		-- Si no existe la entrada
			IF @ultimaEntrada IS NULL
				BEGIN
					BEGIN TRANSACTION

					INSERT INTO LM_Viajes(ID, IDTarjeta, IDEstacionEntrada, IDEstacionSalida, MomentoEntrada, MomentoSalida, Importe_Viaje)
					VALUES(200, @id_Tarjeta, NULL, NULL, NULL, @FechaHoraSalida, 2) --duda

					COMMIT TRANSACTION

				END
		END
	COMMIT TRANSACTION
END
GO

BEGIN TRANSACTION
DECLARE @ID_Tarjeta int = 
DECLARE @ID_Estacion smallint = 
DECLARE @FechaHoraSalida smalldatetime = 

EXECUTE PasajeroSale @ID_Tarjeta,@ID_Estacion,@FechaHoraSalida
COMMIT TRANSACTION
ROLLBACK TRANSACTION

--3.A veces, un pasajero reclama que le hemos cobrado un viaje de forma indebida. Escribe un procedimiento que reciba como parámetro el ID de un pasajero 
--y la fecha y hora de la entrada en el metro y anule ese viaje, actualizando además el saldo de la tarjeta que utilizó.
GO
CREATE PROCEDURE AnularViajeYDevolverImporte @ID_Pasajero int, @FechaEntrada smalldateTime
AS
BEGIN
	DECLARE @importeViaje smallmoney
	
	--Guardamos en la variable el importe del viaje que vamos a cancelar
	SET @importeViaje = 
	(
		SELECT V.Importe_Viaje
		FROM LM_Viajes AS V
		INNER JOIN LM_Tarjetas AS T
		ON V.IDTarjeta = T.ID
		INNER JOIN LM_Pasajeros AS P
		ON T.IDPasajero = P.ID
		WHERE P.ID = @ID_Pasajero AND V.MomentoEntrada = @FechaEntrada
	)

	-- Actualizamos la tarjeta para sumarle el importe gastado en ese viaje cancelado
	BEGIN TRANSACTION
		UPDATE LM_Tarjetas
		SET Saldo = Saldo + @importeViaje
		FROM LM_Viajes AS V
		INNER JOIN LM_Tarjetas AS T
		ON V.IDTarjeta = T.ID
		INNER JOIN LM_Pasajeros AS P
		ON T.IDPasajero = P.ID
		WHERE T.IDPasajero = @ID_Pasajero AND V.MomentoEntrada = @FechaEntrada
	COMMIT TRANSACTION

	-- Eliminamos de la tabla viajes el viaje que hemos cancelado 
	BEGIN TRANSACTION
		DELETE FROM V
		FROM LM_Viajes AS V
		INNER JOIN LM_Tarjetas AS T
		ON V.IDTarjeta = T.ID
		INNER JOIN LM_Pasajeros AS P
		ON T.IDPasajero = P.ID
		WHERE P.ID = @id_Pasajero AND V.MomentoEntrada = @fechaEntrada
	COMMIT TRANSACTION
END
GO
--Ejecucción
BEGIN TRANSACTION
DECLARE @ID_Pasajero int = 5
DECLARE @FechaEntrada smalldatetime = '2017-02-24 16:55:00'

EXECUTE AnularViajeYDevolverImporte  @ID_Pasajero,@FechaEntrada

ROLLBACK TRANSACTION
COMMIT TRANSACTION


--4.La empresa de Metro realiza una campaña de promoción para pasajeros fieles.

--Crea un procedimiento almacenado que recargue saldo a los pasajeros que cumplan determinados requisitos. 
--Se recargarán N1 euros a los pasajeros que hayan consumido más de 30 euros en el mes anterior (considerar mes completo, del día 1 al fin) y 
--N2 euros a los que hayan utilizado más de 10 veces alguna estación de las zonas 3 o 4. 
--Los valores de N1 y N2 se pasarán como parámetros. Si se omiten, se tomará el valor 5.
--Ambos premios son excluyentes. Si algún pasajero cumple ambas condiciones se le aplicará la que suponga mayor bonificación de las dos.
GO
ALTER PROCEDURE RecargarSaldoPasajerosFieles @importeN1 smallmoney = 5, @importeN2 smallmoney = 5
AS
BEGIN
	-- Variables para manejar el rango de fechas
	DECLARE @inicioMes smallDateTime 
	DECLARE @finMes smallDateTime
	DECLARE @mesAnterior smallDateTime 

	-- Creamos una variable tipo tabla donde insertaremos los pasajeros que hayan gastado mas de 30 euros y no hayan usado más de 10 veces 
	--alguna estación de las zonas 3 o 4 en el rango de fechas indicado 
	
	DECLARE @MasDe30EurosConsumidosUltimoMes TABLE(ID_Tarjeta int)

	-- Creamos una variable tipo tabla donde insertaremos los pasajeros que hayan usado más de 10 veces alguna estación de las zonas 3 o 4 
	--y no hayan gastado mas de 30 euros en el rango de fechas indicado
	
	DECLARE @MasDe10VecesZonas3y4 TABLE(ID_Tarjeta int)

	-- Creamos una variable tipo tabla donde insertaremos los pasajeros que cumplan las dos condiciones
	
	DECLARE @Cumplen2Condiciones TABLE(ID_Tarjeta int)


	-- Guardamos el mes anterior cogiendo la fecha actual menos tres meses(los viajes son en febrero y para comprobarlo tenemos que restarle 3 meses 
	--a la fecha actual)
	SET @mesAnterior = DATEADD(MONTH, -3,  CURRENT_TIMESTAMP)
	-- Creo una nueva fecha con el año y mes anterior pero dia 1(primer dia del mes)
	SET @inicioMes = DATEFROMPARTS(YEAR(@mesAnterior), MONTH(@mesAnterior), 1)
	-- Creo una nueva fecha con el año y mes anterior pero el ultimo dia del mes(para ello utilizamos el EOMONTH que coge el ultimo dia del mes de 
	--la fecha)
	SET @finMes = DATEFROMPARTS(YEAR(@mesAnterior), MONTH(@mesAnterior),DAY(EOMONTH(@mesAnterior)))

	-- Insertamos en la variable anteriormente creada los pasajeros que hayan gastado más de 30 euros y no hayan usado más de 10 veces alguna estación 
	-- de las zonas 3 o 4 en el rango de fechas indicado 
	INSERT INTO @MasDe30EurosConsumidosUltimoMes
		SELECT T.ID
		FROM LM_Viajes AS V
		INNER JOIN LM_Tarjetas AS T
		ON V.IDTarjeta = T.ID
		WHERE V.MomentoEntrada BETWEEN @inicioMes AND @finMes
		GROUP BY T.ID
		HAVING SUM(V.Importe_Viaje) > 30
		
		EXCEPT 
		
		SELECT T.ID AS [ID Tarjeta]
		FROM  LM_Tarjetas AS T 
		INNER JOIN LM_Viajes AS V
	    ON T.ID = V.IDTarjeta
		INNER JOIN LM_Estaciones AS E 
		ON V.IDEstacionEntrada = E.ID OR V.IDEstacionSalida = E.ID
		WHERE (E.Zona_Estacion = 3 OR E.Zona_Estacion = 4) AND (MomentoEntrada BETWEEN @inicioMes AND @finMes)
		GROUP BY T.ID
		HAVING COUNT(E.Zona_Estacion) > 10


	-- Insertamos en la variable anteriormente creada los pasajero que hayan usado más de 10 veces alguna estación de las zonas 3 o 4 y no hayan gastado
	-- mas de 30 euros en el rango de fechas indicado
	INSERT INTO @MasDe10VecesZonas3y4
		SELECT T.ID AS [ID Tarjeta]
		FROM  LM_Tarjetas AS T 
		INNER JOIN LM_Viajes AS V
	    ON T.ID = V.IDTarjeta
		INNER JOIN LM_Estaciones AS E 
		ON V.IDEstacionEntrada = E.ID OR V.IDEstacionSalida = E.ID
		WHERE (E.Zona_Estacion = 3 OR E.Zona_Estacion = 4) AND (MomentoEntrada BETWEEN @inicioMes AND @finMes)
		GROUP BY T.ID
		HAVING COUNT(E.Zona_Estacion) > 10

		EXCEPT 

		SELECT T.ID
		FROM LM_Viajes AS V
		INNER JOIN LM_Tarjetas AS T
		ON V.IDTarjeta = T.ID
		WHERE V.MomentoEntrada BETWEEN @inicioMes AND @finMes
		GROUP BY T.ID
		HAVING SUM(V.Importe_Viaje) > 30

	--Pasajeros que cumplen ambas condiciones
	INSERT INTO @Cumplen2Condiciones
		SELECT ID_Tarjeta 
		FROM @MasDe30EurosConsumidosUltimoMes 
		INTERSECT  
		SELECT ID_Tarjeta 
		FROM @MasDe10VecesZonas3y4
	

	--Actualiza el saldo cuando ha consumido mas de 30 euros en el ultimo mes
		UPDATE LM_Tarjetas
		SET Saldo = Saldo + @importeN1
		FROM LM_Viajes AS V
		INNER JOIN LM_Tarjetas AS T
		ON V.IDTarjeta = T.ID
		WHERE V.IDTarjeta IN (SELECT * FROM @MasDe30EurosConsumidosUltimoMes)

	--Actualiza el saldo cuando ha estado mas de 10 veces en la zona 3 y 4
		UPDATE LM_Tarjetas
		SET Saldo = Saldo + @importeN2
		FROM LM_Viajes AS V
		INNER JOIN LM_Tarjetas AS T
		ON V.IDTarjeta IN (SELECT * FROM @MasDe10VecesZonas3y4)

	--Actualiza el saldo(mayor cantidad) cuando el pasajero cumpla los dos requisitos
	    --N1 mayor que N2
		IF @importeN1 > @importeN2 
			BEGIN
				UPDATE LM_Tarjetas
				SET Saldo = Saldo + @importeN1
				FROM LM_Viajes AS V
				INNER JOIN LM_Tarjetas AS T
				ON V.IDTarjeta IN (SELECT * FROM @Cumplen2Condiciones)
			END

		--N1 menor que N2
		ELSE IF @importeN1 < @importeN2 
			BEGIN
				UPDATE LM_Tarjetas
				SET Saldo = Saldo + @importeN2
				FROM LM_Viajes AS V
				INNER JOIN LM_Tarjetas AS T
				ON V.IDTarjeta IN (SELECT * FROM @Cumplen2Condiciones)
			END
		
		--N1 igual que N2(Sumamos N1, porque ambos son iguales, podriamos sumarle N2 igualmente)
		ELSE 
			BEGIN
				UPDATE LM_Tarjetas
				SET Saldo = Saldo + @importeN1
				FROM LM_Viajes AS V
				INNER JOIN LM_Tarjetas AS T
				ON V.IDTarjeta IN (SELECT * FROM @Cumplen2Condiciones)
			END
END
GO

--Ejecuccion

Begin transaction
DECLARE @importeN1 smallmoney = 5
DECLARE @importeN2 smallmoney = 10

EXECUTE RecargarSaldoPasajerosFieles @importeN1,@importeN2
COMMIT TRANSACTION
ROLLBACK TRANSACTION

--Ejercicio 5

--Crea una función que nos devuelva verdadero si es posible que un pasajero haya subido a un tren en un determinado viaje. Se pasará como parámetro el código del viaje y la matrícula del tren.



--6.Crea un procedimiento SustituirTarjeta que Cree una nueva tarjeta y la asigne al mismo usuario y con el mismo saldo que otra tarjeta existente. 
--El código de la tarjeta a sustituir se pasará como parámetro.





--7.Las estaciones de la zona 3 tienen ciertas deficiencias, lo que nos ha obligado a introducir una serie de modificaciones en los trenes  para cumplir 
--las medidas de seguridad.

--A consecuencia de estas modificaciones, la capacidad de los trenes se ha visto reducida en 6 plazas para los trenes de tipo 1 y 4 plazas para los 
--trenes de tipo 2.

--Realiza un procedimiento al que se pase un intervalo de tiempo y modifique la capacidad de todos los trenes que hayan circulado más de una vez por 
--alguna estación de la zona 3 en ese intervalo.


