--1. N�mero de clientes de cada pa�s.
Select count(*) as [Numero de clientes],Country FROM Customers
	Group by Country

--2. N�mero de clientes diferentes que compran cada producto. Incluye el nombre
--del producto.
Select count(distinct O.CustomerID) as [Numero de clientes],P.ProductName as [Numero de clientes]
	FROM Orders as O
	INNER JOIN [Order Details] as OD
	on O.OrderID = OD.OrderID
	INNER JOIN Products as P
	on P.ProductID = OD.ProductID
		Group by P.ProductName

--3. N�mero de pa�ses diferentes en los que se vende cada producto. Incluye el
--nombre del producto.
SELECT COUNT(distinct ShipCountry) AS [Numero de paises diferentes],P.ProductName
	FROM Orders AS O
	INNER JOIN [Order Details] AS [OD] 
		ON O.OrderID = OD.OrderID
	INNER JOIN Products AS P
		ON P.ProductID = OD.ProductID
			GROUP BY P.ProductName

--4. Empleados (nombre y apellido) que han vendido alguna vez
--�Gudbrandsdalsost�, �Lakkalik��ri�, �Tourti�re� o �Boston Crab Meat�.
Select E.FirstName,E.LastName,P.ProductName
	from Employees as E
	INNER JOIN Orders AS O
		ON E.EmployeeID = O.EmployeeID
	INNER JOIN [Order Details] AS OD
		ON O.OrderID = OD.OrderID
	INNER JOIN Products AS P
		ON P.ProductID = OD.ProductID
		WHERE ProductName IN('Gudbrandsdalsost', 'Lakkalik��ri', 'Tourti�re', 'Boston Crab Meat')

--5. Empleados que no han vendido nunca �Northwoods Cranberry Sauce� o
--�Carnarvon Tigers�.
SELECT FirstName,LastName
	FROM Employees 
EXCEPT
SELECT E.FirstName,E.LastName
	FROM Employees AS E
	INNER JOIN orders AS O
		ON E.EmployeeID = O.EmployeeID
	INNER JOIN [Order Details] AS OD
		ON O.OrderID = OD.OrderID
	INNER JOIN Products as P
		ON P.ProductID = OD.ProductID
		WHERE P.Productname IN('Northwoods Cranberry Sauce', 'Carnarvon Tigers')

--6. N�mero de unidades de cada categor�a de producto que ha vendido cada
--empleado. Incluye el nombre y apellidos del empleado y el nombre de la
--categor�a.
Select E.FirstName,E.LastName,C.CategoryName,Count(P.ProductID) as [Numero de unidades],C.CategoryID
	from Employees as E
	INNER JOIN Orders AS O
		ON E.EmployeeID = O.EmployeeID
	INNER JOIN [Order Details] AS OD
		ON O.OrderID = OD.OrderID
	INNER JOIN Products AS P
		ON P.ProductID = OD.ProductID
	INNER JOIN Categories AS C
		ON C.CategoryID = P.CategoryID
	Group by E.FirstName,E.LastName,C.CategoryName,C.CategoryID

--7. Total de ventas (US$) de cada categor�a en el a�o 97. Incluye el nombre de la
--categor�a.
Select SUM(OD.UnitPrice*OD.Quantity) as [Total de ventas],C.CategoryName, C.CategoryID
	FROM Orders AS O
	INNER JOIN [Order Details] AS OD
		ON OD.OrderID = O.OrderID
	INNER JOIN Products AS P
		ON P.ProductID = OD.ProductID
	INNER JOIN Categories AS C
		ON C.CategoryID = P.CategoryID
		WHERE YEAR(O.OrderDate) = 1997
			GROUP BY C.CategoryName,C.CategoryID
				
--8. Productos que han comprado m�s de un cliente del mismo pa�s, indicando el
--nombre del producto, el pa�s y el n�mero de clientes distintos de ese pa�s que
--lo han comprado.
SELECT  COUNT(C.CustomerID) AS [Numero de clientes],P.ProductName,C.Country
	FROM Customers AS C
	INNER JOIN Orders AS [O] 
		ON O.CustomerID = C.CustomerID
	INNER JOIN [Order Details] AS [OD] 
		ON OD.OrderID = O.OrderID
	INNER JOIN Products AS P 
		ON P.ProductID = OD.ProductID
			GROUP BY P.ProductName,C.Country
			HAVING COUNT(C.CustomerID) > 1

