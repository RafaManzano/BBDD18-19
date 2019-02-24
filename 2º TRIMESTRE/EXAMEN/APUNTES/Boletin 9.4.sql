--1.Número de mascotas que han sufrido cada enfermedad.
SELECT COUNT(Mascota) AS [Numero de mascotas],IDEnfermedad FROM BI_Mascotas_Enfermedades
	GROUP BY IDEnfermedad

--2.Número de mascotas que han sufrido cada enfermedad incluyendo las enfermedades 
--que no ha sufrido ninguna mascota.
SELECT COUNT(Mascota) AS [Numero de Mascotas],IDEnfermedad
	FROM BI_Mascotas_Enfermedades AS BIME	
		RIGHT JOIN  BI_Enfermedades AS BIE
			ON BIE.ID = BIME.IDEnfermedad
		GROUP BY IDEnfermedad

--3.Número de mascotas de cada cliente. Incluye nombre completo y dirección del cliente.
SELECT COUNT(BI.Codigo) AS [Numero de Mascostas], BIC.Nombre, BIC.Direccion
	FROM BI_Mascotas AS BI
	INNER JOIN BI_Clientes AS BIC
		ON BIC.Codigo = BI.Codigo
	GROUP BY BIC.Nombre, BIC.Direccion

--4.Número de mascotas de cada especie de cada cliente. 
--Incluye nombre completo y dirección del cliente.
SELECT COUNT(M.Codigo) AS [Numero de mascotas],C.Nombre,C.Direccion FROM BI_Mascotas AS M
	INNER JOIN BI_Clientes AS C
		ON C.Codigo = M.CodigoPropietario
	GROUP BY C.Nombre,C.Direccion

--5.Número de mascotas de cada especie que han sufrido cada enfermedad.
SELECT COUNT(M.Codigo) AS [Numero de mascotas],M.Especie,E.IDEnfermedad FROM BI_Mascotas AS M
	INNER JOIN BI_Mascotas_Enfermedades AS E
		ON M.Codigo = E.Mascota
	GROUP BY M.Especie,E.IDEnfermedad

--6.Número de mascotas de cada especie que han sufrido cada enfermedad incluyendo las enfermedades 
--que no ha sufrido ninguna mascota de alguna especie.
SELECT COUNT(M.Codigo) AS [Numero de mascotas],M.Especie,E.Nombre FROM BI_Mascotas AS M
	INNER JOIN BI_Mascotas_Enfermedades AS ME
		ON M.Codigo = ME.Mascota
	RIGHT JOIN BI_Enfermedades AS E
		ON E.ID = ME.IDEnfermedad
	GROUP BY M.Especie,E.Nombre

SELECT * FROM BI_Mascotas

--7.Queremos saber cuál es la enfermedad más común en cada especie. 
--Incluye cuantos casos se han producido
SELECT M.Especie,ME.IDEnfermedad,COUNT(ME.IDEnfermedad) AS [Top enfermedad] 
	FROM BI_Mascotas AS M
	INNER JOIN BI_Mascotas_Enfermedades AS ME 
		ON M.Codigo=ME.Mascota
INNER JOIN
(SELECT MAX(NE.[Cantidad de Enfermedades]) AS [Enfermedad mas comun],NE.Especie FROM
(SELECT M.Especie,ME.IDEnfermedad,COUNT(ME.IDEnfermedad) AS [Cantidad de Enfermedades] 
	FROM BI_Mascotas AS M
	INNER JOIN BI_Mascotas_Enfermedades AS ME 
		ON M.Codigo=ME.Mascota
		GROUP BY M.Especie,ME.IDEnfermedad) AS NE --Numero de enfermedades de cada especie
			GROUP BY NE.Especie) AS EMC ON EMC.Especie = M.Especie --Enfermedad mas comun de cada especie
				GROUP BY M.Especie,ME.IDEnfermedad, EMC.[Enfermedad mas comun]
				HAVING EMC.[Enfermedad mas comun] = COUNT(ME.IDEnfermedad)


