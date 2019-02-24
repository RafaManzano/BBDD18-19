--Sobre la base de datos LeoMetro
USE LeoMetro
GO
/*EJERCICIO 1
Crea una función inline que nos devuelva el número de estaciones que ha recorrido cada tren en un determinado periodo de tiempo. 
El principio y el fin de ese periodo se pasarán como parámetros*/
SET DATEFORMAT ymd

GO
--CREATE FUNCTION, si no la he creado aun
--ALTER TABLE si ya esta creada
ALTER FUNCTION numeroEstacionesQueRecorreCadaTrenEnXTiempo (@principio DateTime, @fin DateTime)
RETURNS TABLE AS
RETURN
(
SELECT count(estacion) AS EstacionesRecorridas, Tren
FROM LM_Recorridos
WHERE Momento BETWEEN @principio AND @fin
GROUP BY Tren
)
GO

--DECLARAR VARIABLES
DECLARE @principio DateTime
DECLARE @fin DateTime

--ASIGNAR VALOR A VARIABLES
SET @principio = '2017-02-25'
SET @fin = '2017-02-27'

SELECT * FROM numeroEstacionesQueRecorreCadaTrenEnXTiempo (@principio, @fin)
GO
/*EJERCICIO 2
Crea una función inline que nos devuelva el número de veces que cada usuario ha entrado en el metro en un periodo de tiempo. 
El principio y el fin de ese periodo se pasarán como parámetros*/
set dateformat ymd

GO
ALTER FUNCTION numeroVecesQueUsuarioEntraMetro (@principio datetime, @fin datetime)
RETURNS TABLE AS
RETURN
(
	SELECT V.IDPasajero,COUNT(V.MomentoEntrada) AS [Veces que ha entrado]
	FROM LM_Viajes AS V
	WHERE V.MomentoEntrada BETWEEN @principio AND @fin
	GROUP BY V.IDPasajero
)
GO

DECLARE @principio datetime
DECLARE @fin datetime

SET @principio = '2017-02-25'
SET @fin = '2017-02-26'

SELECT * FROM numeroVecesQueUsuarioEntraMetro (@principio, @fin)

GO
/*EJERCICIO 3
Crea una función inline a la que pasemos la matrícula de un tren y una fecha de inicio y fin y nos devuelva una tabla 
con el número de veces que ese tren ha estado en cada estación, además del ID, nombre y dirección de la estación*/
GO
set dateformat ymd

GO
ALTER FUNCTION TrenEstacion (@principio datetime, @fin datetime, @matricula char(7))
RETURNS TABLE AS
RETURN
(
	SELECT T.Matricula, T.ID, COUNT(R.estacion) AS [Veces que ha estado],E.ID AS [IDEstacion], E.Denominacion AS [NombreEstacion], E.Direccion AS [DireccionEstacion]
	FROM LM_Trenes AS T
	inner join LM_Recorridos as R
	on T.ID=R.Tren
	inner join LM_Estaciones AS E
	on R.estacion=E.ID
	WHERE T.Matricula=@matricula AND R.Momento BETWEEN @principio AND @fin
	GROUP BY T.ID,T.Matricula,E.ID,E.Denominacion,E.Direccion
)
GO

DECLARE @principio datetime
DECLARE @fin datetime
DECLARE @matricula char(7)

SET @principio = '2017-02-25 00:00:00.000'
SET @fin = '2017-02-27 23:14:00.000'
SET @matricula = '5607GLZ'

SELECT * FROM TrenEstacion (@principio, @fin, @matricula)
GO
------------------------------VERSION TOMAS-----------------------------
GO
ALTER FUNCTION TrenEstacion (@matricula char(7),@principio datetime, @fin datetime)
RETURNS TABLE AS
RETURN
(
	SELECT COUNT(R.estacion) AS [Veces que ha pasado], E.ID, E.Denominacion, E.Direccion
	FROM LM_Trenes AS T
	inner join LM_Recorridos as R
	on T.ID=R.Tren
	inner join LM_Estaciones AS E
	on R.estacion=E.ID
	WHERE T.Matricula = @matricula AND R.Momento BETWEEN @principio AND @fin
	GROUP BY E.ID,E.Denominacion,E.Direccion
)
GO

DECLARE @matricula char(7)
DECLARE @principio datetime
DECLARE @fin datetime

SET @matricula = '5607GLZ'
SET @principio = '2017-02-25'
SET @fin = '2017-02-27'

