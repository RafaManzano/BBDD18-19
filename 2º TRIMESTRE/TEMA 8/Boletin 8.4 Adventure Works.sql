USE AdventureWorks2014
--1. Nombre completo (Tratamiento, nombre, inicial del segundo nombre, apellidos de todos los clientes que en los nombres de sus compañías 
--aparezcan las palabras "cycle”  o "bike”.
SELECT P.Title, P.FirstName, P.MiddleName, P.LastName FROM Sales.Store AS S
INNER JOIN Sales.Customer AS C
ON C.StoreID = S.BusinessEntityID
INNER JOIN Person.Person AS P
ON P.BusinessEntityID = C.PersonID
WHERE S.Name LIKE('%cycle%') OR S.Name LIKE('%bike%')

--2. Repite la consulta anterior sin incluir la inicial del nombre. ¿Obtienes el mismo número de filas? ¿A qué es debido?
SELECT P.Title, P.FirstName, P.LastName FROM Sales.Store AS S
INNER JOIN Sales.Customer AS C
ON C.StoreID = S.BusinessEntityID
INNER JOIN Person.Person AS P
ON P.BusinessEntityID = C.PersonID
WHERE S.Name LIKE('%cycle%') OR S.Name LIKE('%bike%')
--Creo que no deberia introducir los valores null pero a mi no me deja

--3. Explica cómo podrías solucionar el problema detectado en el ejercicio anterior. 
--Pista: Busca la función ISNULL() en la ayuda.
--Como la anterior no me da fallos asi que lo dejo

--4. Número de productos de cada color.
SELECT COUNT(*) AS ProductNumber, Color FROM Production.Product
GROUP BY Color

--5. El margen de un producto es la diferencia entre su precio de venta (ListPrice) y su precio de coste (StandardPrice).
--Crea una consulta que obtenga nombre y número del producto, margen y categoría. 
SELECT ProductNumber,Name, (ListPrice - StandardCost) AS Diference, ProductModelID FROM Production.Product

--6. ID de categoría y margen medio (AVG) de los productos de esa categoría. Ten l cuenta que el margen medio es la media de los márgenes.
SELECT ProductModelID, AVG((ListPrice - StandardCost)) AS Average FROM Production.Product
GROUP BY ProductModelID 

--7. Consulta cuantas direcciones diferentes tenemos de cada país
SELECT COUNT(DISTINCT A.AddressID) AS AddressDiferences, CR.Name AS CountryName FROM Person.StateProvince AS SP
INNER JOIN Person.CountryRegion AS CR
ON CR.CountryRegionCode = SP.CountryRegionCode
INNER JOIN Person.Address AS A
ON A.StateProvinceID = SP.StateProvinceID
GROUP BY CR.Name

--8. Consulta cuantas direcciones diferentes tenemos de cada país y estado
SELECT COUNT(DISTINCT A.AddressID) AS AddressNumbers, SP.Name AS StateName, CR.Name AS CountryName FROM Person.StateProvince AS SP
INNER JOIN Person.CountryRegion AS CR
ON CR.CountryRegionCode = SP.CountryRegionCode
INNER JOIN Person.Address AS A
ON A.StateProvinceID = SP.StateProvinceID
GROUP BY CR.Name, SP.Name

--9. Consulta cuantas direcciones diferentes tenemos de cada país, estado y ciudad
SELECT COUNT(DISTINCT A.AddressID) AS AddressNumbers, A.City AS CityName, SP.Name AS StateName, CR.Name AS CountryName  FROM Person.StateProvince AS SP
INNER JOIN Person.CountryRegion AS CR
ON CR.CountryRegionCode = SP.CountryRegionCode
INNER JOIN Person.Address AS A
ON A.StateProvinceID = SP.StateProvinceID
GROUP BY CR.Name, SP.Name, A.City
