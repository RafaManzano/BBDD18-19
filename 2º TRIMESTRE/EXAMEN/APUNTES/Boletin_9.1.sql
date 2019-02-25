USE Northwind
GO

--Escribe las siguientes consultas sobre la base de datos NorthWind.

--1.Nombre de los proveedores y número de productos que nos vende cada uno
SELECT S.CompanyName, COUNT(P.ProductID) AS CANTIDAD_PRODUCTOS
FROM Suppliers AS S
INNER JOIN Products AS P
ON P.SupplierID = S.SupplierID
GROUP BY S.CompanyName

--2.Nombre completo y telefono de los vendedores que trabajen en New York, Seattle, Vermont, Columbia, Los Angeles, Redmond o Atlanta.
SELECT distinct E.FirstName, E.LastName, E.HomePhone
FROM Employees AS E
INNER JOIN Orders AS O
ON E.EmployeeID = O.EmployeeID
WHERE O.ShipCity NOT IN ('New York', 'Seattle', 'Vermont','Columbia', 'Los Angeles', 'Redmond', 'Atlanta')

--3.Número de productos de cada categoría y nombre de la categoría.
SELECT COUNT(P.ProductID) AS CANTIDAD_PRODUCTOS, C.CategoryName
FROM Products AS P
INNER JOIN Categories AS C
ON P.CategoryID = C.CategoryID
GROUP BY C.CategoryName

--4.Nombre de la compañía de todos los clientes que hayan comprado queso de cabrales o tofu.

SELECT distinct C.CompanyName	--, P.ProductName
FROM Customers AS C
INNER JOIN Orders AS O
ON O.CustomerID = C.CustomerID
INNER JOIN [Order Details] AS OD
ON OD.OrderID = O.OrderID
INNER JOIN Products AS P
ON P.ProductID = OD.ProductID
WHERE P.ProductName IN ('queso cabrales', 'tofu')


--SELECT ProductName FROM Products


--5.Empleados (ID, nombre, apellidos y teléfono) que han vendido algo a Bon app' o Meter Franken.

SELECT distinct E.EmployeeID, E.FirstName, E.LastName, E.HomePhone--, c.CompanyName
FROM Employees AS E
INNER JOIN Orders AS O
ON O.EmployeeID = E.EmployeeID
INNER JOIN Customers AS C
ON O.CustomerID = C.CustomerID
WHERE C.CompanyName IN ('Bon app''', 'Meter Franken')


--6.Empleados (ID, nombre, apellidos, mes y día de su cumpleaños) que no han vendido nunca nada a ningún cliente de Francia. *

--* Se necesitan subconsultas

--7.Total de ventas en US$ de productos de cada categoría (nombre de la categoría).

SELECT SUM( (O.UnitPrice * O.Quantity ) ) AS DINERO_TOTAL, C.CategoryName
FROM Products AS P
INNER JOIN Categories AS C
ON C.CategoryID = P.CategoryID
INNER JOIN [Order Details] AS O
ON O.ProductID = P.ProductID
GROUP BY C.CategoryName

--8.Total de ventas en US$ de cada empleado cada año (nombre, apellidos, dirección).
SELECT E.FirstName, E.LastName, E.Address ,SUM( ( OD.UnitPrice * OD.Quantity ) ) AS TOTAL_VENTAS
FROM Employees AS E
INNER JOIN Orders AS O
ON O.EmployeeID = E.EmployeeID
INNER JOIN [Order Details] AS OD
ON OD.OrderID = O.OrderID
GROUP BY E.LastName, E.FirstName, E.Address

--9.Ventas de cada producto en el año 97. Nombre del producto y unidades.
SELECT P.ProductName, COUNT(*) AS UNIDADES
FROM Products AS P
INNER JOIN [Order Details] AS OD
ON OD.ProductID = P.ProductID
INNER JOIN Orders AS O
ON O.OrderID = OD.OrderID
WHERE YEAR(O.OrderDate) = 1997
GROUP BY P.ProductName

--10.Cuál es el producto del que hemos vendido más unidades en cada país. *


--* Se necesitan subconsultas

--11.Empleados (nombre y apellidos) que trabajan a las órdenes de Andrew Fuller.


SELECT SUB.FirstName, SUB.LastName
FROM Employees AS SUB
INNER JOIN Employees AS BOSS
ON BOSS.EmployeeID = SUB.ReportsTo
WHERE BOSS.FirstName = 'ANDREW' AND BOSS.LastName = 'FULLER'

--CORREGIDA POR LEO

		--reports to es rendir cuentas a (un superior)

--12.Número de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. Nombre, apellidos, ID.
--ESTA ESTA MAL

SELECT  BOSS.FirstName AS NOMBRE_DEL_JEFE, BOSS.LastName AS APELLIDO_DEL_JEFE, COUNT (SUB.EmployeeID) AS CANTIDAD_SUBS
FROM Employees AS SUB
INNER JOIN Employees AS BOSS
ON BOSS.EmployeeID = SUB.ReportsTo
GROUP BY BOSS.LastName, BOSS.FirstName

