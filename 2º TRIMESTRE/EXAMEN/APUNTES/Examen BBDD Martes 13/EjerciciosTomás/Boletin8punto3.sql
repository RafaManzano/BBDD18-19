USE AdventureWorks2012

				/**Consultas sencillas**/

/*1.Nombre del producto, código y precio, ordenado de mayor a menor precio*/
SELECT * FROM Production.Product

SELECT Name,ProductNumber, ListPrice FROM Production.Product
	ORDER BY ListPrice DESC

/*2.Número de direcciones de cada Estado/Provincia*/
SELECT * FROM Person.Address

SELECT COUNT(AddressID) AS [Número de direcciones], StateProvinceID FROM Person.Address
	GROUP BY StateProvinceID

/*3.Nombre del producto, código, número, tamaño y peso de los productos que estaban a la venta durante todo el mes de septiembre de 2002.
No queremos que aparezcan aquellos cuyo peso sea superior a 2000.*/
SELECT * FROM Production.Product

SET DATEFORMAT ymd

SELECT Name, ProductID, ProductNumber, Size, [Weight] FROM Production.Product
	WHERE SellStartDate BETWEEN '2002-09-01' AND '2002-09-30'

/*4.Margen de beneficio de cada producto (Precio de venta menos el coste), y porcentaje que supone respecto del precio de venta.*/
SELECT * FROM Production.Product

SELECT (ListPrice - StandardCost) AS [Margen de beneficio] FROM Production.Product


				/**Consultas de dificultad media**/

/*5.Número de productos de cada categoría*/
SELECT * FROM Production.ProductSubcategory

SELECT ProductCategoryID, COUNT(Name) AS [Número de productos]  FROM Production.ProductSubcategory
	GROUP BY ProductCategoryID

/*6.Igual a la anterior, pero considerando las categorías generales (categorías de categorías).*/

/* Ni idea :) */

/*7.Número de unidades vendidas de cada producto cada año.*/
SELECT * FROM Sales.SalesOrderDetail


/*8.Nombre completo, compañía y total facturado a cada cliente*/
SELECT * FROM Sales.Customer
SELECT * FROM Person.Person

/*9.Número de producto, nombre y precio de todos aquellos en cuya descripción aparezcan las palabras "race”, "competition” o "performance”*/
SELECT * FROM Production.Product

/*SELECT ProductNumber, Name, ListPrice FROM Production.Product
	WHERE */


				/**Consultas avanzadas**/

/*10.Facturación total en cada país*/
SELECT * FROM Sales.SalesTerritory

SELECT CountryRegionCode, SUM(SalesYTD) AS [Facturación total] FROM Sales.SalesTerritory
	GROUP BY CountryRegionCode

/*11.Facturación total en cada Estado*/
SELECT * FROM Sales.SalesTerritory

SELECT * FROM Person.StateProvince

/*12.Margen medio de beneficios y total facturado en cada país*/
SELECT * FROM Sales.SalesTerritory

SELECT CountryRegionCode FROM Sales.SalesTerritory