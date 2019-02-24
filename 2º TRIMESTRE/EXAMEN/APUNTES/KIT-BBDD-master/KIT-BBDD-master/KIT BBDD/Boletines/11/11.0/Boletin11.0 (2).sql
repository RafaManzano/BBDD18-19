USE LeoMetro
GO

--1. Crea una función inline que nos devuelva el número de estaciones que ha recorrido cada tren en un determinado periodo de tiempo. 
--El principio y el fin de ese periodo se pasarán como parámetros

--Sacamos el select
SELECT Tren, COUNT(estacion) AS EstacionesRecorridas
FROM LM_Recorridos
WHERE momento BETWEEN '20170201 00:00:00' AND '20170228 00:00:00'
GROUP BY Tren

--Lo incluimos en la funcion
GO
CREATE FUNCTION EstacionesRecorridas (@Principio AS smalldatetime, @Final AS smalldatetime)
RETURNS TABLE AS
RETURN
SELECT Tren, COUNT(estacion) AS EstacionesRecorridas
FROM LM_Recorridos
WHERE momento BETWEEN @Principio AND @Final
GROUP BY Tren
GO

--Probamos la función
DECLARE @TiempoInicio smalldatetime, @TiempoFin smalldatetime
SET @TiempoInicio = '20170225 00:00:00'
SET @TiempoFin = '20170226 00:00:00'

SELECT * FROM EstacionesRecorridas(@TiempoInicio, @TiempoFin)

--2. Crea una función inline que nos devuelva el número de veces que cada usuario ha entrado en el metro en un periodo de tiempo. 
--El principio y el fin de ese periodo se pasarán como parámetros

--Hacemos el select
SELECT P.Nombre, P.Apellidos, COUNT(V.ID) AS Viajes
FROM LM_Pasajeros AS P
INNER JOIN LM_Viajes AS V ON V.IDPasajero=P.ID
GROUP BY P.Nombre, P.Apellidos

--creamos la función
GO
CREATE FUNCTION ViajesPorUsuario (@Inicio smalldatetime, @Fin smalldatetime)
RETURNS TABLE
RETURN
SELECT P.Nombre, P.Apellidos, COUNT(V.ID) AS Viajes
FROM LM_Pasajeros AS P
INNER JOIN LM_Viajes AS V ON V.IDPasajero=P.ID
WHERE MomentoEntrada BETWEEN @Inicio AND @Fin
GROUP BY P.Nombre, P.Apellidos
GO

-- Probamos la función
DECLARE @TiempoInicio smalldatetime, @TiempoFin smalldatetime
SET @TiempoInicio = '20170225 00:00:00'
SET @TiempoFin = '20170228 00:00:00'

SELECT * FROM ViajesPorUsuario(@TiempoInicio, @TiempoFin)

--3. Crea una función inline a la que pasemos la matrícula de un tren y una fecha de inicio y fin y nos devuelva una tabla con el número 
--de veces que ese tren ha estado en cada estación, además del ID, nombre y dirección de la estación

SELECT E.ID, E.Denominacion AS Nombre, E.Direccion, COUNT(T.ID) AS NumVecesEstacion
FROM LM_Trenes AS T
INNER JOIN LM_Recorridos AS R ON R.Tren=T.ID
INNER JOIN LM_Estaciones AS E ON E.ID=R.estacion
WHERE Matricula='0100FLZ' AND (Momento BETWEEN '20170225 00:00:00' AND '20170228 23:59:59')
GROUP BY E.ID, E.Denominacion, E.Direccion

GO
ALTER FUNCTION TrenEnEstacion (@Matricula AS char(7), @Inicio AS smalldatetime, @Fin as smalldatetime)
RETURNS TABLE
RETURN
SELECT E.ID, E.Denominacion AS Nombre, E.Direccion, COUNT(T.ID) AS NumVecesEstacion
FROM LM_Trenes AS T
INNER JOIN LM_Recorridos AS R ON R.Tren=T.ID AND Momento BETWEEN @Inicio AND @Fin
RIGHT JOIN LM_Estaciones AS E ON E.ID=R.estacion
WHERE Matricula=@Matricula 
GROUP BY E.ID, E.Denominacion, E.Direccion
GO

SELECT * FROM TrenEnEstacion('5607GLZ', '20170227 00:00:00', '20170228 23:59:59')

--4. Crea una función inline que nos diga el número de personas que han pasado por una estacion en un periodo de tiempo. 
--Se considera que alguien ha pasado por una estación si ha entrado o salido del metro por ella. El principio y el fin de ese periodo 
--se pasarán como parámetros

GO
CREATE FUNCTION PersonasPorEstaciones (@Inicio smalldatetime, @Fin smalldatetime)
RETURNS TABLE
RETURN
SELECT E.ID AS Estacion, COUNT(V.IDPasajero) AS PersonasEnEstacion
FROM LM_Estaciones AS E
INNER JOIN LM_Viajes AS V ON E.ID = V.IDEstacionEntrada OR E.ID=V.IDEstacionSalida 
WHERE (MomentoEntrada BETWEEN @Inicio AND @Fin) AND (MomentoSalida<@Fin AND MomentoSalida>@Inicio)
GROUP BY E.ID
GO

DECLARE @IDEstacion smallint, @TiempoInicio smalldatetime, @TiempoFin smalldatetime
SET @IDEstacion = 3
SET @TiempoInicio = '20170226'
SET @TiempoFin = '20170228'

