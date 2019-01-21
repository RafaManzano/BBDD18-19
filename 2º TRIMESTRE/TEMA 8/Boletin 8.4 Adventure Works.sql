USE AdventureWorks2012
--1. Nombre completo (Tratamiento, nombre, inicial del segundo nombre, apellidos de todos los clientes que en los nombres de sus compañías 
--aparezcan las palabras "cycle”  o "bike”.
SELECT * FROM Sales.Store AS S
INNER JOIN Sales.Customer AS C
ON C.StoreID = S.BusinessEntityID
INNER JOIN Person.Person AS P
ON P.BusinessEntityID = C.PersonID