--9. Total de ventas (US$) en cada pa�s cada a�o.
SELECT SUM(OD.Quantity*OD.UnitPrice) AS [Ventas],ShipCountry,Year(OrderDate) AS [Total de ventas]
	FROM Orders AS O
	INNER JOIN [Order Details] AS [OD] 
		ON OD.OrderID = O.OrderID
			GROUP BY YEAR(OrderDate),ShipCountry

--10. Producto superventas de cada a�o, indicando a�o, nombre del producto,
--categor�a y cifra total de ventas.
Select  P.ProductName,P.CategoryID ,YEAR(O.OrderDate) AS A�o, SUM(OD.Quantity*OD.UnitPrice) AS [Ventas Totales]
				FROM Products AS P
				INNER JOIN [Order Details] AS OD
					ON P.ProductID=OD.ProductID
				INNER JOIN Orders AS O
					ON OD.OrderID=O.OrderID
INNER JOIN
(Select Max(VT.[Ventas Totales]) as [Venta maxima],VT.A�o FROM
(SELECT P.ProductName, YEAR(O.OrderDate) AS A�o, SUM(OD.Quantity*OD.UnitPrice) AS [Ventas Totales]
				FROM Products AS P
				INNER JOIN [Order Details] AS OD
					ON P.ProductID=OD.ProductID
				INNER JOIN Orders AS O
					ON OD.OrderID=O.OrderID
						GROUP BY P.ProductName,YEAR(O.OrderDate)) AS VT
							GROUP BY VT.A�o ) AS VA ON YEAR(O.OrderDate) = VA.A�o
							GROUP BY P.ProductName,P.CategoryID,YEAR(O.OrderDate),VA.[Venta maxima]
							HAVING SUM(OD.Quantity*OD.UnitPrice) = VA.[Venta maxima]
			
			
--11. Cifra de ventas de cada producto en el a�o 97 y su aumento o disminuci�n
--respecto al a�o anterior en US $ y en %.	

select V97.ProductName,V97.[Ventas Totales del 97],
	  (V97.[Ventas Totales del 97]-V96.[Ventas Totales del 96]) AS [Aumento_Disminucion],
	  (V97.[Ventas Totales del 97]-V96.[Ventas Totales del 96])/V96.[Ventas Totales del 96]*100 AS Porcentaje  from(									
SELECT P.ProductName, SUM(OD.Quantity*OD.UnitPrice) AS [Ventas Totales del 97]
	FROM Products AS P
	INNER JOIN [Order Details] AS OD
		ON P.ProductID=OD.ProductID
	INNER JOIN Orders AS O
		ON OD.OrderID=O.OrderID
			WHERE YEAR(O.OrderDate)=1997
				GROUP BY P.ProductName) AS V97
INNER JOIN(
SELECT P.ProductName, SUM(OD.Quantity*OD.UnitPrice) AS [Ventas Totales del 96]
	FROM Products AS P
	INNER JOIN [Order Details] AS OD
		ON P.ProductID=OD.ProductID
	INNER JOIN Orders AS O
		ON OD.OrderID=O.OrderID
			WHERE YEAR(O.OrderDate)=1996
				GROUP BY P.ProductName) AS V96 
ON V97.ProductName = V96.ProductName
order by V96.ProductName


------Hecho con vistas
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

GO
ALTER FUNCTION [Ventas anuales] (@a�o int) returns table AS return
SELECT P.ProductName, SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Ventas Totales]
	FROM Products AS P
	INNER JOIN [Order Details] AS OD
		ON P.ProductID=OD.ProductID
	INNER JOIN Orders AS O
		ON OD.OrderID=O.OrderID
			WHERE YEAR(O.OrderDate)= @a�o
				GROUP BY P.ProductName
GO

SELECT V97.ProductName,V97.[Ventas Totales],
	  (V97.[Ventas Totales]-V96.[Ventas Totales]) AS [Aumento_Disminucion],
	  (V97.[Ventas Totales]-V96.[Ventas Totales])/V97.[Ventas Totales]*100 AS Porcentaje
	  FROM [Ventas anuales](1997) AS V97
	  INNER JOIN [Ventas anuales](1996) AS  V96
		ON V97.ProductName=V96.ProductName

--12. Mejor cliente (el que m�s nos compra) de cada pa�s.
Select C.ContactName,SUM(OD.Quantity) as [Ventas Totales], c.Country
	FROM Customers AS C
	INNER JOIN Orders AS O
		ON C.CustomerID=O.CustomerID
	INNER JOIN [Order Details] AS OD
		ON O.OrderID=OD.OrderID
