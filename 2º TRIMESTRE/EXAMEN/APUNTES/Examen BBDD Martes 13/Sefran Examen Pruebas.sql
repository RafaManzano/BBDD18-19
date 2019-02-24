/* Ejercicios de práctica con base de datos del examen */

use TMPrueba
go

select * from TMBases
select * from TMClientes
select * from TMComplementos
select * from TMEstablecimientos
select * from TMMostachones
select * from TMMostachonesToppings
select * from TMPedidos
select * from TMPedidosComplementos
select * from TMRepartidores
select * from TMTiposMostachon
select * from TMToppings

/* Dinero total gastado por el cliente "Paco Merselo" */

select sum(P.Importe) as TotalGastado from TMPedidos as P
inner join TMClientes as C on P.IDCliente = C.ID
where C.Nombre = 'Paco' and C.Apellidos = 'Merselo'


/* Dinero gastado en complementos por el cliente "Paco Merselo" */

select sum(PC.Cantidad * Co.Importe) as [Total Gastado en Complementos] from TMClientes as C
inner join TMPedidos as P on C.ID = P.IDCliente
inner join TMPedidosComplementos as PC on P.ID = PC.IDPedido
inner join TMComplementos as Co on PC.IDComplemento = Co.ID
where C.Nombre = 'Paco' and C.Apellidos = 'Merselo'


-- Tiempo medio transcurrido (en minutos) entre la hora de envío y de llegada de los pedidos del 
--	repartidor "Ana Conda" entre los meses 3 y 7 del año 2017 

select avg(DATEDIFF(MINUTE,P.Recibido, P.Enviado)) as TiempoMedio from TMPedidos as P
inner join TMRepartidores as R on P.IDRepartidor = R.ID
where R.Nombre = 'Ana' and R.Apellidos = 'Conda' and year(P.Enviado) = 2017 and month(P.Enviado) between 3 and 7


-- Mes de mayor recaudacion de cada establecimiento durante el año 2015 y cantidad del mismo

select ImportePorMes.Denominacion, ImportePorMes.ImporteTotalMensual, ImportePorMes.Mes from (
	select ImportePorMes.Denominacion, max(ImportePorMes.ImporteTotalMensual) as ImporteMaximoAnual from (
		select E.Denominacion, month(P.Enviado) as Mes, sum(P.Importe) as ImporteTotalMensual from TMEstablecimientos as E
		inner join TMPedidos as P on E.ID = P.IDEstablecimiento
		where year(P.Enviado) = 2015
		group by E.Denominacion, month(P.Enviado)
		) as ImportePorMes
	group by ImportePorMes.Denominacion
	) as ImporteMaximo
inner join (
	select E.Denominacion, month(P.Enviado) as Mes, sum(P.Importe) as ImporteTotalMensual from TMEstablecimientos as E
	inner join TMPedidos as P on E.ID = P.IDEstablecimiento
	where year(P.Enviado) = 2015
	group by E.Denominacion, month(P.Enviado)
	) as ImportePorMes on ImporteMaximo.Denominacion = ImportePorMes.Denominacion 
	and ImporteMaximo.ImporteMaximoAnual = ImportePorMes.ImporteTotalMensual

/* Numero de mostachones de cada tipo que ha comprado el cliente Armando Bronca Segura*/

select M.Harina, count(M.Harina) as CantidadComprada from TMClientes as C
inner join TMPedidos as P on C.ID = P.IDCliente
inner join TMMostachones as M on P.ID = M.IDPedido
where C.Nombre = 'Armando' and C.Apellidos = 'Bronca Segura'
group by M.Harina

-- Inserta un nuevo cliente

insert into TMClientes
values (666, 'Sefran', 'Flowered', 'Calle Nosé', 'Sevilla', '666555444', null)

-- Añade un nuevo mostachón, el cual ha sido pedido por el nuevo cliente. 
-- Este mostachón está hecho de harina integral, tiene lacasitos y gominolas y se ha servido en base de aluminio.

begin transaction

insert into TMPedidos 
values (2501,CURRENT_TIMESTAMP, '2018-02-12 19:55:00', 666, 1, 32, 0.20)

insert into TMMostachones
values (6236, 2501, 'Aluminio', 'Integral')

insert into TMMostachonesToppings
values (6236,
	(select id from TMToppings
	where Topping = 'Lacasitos')
),
(6236,
	(select id from TMToppings
	where Topping = 'Gominolas')
)

-- commit transaction

rollback

-- Cambia el topping añadido en la insercción anterior de "Gominolas" por "Sirope"

begin transaction

update TMMostachonesToppings
set IDTopping = (
	select ID from TMToppings  
	where Topping = 'Sirope'
	)
where IDMostachon = 6236 and IDTopping = (
	select id from TMToppings
	where Topping = 'Gominolas'
)

rollback

-- Importe de los pedidos con topping de nata realizados en los establecimiento de Sevilla

select E.Denominacion ,sum(P.Importe) from TMEstablecimientos as E
inner join TMPedidos as P on E.ID = P.IDEstablecimiento
inner join TMMostachones as M on P.ID = M.IDPedido
inner join TMMostachonesToppings as MT on M.ID = MT.IDMostachon
inner join TMToppings as T on MT.IDTopping = T.ID
where T.Topping = 'Nata' and E.Ciudad = 'Sevilla'
group by  E.Denominacion 

-- Importe de cada establecimiento que tiene a su cargo 1 repartidor.
-- Mostrar el nombre del establecimiento

-- Sin nombre

select R.IDEstablecimiento, count(Distinct R.ID) as NumRepartidores, sum(P.Importe) as ImporteTotal from TMRepartidores as R
left join TMPedidos as P on R.ID = P.IDRepartidor
group by R.IDEstablecimiento
having count(Distinct R.ID) = 1

-- con nombre

select E.Denominacion, count(distinct R.ID) as NumRepartidores, sum(P.Importe) from TMEstablecimientos as E
left join TMRepartidores as R on E.ID = R.IDEstablecimiento
left join TMPedidos as P on R.ID = P.IDRepartidor
group by E.Denominacion
having count(Distinct R.ID) = 1