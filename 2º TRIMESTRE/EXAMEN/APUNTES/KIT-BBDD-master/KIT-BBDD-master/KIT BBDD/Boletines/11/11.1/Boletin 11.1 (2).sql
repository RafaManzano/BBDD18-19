USE Northwind

-- EJERCICIO 1
--Deseamos incluir un producto en la tabla Products llamado "Cruzcampo botellín” pero no estamos seguros si se ha insertado o no.
--El precio son 2,40, el proveedor es el 16, la categoría 1 y la cantidad por unidad son "Pack de seis botellines” El resto de 
--columnas se dejarán a NULL. Escribe un script que compruebe si existe un producto con ese nombre. En caso afirmativo, actualizará 
--el precio y en caso negativo insertarlo. Comprueba si existe una tabla llamada ProductSales. Esta tabla ha de tener de cada 
--producto el ID, el Nombre, el Precio unitario, el número total de unidades vendidas y el total de dinero facturado con ese 
--producto. Si no existe, créala

SELECT * FROM Products

--Tambien vale --> IF('Cruzcampo botellin'=ANY(SELECT ProductName FROM Products))
--Tambien vale --> IF('Cruzcampo botellin'!=ALL(SELECT ProductName FROM Products))
BEGIN TRANSACTION

IF('Cruzcampo botellin' in (SELECT ProductName FROM Products))
	UPDATE Products
		SET UnitPrice=2.40
		WHERE ProductName='Cruzcampo botellin'
ELSE 
	
	INSERT INTO Products(ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel)
		VALUES('Cruzcampo botellin',16,1,'Pack de 6 botellines',NULL,NULL,NULL,NULL)

COMMIT TRANSACTION
ROLLBACK TRANSACTION

-- EJERCICIO 2
--Comprueba si existe una tabla llamada ShipShip. Esta tabla ha de tener de cada Transportista el ID, el Nombre de la compañía, 
--el número total de envíos que ha efectuado y el número de países diferentes a los que ha llevado cosas. Si no existe, créala



-- EJERCICIO 3
--Comprueba si existe una tabla llamada EmployeeSales. Esta tabla ha de tener de cada empleado su ID, el Nombre completo, 
--el número de ventas totales que ha realizado, el número de clientes diferentes a los que ha vendido y el total de dinero 
--facturado. Si no existe, créala