--Boletin 7.3
--Consultas sobre una sola Tabla sin agregados
--Sobre la base de Datos AdventureWorks
USE AdventureWorks2012

--Nombre, numero de producto, precio y color de los productos de color rojo o amarillo cuyo precio esté comprendido entre 50 y 500
SELECT ProductID, Name, StandardCost, Color FROM Production.Product
WHERE Color IN ('Red', 'Yellow') AND StandardCost BETWEEN 50 AND 500

--Nombre, número de producto, precio de coste,  precio de venta, margen de beneficios total y margen de beneficios en % del precio de venta de los productos de categorías inferiores a 16
SELECT ProductID, Name, StandardCost, ListPrice, ListPrice - StandardCost AS [Margen beneficio], ((ListPrice - StandardCost) / StandardCost * 100.0) AS [Margen beneficio porcentaje]  FROM Production.Product
WHERE ProductSubcategoryID < '16'                                      

--Empleados cuyo nombre o apellidos contenga la letra "r". Los empleados son los que tienen el valor "EM" en la columna PersonType de la tabla Person
SELECT FirstName, LastName FROM Person.Person 
WHERE PersonType = 'EM' AND ( FirstName LIKE('%r%') OR LastName LIKE('%r%') )

--LoginID, nationalIDNumber, edad y puesto de trabajo (jobTitle) de los empleados (tabla Employees) de sexo femenino que tengan más de cinco años de antigüedad
SELECT LoginID, NationalIDNumber, Year(CURRENT_TIMESTAMP- CAST (BirthDate as smalldatetime))-1900 AS Age, JobTitle, YEAR(HireDate) AS Antiguedad
FROM HumanResources.Employee
WHERE Gender = 'F' AND (YEAR(CURRENT_TIMESTAMP) - YEAR(HireDate)) > 5

--Ciudades correspondientes a los estados 11, 14, 35 o 70, sin repetir. Usar la tabla Person.Address
SELECT DISTINCT City, StateProvinceID 
FROM Person.Address
WHERE StateProvinceID IN ('11', '14', '35', '70')
