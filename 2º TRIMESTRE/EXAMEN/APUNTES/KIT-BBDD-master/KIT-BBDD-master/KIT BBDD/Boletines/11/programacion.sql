USE Northwind

--1.	Deseamos incluir un producto en la tabla Products llamado "Cruzcampo botellín” pero no estamos seguros si se ha insertado o no.
--El precio son 2,40, el proveedor es el 16, la categoría 1 y la cantidad por unidad es "Pack 6 botellines” "Discontinued” toma el valor 0 y el resto de columnas se dejarán a NULL.
--Escribe un script que compruebe si existe un producto con ese nombre. En caso afirmativo, actualizará el precio y en caso negativo insertarlo. 
--2.	Comprueba si existe una tabla llamada ProductSales. Esta tabla ha de tener de cada producto el ID, el Nombre, el Precio unitario, el número total de unidades vendidas y el total de dinero facturado con ese producto. Si no existe, créala
--3.	Comprueba si existe una tabla llamada ShipShip. Esta tabla ha de tener de cada Transportista el ID, el Nombre de la compañía, el número total de envíos que ha efectuado y el número de países diferentes a los que ha llevado cosas. Si no existe, créala
--4.	Comprueba si existe una tabla llamada EmployeeSales. Esta tabla ha de tener de cada empleado su ID, el Nombre completo, el número de ventas totales que ha realizado, el número de clientes diferentes a los que ha vendido y el total de dinero facturado. Si no existe, créala
--5.	Entre los años 96 y 97 hay productos que han aumentado sus ventas y otros que las han disminuido. Queremos cambiar el precio unitario según la siguiente tabla:



--1. Deseamos incluir un producto en la tabla Products llamado "Cruzcampo botellín” pero no estamos seguros si se ha insertado o no.
--   El precio son 2,40, el proveedor es el 16, la categoría 1 y la cantidad por unidad son "Pack de seis botellines” El resto de columnas se dejarán a NULL.
--   Escribe un script que compruebe si existe un producto con ese nombre. En caso afirmativo, actualizará el precio y en caso negativo insertarlo.
BEGIN TRANSACTION

