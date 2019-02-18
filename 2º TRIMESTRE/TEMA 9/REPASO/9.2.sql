USE Northwind
SELECT * FROM Customers
SELECT * FROM Products

--1.  N�mero de clientes de cada pa�s. 
SELECT COUNT(CustomerID) AS CustomersNumber, Country FROM Customers 
GROUP BY Country

--2. N�mero de clientes diferentes que compran cada producto. Incluye el nombre
--del producto 
SELECT COUNT(DISTINCT C.CustomerID) AS CustomersNumber, P.ProductName FROM Customers AS C
INNER JOIN Orders AS O ON O.CustomerID = C.CustomerID
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
GROUP BY P.ProductName

--3. N�mero de pa�ses diferentes en los que se vende cada producto. Incluye el
--nombre del producto
SELECT P.ProductName, COUNT(DISTINCT O.ShipCountry) AS ContriesNumber FROM Orders AS O
INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
GROUP BY P.ProductName

--4.  Empleados (nombre y apellido) que han vendido alguna vez
--�Gudbrandsdalsost�, �Lakkalik��ri�, �Tourti�re� o �Boston Crab Meat�. 
SELECT DISTINCT E.FirstName, E.LastName FROM Employees AS E
INNER JOIN Orders AS O ON O.EmployeeID = E.EmployeeID
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
WHERE P.ProductName IN('Gudbrandsdalsost', 'Lakkalik��ri', 'Tourti�re' , 'Boston Crab Meat')

--5.  Empleados que no han vendido nunca �Northwoods Cranberry Sauce� o
--�Carnarvon Tigers�. 
SELECT DISTINCT E.FirstName, E.LastName FROM Employees AS E
EXCEPT
SELECT DISTINCT E.FirstName, E.LastName FROM Employees AS E
INNER JOIN Orders AS O ON O.EmployeeID = E.EmployeeID
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
WHERE P.ProductName IN('Northwoods Cranberry Sauce', 'Carnarvon Tigers')

--6.  N�mero de unidades de cada categor�a de producto que ha vendido cada
--empleado. Incluye el nombre y apellidos del empleado y el nombre de la
--categor�a. 
SELECT DISTINCT SUM(OD.Quantity) AS Quantity, C.CategoryID, C.CategoryName, E.EmployeeID, E.FirstName, E.LastName FROM Employees AS E
INNER JOIN Orders AS O ON O.EmployeeID = E.EmployeeID
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
INNER JOIN Categories AS C ON C.CategoryID = P.CategoryID
GROUP BY C.CategoryID, C.CategoryName, E.EmployeeID, E.FirstName, E.LastName

--7. Total de ventas (US$) de cada categor�a en el a�o 97. Incluye el nombre de la
--categor�a. 
SELECT SUM(OD.Quantity * OD.UnitPrice) AS TotalPrice, C.CategoryID, C.CategoryName FROM [Order Details] AS OD
INNER JOIN Orders AS O ON O.OrderID = OD.OrderID
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
INNER JOIN Categories AS C ON C.CategoryID = P.ProductID
--WHERE O.OrderDate = 1997
GROUP BY C.CategoryID, C.CategoryName

--8. Productos que han comprado m�s de un cliente del mismo pa�s, indicando el
--nombre del producto, el pa�s y el n�mero de clientes distintos de ese pa�s que
--lo han comprado
--Comprobar con Leo que esta correcto
SELECT COUNT(DISTINCT C.CustomerID) AS CustomersNumber, P.ProductName, O.ShipCountry FROM Customers AS C
INNER JOIN Orders AS O ON O.CustomerID = C.CustomerID
INNER JOIN [Order Details] AS OD ON OD.OrderID = O.OrderID
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
GROUP BY P.ProductName , O.ShipCountry
HAVING COUNT(C.CustomerID) > 2

--9. Total de ventas (US$) en cada pa�s cada a�o.
SELECT SUM(Quantity * UnitPrice) AS TotalPrice, O.ShipCountry, YEAR(OrderDate) AS Year FROM [Order Details] AS OD
INNER JOIN Orders AS O ON O.OrderID = OD.OrderID
GROUP BY O.ShipCountry, YEAR(OrderDate)

--10. . Producto superventas de cada a�o, indicando a�o, nombre del producto,
--categor�a y cifra total de ventas. 
