---Consultas
--1. Título, precio y notas de los libros (titles) que tratan de cocina, ordenados de mayor a menor precio.
SELECT title, price, notes FROM titles
	WHERE type = 'mod_cook' ORDER BY price desc
--2. ID, descripción y nivel máximo y mínimo de los puestos de trabajo (jobs) que pueden tener un nivel 110. **(No pillo muy bien el enunciado)**
SELECT job_id, job_desc, min_lvl, max_lvl FROM jobs
	WHERE min_lvl >= 110
--3. Título, ID y tema de los libros que contengan la palabra "and” en las notas
SELECT title, title_id, type FROM titles
	WHERE notes LIKE '%and%'
--4. Nombre y ciudad de las editoriales (publishers) de los Estados Unidos que no estén en California ni en Texas

SELECT pub_name, city FROM publishers
	WHERE country = 'USA' and city not in ('California', 'Texas')






--5. Título, precio, ID de los libros que traten sobre psicología o negocios y cuesten entre diez y 20 dólares.

SELECT title, price, title_id FROM titles
	WHERE type IN ('psychology', 'business') and price between 10 and 20


--6. Nombre completo (nombre y apellido) y dirección completa de todos los autores que no viven en California ni en Oregón.

SELECT au_fname, au_lname, address, city, state  FROM authors
	WHERE state	NOT IN ('CA', 'OR')


--7. Nombre completo y dirección completa de todos los autores cuyo apellido empieza por D, G o S.

SELECT au_fname, au_lname, address, city, state FROM authors
	WHERE au_lname LIKE '[DGS]%'


--8. ID, nivel y nombre completo de todos los empleados con un nivel inferior a 100, ordenado alfabéticamente

SELECT emp_id, job_lvl, lname, fname FROM employee
	WHERE job_lvl < 100 ORDER BY lname, fname desc



---Modificaciones de datos
select * from jobs
--1. Inserta un nuevo autor.
INSERT INTO authors (au_id, au_fname, au_lname, city, state, contract)
	VALUES ('022-12-1923', 'Howard', 'Phillips Lovecraft', 'Providence', 'RI', 0)
--2. Inserta dos libros, escritos por el autor que has insertado antes y publicados por la editorial "Ramona publishers”.
INSERT INTO	titles (title_id, title, type, pub_id, pubdate)
	VALUES ('LC2013', 'At the Mountains of Madness', 'Horror', 1756, 1931-02-21),
	('LC2011', 'The Case of Charles Dexter Ward', 'Horror', 1756, 1927-01-06)
--3. Modifica la tabla jobs para que el nivel mínimo sea 90.
UPDATE jobs SET min_lvl = 90
	WHERE min_lvl < 90
---ALTER TABLE jobs ADD constraint CK_Jobs check (min_lvl >= 90) ---Este check daría error ya que las columnas por debajo de 90 darían error.

--4. Crea una nueva editorial (publihers) con ID 9908, nombre Mostachon Books y sede en Utrera.
INSERT INTO publishers (pub_id, pub_name, city, state, country)
	VALUES (9908, 'Mostachon Books', 'Utrera', NULL, 'España')
--5. Cambia el nombre de la editorial con sede en Alemania para que se llame "Machen Wücher" y traslasde su sede a Stuttgart
UPDATE publishers 
	SET pub_name = 'Machen Wücher'
	WHERE pub_id = 9901

UPDATE publishers
	SET city = 'Stuttgart'
	WHERE pub_id = 9901