-- Otra forma de hacerlo
-- IF 'Cruzcampo botellin' != ALL (SELECT ProductName FROM Products )
IF NOT exists (SELECT ProductName FROM Products WHERE ProductName = 'Cruzcampo botellin')
	BEGIN -- inicio bloque if
		INSERT INTO Products (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
		VALUES ('Cruzcampo botellin', 16, 1, 'Pack de 6 botellines', 2.40, NULL, NULL, NULL, 0) 
	END   -- fin bloque if
ELSE
	BEGIN -- inicio else
		PRINT 'Ya existe ese elemento en la base de datos. Actualizamos su precio'
		UPDATE Products
		SET UnitPrice = UnitPrice + 0.50
		WHERE ProductName = 'Cruzcampo botellin'
	END  -- en else

COMMIT TRANSACTION
ROLLBACK TRANSACTION

-- Consultamos cambios
SELECT * FROM Products WHERE ProductName = 'Cruzcampo botellin'

  

-- 2 Comprueba si existe una tabla llamada ProductSales. Esta tabla ha de tener de cada producto el ID, el Nombre, el Precio unitario,
-- el número total de unidades vendidas y el total de dinero facturado con ese producto. Si no existe, créala

-- Comprobar si existe una tabla
-- Buscando si tiene un objetID, si tiene un id asignado es que existe la tabla
BEGIN TRANSACTION
IF OBJECT_ID('ProductSales') IS NULL
	BEGIN
		Print 'La tabla ProductSales no existe, procederemos a crearla' 
		CREATE TABLE ProductSales
		(
			ID int NOT NULL CONSTRAINT PK_Product PRIMARY KEY,
			Name	   varchar(50) NOT NULL,
			UnitPrice  int	       NOT NULL,
			TotalSales int		   NOT NULL,
			TotalMoney int         NOT NULL,
			CONSTRAINT FK_ProductSales_Products FOREIGN KEY(ID) REFERENCES Products (ProductID)
			ON UPDATE CASCADE ON DELETE NO ACTION
		) 

		-- INSERTAMOS LOS DATOS
		INSERT INTO ProductSales
	    SELECT P.ProductID, P.ProductName, P.UnitPrice, SUM(O.Quantity) AS [Total Unidades Vendidas], SUM(O.Quantity * O.UnitPrice)  AS [Total de dinero facturado] 
		FROM Products AS P
		JOIN [Order Details] AS O ON P.ProductID = O.ProductID
		GROUP BY P.ProductID, P.ProductName, P.UnitPrice
	END
ELSE
	BEGIN
		Print 'La tabla ProductSales si existe'
	END
ROLLBACK TRANSACTION

-- Comprobamos que se han insertado los datos
SELECT * FROM ProductSales

--3. Comprueba si existe una tabla llamada ShipShip. Esta tabla ha de tener de cada Transportista el ID,
--   el Nombre de la compañía, el número total de envíos que ha efectuado y el número de países diferentes a los que ha llevado cosas. 
--   Si no existe, créala
BEGIN TRANSACTION
IF OBJECT_ID('ShipShip') IS NULL
	BEGIN
		Print 'La tabla ShipShip no existe, procederemos a crearla' 
		CREATE TABLE ShipShip
		(
			ID int NOT NULL CONSTRAINT PK_Ship PRIMARY KEY,
			CompanyName	 varchar(50) NOT NULL,
			TotalShip    int		 NOT NULL,
			TotalCountry int         NOT NULL
			CONSTRAINT FK_ShipShip_Shipers FOREIGN KEY(ID) REFERENCES Shippers (ShipperID)
			ON UPDATE CASCADE ON DELETE NO ACTION
		) 

		-- Insertamos los datos que nos piden
		INSERT INTO ShipShip
		SELECT DISTINCT S.ShipperID, CompanyName, COUNT(O.OrderID) AS NumeroPedidosEnviados, COUNT(DISTINCT O.ShipCountry) AS NumeroDePaises
		FROM Shippers AS S
		JOIN [Orders] AS O ON S.ShipperID = O.ShipVia
		GROUP BY S.ShipperID, CompanyName
	END
ELSE
	BEGIN
		Print 'La tabla ShipShips si existe'
	END
ROLLBACK TRANSACTION

-- Compobamos que se a creado la tabla
SELECT * FROM ShipShip

--4. Comprueba si existe una tabla llamada EmployeeSales. Esta tabla ha de tener de cada empleado su ID, el Nombre completo, el número de ventas totales que ha realizado, el número de clientes diferentes a los que ha vendido y el total de dinero facturado. Si no existe, créala
BEGIN TRANSACTION
IF OBJECT_ID('EmployeeSales') IS NULL
	BEGIN
		Print 'La tabla EmployeeSales no existe, procederemos a crearla' 
		CREATE TABLE EmployeeSales
		(
			ID int NOT NULL CONSTRAINT PK_Ship PRIMARY KEY,
			LastName	      varchar(20) NOT NULL,
			FirstName	      varchar(20) NOT NULL,
			TotalSales        int		  NOT NULL,
			NumberOfCustomers int		  NOT NULL,
			TotalCharged      int         NOT NULL
		) 

		-- Insertamos los datos que nos piden
		INSERT INTO EmployeeSales
		SELECT E.EmployeeID, E.LastName, E.FirstName, COUNT(O.OrderID) AS NumeroVentas, COUNT(DISTINCT O.CustomerID) AS NumeroClientes, SUM(OD.UnitPrice) AS TotalFacturado
		FROM Employees AS E
		JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
		JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
		GROUP BY E.EmployeeID, E.LastName, E.FirstName


		SELECT * FROM Employees
	END
ELSE
	BEGIN
		Print 'La tabla EmployeeSales si existe'
	END
ROLLBACK TRANSACTION

-- Compobamos que se a creado la tabla
SELECT * FROM EmployeeSales


--5. Entre los años 96 y 97 hay productos que han aumentado sus ventas y otros que las han disminuido. 
--   Queremos cambiar el precio unitario según la siguiente tabla:
--Incremento de ventas  Incremento de precio

--Negativo              -10%
--Entre 0 y 10%         No varía
--Entre 10% y 50%       +5%
--Mayor del 50%         10% con un máximo de 2,25

SELECT * FROM Vtas96
SELECT * FROM Ventas_97
--Crear vista con ventas del 96 y 97 para cada producto, su incremento y el %

UPDATE Products
SET UnitPrice = CASE...
FROM VistaMaravillosa
WHERE Product.ProductID = VM.ProductID