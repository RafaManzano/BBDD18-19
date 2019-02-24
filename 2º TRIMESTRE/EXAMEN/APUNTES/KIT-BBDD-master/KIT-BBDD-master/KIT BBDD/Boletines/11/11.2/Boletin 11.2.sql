USE AirLeo
SET DATEFORMAT YMD
--1.Escribe un procedimiento que cancele un pasaje y las tarjetas de embarque asociadas.
--Recibirá como parámetros el ID del pasaje.
GO
CREATE PROCEDURE CancelarPasajeYTarjetaEmbarque -- Creamos el procedimiento
		@IDPasaje int							--Creamos los parámetros(entrada y salida)
AS
BEGIN											--Instrucciones que devolverá el procedimiento
	BEGIN TRANSACTION	
		DELETE AL_Tarjetas WHERE @IDPasaje = Numero_Pasaje
		DELETE AL_Vuelos_Pasajes WHERE @IDPasaje = Numero_Pasaje
		DELETE AL_Pasajes WHERE @IDPasaje = Numero
	COMMIT TRANSACTION 

END
GO
DECLARE @IDPasaje int = 1						--Declaramos el parámetro y le damos un valor
EXECUTE CancelarPasajeYTarjetaEmbarque @IDPasaje --Ejecutamos el procedimiento

--2.Escribe un procedimiento almacenado que reciba como parámetro el ID de un pasajero y 
--devuelva en un parámetro de salida el número de vuelos diferentes que ha tomado ese pasajero.
GO
CREATE PROCEDURE NumeroVuelosDiferentes
		@IDPasajero char(9),
		@NumeroVuelos int OUTPUT
AS
BEGIN
	SELECT @IDPasajero AS [ID Pasajero], COUNT(DISTINCT(Codigo_Vuelo)) AS [Número de vuelos]
	FROM AL_Pasajeros AS P
	JOIN AL_Pasajes AS PA ON P.ID = PA.ID_Pasajero
	JOIN AL_Vuelos_Pasajes AS VP ON PA.Numero = VP.Numero_Pasaje
	WHERE @IDPasajero = ID_Pasajero AND VP.Embarcado = 'S'
END
GO
DECLARE @IDPasajero char(9) = 'A003'
DECLARE @NumeroVuelos int 
EXECUTE NumeroVuelosDiferentes @IDPasajero,@NumeroVuelos OUTPUT

DROP PROCEDURE NumeroVuelosDiferentes

SELECT * FROM AL_Pasajeros

--3.Escribe un procedimiento almacenado que reciba como parámetro el ID de un pasajero y 
--dos fechas y nos devuelva en otro parámetro (de salida) el número de horas que ese pasajero 
--ha volado durante ese intervalo de fechas.

GO
CREATE PROCEDURE NumeroHorasVoladas
		@IDPasajero char(9),
		@Fecha1 smalldatetime, 
		@Fecha2 smalldatetime,
		@NumeroHoras int OUTPUT 
AS
BEGIN 
SELECT sum(DATEDIFF(HOUR,Salida,Llegada)) AS [Horas vuelo]
FROM AL_Vuelos AS V 
JOIN AL_Vuelos_Pasajes AS VP ON V.Codigo = VP.Codigo_Vuelo
JOIN AL_Pasajes AS P ON VP.Numero_Pasaje = P.Numero
JOIN AL_Pasajeros AS PA ON P.ID_Pasajero = PA.ID
WHERE (Salida BETWEEN @Fecha1 AND @Fecha2) AND ID_Pasajero = @IDPasajero
END
GO
DECLARE @IDPasajero char(9) = 'A003'
DECLARE @Fecha1 smalldatetime = '2008-01-14 14:05:00'
DECLARE @Fecha2 smalldatetime = '2009-11-14 17:30:00'
DECLARE @NumeroHoras int
EXECUTE NumeroHorasVoladas @IDPasajero,@Fecha1,@Fecha2, @NumeroHoras OUTPUT 

SELECT * FROM AL_Vuelos
DROP PROCEDURE NumeroHorasVoladas
GO
/*4.Escribe un procedimiento que reciba como parámetro todos los datos de un pasajero y un número de vuelo y realice el siguiente proceso:
En primer lugar, comprobará si existe el pasajero. Si no es así, lo dará de alta.
A continuación comprobará si el vuelo tiene plazas disponibles (hay que consultar la capacidad del avión) y en caso afirmativo creará 
un nuevo pasaje para ese vuelo.*/

