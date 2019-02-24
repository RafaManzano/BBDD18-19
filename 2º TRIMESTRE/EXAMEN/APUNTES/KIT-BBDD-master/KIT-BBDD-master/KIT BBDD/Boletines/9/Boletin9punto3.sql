--1. Título y tipo de todos los libros en los que alguno de los autores vive en California (CA).
SELECT * FROM titles
SELECT * FROM titleauthor
SELECT * FROM authors

SELECT title, [type], [state]
	FROM titles AS t
	INNER JOIN titleauthor AS ta
	ON t.title_id = ta.title_id
	INNER JOIN authors AS a
	ON ta.au_id = a.au_id
		WHERE [state] IN ('CA')

--2. Título y tipo de todos los libros en los que ninguno de los autores vive en California (CA).

/*1) Buscamos cuales son todos los que viven en California.
  2) Hacemos esa misma consulta pero sin WHERE (para verlos todos vamoh)
  3) Hacemos un EXCEPT entre la colsulta donde salen todos (paso 2) y la consulta donde solo salen los que viven en California (paso 1)*/

SELECT * FROM titles
SELECT * FROM titleauthor
SELECT * FROM authors

SELECT title, [type], [state] --SELECT para saber todos los autores sin tener en cuenta la condición de California (que van a salir todos los autores vamoh)
	FROM titles AS t
	INNER JOIN titleauthor AS ta
	ON t.title_id = ta.title_id
	INNER JOIN authors AS a
	ON ta.au_id = a.au_id

EXCEPT

SELECT title, [type], [state]  --SELECT para saber todos los que viven en california
	FROM titles AS t
	INNER JOIN titleauthor AS ta
	ON t.title_id = ta.title_id
	INNER JOIN authors AS a
	ON ta.au_id = a.au_id
		WHERE [state] IN ('CA')

--3. Número de libros en los que ha participado cada autor, incluidos los que no han publicado nada.
SELECT * FROM titles
SELECT * FROM titleauthor
SELECT * FROM authors

--SELECT au_fname, au_lname FROM authors

GO
ALTER VIEW AutoresPorLibros AS 
SELECT COUNT(t.title) AS [Número de libros escritos], a.au_fname, a.au_lname
	FROM titles AS t
	INNER JOIN titleauthor AS ta
	ON t.title_id = ta.title_id
	INNER JOIN authors AS a
	ON ta.au_id = a.au_id
		GROUP BY a.au_fname, a.au_lname
GO

SELECT Autores.au_fname, Autores.au_lname, AxL.[Número de libros escritos]
	FROM (SELECT au_fname, au_lname FROM authors) AS [Autores]
	LEFT JOIN AutoresPorLibros AS AxL
	ON Autores.au_fname = AxL.au_fname AND Autores.au_lname = AxL.au_lname

--4. Número de libros que ha publicado cada editorial, incluidas las que no han publicado ninguno.
SELECT * FROM publishers
SELECT * FROM titles

SELECT pub_name FROM publishers

SELECT p.pub_name, COUNT(t.title) AS [Número de libros publicados]
	FROM publishers AS p
	INNER JOIN titles AS t
	ON p.pub_id= t.pub_id
		GROUP BY p.pub_name

SELECT Editoriales.pub_name, [Libros publicados].[Número de libros publicados] 
	FROM (SELECT pub_name FROM publishers) AS [Editoriales]
	LEFT JOIN (SELECT p.pub_name, COUNT(t.title) AS [Número de libros publicados]
					FROM publishers AS p
					INNER JOIN titles AS t
					ON p.pub_id = t.pub_id
						GROUP BY p.pub_name) AS [Libros publicados]
	ON Editoriales.pub_name = [Libros publicados].pub_name

--5. Número de empleados de cada editorial.
SELECT * FROM publishers
SELECT * FROM employee

SELECT p.pub_name, COUNT(e.emp_id) AS [Número de empleados]
	FROM publishers AS p
	INNER JOIN employee AS e
	ON p.pub_id = e.pub_id
		GROUP BY p.pub_name

--6. Calcular la relación entre número de ejemplares publicados y número de empleados de cada editorial, incluyendo el nombre de la misma.

--NI IDEA DE COMO HACER ESTO.

--7. Nombre, Apellidos y ciudad de todos los autores que han trabajado para la editorial "Binnet & Hardley” o "Five Lakes Publishing”.
SELECT * FROM titles
SELECT * FROM titleauthor
SELECT * FROM authors
SELECT * FROM publishers

SELECT DISTINCT a.au_fname, a.au_lname, a.city 
	FROM authors AS a
	INNER JOIN titleauthor AS ta
	ON a.au_id = ta.au_id
	INNER JOIN titles AS t
	ON ta.title_id = t.title_id
	INNER JOIN publishers AS p
	ON t.pub_id = p.pub_id
		WHERE p.pub_name IN ('Binnet & Hardley', 'Five Lakes Publishing')

