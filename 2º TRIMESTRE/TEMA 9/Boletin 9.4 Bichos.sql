USE Bichos

--1. Número de mascotas que han sufrido cada enfermedad.
SELECT COUNT(M.Codigo) AS NumeroDeMascotas, E.ID,E.Nombre FROM BI_Mascotas AS M
INNER JOIN BI_Mascotas_Enfermedades AS ME ON ME.Mascota = M.Codigo
INNER JOIN BI_Enfermedades AS E ON ME.IDEnfermedad = E.ID
GROUP BY E.ID,E.Nombre

--2. Número de mascotas que han sufrido cada enfermedad incluyendo las enfermedades que no ha sufrido ninguna mascota.
SELECT COUNT(M.Codigo) AS NumeroDeMascotas, E.ID,E.Nombre FROM BI_Mascotas AS M
INNER JOIN BI_Mascotas_Enfermedades AS ME ON ME.Mascota = M.Codigo
RIGHT JOIN BI_Enfermedades AS E ON ME.IDEnfermedad = E.ID
GROUP BY E.ID,E.Nombre

--3.Número de mascotas de cada cliente. Incluye nombre completo y dirección del cliente.
SELECT COUNT(M.Codigo) AS NumeroDeMascotas, C.Codigo,C.Nombre,C.Direccion  FROM BI_Mascotas AS M
INNER JOIN BI_Clientes AS C ON M.CodigoPropietario = C.Codigo
GROUP BY C.Codigo,C.Nombre,C.Direccion

--4. Número de mascotas de cada especie de cada cliente. Incluye nombre completo y dirección del cliente.
SELECT COUNT(M.Codigo) AS NumeroDeMascotas, M.Codigo, M.Especie, C.Codigo, C.Nombre, C.Direccion FROM BI_Clientes AS C
INNER JOIN BI_Mascotas AS M ON M.CodigoPropietario = C.Codigo
INNER JOIN BI_Mascotas_Enfermedades AS ME ON ME.Mascota = M.Codigo
INNER JOIN BI_Enfermedades AS E ON ME.IDEnfermedad = E.ID
GROUP BY M.Codigo, M.Especie, C.Codigo, C.Nombre, C.Direccion

--5.Número de mascotas de cada especie que han sufrido cada enfermedad.
SELECT COUNT(ME.Mascota) AS NumeroDeMascotas, M.Especie FROM  BI_Mascotas AS M 
INNER JOIN BI_Mascotas_Enfermedades AS ME ON ME.Mascota = M.Codigo
GROUP BY M.Especie

--6. Número de mascotas de cada especie que han sufrido cada enfermedad incluyendo las enfermedades 
--que no ha sufrido ninguna mascota de alguna especie.
SELECT COUNT(ME.Mascota) AS NumeroDeMascotas, M.Especie FROM  BI_Mascotas AS M 
LEFT JOIN BI_Mascotas_Enfermedades AS ME ON ME.Mascota = M.Codigo
GROUP BY M.Especie

--7. Queremos saber cuál es la enfermedad más común en cada especie. Incluye cuantos casos se han producido
SELECT * FROM BI_Mascotas
SELECT * FROM BI_Mascotas_Enfermedades
SELECT * FROM BI_Enfermedades
SELECT COUNT(ME.Mascota) AS NM, M.Especie FROM BI_Enfermedades AS E
INNER JOIN BI_Mascotas_Enfermedades AS ME ON ME.IDEnfermedad = E.ID
FULL JOIN BI_Mascotas AS M ON M.Codigo = ME.Mascota
GROUP BY M.Especie

--8. Duración media, en días, de cada enfermedad, desde que se detecta hasta que se cura. 
--Incluye solo los casos en que el animal se haya curado. Se entiende que una mascota se 
--ha curado si tiene fecha de curación y está viva o su fecha de fallecimiento es posterior a la fecha de curación.
SELECT * FROM BI_Mascotas_Enfermedades

SELECT AVG(DATEDIFF (DAY,ME.FechaInicio,FechaCura)) AS MediaDiasTranscurridos, E.ID, E.Nombre
FROM BI_Enfermedades AS E
INNER JOIN BI_Mascotas_Enfermedades AS ME ON E.ID = ME.IDEnfermedad
INNER JOIN BI_Mascotas AS M ON M.Codigo = ME.Mascota
WHERE ME.FechaCura IS NOT NULL AND M.FechaFallecimiento IS NULL OR ME.FechaCura < M.FechaFallecimiento
GROUP BY E.ID, E.Nombre

--9. Número de veces que ha acudido a consulta cada cliente con alguna de sus mascotas. Incluye nombre y apellidos del cliente.
SELECT COUNT(M.Codigo) AS Mascotas, C.Codigo FROM BI_Mascotas AS M
INNER JOIN BI_Clientes AS C ON C.Codigo = M.CodigoPropietario
GROUP BY C.Codigo

SELECT C.Codigo,COUNT (V.IDVisita) AS Visitas FROM BI_Visitas AS V
INNER JOIN BI_Mascotas AS M ON M.Codigo = V.Mascota
INNER JOIN BI_Clientes AS C ON C.Codigo = M.CodigoPropietario
WHERE EXISTS (SELECT COUNT(M.Codigo) AS Mascotas, C.Codigo FROM BI_Mascotas AS M
				INNER JOIN BI_Clientes AS C ON C.Codigo = M.CodigoPropietario
				GROUP BY C.Codigo)
GROUP BY C.Codigo

--10.Número de visitas a las que ha acudido cada mascota, fecha de su primera y de su última visita
SELECT COUNT(V.IDVisita) AS NumeroDeVisitas, M.Codigo, M.Alias, MIN(V.Fecha) AS PrimeraFecha, MAX(V.Fecha) AS UltimaFecha FROM BI_Mascotas AS M
INNER JOIN BI_Visitas AS V ON V.Mascota = M.Codigo
GROUP BY M.Codigo, M.Alias

--11. Incremento (o disminución) de peso que ha experimentado cada mascota entre cada dos consultas sucesivas. 
--Incluye nombre de la mascota, especie, fecha de las dos consultas sucesivas e incremento o disminución de peso.
SELECT * FROM BI_Visitas
SELECT * FROM BI_Mascotas

--SELECT (SELECT Fecha, Mascota, Peso FROM BI_Visitas) AS Peso FROM BI_Visitas
SELECT Peso FROM BI_Visitas