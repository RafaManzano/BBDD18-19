USE LeoMetroV2
SET DATEFORMAT YMD
--0. La dimisión de Esperanza Aguirre ha causado tal conmoción entre los directivos de LeoMetro que han decidido conceder 
--una amnistía a todos los pasajeros que tengan un saldo negativo en sus tarjetas.
--Crea un procedimiento que recargue la cantidad necesaria para dejar a 0 el saldo de las tarjetas que tengan un saldo 
--negativo y hayan sido recargadas al menos una vez en los últimos dos meses.
/*
Interfaz
Nombre: recargarEA
Cabecera: CREATE PROCEDURE recargarEA ()
Precondiciones: No hay
Entrada: No hay
Salida: No hay
E/S: No hay
Postcondiciones: Todas aquellas tarjetas que hayan recargado al menos una vez en menos de dos meses si estan negativas seran
--hasta cero
*/
--Recargas no tiene ningun dato, asi que le he añadido uno para hacer la prueba
BEGIN TRANSACTION
DECLARE @ID UNIQUEIDENTIFIER
SET @ID = NEWID()
INSERT LM_Recargas (ID,ID_Tarjeta, Cantidad_Recarga, Momento_Recarga, SaldoResultante)
VALUES (@ID, 1, 1, CURRENT_TIMESTAMP, 2)
--ROLLBACK
--COMMIT
SELECT * FROM LM_Recargas

GO
CREATE PROCEDURE recargarEA AS
	UPDATE LM_Tarjetas
	SET Saldo = 0
	FROM LM_Tarjetas AS LMT
	INNER JOIN LM_Recargas AS LMR ON LMT.ID = LMR.ID_Tarjeta
	WHERE LMT.Saldo < 0 AND DATEDIFF(MONTH, LMR.Momento_Recarga, CURRENT_TIMESTAMP) < 2
GO

SELECT * FROM LM_Tarjetas
BEGIN TRANSACTION 
EXECUTE recargarEA 
--ROLLBACK
--COMMIT

--1. Crea un procedimiento RecargarTarjeta que reciba como parámetros el ID de una tarjeta y un importe y 
--actualice el saldo de la tarjeta sumándole dicho importe, además de grabar la correspondiente recarga
/*
Interfaz
Nombre: RecargarTarjeta
Cabecera: CREATE PROCEDURE RecargarTarjeta @IDTarjeta INT, @Importe SMALLMONEY
Precondiciones: No hay
Entrada: - @IDTarjeta INT //El id de la tarjeta necesaria que se le actualice el saldo
		 - @Importe SMALLMONEY //Es el dinero que se le añade
Salida: No hay
E/S: No hay
Postcondiciones: A esa tarjeta se le aumenta el saldo lo que diga el importe
*/
GO
CREATE PROCEDURE RecargarTarjeta 
	@IDTarjeta INT, @Importe SMALLMONEY AS

	UPDATE LM_Tarjetas
	SET Saldo += @Importe
	WHERE ID = @IDTarjeta

	DECLARE @ID UNIQUEIDENTIFIER
	SET @ID = NEWID()
	INSERT LM_Recargas (ID,ID_Tarjeta, Cantidad_Recarga, Momento_Recarga, SaldoResultante)
	VALUES (@ID, @IDTarjeta, @Importe, CURRENT_TIMESTAMP, (SELECT Saldo FROM LM_Tarjetas WHERE ID = @IDTarjeta))
GO

--Test
BEGIN TRANSACTION
SELECT * FROM LM_Tarjetas
SELECT * FROM LM_Recargas
EXECUTE RecargarTarjeta 1, 3
SELECT * FROM LM_Tarjetas
SELECT * FROM LM_Recargas
--ROLLBACK
--COMMIT

BEGIN TRANSACTION
SELECT * FROM LM_Tarjetas
SELECT * FROM LM_Recargas
EXECUTE RecargarTarjeta 2, 3
SELECT * FROM LM_Tarjetas
SELECT * FROM LM_Recargas
--ROLLBACK
--COMMIT

