/*1. Nombre de la compañía y dirección completa (dirección, cuidad, país) de todos los clientes que no sean de los Estados Unidos.*/
SELECT CompanyName,Address,City,Country FROM Customers
	WHERE Country <> 'USA'

/*2. La consulta anterior ordenada por país y ciudad.*/
SELECT CompanyName,Address,Country,City FROM Customers
	WHERE Country <> 'USA'
	ORDER BY Country,City

/*3. Nombre, Apellidos, Ciudad y Edad de todos los empleados, ordenados por antigüedad en la empresa.*/
--SELECT FirstName,LastName,City,(CURRENT_TIMESTAMP) AS Age FROM Employees

/*4. Nombre y precio de cada producto, ordenado de mayor a menor precio.*/
SELECT ProductName,UnitPrice FROM Products
	ORDER BY UnitPrice DESC

/*5. Nombre de la compañía y dirección completa de cada proveedor de algún país de América del Norte.*/
SELECT CompanyName,Address,City,Country FROM Suppliers
	WHERE Country IN ('USA', 'Canada', 'Mexico')

/*6. Nombre del producto, número de unidades en stock y valor total del stock, de los productos que no sean de la categoría 4.*/
SELECT ProductName,UnitsInStock,(UnitsInStock*UnitPrice) AS PriceOfStock FROM Products
	WHERE CategoryID <> 4

/*7. Clientes (Nombre de la Compañía, dirección completa, persona de contacto) que no residan en un país de América del Norte
y que la persona de contacto no sea el propietario de la compañía.*/
SELECT CompanyName, Address, City,Country, ContactName FROM Customers
	WHERE Country <> 'USA' AND ContactTitle <> 'Owner'

/*8. ID del cliente y número de pedidos realizados por cada cliente, ordenado de mayor a menor número de pedidos.*/
SELECT CustomerID, COUNT(OrderID) AS [Número de pedidos] FROM Orders
	GROUP BY CustomerID
	ORDER BY COUNT(OrderID) DESC

/*9. Número de pedidos enviados a cada ciudad, incluyendo el nombre de la ciudad.*/
SELECT COUNT(ShipCity) AS [Número de pedidos], ShipCity FROM Orders
	GROUP BY ShipCity
	ORDER BY ShipCity

/*10. Número de productos de cada categoría.*/
SELECT CategoryID, COUNT(CategoryID) AS [Número de productos] FROM Products
	GROUP BY CategoryID
