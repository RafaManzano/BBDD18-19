USE Northwind
GO

--10. Producto superventas de cada a�o, indicando a�o, nombre del producto,
--categor�a y cifra total de ventas.
SELECT P.ProductID,P.ProductName,P.CategoryID,Definitivo.A�o,Definitivo.[Venta maxima] 
FROM Orders AS O

INNER JOIN [Order Details] AS OD ON O.OrderID=OD.OrderID
INNER JOIN Products AS P ON OD.ProductID=P.ProductID
INNER JOIN 
		(
			SELECT MaxProducto.A�o,MAX(MaxProducto.[Cifra de ventas]) AS [Venta maxima]
			FROM 
				(SELECT OD.ProductID,YEAR(O.OrderDate) AS [A�o],SUM(OD.Quantity) [Cifra de ventas] 
					FROM Orders AS O

					INNER JOIN [Order Details] AS OD 
					ON O.OrderID=OD.OrderID

					GROUP BY OD.ProductID,YEAR(O.OrderDate)
				) AS MaxProducto 

			GROUP BY MaxProducto.A�o

		) AS Definitivo 
		ON YEAR(O.OrderDate)=Definitivo.A�o 

GROUP BY  P.ProductID,P.ProductName,P.CategoryID,Definitivo.A�o,Definitivo.[Venta maxima]

HAVING SUM(OD.Quantity)=Definitivo.[Venta maxima]