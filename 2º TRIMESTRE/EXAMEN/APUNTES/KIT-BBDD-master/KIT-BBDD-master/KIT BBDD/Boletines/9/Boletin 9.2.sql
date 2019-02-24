
--1. Número de clientes de cada país.
Use Northwind
SELECT COUNT(CustomerID) AS [Numero de clientes],Country
	FROM Customers
		GROUP BY Country

--2. Número de clientes diferentes que compran cada producto.
SELECT COUNT(distinct CustomerID) AS [Numero de clientes diferentes],OD.ProductID
	FROM Orders AS O
	INNER JOIN [Order Details] AS [OD] 
		ON O.OrderID = OD.OrderID
			GROUP BY ProductID
		
--3. Número de países diferentes en los que se vende cada producto.
SELECT COUNT(distinct ShipCountry) AS [Numero de paises diferentes],OD.ProductID
	FROM Orders AS O
	INNER JOIN [Order Details] AS [OD] 
		ON O.OrderID = OD.OrderID
			GROUP BY ProductID

--4. Empleados que han vendido alguna vez “Gudbrandsdalsost”, “Lakkalikööri”,
--“Tourtière” o “Boston Crab Meat”.
SELECT  DISTINCT O.EmployeeID
	FROM Orders AS O
	INNER JOIN [Order Details] AS [OD] 
		ON O.OrderID = OD.OrderID
	INNER JOIN Products AS P 
		ON P.ProductID = OD.ProductID
			WHERE P.ProductName IN ('Gudbrandsdalsost','Lakkalikööri','Tourtière','Boston Crab Meat')

--5. Empleados que no han vendido nunca “Chartreuse verte” ni “Ravioli Angelo”.
SELECT  DISTINCT O.EmployeeID
	FROM Orders AS O
	INNER JOIN [Order Details] AS [OD] 
		ON O.OrderID = OD.OrderID
	INNER JOIN Products AS P
		ON P.ProductID = OD.ProductID
			WHERE P.ProductName NOT IN ('Chartreuse verte','Ravioli Angelo')

--6. Número de unidades de cada categoría de producto que ha vendido cada
--empleado.
SELECT COUNT(P.ProductID) AS [Numero de unidades],P.CategoryID,O.EmployeeID
	FROM Products AS P
	INNER JOIN [Order Details] AS [OD]
		ON P.ProductID = OD.ProductID
	INNER JOIN Orders AS O 
		ON O.OrderID = OD.OrderID
			GROUP BY P.CategoryID,O.EmployeeID


--7. Total de ventas (US$) de cada categoría en el año 97.
SELECT P.CategoryID,SUM(OD.Quantity*OD.UnitPrice) AS [Total de ventas]
	FROM Orders AS O
	INNER JOIN [Order Details] AS [OD] 
		ON OD.OrderID = O.OrderID
	INNER JOIN Products AS P 
		ON P.ProductID = OD.ProductID
			WHERE YEAR(O.OrderDate) IN(1997)
				GROUP BY P.CategoryID
					ORDER BY P.CategoryID

--8. Productos que han comprado más de un cliente del mismo país, indicando el
--nombre del producto, el país y el número de clientes distintos de ese país que
--lo han comprado.
SELECT  COUNT(distinct C.CustomerID) AS [Numero de clientes],P.ProductName,C.Country
	FROM Customers AS C
	INNER JOIN Orders AS [O] 
		ON O.CustomerID = C.CustomerID
	INNER JOIN [Order Details] AS [OD] 
		ON OD.OrderID = O.OrderID
	INNER JOIN Products AS P 
		ON P.ProductID = OD.ProductID
			GROUP BY P.ProductName,C.Country


--9. Total de ventas (US$) en cada país cada año.
SELECT SUM(OD.Quantity*OD.UnitPrice) AS [Ventas],ShipCountry,Year(OrderDate) AS [Total de ventas]
	FROM Orders AS O
	INNER JOIN [Order Details] AS [OD] 
		ON OD.OrderID = O.OrderID
			GROUP BY YEAR(OrderDate),ShipCountry


--10. Producto superventas de cada año, indicando año, nombre del producto,
--categoría y cifra total de ventas.
GO
CREATE VIEW [Ventas por año] AS
	SELECT P.ProductName, C.CategoryName, YEAR(O.OrderDate) AS Año, SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Ventas Totales]
			FROM Products AS P
			INNER JOIN [Order Details] AS OD
				ON P.ProductID=OD.ProductID
			INNER JOIN Categories AS C
				ON P.CategoryID=C.CategoryID
			INNER JOIN Orders AS O
				ON OD.OrderID=O.OrderID
					GROUP BY P.ProductName,C.CategoryName,YEAR(O.OrderDate)
GO
	SELECT [Ventas Totales] AS [Maximo],ProductName,CategoryName,VA.Año 
		FROM [Ventas por año] AS VA
		INNER JOIN (
			SELECT MAX([Ventas Totales]) AS [Maximo],Año 
				FROM [Ventas por año]
					GROUP BY Año) AS Max
				ON VA.[Ventas Totales]= MAX.Maximo AND VA.Año = Max.Año
	

