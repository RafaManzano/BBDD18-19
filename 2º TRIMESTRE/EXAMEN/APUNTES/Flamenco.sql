USE Flamenco
--Ejercicio 1
--N�mero de veces que ha actuado cada cantaor en cada festival de la provincia de C�diz,
--incluyendo a los que no han actuado nunca
GO
ALTER
--CREATE 
VIEW CANTAORES_FESTIVALES AS
SELECT C.Codigo AS CODIGO_CANTAOR, C.Nombre_Artistico, F.Cod AS CODIGO_FEST, F.Denominacion, F.Provincia
FROM F_Cantaores AS C
LEFT JOIN F_Festivales_Cantaores AS FC
ON C.Codigo = FC.Cod_Cantaor
LEFT JOIN F_Festivales AS F
ON FC.Cod_Festival = F.Cod
GO
GO
CREATE VIEW [LOS QUE NUNCA HAN ESTADO EN CADIZ] AS 
SELECT CF.NOMBRE_ARTISTICO, CF.CODIGO_FEST, CF.PROVINCIA,COUNT(CF.CODIGO_CANTAOR) AS CANTIDAD
FROM CANTAORES_FESTIVALES AS CF
--WHERE CF.PROVINCIA = 'CA'
GROUP BY CF.NOMBRE_ARTISTICO, CF.CODIGO_FEST, CF.PROVINCIA
EXCEPT
SELECT CF.NOMBRE_ARTISTICO, CF.CODIGO_FEST, CF.PROVINCIA,COUNT(CF.CODIGO_CANTAOR) AS CANTIDAD
FROM CANTAORES_FESTIVALES AS CF
WHERE CF.PROVINCIA = 'CA'
GROUP BY CF.NOMBRE_ARTISTICO, CF.CODIGO_FEST, CF.PROVINCIA
GO

SELECT * FROM [LOS QUE NUNCA HAN ESTADO EN CADIZ]
SELECT * FROM CANTAORES_FESTIVALES

SELECT  CF.Denominacion, CF.Nombre_Artistico, COUNT(CF.Nombre_Artistico) AS VECES
FROM CANTAORES_FESTIVALES AS CF
WHERE CF.Provincia = 'CA' 
GROUP BY CF.Denominacion, CF.Nombre_Artistico



--Ejercicio 2
--Crea un nuevo palo llamado �Ton�.
--Haz que todos los cantaores que cantaban Bamberas o Peteneras canten Ton�s. No utilices
--los c�digos de los palos, sino sus nombres.
SELECT * FROM F_Palos
INSERT INTO F_Palos VALUES ('TO', 'Ton�');




--Ejercicio 3
--N�mero de cantaores mayores de 30 a�os que han actuado cada a�o en cada pe�a. Se
--contar� la edad que ten�an en el a�o de la actuaci�n.
GO
ALTER
--CREATE 
VIEW DATOS_VISTA AS	/*Muestra el codigo del cantaor, su nombre artistico, su a�o de nacimiento
el a�o de actuacion y el nombre de la pe�a donde actuo. Solo muestra los datos de los que eran mayores a 30 en ese momento*/
SELECT DISTINCT C.Codigo AS CODIGO_CANTAOR, C.Nombre_Artistico AS NOM_ARTISTICO_CANTAOR, C.Anno AS A�O_FECHA_NAC_CANTAOR,YEAR(A.Fecha) AS A�O_ACTUACION, P.Nombre AS NOMBRE_PE�A
FROM F_Cantaores AS C
INNER JOIN F_Actua AS A
ON C.Codigo = A.Cod_Cantaor
INNER JOIN F_Penhas AS P
ON A.Cod_Penha = P.Codigo
WHERE (YEAR(A.Fecha) - C.Anno ) > 30
GO
---------------------------------------------------
SELECT A�O_ACTUACION,COUNT (CODIGO_CANTAOR) AS  CANTIDAD_DE_CANTAORES_CON_MAS_DE_30_A�OS
FROM DATOS_VISTA
GROUP BY A�O_ACTUACION
----------------------------------------------------

SELECT * FROM F_Cantaores
--Ejercicio 4
--Cantaores (nombre, apellidos y nombre art�stico) que hayan actuado m�s de dos veces en
--pe�as de la provincia de Sevilla y canten Fandangos o Buler�as. S�lo se incluyen las
--actuaciones directas en Pe�as, no los festivales.
SELECT DISTINCT C.Nombre, C.Apellidos, C.Nombre_Artistico
FROM F_Cantaores AS C
INNER JOIN F_Palos_Cantaor AS PC
ON C.Codigo = PC.Cod_cantaor
INNER JOIN F_Palos AS P
ON  PC.Cod_Palo = P.Cod_Palo
INNER JOIN F_Actua AS A
ON C.Codigo = A.Cod_Cantaor
INNER JOIN F_Penhas AS PE
ON A.Cod_Penha = PE.Codigo
WHERE PE.Localidad = 'Sevilla' AND P.Palo IN ('Fandangos de Huelva', 'Buler�as')
GROUP BY C.Nombre, C.Apellidos, C.Nombre_Artistico
HAVING COUNT(C.Nombre_Artistico) > 2

--Ejercicio 5
--N�mero de actuaciones que se han celebrado en cada pe�a, incluyendo actuaciones directas
--y en festivales. Incluye el nombre de la pe�a y la localidad.

SELECT PE.Codigo,PE.Nombre AS NOMBRE_PE�A, PE.Localidad, (COUNT (DISTINCT A.Num) + COUNT (DISTINCT F.Cod)) AS CANTIDAD_ACTUACIONES
FROM F_Cantaores AS C
INNER JOIN F_Provincias AS PROV
ON C.Cod_Provincia = PROV.Cod_Provincia
INNER JOIN F_Actua AS A
ON C.Codigo = A.Cod_Cantaor
INNER JOIN F_Penhas AS PE
ON A.Cod_Penha = PE.Codigo AND PE.Cod_provincia = PROV.Cod_Provincia
INNER JOIN F_Festivales_Cantaores AS FC
ON C.Codigo = FC.Cod_Cantaor 
INNER JOIN F_Festivales AS F
ON FC.Cod_Festival = F.Cod
GROUP BY PE.Codigo, PE.Nombre, PE.Localidad




SELECT * FROM F_Actua
SELECT * FROM F_Penhas
