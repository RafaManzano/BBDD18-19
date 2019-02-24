USE Northwind

-- 1.	Nombre de los proveedores y número de productos que nos vende cada uno
SELECT S.CompanyName , COUNT(P.ProductID) AS [Numero de productos]
FROM Products AS P
INNER JOIN Suppliers AS S ON P.SupplierID = S.SupplierID
Group by CompanyName
Order by CompanyName

-- 2.	Nombre completo y telefono de los vendedores que trabajen en
-- New York, Seattle, Vermont, Columbia, Los Angeles, Redmond o Atlanta.
SELECT LastName, FirstName, HomePhone
FROM Employees AS E
INNER JOIN EmployeeTerritories AS ET ON E.EmployeeID = ET.EmployeeID
INNER JOIN Territories AS T ON ET.TerritoryID = T.TerritoryID
WHERE T.TerritoryDescription IN ('New York', 'Seattle', 'Vermont', 'Columbia', 'Los Angeles', 'Redmond', 'Atlanta')
GROUP BY FirstName, LastName, HomePhone

-- 3.	Número de productos de cada categoría y nombre de la categoría.
SELECT COUNT(P.ProductID) AS [Numero de productos] , C.CategoryName
FROM Products AS P
INNER JOIN Categories AS C
ON P.CategoryID = C.CategoryID
GROUP BY C.CategoryName

-- 4.	Nombre de la compañía de todos los clientes que hayan comprado queso de cabrales o tofu.
SELECT C.CompanyName, P.ProductName
FROM Customers AS C
INNER JOIN Orders AS O ON C.CustomerID = O.CustomerID
INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
INNER JOIN Products AS P ON OD.ProductID = P.ProductID
WHERE P.ProductName IN ('Tofu', 'Queso Cabrales')

-- 5.	Empleados (ID, nombre, apellidos y teléfono) que han vendido algo a Bon app' o Meter Franken.
SELECT E.EmployeeID, E.FirstName, E.LastName, E.HomePhone
FROM Employees AS E
INNER JOIN Orders AS O
ON E.EmployeeID = O.EmployeeID
INNER JOIN Customers AS C
ON O.CustomerID = C.CustomerID
WHERE C.CompanyName LIKE 'bon%' OR C.CompanyName LIKE 'Meter Franken'

-- 6.	Empleados (ID, nombre, apellidos, mes y día de su cumpleaños)
-- que no han vendido nunca nada a ningún cliente de Francia.
SELECT E.EmployeeID, E.LastName, E.LastName, MONTH(E.BirthDate) AS MES, DAY(E.BirthDate) AS DIA
FROM Employees AS E
INNER JOIN Orders AS O
ON E.EmployeeID = O.EmployeeID
INNER JOIN Customers AS C
ON O.CustomerID = C.CustomerID
WHERE C.Country NOT LIKE 'France'

-- 7.	Total de ventas en US$ de productos de cada categoría (nombre de la categoría).
SELECT SUM(OD.Quantity * OD.UnitPrice) AS [Total de ventas de productos de cada categoria], P.CategoryID
FROM Products AS P
INNER JOIN [Order Details] AS OD
ON P.ProductID = OD.ProductID
INNER JOIN Orders AS O
ON OD.OrderID = O.OrderID
GROUP BY P.CategoryID

-- 8.	Total de ventas en US$ de cada empleado cada año (nombre, apellidos, dirección).
SELECT SUM(OD.Quantity * OD.UnitPrice) AS [Total de ventas de productos de cada Empleado], E.EmployeeID
FROM Products AS P
INNER JOIN [Order Details] AS OD
ON P.ProductID = OD.ProductID
INNER JOIN Orders AS O
ON OD.OrderID = O.OrderID
INNER JOIN Employees AS E
ON O.EmployeeID = E.EmployeeID
GROUP BY E.EmployeeID

-- 9.	Ventas de cada producto en el año 97. Nombre del producto y unidades.
SELECT P.ProductName, SUM(OD.Quantity) AS Unidades
FROM Products AS P
INNER JOIN [Order Details] AS OD
ON P.ProductID = OD.ProductID
INNER JOIN Orders AS O
ON OD.OrderID = O.OrderID
WHERE YEAR(O.OrderDate) = '1997'
GROUP BY P.ProductName, O.OrderDate

-- 10.	Cuál es el producto del que hemos vendido más unidades en cada país.
SELECT P.ProductName AS UnidadesVendidas, MAX(OD.Quantity), O.ShipCountry
FROM [Order Details] AS OD
INNER JOIN Orders AS O
ON O.OrderID=OD.OrderID
INNER JOIN Products AS P 
On P.ProductID=OD.ProductID
WHERE Quantity IN 
(
  SELECT SUM(Quantity) FROM [Order Details]
  GROUP BY Quantity
)
Group By O.ShipCountry, P.ProductName

-- 11.	Empleados (nombre y apellidos) que trabajan a las órdenes de Andrew Fuller.
SELECT * FROM Employees
-- 12.	Número de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. Nombre, apellidos, ID.