CREATE PROCEDURE ComprobarPlazasYCrearPasaje
		@IDPasajero char(9),
		@Nombre varchar(20), 
		@Apellidos varchar(50),
		@Direccion varchar(60),
		@Fecha_Nacimiento date ,
		@Nacionalidad varchar(30),
		@NumeroVuelo int
AS
BEGIN 	
	DECLARE @NumeroTotalDePasajes int --Declaramos variable para guardar el numero de pasajes que tiene el vuelo que hemos indicado(@numerovuelo)
	DECLARE @NumeroDelPasaje int --Declaramos la variable numero del pasaje(código) que se autorellenará al ser IDENTITY
	DECLARE @CapacidadAvion int --Declaramos variable para guardar la capacidad del avión

	IF NOT EXISTS(SELECT * FROM AL_Pasajeros WHERE ID=@IDPasajero AND Nombre=@Nombre AND Apellidos=@Apellidos) --Comprobamos que el cliente no existe
		BEGIN
			INSERT AL_Pasajeros (ID,Nombre,Apellidos,Direccion,Fecha_Nacimiento,Nacionalidad)  --Insertamos el nuevo cliente
			VALUES(@IDPasajero,@Nombre,@Apellidos,@Direccion,@Fecha_Nacimiento,@Nacionalidad)
		END
	ELSE PRINT 'El cliente ya existe '
	-- END IF

	SELECT @CapacidadAvion = Filas*Asientos_x_Fila FROM AL_Aviones AS A
	INNER JOIN AL_Vuelos AS V ON A.Matricula = V.Matricula_Avion
	WHERE @NumeroVuelo = V.Codigo 

	
	SELECT @NumeroTotalDePasajes = COUNT(Numero_Pasaje) FROM AL_Vuelos_Pasajes AS VP
	WHERE @NumeroVuelo = VP.Codigo_Vuelo	
	
	BEGIN TRANSACTION 
	IF(@CapacidadAvion>@NumeroTotalDePasajes) --Comprobamos si hay plazas disponibles en el vuelo que hemos indicado(@numerovuelo) 
		BEGIN 
		BEGIN TRANSACTION
			INSERT AL_Pasajes(ID_Pasajero)
			VALUES(@IDPasajero)
			
			SET @NumeroDelPasaje = @@IDENTITY  --Rellenamos la variable numero del pasaje con IDENTITY

			INSERT AL_Vuelos_Pasajes(Codigo_Vuelo,Numero_Pasaje,Embarcado) --Insertamos un nuevo pasaje con las variables creadas
			VALUES(@NumeroVuelo,@NumeroDelPasaje,'N')      
		
		END
	ELSE
		BEGIN
			RAISERROR('El avión está completamente lleno',4,1) --Mostramos un mensaje si no hay plazas disponibles en el vuelo que hemos insertado(@numerovuelo)
		END
-- END IF
COMMIT TRANSACTION 
END

GO
SET DATEFORMAT YMD
DECLARE @IDPasajero char(9) = 'J334'
DECLARE @Nombre varchar(20) = 'Nzdeh'
DECLARE	@Apellidos varchar(50) = 'Yeghyzarian'
DECLARE	@Direccion varchar(60) = 'Make Armenia Great Again'
DECLARE	@Fecha_Nacimiento date = '1997-09-05'
DECLARE	@Nacionalidad varchar(30) = 'Armenia'
DECLARE	@NumeroVuelo int = '3'

EXECUTE ComprobarPlazasYCrearPasaje @IDPasajero,@Nombre,@Apellidos,@Direccion,@Fecha_Nacimiento,@Nacionalidad,@NumeroVuelo


 
SELECT * FROM AL_Pasajeros
SELECT * FROM AL_Pasajes
SELECT * FROM AL_Vuelos



/*5.Escribe un procedimiento almacenado que cancele un vuelo y reubique a sus pasajeros en otro. 
Se ocuparán los asientos libres en el vuelo sustituto.
Se comprobará que ambos vuelos realicen el mismo recorrido. 
Se borrarán todos los pasajes y las tarjetas de embarque y se generarán nuevos 
pasajes. No se generarán nuevas tarjetas de embarque.
El vuelo a cancelar y el sustituto se pasarán como parámetros. 
Si no se pasa el vuelo sustituto,se buscará el primer vuelo inmediatamente posterior al cancelado que realice el mismo recorrido.*/
 
	--1.COMPROBAR VUELOS QUE HACEN EL MISMO RECORRIDO
		--CASO 1: QUE EL SUSTITUTO ESTE A NULL
		--CASO 2: QUE TE PASEN LOS DOS Y AMBOS SEAN CORRECTOS
		--CASO 3:ELSE RAISERROR(EL VUELO ES INCORRECTO)
	--2.COMPROBAR ASIENTOS OCUPADOS EN EL VUELO QUE CANCELEN
	--3.COMPROBAR ASIENTOS LIBRES EN EL VUELO SUSTITUTO
	--4.COMPROBAR SI CABEN
	--5.INSERT SELECT EN PASAJES Y VUELOS PASAJES
	--6.BORRAR DE PASAJES
	--7.BORRAR DE VUELOS PASAJES



