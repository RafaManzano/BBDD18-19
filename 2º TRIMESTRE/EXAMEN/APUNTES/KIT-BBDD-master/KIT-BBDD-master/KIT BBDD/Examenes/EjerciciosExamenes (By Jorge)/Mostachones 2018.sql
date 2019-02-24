-- Dinero total gastado por el cliente "Paco Merselo"

select sum(P.Importe) as [Cantidad total] from TMClientes as C
inner join TMPedidos as P
on C.ID=P.IDCliente
where C.Nombre = 'Paco' and C.Apellidos = 'Merselo' 



-- Dinero total gastado en complementos por el cliente "Paco Merselo"

select sum(CO.Importe*PC.Cantidad) as [Cantidad total] from TMClientes as C
inner join TMPedidos as P
on C.ID=P.IDCliente
inner join TMPedidosComplementos as PC
on P.ID=PC.IDPedido
inner join TMComplementos as CO
on PC.IDComplemento=CO.ID
where C.Nombre = 'Paco' and C.Apellidos = 'Merselo'




-- Tiempo medio transcurrido (en minutos) entre la hora de envío y de llegada de los pedidos de la 
-- repartidora "Ana Conda" entre los meses 3 y 7 del año 2017

select avg(datediff(minute ,Recibido, Enviado)) as [Media en minutos]  from TMPedidos as P 
inner join TMRepartidores as R
on P.IDRepartidor=R.ID
where R.Nombre = 'Ana' and R.Apellidos = 'Conda' --Añadir el mes




/* Numero de mostachones de cada tipo que ha comprado el cliente Armando Bronca Segura*/

select count(M.ID)as [Cantidad de mostachones], TM.Harina  from TMClientes as C
inner join TMPedidos as P
on C.ID=P.IDCliente
inner join TMMostachones as M
on P.ID=M.IDPedido
inner join TMTiposMostachon as TM
on M.Harina = TM.Harina
where C.Nombre = 'Armando' and C.Apellidos = 'Bronca Segura' 
group by TM.Harina




--Mes de mayor recaudacion de cada establecimiento durante el año 2015, cuanto han recaudado ese mes y que porcentaje de la recaudacion anual 
--es la recaudacion de ese mes, mostrando el nombre de cada establecimiento, ordenado de mayor a menor porcentaje de ganancia de ese mes respecto 
--a las ganancias anuales, mostrando el nombre del mes

go

create view [Ganancias en meses 2015] as

select E.ID, sum(P.Importe) as [Ganancias en 2015], month(P.Enviado) as [Mes] from TMEstablecimientos as E
inner join TMPedidos as P
on E.ID=P.IDEstablecimiento
where year(P.Enviado) = 2015
group by E.ID, month(P.Enviado) 

go


select G.ID, E.Denominacion, [Best of 2015]  from [Ganancias en meses 2015] as G
inner join (select max([Ganancias en 2015])as [Best of 2015], ID from [Ganancias en meses 2015]
			group by ID) as GTOP
on G.ID=GTOP.ID and G.[Ganancias en 2015]=GTOP.[Best of 2015]
inner join TMEstablecimientos as E
on G.ID=E.ID		 


