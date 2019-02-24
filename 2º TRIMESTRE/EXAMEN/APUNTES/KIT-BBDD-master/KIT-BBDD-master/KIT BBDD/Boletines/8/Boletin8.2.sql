--Boletin 8.2
--Consultas sobre una sola Tabla con agregados
USE pubs

--1. Numero de libros que tratan de cada tema
SELECT type, COUNT(type) AS [Numero de libros]
FROM titles
GROUP BY type

--2. Numero de autores diferentes en cada ciudad y estado
SELECT COUNT(au_id) AS [Numero de autores], city, state
FROM authors
GROUP BY city, state

--3. Nombre, apellidos, nivel y antigüedad en la empresa de los empleados con un nivel entre 100 y 150.
SELECT fname, lname, job_lvl, YEAR(CURRENT_TIMESTAMP) - YEAR(hire_date) AS Antiguedad
FROM employee
WHERE job_lvl BETWEEN 100 AND 150

--4. Numero de editoriales en cada país. Incluye el país.
SELECT COUNT(pub_id), country
FROM publishers
GROUP BY country

--5. Numero de unidades vendidas de cada libro en cada año (title_id, unidades y año).
SELECT title_id, SUM(qty) AS [Numero de unidades vendidas], YEAR(ord_date) AS Anio
FROM sales
GROUP BY title_id, YEAR(ord_date)

--6. Numero de autores que han escrito cada libro (title_id y numero de autores).
SELECT title_id, COUNT(au_id) AS [Numero de autores]
FROM titleauthor
GROUP BY title_id
ORDER BY COUNT(au_id) DESC


--7. ID, Titulo, tipo y precio de los libros cuyo adelanto inicial (advance) tenga un valor superior a $7.000,
--   ordenado por tipo y titulo
SELECT title_id, type, price
FROM titles
WHERE advance > 7000
ORDER BY type, title_id