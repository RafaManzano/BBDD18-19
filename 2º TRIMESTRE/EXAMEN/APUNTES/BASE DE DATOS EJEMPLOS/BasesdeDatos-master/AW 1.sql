--Bolet�n AW 1
--Escribe vistas que realicen las siguientes consultas sobre la base de datos Adventure Works. Puedes escribir otras vistas adicionales para ayudarte.
--Utiliza VISTAS para simplificar las consultas
Use AdventureWorks2012 --MIERDA
go
--1.Nombre y direcci�n completas de todos los clientes que tengan alguna sede en Canada.

Select *
from Sales.vStoreWithAddresses
where CountryRegionName in ('Canada')
order by BusinessEntityID

--2.Nombre de cada categor�a y producto m�s caro y m�s barato de la misma, incluyendo los precios.
go
create view [PreciosExtremosCategoria] as (
Select PC.Name as [Nombre de categor�a],
	   max(P.ListPrice) as [Precio m�s caro],
	   min(P.ListPrice) as [Precio m�s barato]
from Production.Product as P
inner join Production.ProductSubcategory as PS
on P.ProductSubcategoryID=PS.ProductSubcategoryID
inner join Production.ProductCategory as PC
on PS.ProductCategoryID=PC.ProductCategoryID
group by PC.Name
)
go
Select PEC.[Nombre de categor�a],
	   P.Name as [Nombre producto m�s caro],
	   PEC.[Precio m�s caro],
	   PMB.[Nombre producto m�s barato],
	   PEC.[Precio m�s barato]
from PreciosExtremosCategoria as PEC
inner join Production.ProductCategory as PC
on PEC.[Nombre de categor�a]=PC.Name
inner join Production.ProductSubcategory as PSC
on PC.ProductCategoryID=PSC.ProductCategoryID
inner join Production.Product as P
on PSC.ProductSubcategoryID=p.ProductSubcategoryID
inner join (
	Select PEC.[Nombre de categor�a],
		   P.Name as [Nombre producto m�s barato],
		   PEC.[Precio m�s barato]
	from PreciosExtremosCategoria as PEC
	inner join Production.ProductCategory as PC
	on PEC.[Nombre de categor�a]=PC.Name
	inner join Production.ProductSubcategory as PSC
	on PC.ProductCategoryID=PSC.ProductCategoryID
	inner join Production.Product as P
	on PSC.ProductSubcategoryID=p.ProductSubcategoryID
	where P.ListPrice=PEC.[Precio m�s barato]
) as PMB --Precio m�s barato
on PEC.[Nombre de categor�a]=PMB.[Nombre de categor�a]
where P.ListPrice=PEC.[Precio m�s caro]


--3.Total de Ventas en cada pa�s en dinero (Ya hecha en el bolet�n 9.3).
go
alter view [Ventas por Pais] as (
Select CR.Name as Pais,
	   sum(SOD.OrderQty*(SOD.UnitPrice*(1-SOD.UnitPriceDiscount))) as [Total Facturado ]
from Sales.SalesOrderHeader as SOH
inner join Sales.SalesOrderDetail as SOD
on SOH.SalesOrderID=SOD.SalesOrderID
inner join Sales.SalesTerritory as ST
on SOH.TerritoryID=ST.TerritoryID
inner join Person.CountryRegion as CR
on ST.CountryRegionCode=CR.CountryRegionCode
group by CR.Name
)
go

--4.N�mero de clientes que tenemos en cada pa�s. Contaremos cada direcci�n como si fuera un cliente distinto.
Select CR.Name,
	   count(BEA.AddressID) as [Numero de Clientes]
From Person.Person as P
inner join Person.BusinessEntityAddress as BEA
on P.BusinessEntityID=BEA.AddressID
inner join Person.Address as A
on BEA.AddressID=A.AddressID
inner join Person.StateProvince as SP
on A.StateProvinceID=SP.StateProvinceID
inner join Person.CountryRegion as CR
on SP.CountryRegionCode=CR.CountryRegionCode
group by CR.Name

