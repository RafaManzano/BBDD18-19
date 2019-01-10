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