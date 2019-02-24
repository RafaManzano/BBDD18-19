Use TransLeo
--Ejercicio 1

--La empresa de logística (transportes y algo más) TransLeo tiene una base de datos con la
--información de los envíos que realiza. Hay una tabla llamada TL_PaquetesNormales en la que se
--guardan los datos de los paquetes que pueden meterse en una caja normal. Las cajas normales
--son paralelepípedos de base rectangular. Las columnas alto, ancho y largo, de tipo entero,
--contienen las dimensiones de cada paquete en centímetros.

--La estructura de la tabla TL_PaquetesNormales es:
--Columna			Tipo			Comentario							Nulos
--codigo			int				Es la clave							No
--alto				int													No
--ancho				int													No
--largo				int													No
--codigoFregoneta	int				FK del vehiculo que lo entrega		Sí
--fechaEntrega		smalldatetime	Eso									Sí

--1. Crea un función fn_VolumenPaquete que reciba el código de un paquete y nos devuelva
--su volumen. El volumen se expresa en litros (dm3) y será de tipo decimal(6,2).
set dateformat ymd

GO
ALTER FUNCTION  fn_VolumenPaquete (@codigo int)
RETURNS DECIMAL (6,2) AS
BEGIN
RETURN
(
	SELECT (Alto*Ancho*Largo)*0.001 AS [Volumen]
	FROM TL_PaquetesNormales AS PN
	WHERE PN.Codigo = @codigo
)
END
GO

DECLARE @codigo int

SET @codigo = '600'

SELECT DBO.fn_VolumenPaquete (@codigo)

GO
--2. Los paquetes normales han de envolverse. Se calcula que la cantidad de papel necesaria
--para envolver el paquete es 1,8 veces su superficie. Crea una función fn_PapelEnvolver
--que reciba un código de paquete y nos devuelva la cantidad de papel necesaria para envolverlo, en metros cuadrados.

set dateformat ymd
--AT= 2AB + AL
GO
ALTER FUNCTION  fn_PapelEnvolver (@codigo int)
RETURNS TABLE AS
RETURN
(
	SELECT ((2*(Alto*Ancho)+2*(Alto*Largo)+2*(Ancho*Largo))*1.8)*0.0001 AS [Superficie]
	FROM TL_PaquetesNormales AS PN
	WHERE PN.Codigo = @codigo
)
GO

DECLARE @codigo int

SET @codigo = '600'

SELECT * FROM fn_PapelEnvolver(@codigo)

GO

--3. Crea una función fn_OcupacionFregoneta a la que se pase el código de un vehículo y una
--fecha y nos indique cuál es el volumen total que ocupan los paquetes que ese vehículo
--entregó en el día en cuestión. Usa las funciones de fecha y hora para comparar sólo el día, independientemente de la hora.

GO
ALTER FUNCTION  fn_OcupacionFregoneta (@codigoFregoneta int, @fechaEntrega SMALLDATETIME)
RETURNS TABLE AS
RETURN
(
	SELECT Alto*Ancho*Largo AS [Volumen Total]
	FROM TL_PaquetesNormales
	WHERE codigoFregoneta = @codigoFregoneta and fechaEntrega = @fechaEntrega
)
GO

DECLARE @codigoFregoneta int
DECLARE @fechaEntrega smalldatetime

SET @codigoFregoneta = '1'
SET @fechaEntrega = '2012-01-20 14:50:00'

SELECT * FROM fn_OcupacionFregoneta(@codigoFregoneta, @fechaEntrega)

GO 

--4. Crea una función fn_CuantoPapel a la que se pase una fecha y nos diga la cantidad total
--de papel de envolver que se gastó para los paquetes entregados ese día. Trata la fecha igual que en el anterior.

GO
CREATE FUNCTION  fn_CuantoPapel (@fechaEntrega SMALLDATETIME)
RETURNS TABLE AS
RETURN
(
	SELECT Alto*Ancho*Largo AS [Volumen Total]
	FROM TL_PaquetesNormales
	WHERE codigoFregoneta = @codigoFregoneta and fechaEntrega = @fechaEntrega
)
GO

