
--1. Nombre del país y número de clientes de cada país, ordenados alfabéticamente por el nombre del país.
--2. ID de producto y número de unidades vendidas de cada producto. 
--3. ID del cliente y número de pedidos que nos ha hecho.
--4. ID del cliente, año y número de pedidos que nos ha hecho cada año.
--5. ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor. Si hay varios precios unitarios para el mismo producto tomaremos el mayor.
--6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor.
--7. Número de pedidos registrados mes a mes de cada año.
--8. Año y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en la que lo hemos enviado (ShipDate), en días para cada año.
--9. ID del distribuidor y número de pedidos enviados a través de ese distribuidor.
--10. ID de cada proveedor y número de productos distintos que nos suministra.
--Última modificación: miércoles, 14 de enero de 2015, 12:37

-- 1. Nombre del país y número de clientes de cada país, ordenados alfabéticamente por el nombre del país.
SELECT Country, COUNT(CustomerID) AS NumeroClientes
FROM Customers
GROUP BY Country
ORDER By Country ASC

--2. ID de producto y número de unidades vendidas de cada producto. 
SELECT P.ProductID, COUNT(OD.Quantity) AS UnidadesVendidas
FROM Products AS P
JOIN [Order Details] AS OD on P.ProductID = OD.ProductID
GROUP BY P.ProductID

--3. ID del cliente y número de pedidos que nos ha hecho.
SELECT CustomerID, COUNT(orderID) AS NumeroPedidos
FROM Orders
GROUP BY CustomerID

--4. ID del cliente, año y número de pedidos que nos ha hecho cada año.
SELECT 