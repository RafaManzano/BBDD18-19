--1.-Título y tipo de todos los libros en los que alguno de los autores vive en California (CA).
SELECT title,[type],state
	FROM titles AS T
	INNER JOIN titleauthor AS TA
		ON TA.title_id = T.title_id
	INNER JOIN authors AS A 
		ON A.au_id = TA.au_id
			WHERE [state] IN ('CA')

--2.-Título y tipo de todos los libros en los que ninguno de los autores vive en California (CA).
SELECT title,[type],state
	FROM titles AS T
	INNER JOIN titleauthor AS TA
		ON TA.title_id = T.title_id
	INNER JOIN authors AS A 
		ON A.au_id = TA.au_id
			WHERE [state] NOT IN ('CA')

--3.-Número de libros en los que ha participado cada autor, incluidos los que no han publicado nada.
SELECT A.au_fname, A.au_lname, COUNT(ta.title_id) AS [Número de libros escritos]
	FROM authors AS A
	LEFT JOIN titleauthor AS TA
		ON A.au_id=TA.au_id
			GROUP BY A.au_fname,A.au_lname

--4.-Número de libros que ha publicado cada editorial, incluidas las que no han publicado ninguno.
Select P.pub_name, COUNT(T.title_id) AS [Número de libros publicados]
	FROM publishers AS P
	LEFT JOIN titles AS T
		ON P.pub_id=T.pub_id
			GROUP BY P.pub_name

--5.-Número de empleados de cada editorial.
SELECT COUNT(emp_id) AS [Numero de empleados],P.pub_name
	FROM employee AS E
	FULL JOIN publishers AS P
		ON E.pub_id = P.pub_id
			GROUP BY P.pub_name

--6.-Calcular la relación entre número de ejemplares publicados y número de empleados de cada editorial,
--incluyendo el nombre de la misma.
Select P.pub_name,CAST(COUNT(DISTINCT T.title_id)AS REAL)/COUNT(DISTINCT E.emp_id) AS [Ejemplares publicados/Empleados]
	FROM publishers AS P
	INNER JOIN employee AS E
		ON P.pub_id = E.pub_id
	LEFT JOIN titles AS T
		ON T.pub_id = P.pub_id
			GROUP BY P.pub_name
			HAVING COUNT(DISTINCT E.emp_id)>0

--7.Nombre, Apellidos y ciudad de todos los autores que han trabajado para la editorial
--"Binnet & Hardley” o "Five Lakes Publishing”
SELECT A.au_fname, A.au_lname,A.[address]
	FROM authors AS A
	INNER JOIN titleauthor AS TA
		ON A.au_id = TA.au_id
	INNER JOIN titles AS T
		ON T.title_id = TA.title_id
	INNER JOIN publishers AS P
		ON P.pub_id = T.pub_id
			WHERE P.pub_name in ('Binnet & Hardley', 'Five Lakes Publishing')

		

--8.-Empleados que hayan trabajado en alguna editorial que haya publicado algún libro 
--en el que alguno de los autores fuera Marjorie Green o Michael O'Leary.
SELECT E.fname, E.lname
	FROM authors AS A
	INNER JOIN titleauthor AS TA
		ON A.au_id = TA.au_id
	INNER JOIN titles AS T
		ON TA.title_id = T.title_id
	INNER JOIN publishers AS P
		ON T.pub_id=P.pub_id
	INNER JOIN employee AS E
		ON p.pub_id=e.pub_id
		WHERE A.au_fname='Marjorie' AND A.au_lname='Green' OR A.au_fname='Michael' AND A.au_lname='O''Leary' 
			GROUP BY E.fname,E.lname
--9.-Número de ejemplares vendidos de cada libro, especificando el título y el tipo.
GO
CREATE VIEW [Ventas por libro] AS(
SELECT SUM(S.qty) AS [Cantidad], T.title, T.[type]
	FROM sales AS S
	INNER JOIN titles AS T
		ON S.title_id = T.title_id
	GROUP BY T.title,T.[type]
	)
GO

--10.  Número de ejemplares de todos sus libros que ha vendido cada autor.
SELECT A.au_fname, A.au_lname, SUM(Cantidad) AS [Total de libros vendidos]
	FROM authors AS A
	INNER JOIN titleauthor AS ta
		ON A.au_id = TA.au_id
	INNER JOIN titles AS T
		ON TA.title_id=T.title_id
	INNER JOIN [Ventas por libro] AS VPL
		ON T.title=VPL.title
	GROUP BY A.au_fname,A.au_lname

--11.  Número de empleados de cada categoría (jobs).
SELECT COUNT(emp_id) AS [Numero de empleados], job_desc AS [Categoria]
	FROM employee AS E
	right JOIN jobs AS J
		ON J.job_id = E.job_id
			GROUP BY job_desc

--12.  Número de empleados de cada categoría (jobs) que tiene cada editorial, incluyendo aquellas categorías en las que no haya ningún empleado.
SELECT P.pub_name AS [Nombre de la editorial], J.job_desc AS [Categoría], COUNT(E.job_id) AS [Numero de empleados]
	FROM publishers AS P
	CROSS JOIN jobs AS J
	LEFT JOIN employee as e
		ON P.pub_id = E.pub_id AND J.job_id = E.job_id
	GROUP BY P.pub_name,J.job_desc
	ORDER BY P.pub_name

--13.  Autores que han escrito libros de dos o más tipos diferentes
SELECT A.au_fname, A.au_lname
	FROM authors AS A
	INNER JOIN titleauthor AS TA
		ON A.au_id = TA.au_id
	INNER JOIN titles AS T
		ON TA.title_id = T.title_id
		GROUP BY A.au_fname, A.au_lname
		HAVING COUNT(DISTINCT T.[type]) >=2

--14.  Empleados que no trabajan actualmente en editoriales que han publicado libros 
--cuya columna notes contenga la palabra "and”.
SELECT E.fname, E.lname
	FROM employee AS E
	INNER JOIN publishers AS P
		ON E.pub_id = p.pub_id
	INNER JOIN titles AS T
		ON T.pub_id = P.pub_id
	WHERE notes LIKE ('%AND%')
	ORDER BY E.fname