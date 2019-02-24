--Ejercicio 1
--Número de veces que ha actuado cada cantaor en cada festival de la provincia de Cádiz,
--incluyendo a los que no han actuado nunca


select CA.Nombre_Artistico, [Numero de veces] from F_Cantaores as CA
left join (select count( C.Nombre_Artistico) as [Numero de veces], C.Nombre_Artistico,  F.Provincia  from F_Cantaores as C
			inner join F_Festivales_Cantaores as FC
			on C.Codigo=FC.Cod_Cantaor
			inner join F_Festivales as F
			on FC.Cod_Festival=F.Cod 
			where F.Provincia ='CA'
			group by C.Nombre_Artistico, F.Provincia) as SUB

on CA.Nombre_Artistico=SUB.Nombre_Artistico



--Ejercicio 2
--Crea un nuevo palo llamado “Toná”.
--Haz que todos los cantaores que cantaban Bamberas o Peteneras canten Tonás. No utilices
--los códigos de los palos, sino sus nombres.

select * from F_Palos


--insert into F_Palos values('PI','Pixipilingui')

--insert into F_Palos_Cantaor 
--select Codigo, 'PI' from F_Cantaores as C
--inner join F_Palos_Cantaor as PC
--on C.Codigo=PC.Cod_cantaor
--inner join F_Palos as P
--on PC.Cod_Palo=P.Cod_Palo
--where P.Palo in ('Toná')

insert into F_Palos values('TO','Toná')

begin transaction prueba


insert into F_Palos_Cantaor 
select Codigo, 'TO' from F_Cantaores as C
inner join F_Palos_Cantaor as PC
on C.Codigo=PC.Cod_cantaor
inner join F_Palos as P
on PC.Cod_Palo=P.Cod_Palo
where P.Palo in ('Peteneras','Bamberas')

rollback

commit transaction prueba

select * from F_Palos_Cantaor





--Ejercicio 3
--Número de cantaores mayores de 30 años que han actuado cada año en cada peña. Se
--contará la edad que tenían en el año de la actuación.



select count(*) as [Numero de cantaores], P.Nombre, year(A.Fecha) as [Anno] from F_Cantaores as C
inner join F_Actua as A
on C.Codigo=A.Cod_Cantaor
inner join F_Penhas as P
on A.Cod_Penha=P.Codigo
where 30>= (year(A.Fecha)-Anno)
group by P.Nombre, year(A.Fecha)



--Ejercicio 4
--Cantaores (nombre, apellidos y nombre artístico) que hayan actuado más de dos veces en
--peñas de la provincia de Sevilla y canten Fandangos o Bulerías. Sólo se incluyen las
--actuaciones directas en Peñas, no los festivales.


select C.Nombre, C.Apellidos, C.Nombre_Artistico  from F_Cantaores as C
inner join F_Provincias as P
on C.Cod_Provincia=P.Cod_Provincia
inner join F_Penhas as PE
on P.Cod_Provincia = PE.Cod_provincia
inner join F_Palos_Cantaor as PC
on C.Codigo=PC.Cod_cantaor
inner join F_Palos as PA
on PC.Cod_Palo=PA.Palo
where PA.Palo in ('Bulerías','Fandangos de Huelva')





--Ejercicio 5
--Número de actuaciones que se han celebrado en cada peña, incluyendo actuaciones directas
--y en festivales. Incluye el nombre de la peña y la localidad.