USE Northwind

--1. Inserta un nuevo cliente
SELECT * FROM Customers

INSERT INTO Customers (CustomerID ,CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax)
VALUES ('RAFAR', ' Bar Manueh', 'Rafael Manuel Manzano', 'Owner', 'Calle Falsa 123 ', 'Carmona', 'CAR', '41410', 'Spain', '600980102', '86 22 33 44');

--2. Véndele (hoy) tres unidades de "Pavlova”, diez de "Inlagd Sill” y 25 de "Filo Mix”. El distribuidor será Speedy Express 
--y el vendedor Laura Callahan.
SELECT * FROM Products
SELECT * FROM [Order Details]
SELECT * FROM Orders

BEGIN TRANSACTION
INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, ShipName)
SELECT 'RAFAR', EmployeeID, CURRENT_TIMESTAMP, 'Speedy Express' FROM Employees
WHERE FirstName = 'Laura' AND LastName = 'Callahan'
--ROLLBACK
--COMMIT

BEGIN TRANSACTION 
INSERT INTO [Order Details] (OrderID,ProductID, UnitPrice, Quantity, Discount) 
		SELECT 11078,P.ProductID, P.UnitPrice, 3, 0 FROM Products AS P 
	    WHERE P.ProductName = 'Pavlova'
--ROLLBACK
--COMMIT

BEGIN TRANSACTION 
INSERT INTO [Order Details] (OrderID,ProductID, UnitPrice, Quantity, Discount) 
		SELECT 11078, P.ProductID, P.UnitPrice, 10, 0 FROM Products AS P 
	    WHERE P.ProductName = 'Inlagd Sill'
--ROLLBACK
--COMMIT

BEGIN TRANSACTION 
INSERT INTO [Order Details] (OrderID,ProductID, UnitPrice, Quantity, Discount) 
		SELECT 11078, P.ProductID, P.UnitPrice, 25, 0 FROM Products AS P 
	    WHERE P.ProductName = 'Filo Mix'
--ROLLBACK
--COMMIT

--Me equivoque y tuve que eliminar
BEGIN TRANSACTION
DELETE FROM [Order Details]
WHERE OrderID = 11078 AND UnitPrice = 7.0
--ROLLBACK
--COMMIT

--3. Ante la bajada de ventas producida por la crisis, hemos de adaptar nuestros precios según las siguientes reglas:
--3.1 Los productos de la categoría de bebidas (Beverages) que cuesten más de $10 reducen su precio en un dólar.
--3.2 Los productos de la categoría Lácteos que cuesten más de $5 reducen su precio en un 10%.
--3.3 Los productos de los que se hayan vendido menos de 200 unidades en el último año, reducen su precio en un 5%
SELECT * FROM Categories
SELECT * FROM Orders
SELECT * FROM Products
SELECT SUM(Quantity) AS HOLAS, ProductID FROM [Order Details] 
GROUP BY ProductID
HAVING SUM(Quantity) < 200

--3.1
BEGIN TRANSACTION
UPDATE Products 
SET UnitPrice = UnitPrice - 1
FROM Products AS P 
INNER JOIN Categories AS C ON P.CategoryID = C.CategoryID
WHERE P.UnitPrice > 10 AND C.CategoryName = 'Beverages'
--ROLLBACK
--COMMIT

--3.2
BEGIN TRANSACTION
UPDATE Products 
SET UnitPrice = UnitPrice * 0.9 
FROM Products AS P 
INNER JOIN Categories AS C ON P.CategoryID = C.CategoryID
WHERE P.UnitPrice > 5 AND C.CategoryName = 'Dairy Products'
--ROLLBACK
--COMMIT

--3.3
BEGIN TRANSACTION
UPDATE Products 
SET UnitPrice = UnitPrice * 0.95 
FROM Products AS P
INNER JOIN
(SELECT SUM(OD.Quantity) AS Cantidad, P.ProductID FROM [Order Details] AS OD
INNER JOIN Products AS P ON OD.ProductID = P.ProductID
INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
WHERE DATEDIFF(MONTH, O.OrderDate, CURRENT_TIMESTAMP) <= 12
GROUP BY P.ProductID
HAVING SUM(OD.Quantity) < 200) AS ProductosMenores200 ON P.ProductID = ProductosMenores200.ProductID
--ROLLBACK
--COMMIT

--4. Inserta un nuevo vendedor llamado Michael Trump. Asígnale los territorios de Louisville, Phoenix, Santa Cruz y Atlanta.
INSERT INTO Employees(LastName ,FirstName, Title, BirthDate, Address, City, Region, PostalCode, Country)
VALUES ('Trump', 'Michael', 'Vendor', '1999/12/03','Juan Ramon Jimenez 103', 'Bollullos de la Eme', 'BOLL', '41110', 'Spain');
