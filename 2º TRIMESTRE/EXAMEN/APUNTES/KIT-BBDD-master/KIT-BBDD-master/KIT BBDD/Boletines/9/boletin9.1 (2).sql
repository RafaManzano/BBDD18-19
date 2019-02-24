USE Northwind
SELECT * FROM Categories
--Escribe las siguientes consultas sobre la base de datos NorthWind.
--Pon el enunciado como comentario junta a cada una
--Nombre de los proveedores y número de productos que nos vende cada uno

SELECT
	S.CompanyName AS Nombre,
	Count(P.ProductID) AS Numero
FROM Suppliers AS S
INNER JOIN Products AS P
	ON S.SupplierID = P.SupplierID
GROUP BY  CompanyName

--Nombre completo y telefono de los vendedores que trabajen en New York, Seattle, Vermont, Columbia, Los Angeles, Redmond o Atlanta.

SELECT 
	LastName, 
	FirstName, 
	HomePhone, 
	ShipCity 
FROM Employees As emp 
INNER JOIN Orders as ord 
ON emp.EmployeeID = ord.EmployeeID 
WHERE ShipCity IN ('New York', 'Seattle', 'Vermont', 'Columbia', 'Los Angeles', 'Redmond' ,'Atlanta')

--Número de productos de cada categoría y nombre de la categoría.

SELECT 
	COUNT(CategoryName) as numero, 
	c.CategoryName as numero 
FROM Products as p 
LEFT JOIN Categories as c 
ON  p.CategoryID = c.CategoryID 
Group by p.CategoryID, c.CategoryName

--Nombre de la compañía de todos los clientes que hayan comprado queso de cabrales o tofu.

SELECT 
	CompanyName, 
	ContactName 
FROM Customers 
INNER JOIN Orders 
ON Customers.CustomerID=Orders.CustomerID 
INNER JOIN [Order Details] 
ON Orders.OrderID=[Order Details].OrderID 
INNER JOIN Products 
ON [Order Details].ProductID=Products.ProductID
Where Products.ProductName IN ('Queso Cabrales','Tofu') 

--Empleados (ID, nombre, apellidos y teléfono) que han vendido algo a Bon app' o Meter Franken.

SELECT
	FirstName, 
	LastName, 
	Phone, 
	Empleados.EmployeeID 
FROM Employees as Empleados 
INNER JOIN Orders as Pedido 
ON Empleados.EmployeeID=Pedido.EmployeeID 
INNER JOIN Customers as Cliente 
ON Pedido.CustomerID=Cliente.CustomerID 
Where Cliente.CompanyName IN ('Bon app''','Meter Franken')

--Empleados (ID, nombre, apellidos, mes y día de su cumpleaños) que no han vendido nunca nada a ningún cliente de Francia. *

SELECT
	E.EmployeeID AS ID,
	E.FirstName AS Nombre,
	E.LastName AS Apellidos,
    Month(BirthDate) AS MesCumple,
	Day(BirthDate) AS DiaCumple
	
FROM Employees as E
INNER JOIN Orders as O
	ON E.EmployeeID=O.EmployeeID
WHERE O.ShipCountry LIKE 'France' 
GROUP BY E.EmployeeID, E.FirstName, E.LastName, Month(BirthDate), Day(BirthDate)

--Total de ventas en US$ de productos de cada categoría (nombre de la categoría).
--Total de ventas en US$ de cada empleado cada año (nombre, apellidos, dirección).
--Ventas de cada producto en el año 97. Nombre del producto y unidades.
--Cuál es el producto del que hemos vendido más unidades en cada país. *
--Empleados (nombre y apellidos) que trabajan a las órdenes de Andrew Fuller.



--Número de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. Nombre, apellidos, ID.