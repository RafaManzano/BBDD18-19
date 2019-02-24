USE NorthWind
GO

--1. Deseamos incluir un producto en la tabla Products llamado "Cruzcampo lata” pero no estamos seguros si se ha insertado o no.
--El precio son 4,40, el proveedor es el 16, la categoría 1 y la cantidad por unidad es "Pack 6 latas” "Discontinued” toma el valor 0 
--y el resto de columnas se dejarán a NULL.
--Escribe un script que compruebe si existe un producto con ese nombre. En caso afirmativo, actualizará el precio y en caso negativo insertarlo. 

IF EXISTS (SELECT * FROM Products WHERE ProductName='Cruzcampo lata')
	BEGIN
		PRINT('El producto existe, se actualizará el precio')
		UPDATE Products
		SET UnitPrice=4.40
		WHERE ProductName='Cruzcampo lata'
	END
ELSE
	BEGIN
		INSERT INTO Products (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, Discontinued)
		VALUES
		('Cruzcampo lata', 16, 1, 'Pack 6 latas', 4.40, 0)
		PRINT ('Se ha insertado un producto nuevo')
	END

--2. Comprueba si existe una tabla llamada ProductSales. Esta tabla ha de tener de cada producto el ID, el Nombre, el Precio unitario, 
--el número total de unidades vendidas y el total de dinero facturado con ese producto. Si no existe, créala

IF OBJECT_ID('ProductSales') IS NOT NULL
	BEGIN
		PRINT('La tabla existe')
	END
ELSE
	BEGIN
		PRINT('La tabla no existe, se creará')
		CREATE TABLE ProductSales(
			ProductID int NOT NULL,
			CONSTRAINT PK_ProductSales PRIMARY KEY (ProductID),
			CONSTRAINT FK_ProductSales_Products FOREIGN KEY (ProductID) REFERENCES Products (ProductID),
			ProductName nvarchar(40) NOT NULL,
			UnitPrice money NULL,
			UdVendidas int NULL,
			TotalFacturado money NULL
		)
	END

--3. Comprueba si existe una tabla llamada ShipShip. Esta tabla ha de tener de cada Transportista el ID, el Nombre de la compañía, el número total
-- de envíos que ha efectuado y el número de países diferentes a los que ha llevado cosas. Si no existe, créala

IF OBJECT_ID('ShipShip') IS NOT NULL
	BEGIN
		PRINT('La tabla existe')
	END
ELSE
	BEGIN
		PRINT ('La tabla no existe, se creará')
		CREATE TABLE ShipShip (
			IDTransportista int NOT NULL,
			CONSTRAINT PK_ShipShip PRIMARY KEY (IDTransportista),
			CONSTRAINT FK_ShipShip_Shippers FOREIGN KEY (IDTransportista) REFERENCES Shippers (ShipperID),
			NombreCompañia nvarchar(40) NOT NULL,
			TotalEnvios int NULL,
			PaisesClientes int NULL
		)
	END

--4. Comprueba si existe una tabla llamada EmployeeSales. Esta tabla ha de tener de cada empleado su ID, el Nombre completo, el número de ventas 
--totales que ha realizado, el número de clientes diferentes a los que ha vendido y el total de dinero facturado. Si no existe, créala

IF OBJECT_ID('EmployeeSales') IS NOT NULL
	BEGIN
		PRINT ('La tabla ya existe')
	END
ELSE
	BEGIN
		CREATE TABLE EmployeeSales(
			IDEmpleado int NOT NULL,
			CONSTRAINT PK_EmployeeSales PRIMARY KEY (IDEmpleado),
			CONSTRAINT FK_EmployeeSales_Employees FOREIGN KEY (IDEmpleado) REFERENCES Employees (EmployeeID)
				ON UPDATE CASCADE ON DELETE NO ACTION,
			Nombre nvarchar(10) NOT NULL,
			Apellidos nvarchar(20) NOT NULL,
			VentasTotales int NULL,
			ClientesDiferentes int NULL,
			DineroFacturado money NULL
		)
	END

--5. Entre los años 96 y 97 hay productos que han aumentado sus ventas y otros que las han disminuido. Queremos cambiar el precio unitario según 
--la siguiente tabla:

--Incremento de ventas --- Incremento de precio

--Negativo						-10%

--Entre 0 y 10%					No varía

--Entre 10% y 50%					+5%

--Mayor del 50%			10% con un máximo de 2,25

--Creamos dos vistas, una con las ventas del año 97 y otra con las ventas del 96
GO
CREATE VIEW VentasEnEl97
AS
SELECT P.ProductName AS Producto,SUM(Quantity) AS Ventas
FROM Products AS P 
INNER JOIN [Order Details] AS OD ON OD.ProductID = P.ProductID
INNER JOIN Orders AS O ON O.OrderID = OD.OrderID
WHERE YEAR(O.OrderDate)=1997
GROUP BY P.ProductName

GO
CREATE VIEW VentasEnEl96
AS
SELECT P.ProductName AS Producto,SUM(Quantity) AS Ventas
FROM Products AS P 
INNER JOIN [Order Details] AS OD ON OD.ProductID = P.ProductID
INNER JOIN Orders AS O ON O.OrderID = OD.OrderID
WHERE YEAR(O.OrderDate)=1996
GROUP BY P.ProductName
--((Valor Reciente / Valor Anterior) – 1) x 100
CREATE VIEW IncrementoDeVentas
AS
SELECT v96.Producto, V96.Ventas AS Ventas96, V97.Ventas AS Ventas97, (V97.Ventas-V96.Ventas) AS IncrementoVentas,
(((V97.Ventas/CAST(V96.Ventas AS decimal(6,3)))-1)*100) AS PorcentajeIncremento
FROM VentasEnEl96 AS V96 INNER JOIN VentasEnEl97 AS V97 ON V97.Producto=V96.Producto
GROUP BY V96.Producto, V96.Ventas, V97.Ventas

UPDATE Products
SET UnitPrice = CASE
WHEN IncrementoDeVentas.PorcentajeIncremento < 0 THEN UnitPrice*0.9
WHEN IncrementoDeVentas.PorcentajeIncremento BETWEEN 0 AND 10 THEN UnitPrice
WHEN IncrementoDeVentas.PorcentajeIncremento BETWEEN 10 AND 50 THEN UnitPrice*1.05
WHEN IncrementoDeVentas.PorcentajeIncremento>50 THEN UnitPrice*1.1
END
FROM IncrementoDeVentas

SELECT * FROM Products

