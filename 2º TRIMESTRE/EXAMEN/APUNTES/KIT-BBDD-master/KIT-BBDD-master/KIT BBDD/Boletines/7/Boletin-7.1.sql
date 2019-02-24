USE Northwind
GO

Set Dateformat 'YMD'

--De la 1 a la 7 se pueden hacer sin usar funciones de agregados. 

--1. Nombre de la compañía y dirección completa (dirección, ciudad, país) de todos los clientes que no
--sean de los Estados Unidos.

SELECT CompanyName,ContactName,ContactTitle,Address,City,Country
FROM Customers
WHERE Country!='USA'

--2. La consulta anterior ordenada por país y ciudad.
SELECT CompanyName,ContactName,ContactTitle,Address,City,Country
FROM Customers
WHERE Country!='USA'
ORDER BY 'COUNTRY','CITY' 

--3. Nombre, Apellidos, Ciudad y Edad de todos los empleados, ordenados por antigüedad en la empresa.
SELECT * FROM Employees

SELECT LastName,FirstName, City,YEAR(Current_Timestamp) - YEAR(BirthDate) as Age
FROM Employees
ORDER BY HireDate


--4. Nombre y precio de cada producto, ordenado de mayor a menor precio.
SELECT ProductName, UnitPrice 
FROM Products
ORDER BY UnitPrice desc

--5. Nombre de la compañía y dirección completa de cada proveedor de algún país de América del Norte.
SELECT CompanyName, Address, City, Country
FROM Suppliers
WHERE Country IN ('USA','Canada','Mexico')

--6. Nombre del producto, número de unidades en stock y valor total del stock, de los productos que no
--sean de la categoría 4.
SELECT ProductName, UnitsInStock, UnitPrice * UnitsInStock AS TotalValor
FROM Products
WHERE CategoryID!='4'
--WHERE CategoryID <> 4

--7. Clientes (Nombre de la Compañía, dirección completa, persona de contacto) que no residan en un 
--país de América del Norte y que la persona de contacto no sea el propietario de la compañía
SELECT CompanyName, Address, City, Country, ContactTitle
FROM Customers
WHERE Country NOT IN ('USA','Canada','Mexico') AND ContactTitle!='Owner'

--8. ID del cliente y número de pedidos realizados por cada cliente, ordenado de mayor a menor número
--de pedidos.
SELECT CustomerID, COUNT (CustomerID) AS NumberOrders
--SELECT CustomerID, COUNT (*) AS NumberOrders
FROM Orders
GROUP BY CustomerID
ORDER BY NumberOrders DESC

--9. Número de pedidos enviados a cada ciudad, incluyendo el nombre de la ciudad.
SELECT ShipCity, COUNT(ShipCity) AS NumberShipCity
--SELECT ShipCity, COUNT(*) AS NumberShipCity
FROM Orders
GROUP BY ShipCity

--10. Número de productos de cada categoría. 
SELECT CategoryID, COUNT(CategoryID) AS NumberCategoryID
--SELECT CategoryID, COUNT(*) AS NumberCategoryID
FROM Products
GROUP BY CategoryID
