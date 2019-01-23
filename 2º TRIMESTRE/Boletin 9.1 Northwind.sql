USE Northwind

--1. Nombre de los proveedores y número de productos que nos vende cada uno
SELECT S.ContactName, COUNT(P.ProductID) AS ProductsNumber FROM Suppliers AS S
INNER JOIN Products AS P ON S.SupplierID = P.SupplierID
GROUP BY S.ContactName

--2. Nombre completo y telefono de los vendedores que trabajen en New York, Seattle, Vermont, 
--Columbia, Los Angeles, Redmond o Atlanta.
SELECT E.FirstName, E.LastName, E.HomePhone FROM Employees AS E
INNER JOIN EmployeeTerritories AS ET ON ET.EmployeeID = E.EmployeeID
INNER JOIN Territories AS T ON T.TerritoryID = ET.TerritoryID
WHERE T.TerritoryDescription IN('New York', 'Seattle', 'Vermont', 'Columbia', 'Los Angeles', 'Redmond' , 'Atlanta')

--3. Número de productos de cada categoría y nombre de la categoría.
SELECT C.CategoryName, COUNT(P.ProductID) AS ProductsNumber FROM Products AS P
INNER JOIN Categories AS C ON C.CategoryID = P.CategoryID
GROUP BY C.CategoryName

--4. Nombre de la compañía de todos los clientes que hayan comprado queso de cabrales o tofu.
SELECT C.CompanyName, COUNT(C.CustomerID) AS Customers FROM Customers AS C 
INNER JOIN Orders AS O ON C.CustomerID = O.CustomerID
INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
WHERE P.ProductName IN('Queso Cabrales', 'Tofu')
GROUP BY C.CompanyName

--5. Empleados (ID, nombre, apellidos y teléfono) que han vendido algo a Bon app' o Meter Franken.
SELECT E.FirstName, E.LastName, E.HomePhone FROM Employees AS E
INNER JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
WHERE O.ShipName IN('Bon app''', ('Meter Franken'))

--6. Empleados (ID, nombre, apellidos, mes y día de su cumpleaños) que no han vendido nunca nada a ningún cliente de Francia. *

--7. Total de ventas en US$ de productos de cada categoría (nombre de la categoría).
SELECT C.CategoryID, C.CategoryName, SUM(OD.UnitPrice * OD.Quantity) AS Total  FROM Products AS P 
INNER JOIN Categories AS C ON C.CategoryID = P.CategoryID
INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
GROUP BY C.CategoryName, C.CategoryID