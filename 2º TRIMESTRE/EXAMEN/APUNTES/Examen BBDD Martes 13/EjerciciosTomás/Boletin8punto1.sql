/*1. Nombre del país y número de clientes de cada país, ordenados alfabéticamente por el nombre del país.*/
SELECT * FROM Customers

SELECT Country, COUNT(Country) AS [Numero de Clientes] FROM Customers
	GROUP BY Country
	ORDER BY Country

/*2. ID de producto y número de unidades vendidas de cada producto.*/
SELECT * FROM [Order Details]

SELECT ProductID, SUM(Quantity) AS [Cantidad] FROM [Order Details] 
	Group by ProductID
	ORDER BY ProductID

/*3. ID del cliente y número de pedidos que nos ha hecho.*/
SELECT * FROM Orders

SELECT CustomerID, COUNT(CustomerID) AS [Numero de pedidos] FROM Orders
	GROUP BY CustomerID
	ORDER BY CustomerID

/*4. ID del cliente, año y número de pedidos que nos ha hecho cada año.*/
SELECT * FROM Orders

SELECT CustomerID, YEAR(OrderDate) AS [Año de pedido], COUNT(CustomerID) AS [Numero de pedidos] FROM Orders
	GROUP BY YEAR(OrderDate), CustomerID
	ORDER BY CustomerID

/*5. ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor.  djfgjxdftjdfjdrtfjhsdrtjsertjhsdfghrtfjh
Si hay varios precios unitarios para el mismo producto tomaremos el mayor.*/
SELECT * FROM Products

SELECT ProductID, MAX(UnitPrice), UnitPrice*UnitsOnOrder AS [Total facturado] FROM Products
	ORDER BY [Total facturado] DESC

/*6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor.*/
SELECT * FROM Products

SELECT SupplierID, Sum(UnitPrice*UnitsInStock) AS [Importe total del stock] FROM Products
	GROUP BY SupplierID

/*7. Número de pedidos registrados mes a mes de cada año.*/
SELECT * FROM Orders

SELECT Count(OrderID) AS [Numero de pedidos], Month(OrderDate) AS [Mes], Year(OrderDate) AS [Año] FROM Orders
	GROUP BY Month(OrderDate), YEAR(OrderDate)
	ORDER BY Año, Mes

/*8. Año y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en la que lo hemos enviado (ShipDate), en días para cada año.*/
SELECT * FROM Orders

SELECT YEAR(OrderDate) AS [Año del pedido], AVG(DAY(OrderDate - ShippedDate)) AS [Tiempo medio transcurrido (en días)]
	FROM Orders
	GROUP BY YEAR(OrderDate)
	ORDER BY YEAR(OrderDate) ASC

/*9. ID del distribuidor y número de pedidos enviados a través de ese distribuidor.*/
SELECT * FROM Products

SELECT SupplierID, Count(SupplierID) AS [Numero de pedidos al distribuidor] FROM Products
	GROUP BY SupplierID

/*10. ID de cada proveedor y número de productos distintos que nos suministra.*/
SELECT * FROM Products

SELECT SupplierID, Count(CategoryID) AS [Numero de productos distintos] FROM Products
	GROUP BY SupplierID