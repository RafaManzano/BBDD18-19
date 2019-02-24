/*1. Título, precio y notas de los libros (titles) que tratan de cocina, ordenados de mayor a menor precio.*/
SELECT * FROM titles
SELECT title,price,notes FROM titles
	WHERE type IN ('mod_cook','trad_cook')
	--WHERE type LIKE '%cook%'
	ORDER BY price DESC

/*2. ID, descripción y nivel máximo y mínimo de los puestos de trabajo (jobs) que pueden tener un nivel 110.*/
SELECT * FROM jobs
	WHERE min_lvl >= 110

/*3. Título, ID y tema de los libros que contengan la palabra "and” en las notas.*/
SELECT * FROM titles
SELECT title_id, title, type, notes FROM titles
	WHERE notes LIKE '%and%'

/*4. Nombre y ciudad de las editoriales (publishers) de los Estados Unidos que no estén en California ni en Texas.*/
SELECT * FROM publishers
SELECT pub_name,city FROM publishers
	WHERE country = 'USA' AND state NOT IN ('CA', 'TX')

/*5. Título, precio, ID de los libros que traten sobre psicología o negocios y cuesten entre diez y 20 dólares.*/
SELECT * FROM titles
SELECT title, price, title_id FROM titles
	WHERE type IN ('psychology', 'business') AND price BETWEEN 10 AND 20

/*6. Nombre completo (nombre y apellido) y dirección completa de todos los autores que no viven en California ni en Oregón.*/
SELECT * FROM authors
SELECT au_fname, au_lname, [address], city, [state] FROM authors
	WHERE [state] NOT IN ('CA','OR')

/*7. Nombre completo y dirección completa de todos los autores cuyo apellido empieza por D, G o S.*/
SELECT * FROM authors
SELECT au_fname, au_lname, [address], city, [state] FROM authors
	WHERE au_lname LIKE ('[DGS]%')

/*8. ID, nivel y nombre completo de todos los empleados con un nivel inferior a 100, ordenado alfabéticamente.*/
SELECT * FROM employee
SELECT emp_id,job_lvl, fname, lname FROM employee
	WHERE job_lvl < 100
	ORDER BY fname, lname




/*1. Inserta un nuevo autor.*/
SELECT * FROM authors

INSERT INTO authors	(au_id,au_lname,au_fname,address,city,state,zip,contract)
	VALUES ('999-99-9999', 'Moore', 'Alan', NULL, 'Northampton', NULL, 99999, 1)

/*2. Inserta dos libros, escritos por el autor que has insertado antes y publicados por la editorial "Ramona publishers”.*/
SELECT * FROM titles

INSERT INTO titles (title_id, title, type, pub_id, price, advance, royalty, ytd_sales, notes, pubdate)
	VALUES ('CO9999', 'V de Vendetta', 'comic', 9999, 19.99, NULL, NULL, NULL, 'Best comic ever.', 1982-01-01)

INSERT INTO titles (title_id, title, type, pub_id, price, advance, royalty, ytd_sales, notes, pubdate)
	VALUES ('CO9998', 'La liga de los hombres extraordinarios', 'comic', NULL, 9.99, NULL, NULL, NULL, 'V de Vendetta es mejor', 1999-01-01)

SELECT * FROM titleauthor

INSERT INTO titleauthor (au_id, title_id, au_ord, royaltyper)
	VALUES ('999-99-9999', 'CO9999', 1, 100)

INSERT INTO titleauthor (au_id, title_id, au_ord, royaltyper)
	VALUES ('999-99-9999', 'CO9998', 1, 100) 

/*3. Modifica la tabla jobs para que el nivel mínimo sea 90.*/
SELECT * FROM jobs
	WHERE min_lvl < 90

BEGIN TRANSACTION

UPDATE jobs
	SET min_lvl = 90
	WHERE min_lvl < 90

ROLLBACK 

COMMIT

/*4. Crea una nueva editorial (publihers) con ID 9908, nombre Mostachon Books y sede en Utrera.*/
SELECT * FROM publishers

INSERT INTO publishers (pub_id, pub_name, city, state, country)
	VALUES (9908, 'Mostachon Books', 'Utrera', NULL, 'España')

/*5. Cambia el nombre de la editorial con sede en Alemania para que se llame "Machen Wücher" y traslasde su sede a Stuttgart*/
SELECT * FROM publishers

BEGIN TRANSACTION

UPDATE publishers
	SET pub_name = 'Machen Wücher',
		city = 'Stuttgart'
	WHERE country = 'Germany'

ROLLBACK

COMMIT