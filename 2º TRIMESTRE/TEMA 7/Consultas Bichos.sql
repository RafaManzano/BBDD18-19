USE Bichos

--1. Introduce dos nuevos clientes. Asígnales los códigos que te parezcan adecuados.
SELECT * FROM BI_Clientes

INSERT INTO BI_Clientes 
	VALUES (107, 600841230, 'Avenida Caramelo 3', NULL, 'Luz Cuesta Mogollon'),
		   (108, 605091230, 'Avenida Chocolate 83', NULL, 'Helen Chufe')

--2. Introduce una mascota para cada uno de ellos. Asígnales los códigos que te parezcan adecuados.
SELECT * FROM BI_Mascotas

INSERT INTO BI_Mascotas 
	VALUES ('CH010', 'Gran Danes', 'Perro', '2014-02-10', NULL, 'ScoobyDoo', 107),
		   ('CH011', 'America', 'Gato', '1999-01-10', NULL, 'Garfield', 108)

--3. Escribe un SELECT para obtener los IDs de las enfermedades 
--que ha sufrido alguna mascota (una cualquiera). Los IDs no deben repetirse
SELECT * FROM BI_Mascotas_Enfermedades

SELECT DISTINCT IDEnfermedad FROM BI_Mascotas_Enfermedades
	WHERE Mascota = 'PH002'

--4. El cliente Josema Ravilla ha llevado a visita a todas sus mascotas.
--4.1 Escribe un SELECT para averiguar el código de Josema Ravilla.
SELECT Codigo, Nombre FROM BI_Clientes
	WHERE Nombre = 'Josema Ravilla'

--4.2 Escribe otro SELECT para averiguar los códigos de las mascotas de Josema Ravilla.
SELECT Codigo FROM BI_Mascotas
	WHERE CodigoPropietario = 102

--4.3 Con los códigos obtenidos en la consulta anterior, escribe los INSERT correspondientes en la tabla BI_Visitas.
-- La fecha y hora se tomarán del sistema.
SELECT * FROM BI_Visitas

INSERT INTO BI_Visitas
	VALUES (CURRENT_TIMESTAMP, 40, 29, 'GM002'),
		   (CURRENT_TIMESTAMP, 39, 95, 'PH002')

--5. Todos los perros del cliente 104 han enfermado el 20 de diciembre de sarna.
SELECT * FROM BI_Enfermedades
--5.1 Escribe un SELECT para averiguar los códigos de todos los perros del cliente 104
SELECT Codigo FROM BI_Mascotas
	WHERE CodigoPropietario = 104 AND Especie = 'Perro'

--5.2 Con los códigos obtenidos en la consulta anterior, escribe los INSERT correspondientes en la tabla BI_Mascotas_Enfermedades
SELECT * FROM BI_Mascotas_Enfermedades

BEGIN TRANSACTION
INSERT INTO BI_Mascotas_Enfermedades
	VALUES (4, 'PM004', '2018-12-20', NULL),
		   (4, 'PH104', '2018-12-20', NULL),
		   (4, 'PH004', '2018-12-20', NULL)

--ROLLBACK
--COMMIT

--6. Escribe una consulta para obtener el nombre, especie y raza de todas las mascotas, ordenados por edad.
SELECT * FROM BI_Mascotas

SELECT Alias, Especie, Raza, YEAR((CURRENT_TIMESTAMP - CAST(FechaNacimiento AS DATETIME)))- 1900 AS Edad  FROM BI_Mascotas
	ORDER BY Edad

--7. Escribe los códigos de todas las mascotas que han ido alguna vez al veterinario un lunes o un viernes. 
--Para averiguar el dia de la semana de una fecha se usa la función DATEPART (WeekDay, fecha) que devuelve 
--un entero entre 1 y 7 donde el 1 corresponde al lunes, el dos al martes y así sucesivamente.
--NOTA: El servidor se puede configurar para que la semana empiece en lunes o domingo.
SELECT * FROM BI_Visitas

SELECT Mascota, Fecha FROM BI_Visitas
	WHERE DATEPART(WEEKDAY, Fecha) BETWEEN 1 AND 5
	