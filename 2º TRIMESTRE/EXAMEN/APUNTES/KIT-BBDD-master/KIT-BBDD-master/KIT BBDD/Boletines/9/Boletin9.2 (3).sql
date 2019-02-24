USE Northwind
--Unidad 9.2
--PROBLEMA

--1. N�mero de clientes de cada pa�s.
SELECT COUNT(CustomerID) AS [Numero de Clientes], Country
FROM Customers
GROUP BY Country
ORDER BY Country

--2. N�mero de clientes diferentes que compran cada producto.
SELECT COUNT( DISTINCT C.CustomerID) AS Cliente, OD.ProductID
FROM Customers AS C
INNER JOIN Orders AS O
ON C.CustomerID = O.CustomerID
INNER JOIN [Order Details] AS OD
ON O.OrderID = OD.OrderID
GROUP BY OD.ProductID

--3. N�mero de pa�ses diferentes en los que se vende cada producto.
SELECT COUNT(DISTINCT O.ShipCountry) AS [Numero de paises diferentes], P.ProductName
FROM Orders AS O
INNER JOIN [Order Details] AS OD
ON O.OrderID = OD.OrderID
INNER JOIN Products AS P
ON OD.ProductID = P.ProductID
GROUP BY P.ProductName

--4. Empleados que han vendido alguna vez �Gudbrandsdalsost�, �Lakkalik��ri�,
--�Tourti�re� o �Boston Crab Meat�.
SELECT DISTINCT E.FirstName, E.LastName, P.ProductName
FROM Employees AS E
INNER JOIN Orders AS O
ON E.EmployeeID = O.EmployeeID
INNER JOIN [Order Details] AS OD
ON O.OrderID = OD.OrderID
INNER JOIN Products AS P
ON OD.ProductID = P.ProductID
WHERE P.ProductName in ('Gudbrandsdalsost','Lakkalikööri','Tourtière','Boston Crab Meat')

--5. Empleados que no han vendido nunca �Chartreuse verte� ni �Ravioli Angelo�.
SELECT DISTINCT E.FirstName, E.LastName
FROM Employees AS E
INNER JOIN Orders AS O
ON E.EmployeeID = O.EmployeeID
INNER JOIN [Order Details] AS OD
ON O.OrderID = OD.OrderID
INNER JOIN Products AS P
ON OD.ProductID = P.ProductID
WHERE P.ProductName NOT IN ('Chartreuse verte', 'Ravioli Angelo')

--6. N�mero de unidades de cada categor�a de producto que ha vendido cada empleado.
SELECT SUM(OD.Quantity) AS [Numero de unidades], C.CategoryID, E.FirstName
FROM Employees AS E
INNER JOIN Orders AS O
ON E.EmployeeID = O.EmployeeID
INNER JOIN [Order Details] AS OD
ON O.OrderID = OD.OrderID
INNER JOIN Products AS P
ON OD.ProductID = P.ProductID
INNER JOIN Categories AS C
ON P.CategoryID = C.CategoryID
GROUP BY E.FirstName, C.CategoryID
ORDER BY E.FirstName, C.CategoryID

--7. Total de ventas (US$) de cada categor�a en el a�o 97.
SELECT SUM(OD.Quantity * OD.UnitPrice) AS [Total Ventas], C.CategoryName
FROM Orders AS O
INNER JOIN [Order Details] AS OD
ON O.OrderID = OD.OrderID
INNER JOIN Products AS P
ON OD.ProductID = P.ProductID
INNER JOIN Categories AS C
ON P.CategoryID = C.CategoryID
WHERE YEAR(O.OrderDate) = '1997' 
GROUP BY C.CategoryName

--8. Productos que han comprado m�s de un cliente del mismo pa�s, indicando el
--nombre del producto, el pa�s y el n�mero de clientes distintos de ese pa�s que lo han comprado.
SELECT P.ProductName, C.Country, COUNT( DISTINCT C.CustomerID) AS NumeroClientes
FROM Customers AS C
INNER JOIN Orders AS O
ON C.CustomerID = O.CustomerID
INNER JOIN [Order Details] AS OD
ON O.OrderID = OD.OrderID
INNER JOIN Products AS P
ON OD.ProductID = P.ProductID
GROUP BY P.ProductName, C.Country
HAVING COUNT( DISTINCT C.CustomerID) > 1

--9. Total de ventas (US$) en cada pa�s cada a�o.
SELECT CAST(SUM((OD.UnitPrice * Quantity) - (OD.UnitPrice * Quantity * Discount) ) AS smallmoney) AS TotalVentas, S.CompanyName , YEAR(O.OrderDate) YEAR
FROM Suppliers AS S
INNER JOIN Products AS P
ON S.SupplierID = P.SupplierID
INNER JOIN [Order Details] AS OD
ON P.ProductID = OD.ProductID
INNER JOIN Orders AS O
ON O.OrderID = OD.OrderID
GROUP BY YEAR(O.OrderDate), S.CompanyName

--10. Producto superventas de cada a�o, indicando a�o, nombre del producto, categor�a y cifra total de ventas.
--11. Cifra de ventas de cada producto en el a�o 97 y su aumento o disminuci�n respecto al a�o anterior en US $ y en %.

--12. Mejor cliente (el que m�s nos compra) de cada pa�s.
SELECT DISTINCT C.CompanyName, C.Country ,MAX(OD.UnitPrice * OD.Quantity) AS Ventas
FROM Customers AS C
INNER JOIN Orders AS O
ON C.CustomerID = O.CustomerID
INNER JOIN [Order Details] AS OD
ON O.OrderID = OD.OrderID
GROUP BY C.CompanyName, Country
ORDER BY Ventas DESC

--13. N�mero de productos diferentes que nos compra cada cliente.
SELECT DISTINCT COUNT(P.ProductID) AS [Numero de productos diferentes], C.ContactName
FROM Customers AS C
INNER JOIN Orders AS O
ON C.CustomerID = O.CustomerID
INNER JOIN [Order Details] AS OD
ON O.OrderID = OD.OrderID
INNER JOIN Products AS P
ON OD.ProductID = P.ProductID
GROUP BY C.CustomerID, C.ContactName

--14. Clientes que nos compran mas de cinco productos diferentes.
SELECT COUNT(P.ProductID) AS Productos,  C.ContactName
FROM Customers AS C
INNER JOIN Orders AS O
ON C.CustomerID = O.CustomerID
INNER JOIN [Order Details] AS OD
ON O.OrderID = OD.OrderID
INNER JOIN Products AS P
ON OD.ProductID = P.ProductID
GROUP BY C.CustomerID, C.ContactName
HAVING count(P.ProductName)>5

--15. Vendedores que han vendido una mayor cantidad que la media en US $ en el año 97.
--16. Empleados que hayan aumentado su cifra de ventas m�s de un 10% entre dos
--a�os consecutivos, indicando el a�o en que se produjo el aumento.