--5.Repite la consulta anterior pero contando cada cliente una sola vez. Si el cliente tiene varias direcciones, 
--s�lo consideraremos aquella en la que nos haya comprado la �ltima vez.
go
Alter view [Ultima compra] as 
Select BEA.BusinessEntityID,
	  max(SOH.OrderDate) as [Fecha �ltima compra],
	  BEA.AddressID as Lugar
From Person.BusinessEntityAddress as BEA
inner join Person.Person as PP
on BEA.BusinessEntityID=PP.BusinessEntityID
inner join Sales.Customer as C
on PP.BusinessEntityID=C.CustomerID
inner join Sales.SalesOrderHeader as SOH
on C.CustomerID=SOH.CustomerID
inner join person.Address as A
on SOH.ShipToAddressID=A.AddressID
group by BEA.BusinessEntityID,BEA.AddressID
go


Select CR.Name,
	   count(BEA.BusinessEntityID) as [Numero de Clientes]
From Person.Person as P
inner join Person.BusinessEntityAddress as BEA
on P.BusinessEntityID=BEA.BusinessEntityID
inner join Person.Address as A
on BEA.AddressID=A.AddressID
inner join Person.StateProvince as SP
on A.StateProvinceID=SP.StateProvinceID
inner join Person.CountryRegion as CR
on SP.CountryRegionCode=CR.CountryRegionCode
where BEA.BusinessEntityID in ( Select BusinessEntityID from [Ultima compra]) 
and BEA.AddressID in (Select Lugar from [Ultima compra])
group by CR.Name
--6.Repite la consulta anterior pero en este caso si el cliente tiene varias direcciones, s�lo consideraremos aquella en la que nos 
--haya comprado m�s.
go
Alter View [Ventas por Direccion] as 
Select BEA.BusinessEntityID,
	  BEA.AddressID,
	  sum(SOD.OrderQty*(SOD.UnitPrice*(1-SOD.UnitPriceDiscount))) as [Total Facturado por Lugar]
From Person.BusinessEntityAddress as BEA
inner join Person.Person as PP
on BEA.BusinessEntityID=PP.BusinessEntityID
inner join Sales.Customer as C
on PP.BusinessEntityID=C.CustomerID
inner join Sales.SalesOrderHeader as SOH
on C.CustomerID=SOH.CustomerID
inner join Sales.SalesOrderDetail as SOD
on SOH.SalesOrderID=SOD.SalesOrderID
inner join person.Address as A
on SOH.ShipToAddressID=A.AddressID
group by BEA.BusinessEntityID,BEA.AddressID
go

Create view [Ventas Maximas] as 
Select BusinessEntityID,
	   AddressID,
	   max([Total Facturado por Lugar])
From [Ventas por Direccion]
go




Select CR.Name,
	   count(BEA.BusinessEntityID) as [Numero de Clientes]
From Person.Person as P
inner join Person.BusinessEntityAddress as BEA
on P.BusinessEntityID=BEA.BusinessEntityID
inner join Person.Address as A
on BEA.AddressID=A.AddressID
inner join Person.StateProvince as SP
on A.StateProvinceID=SP.StateProvinceID
inner join Person.CountryRegion as CR
on SP.CountryRegionCode=CR.CountryRegionCode
inner join [Ventas por Direccion] as VPD
on BEA.BusinessEntityID=VPD.BusinessEntityID
group by CR.Name



--7.Los tres pa�ses en los que m�s hemos vendido, incluyendo la cifra total de ventas y la fecha de la �ltima venta.

Select * from Sales.SalesOrderHeader
order by OrderDate desc

Select top 3
	   CR.Name as Pais,
	   sum(SOD.OrderQty*SOD.UnitPrice*(1-SOD.UnitPriceDiscount)) as [Total Ventas],
	   max(SOH.OrderDate) as [Fecha �ltima Venta]
