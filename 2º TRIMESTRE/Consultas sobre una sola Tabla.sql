--1.Nombre de la compa��a y direcci�n completa (direcci�n, cuidad, pa�s) de todos los
--clientes que no sean de los Estados Unidos.
USE Northwind

SELECT * FROM Customers

SELECT CompanyName, Address, City, Country FROM Customers
	WHERE Country <> 'USA'

--2. La consulta anterior ordenada por pa�s y ciudad.
SELECT CompanyName, Address, City, Country FROM Customers
	WHERE Country <> 'USA'
	ORDER BY Country, City

--3. Nombre, Apellidos, Ciudad y Edad de todos los empleados, ordenados por antig�edad en
--la empresa.
SELECT * FROM Employees

SELECT FirstName, LastName, City, YEAR((CURRENT_TIMESTAMP - BirthDate)) - 1900 AS Age, HireDate FROM Employees
	ORDER BY HireDate ASC

--4. Nombre y precio de cada producto, ordenado de mayor a menor precio.
SELECT * FROM Products

SELECT ProductName, UnitPrice FROM Products
	ORDER BY UnitPrice DESC

--5. Nombre de la compa��a y direcci�n completa de cada proveedor de alg�n pa�s de
--Am�rica del Norte.
SELECT * FROM Suppliers

SELECT CompanyName, Address, City, Country FROM Suppliers
	WHERE Country = 'USA' OR Country = 'Canada'

--6. Nombre del producto, n�mero de unidades en stock y valor total del stock, de los
--productos que no sean de la categor�a 4.
SELECT * FROM Products

SELECT ProductName, UnitsInStock, (UnitPrice * UnitsInStock) AS TotalPrize FROM Products
	WHERE CategoryID <> 4

--7. Clientes (Nombre de la Compa��a, direcci�n completa, persona de contacto) que no
--residan en un pa�s de Am�rica del Norte y que la persona de contacto no sea el
--propietario de la compa��a
SELECT * FROM Customers

SELECT CompanyName, Address, City, Country, ContactName FROM Customers
	WHERE Country <> 'USA' AND Country <> 'Canada' AND ContactTitle <> 'Owner'

--8. ID del cliente y n�mero de pedidos realizados por cada cliente, ordenado de mayor a
--menor n�mero de pedidos.
SELECT * FROM Orders

SELECT CustomerID, COUNT(*) AS NumberOfOrder FROM Orders
	GROUP BY CustomerID
	ORDER BY NumberOfOrder DESC

--9. N�mero de pedidos enviados a cada ciudad, incluyendo el nombre de la ciudad.
SELECT * FROM Orders

SELECT COUNT(*) AS NumberOfOrder, ShipCity, ShipCountry FROM Orders
	GROUP BY ShipCity, ShipCountry

--10. N�mero de productos de cada categor�a.
SELECT * FROM Products

SELECT CategoryID, COUNT(*) AS NumberOfProducts FROM Products
	GROUP BY CategoryID