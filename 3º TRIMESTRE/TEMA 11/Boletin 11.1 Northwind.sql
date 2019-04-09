USE Northwind

--1. Deseamos incluir un producto en la tabla Products llamado "Cruzcampo lata” pero no estamos seguros si 
--se ha insertado o no.
--El precio son 4,40, el proveedor es el 16, la categoría 1 y la cantidad por unidad es "Pack 6 latas” 
--"Discontinued” toma el valor 0 y el resto de columnas se dejarán a NULL.
--Escribe un script que compruebe si existe un producto con ese nombre. En caso afirmativo, 
--actualizará el precio y en caso negativo insertarlo. 
SELECT * FROM Products
BEGIN TRANSACTION
IF NOT EXISTS(SELECT ProductName FROM Products WHERE ProductName = 'Cruzcampo lata')
BEGIN --{
	INSERT INTO Products (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, Discontinued)
	VALUES ('Cruzcampo lata', 16, 1,  'Pack 6 latas', 4.40, 0)
END --}
ELSE
BEGIN
	UPDATE Products
	SET UnitPrice = 4.40
	WHERE ProductName = 'Cruzcampo lata'
END
--ROLLBACK
--COMMIT

--2. Comprueba si existe una tabla llamada ProductSales. Esta tabla ha de tener de cada producto el ID, 
--el Nombre, el Precio unitario, el número total de unidades vendidas y el total de dinero 
--facturado con ese producto. Si no existe, créala
BEGIN TRANSACTION
IF OBJECT_ID ('dbo.ProductsSales') IS NULL
BEGIN --{
	CREATE TABLE ProductsSales (
	ID INT NOT NULL,
	ProductName VARCHAR(40) NOT NULL,
	UnitPrice MONEY NOT NULL,
	TotalSales SMALLINT NULL,
	TotalMoney MONEY NULL,
	)
END --}
ELSE
BEGIN
	PRINT('La tabla ya esta en el sistema')
END
--ROLLBACK
--COMMIT
SELECT * FROM ProductsSales

--3. Comprueba si existe una tabla llamada ShipShip. Esta tabla ha de tener de cada 
--Transportista el ID, el Nombre de la compañía, el número total de envíos que ha efectuado y 
--el número de países diferentes a los que ha llevado cosas. Si no existe, créala
BEGIN TRANSACTION
IF OBJECT_ID ('dbo.ShipShip') IS NULL
BEGIN --{
	CREATE TABLE ShipShip (
	ID INT NOT NULL,
	CompanyName VARCHAR(40) NOT NULL,
	Total INT NULL,
	DifferentsCountries SMALLINT NULL,
	)
END --}
ELSE
BEGIN
	PRINT('La tabla ya esta en el sistema')
END
--ROLLBACK
--COMMIT
SELECT * FROM ShipShip

--4. Comprueba si existe una tabla llamada EmployeeSales. Esta tabla ha de tener de 
--cada empleado su ID, el Nombre completo, el número de ventas totales que ha realizado, 
--el número de clientes diferentes a los que ha vendido y el total de dinero facturado. 
--Si no existe, créala
BEGIN TRANSACTION
IF OBJECT_ID ('dbo.EmployeeSales') IS NULL
BEGIN --{
	CREATE TABLE EmployeeSales (
	ID INT NOT NULL,
	Name VARCHAR(100) NOT NULL,
	TotalSales SMALLINT NULL,
	DifferentsCustomers INT NULL,
	TotalMoney MONEY NULL
	)
END --}
ELSE
BEGIN
	PRINT('La tabla ya esta en el sistema')
END
--ROLLBACK
--COMMIT
SELECT * FROM EmployeeSales

--5. Entre los años 96 y 97 hay productos que han aumentado sus ventas y 
--otros que las han disminuido. Queremos cambiar el precio unitario según la siguiente tabla:

--Incremento de ventas    Incremento de precio
-- - Negativo			  - 10%
-- - Entre 0 y 10%        - No varía
-- - Entre 10% y 50%      - +5%
-- - Mayor del 50%        - 10% con un máximo de 2,25
BEGIN TRANSACTION
GO
CREATE FUNCTION VentasPorAño(@Fecha INT) RETURNS TABLE AS RETURN
SELECT Categories.CategoryName, Products.ProductName, 
Sum(CONVERT(money,("Order Details".UnitPrice*Quantity*(1-Discount)/100))*100) AS ProductSales
FROM (Categories INNER JOIN Products ON Categories.CategoryID = Products.CategoryID) 
	INNER JOIN (Orders 
		INNER JOIN "Order Details" ON Orders.OrderID = "Order Details".OrderID) 
	ON Products.ProductID = "Order Details".ProductID
WHERE YEAR(ShippedDate) = @Fecha
GROUP BY Categories.CategoryName, Products.ProductName
GO
--ROLLBACK
--COMMIT
/*
BEGIN TRANSACTION 
DECLARE @Total INT
SET @Total = (SELECT (V97.ProductSales - V96.ProductSales) AS Total FROM VentasPorAño(1996) AS V96
		INNER JOIN VentasPorAño(1997) AS V97 ON V96.ProductName = V97.ProductName)
UPDATE Products
SET UnitPrice = CASE (@Total)
		WHEN @Total < 0 THEN UnitPrice * 1.10 
		WHEN @Total BETWEEN @Total * 0.1 AND @Total * 0.5 THEN UnitPrice * 1.25 
		WHEN @Total > @Total * 0.5 THEN UnitPrice * 1.10 --AND UnitPrice < 2.25 
		END
*/
GO
CREATE VIEW VentasPorProducto AS
SELECT SUM(V97.ProductSales - V96.ProductSales) AS Total, V97.ProductName FROM VentasPorAño(1996) AS V96
INNER JOIN VentasPorAño(1997) AS V97 ON V96.ProductName = V97.ProductName
GROUP BY V97.ProductName
GO

BEGIN TRANSACTION
UPDATE Products
SET UnitPrice = (SELECT ProductName FROM VentasPorProducto
		WHERE Total = CASE (Total)   
			WHEN Total < 0 THEN UnitPrice * 1.10 
			WHEN Total BETWEEN Total * 0.1 AND Total * 0.5 THEN UnitPrice * 1.25 
			WHEN Total > Total * 0.5 THEN UnitPrice * 1.10 --AND UnitPrice < 2.25 
			END