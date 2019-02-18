USE Northwind
SELECT * FROM Products
SELECT * FROM Customers
SELECT * FROM Orders
--1. Nombre de los proveedores y número de productos que nos vende cada uno
SELECT S.ContactName, COUNT(P.ProductID) AS ProductsNumber FROM Products AS P
INNER JOIN Suppliers AS S ON S.SupplierID = P.SupplierID
GROUP BY S.ContactName

--2. Nombre completo y telefono de los vendedores que trabajen en New York, Seattle, Vermont, 
--Columbia, Los Angeles, Redmond o Atlanta.
SELECT DISTINCT E.FirstName, E.LastName, E.HomePhone FROM Employees AS E
INNER JOIN EmployeeTerritories AS ET ON ET.EmployeeID = E.EmployeeID
INNER JOIN Territories AS T ON T.TerritoryID = ET.TerritoryID
WHERE T.TerritoryDescription IN('New York', 'Seattle', 'Vermont', 'Columbia', 'Los Angeles', 'Redmond' , 'Atlanta')

--3. Número de productos de cada categoría y nombre de la categoría.
SELECT COUNT(P.ProductID) AS ProductsNumber,C.CategoryName FROM Products AS P
INNER JOIN Categories AS C ON C.CategoryID = P.CategoryID
GROUP BY C.CategoryName

--4. Nombre de la compañía de todos los clientes que hayan comprado queso de cabrales o tofu.
SELECT C.CompanyName FROM Customers AS C
INNER JOIN Orders AS O ON O.CustomerID = C.CustomerID
INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
INNER JOIN Products AS P ON OD.ProductID = P.ProductID
WHERE P.ProductName LIKE('%Cabrales%') OR P.ProductName LIKE('%Tofu%')

--5. Empleados (ID, nombre, apellidos y teléfono) que han vendido algo a Bon app' o Meter Franken.
SELECT E.EmployeeID, E.FirstName, E.LastName, E.HomePhone FROM Employees AS E
INNER JOIN Orders AS O ON O.EmployeeID = E.EmployeeID
INNER JOIN Customers AS C ON C.CustomerID = O.CustomerID
WHERE C.CompanyName IN('Bon app''', 'Meter Franken')

--6. Empleados (ID, nombre, apellidos, mes y día de su cumpleaños) que no 
--han vendido nunca nada a ningún cliente de Francia.
--No esta correcto porque no sale ninguna fila, pero creo que es correcto el planteamiento
SELECT E.EmployeeID, E.FirstName, E.LastName, MONTH(E.BirthDate) AS Month, DAY(E.BirthDate) AS Day FROM Employees AS E
EXCEPT
SELECT E.EmployeeID, E.FirstName, E.LastName, MONTH(E.BirthDate) AS Month, DAY(E.BirthDate) AS Day FROM Employees AS E
INNER JOIN Orders AS O ON O.EmployeeID = E.EmployeeID
WHERE O.ShipCountry = 'France'

--7. Total de ventas en US$ de productos de cada categoría (nombre de la categoría).
--Esto seria el total de ventas por categoria
SELECT C.CategoryID, SUM(OD.Quantity * OD.UnitPrice) AS Price FROM Orders AS O
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
INNER JOIN Categories AS C ON C.CategoryID = P.CategoryID
GROUP BY C.CategoryID
ORDER BY C.CategoryID ASC

--Por productos
SELECT C.CategoryID, P.ProductID, SUM(OD.Quantity * OD.UnitPrice) AS Price FROM Orders AS O
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
INNER JOIN Categories AS C ON C.CategoryID = P.CategoryID
GROUP BY C.CategoryID, P.ProductID
ORDER BY C.CategoryID, P.ProductID ASC

--8. Total de ventas en US$ de cada empleado cada año (nombre, apellidos, dirección).
SELECT E.EmployeeID, E.FirstName, E.LastName, E.Address,SUM(OD.Quantity * OD.UnitPrice) AS TotalPrice, YEAR(O.OrderDate) AS Year FROM Employees AS E
INNER JOIN Orders AS O ON O.EmployeeID = E.EmployeeID
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
GROUP BY E.EmployeeID, E.FirstName, E.LastName, E.Address, YEAR(O.OrderDate)

--9. Ventas de cada producto en el año 97. Nombre del producto y unidades.
SELECT P.ProductName, OD.Quantity, SUM(OD.UnitPrice * OD.Quantity) AS TotalPrice FROM Orders AS O
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
WHERE YEAR(O.OrderDate) = 1997
GROUP BY P.ProductName, OD.Quantity

--10. Cuál es el producto del que hemos vendido más unidades en cada país. *

--11. Empleados (nombre y apellidos) que trabajan a las órdenes de Andrew Fuller.
SELECT Sub.FirstName, Sub.LastName FROM Employees AS Boss
INNER JOIN Employees AS Sub ON Sub.ReportsTo = Boss.EmployeeID
WHERE Boss.FirstName = 'Andrew' AND Boss.LastName = 'Fuller'

--12. Número de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. 
--Nombre, apellidos, ID.
SELECT Boss.FirstName, Boss.LastName, Boss.EmployeeID, COUNT(Sub.EmployeeID) AS EmployeesNumber FROM Employees AS Boss
LEFT JOIN Employees AS Sub ON Sub.ReportsTo = Boss.EmployeeID
GROUP BY Boss.FirstName, Boss.LastName, Boss.EmployeeID