BEGIN TRANSACTION
SELECT * FROM LM_Tarjetas
SELECT * FROM LM_Recargas
EXECUTE RecargarTarjeta 3, 3
SELECT * FROM LM_Tarjetas
SELECT * FROM LM_Recargas
--ROLLBACK
--COMMIT

--2. Crea un procedimiento almacenado llamado PasajeroSale que reciba como parámetros el ID de una tarjeta, 
--el ID de una estación y una fecha/hora (opcional). El procedimiento se llamará cuando un pasajero pasa su tarjeta 
--por uno de los tornos de salida del metro. Su misión es grabar la salida en la tabla LM_Viajes. Para ello 
--deberá localizar la entrada que corresponda, que será la última entrada correspondiente al mismo pasajero y 
--hará un update de las columnas que corresponda. Si no existe la entrada, grabaremos una nueva fila en LM_Viajes dejando a NULL 
--la estación y el momento de entrada.
--Si se omite el parámetro de la fecha/hora, se tomará la actual.
/*
Interfaz
Nombre: PasajeroSale
Cabecera: CREATE PROCEDURE PasajeroSale @IDTarjeta INT, @IDEstacion INT, @Fecha SMALLDATETIME
Precondiciones: No hay
Entrada: - @IDTarjeta INT //Es la tarjeta de un pasajero
		 - @IDEstacion INT  //La id de una estacion de metro
		 - @Fecha SMALLDATETIME //La fecha donde entro al metro
Salida: No hay
E/S: No hay
Postcondiciones: Grabara la salida de un viaje, si no tuviera grabamos una nueva fila de los viajes
*/
SELECT * FROM LM_Viajes
SELECT * FROM LM_Tarjetas
GO
CREATE PROCEDURE PasajeroSale 
	@IDTarjeta INT, 
	@IDEstacion INT, 
	@Fecha SMALLDATETIME AS

	IF @Fecha IS NULL
	BEGIN
	SET @Fecha = CURRENT_TIMESTAMP
	END

	IF (SELECT MAX(LMV.ID) FROM LM_Tarjetas AS LMT
		INNER JOIN LM_Viajes AS LMV ON LMT.ID = LMV.IDTarjeta
		WHERE LMT.ID = @IDTarjeta) IS NOT NULL
	BEGIN
		UPDATE LM_Viajes 
	    SET IDEstacionSalida = @IDEstacion,
		MomentoSalida = @Fecha
		WHERE IDTarjeta = @IDTarjeta
	END
	ELSE
	BEGIN
		DECLARE @ID UNIQUEIDENTIFIER
		SET @ID = NEWID()
		INSERT LM_Viajes (IDTarjeta, IDEstacionEntrada, IDEstacionSalida, MomentoEntrada, MomentoSalida)
		VALUES(@IDTarjeta, NULL, @IDEstacion, NULL, @Fecha)
	END
GO 

BEGIN TRANSACTION
--INSERT LM_Tarjetas(Saldo, IDPasajero)
--VALUES(50, 1)
--SELECT * FROM LM_Tarjetas
SELECT * FROM LM_Viajes
EXECUTE PasajeroSale 2, 5, NULL
SELECT * FROM LM_Viajes
WHERE ID = 2
--ROLLBACK
--COMMIT

--3. A veces, un pasajero reclama que le hemos cobrado un viaje de forma indebida. 
--Escribe un procedimiento que reciba como parámetro el ID de un pasajero y la fecha y hora de la entrada en el metro y 
--anule ese viaje, actualizando además el saldo de la tarjeta que utilizó.
/*
Interfaz
Nombre: CobroEquivocado
Cabecera: CREATE PROCEDURE CobroEquivocado @IDPasajero INT @Fecha SMALLDATETIME
Precondiciones: No hay
Entrada: - @IDPasajero //Es el id del pasajero al que hay que eliminarle el cobro
		 - @Fecha //La fecha de entrada al metro
Salida: No hay
E/S: No hay
Postcondiciones: Al ejecutar, elimina el viaje y actualiza a la tarjeta el cobro del billete
*/
GO
CREATE PROCEDURE CobroEquivocado 
	@IDPasajero INT ,
	@Fecha SMALLDATETIME AS

	UPDATE LM_Tarjetas
	SET Saldo += LMV.Importe_Viaje
	FROM LM_Tarjetas AS LMT
	INNER JOIN LM_Viajes AS LMV ON  LMT.ID = LMV.IDTarjeta 
	WHERE LMT.IDPasajero = @IDPasajero AND MomentoEntrada = @Fecha 

	DELETE LM_Viajes
	FROM LM_Viajes AS LMV
	INNER JOIN LM_Tarjetas AS LMT ON LMV.IDTarjeta = LMT.ID
	WHERE LMT.IDPasajero = @IDPasajero AND MomentoEntrada = @Fecha