SELECT * FROM TrenEstacion (@matricula, @principio, @fin)
GO
/*EJERCICIO 4
Crea una función inline que nos diga el número de personas que han pasado por una estacion en un periodo de tiempo. 
Se considera que alguien ha pasado por una estación si ha entrado o salido del metro por ella. 
El principio y el fin de ese periodo se pasarán como parámetros*/
GO
ALTER FUNCTION CuentaPersonas (@principio datetime, @fin datetime)
RETURNS TABLE AS
RETURN
(
	SELECT COUNT(IDPasajero) AS [Numero de Personas], IDEstacionEntrada AS [Estacion Entrada], IDEstacionSalida AS [Estacion Salida]
	FROM LM_Viajes AS V
	WHERE V.MomentoEntrada = @principio AND V.MomentoSalida = @fin
	GROUP BY IDPasajero, IDEstacionEntrada, IDEstacionSalida
)
GO

DECLARE @principio datetime
DECLARE @fin datetime


SET @principio = '2017-02-24 16:50:00'
SET @fin = '2017-02-24 18:21:00'

SELECT * FROM CuentaPersonas(@principio, @fin)
GO
----------------------------------------VERSION 2-------------------------------------------------
go
ALTER FUNCTION PasajerosEnEstacionIntervalo (@estacion as varchar(2), @inicio as datetime, @final as datetime)
RETURNS TABLE AS
RETURN(
	select count(TB.IDPasajero) AS CantidadPersonas from (
	select distinct IDPasajero from LM_Viajes
	where (IDEstacionEntrada = @estacion or IDEstacionSalida = @estacion)
	and (MomentoEntrada between @inicio AND @final
	or MomentoSalida between @inicio AND @final)
	) AS TB
)
go

--consultamos la funcion

declare @inicial datetime
declare @final datetime
declare @estacion varchar(2)

set @inicial = datetimefromparts(2017,2,26,0,0,0,0)
set @final = datetimefromparts(2017,2,27,0,0,0,0)
set @estacion = '4'

select * from PasajerosEnEstacionIntervalo (@estacion, @inicial, @final)go
ALTER FUNCTION PasajerosEnEstacionIntervalo (@estacion as varchar(2), @inicio as datetime, @final as datetime)
RETURNS TABLE AS
RETURN(
	select count(TB.IDPasajero) AS CantidadPersonas from (
	select distinct IDPasajero from LM_Viajes
	where (IDEstacionEntrada = @estacion or IDEstacionSalida = @estacion)
	and (MomentoEntrada between @inicio AND @final
	or MomentoSalida between @inicio AND @final)
	) AS TB
)
go

--consultamos la funcion

declare @inicial datetime
declare @final datetime
declare @estacion varchar(2)

set @inicial = datetimefromparts(2017,2,26,0,0,0,0)
set @final = datetimefromparts(2017,2,27,0,0,0,0)
set @estacion = '4'

select * from PasajerosEnEstacionIntervalo (@estacion, @inicial, @final)
GO

/*EJERCICIO 5
Crea una función inline que nos devuelva los kilómetros que ha recorrido cada tren en un periodo de tiempo. 
El principio y el fin de ese periodo se pasarán como parámetros*/
GO
CREATE FUNCTION CuentaKM (@principio datetime, @fin datetime)
RETURNS TABLE AS
RETURN
(
	SELECT SUM(Distancia) AS [Numero de KM], 
	FROM LM_Itinerarios AS I
	WHERE 
	GROUP BY 
)
GO

DECLARE @principio datetime
DECLARE @fin datetime


SET @principio = '2017-02-24 16:50:00'
SET @fin = '2017-02-24 18:21:00'

SELECT * FROM CuentaKM(@principio, @fin)
GO

/*EJERCICIO 6
Crea una función inline que nos devuelva el número de trenes que ha circulado por cada línea en un periodo de tiempo. 
El principio y el fin de ese periodo se pasarán como parámetros. 
Se devolverá el ID, denominación y color de la línea*/
GO

GO

/*EJERCICIO 7
Crea una función inline que nos devuelva el tiempo total que cada usuario ha pasado en el metro en un periodo de tiempo. 
El principio y el fin de ese periodo se pasarán como parámetros. 
Se devolverá ID, nombre y apellidos del pasajero. 
El tiempo se expresará en horas y minutos.*/
GO

GO
--CREATE PROCEDURE