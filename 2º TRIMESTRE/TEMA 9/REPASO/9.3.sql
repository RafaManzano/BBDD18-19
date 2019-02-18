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
