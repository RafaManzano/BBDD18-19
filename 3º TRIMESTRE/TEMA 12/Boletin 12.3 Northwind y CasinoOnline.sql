USE Northwind
--Sobre NorthWind

--1. Haz un trigger para que un pedido (order) no pueda incluir más de 10 productos diferentes.
--SELECT * FROM [Order Details]
SELECT OrderID, COUNT(DISTINCT ProductID) FROM [Order Details]
--WHERE OrderID IN (SELECT OrderID FROM inserted)
GROUP BY OrderID
HAVING COUNT(DISTINCT ProductID) > 10
GO
CREATE TRIGGER PedidosMenores10 ON [Order Details]
	AFTER INSERT, UPDATE AS
	BEGIN 
		IF EXISTS (SELECT * FROM [Order Details]
				   WHERE OrderID IN (SELECT OrderID FROM inserted)
				   GROUP BY OrderID
				   HAVING COUNT(DISTINCT ProductID) > 10)
				   BEGIN
						ROLLBACK
				   END
	END
GO

--Pruebas
BEGIN TRANSACTION
SET IDENTITY_INSERT ORDERS ON --Para un error que da por el INSERT-IDENTITY OFF
INSERT INTO Orders (OrderID)VALUES(12001)

INSERT INTO [Order Details] VALUES
(12001,1,1,1,0),(12001,2,1,1,0),(12001,3,1,1,0),(12001,4,4,1,0),(12001,5,1,1,0),(12001,12,1,1,0),
(12001,7,1,1,0),(12001,8,1,1,0),(12001,9,1,1,0),(12001,10,1,1,0),(12001,6,1,1,0)
--ROLLBACK
--COMMIT

--Pruebas
BEGIN TRANSACTION
SET IDENTITY_INSERT ORDERS ON --Para un error que da por el INSERT-IDENTITY OFF
INSERT INTO Orders (OrderID)VALUES(12001)

INSERT INTO [Order Details] VALUES
(12001,1,1,1,0),(12001,2,1,1,0),(12001,3,1,1,0),(12001,4,4,1,0),(12001,5,1,1,0),(12001,12,1,1,0),
(12001,7,1,1,0),(12001,8,1,1,0)
--ROLLBACK
--COMMIT

--Pruebas
BEGIN TRANSACTION
SET IDENTITY_INSERT ORDERS ON --Para un error que da por el INSERT-IDENTITY OFF
--INSERT INTO Orders (OrderID)VALUES(12001)

INSERT INTO [Order Details] VALUES
(12001,9,1,1,0),(12001,10,1,1,0),(12001,6,1,1,0)
--ROLLBACK
--COMMIT

UPDATE [Order Details] set OrderID = 12001
-- SELECT * FROM [Order Details]
	WHERE OrderID < 10249

--2. Haz un trigger para que un cliente no pueda hacer más de 10 pedidos al año (años naturales) de la misma categoría
GO
CREATE TRIGGER ClientesNoTanFieles ON Orders
	AFTER INSERT, UPDATE AS
	BEGIN
		IF EXISTS (SELECT * FROM Orders AS O
		INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
		INNER JOIN Products AS P ON OD.ProductID = P.ProductID
		WHERE O.CustomerID = (SELECT O.CustomerID FROM inserted AS O
							 INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
							 INNER JOIN Products AS P ON OD.ProductID = P.ProductID) AND
			  YEAR(O.OrderDate) = (SELECT YEAR(O.OrderDate) FROM inserted AS O
							       INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
							       INNER JOIN Products AS P ON OD.ProductID = P.ProductID) AND
			  P.CategoryID = (SELECT P.CategoryID FROM inserted AS O
							  INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
							  INNER JOIN Products AS P ON OD.ProductID = P.ProductID)
		GROUP BY O.CustomerID
		HAVING COUNT(O.OrderID) > 10)	
	END
GO

--3. Haz un trigger que no permita que un empleado sea superior de otro (ReportsTo) si el segundo es su superior 
--(en uno o varios niveles).
GO
CREATE TRIGGER NopuedeSerSuperior ON Employees
	AFTER INSERT, UPDATE AS
	BEGIN
		SELECT * FROM Employees AS Jefe
		CROSS JOIN inserted AS Subordinado
		WHERE Subordinado.ReportsTo <> Jefe.EmployeeID
	END
GO

--4. Haz un trigger que impida que la primera venta a un cliente de fuera de USA pueda tener un importe superior a 500 $
SELECT * FROM Orders
GO

SELECT MIN(OrderID), CustomerID FROM Orders
GROUP BY CustomerID, ShipCountry
HAVING ShipCountry <> 'USA'
ORDER BY CustomerID ASC

