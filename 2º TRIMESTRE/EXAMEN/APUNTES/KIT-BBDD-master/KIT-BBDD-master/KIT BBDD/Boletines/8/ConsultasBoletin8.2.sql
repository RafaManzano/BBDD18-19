USE pubs

--1. Numero de libros que tratan de cada tema
SELECT type, COUNT(title_id) as NºLibrosPorTema FROM titles
	--WHERE
	GROUP BY type
	--HAVING
	--ORDER BY

--2. Número de autores diferentes en cada ciudad y estado
SELECT state, city, COUNT(au_id) as NumeroAutores FROM authors
	--WHERE
	GROUP BY state, city
	--HAVING
	ORDER BY state

--3. Nombre, apellidos, nivel y antigüedad en la empresa de los empleados con un nivel entre 100 y 150.
SELECT fname, lname, job_lvl, (YEAR(CURRENT_TIMESTAMP-hire_date)-1900) AS AñosAntigüedad FROM employee
	WHERE job_lvl BETWEEN 100 AND 150
	--GROUP BY 
	--HAVING
	--ORDER BY

--4. Número de editoriales en cada país. Incluye el país.
SELECT country, COUNT(pub_id) AS NumeroEditoriales FROM publishers
	--WHERE
	GROUP BY country
	--HAVING
	--ORDER BY

--5. Número de unidades vendidas de cada libro en cada año (title_id, unidades y año).
SELECT title_id, YEAR(ord_date) AS AñoVenta, SUM(qty) AS CantidadTotal  FROM sales
	--WHERE
	GROUP BY title_id, YEAR(ord_date)
	--HAVING
	--ORDER BY title_id, YEAR(ord_date)

--6. Número de autores que han escrito cada libro (title_id y numero de autores).
SELECT title_id, COUNT(au_id) AS numeroAutores FROM titleauthor
	--WHERE
	GROUP BY title_id
	--HAVING
	--ORDER BY

--7. ID, Titulo, tipo y precio de los libros cuyo adelanto inicial (advance) tenga un valor superior a $7.000, ordenado por tipo y título
SELECT title_id, title, type, price FROM titles
	WHERE advance>7000
	--GROUP BY
	--HAVING
	ORDER BY type, title
