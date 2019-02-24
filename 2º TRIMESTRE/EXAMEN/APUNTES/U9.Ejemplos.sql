/*
Script para ilustrar como hacer consultas de más de una tabla

*/

USE Ejemplos
GO
-- Comprobamos si existe la tabla Regalos
IF Object_ID('Regalitos') IS NULL
BEGIN
	CREATE TABLE Regalos(
		ID tinyint NOT NULL CONSTRAINT [PK_Regalos] PRIMARY KEY
		,Denominacion nvarchar(50) NOT NULL
		,Ancho tinyint NULL
		,Largo tinyint NULL
		,Alto tinyint NULL
		,Tipo char(1) NULL
		,EdadMinima tinyint NOT NULL
		,Precio smallmoney NOT NULL
		,Superficie  AS (CONVERT(smallint,Ancho)*Largo)
	)

	INSERT INTO Regalos (ID ,Denominacion,Ancho,Largo,Alto,Tipo,EdadMinima,Precio) VALUES
	(1,'Muñeca meona',15,10,80,'M',3,40.95)
	,(4,'Exin chabola',45,85,20,'C',6,17.20)
	,(6,'Action Man Latin King',20,15,50,'M',4,15.48)
	,(7,'Patinete',35,90,30,'A',6,38.00)
	,(11,'Trompo',15,15,20,'A',4,4.80)
	,(13,'QuimiPum',45,75,20,'E',10,14.25)
	,(15,'Muñeca llorona',15,10,80,'M',3,36.85)
	,(16,'Magia Potagia',50,80,20,'S',8,19.70)
	,(18 ,'Enredos',55,65,20,NULL,5,14.85)
	,(22,'Action Man Skin Head',20,15,50,'M',4,15.48)
END	--IF Object_ID('Regalitos') IS NULL

IF Object_ID('Gente') IS NULL
BEGIN
	CREATE TABLE Gente (
		Nombre NVarchar (30)
		,Altura SmallInt
	)

	INSERT INTO Gente (Nombre, Altura)
		VALUES ('Enrique',175)
			,('Cristina',172)
			,('Diego',170);
END	-- IF Object_ID('Gente') IS NULL

IF Object_ID('Gente') IS NULL
BEGIN
	CREATE TABLE Personas (
		Nombre NVarchar (30)
		,Altura SmallInt
	)

	INSERT INTO Personas (Nombre, Altura)
		VALUES ('Adela',165)
			,('Diego',183)
			,('Iñigo',175)
			,('Cristina',172);
END
--Mas datos
CREATE TABLE Criaturitas (
	ID TinyInt Identity (1,1)
	,Nombre NVarchar (30)
	,CONSTRAINT PK_Criaturitas Primary Key (ID)
)
ALTER TABLE Regalos ADD GoesTo TinyInt NULL 
	CONSTRAINT FK_RegalosCriaturitas Foreign Key References Criaturitas (ID)
GO
Insert INTO Criaturitas (Nombre) SELECT Nombre FROM Gente UNION SELECT Nombre FROM Personas

UPDATE Regalos SET GoesTo = 1 WHERE ID = 4
UPDATE Regalos SET GoesTo = 2 WHERE ID IN (11,22)
UPDATE Regalos SET GoesTo = 3 WHERE ID IN (6,18)
UPDATE Regalos SET GoesTo = 5 WHERE ID IN (1,7)
GO
------------------------------------------------------
--Ejemplos de Consultas multitabla
-- Union
SELECT * FROM Gente
UNION
SELECT * FROM Personas

--Intersección
SELECT * FROM Gente
INTERSECT
SELECT * FROM Personas

--Diferencia
SELECT * FROM Gente
EXCEPT
SELECT * FROM Personas

-- INNER Join
SELECT * FROM Regalos
SELECT R.Denominacion, R.GoesTo,C.ID, C.Nombre FROM Regalos AS R INNER JOIN Criaturitas AS C ON R.GoesTO = C.ID

