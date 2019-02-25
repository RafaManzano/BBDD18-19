--Queremos saber cuál es la enfermedad más común en cada especie. Incluye cuantos casos se han producido
GO
-- Numero de casos de cada enfermedad en cada especie
CREATE VIEW Incidencia AS
SELECT M.Especie, ME.IDEnfermedad, COUNT (*) AS Casos FROM BI_Mascotas AS M INNER JOIN BI_Mascotas_Enfermedades AS ME
	ON M.Codigo = ME.Mascota
	Group By M.Especie, ME.IDEnfermedad
GO

--Versión con subconsultas
SELECT M.Especie,E.Nombre, TopEnfermedad.Mayor FROM BI_Enfermedades AS E
INNER JOIN BI_Mascotas_Enfermedades AS ME ON E.ID = ME.IDEnfermedad
INNER JOIN BI_Mascotas AS M ON ME.Mascota = M.Codigo
INNER JOIN
(SELECT Incidencia.Especie, MAX(Incidencia.Casos) AS Mayor FROM
	(SELECT M.Especie, ME.IDEnfermedad, COUNT (*) AS Casos FROM BI_Mascotas AS M 
		INNER JOIN BI_Mascotas_Enfermedades AS ME
		ON M.Codigo = ME.Mascota
		Group By M.Especie, ME.IDEnfermedad) AS Incidencia
	GROUP BY Incidencia.Especie) AS TopEnfermedad
	ON M.Especie = TopEnfermedad.Especie
	GROUP BY M.Especie, TopEnfermedad.Mayor, ME.IDEnfermedad,E.Nombre
	HAVING COUNT(*) = TopEnfermedad.Mayor

-- Version con 1 vista
SELECT M.Especie,E.Nombre, TopEnfermedad.Mayor FROM BI_Enfermedades AS E
INNER JOIN BI_Mascotas_Enfermedades AS ME ON E.ID = ME.IDEnfermedad
INNER JOIN BI_Mascotas AS M ON ME.Mascota = M.Codigo
INNER JOIN
(SELECT Incidencia.Especie, MAX(Incidencia.Casos) AS Mayor FROM Incidencia
	GROUP BY Incidencia.Especie) AS TopEnfermedad
	ON M.Especie = TopEnfermedad.Especie
	GROUP BY M.Especie, TopEnfermedad.Mayor, ME.IDEnfermedad,E.Nombre
	HAVING COUNT(*) = TopEnfermedad.Mayor
GO
-- Versión con una megavista
CREATE VIEW TopEnfermedad AS
(SELECT Incidencia.Especie, MAX(Incidencia.Casos) AS Mayor FROM
	(SELECT M.Especie, ME.IDEnfermedad, COUNT (*) AS Casos FROM BI_Mascotas AS M 
		INNER JOIN BI_Mascotas_Enfermedades AS ME
		ON M.Codigo = ME.Mascota
		Group By M.Especie, ME.IDEnfermedad) AS Incidencia
	GROUP BY Incidencia.Especie)
GO
SELECT M.Especie,E.Nombre, TopEnfermedad.Mayor FROM BI_Enfermedades AS E
INNER JOIN BI_Mascotas_Enfermedades AS ME ON E.ID = ME.IDEnfermedad
INNER JOIN BI_Mascotas AS M ON ME.Mascota = M.Codigo
INNER JOIN TopEnfermedad
	ON M.Especie = TopEnfermedad.Especie
	GROUP BY M.Especie, TopEnfermedad.Mayor, ME.IDEnfermedad,E.Nombre
	HAVING COUNT(*) = TopEnfermedad.Mayor