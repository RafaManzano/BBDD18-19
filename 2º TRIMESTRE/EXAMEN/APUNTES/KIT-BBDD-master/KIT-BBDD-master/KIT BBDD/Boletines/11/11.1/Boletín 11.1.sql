USE Northwind
/*1. Deseamos incluir un producto en la tabla Products llamado "Cruzcampo lata” pero no estamos seguros si se
ha insertado o no. El precio son 4,40, el proveedor es el 16, la categoría 1 y la cantidad por unidad es
"Pack 6 latas”. "Discontinued” toma el valor 0 y el resto de columnas se dejarán a NULL. Escribe un script que
compruebe si existe un producto con ese nombre. En caso afirmativo, actualizará el precio y en caso negativo
insertarlo.*/

--DELETE FROM Products WHERE ProductName = 'Cruzcampo lata'

IF NOT EXISTS (SELECT * FROM PRODUCTS WHERE ProductName = 'Cruzcampo lata')
	BEGIN
		PRINT('Producto no encontrado, será insertado.')
		INSERT INTO Products VALUES(
			'Cruzcampo lata', --ProductName
			16, --SupplierID
			1, --CategoryID
			'Pack 6 latas', --QuantityPerUnit
			4.40, --UnitPrice
			NULL, --UnitsInStock
			NULL, --UnitsOnOrder
			NULL, --ReorderLevel
			0 --Discontinued
		)
	END
ELSE
	BEGIN
	PRINT('Producto encontrado, será modificado.')
		UPDATE Products SET
			ProductName = 'Cruzcampo lata',
			SupplierID = 16,
			CategoryID = 1,
			QuantityPerUnit = 'Pack 6 latas',
			UnitPrice = 4.40,
			Discontinued = 0
		WHERE ProductName = 'Cruzcampo lata'
	END
--SELECT * FROM Products WHERE ProductName = 'Cruzcampo lata'

/*2. Comprueba si existe una tabla llamada ProductSales. Esta tabla ha de tener de cada producto el ID, el
Nombre, el Precio unitario, el número total de unidades vendidas y el total de dinero facturado con ese
producto. Si no existe, créala*/

--DROP TABLE ProductSales

IF(OBJECT_ID('ProductSales') IS NULL)
	BEGIN
		PRINT('La tabla no está, será creada.')
		CREATE TABLE ProductSales(
			ProductID int NOT NULL
			CONSTRAINT FK_ProductID FOREIGN KEY REFERENCES Products(ProductID)
			ON DELETE CASCADE ON UPDATE CASCADE,
			ProductName nvarchar(40),
			UnitPrice money NULL,
			[Unidades vendidas] int NULL,
			[Total facturado] money NULL
		)
		INSERT INTO ProductSales
			SELECT
				P.ProductID,
				P.ProductName,
				P.UnitPrice,
				SUM(OD.Quantity) AS [Unidades vendidas],
				P.UnitPrice*SUM(OD.Quantity) AS [Total facturado]
			FROM
				Products AS P
				INNER JOIN [Order Details] AS OD
				ON P.ProductID = OD.ProductID
			GROUP BY
				P.ProductID,
				P.ProductName,
				P.UnitPrice
	END
ELSE
	BEGIN
		PRINT('Los DBA han sido buenos chicos.')
		SELECT * FROM ProductSales
	END

/*3. Comprueba si existe una tabla llamada ShipShip. Esta tabla ha de tener de cada Transportista el ID, el
Nombre de la compañía, el número total de envíos que ha efectuado y el número de países diferentes a los que ha
llevado cosas. Si no existe, créala*/

IF(OBJECT_ID('ShipShip') IS NULL)
	BEGIN
		SELECT 'será creada.' AS 'La tabla no está,'
		CREATE TABLE ShipShip(
			ShipperID int NOT NULL
			CONSTRAINT FK_Shippers FOREIGN KEY REFERENCES Shippers(ShipperID)
			ON DELETE CASCADE ON UPDATE CASCADE,
			CompanyName nvarchar(40) NOT NULL,
			[Envíos] int NULL,
			[Países a los que envía] int NULL
		)
		INSERT INTO ShipShip
			SELECT
				S.ShipperID,
				S.CompanyName,
				COUNT(*) AS 'Envíos',
				COUNT(DISTINCT O.ShipCountry) AS 'Países a los que envía'
			FROM
				Shippers AS S
				INNER JOIN Orders AS O
				ON S.ShipperID = O.ShipVia
				INNER JOIN [Order Details] AS OD
				ON O.OrderID = OD.OrderID
			GROUP BY
				S.ShipperID,
				S.CompanyName
				SELECT * FROM ShipShip
	END
ELSE
	BEGIN
		SELECT ' buenos chicos.' AS 'Los DBA han sido'
		SELECT * FROM ShipShip
	END

/*4. Comprueba si existe una tabla llamada EmployeeSales. Esta tabla ha de tener de cada empleado su ID, el
Nombre completo, el número de ventas totales que ha realizado, el número de clientes diferentes a los que ha
vendido y el total de dinero facturado. Si no existe, créala*/

/*5. Entre los años 96 y 97 hay productos que han aumentado sus ventas y otros que las han disminuido. Queremos
cambiar el precio unitario según la siguiente tabla:
·----------------------·-----------------------------·
| Incremento de ventas |  Incremento de precio       |
·----------------------·-----------------------------·
|  Negativo			   |  -10%						 |
|  Entre 0% y 10%	   |  No varía					 |
|  Entre 10% y 50%	   |  +5%						 |
|  Mayor del 50%	   |  10% con un máximo del 2,25 |
·----------------------------------------------------·
*/

--CONSULTA DEL EJERCICIO 9.2.11
SELECT * FROM [DiferenciasAños]

BEGIN TRANSACTION
UPDATE Products SET
UnitPrice =
	CASE
		WHEN [DiferenciasAños].D
ROLLBACK