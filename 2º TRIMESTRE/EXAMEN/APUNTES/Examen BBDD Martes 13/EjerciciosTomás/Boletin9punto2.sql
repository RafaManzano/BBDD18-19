USE Northwind

/*1. Número de clientes de cada país.*/
SELECT COUNT(CustomerID) AS [Número de clientes], Country FROM Customers
	GROUP BY Country

/*2. Número de clientes diferentes que compran cada producto.*/
SELECT COUNT(c.CustomerID) AS [Número de clientes], p.ProductName
	FROM Customers AS c
	INNER JOIN Orders AS o
	ON c.CustomerID = o.CustomerID
	INNER JOIN [Order Details] AS od
	ON o.OrderID = od.OrderID
	INNER JOIN Products AS p
	ON od.ProductID = p.ProductID
		GROUP BY p.ProductName

/*3. Número de países diferentes en los que se vende cada producto.*/
SELECT COUNT(o.ShipCountry) AS [Número de paises], p.ProductName
	FROM Orders AS o
	INNER JOIN [Order Details] AS od
	ON o.OrderID = od.OrderID
	INNER JOIN Products AS p
	ON od.ProductID = p.ProductID
		GROUP BY p.ProductName

/*4. Empleados que han vendido alguna vez “Gudbrandsdalsost”, “Lakkalikööri”, “Tourtière” o “Boston Crab Meat”.*/
SELECT * FROM Employees
SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT * FROM Products

SELECT DISTINCT e.FirstName, e.LastName
	FROM Employees AS e
	INNER JOIN Orders AS o
	ON e.EmployeeID = o.EmployeeID
	INNER JOIN [Order Details] AS od
	ON o.OrderID = od.OrderID
	INNER JOIN Products AS p
	ON od.ProductID = p.ProductID
		WHERE p.ProductName IN ('Gudbrandsdalsost', 'Lakkalikööri', 'Tourtière', 'Boston Crab Meat')

/*5. Empleados que no han vendido nunca “Chartreuse verte” ni “Ravioli Angelo”.*/
--
SELECT * FROM Employees
SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT * FROM Products

SELECT DISTINCT e.FirstName, e.LastName		--Se puede quitar el DISTINCT teniendo el EXCEPT
	FROM Employees AS e
	INNER JOIN Orders AS o
	ON e.EmployeeID = o.EmployeeID
	INNER JOIN [Order Details] AS od
	ON o.OrderID = od.OrderID
	INNER JOIN Products AS p
	ON od.ProductID = p.ProductID

EXCEPT

SELECT DISTINCT e.FirstName, e.LastName		--Se puede quitar el DISTINCT teniendo el EXCEPT
	FROM Employees AS e
	INNER JOIN Orders AS o
	ON e.EmployeeID = o.EmployeeID
	INNER JOIN [Order Details] AS od
	ON o.OrderID = od.OrderID
	INNER JOIN Products AS p
	ON od.ProductID = p.ProductID
		WHERE p.ProductName IN ('Chartreuse verte', 'Ravioli Angelo')

/*6. Número de unidades de cada categoría de producto que ha vendido cada empleado.*/
SELECT * FROM Employees
SELECT * FROM Orders
SELECT * FROM [Order Details]
SELECT * FROM Products
SELECT * FROM Categories

SELECT SUM(od.Quantity) AS [Número de unidades vendidas], c.CategoryName
	FROM Categories AS c
	INNER JOIN Products AS p
	ON c.CategoryID = p.CategoryID
	INNER JOIN [Order Details] AS od
	ON p.ProductID = od.ProductID
	INNER JOIN Orders AS o
	ON od.OrderID = o.OrderID
	INNER JOIN Employees AS e
	ON o.EmployeeID = e.EmployeeID
		GROUP BY c.CategoryName
		

/*7. Total de ventas (US$) de cada categoría en el año 97.*/
SELECT * FROM Categories
SELECT * FROM Products
SELECT * FROM [Order Details]
SELECT * FROM Orders

SELECT CategoryName, SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS [Total de ventas]
	FROM Categories AS c
	INNER JOIN Products AS p
	ON c.CategoryID = p.CategoryID
	INNER JOIN [Order Details] AS od
	ON p.ProductID = od.ProductID
	INNER JOIN Orders AS o
	ON od.OrderID = o.OrderID
		WHERE YEAR(o.OrderDate) = '1997'
		GROUP BY c.CategoryName

