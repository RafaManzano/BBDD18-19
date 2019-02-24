--EJERCICIO 1
USE TransLeo
GO
select * from TL_PaquetesNormales order by fechaEntrega
--1. Crea un función fn_VolumenPaquete que reciba el código de un paquete y nos devuelva su volumen. El volumen se expresa en litros (dm3)  y será de 
--tipo decimal(6,2).

CREATE FUNCTION fn_MiVolumenPaquete (@CodigoPaquete int)
RETURNS decimal(6, 2)
AS
BEGIN
	DECLARE @Volumen AS decimal(6,2)
	SELECT @Volumen = (Alto*Ancho*CAST(Largo AS decimal(6,2)))/1000 FROM TL_PaquetesNormales WHERE Codigo=@CodigoPaquete
	RETURN @Volumen
END
GO

SELECT DBO.fn_MiVolumenPaquete(603)

--2. Los paquetes normales han de envolverse. Se calcula que la cantidad de papel necesaria para envolver el paquete es 1,8 veces su superficie. 
--Crea una función fn_PapelEnvolverque reciba un código de paquete y nos devuelva la cantidad de papel necesaria para envolverlo, en metros cuadrados.
--(((Ancho*Largo)*2)+((Ancho*Alto)*2)+((Largo*Alto)*2))/10000

GO
ALTER FUNCTION fn_PapelEnvolver (@CodigoPaquete int)
RETURNS decimal(8, 2)
AS
BEGIN
	DECLARE @PapelNecesario AS decimal(8,2)
	SELECT @PapelNecesario = ((CAST(Ancho AS decimal(8,2))*Largo)/10000)*1.8 FROM TL_PaquetesNormales WHERE Codigo=@CodigoPaquete
	RETURN @PapelNecesario
END
GO

SELECT DBO.fn_PapelEnvolver (2502)

--3. Crea una función fn_OcupacionFregoneta a la que se pase el código de un vehículo y una fecha y nos indique cuál es el volumen total que ocupan 
--los paquetes que ese vehículo entregó en el día en cuestión. Usa las funciones de fecha y hora para comparar sólo el día, independientemente 
--de la hora.

GO
CREATE FUNCTION fn_OcupacionFregoneta (@Fregoneta AS int, @Fecha date)
RETURNS decimal(6,2)
AS
BEGIN
	DECLARE @Volumen AS decimal(6, 2)
	SELECT @Volumen = SUM(DBO.fn_MiVolumenPaquete(Codigo))
		FROM TL_PaquetesNormales 
		WHERE codigoFregoneta=@Fregoneta AND CAST(fechaEntrega AS date)=@Fecha 
		--HAVING CAST(fechaEntrega AS date)=@Fecha 
	RETURN @Volumen
END
Go 

SELECT DBO.fn_OcupacionFregoneta (6, '2015-04-01')

--4. Crea una función fn_CuantoPapel a la que se pase una fecha y nos diga la cantidad total de papel de envolver que se gastó para los paquetes 
--entregados ese día. Trata la fecha igual que en el anterior.

GO
ALTER FUNCTION fn_MiCuantoPapel (@Fecha as Date)
RETURNS decimal(8, 2)
AS
BEGIN
	DECLARE @CantidadPapel AS decimal (8, 2)
	SELECT @CantidadPapel= SUM(DBO.fn_PapelEnvolver(Codigo)) 
		FROM TL_PaquetesNormales
		WHERE CAST(fechaEntrega AS date)=@Fecha
	RETURN @CantidadPapel
END
GO

SELECT DBO.fn_MiCuantoPapel ('2014-07-01')

SELECT DBO.fn_MiCuantoPapel ('2015-04-01')  

--5 .Modifica la función anterior para que en lugar de aceptar una fecha, acepte un rango de fechas (inicio y fin). Si el inicio y fin son iguales, 
--calculará la cantidad gastada ese día. Si el fin es anterior al inicio devolverá 0.

GO
ALTER FUNCTION fn_CuantoPapelModificado (@Inicio as date, @Fin AS date)
RETURNS decimal(8, 2)
AS
BEGIN
	DECLARE @PapelGastado AS decimal(8, 2)
	IF(@Inicio=@Fin)
		BEGIN
			SET @PapelGastado = DBO.fn_MiCuantoPapel(@Inicio)
		END
	ELSE
		BEGIN
			SET @PapelGastado=0.0
		END
	RETURN @PapelGastado
END
GO

SELECT DBO.fn_CuantoPapelModificado ('2015-04-01', '2014-07-01') --debe devolver 0

SELECT DBO.fn_CuantoPapelModificado ('2015-04-01', '2015-04-01')

--6.Crea una función fn_Entregas a la que se pase un rango de fechas y nos devuelva una tabla con los códigos de los paquetes entregados y 
--los vehículos que los entregaron entre esas fechas.

GO
ALTER FUNCTION fn_MisEntregas (@Inicio AS date, @Fin AS date)
RETURNS TABLE AS
RETURN
SELECT Codigo, codigoFregoneta
FROM TL_PaquetesNormales
WHERE fechaEntrega>=@Inicio AND fechaEntrega<=@Fin 
GO

SELECT * FROM DBO.fn_MisEntregas('2015-04-01', '2015-04-02') 

--EJERCICIO 2
USE AirLeo
GO

--1. Diseña una función fn_distanciarecorrida a la que se pase un código de avión y un rango de fechas y nos devuelva la distancia total recorrida 
--por ese avión en ese rango defechas.

