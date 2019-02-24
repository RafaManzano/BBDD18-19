USE  Northwind

 -- 1. Número de clientes de cada país.

SELECT 
	ShipCountry as cliente,
	COUNT(shipCountry) as pais
FROM 
	Orders
GROUP BY
	ShipCountry,
	CustomerID

 -- 2. Número de clientes diferentes que compran cada producto.

SELECT
	COUNT(CustomerID) as numero,
	ProductName as producto
FROM
	Orders as O
JOIN
	[Order Details] as OD
ON
	o.OrderID=OD.OrderID
JOIN
	Products as P
	
ON
	OD.ProductID=P.ProductID

GROUP BY
	productname, CustomerID

 -- 3. Número de países diferentes en los que se vende cada producto.

 SELECT
 FROM 
	

 -- 4. Empleados que han vendido alguna vez “Gudbrandsdalsost”, “Lakkalikööri”,
 -- “Tourtière” o “Boston Crab Meat”.

 -- 5. Empleados que no han vendido nunca “Chartreuse verte” ni “Ravioli Angelo”.

 -- 6. Número de unidades de cada categoría de producto que ha vendido cada
 -- empleado.

 -- 7. Total de ventas (US$) de cada categoría en el año 97.

 -- 8. Productos que han comprado más de un cliente del mismo país, indicando el
 -- nombre del producto, el país y el número de clientes distintos de ese país que
 -- lo han comprado.

 -- 9. Total de ventas (US$) en cada país cada año.

 -- 10. Producto superventas de cada año, indicando año, nombre del producto,
 -- categoría y cifra total de ventas.

 -- 11. Cifra de ventas de cada producto en el año 97 y su aumento o disminución
 -- respecto al año anterior en US $ y en %.

 -- 12. Mejor cliente (el que más nos compra) de cada país.

 -- 13. Número de productos diferentes que nos compra cada cliente.

 -- 14. Clientes que nos compran más de cinco productos diferentes.

 -- 15. Vendedores que han vendido una mayor cantidad que la media en US $ en el
 -- año 97.
 
 -- 16. Empleados que hayan aumentado su cifra de ventas más de un 10% entre dos
 -- años consecutivos, indicando el año en que se produjo el aumento.