--Escribe las siguientes consultas sobre la base de datos NorthWind.
USE Northwind

--1-Nombre de los proveedores y número de productos que nos vende cada uno
SELECT 
	S.CompanyName
	,Count(*) As Productos
FROM Products AS P
	JOIN Suppliers AS S
	ON P.SupplierID = S.SupplierID
GROUP BY
	S.CompanyName

--2-Nombre completo y telefono de los vendedores que trabajen en New York, Seattle, Vermont, Columbia, Los Angeles, Redmond o Atlanta.


--3-Número de productos de cada categoría y nombre de la categoría.
SELECT 
	COUNT(*) AS n
	,C.CategoryName
FROM
	Products AS P
	JOIN Categories AS C
	ON p.CategoryID = C.CategoryID
GROUP BY C.CategoryName

--4-Nombre de la compañía de todos los clientes que hayan comprado queso de cabrales o tofu.
SELECT 
	C.CompanyName
FROM 
	Customers AS C
	JOIN Orders AS O
	ON C.CustomerID = O.CustomerID
	JOIN [Order Details] AS OD
	ON O.OrderID = OD.OrderID
	JOIN Products AS P
	ON OD.ProductID = P.ProductID
WHERE
	ProductName IN ('Queso Cabrales','Tofu')
	
--5-Empleados (ID, nombre, apellidos y teléfono) que han vendido algo a Bon app' o Meter Franken.
SELECT 
	E.FirstName
	,E.LastName
FROM 
	Customers AS C
	JOIN Orders AS O
	ON C.CustomerID = O.CustomerID
	JOIN Employees AS E
	ON O.EmployeeID = E.EmployeeID
WHERE
	C.CompanyName IN ('Bon app''','Meter Franken')
GROUP BY
	e.FirstName, E.LastName

--6-Empleados (ID, nombre, apellidos, mes y día de su cumpleaños) que no han vendido nunca nada a ningún cliente de Francia. *
SELECT
	EmployeeID
FROM
	Employees 

Except

SELECT
	E.EmployeeID
FROM
	Employees AS E
	JOIN Orders AS O
	ON E.EmployeeID = O.EmployeeID
	JOIN Customers AS C
	ON O.CustomerID = C.CustomerID
WHERE 
	C.Country LIKE ('France')
GROUP BY 
	E.EmployeeID

--7-Total de ventas en US$ de productos de cada categoría (nombre de la categoría).


--8-Total de ventas en US$ de cada empleado cada año (nombre, apellidos, dirección).


--9-Ventas de cada producto en el año 97. Nombre del producto y unidades.


--10-Cuál es el producto del que hemos vendido más unidades en cada país. *
SELECT P.ProductName AS Nombre, MAX(OD.Quantity) AS cantidad, O.ShipCountry
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


--11-Empleados (nombre y apellidos) que trabajan a las órdenes de Andrew Fuller.
SELECT
	EE.FirstName
	,EE.LastName
FROM
	Employees AS E
	JOIN Employees AS EE
	ON E.EmployeeID=EE.ReportsTo
WHERE
	E.FirstName = 'Andrew' AND E.LastName = 'Fuller'

--12-Número de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. Nombre, apellidos, ID.
SELECT 
	E.FirstName
	--,E.LastName
	,COUNT(EE.FirstName)
FROM
	Employees AS E
	JOIN Employees AS EE
	ON E.EmployeeID=EE.ReportsTo
GROUP BY 
	E.FirstName
