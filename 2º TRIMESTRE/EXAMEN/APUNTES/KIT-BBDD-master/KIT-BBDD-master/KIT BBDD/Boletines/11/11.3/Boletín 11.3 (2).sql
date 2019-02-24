SET DATEFORMAT YMD
--CREATE DATABASE TransLeo
--GO
--CREATE TABLE TL_PaquetesNormales(
--	Codigo INT
--	,Alto INT
--	,Ancho INT
--	,Largo INT
--	,CodigoFregoneta INT
--	,FechaEntrega SMALLDATETIME
--	,CONSTRAINT PK_PaquetesNormales PRIMARY KEY(Codigo)
--)
--GO
--INSERT INTO [dbo].[TL_PaquetesNormales]
--           ([Codigo]
--           ,[Alto]
--           ,[Ancho]
--           ,[Largo]
--           ,[CodigoFregoneta]
--           ,[FechaEntrega])
--     VALUES
--           (1,10,20,30,1,'2017-03-30')
--GO
--GO
/*1. Crea un función fn_VolumenPaquete que reciba el código de un paquete y nos devuelva su volumen.
El volumen se expresa en litros (dm3) y será de tipo decimal(6,2).*/
GO
CREATE FUNCTION fn_VolumenPaquete (@CodPaquete INT)
RETURNS DECIMAL(6,2)
BEGIN
	DECLARE @Volumen DECIMAL(6,2)
	SET @Volumen = (SELECT Alto*Ancho*Largo
					FROM TL_PaquetesNormales
					WHERE @CodPaquete=Codigo)*0.001
	RETURN @Volumen
END
GO
SELECT dbo.fn_VolumenPaquete(600)

/*2. Los paquetes normales han de envolverse. Se calcula que la cantidad de papel necesaria
para envolver el paquete es 1,8 veces su superficie. Crea una función fn_PapelEnvolver
que reciba un código de paquete y nos devuelva la cantidad de papel necesaria para
envolverlo, en metros cuadrados.*/
/*Área=2ab+2ac+2bc
c=Largo
b=Ancho
a=Alto*/
GO
CREATE FUNCTION fn_PapelEnvolver (@CodPaquete INT)
RETURNS DECIMAL(6,2)
BEGIN
	DECLARE @CantidadPapel DECIMAL(6,2)
	SET @CantidadPapel=(SELECT ((2*Alto*Ancho)+(2*Alto*Largo)+(2*Ancho*Largo)*1.8)*0.0001
						FROM TL_PaquetesNormales
						WHERE @CodPaquete=Codigo)
	RETURN @CantidadPapel
END
GO
SELECT dbo.fn_PapelEnvolver(600)

/*3. Crea una función fn_OcupacionFregoneta a la que se pase el código de un vehículo y una
fecha y nos indique cuál es el volumen total que ocupan los paquetes que ese vehículo
entregó en el día en cuestión. Usa las funciones de fecha y hora para comparar sólo el
día, independientemente de la hora.*/
GO
SELECT P.Codigo, P.codigoFregoneta
FROM TL_PaquetesNormales AS P
GROUP BY P.Codigo,P.codigoFregoneta
GO
CREATE FUNCTION fn_OcupacionFregoneta(@CodVehiculo INT, @Fecha DATE)
RETURNS DECIMAL (6,2)
BEGIN
	DECLARE @VolumenOcupado DECIMAL(6,2)
	SET @VolumenOcupado=(SELECT SUM(dbo.fn_VolumenPaquete(Codigo))
						 FROM TL_PaquetesNormales
						 WHERE codigoFregoneta=@CodVehiculo AND CAST(fechaEntrega AS DATE)=@Fecha)
	RETURN @VolumenOcupado
