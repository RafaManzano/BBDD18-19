USE pubs

--1. Título y tipo de todos los libros en los que alguno de los autores vive en California (CA).
SELECT T.title, T.type FROM titles AS T
INNER JOIN titleauthor AS TT ON TT.title_id = T.title_id
INNER JOIN authors AS A ON A.au_id = TT.au_id
WHERE A.state = 'CA'

--2. Título y tipo de todos los libros en los que ninguno de los autores vive en California (CA).
SELECT T.title, T.type FROM titles AS T
INNER JOIN titleauthor AS TT ON TT.title_id = T.title_id
INNER JOIN authors AS A ON A.au_id = TT.au_id
WHERE A.state <> 'CA'

--3. Número de libros en los que ha participado cada autor, incluidos los que no han publicado nada.
SELECT COUNT(T.title_id) AS NumerosLibros, A.au_id FROM titles AS T
INNER JOIN titleauthor AS TT ON TT.title_id = T.title_id
RIGHT JOIN authors AS A ON A.au_id = TT.au_id
GROUP BY A.au_id

--4. Número de libros que ha publicado cada editorial, incluidas las que no han publicado ninguno.
SELECT COUNT(T.title_id) AS NumerosLibros, P.pub_id FROM titles AS T
RIGHT JOIN publishers AS P ON P.pub_id = T.pub_id
GROUP BY P.pub_id

--5. Número de empleados de cada editorial.
SELECT COUNT(E.emp_id) AS EmployeesNumber, P.pub_name FROM employee AS E
INNER JOIN publishers AS P ON P.pub_id = E.pub_id
GROUP BY P.pub_name

--6. Calcular la relación entre número de ejemplares publicados y 
--número de empleados de cada editorial, incluyendo el nombre de la misma.

--Número de ejemplares publicados
GO
CREATE VIEW PublishedCopies AS
SELECT COUNT(T.title_id) AS PublishedCopies, P.pub_id FROM publishers AS P
INNER JOIN titles AS T ON T.pub_id = P.pub_id
GROUP BY P.pub_id
GO
--Número de empleados de cada editorial
GO
CREATE VIEW EmployeesNumber AS
SELECT COUNT(E.emp_id) AS EmployeesNumber, P.pub_id FROM employee AS E
INNER JOIN publishers AS P ON P.pub_id = E.pub_id
GROUP BY P.pub_id
GO

SELECT SUM(EN.EmployeesNumber - PC.PublishedCopies) AS Difference, PC.pub_id FROM EmployeesNumber AS EN
INNER JOIN PublishedCopies AS PC ON PC.pub_id = EN.pub_id
GROUP BY PC.pub_id

--7. Nombre, Apellidos y ciudad de todos los autores que han trabajado 
--para la editorial "Binnet & Hardley” o "Five Lakes Publishing”
SELECT A.au_fname, A.au_lname, A.city FROM authors AS A
INNER JOIN titleauthor AS TA ON TA.au_id = A.au_id
INNER JOIN titles AS T ON TA.title_id = T.title_id
INNER JOIN publishers AS P ON P.pub_id = T.pub_id
WHERE P.pub_name IN('Binnet & Hardley', 'Five Lakes Publishing')

--8. Empleados que hayan trabajado en alguna editorial que haya 
--publicado algún libro en el que alguno de los autores fuera Marjorie Green o Michael O'Leary.
--Libros que han sido escritos por Marjorie Green o Michael O'Leary
--Vistas
GO
CREATE VIEW PeoplesBook AS 
SELECT TA.au_id, TA.title_id FROM titleauthor AS TA
INNER JOIN authors AS A ON A.au_id = TA.au_id
WHERE A.au_fname IN('Marjorie', 'Michael') AND A.au_lname IN('Green', 'O''Leary')
GO

--Editorial que ha publicado algun libro de los autores mencionados
GO
CREATE VIEW PublishersAuthors AS
SELECT P.pub_id FROM publishers AS P
INNER JOIN titles AS T ON T.pub_id = P.pub_id
INNER JOIN PeoplesBook AS PB ON PB.title_id = T.title_id
GO

--Empleados de las editoriales que han publicado algun libro de los autores
SELECT DISTINCT E.fname, E.lname FROM employee AS E
INNER JOIN PublishersAuthors AS PA ON PA.pub_id = E.pub_id

--9. Número de ejemplares vendidos de cada libro, especificando el título y 
--el tipo.
SELECT SUM(qty) AS Copies, T.title, T.type FROM titleauthor AS TA
INNER JOIN titles AS T ON T.title_id = TA.title_id
INNER JOIN sales AS S ON S.title_id = T.title_id
GROUP BY T.title, T.type

--10. Número de ejemplares de todos sus libros que ha vendido cada autor.
SELECT SUM(qty) AS Copies, A.au_fname, A.au_lname FROM authors AS A
INNER JOIN titleauthor AS TA ON TA.au_id = A.au_id
INNER JOIN titles AS T ON T.title_id = TA.title_id
INNER JOIN sales AS S ON S.title_id = T.title_id
GROUP BY A.au_fname, A.au_lname

--11. Número de empleados de cada categoría (jobs).
SELECT COUNT(E.emp_id) AS EmployeesNumber, J.job_id FROM employee AS E
INNER JOIN jobs AS J ON J.job_id = E.job_id
GROUP BY J.job_id

--12. Número de empleados de cada categoría (jobs) que tiene cada editorial, 
--incluyendo aquellas categorías en las que no haya ningún empleado.

--Número de empleados de cada categoría (jobs).
GO
CREATE VIEW EmployeesForCategories AS
SELECT COUNT(E.emp_id) AS EmployeesNumber, J.job_id FROM employee AS E
RIGHT JOIN jobs AS J ON J.job_id = E.job_id
GROUP BY J.job_id
GO

--No creo que sea correcto puesto que no da ningun editorial. Preguntar a Leo y revisar
SELECT EFC.EmployeesNumber, E.pub_id FROM employee AS E
RIGHT JOIN EmployeesForCategories AS EFC ON EFC.job_id = E.job_id
GROUP BY EFC.EmployeesNumber, E.pub_id 

--13. Autores que han escrito libros de dos o más tipos diferentes
SELECT A.au_id, COUNT(T.type) AS Types FROM authors AS A
INNER JOIN titleauthor AS TA ON A.au_id = TA.au_id
INNER JOIN titles AS T ON TA.title_id = T.title_id
GROUP BY A.au_id, T.type
HAVING COUNT(T.type) > 1

--14. Empleados que no trabajan actualmente en editoriales 
--que han publicado libros cuya columna notes contenga la palabra "and”
SELECT fname, lname FROM employee
EXCEPT
SELECT E.fname, E.lname FROM employee AS E
INNER JOIN publishers AS P ON E.pub_id = P.pub_id
INNER JOIN titles AS T ON P.pub_id = T.pub_id
WHERE T.notes LIKE('%and%')