INNER JOIN(
Select max(MJ.[Ventas Totales]) AS [Mejor venta],mj.Country from
(Select C.ContactName,SUM(OD.Quantity) as [Ventas Totales], C.Country
	FROM Customers AS C
	INNER JOIN Orders AS O
		ON C.CustomerID=O.CustomerID
	INNER JOIN [Order Details] AS OD
		ON O.OrderID=OD.OrderID
			GROUP BY C.Country,C.ContactName)as MJ
				GROUP BY mj.Country) as MV ON MV.Country = c.Country
					GROUP BY c.Country,C.ContactName,mv.[Mejor venta]
					HAVING SUM(OD.Quantity) = mv.[Mejor venta]

--13. N�mero de productos diferentes que nos compra cada cliente. Incluye el
--nombre y apellidos del cliente y su direcci�n completa.
Select C.CustomerID, COUNT(P.ProductID) AS [Productos diferentes],C.ContactName,C.Address,C.City,C.Region
	FROM Customers AS C
	INNER JOIN Orders AS O
		ON C.CustomerID=O.CustomerID
	INNER JOIN [Order Details] AS OD
		ON O.OrderID=OD.OrderID
	INNER JOIN Products AS P
		ON OD.ProductID=P.ProductID
			GROUP BY C.CustomerID,C.ContactName,C.Address,C.City,C.Region

--14. Clientes que nos compran m�s de cinco productos diferentes.
Select count(P.ProductID) as [Numero de productos],C.CustomerID from Customers AS C
	INNER JOIN  Orders AS O
		ON C.CustomerID = O.CustomerID
	INNER JOIN [Order Details] AS OD
		ON OD.OrderID = O.OrderID
	INNER JOIN Products AS P
		ON P.ProductID = OD.ProductID
			GROUP BY C.CustomerID
			HAVING count(P.ProductID) > 5

--15. Vendedores (nombre y apellidos) que han vendido una mayor cantidad que la
--media en US $ en el a�o 97.
Select E.FirstName,E.LastName,SUM(OD.Quantity*OD.UnitPrice) AS [Numero de ventas]
	FROM Employees AS E
	INNER JOIN Orders AS O
		ON E.EmployeeID = O.EmployeeID
	INNER JOIN [Order Details] AS OD
		ON OD.OrderID=O.OrderID
	GROUP BY E.FirstName,E.LastName
HAVING
(Select AVG(V97.[Numero de ventas]) AS [Media] FROM
(SELECT E.FirstName,E.LastName,SUM(OD.Quantity*OD.UnitPrice) AS [Numero de ventas]
	FROM Employees AS E
	INNER JOIN Orders AS O
		ON E.EmployeeID = O.EmployeeID
	INNER JOIN [Order Details] AS OD
		ON OD.OrderID=O.OrderID
			WHERE YEAR(O.OrderDate)=1997
				GROUP BY E.FirstName,E.LastName) AS V97) <= SUM(OD.Quantity*OD.UnitPrice)
					

--16. Empleados que hayan aumentado su cifra de ventas m�s de un 10% entre dos
--a�os consecutivos, indicando el a�o en que se produjo el aumento. 
SELECT O.EmployeeID,E.FirstName, E.LastName,SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Ventas Empleado],
	YEAR(O.OrderDate) AS A�o2
	FROM [Order Details] AS OD
	INNER JOIN  Orders AS O
		ON OD.OrderID=O.OrderID
	INNER JOIN Employees AS E
		ON O.EmployeeID=E.EmployeeID
INNER JOIN
(
SELECT O.EmployeeID,SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS [Ventas Empleado],YEAR(O.OrderDate) AS A�O
		FROM [Order Details] AS OD
		INNER JOIN Orders AS O
			ON OD.OrderID=O.OrderID
				GROUP BY O.EmployeeID,YEAR(O.OrderDate)
) AS Facturado 
		ON O.EmployeeID=Facturado.EmployeeID AND YEAR(O.Orderdate)-A�O=1
GROUP BY O.EmployeeID,YEAR(O.OrderDate),Facturado.[Ventas Empleado],E.FirstName,E.LastName
HAVING (SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount))-Facturado.[Ventas Empleado])/Facturado.[Ventas Empleado]*100>=10
