USE ICOTR

-- EJ 1 Creac funcion pasa parametro el tipo de helado y 
-- devuelve una tabla con todos los clientes que han pedido alli, y el numero de veces

DROP FUNCTION fn_ClientesHelados
GO
CREATE FUNCTION fn_ClientesHelados(@Sabor char(12))
RETURNS TABLE
AS
	RETURN (SELECT C.Nombre, C.Apellidos, COUNT(H.ID) AS NumeroDeVeces
	        FROM ICHelados AS H
			INNER JOIN ICPedidos AS P ON H.IDPedido = P.ID
			INNER JOIN ICClientes AS C ON P.IDCliente = C.ID
			WHERE Sabor = @Sabor
			GROUP BY C.Nombre, C.Apellidos
			)
GO

SELECT * FROM fn_ClientesHelados('Fresa')


-- funcion que devuelva el dinero ganado entre 2 fechas
-- una funcion que le pases ID de establecimiento y devuelve
---- el nombre de repartidores, 
---- el numero total de pedidos de cada uno
---- la cantidad de complementos   
---- dinero total ganado con los complementos

SELECT COUNT(ID)
FROM ICPedidos AS P
WHERE P.IDEstablecimiento = 28

SELECT R.ID, R.Nombre, COUNT(P.ID)
FROM ICPedidos AS P
JOIN ICRepartidores AS R ON P.IDRepartidor = R.ID
WHERE  R.Nombre = 'Olga'
GROUP BY Nombre, R.ID





DROP FUNCTION  fn_DineroEntreFechas

GO
CREATE FUNCTION fn_DineroEntreFechas( @idEstablecimeinto smallint, @fechaInicio DATE, @fechaFin DATE)
RETURNs TABLE
AS
	RETURN (
			SELECT COUNT(P.ID) AS TotalPedidos--, COUNT(PC.IDComplemento) AS TotalComplementos, (SUM(C.Importe) * PC.Cantidad) AS ImporteGanado
			FROM ICRepartidores AS R
			JOIN ICPedidos AS P ON R.IDEstablecimiento = P.IDEstablecimiento
			WHERE P.IDEstablecimiento = @idEstablecimeinto AND CAST(P.Enviado AS DATE)  BETWEEN @fechaInicio AND @fechaFin
			)
GO
DECLARE @fechaInicio datetime
DECLARE @fechaFin datetime
SET @fechaInicio = datefromparts (2012,02,14)
SET @fechaFin = datefromparts (2016,01,22)
SELECT * FROM fn_DineroEntreFechas( 28, @fechaInicio, @fechaFin)



SELECT * FROM ICPedidosComplementos


DROP FUNCTION  fn_DineroEntreFechas

GO
CREATE FUNCTION fn_DineroEntreFechas( @idEstablecimeinto smallint, @fechaInicio DATE, @fechaFin DATE)
RETURNs TABLE
AS
	RETURN (
			SELECT R.Nombre, R.Apellidos, COUNT(P.ID) AS TotalPedidos, COUNT(PC.IDComplemento) AS TotalComplementos, (SUM(C.Importe) * PC.Cantidad) AS ImporteGanado
			FROM ICRepartidores AS R
			JOIN ICPedidos AS P ON R.IDEstablecimiento = P.IDEstablecimiento
			JOIN ICPedidosComplementos AS PC ON P.ID = PC.IDPedido
			JOIN ICComplementos AS C ON PC.IDComplemento = C.ID
			WHERE P.IDEstablecimiento = @idEstablecimeinto AND CAST(P.Enviado AS DATE)  BETWEEN @fechaInicio AND @fechaFin
			GROUP BY Nombre, Apellidos, Cantidad
			)
GO

DECLARE @fechaInicio datetime
DECLARE @fechaFin datetime
SET @fechaInicio = datefromparts (2012,02,14)
SET @fechaFin = datefromparts (2016,01,22)
SELECT * FROM fn_DineroEntreFechas( 28, @fechaInicio, @fechaFin)

