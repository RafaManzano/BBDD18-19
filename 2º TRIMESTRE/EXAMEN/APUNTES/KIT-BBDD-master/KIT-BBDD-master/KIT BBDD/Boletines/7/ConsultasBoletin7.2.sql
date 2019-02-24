/*Boletin 7.2
o-Consultas sobre una sola Tabla sin agregados
-Título, precio y notas de los libros (titles) que tratan de cocina, ordenados de mayor a menor precio.*/
SELECT title, price, notes FROM titles WHERE [type] like '%_cook' ORDER BY price DESC

/*-ID, descripción y nivel máximo y mínimo de los puestos de trabajo (jobs) que pueden tener un nivel 110.*/
SELECT job_id, job_desc, min_lvl, max_lvl FROM jobs WHERE min_lvl<110 AND max_lvl>110

/*-Título, ID y tema de los libros que contengan la palabra "and” en las notas*/
SELECT title, title_id, [type] FROM titles WHERE notes like '%and%' or notes like 'and%' or notes like '%and'

/*-Nombre y ciudad de las editoriales (publishers) de los Estados Unidos que no estén en California ni en Texas*/
SELECT pub_name, city FROM publishers WHERE country LIKE 'USA' AND state NOT IN ('TX','CA')

/*-Título, precio, ID de los libros que traten sobre psicología o negocios y cuesten entre diez y 20 dólares.*/
SELECT title, price, title_id FROM titles WHERE [type] IN ('psychology', 'business') AND price BETWEEN 10 AND 20

/*-Nombre completo (nombre y apellido) y dirección completa de todos los autores que no viven en California ni en Oregón.*/
SELECT au_lname, au_fname, city, address FROM authors WHERE state NOT IN ('CA', 'OR')

/*-Nombre completo y dirección completa de todos los autores cuyo apellido empieza por D, G o S.*/
SELECT au_lname, au_fname, city, address FROM authors WHERE au_lname LIKE 'D%' OR au_lname LIKE 'G%' OR au_lname LIKE 'S%'

/*-ID, nivel y nombre completo de todos los empleados con un nivel inferior a 100, ordenado alfabéticamente*/
SELECT emp_id, job_lvl, lname, fname FROM employee WHERE job_lvl<100 ORDER BY lname

/*o-Modificaciones de datos*/
/*-Inserta un nuevo autor.*/INSERT INTO authors (au_id, au_lname, au_fname, phone, address, city, state, zip, contract) VALUES ('998-72-5768', 'González', 'Javier', '897685443211', '221 Baeiker St.', 'Sevilla', 'ES', '94612', 'True')

SELECT au_id, au_lname, au_fname, phone, address, city, state, zip, contract FROM authors WHERE state LIKE 'ES'

DELETE FROM authors 
where au_fname like 'Javier'

/*-Inserta dos libros, escritos por el autor que has insertado antes y publicados por la editorial "Ramona publishers”.
pubID=1756
*/
SELECT * FROM publishers WHERE pub_name LIKE 'Ramona publishers'
INSERT INTO titles (title_id, title, type, pub_id, price, advance, royalty, ytd_sales, notes, pubdate) VALUES ('PS4522', 'Programar sin morir en el intento', 'psychology', '1756', 23, 2000, 10, 3336, 'It is a great book!', '2015-05-05')
INSERT INTO titles (title_id, title, type, pub_id, price, advance, royalty, ytd_sales, notes, pubdate) VALUES ('PS4523', 'Chuflerias y pamplinas', 'psychology', '1756', 30, 40000, 12, 4312, 'It is the best book in the world!', '2016-01-01 18:00:00')
SELECT * FROM titles WHERE pub_id LIKE '1756'
INSERT INTO titleauthor (au_id, title_id, au_ord, royaltyper) VALUES ('998-72-5768', 'PS4522', 1, 60)
INSERT INTO titleauthor (au_id, title_id, au_ord, royaltyper) VALUES ('998-72-5768', 'PS4523', 2, 75)
SELECT * FROM titleauthor WHERE au_id LIKE '998-72-5768'


/*-Modifica la tabla jobs para que el nivel mínimo sea 90.*/
UPDATE jobs SET min_lvl=90 WHERE min_lvl<90
SELECT * FROM jobs

/*-Crea una nueva editorial (publihers) con ID 9908, nombre Mostachon Books y sede en Utrera.*/
INSERT INTO publishers (pub_id, pub_name, city, country) VALUES ('9908', 'Mostachon Books', 'Utrera', 'Spain')
SELECT * FROM publishers WHERE pub_id LIKE '9908'

/*-Cambia el nombre de la editorial con sede en Alemania para que se llame "Machen Wücher" y traslasde su sede a Stuttgart*/
UPDATE publishers SET pub_name='Machen Wücher', city='Stuttgart', country='Germany' WHERE pub_id LIKE '9908'