-- Consulta que devuelve para cada vuelo la distancia recorrida (192 filas)
SELECT * FROM AL_Vuelos AS V INNER JOIN 
	AL_Distancias AS D ON (D.Destino=V.Aeropuerto_Llegada AND D.Origen=V.Aeropuerto_Salida) OR 
	(D.Destino=V.Aeropuerto_Salida AND D.Origen=V.Aeropuerto_Llegada)
	
-- Después de 45 minutos intentando sacar la consulta anterior, creamos la función
GO
ALTER FUNCTION fn_distanciarecorrida (@Matricula char(10), @Inicio date, @Fin date)
RETURNS decimal(9,2) AS
BEGIN
	DECLARE @DistanciaRecorrida AS decimal(9, 2)
	SELECT @DistanciaRecorrida = SUM(D.Distancia)
		FROM AL_Vuelos AS V INNER JOIN 
		AL_Distancias AS D ON (D.Destino=V.Aeropuerto_Llegada AND D.Origen=V.Aeropuerto_Salida) OR 
		(D.Destino=V.Aeropuerto_Salida AND D.Origen=V.Aeropuerto_Llegada)
		WHERE V.Matricula_Avion=@Matricula AND 
			  (CAST(V.Llegada AS date) BETWEEN @Inicio AND @Fin) AND
			  (CAST(V.Salida AS date) BETWEEN @Inicio AND @Fin)
	RETURN @DistanciaRecorrida
END
GO

select DBO.fn_distanciarecorrida('USA5068', '2008-01-01', '2010-12-31') AS DistanciaRecorrida

--2.Diseña una función fn_horasVuelo a la que se pase un código de avión y un rango de fechas y nos devuelva las horas totales que ha volado
--ese avión en ese rango de fechas 

CREATE FUNCTION fn_horasVuelo(@Matricula char(10), @Inicio date, @Fin date)
RETURNS decimal(6,2) AS
BEGIN
	DECLARE @HorasVoladas AS decimal(6,2)
	SELECT @HorasVoladas = SUM(DATEDIFF(MINUTE, Salida, Llegada))
	FROM AL_Vuelos 
	WHERE (Salida BETWEEN @Inicio AND @Fin) AND (Llegada BETWEEN @Inicio AND @Fin) AND Matricula_Avion=@Matricula
	SET @HorasVoladas=@HorasVoladas/60
	RETURN @HorasVoladas
END

SELECT DBO.fn_horasVuelo('USA5068', '2008-01-01', '2010-12-31') AS HorasVoladas

--3.Diseña una función a  la que se pase un código de avión y un rango de fechas y nos devuelva una tabla con los nombres y fechas de todos 
--los aeropuertos en que ha estado el avión en ese intervalo.

--Consulta que devuelve los aeropuertos en los que ha estado cada avión y las fechas (384 filas)
SELECT * 
	FROM AL_Aviones AS A
	INNER JOIN AL_Vuelos AS V ON V.Matricula_Avion=A.Matricula
	INNER JOIN AL_Aeropuertos AS AE ON AE.Codigo=V.Aeropuerto_Salida OR AE.Codigo=V.Aeropuerto_Llegada
	ORDER BY V.Codigo

GO
alter FUNCTION fn_MiAvionesEnAeropuertos (@Matricula char(10), @Inicio date, @Fin date)
RETURNS TABLE AS
RETURN
SELECT distinct AE.Nombre AS Aeropuerto, CAST(V.Salida AS date) AS Fecha
	FROM AL_Aviones AS A
	INNER JOIN AL_Vuelos AS V ON V.Matricula_Avion=A.Matricula
	INNER JOIN AL_Aeropuertos AS AE ON AE.Codigo=V.Aeropuerto_Salida OR AE.Codigo=V.Aeropuerto_Llegada
	WHERE V.Matricula_Avion=@Matricula AND (V.Salida BETWEEN @Inicio AND @Fin) AND (V.Llegada BETWEEN @Inicio AND @Fin)
GO

SELECT * FROM AL_Vuelos order by Matricula_Avion

SELECT * FROM dbo.fn_MiAvionesEnAeropuertos('ESP8067', '2008-01-14', '2011-08-04') 

--4.Diseña una función fn_ViajesCliente que nos devuelva nombre y apellidos, kilómetros recorridos y número de vuelos efectuados por 
--cada cliente en un rango de fechas,ordenado de mayor a menor distancia recorrida.

GO
CREATE FUNCTION fn_ViajesClientes (@Inicio date, @Fin date)
RETURNS TABLE AS
RETURN
SELECT P.Nombre, P.Apellidos, SUM(D.Distancia) AS KmRecorridos, COUNT(V.Codigo) AS VuelosRealizados
	FROM AL_Pasajeros AS P
	INNER JOIN AL_Pasajes AS PJ ON PJ.ID_Pasajero=P.ID
	INNER JOIN AL_Vuelos_Pasajes AS VP ON VP.Numero_Pasaje=PJ.Numero
	INNER JOIN AL_Vuelos AS V ON V.Codigo=VP.Codigo_Vuelo
	INNER JOIN AL_Distancias AS D ON (D.Destino=V.Aeropuerto_Llegada AND D.Origen=V.Aeropuerto_Salida) OR 
	(D.Destino=V.Aeropuerto_Salida AND D.Origen=V.Aeropuerto_Llegada)
	WHERE (V.Llegada BETWEEN @Inicio AND @Fin) AND (V.Salida BETWEEN @Inicio AND @Fin)
	GROUP BY P.Nombre, P.Apellidos
GO

SELECT * FROM dbo.fn_ViajesClientes('2010-01-01', '2010-12-31')