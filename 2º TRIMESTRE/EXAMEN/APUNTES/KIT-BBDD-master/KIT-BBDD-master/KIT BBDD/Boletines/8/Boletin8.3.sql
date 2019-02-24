--Consultas 8.3
--Base de datos: AdventureWorks2012
USE AdventureWorks2012

--Consultas sencillas
--1.Nombre del producto, c�digo y precio, ordenado de mayor a menor precio
SELECT Name, ProductID, ListPrice
FROM Production.Product
ORDER BY StandardCost DESC

--2.N�mero de direcciones de cada Estado/Provincia
SELECT COUNT(AddressID) AS [Numero de direcciones], StateProvinceID
FROM Person.Address
GROUP BY StateProvinceID

--3.Nombre del producto, c�digo, n�mero, tama�o y peso de los productos que estaban a la venta durante todo el mes
-- de septiembre de 2002. No queremos que aparezcan aquellos cuyo peso sea superior a 2000.
SELECT Name, ProductID, ProductNumber, Size, Weight
FROM Production.Product

--4.Margen de beneficio de cada producto (Precio de venta menos el coste), y porcentaje que supone
-- respecto del precio de venta. 
SELECT ListPrice - StandardCost AS [Beneficio], ((ListPrice - StandardCost) / StandardCost) * 100 AS Porcentaje
FROM Production.Product
WHERE ListPrice > 0 AND StandardCost > 0

--Consultas de dificultad media
--5.N�mero de productos de cada categor�a
SELECT COUNT(ProductID) AS [Numero de productos], ProductSubcategoryID 
FROM Production.Product
GROUP BY ProductSubcategoryID 

--6.Igual a la anterior, pero considerando las categor�as generales (categor�as de categor�as).
SELECT COUNT(ProductID) AS [Numero de productos], Class
FROM Production.Product
GROUP BY Class

--7.N�mero de unidades vendidas de cada producto cada a�o.
SELECT COUNT(ProductID) AS [Numero de unidades] , YEAR(ModifiedDate) [Anio]
FROM Sales.SalesOrderDetail
GROUP BY YEAR(ModifiedDate)

--8.Nombre completo, compa��a y total facturado a cada cliente

--9.N�mero de producto, nombre y precio de todos aquellos en cuya descripci�n aparezcan las palabras
--  "race�, "competition� o "performance�
SELECT ProductNumber, Name, ListPrice
FROM Production.Product
WHERE Production.ProductDescription.Description IN ('%race%')

--Consultas avanzadas
--10.Facturaci�n total en cada pa�s
SELECT (SOD.UnitPrice * SOD.OrderQty) AS [Facturacion anual], ST.Name
FROM Sales.SalesOrderDetail AS SOD
INNER JOIN Sales.SalesOrderHeader AS SOH ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN Sales.SalesTerritory AS ST ON SOH.TerritoryID = ST.TerritoryID
GROUP BY ST.Name, SOD.UnitPrice, SOD.OrderQty

--11.Facturaci�n total en cada Estado
SELECT (SOD.UnitPrice * SOD.OrderQty) AS [Facturacion anual], ST.Name
FROM Sales.SalesOrderDetail AS SOD
INNER JOIN Sales.SalesOrderHeader AS SOH ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN Sales.SalesTerritory AS ST ON SOH.TerritoryID = ST.TerritoryID
GROUP BY ST.Name, SOD.UnitPrice, SOD.OrderQty

--12.Margen medio de beneficios y total facturado en cada pa�s

