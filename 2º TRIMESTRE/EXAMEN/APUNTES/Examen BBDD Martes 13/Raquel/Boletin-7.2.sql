--Consultas sobre una sola Tabla sin agregados

--Sobre la base de datos "pubs” (En la plataforma aparece como "Ejemplos 2000").
USE pubs
GO

--1.Título, precio y notas de los libros (titles) que tratan de cocina, ordenados de mayor a menor precio.
SELECT title, price, notes, type
FROM titles
WHERE type LIKE '%cook'
ORDER BY price DESC

--2.ID, descripción y nivel máximo y mínimo de los puestos de trabajo (jobs) que pueden tener un nivel 110.
SELECT job_id,job_desc,min_lvl,max_lvl
FROM jobs
--WHERE max_lvl>110 and min_lvl>100
WHERE 110 BETWEEN min_lvl and max_lvl

--3.Título, ID y tema de los libros que contengan la palabra "and” en las notas
SELECT title, title_id, type, notes
FROM titles
WHERE notes LIKE '% and %'

--4.Nombre y ciudad de las editoriales (publishers) de los Estados Unidos que no estén en California ni en Texas.
SELECT pub_name, city
FROM publishers
WHERE country='USA' and state NOT IN ('CA','TX')

--5.Título, precio, ID de los libros que traten sobre psicología o negocios y cuesten entre diez y 20 dólares.
SELECT title, price, title_id
FROM titles
WHERE type IN ('business','psychology') and price>10 and price<20


--6.Nombre completo (nombre y apellido) y dirección completa de todos los autores que no viven en California ni en Oregón.
SELECT au_lname, au_fname, address,city,state,zip
FROM authors
WHERE state NOT IN ('CA','OR')

--7.Nombre completo y dirección completa de todos los autores cuyo apellido empieza por D, G o S.
SELECT au_lname, au_fname, address,city,state,zip
FROM authors
WHERE au_lname LIKE '[D,G,S]%'

--8.ID, nivel y nombre completo de todos los empleados con un nivel inferior a 100, ordenado alfabéticamente
SELECT emp_id,fname,lname, job_lvl
FROM employee
WHERE job_lvl<100
ORDER BY fname,lname

------------------------------------------------------------

--Modificaciones de datos
--Inserta un nuevo autor.
--SELECT * FROM authors WHERE au_fname LIKE 'Pepito'

BEGIN TRANSACTION
	INSERT INTO authors (au_id,au_lname,au_fname,phone,address,city,state,zip,contract)
	VALUES ('213-54-5465','El de los Palotes','Pepito','675264213','121 Sta.Catalina','San Jose','CA','95128',1)
COMMIT TRANSACTION
--ROLLBACK TRANSACTION

--Inserta dos libros, escritos por el autor que has insertado antes y publicados por la editorial "Ramona publishers”.
--SELECT * FROM titles

BEGIN TRANSACTION
	INSERT INTO titles(title_id,title,type,pub_id,price,advance,royalty,ytd_sales,notes,pubdate)
	VALUES('MC2135','Cómo comerte a tu vecina sin que se entere tu vecino','mod_cook','1756',54.99,5000,16,546540,'Guía de recetas para conquistar a tu vecina por el estómago','2017-05-12 00:00:00.000'),
	('GM2879','Cómo ser una e-girl culona','gamer','1756',23.99,5468,32,7845652,'Manual para combinar tus momentos de juego con el ejercicio y no morir en el intento (sólo en el juego)','2017-03-11 00:00:00.000')
COMMIT TRANSACTION
--ROLLBACK TRANSACTION

--Modifica la tabla jobs para que el nivel mínimo sea 90.
--SELECT * FROM jobs

BEGIN TRANSACTION
	UPDATE jobs
	SET min_lvl=90
	WHERE min_lvl<90
COMMIT TRANSACTION
--ROLLBACK TRANSACTION

--Crea una nueva editorial (publihers) con ID 9908, nombre Mostachon Books y sede en Utrera.
--SELECT * FROM publishers

BEGIN TRANSACTION
	INSERT INTO publishers(pub_id,pub_name,city)
	VALUES('9908','Mostachon Books','Utrera')
COMMIT TRANSACTION
--ROLLBACK TRANSACTION

--Cambia el nombre de la editorial con sede en Alemania para que se llame "Machen Wücher" y traslasde su sede a Stuttgart
--SELECT * FROM publishers WHERE pub_id='9901'

BEGIN TRANSACTION
	UPDATE publishers
	SET pub_name='Machen Wücher'
	WHERE country='Germany'
COMMIT TRANSACTION

BEGIN TRANSACTION
	UPDATE publishers
	SET city='Stuttgart'
	WHERE pub_name='Machen Wücher'
COMMIT TRANSACTION

--ROLLBACK TRANSACTION
