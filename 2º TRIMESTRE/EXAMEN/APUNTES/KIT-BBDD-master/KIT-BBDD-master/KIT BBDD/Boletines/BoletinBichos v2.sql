/*1. Introduce dos nuevos clientes. Asígnales los códigos que te parezcan adecuados.*/
SELECT * FROM BI_Clientes

INSERT INTO BI_Clientes (Codigo, Telefono, Direccion, Nombre)
	VALUES (107, '628119707', 'Calle Almeria, 35', 'Tomás Mateo')

INSERT INTO BI_Clientes (Codigo, Telefono, Direccion, Nombre)
	VALUES (108, '658749138', 'Calle Mieo, 48', 'Pseud-OSO')

/*2. Introduce una mascota para cada uno de ellos. Asígnales los códigos que te parezcan adecuados.*/
SELECT * FROM BI_Mascotas

INSERT INTO BI_Mascotas (Codigo, Raza, Especie, FechaNacimiento, FechaFallecimiento, Alias, CodigoPropietario)
	VALUES ('AG007', 'Ganas de vivir', 'Sentimiento', '1998-04-20', '1998-04-21', 'Aversi', 107)

INSERT INTO BI_Mascotas (Codigo, Raza, Especie, FechaNacimiento, FechaFallecimiento, Alias, CodigoPropietario)
	VALUES ('AG000', 'Parguela', 'Humano', '2017-12-22', NULL, 'Pargue', 108)

/*3. Escribe un SELECT para obtener los IDs de las enfermedades que ha sufrido alguna mascota (una cualquiera). Los IDs no deben repetirse.*/
SELECT * FROM BI_Mascotas_Enfermedades
SELECT * FROM BI_Enfermedades

SELECT DISTINCT IDEnfermedad FROM BI_Mascotas_Enfermedades
	WHERE Mascota = 'PH004'

/*INSERT INTO BI_Mascotas_Enfermedades (IDEnfermedad, Mascota, FechaInicio, FechaCura)
	VALUES (1, 'PH002', '2015-10-10', '2015-12-01')*/

/*4. El cliente Josema Ravilla ha llevado a visita a todas sus mascotas.
	4.1. Escribe un SELECT para averiguar el código de Josema Ravilla.*/
	SELECT * FROM BI_Clientes

	SELECT Codigo FROM BI_Clientes
		WHERE Nombre = 'Josema Ravilla'

	/*4.2. Escribe otro SELECT para averiguar los códigos de las mascotas de Josema Ravilla.*/
	SELECT * FROM BI_Mascotas

	SELECT Codigo, CodigoPropietario FROM BI_Mascotas
		WHERE CodigoPropietario = '102'

	/*4.3. Con los códigos obtenidos en la consulta anterior, escribe los INSERT correspondientes en la tabla BI_Visitas.
		 La fecha y hora se tomarán del sistema.*/
	SELECT * FROM BI_Visitas

	INSERT INTO BI_Visitas (Fecha, Temperatura, Peso, Mascota)
		VALUES ('2017-03-12', 21, 3, 'GM002')

	INSERT INTO BI_Visitas (Fecha, Temperatura, Peso, Mascota)
		VALUES ('2017-03-12', 21, 6, 'PH002')

/*5. Todos los perros del cliente 104 han enfermado el 20 de diciembre de sarna :( .
	5.1. Escribe un SELECT para averiguar los códigos de todos los perros del cliente 104*/
	SELECT * FROM BI_Mascotas

	SELECT Codigo FROM BI_Mascotas
		WHERE CodigoPropietario = 104 AND Especie = 'Perro'

	/*5.2. Con los códigos obtenidos en la consulta anterior, escribe los INSERT correspondientes en la tabla BI_Mascotas_Enfermedades*/
	SELECT * FROM BI_Enfermedades
	SELECT * FROM BI_Mascotas_Enfermedades

	INSERT INTO BI_Mascotas_Enfermedades (IDEnfermedad, Mascota, FechaInicio, FechaCura)
		VALUES (4, 'PH004', '2017-12-20', '2017-12-30')

	INSERT INTO BI_Mascotas_Enfermedades (IDEnfermedad, Mascota, FechaInicio, FechaCura)
		VALUES (4, 'PH104', '2017-12-20', '2017-12-29')

	INSERT INTO BI_Mascotas_Enfermedades (IDEnfermedad, Mascota, FechaInicio, FechaCura)
		VALUES (4, 'PM004', '2017-12-20', '2017-12-29')

/*6. Escribe una consulta para obtener el nombre, especie y raza de todas las mascotas, ordenados por edad.*/
SELECT * FROM BI_Mascotas

SELECT Year(Current_Timestamp -CAST(FechaNacimiento AS SmallDateTime))-1900 AS [Edad], Alias, Especie, Raza FROM BI_Mascotas
	ORDER BY Year(Current_Timestamp -CAST(FechaNacimiento AS SmallDateTime))-1900

/*7. Escribe los códigos de todas las mascotas que han ido alguna vez al veterinario un lunes o un viernes.
	 Para averiguar el dia de la semana de una fecha se usa la función DATEPART (WeekDay, fecha)
	 que devuelve un entero entre 1 y 7 donde el 1 corresponde al lunes, el dos al martes y así sucesivamente.*/
SELECT * FROM BI_Mascotas_Enfermedades

SELECT Mascota, DATEPART(WEEKDAY, FechaInicio) AS [Día de la semana] FROM BI_Mascotas_Enfermedades
	WHERE DATEPART(WEEKDAY, FechaInicio) BETWEEN 1 AND 5

/*NOTA: El servidor se puede configurar para que la semana empiece en lunes o domingo.*/