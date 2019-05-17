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
	wHERE OrderID < 10249

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
		INNER JOIN Employees AS Subordinado ON 
	END
GO