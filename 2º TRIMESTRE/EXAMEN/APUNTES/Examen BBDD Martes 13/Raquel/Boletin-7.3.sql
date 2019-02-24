USE AdventureWorks2012
GO

Set Dateformat 'YMD'

--1.Nombre, numero de producto, precio y color de los productos de color rojo o amarillo cuyo precio esté comprendido entre 50 y 500
SELECT Name, ProductNumber, ListPrice, Color
FROM Production.Product
WHERE ListPrice BETWEEN 50 and 500 AND (Color LIKE 'red' OR Color LIKE 'yellow')
--WHERE ListPrice>50 AND ListPrice<500 AND (Color LIKE 'red' OR Color LIKE 'yellow')
--WHERE ListPrice BETWEEN 50 and 500 AND Color in ('red','yellow')
ORDER BY ListPrice ASC

--2.Nombre, número de producto, precio de coste,  precio de venta, margen de beneficios total y margen de beneficios en % del precio
--de venta de los productos de categorías inferiores a 16
SELECT * FROM Production.Product

SELECT Name, ProductNumber, ListPrice, StandardCost,(ListPrice - StandardCost) AS Benefits ,((ListPrice - StandardCost)/ListPrice)*100 AS PercentBenefits
FROM Production.Product
WHERE ListPrice>0 AND StandardCost>0 AND ProductSubcategoryID<16
ORDER BY PercentBenefits ASC

--3.Empleados cuyo nombre o apellidos contenga la letra "r". Los empleados son los que tienen el valor "EM" en la columna PersonType
--de la tabla Person
SELECT FirstName, MiddleName, LastName
FROM Person.Person
WHERE PersonType = 'EM' AND (FirstName LIKE ('%r%') OR MiddleName LIKE ('%r%') OR LastName LIKE ('%r%'))

--4.LoginID, nationalIDNumber, edad y puesto de trabajo (jobTitle) de los empleados (tabla Employees) de sexo femenino que tengan más
--de cinco años de antigüedad
SELECT LoginID, NationalIDNumber, (YEAR(Current_Timestamp) - YEAR(BirthDate)) as Age, JobTitle, (YEAR(Current_Timestamp) - YEAR(HireDate)) AS Antique
FROM HumanResources.Employee
--WHERE Gender='F' AND Antique>5
WHERE Gender in ('F') and YEAR(GETDATE()) - YEAR(HireDate)>5
ORDER BY Antique ASC

--5.Ciudades correspondientes a los estados 11, 14, 35 o 70, sin repetir. Usar la tabla Person.Address
SELECT ,
FROM Person.Address
WHERE StateProvinceID IN ('11','14','35','70')
GROUP BY City
ORDER BY City