/*8. Productos que han comprado más de un cliente del mismo país, indicando
el nombre del producto, el país y el número de clientes distintos de ese país que lo han comprado.*/
SELECT * FROM Products
SELECT * FROM [Order Details]
SELECT * FROM Orders
SELECT * FROM Customers

SELECT p.ProductName, o.ShipCountry, COUNT(c.CustomerID) AS [Número de clientes]
	FROM Products AS p
	INNER JOIN [Order Details] AS od
	ON p.ProductID = od.ProductID
	INNER JOIN Orders AS o
	ON od.OrderID = o.OrderID
	INNER JOIN Customers AS c
	ON o.CustomerID = c.CustomerID
		GROUP BY p.ProductName, o.ShipCountry
		HAVING COUNT(c.CustomerID) > 1			--Utilizamos HAVING porque en CustomerID hemos utilizado un agregado (que tiene un COUNT vamoh)

/*9. Total de ventas (US$) en cada país cada año.*/
SELECT * FROM [Order Details]
SELECT * FROM Orders

SELECT SUM(od.Quantity * od.UnitPrice * (1- od.Discount)) AS [Total de ventas], o.ShipCountry, YEAR(o.OrderDate) AS [Año de venta]
	FROM [Order Details] AS od
	INNER JOIN Orders AS o
	ON od.OrderID = o.OrderID
		GROUP BY o.ShipCountry, YEAR(o.OrderDate)
		ORDER BY o.ShipCountry, YEAR(o.OrderDate) ASC

/*10. Producto superventas de cada año, indicando año, nombre del producto, categoría y cifra total de ventas.*/
SELECT * FROM Categories
SELECT * FROM [Order Details]
SELECT * FROM Orders

--Esta consulta nos da toda la cantidad vendida de cada producto cada año
SELECT p.ProductName, SUM(od.Quantity) AS [Cantidad vendida], YEAR(o.OrderDate) AS [Año]
	FROM Categories AS c
		INNER JOIN Products AS p
		ON c.CategoryID = p.CategoryID
		INNER JOIN [Order Details] AS od
		ON p.ProductID = od.ProductID
		INNER JOIN Orders AS o
		ON od.OrderID = o.OrderID
		GROUP BY p.ProductName, YEAR(o.OrderDate)

/*Esta consulta utiliza la consulta anterior (que tiene una subconsulta vamoh) para poder saber la cantidad máxima
Porque como tenemos que hacer el MAX de un SUM tenemeos que hacerlo con una subconsulta.
No podemos añadir el nombre del producto a la consulta porque nos saldría la máxima cantidad por año de cada elemento y queremos la máxima de cada año.

CONSULTA MAL HECHA PORQUE NOS SEPARA POR NOMBRE TAMBIÉN
SELECT MAX(a.[Cantidad vendida]) AS [Cantidad máxima vendida], a.Año, a.ProductName
	FROM (SELECT p.ProductName, SUM(od.Quantity) AS [Cantidad vendida], YEAR(o.OrderDate) AS [Año], c.CategoryName
			FROM Categories AS c
			INNER JOIN Products AS p
			ON c.CategoryID = p.CategoryID
			INNER JOIN [Order Details] AS od
			ON p.ProductID = od.ProductID
			INNER JOIN Orders AS o
			ON od.OrderID = o.OrderID
				GROUP BY p.ProductName, YEAR(o.OrderDate), c.CategoryName) AS a
	GROUP BY a.Año, a.ProductName*/

/*MISMA CONSULTA PERO SIN EL NOMBRE DEL PRODUCTO*/
SELECT MAX(a.[Cantidad vendida]) AS [Cantidad máxima vendida], a.Año
	FROM (SELECT p.ProductName, SUM(od.Quantity) AS [Cantidad vendida], YEAR(o.OrderDate) AS [Año], c.CategoryName
			FROM Categories AS c
			INNER JOIN Products AS p
			ON c.CategoryID = p.CategoryID
			INNER JOIN [Order Details] AS od
			ON p.ProductID = od.ProductID
			INNER JOIN Orders AS o
			ON od.OrderID = o.OrderID
				GROUP BY p.ProductName, YEAR(o.OrderDate), c.CategoryName) AS a
	GROUP BY a.Año

