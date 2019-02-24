USE Northwind
GO

--PRIMAVERA
DROP FUNCTION VentaProductoPrimavera
GO
CREATE FUNCTION VentaProductoPrimavera(@Producto varchar(10))
RETURNS TABLE AS
RETURN
(SELECT
	SUM(OD.Quantity) AS Valor
FROM
	Orders AS O
	INNER JOIN [Order Details] AS OD
	ON O.OrderID = OD.OrderID
	INNER JOIN Products AS P
	ON OD.ProductID = P.ProductID
WHERE
	((MONTH(O.OrderDate) IN (4,5))
	OR (MONTH(O.OrderDate) = 3 AND DAY(O.OrderDate) >= 22)
	OR (MONTH(O.OrderDate) = 6 AND DAY(O.OrderDate) <= 21))
	AND P.ProductName = @Producto)
GO

--VERANO
DROP FUNCTION VentaProductoVerano
GO
CREATE FUNCTION VentaProductoVerano(@Producto varchar(10))
RETURNS TABLE AS
RETURN
(SELECT
	SUM(OD.Quantity) AS Valor
FROM
	Orders AS O
	INNER JOIN [Order Details] AS OD
	ON O.OrderID = OD.OrderID
	INNER JOIN Products AS P
	ON OD.ProductID = P.ProductID
WHERE
	((MONTH(O.OrderDate) > 6 AND MONTH(O.OrderDate) < 9)
	OR (MONTH(O.OrderDate) = 6 AND DAY(O.OrderDate) >= 22)
	OR (MONTH(O.OrderDate) = 9 AND DAY(O.OrderDate) <= 21))
	AND P.ProductName = @Producto)

GO

--OTOÑO
DROP FUNCTION VentaProductoOtono
GO
CREATE FUNCTION VentaProductoOtono(@Producto varchar(10))
RETURNS TABLE AS
RETURN
(SELECT
	SUM(OD.Quantity) AS Valor
FROM
	Orders AS O
	INNER JOIN [Order Details] AS OD
	ON O.OrderID = OD.OrderID
	INNER JOIN Products AS P
	ON OD.ProductID = P.ProductID
WHERE
	((MONTH(O.OrderDate) > 9 AND MONTH(O.OrderDate) < 12)
	OR (MONTH(O.OrderDate) = 9 AND DAY(O.OrderDate) >= 22)
	OR (MONTH(O.OrderDate) = 12 AND DAY(O.OrderDate) <= 21))
	AND P.ProductName = @Producto)
GO

--INVIERNO
DROP FUNCTION VentaProductoInvierno
GO
CREATE FUNCTION VentaProductoInvierno(@Producto varchar(10))
RETURNS TABLE AS
RETURN
(SELECT
	SUM(OD.Quantity) AS Valor
FROM
	Orders AS O
	INNER JOIN [Order Details] AS OD
	ON O.OrderID = OD.OrderID
	INNER JOIN Products AS P
	ON OD.ProductID = P.ProductID
WHERE
	((MONTH(O.OrderDate) >= 1 AND MONTH(O.OrderDate) < 3)
	OR (MONTH(O.OrderDate) = 12 AND DAY(O.OrderDate) >= 22)
	OR (MONTH(O.OrderDate) = 3 AND DAY(O.OrderDate) <= 21))
	AND P.ProductName = @Producto)
GO

--FUNCIÓN PRINCIPAL
DROP FUNCTION VentaProductoEstaciones
GO
CREATE FUNCTION VentaProductoEstaciones(@Producto varchar(9))
RETURNS TABLE AS
RETURN
(SELECT 1 AS Orden, 'Primavera' AS [Estación], Valor AS [Productos Vendidos] FROM VentaProductoPrimavera('Chai')
UNION
SELECT 2, 'Verano', Valor FROM VentaProductoVerano(@Producto)
UNION
SELECT 3, 'Otoño', Valor FROM VentaProductoVerano(@Producto)
UNION
SELECT 4, 'Invierno', Valor FROM VentaProductoInvierno(@Producto))
GO

SELECT * FROM VentaProductoEstaciones('Chai')
