USE Northwind-- 1. Nombre de la compañía y dirección completa (dirección, cuidad, país) de todos los  clientes que no sean de los Estados Unidos.
SELECT CompanyName, Address, City, Country FROM Customers WHERE Country NOT LIKE 'USA'

-- 2. La consulta anterior ordenada por país y ciudad.
SELECT CompanyName, Address, Country, City FROM Customers WHERE Country NOT LIKE 'USA' ORDER BY Country, City

-- 3. Nombre, Apellidos, Ciudad y Edad de todos los empleados, ordenados por antigüedad en la empresa
SELECT FirstName, LastName, City, Year(CURRENT_TIMESTAMP - BirthDate)-1900 as Year FROM Employees ORDER BY HireDate ASC

-- 4. Nombre y precio de cada producto, ordenado de mayor a menor precio.*/
SELECT ProductName, UnitPrice FROM Products ORDER BY UnitPrice DESC

-- 5.- Nombre de la compañía y dirección completa de cada proveedor de algún país de América del Norte.*/
SELECT CompanyName, Region, City, Address FROM Suppliers WHERE Country LIKE 'USA'

-- 6. Nombre del producto, número de unidades en stock y valor total del stock, de los productos que no sean de la categoría 4.*/
SELECT ProductName, UnitsInStock, UnitsOnOrder FROM Products WHERE CategoryID!=4

-- 7. Clientes (Nombre de la Compañía, dirección completa, persona de contacto) que no residan en un país de América del Norte y que la persona de contacto no sea el propietario de la compañía
SELECT CompanyName, Address, ContactName FROM Customers WHERE ContactTitle LIKE 'OWNER' AND Country NOT LIKE 'USA'

-- 8.- ID del cliente y número de pedidos realizados por cada cliente, ordenado de mayor a menor número de pedidos.