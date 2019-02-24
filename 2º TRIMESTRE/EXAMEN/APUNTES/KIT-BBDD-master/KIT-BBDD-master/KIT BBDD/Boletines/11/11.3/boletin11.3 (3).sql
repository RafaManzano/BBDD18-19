
SELECT * FROM TL_PaquetesNormales

--1. Crea un función fn_VolumenPaquete que reciba el código de un paquete y nos devuelva su volumen.
--El volumen se expresa en litros (dm3) y será de tipo decimal(6,2).
GO
CREATE FUNCTION fn_calcularVolumen (@CodigoPaquete int)
RETURNS decimal(6,2) AS
    BEGIN
		DECLARE @volumen decimal(6,2) -- Variable para almacenar el volumen que luego se devuelve
		SELECT @volumen = CAST (((Alto * Ancho * Largo) * 0.001) AS decimal(6,2)) 
		FROM TL_PaquetesNormales -- Asignamos el resultado de la 
		WHERE Codigo = @CodigoPaquete                                              -- consulta a @volumen
		RETURN @volumen
	END 
GO

SELECT dbo.fn_calcularVolumen(600)

--2. Los paquetes normales han de envolverse. Se calcula que la cantidad de papel necesaria 
--para envolver el paquete es 1,8 veces su superficie. Crea una función fn_PapelEnvolver que reciba un código de paquete
--y nos devuelva la cantidad de papel necesaria para envolverlo, en metros cuadrados.
GO
CREATE FUNCTION fn_calcularSuperficie (@CodigoPaquete int) 
RETURNS decimal(6,2) AS
    BEGIN
		DECLARE @Superficie decimal(6,2) -- Variable para almacenar el volumen que luego se devuelve
		SELECT @Superficie = CAST ( ((Alto * Ancho + Alto * Largo + Ancho * Alto) * 2) * 1.8 * 0.001  AS decimal(6,2)) 
		FROM TL_PaquetesNormales -- Asignamos el resultado de la 
		WHERE Codigo = @CodigoPaquete                                                   -- consulta a @volumen
		RETURN @superficie 
	END 
GO

SELECT dbo.fn_calcularSuperficie (600)

SELECT * FROM TL_PaquetesNormales

--SET @fecha1 = smalldatetimefromparts (2015,04,03,08,40)
--3. Crea una función fn_OcupacionFregoneta a la que se pase el código de un vehículo y una fecha 
--y nos indique cuál es el volumen total que ocupan los paquetes que ese vehículo entregó en el día en cuestión. 
--Usa las funciones de fecha y hora para comparar sólo el día, independientemente de la hora.
GO
ALTER FUNCTION fn_OcupacionFregoneta(@CodigoFregoneta int, @Fecha DATE) 
RETURNS decimal(6,2) AS
    BEGIN
		DECLARE @VolumenTotal decimal(6,2)
		SELECT @volumenTotal = SUM(dbo.fn_calcularVolumen(Codigo))
		FROM TL_PaquetesNormales 
		WHERE codigoFregoneta = @CodigoFregoneta AND CAST(fechaEntrega AS DATE) = @Fecha
		RETURN @VolumenTotal 
	END 
GO

DECLARE @fecha1 DATE
SET @fecha1 = datefromparts (2015,04,03)
SELECT dbo.fn_OcupacionFregoneta('6', @fecha1)

SELECT  * from TL_PaquetesNormales

--4. Crea una función fn_CuantoPapel a la que se pase una fecha y nos diga la cantidad total de papel de envolver
--que se gastó para los paquetes entregados ese día. Trata la fecha igual que en el anterior.
GO
ALTER FUNCTION fn_CuantoPapel (@fecha DATE) 
RETURNS decimal(6,2) AS
    BEGIN
		DECLARE @cantidadPapel decimal(6,2) -- Variable para almacenar el volumen que luego se devuelve
		SELECT @cantidadPapel = dbo.fn_calcularSuperficie(Codigo)
		FROM TL_PaquetesNormales -- Asignamos el resultado de la 
		WHERE CAST(fechaEntrega AS DATE) = @Fecha              -- consulta a @volumen
		RETURN @cantidadPapel 
	END 
GO

DECLARE @fecha DATE
SET @fecha = datefromparts (2015,04,03)
SELECT dbo.fn_CuantoPapel(@fecha)