END
GO
SELECT dbo.fn_OcupacionFregoneta(6,'2015-04-01')
/*4. Crea una función fn_CuantoPapel a la que se pase una fecha y nos diga la cantidad total
de papel de envolver que se gastó para los paquetes entregados ese día. Trata la fecha
igual que en el anterior.*/
GO
CREATE FUNCTION fn_CuantoPapel(@Fecha DATE)
RETURNS DECIMAL(6,2)
BEGIN
	DECLARE @Papelaso DECIMAL(6,2)
	SET @Papelaso= (SELECT SUM(dbo.fn_PapelEnvolver(Codigo))
					FROM TL_PaquetesNormales
					WHERE CAST(fechaEntrega AS DATE)=@Fecha)
	RETURN @Papelaso
END
GO
SELECT dbo.fn_CuantoPapel('2015-04-01')
/*5. Modifica la función anterior para que en lugar de aceptar una fecha, acepte un rango de
fechas (inicio y fin). Si el inicio y fin son iguales, calculará la cantidad gastada ese día. Si
el fin es anterior al inicio devolverá 0.*/

GO
ALTER FUNCTION fn_CuantoPapelmejorada(@FechaInicio DATE, @FechaFin DATE)
RETURNS DECIMAL(6,2)
BEGIN
	DECLARE @Papelaso DECIMAL(6,2)
	SET @Papelaso=
	CASE
	WHEN @FechaFin<@FechaInicio THEN 0
	ELSE (SELECT SUM(dbo.fn_PapelEnvolver(Codigo))
		  FROM TL_PaquetesNormales
		  WHERE CAST(fechaEntrega AS DATE) BETWEEN @FechaInicio AND @FechaFin)
	END
	RETURN @Papelaso
END
GO
SELECT dbo.fn_CuantoPapelmejorada('2015-04-01','2015-04-01')
SELECT dbo.fn_CuantoPapelmejorada('2015-04-01','2015-03-01')
SELECT dbo.fn_CuantoPapelmejorada('2015-04-01','2015-04-03')

/*6. Crea una función fn_Entregas a la que se pase un rango de fechas y nos devuelva una
tabla con los códigos de los paquetes entregados y los vehículos que los entregaron entre
esas fechas.*/
GO
CREATE FUNCTION fn_Entregas(@FechaInicio DATE, @FechaFin DATE)
RETURNS TABLE AS
RETURN(
	SELECT Codigo,codigoFregoneta
	FROM TL_PaquetesNormales
	WHERE CAST(fechaEntrega AS DATE) BETWEEN @FechaInicio AND @FechaFin
)
GO
SELECT * FROM dbo.fn_Entregas('2012-01-20','2015-09-06')
GO
USE AirLeo
GO
--Ejercicio 2: AirLeo
/*1. Diseña una función fn_distancia recorrida a la que se pase un código de avión y un rango
de fechas y nos devuelva la distancia total recorrida por ese avión en ese rango de
fechas.*/
GO
ALTER FUNCTION fn_distancia_recorrida (@CodAvion CHAR(10), @FechaInicio SMALLDATETIME, @FechaFin SMALLDATETIME)
RETURNS DECIMAL (12,4) 
BEGIN
	DECLARE @Distancia DECIMAL(12,4)
	SET @Distancia = (SELECT SUM(D.Distancia) AS [Distancia Recorrida]
					  FROM AL_Vuelos AS V
					  INNER JOIN AL_Distancias AS D ON V.Aeropuerto_Salida=D.Origen AND V.Aeropuerto_Llegada=D.Destino OR (V.Aeropuerto_Salida=D.Destino AND V.Aeropuerto_Llegada=D.Origen)
					  WHERE V.Matricula_Avion=@CodAvion AND (Salida BETWEEN @FechaInicio AND @FechaFin)
					  GROUP BY V.Matricula_Avion)
	RETURN @Distancia
END
GO
SET DATEFORMAT YMD
SELECT dbo.fn_distancia_recorrida('USA5068','2008-01-14 14:05:00','2008-02-14 17:30:00')

