USE Northwind

--1. Número de clientes de cada país.
SELECT COUNT(*) AS CustomersNumber, Country FROM Customers
GROUP BY Country

--2. Número de clientes diferentes que compran cada producto. Incluye el nombre del producto
SELECT COUNT(DISTINCT C.ContactName) AS CustomersNumber, P.ProductID, P.ProductName FROM Customers AS C
INNER JOIN Orders AS O ON O.CustomerID = C.CustomerID
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
GROUP BY  P.ProductID, P.ProductName

--3. Número de países diferentes en los que se vende cada producto. Incluye el nombre del producto
SELECT COUNT(DISTINCT O.ShipCountry) AS Countries, P.ProductID, P.ProductName FROM Orders AS O 
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
GROUP BY  P.ProductID, P.ProductName

--4. Empleados (nombre y apellido) que han vendido alguna vez “Gudbrandsdalsost”, “Lakkalikööri”, “Tourtière” o “Boston Crab Meat”.
SELECT DISTINCT E.FirstName, E.LastName FROM Employees AS E
INNER JOIN Orders AS O ON O.EmployeeID = E.EmployeeID
INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
WHERE P.ProductName IN('Gudbrandsdalsost', 'Lakkalikööri', 'Tourtière' , 'Boston Crab Meat')

--5. Empleados que no han vendido nunca “Northwoods Cranberry Sauce” o “Carnarvon Tigers”.
SELECT FirstName, LastName FROM Employees
EXCEPT 
SELECT DISTINCT E.FirstName, E.LastName FROM Employees AS E
INNER JOIN Orders AS O ON O.EmployeeID = E.EmployeeID
INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
WHERE P.ProductName IN('Northwoods Cranberry Sauce' , 'Carnarvon Tigers')

--6. Número de unidades de cada categoría de producto que ha vendido cada empleado. Incluye el nombre y apellidos 
--del empleado y el nombre de la categoría.
SELECT SUM(P.UnitsInStock + UnitsOnOrder) AS Units, C.CategoryID, E.EmployeeID, E.FirstName, E.LastName AS Units FROM Categories AS C 
INNER JOIN Products AS P ON P.CategoryID = C.CategoryID
INNER JOIN [Order Details] AS OD ON OD.ProductID = P.ProductID
INNER JOIN Orders AS O ON O.OrderID = OD.OrderID
INNER JOIN Employees AS E ON E.EmployeeID = O.EmployeeID
GROUP BY C.CategoryID, E.EmployeeID, E.FirstName, E.LastName

--7. Total de ventas (US$) de cada categoría en el año 97. Incluye el nombre de la categoría.
SELECT SUM(OD.Quantity * OD.UnitPrice) AS Total, C.CategoryID, C.CategoryName FROM Categories AS C
INNER JOIN Products AS P ON P.CategoryID = C.CategoryID
INNER JOIN [Order Details] AS OD ON OD.ProductID = P.ProductID
INNER JOIN Orders AS O ON O.OrderID = OD.OrderID
WHERE YEAR(O.OrderDate) = 1997
GROUP BY  C.CategoryID, C.CategoryName
ORDER BY C.CategoryID ASC

--8. Productos que han comprado más de un cliente del mismo país, indicando el nombre del producto, el país y 
--el número de clientes distintos de ese país que lo han comprado. Esta mal
SELECT * FROM Products

SELECT P.ProductName, COUNT (DISTINCT C.CustomerID) AS CustomersNumber, O.ShipCountry FROM  Products AS P
INNER JOIN [Order Details] AS OD ON OD.ProductID = P.ProductID
INNER JOIN Orders AS O ON O.OrderID = OD.OrderID
INNER JOIN Customers AS C ON C.CustomerID = O.CustomerID
GROUP BY O.ShipCountry, P.ProductName
HAVING  COUNT (DISTINCT C.CustomerID) > 1

SELECT Country FROM Products AS P
INNER JOIN [Order Details] AS OD ON OD.ProductID = P.ProductID
INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
INNER JOIN Customers AS C ON C.CustomerID = O.CustomerID
WHERE C.CustomerID IN (SELECT COUNT(C.CustomerID) AS CustomersNumber FROM Products AS P
					  INNER JOIN [Order Details] AS OD ON OD.ProductID = P.ProductID
					  INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
					  INNER JOIN Customers AS C ON C.CustomerID = O.CustomerID
					  GROUP BY P.ProductID)
GROUP BY C.Country


