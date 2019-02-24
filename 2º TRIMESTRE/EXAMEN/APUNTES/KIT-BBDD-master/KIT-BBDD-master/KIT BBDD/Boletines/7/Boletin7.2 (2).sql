--Boletin 7.2
--Consultas sobre una sola Tabla sin agregados
--Sobre la base de datos "pubs” (En la plataforma aparece como "Ejemplos 2000").

USE pubs

--1. Título, precio y notas de los libros (titles) que tratan de cocina, ordenados de mayor a menor precio.
SELECT title, price, notes 
FROM titles 
WHERE type LIKE ('%_cook')
ORDER BY price DESC

--2. ID, descripción y nivel máximo y mínimo de los puestos de trabajo (jobs) que pueden tener un nivel 110.
SELECT job_id, job_desc, max_lvl, min_lvl 
FROM jobs 
WHERE max_lvl < 110

--3. Título, ID y tema de los libros que contengan la palabra "and” en las notas
SELECT title, title_id , notes 
FROM titles 
WHERE notes LIKE '%and%'

--4. Nombre y ciudad de las editoriales (publishers) de los Estados Unidos que no estén en California ni en Texas
SELECT pub_name, country, state
FROM publishers 
WHERE country like 'USA' and state not in ('TX', 'CA')

--5. Título, precio, ID de los libros que traten sobre psicología o negocios y cuesten entre diez y 20 dólares.
SELECT title, price, title_id, type
FROM titles
WHERE type IN ('psychology', 'business') AND price between 10 and 20

--6. Nombre completo (nombre y apellido) y dirección completa de todos los autores que no viven en California ni en Oregón.
SELECT au_fname, au_lname, [address], state
FROM authors
WHERE state not in ('CA', 'OR')

--7. Nombre completo y dirección completa de todos los autores cuyo apellido empieza por D, G o S.
SELECT au_fname, au_lname, address, city, state 
FROM authors
WHERE au_lname like 'D%' or au_lname like '%G' or au_lname like 'S%'

--8. ID, nivel y nombre completo de todos los empleados con un nivel inferior a 100, ordenado alfabéticamente
SELECT emp_id, fname, lname
FROM employee
WHERE job_lvl < 100 
ORDER BY fname


---- Modificaciones de datos ----
-- 1. Inserta un nuevo autor.
INSERT INTO authors (au_id, au_lname, au_fname, phone, address, city, state, zip, contract)
VALUES ('131-23-5551', 'Soares',   'Paulo',  '555555555555', 'sierpes', 'Sevilla', 'ES', '41003', 'True')

-- Comprobamos que el insert se completo correctamente
SELECT au_id, au_lname, au_fname, phone, address, city, state, zip, contract 
FROM authors 
WHERE state LIKE 'ES' -- buscamos por estado

--2. Inserta dos libros, escritos por el autor que has insertado antes y publicados por la editorial "Ramona publishers”.
-- insertamos primer libro
INSERT INTO titles ( title_id, title, type, pub_id, price, advance, royalty, ytd_sales, notes, pubdate )
VALUES ('19', 'SQL for dummies', 'basesDeDatos', '1756', '0.00', '10', '223', '8749','Aprenderas sql rapidamente', CURRENT_TIMESTAMP )

-- insertamos segundo libro
INSERT INTO titles ( title_id, title, type, pub_id, price, advance, royalty, ytd_sales, notes, pubdate )
VALUES ('20', 'Java for dummies', 'computer', '1756', '4.00', '10', '223', '8749','Aprenderas java rapidamente', CURRENT_TIMESTAMP )

--3. Modifica la tabla jobs para que el nivel mínimo sea 90.
ALTER TABLE jobs WITH NOCHECK ADD CONSTRAINT CK_NivelMinimo CHECK ( min_lvl > '90' )

--4. Crea una nueva editorial (publihers) con ID 9908, nombre Mostachon Books y sede en Utrera.
INSERT INTO publishers (pub_id, pub_name, city, state, country)
VALUES ('9908', 'Mostachon Books', 'Sevilla', 'ES', 'Andalucia')

--5. Cambia el nombre de la editorial con sede en Alemania para que se llame "Machen Wücher" y traslasde su sede a Stuttgart
UPDATE publishers
SET pub_name='Machen Wücher', city='Stuttgart', state='BE'
WHERE country LIKE ('Germany')