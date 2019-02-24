USE Northwind
SELECT * FROM Customers
SELECT * FROM Products

--1.  Número de clientes de cada país. 
SELECT COUNT(CustomerID) AS CustomersNumber, Country FROM Customers 
GROUP BY Country

--2. Número de clientes diferentes que compran cada producto. Incluye el nombre
--del producto 
SELECT COUNT(DISTINCT C.CustomerID) AS CustomersNumber, P.ProductName FROM Customers AS C
INNER JOIN Orders AS O ON O.CustomerID = C.CustomerID
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
GROUP BY P.ProductName

--3. Número de países diferentes en los que se vende cada producto. Incluye el
--nombre del producto
SELECT P.ProductName, COUNT(DISTINCT O.ShipCountry) AS ContriesNumber FROM Orders AS O
INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
GROUP BY P.ProductName

--4.  Empleados (nombre y apellido) que han vendido alguna vez
--“Gudbrandsdalsost”, “Lakkalikööri”, “Tourtière” o “Boston Crab Meat”. 
SELECT DISTINCT E.FirstName, E.LastName FROM Employees AS E
INNER JOIN Orders AS O ON O.EmployeeID = E.EmployeeID
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
WHERE P.ProductName IN('Gudbrandsdalsost', 'Lakkalikööri', 'Tourtière' , 'Boston Crab Meat')

--5.  Empleados que no han vendido nunca “Northwoods Cranberry Sauce” o
--“Carnarvon Tigers”. 
SELECT DISTINCT E.FirstName, E.LastName FROM Employees AS E
EXCEPT
SELECT DISTINCT E.FirstName, E.LastName FROM Employees AS E
INNER JOIN Orders AS O ON O.EmployeeID = E.EmployeeID
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
WHERE P.ProductName IN('Northwoods Cranberry Sauce', 'Carnarvon Tigers')

--6.  Número de unidades de cada categoría de producto que ha vendido cada
--empleado. Incluye el nombre y apellidos del empleado y el nombre de la
--categoría. 
SELECT DISTINCT SUM(OD.Quantity) AS Quantity, C.CategoryID, C.CategoryName, E.EmployeeID, E.FirstName, E.LastName FROM Employees AS E
INNER JOIN Orders AS O ON O.EmployeeID = E.EmployeeID
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
INNER JOIN Categories AS C ON C.CategoryID = P.CategoryID
GROUP BY C.CategoryID, C.CategoryName, E.EmployeeID, E.FirstName, E.LastName

--7. Total de ventas (US$) de cada categoría en el año 97. Incluye el nombre de la
--categoría. 
SELECT SUM(OD.Quantity * OD.UnitPrice) AS TotalPrice, C.CategoryID, C.CategoryName FROM [Order Details] AS OD
INNER JOIN Orders AS O ON O.OrderID = OD.OrderID
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
INNER JOIN Categories AS C ON C.CategoryID = P.ProductID
--WHERE O.OrderDate = 1997
GROUP BY C.CategoryID, C.CategoryName

--8. Productos que han comprado más de un cliente del mismo país, indicando el
--nombre del producto, el país y el número de clientes distintos de ese país que
--lo han comprado
--Comprobar con Leo que esta correcto
SELECT COUNT(DISTINCT C.CustomerID) AS CustomersNumber, P.ProductName, O.ShipCountry FROM Customers AS C
INNER JOIN Orders AS O ON O.CustomerID = C.CustomerID
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
GROUP BY P.ProductName , O.ShipCountry
HAVING COUNT(C.CustomerID) > 2

--9. Total de ventas (US$) en cada país cada año.
SELECT SUM(Quantity * UnitPrice) AS TotalPrice, O.ShipCountry, YEAR(OrderDate) AS Year FROM [Order Details] AS OD
INNER JOIN Orders AS O ON O.OrderID = OD.OrderID
GROUP BY O.ShipCountry, YEAR(OrderDate)