--11. Cifra de ventas de cada producto en el año 97 y su aumento o disminución
--respecto al año anterior en US $ y en %.
GO
CREATE VIEW [Ventas 97] AS
SELECT P.ProductName, SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Ventas Totales del 97]
	FROM Products AS P
	INNER JOIN [Order Details] AS OD
		ON P.ProductID=OD.ProductID
	INNER JOIN Orders AS O
		ON OD.OrderID=O.OrderID
			WHERE YEAR(O.OrderDate)=1997
				GROUP BY P.ProductName
GO

CREATE VIEW [Ventas 96] AS
SELECT P.ProductName, SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Ventas Totales del 96]
	FROM Products AS P
	INNER JOIN [Order Details] AS OD
		ON P.ProductID=OD.ProductID
	INNER JOIN Orders AS O
		ON OD.OrderID=O.OrderID
			WHERE YEAR(O.OrderDate)=1996
				GROUP BY P.ProductName
GO

SELECT V97.ProductName,V97.[Ventas Totales del 97],
	  (V97.[Ventas Totales del 97]-V96.[Ventas Totales del 96]) AS [Aumento_Disminucion],
	  (V97.[Ventas Totales del 97]-V96.[Ventas Totales del 96])/V97.[Ventas Totales del 97]*100 AS Porcentaje
	  FROM [Ventas 97] AS V97
	  INNER JOIN [Ventas 96] AS  V96
		ON V97.ProductName=V96.ProductName

--12. Mejor cliente (el que más nos compra) de cada país.
Select C.CustomerID,SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) as [Ventas Totales],O.ShipCountry
	FROM Customers AS C
	INNER JOIN Orders AS O
		ON C.CustomerID=O.CustomerID
	INNER JOIN [Order Details] AS OD
		ON O.OrderID=OD.OrderID
			GROUP BY C.CustomerID,O.ShipCountry
				

---13. Número de productos diferentes que nos compra cada cliente.

Select C.CustomerID, COUNT(P.ProductID) AS [Productos diferentes]
	FROM Customers AS C
	INNER JOIN Orders AS O
		ON C.CustomerID=O.CustomerID
	INNER JOIN [Order Details] AS OD
		ON O.OrderID=OD.OrderID
	INNER JOIN Products AS P
		ON OD.ProductID=P.ProductID
			GROUP BY C.CustomerID

--14. Clientes que nos compran más de cinco productos diferentes.

SELECT C.CustomerID, COUNT(P.ProductID) AS [Productos diferentes]
	FROM Customers AS C
	INNER JOIN Orders AS O
		ON C.CustomerID=O.CustomerID
	INNER JOIN [Order Details] AS OD
		ON O.OrderID=OD.OrderID
	INNER JOIN Products AS P
		ON OD.ProductID=P.ProductID
			GROUP BY C.CustomerID
				HAVING  COUNT(P.ProductName)>5

--15. Vendedores que han vendido una mayor cantidad que la media en US $ en el
--año 97.
SELECT E.EmployeeID AS Empleado,E.FirstName,E.LastName,sum(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Ventas Empleado en 97]
	FROM [Order Details] AS OD
	INNER JOIN Orders AS O
		ON OD.OrderID=O.OrderID
	INNER JOIN Employees AS E
		ON O.EmployeeID=E.EmployeeID
			WHERE YEAR(O.OrderDate)=1997
				GROUP BY E.EmployeeID,E.FirstName,E.LastName
					HAVING (SELECT AVG([Ventas Empleado en 97])
	FROM (
		Select SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Ventas Empleado en 97]
			FROM [Order Details] AS OD
			INNER JOIN Orders AS O
				ON OD.OrderID=O.OrderID
				WHERE YEAR(O.OrderDate)=1997
					GROUP BY O.EmployeeID
						) AS VE97)<=SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount))


--16. Empleados que hayan aumentado su cifra de ventas más de un 10% entre dos
--años consecutivos, indicando el año en que se produjo el aumento.
SELECT O.EmployeeID,E.FirstName, E.LastName,SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Ventas Empleado],
	YEAR(O.OrderDate) AS Año2
	FROM [Order Details] AS OD
	INNER JOIN  Orders AS O
		ON OD.OrderID=O.OrderID
	INNER JOIN Employees AS E
		ON O.EmployeeID=E.EmployeeID
	INNER JOIN
	(
	SELECT O.EmployeeID,SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Ventas Empleado],YEAR(O.OrderDate) AS AÑO
		FROM [Order Details] AS OD
		INNER JOIN Orders AS O
			ON OD.OrderID=O.OrderID
				GROUP BY O.EmployeeID,YEAR(O.OrderDate)
	) AS Facturado
		ON O.EmployeeID=Facturado.EmployeeID AND YEAR(O.Orderdate)-AÑO=1
			GROUP BY O.EmployeeID,YEAR(O.OrderDate),Facturado.[Ventas Empleado],E.FirstName,E.LastName
			HAVING (SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount))-Facturado.[Ventas Empleado])/Facturado.[Ventas Empleado]*100>=10
