USE Northwind
go

--1. Nombre de la compa��a y direcci�n completa (direcci�n, cuidad, pa�s) de todos los
--clientes que no sean de los Estados Unidos.
Select CompanyName,Address,City,Country from Customers
where Country<>'USA'
go
--2. La consulta anterior ordenada por pa�s y ciudad.
Select CompanyName,Address,City,Country from Customers
where Country<>'USA' order by Country,City
go
--3. Nombre, Apellidos, Ciudad y Edad de todos los empleados, ordenados por antig�edad en
--la empresa.
Select FirstName,LastName,City,Year(Current_Timestamp-BirthDate)-1900 As Edad from Employees
order by HireDate
go
--4. Nombre y precio de cada producto, ordenado de mayor a menor precio.
Select ProductName,UnitPrice from Products order by UnitPrice desc

--5. Nombre de la compa��a y direcci�n completa de cada proveedor de alg�n pa�s de
--Am�rica del Norte.
Select CompanyName,Address,City,Country from Suppliers
where Country in ('Canada','USA','Mexico')

--6. Nombre del producto, n�mero de unidades en stock y valor total del stock, de los
--productos que no sean de la categor�a 4.

Select ProductName,UnitsInStock,UnitsInStock*UnitPrice as TotalValor from Products
where CategoryID<>4
--7. Clientes (Nombre de la Compa��a, direcci�n completa, persona de contacto) que no
--residan en un pa�s de Am�rica del Norte y que la persona de contacto no sea el
--propietario de la compa��a
Select CustomerID,CompanyName,Address,City,Country,ContactName from Customers
where Country not in ('USA','Canada','Mexico') and ContactTitle<>'Owner'

--8. ID del cliente y n�mero de pedidos realizados por cada cliente, ordenado de mayor a
--menor n�mero de pedidos.
Select CustomerID
	  ,count(*) as [N�mero de pedidos]
From Orders
Group by CustomerID
Order by [N�mero de pedidos] DESC
go

--9. N�mero de pedidos enviados a cada ciudad, incluyendo el nombre de la ciudad.

Select Count(*) as [N�mero de pedidos]
	  ,ShipCity
From Orders
Group By ShipCity
go
--10. N�mero de productos de cada categor�a. 
Select CategoryID
	  ,count(*) as [N�mero de productos]
From Products
Group by CategoryID
go