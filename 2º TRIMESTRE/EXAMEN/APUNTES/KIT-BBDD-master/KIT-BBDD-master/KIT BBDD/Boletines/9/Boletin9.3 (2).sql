use pubs

--1. Título y tipo de todos los libros en los que alguno de los autores vive en California (CA).
SELECT T.title, T.type, A.state
FROM titles AS T
INNER JOIN titleauthor AS TA
ON T.title_id = TA.title_id
INNER JOIN authors AS A
ON TA.au_id = A.au_id
WHERE A.state = 'CA'

--2. Título y tipo de todos los libros en los que ninguno de los autores vive en California (CA).
SELECT T.title, T.type, A.state
FROM titles AS T
INNER JOIN titleauthor AS TA
ON T.title_id = TA.title_id
INNER JOIN authors AS A
ON TA.au_id = A.au_id
WHERE A.state != 'CA'

--3. Número de libros en los que ha participado cada autor, incluidos los que no han publicado nada.
SELECT COUNT(T.title_id) AS [Numero de libros], A.au_fname, A.au_lname
FROM titles AS T
INNER JOIN titleauthor AS TA
ON T.title_id = TA.title_id
INNER JOIN authors AS A
ON TA.au_id = A.au_id
GROUP BY A.au_fname, A.au_lname
ORDER BY A.au_fname, A.au_lname

--4. Número de libros que ha publicado cada editorial, incluidas las que no han publicado ninguno.
SELECT COUNT(T.title_id) AS [Numero de libros], P.pub_name
FROM titles AS T
INNER JOIN publishers AS P
ON T.pub_id = P.pub_id
GROUP BY P.pub_name
ORDER BY P.pub_name

--5. Número de empleado de cada editorial.
SELECT COUNT(E.emp_id) AS [Numero de empleados], P.pub_name
FROM employee AS E
INNER JOIN publishers AS P
ON E.pub_id = P.pub_id
GROUP BY P.pub_name

--6. Calcular la relación entre número de ejemplares publicados y número de empleados de cada editorial, incluyendo el nombre de la misma.

--7. Nombre, Apellidos y ciudad de todos los autores que han trabajado para la editorial "Binnet & Hardley” o "Five Lakes Publishing”
SELECT A.au_fname, A.au_lname, A.city
FROM authors AS A
INNER JOIN titleauthor AS TA
  ON A.au_id = TA.au_id
INNER JOIN titles AS T
  ON TA.title_id = T.title_id
INNER JOIN publishers AS P
  ON T.pub_id = P.pub_id
WHERE P.pub_name IN ('Binnet & Hardley', 'Five Lakes Publishing' )
ORDER BY A.au_fname

--8. Empleados que hayan trabajado en alguna editorial que haya publicado algún libro en el que alguno de los autores fuera Marjorie Green o Michael O'Leary.
SELECT E.fname, A.au_fname, A.au_lname
FROM employee AS E
INNER JOIN publishers AS P
  ON E.pub_id = P.pub_id
INNER JOIN titles AS T
  ON P.pub_id = T.pub_id
INNER JOIN titleauthor AS TA
  ON T.title_id = TA.title_id
INNER JOIN authors AS A
  ON TA.au_id = A.au_id
WHERE A.au_fname IN ('Marjorie', 'Michael')

--9. Número de ejemplares vendidos de cada libro, especificando el título y el tipo.
SELECT T.title, T.type, SUM(S.qty) AS [Ejemplares vendidos]
FROM titles AS T
INNER JOIN sales AS S
  ON T.title_id = S.title_id
GROUP BY T.title, T.type

--10.  Número de ejemplares de todos sus libros que ha vendido cada autor.
SELECT A.au_fname, SUM(S.qty) AS [Ejemplares vendidos]
FROM authors AS A
INNER JOIN titleauthor AS TA
  ON A.au_id = TA.au_id
INNER JOIN titles AS T
  ON TA.title_id = T.title_id
INNER JOIN sales AS S
  ON T.title_id = S.title_id
GROUP BY A.au_fname

--11.  Número de empleados de cada categoría (jobs).
SELECT COUNT(E.emp_id) AS [Nº Empleados], J.job_desc
FROM employee AS E
INNER JOIN jobs AS J
  ON E.job_id = J.job_id
GROUP BY J.job_desc

--12.  Número de empleados de cada categoría (jobs) que tiene cada editorial,
-- incluyendo aquellas categorías en las que no haya ningún empleado.
SELECT P.pub_name as [Nombre de la editorial], J.job_desc, COUNT(J.job_id) AS [Nº Empleados]
FROM jobs AS J
INNER JOIN employee AS E
  ON J.job_id = E.job_id
INNER JOIN publishers AS P
  ON E.pub_id = P.pub_id
GROUP BY P.pub_name, J.job_desc
ORDER BY P.pub_name

Select p.pub_name as [Nombre de la editorial], j.job_desc as [Categoría], count(e.job_id) as [Numero de empleados]
from publishers as p
cross join jobs as j
left join employee as e
on p.pub_id=e.pub_id and j.job_id=e.job_id
group by p.pub_name,j.job_desc
order by p.pub_name

--13.  Autores que han escrito libros de dos o más tipos diferentes
SELECT A.au_fname, COUNT(T.title_id) AS Tipos
FROM authors AS A
INNER JOIN titleauthor TA
  ON A.au_id = TA.au_id
INNER JOIN titles AS T
  ON TA.title_id = T.title_id
GROUP BY A.au_fname
HAVING COUNT(T.title_id) > 1

--14.  Empleados que no trabajan en editoriales que han publicado libros cuya columna notes contenga la palabra "and”