from Sales.SalesOrderHeader as SOH
inner join Sales.SalesOrderDetail as SOD
on SOH.SalesOrderID=SOD.SalesOrderID
inner join Sales.SalesTerritory as ST
on SOH.TerritoryID=ST.TerritoryID
inner join Person.CountryRegion as CR
on ST.CountryRegionCode=CR.CountryRegionCode
group by CR.Name
order by  [Total Ventas] desc

--8.Sobre la consulta tres de ventas por pa�s, calcula el valor medio y repite la consulta tres pero incluyendo solamente los pa�ses 
--cuyas ventas est�n por encima de la media.


Select *
from [Ventas por Pais]
where [Total Facturado] >(
	Select sum([Total Facturado])/count(Pais) 
	from [Ventas por Pais]
	)



--9.Nombre de la categor�a y n�mero de clientes diferentes que han comprado productos de cada una.

Select PC.Name,
	   count(Distinct SOH.CustomerID) as [Clientes Diferentes]
from Production.ProductCategory as PC
inner join Production.ProductSubcategory as PS
on PC.ProductCategoryID=PS.ProductCategoryID
inner join Production.Product as P
on PS.ProductSubcategoryID=P.ProductSubcategoryID
inner join Sales.SalesOrderDetail as SOD
on P.ProductID=SOD.ProductID
inner join Sales.SalesOrderHeader as SOH
on SOD.SalesOrderID=SOH.SalesOrderID
group by PC.Name


--10.Clientes que nunca han comprado ninguna bicicleta (discriminarlas por categor�as)
go
alter view [Clientes no bicicletas] as (
Select PP.BusinessEntityID,
	   PP.FirstName,
	   PP.LastName
from Production.ProductCategory as PC
inner join Production.ProductSubcategory as PS
on PC.ProductCategoryID=PS.ProductCategoryID
inner join Production.Product as P
on PS.ProductSubcategoryID=P.ProductSubcategoryID
inner join Sales.SalesOrderDetail as SOD
on P.ProductID=SOD.ProductID
inner join Sales.SalesOrderHeader as SOH
on SOD.SalesOrderID=SOH.SalesOrderID
inner join Sales.Customer as C
on SOH.CustomerID=C.CustomerID
inner join Person.Person as PP
on C.PersonID=PP.BusinessEntityID
EXCEPT

Select PP.BusinessEntityID,
	   PP.FirstName,
	   PP.LastName
from Production.ProductCategory as PC
inner join Production.ProductSubcategory as PS
on PC.ProductCategoryID=PS.ProductCategoryID
inner join Production.Product as P
on PS.ProductSubcategoryID=P.ProductSubcategoryID
inner join Sales.SalesOrderDetail as SOD
on P.ProductID=SOD.ProductID
inner join Sales.SalesOrderHeader as SOH
on SOD.SalesOrderID=SOH.SalesOrderID
inner join Sales.Customer as C
on SOH.CustomerID=C.CustomerID
inner join Person.Person as PP
on C.PersonID=PP.BusinessEntityID
where PC.Name in ('Bikes')

)
go
--11.A la consulta anterior, a��dele el total de compras (en dinero) efectuadas por cada cliente.
Select *
from [Clientes no bicicletas]


Select P.FirstName,
	   P.LastName,
	   sum(SOD.OrderQty*SOD.UnitPrice*(1-SOD.UnitPriceDiscount)) as [Total de Compras]
from [Clientes no bicicletas] as P
inner join Sales.Customer as C
on P.BusinessEntityID=C.PersonID
inner join Sales.SalesOrderHeader as SOH
on C.CustomerID=SOH.CustomerID
inner join Sales.SalesOrderDetail as SOD
on SOH.SalesOrderID=SOD.SalesOrderID
group by P.Lastname,P.FirstName

