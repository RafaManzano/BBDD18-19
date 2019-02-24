use LeoMetro
go

--Ejercicio 1 
--Indica el n�mero de estaciones por las que pasa cada l�nea
select Tren,COUNT(*) as [Numero de Estaciones] from LM_Recorridos
group by Tren

--Ejercicio 2 
--Indica el n�mero de trenes diferentes que han circulado en cada l�nea
select L.ID,COUNT(distinct R.Tren) as [Numero de trenes diferentes] from LM_Lineas as L
inner join LM_Recorridos as R on L.ID=R.Linea
group by L.ID

--Ejercicio 3 
--Indica el n�mero medio de trenes de cada clase que pasan al d�a por cada estaci�n. 
select * from LM_Trenes

--La clase es el tipo

select E.Denominacion,T.Tipo,TrenesPorEstacion.ID, AVG(TrenesPorEstacion.[Numero Trenes]) as [Media] from LM_Estaciones as E
inner join LM_Recorridos as R on E.ID=R.estacion
inner join LM_Trenes as T on R.Tren=T.ID
inner join 
(
	select E.ID,DAY(R.Momento) as [D�a],COUNT(*) as [Numero Trenes] from LM_Estaciones as E
	inner join LM_Recorridos as R on E.ID=R.estacion
	inner join LM_Lineas as L on R.Linea=L.ID
	group by E.ID,DAY(R.Momento)
	--order by E.ID,DAY(R.Momento)
) as TrenesPorEstacion on E.ID=TrenesPorEstacion.ID
group by E.Denominacion,T.Tipo,TrenesPorEstacion.ID
																				
--Ejercicio 4 
--Calcula el tiempo necesario para recorrer una l�nea completa, contando con el tiempo estimado de cada itinerario 
--y considerando que cada parada en una estaci�n dura 30 s.

select * from LM_Lineas
go
--create view [NumeroDeEstacionesDeLineas] as	--cuento el numero de estaciones que tiene cada linea
--select I.Linea,count(*) as [Numero Estaciones] from LM_Itinerarios as I 
--inner join LM_Estaciones as E on I.estacionIni=E.ID	--I.NumOrden=E.ID
--group by I.Linea
--go


--con datepart obtengo el tiempo en minutos o en segundos
--con dateadd convierto de segundaos a horas y minutos

select Linea,
	DATEADD (SECOND , SUM((((DATEPART(MINUTE,TiempoEstimado)*60)+(DATEPART(SECOND,TiempoEstimado))))+30) , CONVERT(time,'0:0') )
	as [En segundos] 
from LM_Itinerarios
group by Linea	--El tiempo de cada itinerario

go
--Ejercicio 5 
--Indica el n�mero total de pasajeros que entran (a pie) cada d�a por cada estaci�n y los que salen del metro en la misma.

/*La siguente vista sirve para calcular el numero de pasajeros que han entrado en el metro cada dia*/
create view PersonasQueEntranAlDia as
select V.IDEstacionEntrada,YEAR(V.MomentoEntrada) as [A�o],MONTH(V.MomentoEntrada) as [Mes],DAY(V.MomentoEntrada) as [D�a],COUNT(T.IDPasajero) as [Cantidad de Personas Que Entran] from LM_Viajes as V
inner join LM_Tarjetas as T on V.IDTarjeta=T.ID
group by V.IDEstacionEntrada,YEAR(V.MomentoEntrada),MONTH(V.MomentoEntrada),DAY(V.MomentoEntrada)
go

/*La siguente vista sirve para calcular el numero de pasajeros que han salido del metro cada dia*/
create view PersonasQueSalenAlDia as
select V.IDEstacionSalida,YEAR(V.MomentoSalida) as [A�o],MONTH(V.MomentoSalida) as [Mes],DAY(V.MomentoSalida) as [D�a],COUNT(T.IDPasajero) as [Cantidad de Personas Que Entran] from LM_Viajes as V
inner join LM_Tarjetas as T on V.IDTarjeta=T.ID
group by V.IDEstacionSalida,YEAR(V.MomentoSalida),MONTH(V.MomentoSalida),DAY(V.MomentoSalida)
go

/*La siguente consulta sirve para calcular el numero total de pasajeros del metro cada dia*/
select PE.IDEstacionEntrada,PS.D�a,PE.[Cantidad de Personas Que Entran],PS.[Cantidad de Personas Que Entran] from PersonasQueEntranAlDia as PE 
inner join PersonasQueSalenAlDia as PS on PE.IDEstacionEntrada=PS.IDEstacionSalida and PE.D�a=PS.D�a and PE.Mes=PS.Mes and PE.A�o=PS.A�o
order by PE.IDEstacionEntrada,PS.D�a

