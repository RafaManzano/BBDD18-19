USE pubs

--1. Título y tipo de todos los libros en los que alguno de los autores vive en California (CA).
SELECT * FROM titles
SELECT * FROM authors

SELECT t.title_id, t.title, t.type FROM titles AS T
INNER JOIN titleauthor AS TA ON T.title_id = TA.title_id
INNER JOIN authors AS A ON A.au_id = TA.au_id
WHERE A.state = 'CA'

--2. Título y tipo de todos los libros en los que ninguno de los autores vive en California (CA).
SELECT * FROM authors
SELECT title_id, title, type FROM titles 
EXCEPT 
SELECT t.title_id, t.title, t.type FROM titles AS T 
INNER JOIN titleauthor AS TA ON T.title_id = TA.title_id
INNER JOIN authors AS A ON A.au_id = TA.au_id
WHERE A.state = ('CA')

--3. Número de libros en los que ha participado cada autor, incluidos los que no han publicado nada.
SELECT COUNT(t.title_id) AS BooksNumber, A.au_id, A.au_fname, A.au_lname FROM titles AS T 
INNER JOIN titleauthor AS TA ON T.title_id = TA.title_id
RIGHT JOIN authors AS A ON A.au_id = TA.au_id
GROUP BY A.au_id, A.au_fname, A.au_lname

--4. Número de libros que ha publicado cada editorial, incluidas las que no han publicado ninguno.
SELECT * FROM publishers
SELECT DISTINCT COUNT( t.title_id) AS BooksNumber, P.pub_id FROM titles AS T
RIGHT JOIN publishers AS P ON P.pub_id = T.pub_id
GROUP BY P.pub_id

--5. Número de empleados de cada editorial.
SELECT COUNT(E.emp_id) AS EmployeeSNumber, P.pub_id FROM publishers AS P
INNER JOIN employee AS E ON E.pub_id = P.pub_id
GROUP BY P.pub_id

--6. Calcular la relación entre número de ejemplares publicados y número de empleados de cada editorial, 
--incluyendo el nombre de la misma.
SELECT COUNT( t.title_id) AS BooksNumber, P.pub_id FROM titles AS T
INNER JOIN publishers AS P ON P.pub_id = T.pub_id
GROUP BY P.pub_id

SELECT COUNT(E.emp_id) AS EmployeeSNumber, P.pub_id FROM publishers AS P
INNER JOIN employee AS E ON E.pub_id = P.pub_id
GROUP BY P.pub_id

--No se que significa

--7. Nombre, Apellidos y ciudad de todos los autores que han trabajado para la editorial 
--"Binnet & Hardley” o "Five Lakes Publishing”
