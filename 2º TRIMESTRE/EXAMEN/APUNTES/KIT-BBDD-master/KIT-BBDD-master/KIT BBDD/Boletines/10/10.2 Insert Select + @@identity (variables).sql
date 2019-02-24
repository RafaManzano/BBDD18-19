--1 Inserta un nuevo cliente.
	
	select * from Customers

	insert into Customers
	values ('PEFER','Pepote Productions','Pepe Fernandez','Owner','C/Detras tuya N 1*1','Ikea',null,'958575','Somewhere','854525655','55-5-55')

	

--2 Véndele (hoy) tres unidades de "Pavlova”, diez de "Inlagd Sill” y 25 de "Filo Mix”. 
-- El distribuidor será Speedy Express y el vendedor Laura Callahan.
	
	select * from Orders
	select * from [Order Details]

	begin transaction venta

	declare @id int

	insert into Orders
	select C.CustomerID, E.EmployeeID, CURRENT_TIMESTAMP, null, null, S.ShipperID, 0, S.CompanyName, C.Address, C.City, 
	null, C.PostalCode, C.Country from Shippers as S
	cross join Customers as C
	cross join Employees as E
	where C.ContactName='Pepe Fernandez' and (E.FirstName='Laura' and E.LastName='Callahan') and S.CompanyName='Speedy Express'


	set @id = @@IDENTITY

	insert into [Order Details]
	select @id, ProductID, UnitPrice, 3 , 0  from Products
	where (ProductName='Pavlova')

	insert into [Order Details]
	select @id, ProductID, UnitPrice, 10 , 0  from Products
	where (ProductName='Inlagd Sill')

	insert into [Order Details]
	select @id, ProductID, UnitPrice, 25 , 0  from Products
	where (ProductName='Filo Mix')
	
--	rollback
	
	commit transaction venta
	
 




--3 Ante la bajada de ventas producida por la crisis, hemos de adaptar nuestros precios según las siguientes reglas:
--		Los productos de la categoría de bebidas (Beverages) que cuesten más de $10 reducen su precio en un dólar.
--		Los productos de la categoría Lácteos que cuesten más de $5 reducen su precio en un 10%.
--		Los productos de los que se hayan vendido menos de 200 unidades en el último año, reducen su precio en un 5%


--4 Inserta un nuevo vendedor llamado Michael Trump. Asígnale los territorios de Louisville, Phoenix, Santa Cruz y Atlanta.


--5 Haz que las ventas del año 97 de Robert King que haya hecho a clientes de los estados de California y Texas se le asignen al nuevo empleado.


--6 Inserta un nuevo producto con los siguientes datos:
--		ProductID: 90
--		ProductName: Nesquick Power Max
--		SupplierID: 12
--		CategoryID: 3
--		QuantityPerUnit: 10 x 300g
--		UnitPrice: 2,40
--		UnitsInStock: 38
--		UnitsOnOrder: 0
--		ReorderLevel: 0
--		Discontinued: 0


--7 Inserta un nuevo producto con los siguientes datos:
--		ProductID: 91
--		ProductName: Mecca Cola
--		SupplierID: 1
--		CategoryID: 1
--		QuantityPerUnit: 6 x 75 cl
--		UnitPrice: 7,35
--		UnitsInStock: 14
--		UnitsOnOrder: 0
--		ReorderLevel: 0
--		Discontinued: 0


--8 Todos los que han comprado "Outback Lager" han comprado cinco años después la misma cantidad de Mecca Cola al mismo vendedor

--9 El pasado 20 de enero, Margaret Peacock consiguió vender una caja de Nesquick Power Max a todos los clientes que le habían 
--comprado algo anteriormente. Los datos de envío (dirección, transportista, etc) 
--son los mismos de alguna de sus ventas anteriores a ese cliente).