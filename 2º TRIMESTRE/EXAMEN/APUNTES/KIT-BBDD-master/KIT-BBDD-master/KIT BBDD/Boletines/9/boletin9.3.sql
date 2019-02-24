Use pubs

--1. Título y tipo de todos los libros en los que alguno de los autores vive en California (CA).

	SELECT
		title,
		type
	FROM titles AS T
	JOIN  titleauthor AS TA
	ON T.title_id=TA.title_id
	JOIN authors AS A
	ON TA.au_id=A.au_id
	WHERE 
		State LIKE ('CA')
	GROUP BY
		T.type,
		T.title

--2. Título y tipo de todos los libros en los que ninguno de los autores vive en California (CA).

	SELECT
		title,
		type
	FROM titles AS T
	JOIN  titleauthor AS TA
	ON T.title_id=TA.title_id
	JOIN authors AS A
	ON TA.au_id=A.au_id
	WHERE 
		State  NOT LIKE ('CA')
	GROUP BY
		T.type,
		T.title

--3. Número de libros en los que ha participado cada autor, incluidos los que no han publicado nada.

	SELECT *
	FROM authors AS A
	JOIN  titleauthor AS TA
	ON A.au_id=TA.au_id
	JOIN titles AS T
	ON T.title_id=TA.title_id


--4. Número de libros que ha publicado cada editorial, incluidas las que no han publicado ninguno.


--5. Número de empleado de cada editorial.


--6. Calcular la relación entre número de ejemplares publicados y número de empleados de cada editorial, incluyendo el nombre de la misma.


--7. Nombre, Apellidos y ciudad de todos los autores que han trabajado para la editorial "Binnet & Hardley” o "Five Lakes Publishing”


--8. Empleados que hayan trabajado en alguna editorial que haya publicado algún libro en el que alguno de los autores fuera Marjorie Green o Michael O'Leary.


--9. Número de ejemplares vendidos de cada libro, especificando el título y el tipo.


--10.  Número de ejemplares de todos sus libros que ha vendido cada autor.


--11.  Número de empleados de cada categoría (jobs).


--12.  Número de empleados de cada categoría (jobs) que tiene cada editorial, incluyendo aquellas categorías en las que no haya ningún empleado.


--13.  Autores que han escrito libros de dos o más tipos diferentes


--14.  Empleados que no trabajan en editoriales que han publicado libros cuya columna notes contenga la palabra "and”