DECLARE @codigoFregoneta int
DECLARE @fechaEntrega smalldatetime

SET @codigoFregoneta = '1'
SET @fechaEntrega = '2012-01-20 14:50:00'

SELECT * FROM fn_OcupacionFregoneta(@codigoFregoneta, @fechaEntrega)

GO 

--5. Modifica la función anterior para que en lugar de aceptar una fecha, acepte un rango de
--fechas (inicio y fin). Si el inicio y fin son iguales, calculará la cantidad gastada ese día. 
--Si el fin es anterior al inicio devolverá 0.

GO
ALTER FUNCTION  fn_CuantoPapel (@fechaEntrega SMALLDATETIME)
RETURNS TABLE AS
RETURN
(
	SELECT Alto*Ancho*Largo AS [Volumen Total]
	FROM TL_PaquetesNormales
	WHERE codigoFregoneta = @codigoFregoneta and fechaEntrega = @fechaEntrega
)
GO

DECLARE @codigoFregoneta int
DECLARE @fechaEntrega smalldatetime

SET @codigoFregoneta = '1'
SET @fechaEntrega = '2012-01-20 14:50:00'

SELECT * FROM fn_OcupacionFregoneta(@codigoFregoneta, @fechaEntrega)

GO 

--6. Crea una función fn_Entregas a la que se pase un rango de fechas y nos devuelva una
--tabla con los códigos de los paquetes entregados y los vehículos que los entregaron entre esas fechas.



--Ejercicio 2
--Sobre la base de datos AirLeo
USE AirLeo
--1. Diseña una función fn_distancia recorrida a la que se pase un código de avión y un rango
--de fechas y nos devuelva la distancia total recorrida por ese avión en ese rango de fechas.

--2. Diseña una función fn_horasVuelo a la que se pase un código de avión y un rango de
--fechas y nos devuelva las horas totales que ha volado ese avión en ese rango de fechas.

--3. Diseña una función a la que se pase un código de avión y un rango de fechas y nos
--devuelva una tabla con los nombres y fechas de todos los aeropuertos en que ha estado el avión en ese intervalo.
--3.Diseña una función a  la que se pase un código de avión y un rango de fechas y nos devuelva una tabla con los nombres y fechas de todos 
--los aeropuertos en que ha estado el avión en ese intervalo.

--Consulta que devuelve los aeropuertos en los que ha estado cada avión y las fechas (384 filas)
SELECT * 
	FROM AL_Aviones AS A
	INNER JOIN AL_Vuelos AS V ON V.Matricula_Avion=A.Matricula
	INNER JOIN AL_Aeropuertos AS AE ON AE.Codigo=V.Aeropuerto_Salida OR AE.Codigo=V.Aeropuerto_Llegada
	ORDER BY V.Codigo

GO
CREATE FUNCTION fn_MiAvionesEnAeropuertos (@Matricula char(10), @Inicio date, @Fin date)
RETURNS TABLE AS
RETURN
SELECT AE.Nombre AS Aeropuerto, CAST(V.Salida AS date) AS Fecha
	FROM AL_Aviones AS A
	INNER JOIN AL_Vuelos AS V ON V.Matricula_Avion=A.Matricula
	INNER JOIN AL_Aeropuertos AS AE ON AE.Codigo=V.Aeropuerto_Salida OR AE.Codigo=V.Aeropuerto_Llegada
	WHERE V.Matricula_Avion=@Matricula AND (V.Salida BETWEEN @Inicio AND @Fin) AND (V.Llegada BETWEEN @Inicio AND @Fin)
GO

SELECT * FROM AL_Vuelos order by Matricula_Avion1

SELECT * FROM dbo.fn_MiAvionesEnAeropuertos('ESP5077', '2011-01-01', '2011-01-23') 

--4. Diseña una función fn_ViajesCliente que nos devuelva nombre y apellidos, kilómetros
--recorridos y número de vuelos efectuados por cada cliente en un rango de fechas,
--ordenado de mayor a menor distancia recorrida.
