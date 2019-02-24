		--BOLETIN 11.2--
GO
USE AirLeo

/*Ejercicio 1
Escribe un procedimiento que cancele un pasaje y las tarjetas de embarque asociadas.
Recibirá como parámetros el ID del pasaje.*/
begin transaction
GO
CREATE PROCEDURE CancelarPasaje -- Creamos procedimiento
	@ID_pasaje int -- variable de entrada como parametro
AS
    -- Eliminamos los vuelos asociado
	DELETE FROM AL_Vuelos_Pasajes
	WHERE Numero_Pasaje = @ID_pasaje
	PRINT 'Vuelo borrado'

	-- Borramos el pasaje asociado
	DELETE FROM AL_Pasajes
	WHERE Numero = @ID_pasaje
	PRINT 'Pasaje borrado'

	-- Por ultimo borramos la tarjeta de embarque
	DELETE FROM AL_Tarjetas
	WHERE Numero_Pasaje = @ID_pasaje
	PRINT 'Tarjeta de embarque borrada'
GO
rollback transaction

-- Prueba de funcionamiento
-- Cancelamos el pasaje 
EXECUTE CancelarPasaje 18

select *from AL_Vuelos
select *from AL_Vuelos_Pasajes
select *from AL_Pasajes
select *from AL_Tarjetas
WHERE Numero_Pasaje = 6

/*Ejercicio 2
Escribe un procedimiento almacenado que reciba como parámetro el ID de un pasajero y devuelva en un parámetro de salida el número de vuelos diferentes
que ha tomado ese pasajero.*/

begin transaction
GO
CREATE PROCEDURE ContarNumeroDeVuelosPorPasajero  -- Creamos procedimiento
	@ID_pasajero char(9),						  -- Variable de entrada donde se pasa el id del pasajero
	@NumeroVuelos int OUTPUT                      -- Variable de salida que guarda el numero de vuelos
AS
    BEGIN
	    -- Hacemos un select del dato que queremos almacenar en la variable de salida
		select @NumeroVuelos = COUNT(VP.Codigo_Vuelo)
		from AL_Pasajes AS P
		JOIN AL_Vuelos_Pasajes AS VP ON P.Numero = VP.Numero_Pasaje
		WHERE P.ID_Pasajero = @ID_pasajero -- buscamos el id pasado por parametro de entrada
	END
GO


-- Creamos variable para almacenar el numero de vuelos
DECLARE @NumeroVuelos int

-- Variable para pasarle el id que queremos buscar
DECLARE @ID_Pasajero char(9)

-- Buscamos un id de cualquier pasajero y lo almacenamos en la variable ID_pasajero
SET @ID_Pasajero = (SELECT ID FROM AL_Pasajeros WHERE Nombre = 'Adela')

-- Ejecutamos el procedimiento pasandole la variable de entrada y la de salida donde se almacenara
EXECUTE ContarNumeroDeVuelosPorPasajero @ID_pasajero, @NumeroVuelos OUTPUT

-- Imprimimos el numero de vuelos xDD
PRINT @NumeroVuelos

-- Si todo se fue a la puta, revertimos los cambios
rollback transaction

/*Ejercicio 3
Escribe un procedimiento almacenado que reciba como parámetro el ID de un pasajero y dos fechas y nos devuelva en otro parámetro (de salida) el número 
de horas que ese pasajero ha volado durante ese intervalo de fechas.*/
BEGIN TRANSACTION
GO
CREATE PROCEDURE CalcularHorasDeVueloEntreFechas
    -- Parametro de entrada
	@ID_Pasajero char(9),
	@fecha1 smalldatetime,
	@fecha2 smalldatetime,

	--Parametros de salida
	@numeroHorasVuelo int OUTPUT
AS
	BEGIN
		SELECT @numeroHorasVuelo = SUM(DATEDIFF(MINUTE, V.Salida, V.Llegada))
		FROM AL_Vuelos AS V
		JOIN AL_Vuelos_Pasajes AS VP ON V.Codigo = VP.Codigo_Vuelo
		JOIN AL_Pasajes AS P ON VP.Numero_Pasaje = P.Numero
		WHERE P.ID_Pasajero = @ID_Pasajero AND V.Salida BETWEEN @fecha1 AND @fecha2 AND V.Llegada BETWEEN @fecha1 AND @fecha2
		GROUP BY ID_Pasajero
	END
GO


-- Creamos variable para almacenar la salida del procedimiento
DECLARE @segundosDeVuelo int

-- Creamos variables donde le meteremos las fechas que iran como parametro
DECLARE @fecha1 smalldatetime
DECLARE @fecha2 smalldatetime

-- Variable para pasarle el id que queremos buscar
DECLARE @ID_Pasajero char(9)

-- Buscamos un id de cualquier pasajero y lo almacenamos en la variable ID_pasajero
SET @ID_Pasajero = (SELECT ID FROM AL_Pasajeros WHERE Nombre = 'Adela')

SET DATEFORMAT DMY;

-- Almacenamos las fechas que le pasaremos como parametro
SET @fecha1 = '14-1-2012'
SET @fecha2 = '20-5-2013'

