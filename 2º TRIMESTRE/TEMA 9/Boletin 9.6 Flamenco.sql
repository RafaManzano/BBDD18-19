USE Flamenco

SELECT * FROM F_Festivales_Cantaores
SELECT * FROM F_Festivales
SELECT * FROM F_Palos
--1. Número de veces que ha actuado cada cantaor en cada festival de la provincia de Cádiz,
--incluyendo a los que no han actuado nunca
SELECT COUNT(FF.Cod) AS NumeroVeces, FC.Codigo, FF.Cod AS FestivalCadiz FROM F_Cantaores AS FC
LEFT JOIN F_Festivales_Cantaores AS FFC ON FFC.Cod_Cantaor = FC.Codigo
LEFT JOIN F_Festivales AS FF ON FF.Cod = FFC.Cod_Festival AND FF.Provincia = 'CA'
GROUP BY FC.Codigo, FF.Cod

--2. Crea un nuevo palo llamado “Toná”.
--Haz que todos los cantaores que cantaban Bamberas o Peteneras canten Tonás. No utilices
--los códigos de los palos, sino sus nombres.
INSERT INTO F_Palos 
VALUES ('TO', 'Tonas')

BEGIN TRANSACTION
INSERT F_Palos_Cantaor
SELECT DISTINCT FPC.Cod_cantaor, 'TO' FROM F_Palos_Cantaor AS FPC
INNER JOIN F_Palos AS FP ON FPC.Cod_Palo = FP.Cod_Palo
WHERE FP.Palo IN('Bamberas', 'Peteneras')
--ROLLBACK
--COMMIT

SELECT * FROM F_Palos_Cantaor
WHERE Cod_Palo = 'TO'
/*
No es lo que se pedia
BEGIN TRANSACTION
UPDATE F_Palos
SET Palo = 'Tonas' 
FROM F_Cantaores AS FC
INNER JOIN F_Palos_Cantaor AS FPC ON FPC.Cod_cantaor = FC.Codigo
INNER JOIN F_Palos AS FP ON FP.Cod_Palo = FPC.Cod_Palo
WHERE Palo IN('Bamberas', 'Peteneras')
--ROLLBACK
--COMMIT
*/
--3. Número de cantaores mayores de 30 años que han actuado cada año en cada peña. Se
--contará la edad que tenían en el año de la actuación.
--Creo que no es correcto, porque he agrupado por demasiadas cosas
SELECT CantaoresPenha.NumeroCantaores, CantaoresPenha.Cod_Penha, CantaoresPenha.Cod_Cantaor FROM F_Cantaores AS FC
INNER JOIN (
			SELECT COUNT(Cod_Cantaor) AS NumeroCantaores, Cod_Penha, YEAR(Fecha) AS Anho, Cod_Cantaor FROM F_Actua
			GROUP BY Cod_Penha, YEAR(Fecha), Cod_Cantaor) AS CantaoresPenha ON CantaoresPenha.Cod_Cantaor = FC.Codigo
WHERE (CantaoresPenha.Anho - FC.Anno) > 30
GROUP BY CantaoresPenha.NumeroCantaores, CantaoresPenha.Cod_Penha, CantaoresPenha.Cod_Cantaor

--Segundo intento. Creo que esto seria lo correcto. Por lo menos se ve mas bonito. Leo aprueba esto
SELECT COUNT(FA.Cod_Cantaor) AS NumeroCantaores, FA.Cod_Penha, YEAR(FA.Fecha) AS Anho FROM F_Cantaores AS FC
INNER JOIN F_Actua AS FA ON FA.Cod_Cantaor = FC.Codigo
WHERE (YEAR(Fa.Fecha) - FC.Anno) > 30
GROUP BY FA.Cod_Penha, YEAR(FA.Fecha) 

--4. Cantaores (nombre, apellidos y nombre artístico) que hayan actuado más de dos veces en
--peñas de la provincia de Sevilla y canten Fandangos o Bulerías. Sólo se incluyen las
--actuaciones directas en Peñas, no los festivales.
 
 --Cantaores que canten fandangos o bulerias de la provincia de sevilla
 GO
 CREATE VIEW CantaoresFBSevilla AS
 SELECT DISTINCT FC.Codigo, FC.Nombre, FC.Apellidos, FC.Nombre_Artistico FROM F_Cantaores AS FC
 INNER JOIN F_Palos_Cantaor AS FPC ON FPC.Cod_cantaor = FC.Codigo
 INNER JOIN F_Palos AS FP ON FP.Cod_Palo = FPC.Cod_Palo
 WHERE (FP.Palo LIKE('%Fandangos%') OR FP.Palo LIKE('%Bulerías%'))
 GO

 --Creo que es correcto pero no estoy del todo seguro
 SELECT COUNT(FA.Cod_Penha) AS NumeroPenhas, CFBS.Nombre, CFBS.Apellidos, CFBS.Nombre_Artistico FROM F_Actua AS FA
 INNER JOIN CantaoresFBSevilla AS CFBS ON CFBS.Codigo = FA.Cod_Cantaor
 INNER JOIN F_Penhas AS FP ON FP.Codigo = FA.Cod_Penha
 WHERE FP.Localidad = 'Sevilla'
 GROUP BY CFBS.Nombre, CFBS.Apellidos, CFBS.Nombre_Artistico
 HAVING COUNT(FA.Cod_Penha) > 1

 --5. Número de actuaciones que se han celebrado en cada peña, incluyendo actuaciones directas
--y en festivales. Incluye el nombre de la peña y la localidad.
GO
CREATE VIEW ActosDirectos AS
SELECT COUNT(FA.Num) AS NumeroActuacion, FA.Cod_Penha FROM F_Cantaores AS FC
INNER JOIN F_Actua AS FA ON FA.Cod_Cantaor = FC.Codigo
GROUP BY FA.Cod_Penha

GO
CREATE VIEW ActosFestivales AS
SELECT COUNT(FFC.Cod_Cantaor) AS NumeroActuacion, FA.Cod_Penha FROM F_Festivales_Cantaores AS FFC
INNER JOIN F_Cantaores AS FC ON FC.Codigo = FFC.Cod_Cantaor
INNER JOIN F_Actua AS FA ON FA.Cod_Cantaor = FC.Codigo
GROUP BY FA.Cod_Penha

--Creo que esta mal, revisar
SELECT SUM(AD.NumeroActuacion + AF.NumeroActuacion) AS Actuaciones, FP.Nombre, FP.Localidad FROM F_Penhas AS FP
INNER JOIN ActosDirectos AS AD ON AD.Cod_Penha = FP.Codigo
INNER JOIN ActosFestivales AS AF ON AF.Cod_Penha = AD.Cod_Penha
GROUP BY FP.Nombre, FP.Localidad