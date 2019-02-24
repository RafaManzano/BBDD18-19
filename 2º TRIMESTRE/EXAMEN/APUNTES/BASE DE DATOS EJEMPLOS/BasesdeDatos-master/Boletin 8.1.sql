Use Northwind
go

--1. Nombre del pa�s y n�mero de clientes de cada pa�s, ordenados alfab�ticamente por el nombre del pa�s.

select Country
	  ,count(*) as [N�mero de Clientes]
from Customers
group by Country
order by Country
go

--2. ID de producto y n�mero de unidades vendidas de cada producto. 

select OD.ProductID
	  ,ProductName
	  ,sum(Quantity) as [Unidades Vendidas]

from [Order Details] as OD
inner join Products as P
on OD.ProductID=P.ProductID
group by OD.ProductID,P.ProductName
go

--3. ID del cliente y n�mero de pedidos que nos ha hecho.

select CustomerID
	  ,count(OrderID)
from Orders
group by CustomerID
go

--4. ID del cliente, a�o y n�mero de pedidos que nos ha hecho cada a�o.

select CustomerID
	  ,year(Orderdate) as A�o
	  ,count(OrderID) as [Numero de Pedidos]
from Orders
group by CustomerID,year(OrderDate)
order by CustomerID
go

--5. ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor. 
--Si hay varios precios unitarios para el mismo producto tomaremos el mayor.

Select ProductID
	  ,max(UnitPrice)
	  ,sum(Quantity*UnitPrice) as CantidadTotal
From [Order Details]
group by ProductID
order by CantidadTotal DESC
go

--6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor.

Select SupplierID
	  ,sum(UnitPrice*UnitsInStock) as [Importe total]
from Products
group by SupplierID
go

--7. N�mero de pedidos registrados mes a mes de cada a�o.

Select Count(OrderID) as [N�mero de Pedidos]
	  ,month(OrderDate) as Mes
	  ,YEAR(OrderDate) as A�o

from Orders
group by month(OrderDate),YEAR(OrderDate)
order by year(OrderDate),month(OrderDate)
go

--8. A�o y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en la que lo hemos enviado (ShipDate), 
--en d�as para cada a�o.

Select YEAR(OrderDate) as A�o
	  ,AVG(cast (ShippedDate-OrderDate as int)) as Media
from [Orders]
group by YEAR(OrderDate)
 
Select YEAR(OrderDate) as A�o
	  ,AVG(DATEDIFF(dd,OrderDate,ShippedDate)) as Media
from [Orders]
group by YEAR(OrderDate)
go
--9. ID del distribuidor y n�mero de pedidos enviados a trav�s de ese distribuidor.

Select ShipVia
	  ,COUNT(OrderID) as [Numero de Pedidos]
from Orders
group by ShipVia
go

--10. ID de cada proveedor y n�mero de productos distintos que nos suministra.

select SupplierID
	  ,COUNT(ProductID) as [N�mero de Productos]

from Products
group by SupplierID
go