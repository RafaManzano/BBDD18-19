--Introduce dos nuevos clientes. Asígnales los códigos que te parezcan adecuados.
INSERT INTO BI_Clientes
VALUES (107, 656565656, 'SUCASA', 'ES546456465486545645', 'Yohago KaKa')

INSERT INTO BI_Clientes
VALUES (108, 654654654, 'CALLE PRINCIPAL', 'ES0154548654123', 'Pepito')


--Introduce una mascota para cada uno de ellos. Asígnales los códigos que te parezcan adecuados.
INSERT INTO BI_Mascotas
VALUES ('MM001', 'LABRADOR', 'PERRO', '17-05-2005',NULL,'COSITA', 107)

INSERT INTO BI_Mascotas
VALUES ('MM002', 'LABRADOR', 'PERRO', '17-05-2008',NULL,'OTRO', 108)

--Escribe un SELECT para obtener los IDs de las enfermedades que ha sufrido alguna mascota (una cualquiera). Los IDs no deben repetirse
SELECT IDEnfermedad
FROM BI_Mascotas_Enfermedades
WHERE MASCOTA = 'PH002'

--El cliente Josema Ravilla ha llevado a visita a todas sus mascotas.
--Escribe un SELECT para averiguar el código de Josema Ravilla.
--Escribe otro SELECT para averiguar los códigos de las mascotas de Josema Ravilla.
--Con los códigos obtenidos en la consulta anterior, escribe los INSERT correspondientes en la tabla BI_Visitas. La fecha y hora se tomarán del sistema.

SELECT CODIGO FROM BI_Clientes WHERE Nombre='Josema Ravilla' 

SELECT CODIGO FROM BI_Mascotas WHERE CodigoPropietario = 102

INSERT INTO BI_Visitas VALUES (CURRENT_TIMESTAMP, 37, 5, 'GM002')
INSERT INTO BI_Visitas VALUES (CURRENT_TIMESTAMP, 37, 25, 'PH002')

--Todos los perros del cliente 104 han enfermado el 20 de diciembre de sarna.
--Escribe un SELECT para averiguar los códigos de todos los perros del cliente 104
--Con los códigos obtenidos en la consulta anterior, escribe los INSERT correspondientes en la tabla BI_Mascotas_Enfermedades

SELECT CODIGO FROM BI_Mascotas WHERE CodigoPropietario = 104 AND Especie = 'PERRO'

INSERT INTO BI_Mascotas_Enfermedades VALUES (4, 'PH004', '20-12-2018', NULL)
INSERT INTO BI_Mascotas_Enfermedades VALUES (4, 'PH104', '20-12-2018', NULL)
INSERT INTO BI_Mascotas_Enfermedades VALUES (4, 'PM004', '20-12-2018', NULL)

SELECT * FROM BI_Enfermedades
