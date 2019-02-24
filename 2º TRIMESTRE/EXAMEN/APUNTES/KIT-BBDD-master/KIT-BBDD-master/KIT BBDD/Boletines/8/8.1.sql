/*
1. Nombre del país y número de clientes de cada país, ordenados alfabéticamente por el nombre del país.
2. ID de producto y número de unidades vendidas de cada producto. 
3. ID del cliente y número de pedidos que nos ha hecho.
4. ID del cliente, año y número de pedidos que nos ha hecho cada año.
5. ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor. Si hay varios precios unitarios para el mismo producto tomaremos el mayor.
6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor.
7. Número de pedidos registrados mes a mes de cada año.
8. Año y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en la que lo hemos enviado (ShipDate), en días para cada año.
9. ID del distribuidor y número de pedidos enviados a través de ese distribuidor.
10. ID de cada proveedor y número de productos distintos que nos suministra.
Última modificación: miércoles, 14 de enero de 2015, 12:37
*/
USE Northwind

-- 1. Nombre del país y número de clientes de cada país, ordenados alfabéticamente por el nombre del país.
SELECT Country, COUNT(*) AS NumeroClientes
FROM Customers
GROUP BY Country
ORDER BY Country

-- 2. ID de producto y número de unidades vendidas de cada producto. 
SELECT ProductID, SUM(Quantity) AS CantidadTotal FROM [Order Details]
	--WHERE
	GROUP BY ProductID
	ORDER BY ProductID

-- 3. ID del cliente y número de pedidos que nos ha hecho
SELECT CustomerID, COUNT(*) AS NumeroPedidos 
FROM Orders
GROUP BY CustomerID


-- 4. ID del cliente, año y número de pedidos que nos ha hecho cada año.
SELECT CustomerID, YEAR(OrderDate) AS [YEAR], COUNT(CustomerID) AS NumeroPedidos 
FROM Orders
GROUP BY CustomerID, YEAR(OrderDate)
ORDER BY CustomerID

-- 5. ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor.
-- Si hay varios precios unitarios para el mismo producto tomaremos el mayor

-- 6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor.
SELECT SupplierID, (SUM(UnitsInStock)*AVG(UnitPrice)) AS ImporteTotal FROM Products
GROUP BY SupplierID

-- 7. Número de pedidos registrados mes a mes de cada año.
SELECT YEAR(OrderDate) AS [YEAR], MONTH(OrderDate) AS [MONTH], COUNT(OrderID) AS [Numero Pedidos]
FROM Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate) 
ORDER BY YEAR(OrderDate), MONTH(OrderDate) 

-- 8. Año y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) 
-- y la fecha en la que lo hemos enviado (ShipDate), en días para cada año.