--8. Empleados que hayan trabajado en alguna editorial que haya publicado algún libro en el que alguno de los autores fuera Marjorie Green o Michael O'Leary.
SELECT * FROM employee
SELECT * FROM publishers
SELECT * FROM titles
SELECT * FROM titleauthor
SELECT * FROM authors

SELECT DISTINCT e.fname, e.lname
	FROM authors AS a
	INNER JOIN titleauthor AS ta
	ON a.au_id = ta.au_id
	INNER JOIN titles AS t
	ON ta.title_id = t.title_id
	INNER JOIN publishers AS p
	ON t.pub_id = p.pub_id
	INNER JOIN employee AS e
	ON p.pub_id = e.pub_id 
		WHERE (a.au_fname = 'Marjorie' AND a.au_lname = 'Green') OR (a.au_fname = 'Michael' AND a.au_lname = 'O''Leary')

--9. Número de ejemplares vendidos de cada libro, especificando el título y el tipo.
SELECT * FROM sales
SELECT * FROM titles

SELECT t.title, t.[type], COUNT(s.qty) AS [Número de ejemplares vendidos]
	FROM sales AS s
	INNER JOIN titles AS t
	ON s.title_id = t.title_id
		GROUP BY t.title, t.[type]

--10. Número de ejemplares de todos sus libros que ha vendido cada autor.
SELECT * FROM sales
SELECT * FROM titles
SELECT * FROM titleauthor
SELECT * FROM authors

SELECT a.au_fname, a.au_lname, COUNT(s.qty) AS [Número de ejemplares vendidos]
	FROM sales AS s
	INNER JOIN titles AS t
	ON s.title_id = t.title_id
	INNER JOIN titleauthor AS ta
	ON t.title_id = ta.title_id
	INNER JOIN authors AS a
	ON ta.au_id = a.au_id
		GROUP BY a.au_fname, a.au_lname

--11. Número de empleados de cada categoría (jobs).
SELECT * FROM employee
SELECT * FROM jobs

SELECT COUNT(e.emp_id) AS [Número de empleados], j.job_desc
	FROM employee AS e
	INNER JOIN jobs AS j
	ON e.job_id = j.job_id
		GROUP BY j.job_desc
		ORDER BY COUNT(e.emp_id)

--12. Número de empleados de cada categoría (jobs) que tiene cada editorial, incluyendo aquellas categorías en las que no haya ningún empleado.
SELECT * FROM jobs
SELECT * FROM employee
SELECT * FROM publishers

/*SELECT job_desc FROM jobs

SELECT Count(e.emp_id) AS [Número de empleados], j.job_desc, p.pub_name
	FROM jobs AS j
	INNER JOIN employee AS e
	ON j.job_id = e.job_id
	INNER JOIN publishers AS p
	ON e.pub_id = p.pub_id
		GROUP BY p.pub_name, j.job_desc*/

SELECT [Lo demás].pub_name, [Categorias trabajos].job_desc, [Lo demás].[Número de empleados]
	FROM (SELECT job_desc FROM jobs) AS [Categorias trabajos]
	LEFT JOIN (SELECT Count(e.emp_id) AS [Número de empleados], j.job_desc, p.pub_name
					FROM jobs AS j
					INNER JOIN employee AS e
					ON j.job_id = e.job_id
					INNER JOIN publishers AS p
					ON e.pub_id = p.pub_id
						GROUP BY p.pub_name, j.job_desc) AS [Lo demás]
	ON [Categorias trabajos].job_desc = [Lo demás].job_desc
	ORDER BY [Lo demás].pub_name

--13. Autores que han escrito libros de dos o más tipos diferentes
SELECT * FROM authors
SELECT * FROM titleauthor
SELECT * FROM titles

SELECT a.au_fname, a.au_lname, COUNT(t.[type]) AS [Número de tipos]
	FROM authors AS a
	INNER JOIN titleauthor AS ta
	ON a.au_id = ta.au_id
	INNER JOIN titles AS t
	ON ta.title_id = t.title_id
		GROUP BY a.au_id, a.au_fname, a.au_lname

SELECT * FROM (SELECT a.au_fname, a.au_lname, COUNT(t.[type]) AS [Número de tipos]
					FROM authors AS a
					INNER JOIN titleauthor AS ta
					ON a.au_id = ta.au_id
					INNER JOIN titles AS t
					ON ta.title_id = t.title_id
						GROUP BY a.au_id, a.au_fname, a.au_lname) AS [Autores y Tipos]
	WHERE [Autores y Tipos].[Número de tipos] >= 2

--14. Empleados que no trabajan actualmente en editoriales que han publicado libros cuya columna notes contenga la palabra "and”.
SELECT * FROM employee
SELECT * FROM publishers
SELECT * FROM titles

SELECT e.fname, e.lname
	FROM employee AS e
	INNER JOIN publishers AS p
	ON e.pub_id = p.pub_id
	INNER JOIN titles AS t
	ON p.pub_id = t.pub_id
		WHERE (t.notes LIKE '%and%')