--8.Duración media, en días, de cada enfermedad, desde que se detecta hasta que se cura. 
--Incluye solo los casos en que el animal se haya curado. Se entiende que una mascota se ha curado 
--si tiene fecha de curación y está viva o su fecha de fallecimiento es posterior a la fecha de curación.
SELECT M.Codigo,M.Alias,DATEDIFF(DAY,ME.FechaInicio,ME.FechaCura) AS [Duracion en dias] 
	FROM BI_Mascotas_Enfermedades as ME
	INNER JOIN BI_Mascotas AS M 
		ON ME.Mascota = M.Codigo
		WHERE ME.FechaCura IS NOT NULL OR M.FechaFallecimiento = NULL OR M.FechaFallecimiento > ME.FechaCura
	
--9.Número de veces que ha acudido a consulta cada cliente con alguna de sus mascotas. 
--Incluye nombre y apellidos del cliente.
SELECT C.Nombre,M.Codigo,COUNT(*) AS [Numero de acudidos] FROM BI_Clientes AS C 
	INNER JOIN  BI_Mascotas AS M ON C.Codigo=M.CodigoPropietario
	INNER JOIN BI_Visitas AS V ON M.Codigo = V.Mascota 
		GROUP BY C.Nombre,M.Codigo


--10.Número de visitas a las que ha acudido cada mascota, fecha de su primera y de su última visita
GO
Create view [Primera Visita] AS
Select Count(IDVisita) AS [Numero de visitas],MIN(V.fecha) AS [Primera visita],M.Alias from BI_Visitas AS V
	INNER JOIN BI_Mascotas AS M
		ON M.Codigo = V.Mascota
	GROUP BY M.Alias
GO

Create view [Ultima visita] AS
Select Count(IDVisita) AS [Numero de visitas],MAX(fecha) AS [Ultima visita],M.Alias from BI_Visitas AS V
	INNER JOIN BI_Mascotas AS M
		ON M.Codigo = V.Mascota
	GROUP BY M.Alias
GO

Select PV.Alias,PV.[Primera visita],UV.[Ultima visita] from [Primera Visita] AS PV
	INNER JOIN [Ultima visita] AS UV
		ON UV.Alias = PV.Alias

select* from BI_Visitas AS V
	INNER JOIN BI_Mascotas AS M
		ON M.Codigo = V.Mascota
--11.Incremento (o disminución) de peso que ha experimentado cada mascota entre cada dos consultas sucesivas. 
--Incluye nombre de la mascota, especie, fecha de las dos consultas sucesivas e 
--incremento o disminución de peso.

--SELECT FA.IDVisita,(FA.Peso - FD.Peso) AS [Aumento Disminucion],FD.[Fecha maxima] AS [Fecha despues],FA.Fecha AS [Fecha anterior] FROM
--(SELECT DISTINCT V.IDVisita,V.Mascota,V.Peso,V.Fecha FROM BI_Visitas AS V
--		INNER JOIN BI_Visitas AS V2 
--			ON V.Mascota = V2.Mascota
--			WHERE V.Fecha > V2.Fecha) AS FA --Fecha primera
--INNER JOIN 		
--(SELECT DISTINCT V.IDVisita,v.Fecha AS [Fecha de la ultima visita],V.Mascota,V.Peso,MAX(V2.Fecha) AS [Fecha maxima] FROM BI_Visitas AS V
--	INNER JOIN BI_Visitas as V2
--		ON V.Mascota=V2.Mascota
--			WHERE V.Fecha > V2.Fecha
--			GROUP BY V.IDVisita,V.Mascota,V.Peso,V.Fecha
--		) AS FD --Fecha segunda
--			ON FA.Mascota = FD.Mascota 
--				WHERE FD.Fecha > FA.Fecha


SELECT DISTINCT FD.IDVisita,M.Alias,(V.Peso - FD.Peso) AS [Aumento Disminucion],V.Fecha,FD.[Fecha maxima]
FROM BI_visitas AS V
INNER JOIN BI_Mascotas AS M
	ON M.Codigo = V.Mascota
INNER JOIN
(
SELECT V.IDVisita,V.Mascota,V.Peso,MAX(V2.Fecha) AS [Fecha maxima] 
	FROM BI_Visitas AS V
	INNER JOIN BI_Visitas as V2
		ON V.Mascota=V2.Mascota
			WHERE V.Fecha > V2.Fecha
			GROUP BY V.IDVisita,V.Mascota,V.Peso
		) AS FD
ON M.Codigo = FD.Mascota AND V.Fecha = FD.[Fecha maxima]


SELECT * FROM BI_Visitas