--10. . Producto superventas de cada año, indicando año, nombre del producto,
--categoría y cifra total de ventas. 

--Hecho por Nzhdeh
SELECT P.ProductID,P.ProductName,P.CategoryID,Definitivo.Año,Definitivo.[Venta maxima] 
FROM Orders AS O

INNER JOIN [Order Details] AS OD ON O.OrderID=OD.OrderID
INNER JOIN Products AS P ON OD.ProductID=P.ProductID
INNER JOIN 
		(
			SELECT MaxProducto.Año,MAX(MaxProducto.[Cifra de ventas]) AS [Venta maxima]
			FROM 
				(SELECT OD.ProductID,YEAR(O.OrderDate) AS [Año],SUM(OD.Quantity) [Cifra de ventas] 
					FROM Orders AS O

					INNER JOIN [Order Details] AS OD 
					ON O.OrderID=OD.OrderID

					GROUP BY OD.ProductID,YEAR(O.OrderDate)
				) AS MaxProducto 

			GROUP BY MaxProducto.Año

		) AS Definitivo 
		ON YEAR(O.OrderDate)=Definitivo.Año 

GROUP BY  P.ProductID,P.ProductName,P.CategoryID,Definitivo.Año,Definitivo.[Venta maxima]

HAVING SUM(OD.Quantity)=Definitivo.[Venta maxima]

--10. Producto superventas de cada año, indicando año, nombre del producto,
--categoría y cifra total de ventas. 
--Hecho por mi y con vistas
--La cantidad de producto por año
GO
CREATE VIEW CantidadProductoAnho AS
SELECT OD.ProductID, YEAR(O.OrderDate) AS Anho, SUM(OD.Quantity) AS Cantidad FROM [Order Details] AS OD
INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
GROUP BY OD.ProductID, YEAR(O.OrderDate)
GO

--Mejor producto por año
GO
CREATE VIEW MaxProducto AS
SELECT MAX(Cantidad) AS Maximo, Anho FROM CantidadProductoAnho
GROUP BY Anho
GO

--Producto superventas de cada año, indicando año, nombre del producto,
--categoría y cifra total de ventas
SELECT MP.Anho, P.ProductName, P.CategoryID, MP.Maximo FROM MaxProducto AS MP
INNER JOIN Orders AS O ON MP.Anho = YEAR(O.OrderDate)
INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
INNER JOIN Products AS P ON OD.ProductID = P.ProductID
GROUP BY MP.Anho, P.ProductName, P.CategoryID, MP.Maximo
HAVING SUM(OD.Quantity) = MP.Maximo

--11. Cifra de ventas de cada producto en el año 97 y su aumento o 
--disminución respecto al año anterior en US $ y en %. 
--Cifra de ventas total 
--Funcion inline
GO
CREATE FUNCTION CifraVentas (@anno int) 
RETURNS TABLE AS RETURN
SELECT SUM(OD.Quantity * OD.UnitPrice) AS Sales, OD.ProductID FROM [Order Details] AS OD
INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
WHERE YEAR(O.OrderDate) = @anno
GROUP BY ProductID
GO

--Pasos para sacar un porcentaje:
	--1. Hacer la proporcion: SIEMPRE es una division, en ella pondremos aquello que queremos comparar (en este caso, la diferencia de ventas con las ventas97. Las Ventas97 siempre va en el denominador)
	--2. El resultado de la division se multiplica por 100
SELECT CV97.ProductID, CV96.Sales, CV97.Sales, (CV97.Sales - (CV97.Sales - CV96.Sales)) AS Diferencia, ((CV97.Sales - CV96.Sales) / CV97.Sales) * 100 AS Porcentaje FROM CifraVentas(1996) AS CV96
INNER JOIN CifraVentas(1997) AS CV97 ON CV96.ProductID = CV97.ProductID

