USE pubs

--1. Numero de libros que tratan de cada tema
SELECT * FROM titles

SELECT [type], COUNT(*) AS NumberOfBooks FROM titles
GROUP BY type

--2. Número de autores diferentes en cada ciudad y estado
SELECT * FROM authors

SELECT DISTINCT [state], city ,COUNT(au_id) AS NumberOfAuthors FROM authors
GROUP BY [state], city

--3. Nombre, apellidos, nivel y antigüedad en la empresa de los empleados con un nivel entre 100 y 150.
SELECT * FROM employee

SELECT fname, lname, YEAR(CURRENT_TIMESTAMP - hire_date) - 1900 AS Seniority FROM employee
WHERE job_lvl BETWEEN 100 AND 150

--4. Número de editoriales en cada país. Incluye el país.
SELECT * FROM publishers

SELECT COUNT(*) AS NumberOfPublishers, country FROM publishers
GROUP BY country

--5. Número de unidades vendidas de cada libro en cada año (title_id, unidades y año).
SELECT * FROM sales

SELECT SUM(qty) AS Units, title_id, YEAR(ord_date) AS [Year]  FROM sales
GROUP BY title_id, YEAR(ord_date) 

--6. Número de autores que han escrito cada libro (title_id y numero de autores).
SELECT * FROM titleauthor

SELECT title_id, COUNT(au_id) AS NumberOfAuthors FROM titleauthor
GROUP BY title_id

--7. ID, Titulo, tipo y precio de los libros cuyo adelanto inicial (advance) tenga un valor superior a $7.000, ordenado por tipo y título
SELECT * FROM titles

SELECT title_id, title, [type], price FROM titles
WHERE advance > 7000
ORDER BY [type], title