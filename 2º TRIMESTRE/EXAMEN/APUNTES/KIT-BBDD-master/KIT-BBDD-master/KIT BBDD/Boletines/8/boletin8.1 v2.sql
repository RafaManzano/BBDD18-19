--1. Nombre del país y número de clientes de cada país, ordenados alfabéticamente por el nombre del país.
SELECT Country, COUNT(CustomerID) AS [Numero_Clientes] FROM Customers
	GROUP BY country ORDER BY Country ASC --COUNT cuenta el numero de filas.

--2. ID de producto y número de unidades vendidas de cada producto. 
SELECT productID, SUM(UnitsOnOrder) AS [Unidades_vendidas] FROM Products
	GROUP BY productID ORDER BY Unidades_vendidas DESC --SUM calcula la suma de todos los valores no nulos

--3. ID del cliente y número de pedidos que nos ha hecho.
SELECT CustomerID, COUNT(CustomerID) AS [Numero_Pedidos] FROM Orders
	GROUP BY CustomerID ORDER BY Numero_Pedidos ASC

--4. ID del cliente, año y número de pedidos que nos ha hecho cada año.
SELECT CustomerID, OrderDate, COUNT(CustomerID) as [Num_Pedidos]
	FROM Orders
		GROUP BY CustomerID, OrderDate ORDER BY Num_Pedidos DESC

--5. ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor. Si hay varios precios unitarios para el mismo producto tomaremos el mayor.
SELECT productID, UnitPrice, (Unitprice * UnitsOnOrder) AS [Total Facturado] FROM Products
	ORDER BY [Total Facturado] DESC

--6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor.
SELECT S.SupplierID, P.UnitsInStock FROM Suppliers AS[S]
	INNER JOIN Products AS [P] ON S.SupplierID = P.SupplierID

--7. Número de pedidos registrados mes a mes de cada año.
SELECT YEAR(OrderDate) AS [Año], MONTH(OrderDate) AS [MES], COUNT (MONTH(OrderDate)) AS[Numero] FROM Orders
	GROUP BY YEAR(OrderDate), MONTH(OrderDate)
		ORDER BY Año ASC

--8. Año y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en la que lo hemos enviado (ShipDate), en días para cada año.
SELECT YEAR(OrderDate) AS [Año], AVG(DAY(ShippedDate - OrderDate)) AS [Media] FROM Orders
	GROUP BY YEAR(OrderDate)

--9. ID del distribuidor y número de pedidos enviados a través de ese distribuidor.
SELECT S.SupplierID, COUNT(O.OrderID) AS[Number_Order] FROM Suppliers AS [S]
	INNER JOIN Products AS [P] ON S.SupplierID = P.SupplierID
		INNER JOIN [Order details] AS [OD] ON P.ProductID = OD.ProductID
			INNER JOIN Orders AS[O] ON OD.OrderID  = O.OrderID
				GROUP BY S.SupplierID ORDER BY S.SupplierID ASC

--10. ID de cada proveedor y número de productos distintos que nos suministra.
SELECT SupplierID, COUNT(SupplierID) AS [Productos] FROM Products
	GROUP BY SupplierID