/*Como en la consulta anterior no pudimos consultar el nombre porque se nos fastidiaba, tenemos que hacer INNER JOIN con otra consulta que si tenga el nombre.
Vamos a consultar la tabla que hicimos antes de utilizar el SUM.
Para eso necesitamos saber que columna utilizaremos para unirlas. (MIRAR EL ON PARA SABER DE QUE HABLO)*/

SELECT paraPorfavor.Año, odioLasSubconsultas.ProductName, odioLasSubconsultas.CategoryName, paraPorfavor.[Cantidad máxima vendida]
	FROM (SELECT MAX(a.[Cantidad vendida]) AS [Cantidad máxima vendida], a.Año
		FROM (SELECT p.ProductName, SUM(od.Quantity) AS [Cantidad vendida], YEAR(o.OrderDate) AS [Año], c.CategoryName
				FROM Categories AS c
				INNER JOIN Products AS p
				ON c.CategoryID = p.CategoryID
				INNER JOIN [Order Details] AS od
				ON p.ProductID = od.ProductID
				INNER JOIN Orders AS o
				ON od.OrderID = o.OrderID
					GROUP BY p.ProductName, YEAR(o.OrderDate), c.CategoryName) AS a
			GROUP BY a.Año) AS [paraPorfavor]

	INNER JOIN (SELECT p.ProductName, SUM(od.Quantity) AS [Cantidad vendida], YEAR(o.OrderDate) AS [Año], c.CategoryName
					FROM Categories AS c
					INNER JOIN Products AS p
					ON c.CategoryID = p.CategoryID
					INNER JOIN [Order Details] AS od
					ON p.ProductID = od.ProductID
					INNER JOIN Orders AS o
					ON od.OrderID = o.OrderID
						GROUP BY p.ProductName, YEAR(o.OrderDate), c.CategoryName) AS [odioLasSubconsultas]

	ON paraPorfavor.[Cantidad máxima vendida] = odioLasSubconsultas.[Cantidad vendida]
	--Utilizando [Cantidad máxima vendida] y [Cantidad vendida] veremos solo donde coinciden la máxima conforme a la tabla con todos los productos
	--que es donde podemos ver el nombre que va asociado a esa cantidad

/*MISMO EJERCICIO PERO CON VISTAS (utilizando el VIEW vamoh)*/
GO
CREATE VIEW [CantidadVendidaPorAñoDeCadaElemento] AS
SELECT p.ProductName, SUM(od.Quantity) AS [Cantidad vendida], YEAR(o.OrderDate) AS [Año]
	FROM Categories AS c
		INNER JOIN Products AS p
		ON c.CategoryID = p.CategoryID
		INNER JOIN [Order Details] AS od
		ON p.ProductID = od.ProductID
		INNER JOIN Orders AS o
		ON od.OrderID = o.OrderID
		GROUP BY p.ProductName, YEAR(o.OrderDate)
GO

GO
CREATE VIEW [MáximaCantidadPorAño] AS
SELECT MAX(a.[Cantidad vendida]) AS [Cantidad máxima vendida], a.Año
	FROM (SELECT p.ProductName, SUM(od.Quantity) AS [Cantidad vendida], YEAR(o.OrderDate) AS [Año], c.CategoryName
			FROM Categories AS c
			INNER JOIN Products AS p
			ON c.CategoryID = p.CategoryID
			INNER JOIN [Order Details] AS od
			ON p.ProductID = od.ProductID
			INNER JOIN Orders AS o
			ON od.OrderID = o.OrderID
				GROUP BY p.ProductName, YEAR(o.OrderDate), c.CategoryName) AS a
	GROUP BY a.Año
GO

SELECT a.ProductName, maxima.[Cantidad máxima vendida], a.Año
	FROM [CantidadVendidaPorAñoDeCadaElemento] AS a
	INNER JOIN [MáximaCantidadPorAño] AS maxima
	ON a.[Cantidad vendida] = maxima.[Cantidad máxima vendida]

/*11. Cifra de ventas de cada producto en el año 97 y su aumento o disminución respecto al año anterior en US $ y en %.*/
SELECT * FROM Products
SELECT * FROM [Order Details]
SELECT * FROM Orders