CREATE PROCEDURE CancelarVueloYReubicarPasajeros
		@CodigoVueloCancelado int,
		@CodigoVueloSustituto int
AS
BEGIN
	DECLARE @AeropuertoSalida char(3)
	DECLARE @AeropuertoLlegada char(3)
	DECLARE @PasajerosVueloCancelado int
	DECLARE @PasajerosVueloSustituto int
	DECLARE @AsientosLibresVueloSustituto int
	
	 

	--1.Comprobar vuelo(codigo vuelo pasado por parametro) que hacen el mismo recorrido
	SELECT @AeropuertoSalida = Aeropuerto_Salida, @AeropuertoLlegada = Aeropuerto_Salida
	FROM AL_Vuelos
	WHERE Codigo = @CodigoVueloCancelado

	--2.Comprobar asientos ocupados en el vuelo cancelado(pasado por parametro)
	SELECT @PasajerosVueloCancelado = COUNT(Numero_Pasaje) FROM AL_Vuelos_Pasajes AS VP
	WHERE @CodigoVueloCancelado = VP.Codigo_Vuelo

	--Pasajeros vuelo sustituto
	SELECT @PasajerosVueloSustituto = COUNT(Numero_Pasaje) FROM AL_Vuelos_Pasajes AS VP
	WHERE @CodigoVueloSustituto = VP.Codigo_Vuelo


	--3.Comprobar asientos libres en el vuelo sustituto
	SELECT @AsientosLibresVueloSustituto = ((Asientos_x_Fila * Filas)-@PasajerosVueloSustituto)  FROM AL_Vuelos_Pasajes AS VP
	INNER JOIN AL_Vuelos AS V ON VP.Codigo_Vuelo = V.Codigo
	INNER JOIN AL_Aviones AS A ON V.Matricula_Avion = A.Matricula
	WHERE Codigo = @CodigoVueloSustituto

	--4.Comprobar si los pasajeros del vuelo cancelado, caben en el vuelo sustituto
	BEGIN TRANSACTION
	IF(@AsientosLibresVueloSustituto>@PasajerosVueloCancelado)
		BEGIN
			BEGIN TRANSACTION
				INSERT INTO AL_Pasajes(ID_Pasajero)
				SELECT ID FROM AL_Pasajeros AS P
				INNER JOIN AL_Pasajes AS PA ON P.ID = PA.ID_Pasajero
				INNER JOIN AL_Vuelos_Pasajes AS VP ON PA.Numero = VP.Numero_Pasaje
				WHERE Codigo_Vuelo = @CodigoVueloCancelado

				INSERT INTO AL_Vuelos_Pasajes
				SELECT ID,'N' FROM AL_Pasajeros AS P
				INNER JOIN AL_Pasajes AS PA ON P.ID = PA.ID_Pasajero
				INNER JOIN AL_Vuelos_Pasajes AS VP ON PA.Numero = VP.Numero_Pasaje
				WHERE Codigo_Vuelo = @CodigoVueloCancelado

				select * from AL_Vuelos_Pasajes

				DELETE FROM AL_Pasajes WHERE @CodigoVueloCancelado =
			COMMIT TRANSACTION
		END
	ELSE PRINT 'No hay asientos suficientes para los pasajeros reubicados en este vuelo'
	--END IF


		 




END

GO
					



/*6.Escribe un procedimiento al que se pase como parámetros un código de un avión y un momento
(dato fecha-hora) y nos escriba un mensaje que indique dónde se encontraba ese avión en ese
momento. El mensaje puede ser "En vuelo entre los aeropuertos de NombreAeropuertoSalida y
NombreaeropuertoLlegada” si el avión estaba volando en ese momento, o "En tierra en el
aeropuerto NombreAeropuerto” si no está volando. Para saber en qué aeropuerto se encuentra 
el avión debemos consultar el último vuelo que realizó antes del momento indicado.
Si se omite el segundo parámetro, se tomará el momento actual.*/