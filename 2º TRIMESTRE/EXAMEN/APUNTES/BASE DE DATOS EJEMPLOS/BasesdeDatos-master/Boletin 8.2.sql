--Consultas sobre una sola Tabla con agregados

--Escribe el c�digo SQL necesario para realizar las siguientes operaciones
--sobre la base de datos "pubs�
USE pubs
go

--1. Numero de libros que tratan de cada tema

select Type
	  ,count(*) as [Numero de libros]
from titles
group by type
go

--2. N�mero de autores diferentes en cada ciudad y estado

Select city
	  ,state
	  ,count(*) as Autores

from authors
group by city,state
go

--3. Nombre, apellidos, nivel y antig�edad en la empresa de los empleados con un nivel entre 100 y 150.

Select fname
	  ,lname
	  ,job_lvl
	  ,datediff(yyyy,hire_date,CURRENT_TIMESTAMP) as antig�edad

from employee
where (job_lvl between 100 and 150)
go
--4. N�mero de editoriales en cada pa�s. Incluye el pa�s.

select Country
	  ,count(*) as [Numero de editoriales]

from publishers
group by Country
go

--5. N�mero de unidades vendidas de cada libro en cada a�o (title_id, unidades y a�o).

select title_id
	  ,sum(qty) as [N�mero de unidades vendidas]
	  ,year(ord_date) as A�o

from sales
group by title_id,year(ord_date)
go

--6. N�mero de autores que han escrito cada libro (title_id y numero de autores).

select title_id
	  ,count(title_id) as [N�mero de autores por libro]

from titleauthor
group by title_id
go

--7. ID, Titulo, tipo y precio de los libros cuyo adelanto inicial (advance) tenga un valor superior a $7.000, ordenado por tipo y t�tulo

select title_id
	  ,title
	  ,type
	  ,price
from titles
where advance>7000
order by type,title
go