USE Bichos
SELECT * FROM BI_Mascotas
SELECT * FROM BI_Enfermedades
SELECT * FROM BI_Mascotas_Enfermedades

--1. Número de mascotas que han sufrido cada enfermedad.
SELECT COUNT(BIME.Mascota) AS NumeroMascotas, BIE.Nombre FROM BI_Enfermedades AS BIE
INNER JOIN BI_Mascotas_Enfermedades AS BIME ON BIE.ID = BIME.IDEnfermedad
GROUP BY BIE.Nombre

--2. Número de mascotas que han sufrido cada enfermedad incluyendo 
--las enfermedades que no ha sufrido ninguna mascota
SELECT COUNT(BIME.Mascota) AS NumeroMascotas, BIE.Nombre FROM BI_Enfermedades AS BIE
LEFT JOIN BI_Mascotas_Enfermedades AS BIME ON BIE.ID = BIME.IDEnfermedad
GROUP BY BIE.Nombre

--3. Número de mascotas de cada cliente. 
--Incluye nombre completo y dirección del cliente.
SELECT BIC.Nombre, BIC.Direccion, COUNT(BIM.Codigo) AS NumeroMascotas FROM BI_Mascotas AS BIM
INNER JOIN BI_Clientes AS BIC ON BIM.CodigoPropietario = BIC.Codigo
GROUP BY BIC.Nombre, BIC.Direccion

--4. Número de mascotas de cada especie de cada cliente. 
--Incluye nombre completo y dirección del cliente.
--Numero de mascotas de cada especie
GO
CREATE VIEW MascotasPorEspecie AS
SELECT COUNT(*) AS Mascotas, Especie FROM BI_Mascotas
GROUP BY Especie
GO

SELECT COUNT(MPE.Mascotas) AS NumeroMascotas, BIC.Codigo FROM MascotasPorEspecie AS MPE
INNER JOIN BI_Mascotas AS BIM ON BIM.Especie = MPE.Especie
INNER JOIN BI_Clientes AS BIC ON BIM.CodigoPropietario = BIC.Codigo
GROUP BY BIC.Codigo

--5. Número de mascotas de cada especie que han sufrido cada enfermedad.
--Es la vista anterior copiada
GO
CREATE VIEW MascotasPorEspecie AS
SELECT COUNT(*) AS Mascotas, Especie FROM BI_Mascotas
GROUP BY Especie
GO

SELECT COUNT(Mascotas) AS Mascotas, BIE.ID FROM MascotasPorEspecie AS MPE
INNER JOIN BI_Mascotas AS BIM ON MPE.Especie = BIM.Especie
INNER JOIN BI_Mascotas_Enfermedades AS BIME ON BIM.Codigo = BIME.Mascota
INNER JOIN BI_Enfermedades AS BIE ON BIME.IDEnfermedad = BIE.ID
GROUP BY BIE.ID


--6. Número de mascotas de cada especie que han sufrido cada enfermedad 
--incluyendo las enfermedades que no ha sufrido ninguna mascota 
--de alguna especie.
SELECT COUNT(Mascotas) AS Mascotas, BIE.ID FROM MascotasPorEspecie AS MPE
INNER JOIN BI_Mascotas AS BIM ON MPE.Especie = BIM.Especie
INNER JOIN BI_Mascotas_Enfermedades AS BIME ON BIM.Codigo = BIME.Mascota
RIGHT JOIN BI_Enfermedades AS BIE ON BIME.IDEnfermedad = BIE.ID
GROUP BY BIE.ID

--7. Queremos saber cuál es la enfermedad más común en cada especie. 
--Incluye cuantos casos se han producido
GO
CREATE VIEW EnfermedadesPorEspecie AS
SELECT COUNT(BIME.IDEnfermedad) AS Enfermedad, BIM.Especie FROM BI_Mascotas_Enfermedades AS BIME
INNER JOIN BI_Mascotas AS BIM ON BIME.Mascota = BIM.Codigo
GROUP BY BIM.Especie
GO

SELECT EnfermedadesPorEspecie.Enfermedad ,MAX(Enfermedad) AS MaximoEnfermedad, BIM.Especie FROM BI_Mascotas AS BIM
INNER JOIN (SELECT COUNT(BIME.IDEnfermedad) AS Enfermedad, BIM.Especie FROM BI_Mascotas_Enfermedades AS BIME
				   INNER JOIN BI_Mascotas AS BIM ON BIME.Mascota = BIM.Codigo
				   GROUP BY BIM.Especie) AS EnfermedadesPorEspecie ON EnfermedadesPorEspecie.Especie = BIM.Especie
GROUP BY BIM.Especie, EnfermedadesPorEspecie.Enfermedad

--8. Duración media, en días, de cada enfermedad, desde que se detecta 
--hasta que se cura. Incluye solo los casos en que el animal se haya 
--curado. Se entiende que una mascota se ha curado si tiene fecha de 
--curación y está viva o su fecha de fallecimiento es posterior a la 
--fecha de curación.
GO
ALTER VIEW DiasTranscurridosEnfermedad AS
SELECT SUM(DATEDIFF(DAY,FechaInicio, FechaCura)) AS Dias, IDEnfermedad FROM BI_Mascotas_Enfermedades
WHERE FechaCura IS NOT NULL
GROUP BY IDEnfermedad
GO

SELECT AVG(Dias) AS MediaDias, BIME.IDEnfermedad FROM BI_Mascotas_Enfermedades AS BIME
INNER JOIN DiasTranscurridosEnfermedad AS DTE ON DTE.IDEnfermedad = BIME.IDEnfermedad
INNER JOIN BI_Mascotas AS BIM ON BIME.Mascota = BIM.Codigo
WHERE BIM.FechaFallecimiento > BIME.FechaCura OR BIM.FechaFallecimiento IS NULL 
GROUP BY BIME.IDEnfermedad

--9. Número de veces que ha acudido a consulta cada cliente con alguna de 
--sus mascotas. Incluye nombre y apellidos del cliente.
SELECT COUNT(BIV.IDVisita) AS NumeroVeces, BIC.Nombre FROM BI_Visitas AS BIV
INNER JOIN BI_Mascotas AS BIM ON BIV.Mascota = BIM.Codigo
INNER JOIN BI_Clientes AS BIC ON BIM.CodigoPropietario = BIC.Codigo
GROUP BY BIC.Nombre

--10. Número de visitas a las que ha acudido cada mascota, fecha de su primera y de su última visita
--
GO
CREATE VIEW VisitasFecha AS
SELECT COUNT(*) AS NumeroVisitas, Mascota FROM BI_Visitas
GROUP BY Mascota
GO



SELECT DISTINCT SUM(NumeroVisitas) , VF.Mascota, BIV.Fecha FROM BI_Visitas AS BIV
INNER JOIN VisitasFecha AS VF ON BIV.Mascota = VF.Mascota
GROUP BY VF.Mascota, BIV.Fecha
