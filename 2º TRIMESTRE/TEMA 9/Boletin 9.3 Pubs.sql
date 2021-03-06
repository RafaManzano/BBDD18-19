USE pubs

--1. T�tulo y tipo de todos los libros en los que alguno de los autores vive en California (CA).
SELECT * FROM titles
SELECT * FROM authors

SELECT t.title_id, t.title, t.type FROM titles AS T
INNER JOIN titleauthor AS TA ON T.title_id = TA.title_id
INNER JOIN authors AS A ON A.au_id = TA.au_id
WHERE A.state = 'CA'

--2. T�tulo y tipo de todos los libros en los que ninguno de los autores vive en California (CA).
SELECT * FROM authors

SELECT title_id, title, type FROM titles 
EXCEPT 
SELECT DISTINCT t.title_id, t.title, t.type FROM titles AS T 
INNER JOIN titleauthor AS TA ON T.title_id = TA.title_id
INNER JOIN authors AS A ON A.au_id = TA.au_id
WHERE A.state = ('CA')

--3. N�mero de libros en los que ha participado cada autor, incluidos los que no han publicado nada.
SELECT COUNT(t.title_id) AS BooksNumber, A.au_id, A.au_fname, A.au_lname FROM titles AS T 
INNER JOIN titleauthor AS TA ON T.title_id = TA.title_id
RIGHT JOIN authors AS A ON A.au_id = TA.au_id
GROUP BY A.au_id, A.au_fname, A.au_lname

--4. N�mero de libros que ha publicado cada editorial, incluidas las que no han publicado ninguno.
SELECT * FROM publishers
SELECT DISTINCT COUNT( t.title_id) AS BooksNumber, P.pub_id FROM titles AS T
RIGHT JOIN publishers AS P ON P.pub_id = T.pub_id
GROUP BY P.pub_id

--5. N�mero de empleados de cada editorial.
SELECT COUNT(E.emp_id) AS EmployeeSNumber, P.pub_id FROM publishers AS P
INNER JOIN employee AS E ON E.pub_id = P.pub_id
GROUP BY P.pub_id

--6. Calcular la relaci�n entre n�mero de ejemplares publicados y n�mero de empleados de cada editorial, 
--incluyendo el nombre de la misma.
SELECT COUNT( t.title_id) AS BooksNumber, P.pub_id FROM titles AS T
INNER JOIN publishers AS P ON P.pub_id = T.pub_id
GROUP BY P.pub_id

SELECT COUNT(E.emp_id) AS EmployeeSNumber, P.pub_id FROM publishers AS P
INNER JOIN employee AS E ON E.pub_id = P.pub_id
GROUP BY P.pub_id

--Dividir

--7. Nombre, Apellidos y ciudad de todos los autores que han trabajado para la editorial 
--"Binnet & Hardley� o "Five Lakes Publishing�
SELECT A.au_fname, A.au_lname, A.city FROM authors AS A
INNER JOIN titleauthor AS TA ON TA.au_id = A.au_id
INNER JOIN titles AS T ON T.title_id = TA.title_id
INNER JOIN publishers AS P ON P.pub_id = T.pub_id
WHERE P.pub_name IN('Binnet & Hardley','Five Lakes Publishing')

--8. Empleados que hayan trabajado en alguna editorial que haya publicado alg�n libro 
--en el que alguno de los autores fuera Marjorie Green o Michael O'Leary.
SELECT DISTINCT E.fname,E.lname FROM employee AS E
INNER JOIN publishers AS P ON P.pub_id = E.pub_id
INNER JOIN titles AS T ON T.pub_id = P.pub_id
INNER JOIN titleauthor AS TA ON TA.title_id = T.title_id
INNER JOIN authors AS A ON A.au_id = TA.au_id
WHERE (A.au_fname = 'Marjorie' OR A.au_fname = 'Michael') AND (A.au_lname = 'Green' OR A.au_lname = 'O''Leary')

--9. N�mero de ejemplares vendidos de cada libro, especificando el t�tulo y el tipo. No entiendo porque no sale nada
SELECT SUM(S.qty) AS Quantity, T.title_id, T.title, T.type FROM titles AS T
INNER JOIN sales AS S ON S.title_id = T.title
GROUP BY T.title_id, T.title, T.type

--10. N�mero de ejemplares de todos sus libros que ha vendido cada autor.
SELECT SUM(S.qty) AS Copies, A.au_id, A.au_fname, A.au_lname FROM titles AS T
INNER JOIN sales AS S ON S.title_id = T.title_id
INNER JOIN titleauthor AS TA ON TA.title_id = T.title_id
INNER JOIN authors AS A ON A.au_id = TA.au_id
GROUP BY A.au_id, A.au_fname, A.au_lname

--11. N�mero de empleados de cada categor�a (jobs).
SELECT COUNT(E.emp_id) AS Employees, J.job_id FROM jobs AS J
INNER JOIN employee AS E ON E.job_id = J.job_id
GROUP BY J.job_id

--12. N�mero de empleados de cada categor�a (jobs) que tiene cada editorial, 
--incluyendo aquellas categor�as en las que no haya ning�n empleado.

--N�mero de empleados de cada categor�a (jobs). --Preguntar a leo, tiene que haber un outer join pero no me sale correctamente, no estoy seguro si esta bien planteada la subconsulta
SELECT EmployeesByCategory.Employees, EmployeesByCategory.job_id, P.pub_id FROM employee AS E
INNER JOIN (
SELECT COUNT(E.emp_id) AS Employees, J.job_id FROM jobs AS J
INNER JOIN employee AS E ON E.job_id = J.job_id
GROUP BY J.job_id  ) AS EmployeesByCategory ON EmployeesByCategory.job_id = E.job_id
INNER JOIN publishers AS P ON P.pub_id = E.pub_id
GROUP BY P.pub_id, EmployeesByCategory.job_id,EmployeesByCategory.Employees

--13. Autores que han escrito libros de dos o m�s tipos diferentes
SELECT A.au_id, A.au_fname, A.au_lname, COUNT(T.type) AS Type FROM authors AS A
INNER JOIN titleauthor AS TA ON TA.au_id = A.au_id
INNER JOIN titles AS T ON T.title_id = TA.title_id
GROUP BY A.au_id, A.au_fname, A.au_lname
HAVING COUNT(T.type) > 1

--14. Empleados que no trabajan actualmente en editoriales que han publicado libros cuya columna notes contenga la palabra "and�
SELECT fname, lname FROM employee
EXCEPT
SELECT E.fname, E.lname FROM publishers AS P
INNER JOIN employee AS E ON E.pub_id = P.pub_id
INNER JOIN titles AS T ON T.pub_id = P.pub_id
WHERE T.notes NOT LIKE('%and%')
