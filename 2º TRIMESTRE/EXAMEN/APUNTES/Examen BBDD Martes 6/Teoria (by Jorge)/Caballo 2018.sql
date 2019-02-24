

--El nombre completo de cada jugador que haya apostado a algun caballo que haya nacido en 2009 
--y haya obtenido mas victorias
go
alter view masVictorias2009 as

select ID, count(ID) as [Numero de victorias], Nombre from LTCaballos as C
inner join LTCaballosCarreras as CC on C.ID=CC.IDCaballo
where year(FechaNacimiento) = '2009' and (CC.Posicion between 1 and 2)
group by Nombre, ID 

go

select J.Nombre, J.Apellidos  from LTJugadores as J
inner join LTApuestas as A on J.ID=A.IDJugador
inner join masVictorias2009 as V09 on A.IDCaballo=V09.ID
where V09.[Numero de victorias] = (select max([Numero de victorias]) from masVictorias2009)


--Nombre del hipodromo donde se haya hecho la apuesta mas grande a un caballo que llevase numero par

go

alter view ApuestaMasGrandeNumeroPar as

select max(A.Importe) as [Apuestaza]  from LTApuestas as A
inner join LTCaballosCarreras as CC on A.IDCaballo=CC.IDCaballo and A.IDCarrera=CC.IDCarrera
where (CC.Numero%2=0)

go

select C.Hipodromo  from LTApuestas as A
inner join LTCarreras as C on A.IDCarrera=C.ID
inner join ApuestaMasGrandeNumeroPar as AP on A.Importe=AP.[Apuestaza]







--Precio del los primeros premios (El dinero que se ha llevado quien ha ganado) que se hayan ganado en las 
--segundas carreras del Gran Hipodromo de Andalucia 

select (A.Importe*CC.Premio1)as[Primer premio] from LTApuestas as A
inner join LTCaballosCarreras as CC on A.IDCaballo=CC.IDCaballo and A.IDCarrera=CC.IDCarrera
inner join LTCarreras as C on A.IDCarrera=C.ID
where CC.Posicion=1 and C.NumOrden= 2 and C.Hipodromo='Gran Hipodromo de Andalucia' 




 






