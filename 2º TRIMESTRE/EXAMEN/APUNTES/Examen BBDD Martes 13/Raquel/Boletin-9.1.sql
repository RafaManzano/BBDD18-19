USE Northwind
GO

--1.Nombre de los proveedores y número de productos que nos vende cada uno--
SELECT * FROM Suppliers
SELECT * FROM Products

SELECT S.CompanyName, COUNT(*) AS NumberOfProducts
FROM Suppliers AS S
INNER JOIN Products AS P
ON S.SupplierID=P.SupplierID
GROUP BY S.CompanyName

--2.Nombre completo y telefono de los vendedores que trabajen en New York, 
--Seattle, Vermont, Columbia, Los Angeles, Redmond o Atlanta.--
SELECT * FROM Employees

SELECT FirstName,LastName, HomePhone
FROM Employees
WHERE City in ('New York', 'Seattle', 'Vermont', 'Columbia', 'Los Angeles', 'Redmond' , 'Atlanta')

--3.Número de productos de cada categoría y nombre de la categoría.--
SELECT * FROM Categories
SELECT * FROM Products

SELECT C.CategoryName, COUNT(P.ProductID) AS NumberOfProducts
FROM Categories AS C
INNER JOIN Products AS P
ON C.CategoryID=P.CategoryID
GROUP BY CategoryName

--4.Nombre de la compañía de todos los clientes que hayan comprado queso de cabrales o tofu.--
SELECT * FROM Customers
SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT * FROM Products

SELECT C.CompanyName
FROM Customers AS C
INNER JOIN Orders AS O
ON C.CustomerID=O.CustomerID
INNER JOIN [Order Details] AS OD
ON O.OrderID=OD.OrderID
INNER JOIN Products AS P
ON P.ProductID=OD.ProductID
WHERE P.ProductName LIKE 'Cabrales' OR P.ProductName LIKE 'Tofu'

--5.Empleados (ID, nombre, apellidos y teléfono) que han vendido algo a Bon app' o Meter Franken'.--
SELECT * FROM Employees
SELECT * FROM Orders
SELECT * FROM Customers

SELECT E.EmployeeID, E.FirstName, E.LastName, E.HomePhone, C.CompanyName
FROM Employees as E
INNER JOIN Orders AS O
ON E.EmployeeID=O.EmployeeID
INNER JOIN Customers AS C
ON C.CustomerID=O.CustomerID
WHERE C.CompanyName LIKE 'Bon app_' OR C.CompanyName LIKE 'Meter Franken'

--6.Empleados (ID, nombre, apellidos, mes y día de su cumpleaños) que no han vendido nunca nada --
--a ningún cliente de Francia. Se necesitan subconsultas --
SELECT * FROM Employees
SELECT * FROM Orders
SELECT * FROM Customers

SELECT E.EmployeeID, E.FirstName, E.LastName, DAY(E.BirthDate) AS Day, MONTH(E.BirthDate) AS Month
FROM Employees as E
INNER JOIN Orders AS O
ON E.EmployeeID=O.EmployeeID
INNER JOIN Customers AS C
ON C.CustomerID=O.CustomerID
WHERE O.ShipCountry NOT LIKE 'France'

--7.Total de ventas en US$ de productos de cada categoría (nombre de la categoría).--


--8.Total de ventas en US$ de cada empleado cada año (nombre, apellidos, dirección).--


--9.Ventas de cada producto en el año 97. Nombre del producto y unidades.--


--10.Cuál es el producto del que hemos vendido más unidades en cada país. Se necesitan subconsultas --


--11.Empleados (nombre y apellidos) que trabajan a las órdenes de Andrew Fuller.--


--12.Número de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. Nombre,--
-- apellidos, ID.--