-- Ejecutamos el procedimiento pasandole la variable de entrada y la de salida donde se almacenara
EXECUTE CalcularHorasDeVueloEntreFechas @ID_Pasajero, @fecha1, @fecha2, @segundosDeVuelo OUTPUT

-- Imprimimos el numero de horas de vuelos
PRINT ((@segundosDeVuelo / 60.00) / 60.00)

ROLLBACK TRANSACTION

/*Ejercicio 4
Escribe un procedimiento que reciba como parámetro todos los datos de un pasajero y un número de vuelo y realice el siguiente proceso:

En primer lugar, comprobará si existe el pasajero. Si no es así, lo dará de alta.

A continuación comprobará si el vuelo tiene plazas disponibles (hay que consultar la capacidad del avión) y en caso afirmativo creará un nuevo pasaje 
para ese vuelo.*/

BEGIN TRANSACTION


SELECT * FROM AL_Vuelos
DROP PROCEDURE CrearNuevoPasaje



GO
CREATE PROCEDURE CrearNuevoPasaje
	-- Datos del nuevo pasajero
	@ID	char(9),
	@Nombre varchar(20),
	@Apellidos varchar(50),
	@Direccion varchar(60),
	@Fecha_Nacimiento date,
	@Nacionalidad varchar(50),

	-- Vuelo
	@numeroVuelo int

AS
BEGIN
	-- Numero maximo de filas del avion
	DECLARE @MaximoFilasAvion int
	SELECT @MaximoFilasAvion = Filas
	FROM AL_Vuelos AS V
	JOIN AL_Aviones AS A ON V.Matricula_Avion = A.Matricula
	WHERE V.Codigo = 2


	-- Numero de asientos por fila
	DECLARE @NumeroAsientosFila int
	SELECT @NumeroAsientosFila = Asientos_x_Fila
	FROM AL_Vuelos AS V
	JOIN AL_Aviones AS A ON V.Matricula_Avion = A.Matricula
	WHERE V.Codigo = 2

	DECLARE @contadorFilas int 
	DECLARE @contadorAsientos int

	SET @contadorFilas = 0
	SET @contadorAsientos = 0


	IF NOT exists (SELECT Nombre FROM AL_Pasajeros WHERE Nombre = @Nombre AND Apellidos = @Apellidos)
				BEGIN 
					PRINT 'El usuario Pasajero no existe. Procederemos a crearlo'
					INSERT INTO AL_Pasajeros(Nombre, Apellidos, Direccion, Fecha_Nacimiento, Nacionalidad)
					VALUES (@Nombre, @Apellidos, @Direccion, @Fecha_Nacimiento, @Nacionalidad)
				END

	WHILE (@contadorFilas < @MaximoFilasAvion)
	BEGIN
		IF ((SELECT COUNT(Fila_Asiento) FROM AL_Tarjetas WHERE Codigo_Vuelo = 2 AND Fila_Asiento = @contadorFilas) < @MaximoFilasAvion)
		BEGIN
			INSERT INTO AL_Pasajes
			VALUES (2335, @ID)
		END
		ELSE
		BEGIN
			WHILE (@contadorAsientos < @NumeroAsientosFila)
			BEGIN
				IF ((SELECT COUNT(Letra_Asiento) FROM AL_Tarjetas WHERE Codigo_Vuelo = 2 AND Fila_Asiento = @contadorFilas) < @NumeroAsientosFila)
				BEGIN
					INSERT INTO AL_Pasajes(ID_Pasajero)
					VALUES (@ID)
				END
			END
		END
	END
END
GO

EXECUTE CrearNuevoPasaje 'A006', 'Pepe', 'asas', 'C: susmuerto', '2212-4-21', 'Brasil', 2
	










/*
WHILE @cont < 11
	BEGIN
		PRINT 'Ya van '+CAST(@cont AS VarChar)+'veces'
	SET @cont = @cont + 1
END
*/






















	BEGIN
		SELECT * FROM AL_Pasajeros

		
	END
GO
ROLLBACK TRANSACTION


/*
BEGIN TRANSACTION
GO
CREATE PROCEDURE CrearNuevoPasaje
	-- Datos del nuevo pasajero
	@ID	char(9),
	@Nombre varchar(20),
	@Apellidos varchar(50),
	@Direccion varchar(60),
	@Fecha_Nacimiento date,
	@Nacionalidad varchar(50),

	-- Vuelo
	@numeroVuelo int

AS
	BEGIN
		SELECT * FROM AL_Pasajeros

		IF NOT exists (SELECT Nombre FROM AL_Pasajeros WHERE Nombre = 'Pepito' AND Apellidos = 'Rodriguez')
			BEGIN 
				PRINT 'El usuario Pasajero no existe. Procederemos a crearlo'
				INSERT INTO AL_Pasajeros(ID, Nombre, Apellidos, Direccion, Fecha_Nacimiento, Nacionalidad)
				VALUES (@ID, @Nombre, @Apellidos, @Direccion, @Fecha_Nacimiento, @Nacionalidad)
			END
		ELSE
			BEGIN -- inicio else
				PRINT 'El Pasajero ya existe. Le asignaremos un asiento en el vuelo'
			END  -- en else
	END
GO
ROLLBACK TRANSACTION
*/