GO

BEGIN TRANSACTION 
SELECT * FROM LM_Viajes
SELECT * FROM LM_Tarjetas
EXECUTE CobroEquivocado 27, '2017-02-27 10:03'
SELECT * FROM LM_Viajes
SELECT * FROM LM_Tarjetas
--ROLLBACK
--COMMIT

BEGIN TRANSACTION 
SELECT * FROM LM_Viajes
SELECT * FROM LM_Tarjetas
EXECUTE CobroEquivocado 1, '2017-02-24 16:50'
SELECT * FROM LM_Viajes
SELECT * FROM LM_Tarjetas
--ROLLBACK
--COMMIT

BEGIN TRANSACTION 
SELECT * FROM LM_Viajes
SELECT * FROM LM_Tarjetas
EXECUTE CobroEquivocado 2, '2017-02-24 16:50'
SELECT * FROM LM_Viajes
SELECT * FROM LM_Tarjetas
--ROLLBACK
--COMMIT

--4. La empresa de Metro realiza una campaña de promoción para pasajeros fieles.
--Crea un procedimiento almacenado que recargue saldo a los pasajeros que cumplan determinados requisitos. 
--Se recargarán N1 euros a los pasajeros que hayan consumido más de 30 euros en el mes anterior (considerar mes completo, del día 1 al fin) y N2 euros a los que hayan utilizado más de 10 veces alguna estación de las zonas 3 o 4. 
--Los valores de N1 y N2 se pasarán como parámetros. Si se omiten, se tomará el valor 5.
--Ambos premios son excluyentes. Si algún pasajero cumple ambas condiciones se le aplicará la que suponga mayor bonificación de las dos.
--Lo hare despues puesto que hoy se ha expuesto entonces lo tengo muy fresco

--Version Pablo
GO
CREATE FUNCTION RecargaFieles (@IDtarjeta INT, @N1 SMALLMONEY = 5, @N2 SMALLMONEY = 5) RETURNS INT AS
BEGIN
	DECLARE @dinero SMALLMONEY
	SET @dinero = 0 --Esto es por si algun fiel no cumple algun requisito, que devuelva 0.

	--Buscamos los que hayan usado mas de 10 veces alguna estacion de las zonas 3 y 4.
	IF EXISTS (SELECT COUNT(IDTarjeta) AS[Veces Viajada] FROM LM_Viajes AS[V]
					INNER JOIN LM_Estaciones AS [E] ON V.IDEstacionEntrada = E.ID OR V.IDEstacionSalida = E.ID
				WHERE E.Zona_Estacion IN(3,4) AND V.IDTarjeta = @IDtarjeta
				GROUP BY IDTarjeta
				HAVING COUNT(IDTarjeta) >= 10)
		SET @dinero = @N2

	--Buscamos los que hayan consumido mas de 30 euros en el mes anterior.
	IF EXISTS (SELECT SUM(Importe_Viaje) AS[Gastado] FROM LM_Viajes AS[V]
					WHERE CAST(V.MomentoSalida AS DATE) BETWEEN '2017-02-01' AND '2017-02-28' AND V.IDTarjeta = @IDTarjeta
				GROUP BY IDTarjeta
				HAVING SUM(Importe_Viaje) >= 30)
		SET @dinero = @N1

	--En la cabecera ya les asigno un valor por defecto, asi que no necesito comprobar si algun valor es nulo. Simplemente comparo que valor es mas grande y lo asigno.
	IF (@N1 >= @N2)
		SET @dinero = @N1
	ELSE
		SET @dinero = @N2

	RETURN @dinero
END
GO