--12. Mejor cliente (el que más nos compra) de cada país.
--Numero de pedidos por cliente
GO
CREATE VIEW PedidosClientes AS
SELECT COUNT(*) AS NumerosPedidos, CustomerID FROM Orders
GROUP BY CustomerID
GO

GO
CREATE VIEW MaxPaises AS
SELECT MAX(PC.NumerosPedidos) AS MaxPedidos, O.ShipCountry FROM Orders AS O
INNER JOIN PedidosClientes AS PC ON O.CustomerID = PC.CustomerID
GROUP BY O.ShipCountry
GO

SELECT MaxPedidos, C.ContactName, O.ShipCountry FROM MaxPaises AS MP
INNER JOIN Orders AS O ON MP.ShipCountry = O.ShipCountry
INNER JOIN Customers AS C ON O.CustomerID = C.CustomerID
GROUP BY O.ShipCountry, MP.MaxPedidos, C.ContactName
HAVING COUNT(OrderID) = MaxPedidos

--13. Número de productos diferentes que nos compra cada cliente. Incluye el
--nombre y apellidos del cliente y su dirección completa.
SELECT COUNT(DISTINCT P.ProductID) AS Products, C.ContactName, C.Address FROM Products AS P
INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
INNER JOIN Customers AS C ON O.CustomerID = C.CustomerID
GROUP BY C.ContactName, C.Address

--14. Clientes que nos compran más de cinco productos diferentes.
SELECT COUNT(DISTINCT P.ProductID) AS Products, C.ContactName, C.Address FROM Products AS P
INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
INNER JOIN Customers AS C ON O.CustomerID = C.CustomerID
GROUP BY C.ContactName, C.Address
HAVING COUNT(DISTINCT P.ProductID) > 4

--15. Vendedores (nombre y apellidos) que han vendido una mayor cantidad que la
--media en US $ en el año 97.
--Las ventas de cada vendedor 
GO
CREATE VIEW DolaresVendedores AS
SELECT SUM(OD.Quantity * OD.UnitPrice) AS Dolares, E.EmployeeID FROM Employees AS E
INNER JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
GROUP BY E.EmployeeID
GO

--Las ventas totales del anno 1997. Esta no nos hace falta, probare a hacer la media directamente
GO
ALTER VIEW DolaresAnno AS 
SELECT SUM(OD.Quantity * OD.UnitPrice) AS Dolares, YEAR(O.OrderDate) AS Anno FROM Orders AS O 
INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
GROUP BY YEAR(O.OrderDate)
GO

--Queda crear la media y probar
GO
CREATE VIEW DolarAnno AS 
SELECT SUM(OD.Quantity * OD.UnitPrice) AS Dolares, YEAR(O.OrderDate) AS Anno FROM Orders AS O 
INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
WHERE YEAR(O.OrderDate) = 1997
GROUP BY YEAR(O.OrderDate)
GO

--Esta mal hecha quiero darle una vueltita
SELECT E.FirstName, E.LastName, AVG(DA.Dolares) AS Ratha FROM DolaresVendedores AS DV
INNER JOIN Orders AS O ON DV.EmployeeID = O.EmployeeID
INNER JOIN DolarAnno AS DA ON O.OrderDate = DA.Anno
INNER JOIN Employees AS E ON O.EmployeeID = E.EmployeeID
GROUP BY E.FirstName, E.LastName
HAVING AVG(DA.Dolares) < DV.Dolares


--16. Empleados que hayan aumentado su cifra de ventas más de un 10% entre dos
--años consecutivos, indicando el año en que se produjo el aumento.
--Cifra de ventas de cada empleado
GO
CREATE VIEW DolaresVendedores AS
SELECT SUM(OD.Quantity * OD.UnitPrice) AS Dolares, E.EmployeeID FROM Employees AS E
INNER JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
GROUP BY E.EmployeeID
GO

--Vendedores que ganan en los 3 años (dos anteriores).