/*Ejercicio 5
Escribe un procedimiento almacenado que cancele un vuelo y reubique a sus pasajeros en otro. Se ocuparán los asientos libres en el vuelo sustituto.
Se comprobará que ambos vuelos realicen el mismo recorrido. Se borrarán todos los pasajes y las tarjetas de embarque y se generarán nuevos pasajes.
No se generarán nuevas tarjetas de embarque. El vuelo a cancelar y el sustituto se pasarán como parámetros. Si no se pasa el vuelo sustituto, 
se buscará el primer vuelo inmediatamente posterior al cancelado que realice el mismo recorrido.*/


GO
CREATE FUNCTION ComprobarVueloAvion(@Avion char(10) ,@Fecha Smalldatetime)
RETURNS NVARCHAR(50)
AS
BEGIN
	DECLARE @estaVolando NVARCHAR(50)
	DECLARE @Aeropuerto_Salida char(3)
	DECLARE @Aeropuerto_Llegada char(3)
	SELECT @Aeropuerto_Salida = ' '
	SELECT @Aeropuerto_Llegada = ' '
	IF EXISTS 
	(
		SELECT Matricula_Avion, Salida, Llegada, Aeropuerto_Salida, Aeropuerto_Llegada
		FROM AL_Vuelos
		WHERE Matricula_Avion = @Avion AND @Fecha BETWEEN Salida AND Llegada
	)
		SELECT @estaVolando = 'Esta Volando con origen '+cast(@Aeropuerto_S alida as varchar)+' y destino '+cast(@Aeropuerto_Llegada as varchar)
	ELSE
		SELECT @estaVolando = 'Esta En Tierra en el aeropuerto '+cast(@Aeropuerto_Llegada as varchar)

	RETURN @estaVolando
END
GO


/*Ejercicio 6
Escribe un procedimiento al que se pase como parámetros un código de un avión y un momento (dato fecha-hora) y nos escriba un mensaje que indique 
dónde se encontraba ese avión en ese momento. El mensaje puede ser "En vuelo entre los aeropuertos de NombreAeropuertoSalida y NombreaeropuertoLlegada” 
si el avión estaba volando en ese momento, o "En tierra en el aeropuerto NombreAeropuerto” si no está volando. Para saber en qué aeropuerto se encuentra 
el avión debemos consultar el último vuelo que realizó antes del momento indicado.
Si se omite el segundo parámetro, se tomará el momento actual.*/

GO
CREATE PROCEDURE BuscarAvion
	@Avion char(10),
	@Fecha smalldatetime
AS
BEGIN
	DECLARE @Aeropuerto_Salida char(3)
	DECLARE @Aeropuerto_Llegada char(3)
	SELECT @Aeropuerto_Salida = ' '
	SELECT @Aeropuerto_Llegada = ' '
	
	
	-- Comprobamos si existe la colsulta
	IF EXISTS 
	(
		SELECT Matricula_Avion, Salida, Llegada, Aeropuerto_Salida, Aeropuerto_Llegada
		FROM AL_Vuelos
		WHERE Matricula_Avion = @Avion AND @Fecha BETWEEN Salida AND Llegada
	)
		BEGIN
		    -- Seleccionamos los aeropuertos de salida y llegada cuando fecha este entre 'Salida' y 'Llegada'
			SELECT @Aeropuerto_Llegada = Aeropuerto_Llegada FROM AL_Vuelos WHERE Matricula_Avion = @Avion AND @Fecha BETWEEN Salida AND Llegada
			SELECT @Aeropuerto_Salida  = Aeropuerto_Salida FROM AL_Vuelos  WHERE Matricula_Avion = @Avion AND @Fecha BETWEEN Salida AND Llegada
			PRINT 'Esta Volando con origen '+cast(@Aeropuerto_Salida as varchar)+' y destino '+cast(@Aeropuerto_Llegada as varchar)
		END
	ELSE
		BEGIN
		    -- Seleccionamos el aeropuerto de llegada del ultimo vuelo
			SELECT @Aeropuerto_Llegada  = Aeropuerto_Llegada FROM AL_Vuelos  WHERE Matricula_Avion = @Avion AND  Llegada < @Fecha
			PRINT 'Esta En Tierra en el aeropuerto '+cast(@Aeropuerto_Llegada as varchar)
		END
END
GO


-- Establecememos el formato horario dd/mm/yyyy
SET DATEFORMAT DMY

-- Creamos la variable fecha para buscar por fecha
DECLARE @Fecha Smalldatetime
SELECT @Fecha = '13-09-2013 14:45:00'

-- Creamos la variable avion para buscar por matricula del avion
DECLARE @Avion char(10)
SELECT @Avion = 'ESP4502'

-- Buscamos un avion por matricula
EXECUTE BuscarAvion @Avion, @Fecha





SELECT * FROM AL_Vuelos WHERE Matricula_Avion = 'ESP4502'
ORDER BY Salida









	