/*
Esta funcion actualiza los fieles que cumplan las condiciones del enunciado.
*/
GO
CREATE PROCEDURE ActualizarFieles (@N1 SMALLMONEY = 5, @N2 SMALLMONEY = 5) AS
BEGIN
	UPDATE LM_Tarjetas
	SET Saldo = Saldo + dbo.RecargaFieles(ID, @N1, @N2)
END
GO

BEGIN TRAN
EXECUTE ActualizarFieles 3,5
SELECT * FROM LM_Tarjetas
ROLLBACK


--5. Crea una función que nos devuelva verdadero si es posible que un pasajero haya subido a un tren en un determinado 
--viaje. Se pasará como parámetro el código del viaje y la matrícula del tren.
/*
Interfaz:
Nombre: SubioColeguita
Cabecera: CREATE FUNCTION SubioColeguita @IDViaje INT, @Matricula CHAR(7)
Precondiciones: No hay
Entrada: - @IDViaje INT //Es el viaje en el que se investigara si el pasajero subio
		 - @Matricula CHAR(7) //Es la matricula del tren donde se subio
Salida: @Entro BIT //Se devolvera 1 si el pasajero subio y 0 sino subio
E/S: No hay
Postcondiciones: Se devolvera 1 si el pasajero subio y 0 sino subio
*/
GO
CREATE FUNCTION SubioColeguita (@IDViaje INT, @Matricula CHAR(7))
	RETURNS BIT AS
	BEGIN 
	DECLARE @Entro BIT
	SET @Entro = 0
		IF EXISTS (SELECT * FROM LM_Trenes AS LMT
			INNER JOIN LM_Recorridos AS LMR ON LMT.ID = LMR.Tren
			INNER JOIN LM_Estaciones AS LME ON LMR.estacion = LME.ID
			INNER JOIN LM_Viajes AS LMV ON LME.ID = LMV.IDEstacionEntrada OR LME.ID = LMV.IDEstacionSalida
			WHERE LMV.ID = @IDViaje AND LMT.Matricula = @Matricula) 
			BEGIN
				SET @Entro = 1
			END
	RETURN @Entro
	END
GO

SELECT LMV.ID, LMT.Matricula FROM LM_Trenes AS LMT
INNER JOIN LM_Recorridos AS LMR ON LMT.ID = LMR.Tren
INNER JOIN LM_Estaciones AS LME ON LMR.estacion = LME.ID
INNER JOIN LM_Viajes AS LMV ON LME.ID = LMV.IDEstacionEntrada OR LME.ID = LMV.IDEstacionSalida
--WHERE LMV.ID = 5 AND LMT.Matricula = @Matricula

DECLARE @Booleana BIT
SET @Booleana = dbo.SubioColeguita (1, '0100FRY')
PRINT @booleana
SET @Booleana = dbo.SubioColeguita (2, '0100FRY')
PRINT @booleana
SET @Booleana = dbo.SubioColeguita (8, '0100FRY')
PRINT @booleana
SET @Booleana = dbo.SubioColeguita (-2, '0100FRY')
PRINT @booleana

--6. Crea un procedimiento SustituirTarjeta que Cree una nueva tarjeta y la asigne al mismo usuario y con 
--el mismo saldo que otra tarjeta existente. El código de la tarjeta a sustituir se pasará como parámetro.
/*
Interfaz
Nombre: SustituirTarjeta 
Cabecera: CREATE PROCEDURE @IDTarjeta INT 
Precondiciones: No hay
Entrada: -@IDTarjeta //Es la tarjeta a la que vamos a sustituir
Salida: No hay
E/S:No hay
Postcondiciones: Se va a introducir una nueva tarjeta con los datos de la introducida por parametros
*/

GO
CREATE PROCEDURE SustituirTarjetav2 
	@IDTarjeta INT AS

	INSERT LM_Tarjetas (Saldo, IDPasajero)
	SELECT Saldo, IDPasajero FROM LM_Tarjetas
	WHERE ID = @IDTarjeta
GO

BEGIN TRANSACTION
EXECUTE SustituirTarjetav2 1
--ROLLBACK
--COMMIT
SELECT * FROM LM_Tarjetas