/*2. Diseña una función fn_horasVuelo a la que se pase un código de avión y un rango de
fechas y nos devuelva las horas totales que ha volado ese avión en ese rango de fechas.*/
GO
CREATE FUNCTION fn_horasVuelo(@CodAvion CHAR(10), @FechaInicio SMALLDATETIME, @FechaFin SMALLDATETIME)
RETURNS DECIMAL(12,4)
BEGIN
	DECLARE @horasVuelo DECIMAL(12,4)
	SET @horasVuelo = (SELECT SUM(DATEDIFF(MINUTE,Salida,Llegada)/60.00) AS [Horas de Vuelo]
					   FROM AL_Vuelos AS V
					   WHERE @CodAvion=V.Matricula_Avion AND Salida BETWEEN @FechaInicio AND @FechaFin)
	RETURN @horasVuelo
END
GO
SET DATEFORMAT YMD
SELECT dbo.fn_horasVuelo('USA5068   ','2008-01-14 14:05:00','2008-01-14 17:30:00')
/*3. Diseña una función a la que se pase un código de avión y un rango de fechas y nos
devuelva una tabla con los nombres y fechas de todos los aeropuertos en que ha estado
el avión en ese intervalo.*/
GO
create FUNCTION fn_DatosAvion(@CodAvion CHAR(10),@FechaInicio DATE, @FechaFin DATE)
RETURNS TABLE AS
RETURN(
	SELECT A.Nombre,AeropuertosRaro.Fecha
	FROM AL_Aeropuertos AS A
	INNER JOIN (SELECT V.Aeropuerto_Salida AS Aeropuerto,CAST(V.Salida AS DATE) AS Fecha
				FROM AL_Vuelos AS V
				WHERE V.Matricula_Avion=@CodAvion AND (CAST(Salida AS DATE) BETWEEN @FechaInicio AND					@FechaFin )
				UNION
				SELECT V.Aeropuerto_Llegada AS Aeropuerto,CAST(V.Llegada AS DATE) AS Fecha
				FROM AL_Vuelos AS V
				WHERE V.Matricula_Avion=@CodAvion AND CAST(Llegada AS DATE) BETWEEN @FechaInicio AND					@FechaFin
				) AS AeropuertosRaro ON A.Codigo=AeropuertosRaro.Aeropuerto
	--WHERE V.Matricula_Avion=@CodAvion AND Salida BETWEEN @FechaInicio AND @FechaFin AND Llegada BETWEEN @FechaInicio AND @FechaFin
	
)
GO
SET DATEFORMAT YMD
DECLARE @Variable DATE
SET @Variable='2008-01-14'
DECLARE @Variable2 DATE
SET @Variable2='2011-08-14'
SELECT * FROM dbo.fn_DatosAvion('ESP8067   ',@Variable,@Variable2)
SELECT * FROM dbo.fn_DatosAvion('ESP8067   ','2008-01-14','2011-08-14')

/*4. Diseña una función fn_ViajesCliente que nos devuelva nombre y apellidos, kilómetros
recorridos y número de vuelos efectuados por cada cliente en un rango de fechas,
ordenado de mayor a menor distancia recorrida.*/
GO
ALTER FUNCTION fn_ViajesCliente (@FechaInicio DATETIME, @FechaFin DATETIME)
RETURNS TABLE AS
RETURN(
	SELECT P.Nombre,P.Apellidos, SUM(D.Distancia) AS [Kilómetros Recorridos],COUNT(P.ID) AS [Número de viajes]
	FROM AL_Pasajeros AS P
	INNER JOIN AL_Pasajes AS Pasajes ON P.ID=Pasajes.ID_Pasajero
	INNER JOIN AL_Vuelos_Pasajes AS VP ON Pasajes.Numero=VP.Numero_Pasaje
	INNER JOIN AL_Vuelos AS V ON VP.Codigo_Vuelo=V.Codigo
	INNER JOIN AL_Distancias AS D ON V.Aeropuerto_Salida=D.Origen AND V.Aeropuerto_Llegada=D.Destino
	WHERE V.Llegada BETWEEN @FechaInicio AND @FechaFin AND VP.Embarcado='S'
	GROUP BY P.Nombre,P.Apellidos
)
GO
SET DATEFORMAT YMD
SELECT * FROM fn_ViajesCliente('2008-01-14 14:05:00','2011-04-14 17:30:00')