SELECT SUM(od.Quantity) AS [Cantidad], p.ProductName, YEAR(o.OrderDate) AS [Año]
	FROM Products AS p
	INNER JOIN[Order Details] AS od
	ON p.ProductID = od.ProductID
	INNER JOIN Orders AS o
	ON od.OrderID = o.OrderID
		WHERE YEAR(o.OrderDate) = '1996'
		GROUP BY p.ProductName, YEAR(o.OrderDate)

SELECT SUM(od.Quantity) AS [Cantidad], p.ProductName, YEAR(o.OrderDate) AS [Año]
	FROM Products AS p
	INNER JOIN[Order Details] AS od
	ON p.ProductID = od.ProductID
	INNER JOIN Orders AS o
	ON od.OrderID = o.OrderID
		WHERE YEAR(o.OrderDate) = '1997'
		GROUP BY p.ProductName, YEAR(o.OrderDate)

SELECT [año97].Cantidad97, ([año97].[Dinero97] - [año96].[Dinero96]) AS [Aumento/Decrecimiento]
	FROM (SELECT SUM(od.Quantity) AS [Cantidad96], SUM((od.Quantity * od.UnitPrice) * (1 - od.Discount)) AS [Dinero96], p.ProductName, YEAR(o.OrderDate) AS [Año]
			FROM Products AS p
			INNER JOIN[Order Details] AS od
			ON p.ProductID = od.ProductID
			INNER JOIN Orders AS o
			ON od.OrderID = o.OrderID
				WHERE YEAR(o.OrderDate) = '1996'
				GROUP BY p.ProductName, YEAR(o.OrderDate)) AS [año96]

	INNER JOIN (SELECT SUM(od.Quantity) AS [Cantidad97], SUM((od.Quantity * od.UnitPrice) * (1 - od.Discount)) AS [Dinero97], p.ProductName, YEAR(o.OrderDate) AS [Año]
					FROM Products AS p
					INNER JOIN[Order Details] AS od
					ON p.ProductID = od.ProductID
					INNER JOIN Orders AS o
					ON od.OrderID = o.OrderID
						WHERE YEAR(o.OrderDate) = '1997'
						GROUP BY p.ProductName, YEAR(o.OrderDate)) AS [año97]

	ON [año96].ProductName = [año97].ProductName

/*12. Mejor cliente (el que más nos compra) de cada país.*/
SELECT * FROM Customers
SELECT * FROM Orders
SELECT * FROM [Order Details]

GO
ALTER VIEW ClientesCantidadPais AS
SELECT SUM(od.Quantity) AS [Cantidad comprada], c.CompanyName, o.ShipCountry
	FROM Customers AS c
	INNER JOIN Orders AS o
	ON c.CustomerID = o.CustomerID
	INNER JOIN [Order Details] AS od
	ON o.OrderID = od.OrderID
		GROUP BY c.CompanyName, o.ShipCountry
GO

SELECT MAX(ccp.[Cantidad comprada]) AS [Máxima cantidad comprada], ccp.ShipCountry
	FROM ClientesCantidadPais AS ccp
		GROUP BY ccp.ShipCountry

SELECT MAX(ccp.[Cantidad comprada]) AS [Máxima cantidad comprada], ccp.CompanyName, ccp.ShipCountry
	FROM ClientesCantidadPais AS ccp
		GROUP BY ccp.CompanyName, ccp.ShipCountry

SELECT A.[Máxima cantidad comprada], A.ShipCountry, B.CompanyName
	FROM (SELECT MAX(ccp.[Cantidad comprada]) AS [Máxima cantidad comprada], ccp.ShipCountry
			FROM ClientesCantidadPais AS ccp
				GROUP BY ccp.ShipCountry) AS [A]

	INNER JOIN (SELECT MAX(ccp.[Cantidad comprada]) AS [Máxima cantidad comprada], ccp.CompanyName, ccp.ShipCountry
					FROM ClientesCantidadPais AS ccp
						GROUP BY ccp.CompanyName, ccp.ShipCountry) AS [B]

	ON A.[Máxima cantidad comprada] = B.[Máxima cantidad comprada] AND A.ShipCountry = B.ShipCountry

/*13. Número de productos diferentes que nos compra cada cliente.*/

/*14. Clientes que nos compran más de cinco productos diferentes.*/

/*15. Vendedores que han vendido una mayor cantidad que la media en US $ en el año 97.*/

/*16. Empleados que hayan aumentado su cifra de ventas más de un 10% entre dos años consecutivos, indicando el año en que se produjo el aumento.*/