SELECT  * from TL_PaquetesNormales

--5. Modifica la función anterior para que en lugar de aceptar una fecha, acepte un rango de fechas (inicio y fin). 
--Si el inicio y fin son iguales, calculará la cantidad gastada ese día. Si el fin es anterior al inicio devolverá 0.
GO
CREATE FUNCTION fn_CuantoPapelRango (@fecha1 DATE, @fecha2 DATE ) 
RETURNS decimal(6,2) AS
    BEGIN
		DECLARE @cantidadPapel decimal(6,2) -- Variable para almacenar el volumen que luego se devuelve
		SELECT @cantidadPapel = CAST ( ((Alto * Ancho + Alto * Largo + Ancho * Alto) * 2) * 1.8 * 0.001  AS decimal(6,2)) 
		FROM TL_PaquetesNormales -- Asignamos el resultado de la 
		WHERE CAST(fechaEntrega AS DATE) BETWEEN @Fecha1 AND @Fecha2
		RETURN @cantidadPapel 
	END 
GO

DECLARE @fecha DATE
SET @fecha = datefromparts (2015,04,03)
SELECT dbo.fn_CuantoPapel(@fecha)

SELECT  * from TL_PaquetesNormales

--6. Crea una función fn_Entregas a la que se pase un rango de fechas y nos devuelva una tabla con los códigos
--de los paquetes entregados y los vehículos que los entregaron entre esas fechas.
GO
CREATE FUNCTION fn_Entregas(@Fecha1 DATE, @Fecha2 DATE) 
RETURNS TABLE
AS
		RETURN (SELECT Codigo, codigoFregoneta 
				 FROM TL_PaquetesNormales 
				 WHERE CAST(fechaEntrega AS DATE) BETWEEN @Fecha1 AND @Fecha2)
GO

DECLARE @fecha1 datetime
DECLARE @fecha2 datetime

SET @fecha1 = datefromparts (2010,01,01)
SET @fecha2 = datefromparts (2016,10,04)

SELECT * FROM dbo.fn_Entregas(@fecha1, @fecha2)

SELECT * FROM TL_PaquetesNormales

/*
GO
ALTER FUNCTION fn_Entregas(@Fecha1 DATE, @Fecha2 DATE) 
RETURNS @Resultado TABLE
(
	Codigo int Not NULL,
	codigoFregoneta int NULL
) 
AS
    BEGIN
		INSERT @Resultado (Codigo, codigoFregoneta)
			SELECT Codigo, codigoFregoneta
			FROM TL_PaquetesNormales
			WHERE CAST(fechaEntrega AS DATE) BETWEEN @Fecha1 AND @Fecha2
		RETURN
	END 
GO

DECLARE @fecha1 datetime
DECLARE @fecha2 datetime

SET @fecha1 = datefromparts (2010,01,01)
SET @fecha2 = datefromparts (2016,10,04)

SELECT * FROM dbo.fn_Entregas(@fecha1, @fecha2)

SELECT * FROM TL_PaquetesNormales
*/

-------------------------------------------------------------------------

--Sobre la base de datos AirLeo
--1. Diseña una función fn_distancia recorrida a la que se pase un código de avión y un rango
--de fechas y nos devuelva la distancia total recorrida por ese avión en ese rango de
--fechas.
GO
	CREATE FUNCTION fn_distancia(@codigoAvion int, @Fecha1 DATE, @Fecha2 DATE) 
	RETURNS int
	AS
	BEGIN
		DECLARE @distanciaRecorrida int

		SELECT 
			
		RETURN @distanciaRecorrida
	END
GO

--2. Diseña una función fn_horasVuelo a la que se pase un código de avión y un rango de
--fechas y nos devuelva las horas totales que ha volado ese avión en ese rango de fechas.
--© IES Nervión. Departamento de Informática

--3. Diseña una función a la que se pase un código de avión y un rango de fechas y nos
--devuelva una tabla con los nombres y fechas de todos los aeropuertos en que ha estado
--el avión en ese intervalo.

--4. Diseña una función fn_ViajesCliente que nos devuelva nombre y apellidos, kilómetros
--recorridos y número de vuelos efectuados por cada cliente en un rango de fechas,
--ordenado de mayor a menor distancia recorrida.