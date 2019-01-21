USE pubs

--Consultas sobre una sola Tabla sin agregados
--1. Título, precio y notas de los libros (titles) que tratan de cocina, ordenados de mayor a menor precio.
SELECT * FROM titles

SELECT title, price, notes FROM titles
WHERE [type] LIKE '%cook%'
ORDER BY price DESC

--2. ID, descripción y nivel máximo y mínimo de los puestos de trabajo (jobs) que pueden tener un nivel 110.
SELECT * FROM jobs

SELECT job_id, min_lvl, max_lvl FROM jobs
WHERE max_lvl > 110

--3. Título, ID y tema de los libros que contengan la palabra "and” en las notas
SELECT * FROM titles

SELECT title_id, title, [type] FROM titles
WHERE notes LIKE ('%and%') 

--4. Nombre y ciudad de las editoriales (publishers) de los Estados Unidos que no estén en California ni en Texas
SELECT * FROM publishers

SELECT pub_name, city, country FROM publishers
WHERE country = 'USA' AND city <> 'California' AND city <> 'Texas'

--5. Título, precio, ID de los libros que traten sobre psicología o negocios y cuesten entre diez y 20 dólares.
SELECT * FROM titles

SELECT title_ID, title, price, type  FROM titles
WHERE (type = 'psychology' OR type = 'business') AND (price > 10 AND price < 20)

--6. Nombre completo (nombre y apellido) y dirección completa de todos los autores que no viven en California ni en Oregón.
SELECT * FROM authors

SELECT au_fname, au_lname, address, city, state FROM authors
WHERE city <> 'California' AND city <> 'Oregon'

--7. Nombre completo y dirección completa de todos los autores cuyo apellido empieza por D, G o S.
SELECT * FROM authors

SELECT au_fname, au_lname, address, city FROM authors
WHERE au_lname LIKE '[DGS]%'

--8. ID, nivel y nombre completo de todos los empleados con un nivel inferior a 100, ordenado alfabéticamente
SELECT * FROM employee

SELECT emp_id, fname, lname FROM employee
WHERE job_lvl < 100
ORDER BY lname ASC

--Modificaciones de datos
--1. Inserta un nuevo autor.
SELECT * FROM authors

INSERT INTO authors
(au_id, au_lname, au_fname, phone, address, city, state, zip, contract)
VALUES ('092-12-9852', 'Papito', 'Mamasita' , '892-219-8520', 'Calle Falsa 123', 'Carmona City', 'SE', 41410, 0)

--2. Inserta dos libros, escritos por el autor que has insertado antes y publicados por la editorial "Ramona publishers”.
SELECT * FROM titles
SELECT * FROM publishers
SELECT * FROM titleauthor

INSERT INTO titles
(title_id, title, type, pub_id, price, advance, royalty, ytd_sales, notes, pubdate)
VALUES ('NO0234', 'The Amazing Spiderman', 'novel', 1756, 20.22, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP),
       ('NO0235', 'The Amazing Batman', 'novel', 1756, 28.22, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP)

INSERT INTO titleauthor
(au_id, title_id, au_ord, royaltyper)
VALUES ('092-12-9852', 'NO0234', 3, 70),
	   ('092-12-9852', 'NO0235', 1, 200)

--3. Modifica la tabla jobs para que el nivel mínimo sea 90.
SELECT * FROM jobs

BEGIN TRANSACTION
UPDATE jobs
SET min_lvl = 90
WHERE min_lvl < 90

--ROLLBACK
--COMMIT

--4. Crea una nueva editorial (publihers) con ID 9908, nombre Mostachon Books y sede en Utrera.
SELECT * FROM publishers

INSERT INTO publishers
(pub_id, pub_name, city, state, country)
VALUES (9908, 'Mostachon Books', 'Utrera', 'SE', 'Spain')

--5. Cambia el nombre de la editorial con sede en Alemania para que se llame "Machen Wücher" y traslasde su sede a Stuttgart
SELECT * FROM publishers
WHERE country = 'Germany'

BEGIN TRANSACTION 
UPDATE publishers
SET pub_name = 'Machen Wücher',
	city = 'Stuttgart'
WHERE pub_name = 'GGG&G' OR city = 'Mnchen'
--ROLLBACK
--COMMIT