SELECT MIN(OrderID), CustomerID FROM Orders
GROUP BY CustomerID

CREATE TRIGGER PrimeraVentaNoUSA ON Orders
	AFTER INSERT, UPDATE AS
	BEGIN
	--IF EXISTS()
	SELECT OrderID, CustomerID FROM Orders
	GROUP BY CustomerID, OrderID
	HAVING MIN(OrderID) 
	
	
			  BEGIN 
				ROLLBACK
			  END
	END
GO

--5. Haz un trigger que impida que pueda haber a la venta más de 30 productos de una misma categoría. Los productos que están 
--a la venta son los que tienen un "0” en la columna "discontinued”
GO
CREATE TRIGGER Menos30ProductosVenta ON [Order Details]
	AFTER INSERT, UPDATE AS
	BEGIN
	IF EXISTS(SELECT * FROM [Order Details] AS OD
			  INNER JOIN Products AS P ON OD.ProductID = P.ProductID
			  WHERE P.Discontinued = 0  AND OD.OrderID NOT IN(SELECT * FROM inserted)
			  GROUP BY P.CategoryID)
			  BEGIN
				ROLLBACK
			  END
	END
GO

--Sobre CasinOnLine
USE CasinOnLine2
--6. Haz un trigger que asegure que una vez se introduce el número de una apuesta, no pueda cambiarse.
SELECT * FROM COL_NumerosApuesta

GO
CREATE TRIGGER NoCambiarApuestas ON COL_NumerosApuesta
	AFTER UPDATE AS 
	BEGIN
	IF EXISTS(
		SELECT * FROM COL_NumerosApuesta AS NA
		CROSS JOIN inserted AS I  
		WHERE I.IDJugador = NA.IDJugador AND I.IDMesa = NA.IDMesa AND I.IDJugada = NA.IDJugada AND I.Numero <> NA.Numero)
		AND EXISTS (
		SELECT * FROM COL_NumerosApuesta AS NA
		CROSS JOIN deleted AS D
		WHERE D.IDJugador = NA.IDJugador AND D.IDMesa = NA.IDMesa AND D.IDJugada = NA.IDJugada AND D.Numero <> NA.Numero)
		BEGIN
			ROLLBACK
		END
	END
GO

--7. Haz un trigger que garantice que no se puedan hacer más apuestas en una jugada si la columna NoVaMas tiene el valor 1.
SELECT J.IDMesa, A.IDJugada FROM COL_Jugadas AS J
INNER JOIN COL_Apuestas AS A ON J.IDMesa = A.IDMesa AND J.IDJugada = A.IDJugada
GROUP BY J.IDMesa, A.IDJugada
GO
CREATE TRIGGER NoMasApuestas ON COL_Jugadas
	AFTER INSERT AS
	BEGIN
		SELECT J.IDMesa, A.IDJugada FROM COL_Jugadas AS J
		INNER JOIN COL_Apuestas AS A ON J.IDMesa = A.IDMesa AND J.IDJugada = A.IDJugada
		GROUP BY J.IDMesa, A.IDJugada
	END
GO

--8. Haz un trigger que garantice que entre dos jugadas sucesivas en una misma mesa pasen al menos 5 minutos.
SELECT * FROM COL_Jugadas
SELECT * FROM COL_Apuestas
GO
CREATE TRIGGER JugadasSucesivas ON COL_Jugadas
	AFTER INSERT AS

	BEGIN
	IF EXISTS(
		SELECT * FROM COL_Jugadas AS J
		CROSS JOIN inserted AS I
		WHERE J.IDMesa = I.IDMesa AND J.IDJugada <> I.IDJugada AND DATEDIFF(MINUTE, J.MomentoJuega, I.MomentoJuega) < 5 AND DATEDIFF(MINUTE, I.MomentoJuega, J.MomentoJuega) < 5)
		BEGIN
			ROLLBACK
		END
	END
GO

--9. Haz un trigger que asegure que, cuando se actualiza el número de una jugada, 
--se paguen todas las apuestas, incrementando los saldos que correspondan. 
--Se puede utilizar el procedimiento creado al efecto.
CREATE TRIGGER AsegurarPasta ON COL_NumerosApuesta
	AFTER INSERT AS
	BEGIN
		EXECUTE dbo.FinApuestas(
	END

--10. Haz un trigger que impida que en una jugada se puedan hacer apuestas 
--que puedan provocar que se supere el límite de la mesa. Se recomienda modular.
GO
CREATE TRIGGER NoSePuedeApostar ON COL_Jugadas
	AFTER INSERT AS
	BEGIN 
		SELECT * FROM COL_Jugadas AS J
		INNER JOIN COL_Mesas AS M ON J.IDMesa = M.ID

	END
GO