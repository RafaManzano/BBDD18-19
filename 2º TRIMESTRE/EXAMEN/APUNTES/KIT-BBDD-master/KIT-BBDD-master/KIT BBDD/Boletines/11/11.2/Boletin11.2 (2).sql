USE AirLeo
GO

--Ejercicio 1
--Escribe un procedimiento que cancele un pasaje y las tarjetas de embarque asociadas.
--Recibirá como parámetros el ID del pasaje.

ALTER PROCEDURE cancelarPasaje
	@Pasaje AS int 
AS
	DELETE FROM AL_Vuelos_Pasajes
	WHERE Numero_Pasaje=@Pasaje
	DELETE FROM Al_Tarjetas
	WHERE Numero_Pasaje=@Pasaje
	DELETE FROM Al_Pasajes
	WHERE Numero=@Pasaje
GO

EXECUTE cancelarPasaje 24

--Ejercicio 2
--Escribe un procedimiento almacenado que reciba como parámetro el ID de un pasajero y devuelva en un parámetro de salida el número de vuelos 
--diferentes que ha tomado ese pasajero.

CREATE PROCEDURE numeroVuelos
	@IDPasajero AS char(9),
	@Vuelos AS int OUTPUT
AS
	SELECT @Vuelos = COUNT(PJ.Numero)
		FROM AL_Pasajeros AS P
		INNER JOIN AL_Pasajes AS PJ ON PJ.ID_Pasajero=P.ID
	WHERE P.ID=@IDPasajero
GO

DECLARE @Vuelos INT
EXECUTE numeroVuelos 'A055', @Vuelos OUTPUT
PRINT @Vuelos

--Ejercicio 3
--Escribe un procedimiento almacenado que reciba como parámetro el ID de un pasajero y dos fechas y nos devuelva en otro parámetro (de salida) el 
--número de horas que ese pasajero ha volado durante ese intervalo de fechas.

GO
CREATE PROCEDURE horasVoladas
	@IDPasajero AS char(9),
	@Inicio AS date,
	@Fin AS date,
	@HorasVoladas AS decimal(6,2) OUTPUT
AS
SELECT @HorasVoladas = SUM(DATEDIFF(MINUTE, Salida, Llegada))
	FROM AL_Pasajeros AS P
	INNER JOIN AL_Pasajes AS PJ ON PJ.ID_Pasajero=P.ID
	INNER JOIN AL_Vuelos_Pasajes AS VP ON VP.Numero_Pasaje=PJ.Numero
	INNER JOIN AL_Vuelos AS V ON V.Codigo=VP.Codigo_Vuelo
	WHERE (Salida BETWEEN @Inicio AND @Fin) AND (Llegada BETWEEN @Inicio AND @Fin) AND P.ID=@IDPasajero
	SET @HorasVoladas=@HorasVoladas/60
GO

DECLARE @Horas decimal(6,2)
EXECUTE horasVoladas 'A003', '2012-01-12', '2012-01-15', @Horas OUTPUT
PRINT @Horas

--Ejercicio 4
--Escribe un procedimiento que reciba como parámetro todos los datos de un pasajero y un número de vuelo y realice el siguiente proceso:
--En primer lugar, comprobará si existe el pasajero. Si no es así, lo dará de alta.
--A continuación comprobará si el vuelo tiene plazas disponibles (hay que consultar la capacidad del avión) y en caso afirmativo creará un nuevo 
--pasaje para ese vuelo.

GO
ALTER PROCEDURE crearPasaje
	@IDPasajero AS char(9),
	@Nombre AS varchar(20),
	@Apellidos AS varchar(50),
	@Direccion AS varchar(60),
	@Fecha_Nacimiento AS date,
	@Nacionalidad AS varchar(30),
	@CodigoVuelo AS int
AS
	-- Comprobamos si el pasajero está registrado o no en la base de datos, si no lo está será añadido.
	IF NOT EXISTS (SELECT * FROM AL_Pasajeros 
					WHERE ID=@IDPasajero AND Nombre=@Nombre AND Apellidos=@Apellidos AND Fecha_Nacimiento=@Fecha_Nacimiento)
		BEGIN
			PRINT ('El pasajero no está registrado en la base de datos, vamos a añadirlo')
			INSERT INTO AL_Pasajeros (ID, Nombre, Apellidos, Direccion, Fecha_Nacimiento, Nacionalidad)
			VALUES (@IDPasajero, @Nombre, @Apellidos, @Direccion, @Fecha_Nacimiento, @Nacionalidad)
			PRINT('Pasajero añadido correctamente')
		END
	ELSE
		BEGIN
			PRINT('El pasajero ya está registrado')
		END

	-- SI el número de plazas ocupadas es menor al número de plazas que tiene el avión, se creará el pasaje, en otro caso no se creará.
	IF ((SELECT COUNT(P.Numero) FROM AL_Pasajes AS P 
			INNER JOIN AL_Vuelos_Pasajes AS VP ON VP.Numero_Pasaje=P.Numero 
			INNER JOIN AL_Vuelos AS V ON V.Codigo=VP.Codigo_Vuelo
			WHERE V.Codigo=@CodigoVuelo) <
		(SELECT (Filas*Asientos_x_Fila) FROM AL_Aviones AS A 
		INNER JOIN AL_Vuelos AS V ON V.Matricula_Avion=A.Matricula WHERE V.Codigo=@CodigoVuelo) )
		BEGIN
			PRINT('El avión tiene plazas disponibles, se creará un pasaje')
			INSERT INTO AL_Pasajes (ID_Pasajero)
			VALUES (@IDPasajero)
			PRINT('El pasaje se ha creado correctamente')
		END
	ELSE
		BEGIN
			PRINT('El avión no tiene plazas disponibles, no se puede crear el pasaje')
		END
GO 

EXECUTE crearPasaje 'J666', 'Jesús', 'Prieto Monge', 'Calle Araquil 12, Sevilla', '1997-01-09', 'España', 175

--Ejercicio 5
--Escribe un procedimiento almacenado que cancele un vuelo y reubique a sus pasajeros en otro. Se ocuparán los asientos libres en el vuelo sustituto. 
--Se comprobará que ambos vuelos realicen el mismo recorrido. Se borrarán todos los pasajes y las tarjetas de embarque y se generarán nuevos pasajes.
--No se generarán nuevas tarjetas de embarque. El vuelo a cancelar y el sustituto se pasarán como parámetros. Si no se pasa el vuelo sustituto, 
--se buscará el primer vuelo inmediatamente posterior al cancelado que realice el mismo recorrido.

GO
CREATE PROCEDURE reubicarVuelo
	@VueloACancelar AS int,
	@VueloSustituto AS int
AS
	
GO

--Ejercicio 6
--Escribe un procedimiento al que se pase como parámetros un código de un avión y un momento (dato fecha-hora) y nos escriba un mensaje que indique 
--dónde se encontraba ese avión en ese momento. El mensaje puede ser "En vuelo entre los aeropuertos de NombreAeropuertoSalida y 
--NombreaeropuertoLlegada” si el avión estaba volando en ese momento, o "En tierra en el aeropuerto NombreAeropuerto” si no está volando. 
--Para saber en qué aeropuerto se encuentra el avión debemos consultar el último vuelo que realizó antes del momento indicado.
--Si se omite el segundo parámetro, se tomará el momento actual.

GO
CREATE PROCEDURE localizarAvion
	@Matricula AS char(10),
	@Momento AS smalldatetime
AS
	
GO