BEGIN TRANSACTION
EXECUTE SustituirTarjetav2 4
--ROLLBACK
--COMMIT
SELECT * FROM LM_Tarjetas

--7. Las estaciones de la zona 3 tienen ciertas deficiencias, lo que nos ha obligado a introducir una serie de 
--modificaciones en los trenes para cumplir las medidas de seguridad.
--A consecuencia de estas modificaciones, la capacidad de los trenes se ha visto reducida en 6 plazas para los trenes de 
--tipo 1 y 4 plazas para los trenes de tipo 2.
--Realiza un procedimiento al que se pase un intervalo de tiempo y modifique la capacidad de todos los trenes que 
--hayan circulado más de una vez por alguna estación de la zona 3 en ese intervalo.
/*
Interfaz
Nombre: DeficienciasTrenes
Cabecera: CREATE PROCEDURE DeficienciasTrenes @FechaInicio DATE, @FechaFin DATE
Precondiciones: No hay
Entrada: - @FechaInicio SMALLDATETIME //La fecha donde empieza
		 - @FechaFin SMALLDATETIME //La fecha donde acaba
Salida: No hay
E/S: No hay
Postcondiciones: Se reduce la capacidad de los trenes que hayan circulado en la zona 3 (6 plazas tipo 1 y 4 plazas tipo 2)
*/

GO
CREATE PROCEDURE DeficienciasTrenes 
	@FechaInicio DATE, 
	@FechaFin DATE AS

	DECLARE @Subida INT
	SET @Subida = 4
	IF EXISTS (SELECT * FROM LM_Trenes AS LMT
			   INNER JOIN LM_Recorridos AS LMR ON LMT.ID = LMR.Tren
			   INNER JOIN LM_Estaciones AS LME ON LMR.estacion = LME.ID
			   INNER JOIN LM_Viajes AS LMV ON LME.ID = LMV.IDEstacionEntrada OR LME.ID = LMV.IDEstacionSalida
			   WHERE LMT.Tipo = 1 AND LME.Zona_Estacion = 3 AND LMV.MomentoEntrada BETWEEN @FechaInicio AND @FechaFin AND LMV.MomentoSalida BETWEEN @FechaInicio AND @FechaFin)
			   SET @Subida = 6
	BEGIN

			   IF @Subida = 6 
			   BEGIN
				   UPDATE LM_Trenes
				   SET Capacidad -= @Subida
				   FROM LM_Trenes AS LMT
				   INNER JOIN LM_Recorridos AS LMR ON LMT.ID = LMR.Tren
				   INNER JOIN LM_Estaciones AS LME ON LMR.estacion = LME.ID
				   INNER JOIN LM_Viajes AS LMV ON LME.ID = LMV.IDEstacionEntrada OR LME.ID = LMV.IDEstacionSalida
				   WHERE LMT.Tipo = 1 AND LME.Zona_Estacion = 3 AND LMV.MomentoEntrada BETWEEN @FechaInicio AND @FechaFin AND LMV.MomentoSalida BETWEEN @FechaInicio AND @FechaFin
			   END

			   ELSE
			   BEGIN
					UPDATE LM_Trenes
					SET Capacidad -= @Subida
					FROM LM_Trenes AS LMT
					INNER JOIN LM_Recorridos AS LMR ON LMT.ID = LMR.Tren
					INNER JOIN LM_Estaciones AS LME ON LMR.estacion = LME.ID
					INNER JOIN LM_Viajes AS LMV ON LME.ID = LMV.IDEstacionEntrada OR LME.ID = LMV.IDEstacionSalida
					WHERE LMT.Tipo = 2 AND LME.Zona_Estacion = 3 AND LMV.MomentoEntrada BETWEEN @FechaInicio AND @FechaFin AND LMV.MomentoSalida BETWEEN @FechaInicio AND @FechaFin
			   END
	END
GO

BEGIN TRANSACTION 
--SELECT * FROM LM_Viajes
--SELECT * FROM LM_Trenes
EXECUTE DeficienciasTrenes '2017-02-24 08:50', '2017-04-24 18:50'
--ROLLBACK
--COMMIT
