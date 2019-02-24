--1. Numero de libros que tratan de cada tema

select count(title_id) as [Numero de libros], type from titles
group by type


--2. Número de autores diferentes en cada ciudad y estado

select count(distinct au_id) as [Numero de autores], city, state from authors
group by city, state

--3. Nombre, apellidos, nivel y antigüedad en la empresa de los empleados con un nivel entre 100 y 150.

select fname, lname, job_lvl, (year(current_timestamp - hire_date)-1900)as[Antiguedad] from employee
where job_lvl between 100 and 150--pepino

--4. Número de editoriales en cada país. Incluye el país.

select count(pub_id) as [Numero de editoriales], country from publishers
group by country


--5. Número de unidades vendidas de cada libro en cada año (title_id, unidades y año).

select title_id, sum(qty) as [Numero de unidades vendidas], year(ord_date)as [Años]  from sales
group by title_id, year(ord_date)

--Añadimos el nombre del libro para hacer la consulta mas clara

select s.title_id, t.title, sum(s.qty) as [Numero de unidades vendidas], year(s.ord_date)as [Años]  from sales as s
inner join titles as t
on s.title_id=t.title_id
group by s.title_id, year(s.ord_date), t.title



--6. Número de autores que han escrito cada libro (title_id y numero de autores).

select title_id, count(au_ord) as [Numero de autores] from titleauthor
group by  title_id


--Añadimos el nombre del libro para hacer la consulta mas clara

select ta.title_id, t.title, count(ta.au_ord) as [Numero de autores] from titleauthor as ta
inner join titles as t
on ta.title_id = t.title_id
group by  ta.title_id, t.title



--7. ID, Titulo, tipo y precio de los libros cuyo adelanto inicial (advance) tenga un valor superior a $7.000, ordenado por tipo y título

select title_id, title,type, price from titles
where advance > 7000 
order by type, title