--Ejercicio 6 
--Calcula la media de kil�metros al d�a que hace cada tren. Considera �nicamente los d�as que ha estado en servicio 
select ID,A�o,Mes,D�a,AVG([KM/Dia]) [Media de kil�metros] from 
	(
		select T.ID,YEAR( R.Momento) as [A�o],MONTH( R.Momento) as [Mes],DAY( R.Momento) as [D�a],SUM(I.Distancia) as [KM/Dia] from LM_Trenes AS T
		inner join LM_Recorridos as R on T.ID=R.Tren
		inner join LM_Itinerarios as I on R.Linea=I.Linea
		where R.Momento>T.FechaEntraServicio
		group by T.ID,YEAR(R.Momento),MONTH(R.Momento),DAY(R.Momento)
	) as RecorridoPorDia
group by ID,A�o,Mes,D�a

select * from LM_Itinerarios


select T.ID,YEAR( R.Momento) as [A�o],MONTH( R.Momento) as [Mes],DAY( R.Momento) as [D�a],SUM(I.Distancia) as [KM/Dia] from LM_Trenes AS T
inner join LM_Recorridos as R on T.ID=R.Tren
inner join LM_Itinerarios as I on R.Linea=I.Linea
where R.Momento>T.FechaEntraServicio
group by T.ID,YEAR(R.Momento),MONTH(R.Momento),DAY(R.Momento)

--Ejercicio 7 
--Calcula cu�l ha sido el intervalo de tiempo en que m�s personas registradas han estado en el metro al mismo tiempo. 
--Considera intervalos de una hora (de 12:00 a 12:59, de 13:00 a 13:59, etc). 
--Si hay varios momentos con el n�mero m�ximo de personas, muestra el m�s reciente.

--cantidad de personas a una hora en concreto
select E.ID,CAST(V.MomentoEntrada as time) as [Hora],COUNT(T.IDPasajero) [Cantiada de personas] from LM_Estaciones as E
inner join LM_Viajes as V on E.ID=V.IDEstacionEntrada
inner join LM_Tarjetas as T on V.IDTarjeta=T.ID
group by E.ID,CAST(V.MomentoEntrada as time)

--Ejercicio 8 
--Calcula el dinero gastado por cada usuario en el mes de febrero de 2017. El precio de un viaje es el de la zona m�s cara que incluya. 
--Incluye a los que no han viajado.

--drop view [ZonaDeEntrada] as--
--select T.IDPasajero,V.IDEstacionEntrada,ZP.Zona,ZP.Precio_Zona from LM_Viajes as V
--inner join LM_Estaciones as E on V.IDEstacionEntrada=E.ID
--inner join LM_Zona_Precios as ZP on E.Zona_Estacion=ZP.Zona
--inner join LM_Tarjetas as T on V.IDTarjeta=T.ID
--where MONTH(V.MomentoEntrada)=2 and YEAR(V.MomentoEntrada)=2017

--go
--drop view [ZonaDeSalida] as
--select T.IDPasajero,V.IDEstacionSalida,ZP.Zona,ZP.Precio_Zona from LM_Viajes as V
--inner join LM_Estaciones as E on V.IDEstacionSalida=E.ID
--inner join LM_Zona_Precios as ZP on E.Zona_Estacion=ZP.Zona
--inner join LM_Tarjetas as T on V.IDTarjeta=T.ID
--where MONTH(V.MomentoSalida)=2 and YEAR(V.MomentoSalida)=2017
--go

select T.IDPasajero,SUM(V.Importe_Viaje) as [Precio maximo] from LM_Viajes as V
right join LM_Tarjetas as T on V.IDTarjeta=T.ID
where MONTH(V.MomentoEntrada)=2 and YEAR(V.MomentoEntrada)=2017
group by T.IDPasajero,V.Importe_Viaje

--Ejercicio 9 
--Calcula el tiempo medio diario que cada pasajero pasa en el sistema de metro y el n�mero de veces que accede al mismo.

--el tiempo medio y las veces accedidas en un dia
select TiempoMetroNumeroEntrada.IDPasajero,
	DATEADD(MINUTE,AVG(TiempoMetroNumeroEntrada.[Tiempo en Metro]),CONVERT(time,'0:0')) as [Tiempo Medio Diario],
	SUM(TiempoMetroNumeroEntrada.[Numero de Veces Entrados]) as [Veces Accedido]
from 
	(
	--el tiempo total en el metro y las veces que ha accedido en un dia
		select T.IDPasajero,YEAR(V.MomentoEntrada) as [A�o],MONTH(V.MomentoEntrada) as [Mes],DAY(V.MomentoEntrada) as [D�a],
				SUM(DATEDIFF(MINUTE,MomentoEntrada,MomentoSalida)) as [Tiempo en Metro],
				count(*) as [Numero de Veces Entrados] 
		from LM_Viajes as V
		inner join LM_Tarjetas as T on V.IDTarjeta=T.ID
		group by IDPasajero,YEAR(MomentoEntrada),MONTH(MomentoEntrada),DAY(MomentoEntrada)
	) as TiempoMetroNumeroEntrada
group by TiempoMetroNumeroEntrada.IDPasajero,TiempoMetroNumeroEntrada.D�a,TiempoMetroNumeroEntrada.[Numero de Veces Entrados]
order by TiempoMetroNumeroEntrada.IDPasajero