SELECT * FROM PersonasPorEstaciones(@TiempoInicio, @TiempoFin)

--5. Crea una función inline que nos devuelva los kilómetros que ha recorrido cada tren en un periodo de tiempo.
--El principio y el fin de ese periodo se pasarán como parámetros
GO
CREATE VIEW MomentosAnteriores AS
SELECT Actual.Tren, Actual.Linea, Actual.estacion, MAX(Anterior.Momento) AS [Momento inmediatamente anterior], Actual.Momento
FROM LM_Recorridos AS Actual
INNER JOIN LM_Recorridos AS Anterior ON Actual.Tren=Anterior.Tren AND Actual.Linea=Anterior.Linea
WHERE Anterior.Momento<Actual.Momento
GROUP BY Actual.Tren, Actual.Linea, Actual.estacion, Actual.Momento
GO

GO
CREATE VIEW EstacionesIniciales AS
SELECT R.estacion AS [Estacion Salida], ma.[Momento inmediatamente anterior], MA.estacion AS [Estacion llegada], ma.Momento
FROM LM_Recorridos AS R
INNER JOIN MomentosAnteriores AS MA ON R.Momento=MA.[Momento inmediatamente anterior] AND R.Tren = MA.Tren AND R.Linea=MA.Linea
GO

GO
CREATE FUNCTION KilometrosRecorridos (@Principio smalldatetime, @Fin smalldatetime)
RETURNS TABLE
RETURN
SELECT R.Tren, SUM(I.distancia) AS KmRecorridos
FROM MomentosAnteriores AS MA
INNER JOIN LM_Recorridos AS R ON MA.Tren=R.Tren AND R.Momento = MA.[Momento inmediatamente anterior]
INNER JOIN LM_Itinerarios AS I ON I.estacionIni=R.estacion AND MA.estacion = I.estacionFin
WHERE R.Momento BETWEEN @Principio AND @Fin
GROUP BY R.Tren 
GO

SELECT * FROM KilometrosRecorridos('20170226', '20170228')

-- EJERCICIO EXTRA: Crear una función inline que nos devuelva la cantidad de productos que se han vendido en cada estación del año.
-- El nombre del producto se pasará por parámetros.

USE Northwind
GO

ALTER FUNCTION UnidadesVendidasPorEstacion (@NombreProducto nvarchar(40))
RETURNS TABLE
RETURN
SELECT P.ProductName AS Producto, SUM(OD.Quantity) AS UdVendidas,
CASE
WHEN (MONTH(O.OrderDate)=12 AND DAY(O.OrderDate)>=22) OR (MONTH(O.OrderDate)>=1 AND MONTH(O.OrderDate)<3) OR (MONTH(O.OrderDate)=3 AND DAY(O.OrderDate)<22) THEN 'Invierno'
WHEN (MONTH(O.OrderDate)=3 AND DAY(O.OrderDate)>=22) OR (MONTH(O.OrderDate)>=4 AND MONTH(O.OrderDate)<6) OR (MONTH(O.OrderDate)=6 AND DAY(O.OrderDate)<22) THEN 'Primavera'
WHEN (MONTH(O.OrderDate)=6 AND DAY(O.OrderDate)>=22) OR (MONTH(O.OrderDate)>=7 AND MONTH(O.OrderDate)<9) OR (MONTH(O.OrderDate)=9 AND DAY(O.OrderDate)<22) THEN 'Verano'
WHEN (MONTH(O.OrderDate)=9 AND DAY(O.OrderDate)>=22) OR (MONTH(O.OrderDate)>=10 AND MONTH(O.OrderDate)<12) OR (MONTH(O.OrderDate)=12 AND DAY(O.OrderDate)<22) THEN 'Otoño'
END AS Estacion
FROM Products AS P
INNER JOIN [Order Details] AS OD ON OD.ProductID=P.ProductID
INNER JOIN Orders AS O ON O.OrderID=OD.OrderID
WHERE P.ProductName=@NombreProducto
GROUP BY ProductName, 
CASE
WHEN (MONTH(O.OrderDate)=12 AND DAY(O.OrderDate)>=22) OR (MONTH(O.OrderDate)>=1 AND MONTH(O.OrderDate)<3) OR (MONTH(O.OrderDate)=3 AND DAY(O.OrderDate)<22) THEN 'Invierno'
WHEN (MONTH(O.OrderDate)=3 AND DAY(O.OrderDate)>=22) OR (MONTH(O.OrderDate)>=4 AND MONTH(O.OrderDate)<6) OR (MONTH(O.OrderDate)=6 AND DAY(O.OrderDate)<22) THEN 'Primavera'
WHEN (MONTH(O.OrderDate)=6 AND DAY(O.OrderDate)>=22) OR (MONTH(O.OrderDate)>=7 AND MONTH(O.OrderDate)<9) OR (MONTH(O.OrderDate)=9 AND DAY(O.OrderDate)<22) THEN 'Verano'
WHEN (MONTH(O.OrderDate)=9 AND DAY(O.OrderDate)>=22) OR (MONTH(O.OrderDate)>=10 AND MONTH(O.OrderDate)<12) OR (MONTH(O.OrderDate)=12 AND DAY(O.OrderDate)<22) THEN 'Otoño'
END
GO

select * from products
SELECT * FROM UnidadesVendidasPorEstacion('Guaraná Fantástica')