USE Northwind

--1. Nombre de los proveedores y n�mero de productos que nos vende cada uno
SELECT S.ContactName, COUNT(P.ProductID) AS ProductsNumber FROM Suppliers AS S
INNER JOIN Products AS P ON S.SupplierID = P.SupplierID
GROUP BY S.ContactName

--2. Nombre completo y telefono de los vendedores que trabajen en New York, Seattle, Vermont, 
--Columbia, Los Angeles, Redmond o Atlanta.
SELECT E.FirstName, E.LastName, E.HomePhone FROM Employees AS E
INNER JOIN EmployeeTerritories AS ET ON ET.EmployeeID = E.EmployeeID
INNER JOIN Territories AS T ON T.TerritoryID = ET.TerritoryID
WHERE T.TerritoryDescription IN('New York', 'Seattle', 'Vermont', 'Columbia', 'Los Angeles', 'Redmond' , 'Atlanta')

--3. N�mero de productos de cada categor�a y nombre de la categor�a.
SELECT C.CategoryName, COUNT(P.ProductID) AS ProductsNumber FROM Products AS P
INNER JOIN Categories AS C ON C.CategoryID = P.CategoryID
GROUP BY C.CategoryName

--4. Nombre de la compa��a de todos los clientes que hayan comprado queso de cabrales o tofu.
SELECT C.CompanyName, COUNT(C.CustomerID) AS Customers FROM Customers AS C 
INNER JOIN Orders AS O ON C.CustomerID = O.CustomerID
INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
WHERE P.ProductName IN('Queso Cabrales', 'Tofu')
GROUP BY C.CompanyName

--5. Empleados (ID, nombre, apellidos y tel�fono) que han vendido algo a Bon app' o Meter Franken.
SELECT E.FirstName, E.LastName, E.HomePhone FROM Employees AS E
INNER JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
WHERE O.ShipName IN('Bon app''', ('Meter Franken'))

--6. Empleados (ID, nombre, apellidos, mes y d�a de su cumplea�os) que no han vendido nunca nada a ning�n cliente de Francia. *

--7. Total de ventas en US$ de productos de cada categor�a (nombre de la categor�a).
SELECT C.CategoryID, C.CategoryName, SUM(OD.UnitPrice * OD.Quantity) AS Total  FROM Products AS P 
INNER JOIN Categories AS C ON C.CategoryID = P.CategoryID
INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
GROUP BY C.CategoryName, C.CategoryID

--8. Total de ventas en US$ de cada empleado cada a�o (nombre, apellidos, direcci�n).
SELECT E.FirstName, E.LastName, E.Address ,SUM(OD.UnitPrice * OD.Quantity) AS Total FROM [Order Details] AS OD
INNER JOIN Orders AS O ON O.OrderID = OD.OrderID
INNER JOIN Employees AS E ON E.EmployeeID = O.EmployeeID
GROUP BY E.FirstName, E.LastName, E.Address 

--9. Ventas de cada producto en el a�o 97. Nombre del producto y unidades.
SELECT P.ProductName, COUNT(OD.ProductID) AS Units, CAST(SUM(OD.UnitPrice * OD.Quantity - OD.Discount) AS DECIMAL(10,2)) AS Sales FROM Products AS P
INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
INNER JOIN Orders AS O ON O.OrderID = OD. OrderID
WHERE YEAR(O.OrderDate) = 1997
GROUP BY P.ProductName, YEAR(O.OrderDate)

--10. Cu�l es el producto del que hemos vendido m�s unidades en cada pa�s.

--11. Empleados (nombre y apellidos) que trabajan a las �rdenes de Andrew Fuller.
SELECT ESB.FirstName, ESB.LastName FROM Employees AS EJE
INNER JOIN Employees AS ESB ON ESB.ReportsTo = EJE.EmployeeID
WHERE EJE.FirstName = 'Andrew' AND EJE.LastName = 'Fuller'

--12. N�mero de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. Nombre, apellidos, ID.
SELECT EJE.EmployeeID, EJE.FirstName, EJE.LastName, COUNT(EJE.EmployeeID) AS Subordinados FROM Employees AS EJE
FULL JOIN Employees AS ESB ON ESB.ReportsTo = EJE.EmployeeID 
GROUP BY EJE.EmployeeID, EJE.FirstName, EJE.LastName
