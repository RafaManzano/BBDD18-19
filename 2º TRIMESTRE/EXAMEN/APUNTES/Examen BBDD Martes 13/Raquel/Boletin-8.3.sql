USE AdventureWorks2012
GO

--Consultas sencillas
--1.Nombre del producto, código y precio, ordenado de mayor a menor precio
SELECT * FROM Production.Product

SELECT Name, ProductNumber, ListPrice
FROM Production.Product
ORDER BY ListPrice DESC

--2.Número de direcciones de cada Estado/Provincia
SELECT PA.StateProvinceID, SP.StateProvinceCode
FROM Person.StateProvince AS SP
INNER JOIN Person.Address AS PA
ON SP.StateProvinceID=PA.StateProvinceID
GROUP BY SP.StateProvinceCode, PA.StateProvinceID

--3.Nombre del producto, código, número, tamaño y peso de los productos que estaban a la venta durante todo el mes de 
-- septiembre de 2002. No queremos que aparezcan aquellos cuyo peso sea superior a 2000.
SELECT * FROM Production.Product

SELECT Name, ProductID, ProductNumber,Size, Weight
FROM Production.Product
WHERE MONTH(SellStartDate)=09 and YEAR(SellStartDate)=2002 and Weight<=2000

--4.Margen de beneficio de cada producto (Precio de venta menos el coste), y porcentaje que supone respecto del precio de venta.
SELECT * FROM Production.Product

SELECT ListPrice,StandardCost, (ListPrice-StandardCost) AS Benefit, ((ListPrice-StandardCost)/ListPrice)*100 AS PercentBenefits
FROM Production.Product
WHERE ListPrice!=0

--Consultas de dificultad media
--5.Número de productos de cada categoría
SELECT * FROM Production.ProductSubcategory

SELECT COUNT(Name) AS NumberProducts
, ProductCategoryID,ProductSubcategoryID
FROM Production.ProductSubcategory
GROUP BY ProductSubcategoryID, ProductCategoryID

--6.Igual a la anterior, pero considerando las categorías generales (categorías de categorías).

--(Anterior lo tiene ambos)

--7.Número de unidades vendidas de cada producto cada año.
SELECT * FROM Sales.SalesOrderDetail

SELECT ProductID, COUNT (ProductID) AS NumbersUnit, YEAR(ModifiedDate) AS Year
FROM Sales.SalesOrderDetail
GROUP BY ProductID, ModifiedDate
ORDER BY ModifiedDate, ProductID

--8.Nombre completo, compañía y total facturado a cada cliente


--9.Número de producto, nombre y precio de todos aquellos en cuya descripción aparezcan las palabras "race”, 
-- "competition” o "performance”


--Consultas avanzadas
--10.Facturación total en cada país


--11.Facturación total en cada Estado


--12.Margen medio de beneficios y total facturado en cada país

