--BOLETIN 8.1
USE Northwind

--1. Nombre del país y número de clientes de cada país, ordenados alfabéticamente por el nombre del país.
SELECT Country, COUNT(*) AS NumberCustomer FROM Customers
	--WHERE 
	GROUP BY Country
	ORDER BY Country

--2. ID de producto y número de unidades vendidas de cada producto. 
SELECT ProductID, SUM(Quantity) AS CantidadTotal FROM [Order Details]
	--WHERE
	GROUP BY ProductID
	ORDER BY ProductID

--3. ID del cliente y número de pedidos que nos ha hecho.
SELECT CustomerID, COUNT (CustomerID) AS CantidadPedidos FROM Orders
	--WHERE
	GROUP BY CustomerID
	--ORDER BY

--4. ID del cliente, año y número de pedidos que nos ha hecho cada año.
SELECT CustomerID, YEAR(OrderDate) AS [Year], COUNT(CustomerID) AS Orders FROM Orders
	--WHERE
	GROUP BY CustomerID, YEAR(OrderDate)
	ORDER BY CustomerID

--5. ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor. Si hay varios precios unitarios para el mismo producto tomaremos el mayor.
SELECT ProductID, MAX(UnitPrice) AS PrecioUnitarioMaximo, SUM(Quantity) AS CantidaTotal, (MAX(UnitPrice)*SUM(Quantity)) AS TotalFacturado FROM [Order Details]
	--WHERE
	GROUP BY ProductID
	ORDER BY (MAX(UnitPrice)*SUM(Quantity)) DESC

--6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor.
SELECT SupplierID, (SUM(UnitsInStock)*AVG(UnitPrice)) AS ImporteTotal FROM Products
	--WHERE
	GROUP BY SupplierID
	--ORDER BY

--7. Número de pedidos registrados mes a mes de cada año.
SELECT YEAR(OrderDate) AS YEAR, MONTH(Orderdate) AS MONTH, COUNT(OrderID) AS ORDERS FROM Orders
	--WHERE
	GROUP BY YEAR(OrderDate), MONTH(OrderDate) 
	ORDER BY YEAR(OrderDate), MONTH(OrderDate) 

--8. Año y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en la que lo hemos enviado (ShipDate), en días para cada año.
SELECT YEAR(OrderDate) AS Año, AVG(DAY(ShippedDate) - DAY(OrderDate)) AS TiempoMedioDias FROM Orders
	--WHERE
	GROUP BY YEAR(OrderDate)
	--ORDER BY
	--ESTE FALTA DATEDIFF

--9. ID del distribuidor y número de pedidos enviados a través de ese distribuidor.
SELECT ShipVia, COUNT(OrderID) as NumeroPedidos FROM Orders
	--WHERE 
	GROUP BY ShipVia
	--ORDER BY

--10. ID de cada proveedor y número de productos distintos que nos suministra.
SELECT SupplierID, COUNT(ProductID) as NumeroDeProductosDistintos FROM Products
	--WHERE 
	GROUP BY SupplierID
	--ORDER BY 
