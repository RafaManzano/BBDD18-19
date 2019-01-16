USE AdventureWorks2012

--Consultas sencillas
--1.Nombre del producto, código y precio, ordenado de mayor a menor precio
SELECT * FROM Production.Product

SELECT ProductID, [Name], ListPrice FROM Production.Product
ORDER BY ListPrice DESC

--2.Número de direcciones de cada Estado/Provincia
SELECT * FROM Person.StateProvince

SELECT TerritoryID, COUNT (*) AS NumberOfStates FROM Person.StateProvince
GROUP BY TerritoryID

--3.Nombre del producto, código, número, tamaño y peso de los productos que estaban a la venta durante todo el mes de septiembre de 2002. 
--No queremos que aparezcan aquellos cuyo peso sea superior a 2000.
SELECT * FROM Production.Product

SELECT ProductID, [Name], ProductNumber, Size, [Weight] FROM Production.Product
WHERE MONTH(SellStartDate) = 9 AND YEAR(SellStartDate) = 2002 AND [Weight] < 2000

--4.Margen de beneficio de cada producto (Precio de venta menos el coste), y porcentaje que supone respecto del precio de venta.
SELECT * FROM Production.Product

SELECT (ListPrice - StandardCost) AS DifferencePrice,((ListPrice - StandardCost) / 100) AS PorcentagePrice  FROM Production.Product

--Consultas de dificultad media
--5.Número de productos de cada categoría
SELECT * FROM Production.Product

SELECT COUNT(*) AS NumberOfProducts, ProductModelID FROM Production.Product
GROUP BY ProductModelID

--6.Igual a la anterior, pero considerando las categorías generales (categorías de categorías).
SELECT * FROM Production.Product

SELECT COUNT(*) AS NumberOfProducts, ProductSubcategoryID FROM Production.Product
GROUP BY ProductSubcategoryID

--7.Número de unidades vendidas de cada producto cada año.
SELECT * FROM Sales.SalesOrderDetail

SELECT COUNT(*) AS NumberOfUnits, ProductID, YEAR(ModifiedDate) AS [Year] FROM Sales.SalesOrderDetail
GROUP BY ProductID, YEAR(ModifiedDate)

--8.Nombre completo, compañía y total facturado a cada cliente

--9.Número de producto, nombre y precio de todos aquellos en cuya descripción aparezcan las palabras "race”, "competition” o "performance”

--Consultas avanzadas
--10.Facturación total en cada país
--11.Facturación total en cada Estado
--12.Margen medio de beneficios y total facturado en cada país