-- OUTER Join
-- Muestra todas las filas de la tabla de la izquierda (Regalos), incluidas los que no se relacionan con ningúna criaturita
SELECT R.Denominacion, R.GoesTo,C.ID, C.Nombre FROM Regalos AS R LEFT JOIN Criaturitas AS C ON R.GoesTO = C.ID

-- Muestra todas las filas de la tabla de la derecha (Criaturitas), incluidas las que no tienen ningún regalo (pobres)
SELECT R.Denominacion, R.GoesTo,C.ID, C.Nombre FROM Regalos AS R RIGHT JOIN Criaturitas AS C ON R.GoesTO = C.ID

-- Incluye todas las filas de ambas tablas, aunque no estén relacionadas: las criaturitas sin regalo y los regalos sin criaturita
SELECT R.Denominacion, R.GoesTo,C.ID, C.Nombre FROM Regalos AS R FULL JOIN Criaturitas AS C ON R.GoesTO = C.ID

-- Subconsultas
--Ejemplo: Criaturitas que tienen algún regalo de tipo 'A'
-- Usando JOIN
SELECT C.Nombre FROM Regalos AS R 
	INNER JOIN Criaturitas AS C ON R.GoesTO = C.ID
	WHERE R.Tipo = 'A'

--Usando subconsultas
SELECT Nombre FROM Criaturitas
	WHERE ID IN (SELECT GoesTO FROM Regalos
					WHERE Tipo = 'A'
				)

--Ejemplo (NorthWind):  Nombres y precios de los productos de la categoría Dairy Products
USE NorthWind
GO
-- Usando JOIN
SELECT DISTINCT ProductName, UnitPrice FROM Products AS P 
	JOIN Categories AS C ON P.CategoryID = C.CategoryID
	WHERE C.CategoryName = 'Dairy Products'

-- Usando una subconsulta
SELECT DISTINCT ProductName, UnitPrice FROM Products
	WHERE  CategoryID IN (SELECT CategoryID FROM Categories 
							WHERE CategoryName = 'Dairy Products'
						)

-- En este caso, como la subconsulta devuelve una sola fila, podemos también usar =
SELECT DISTINCT ProductName, UnitPrice FROM Products 
	WHERE  CategoryID = (SELECT CategoryID FROM Categories 
							WHERE CategoryName = 'Dairy Products'
						)

-- Con EXISTS
SELECT DISTINCT ProductName, UnitPrice FROM Products AS P
	WHERE EXISTS (SELECT CategoryID FROM Categories AS C
							WHERE (P.CategoryID = C.CategoryID) AND (C.CategoryName = 'Dairy Products')
					)

-- Otro ejemplo con más tablas

-- Clientes que nos han comprado algún producto de la categoría Dairy Products
SELECT DISTINCT CompanyName, City, Country FROM Customers AS Cu
	JOIN Orders AS O ON Cu.CustomerID = O.CustomerID
	JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
	JOIN Products AS P ON OD.ProductID = P.ProductID
	JOIN Categories AS C ON P.CategoryID = C.CategoryID
	WHERE C.CategoryName = 'Dairy Products'

--Con un JOIN cambiado por subconsulta
SELECT DISTINCT CompanyName, City, Country FROM Customers AS Cu
	JOIN Orders AS O ON Cu.CustomerID = O.CustomerID
	JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
	WHERE OD.ProductID IN (SELECT P.ProductID FROM Products AS P 
		JOIN Categories AS C ON P.CategoryID = C.CategoryID
		WHERE C.CategoryName = 'Dairy Products')

--La misma subconsulta definida con With
WITH ProductosDairy (ProductID) AS (SELECT P.ProductID FROM Products AS P 
		JOIN Categories AS C ON P.CategoryID = C.CategoryID
		WHERE C.CategoryName = 'Dairy Products')
SELECT DISTINCT CompanyName, City, Country FROM Customers AS Cu
	JOIN Orders AS O ON Cu.CustomerID = O.CustomerID
	JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
	WHERE OD.ProductID IN (SELECT ProductID FROM ProductosDairy)