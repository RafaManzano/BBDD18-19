USE Northwind

--1. Nombre del país y número de clientes de cada país, ordenados alfabéticamente por el nombre del país. 
SELECT * FROM Customers

SELECT COUNT(*) AS NumberOfCustomers, Country FROM Customers
GROUP BY Country


--2. ID de producto y número de unidades vendidas de cada producto. 
SELECT * FROM Products

SELECT ProductID,  SUM(UnitsOnOrder) AS UnitsSells FROM Products
GROUP BY ProductID

--3. ID del cliente y número de pedidos que nos ha hecho.
SELECT * FROM Orders

SELECT CustomerID, COUNT(*) AS NumberOfOrders FROM Orders
GROUP BY CustomerID

--4. ID del cliente, año y número de pedidos que nos ha hecho cada año.
SELECT * FROM Orders

SELECT CustomerID, COUNT(*) AS NumberOfOrders, YEAR(OrderDate) AS [Year] FROM Orders
GROUP BY YEAR(OrderDate), CustomerID

--5. ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor. 
--Si hay varios precios unitarios para el mismo producto tomaremos el mayor. (Mitica dificultad de examen pregunta 4)
SELECT * FROM Products

SELECT ProductID, SUM(UnitPrice * UnitsOnOrder) AS Total FROM Products
GROUP BY ProductID
ORDER BY Total DESC

--6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor.
SELECT * FROM Products

SELECT SupplierID, SUM(UnitPrice * UnitsInStock) AS Total FROM Products
GROUP BY SupplierID

--7. Número de pedidos registrados mes a mes de cada año.
SELECT * FROM Orders

SELECT COUNT(*) AS NumberOfOrders, YEAR(OrderDate) AS [Year], MONTH(OrderDate) AS [Month] FROM Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year ASC

--8. Año y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en la que lo hemos enviado (ShipDate), en días para cada año.
SELECT * FROM Orders

SELECT CAST(AVG(ShippedDate - OrderDate) AS smalldatetime) AS Average FROM Orders