--9. Total de ventas (US$) en cada país cada año.
SELECT SUM(OD.Quantity * OD.UnitPrice) AS Total, O.ShipCountry, YEAR(O.OrderDate) AS Year FROM  [Order Details] AS OD
INNER JOIN Orders AS O ON O.OrderID = OD.OrderID
GROUP BY O.ShipCountry, YEAR(O.OrderDate)
ORDER BY Year ASC

--10. Producto superventas de cada año, indicando año, nombre del producto, categoría y cifra total de ventas.
SELECT MAX(OD.UnitPrice * OD.Quantity) AS Blockbusters, YEAR(O.OrderDate) AS Year, P.ProductName, C.CategoryID FROM Products AS P
INNER JOIN [Order Details] AS OD ON OD.ProductID = P.ProductID
INNER JOIN Orders AS O ON O.OrderID = OD.OrderID
INNER JOIN Categories AS C ON C.CategoryID = P.CategoryID
GROUP BY YEAR(O.OrderDate), P.ProductName, C.CategoryID

SELECT MAX(OD.UnitPrice * OD.Quantity) AS Blockbusters, YEAR(O.OrderDate) AS Year FROM Products AS P
INNER JOIN [Order Details] AS OD ON OD.ProductID = P.ProductID
INNER JOIN Orders AS O ON O.OrderID = OD.OrderID
INNER JOIN Categories AS C ON C.CategoryID = P.CategoryID
GROUP BY YEAR(O.OrderDate)

--11. Cifra de ventas de cada producto en el año 97 y su aumento o disminución respecto al año anterior en US $ y en %.
--Cifra de ventas del año 1997
SELECT DISTINCT Sales97.Quantity, (Sales97.Sales97 - Sales96.Sales96) AS [Difference $], ((Sales97.Sales97 - Sales96.Sales96) / Sales96.Sales96) * 100 AS [Percentage %], P.ProductID, P.ProductName FROM (
				--Cifra de ventas del año 97
				SELECT SUM(OD.Quantity) AS Quantity, SUM(OD.Quantity * OD.UnitPrice) AS Sales97, OD.ProductID FROM [Order Details] AS OD 
				INNER JOIN Orders AS O ON O.OrderID = OD.OrderID
				WHERE YEAR(O.OrderDate) = 1997 
				GROUP BY OD.ProductID) AS Sales97
				
	INNER JOIN (
				--Cifra de ventas del año 96
				SELECT SUM(OD.Quantity) AS Quantity, SUM(OD.Quantity * OD.UnitPrice) AS Sales96, OD.ProductID FROM [Order Details] AS OD 
				INNER JOIN Orders AS O ON O.OrderID = OD.OrderID
				WHERE YEAR(O.OrderDate) = 1996 
				GROUP BY OD.ProductID) AS Sales96 

	ON Sales96.ProductID = Sales97.ProductID
	INNER JOIN Products AS P ON P.ProductID = Sales97.ProductID
	ORDER BY P.ProductID ASC
	


--12. Mejor cliente (el que más nos compra) de cada país.
SELECT COUNT(O.CustomerID) AS BestCustomer, C.Country FROM Customers AS C
INNER JOIN Orders AS O ON C.CustomerID = O.CustomerID
GROUP BY C.Country

--13. Número de productos diferentes que nos compra cada cliente. Incluye el nombre y apellidos del cliente y su dirección completa.
SELECT COUNT(DISTINCT P.ProductID) AS ProductsNumber,C.CustomerID,C.ContactName, C.Address, C.City FROM Products AS P
INNER JOIN [Order Details] AS OD ON OD.ProductID = P.ProductID
INNER JOIN Orders AS O ON OD.OrderID = O.OrderID
INNER JOIN Customers AS C ON O.CustomerID = C.CustomerID
GROUP BY C.CustomerID,C.ContactName, C.Address, C.City 

--14. Clientes que nos compran más de cinco productos diferentes.

--15.Vendedores (nombre y apellidos) que han vendido una mayor cantidad que la media en US $ en el año 97.
SELECT AVG((SELECT OD.Quantity * OD.UnitPrice FROM [Order Details] AS OD)) AS Total, YEAR(O.OrderDate) AS Year FROM Products AS P
INNER JOIN [Order Details] AS OD ON OD.ProductID = P.ProductID
INNER JOIN Orders AS O ON O.OrderID = OD.OrderID
GROUP BY YEAR(O.OrderDate)