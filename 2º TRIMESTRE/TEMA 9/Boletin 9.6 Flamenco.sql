USE Flamenco
SELECT * FROM F_Festivales_Cantaores
SELECT * FROM F_Festivales
SELECT * FROM F_Palos
--1. N�mero de veces que ha actuado cada cantaor en cada festival de la provincia de C�diz,
--incluyendo a los que no han actuado nunca
SELECT COUNT(FF.Cod) AS NumeroVeces, FC.Codigo, FF.Cod AS FestivalCadiz FROM F_Cantaores AS FC
LEFT JOIN F_Festivales_Cantaores AS FFC ON FFC.Cod_Cantaor = FC.Codigo
LEFT JOIN F_Festivales AS FF ON FF.Cod = FFC.Cod_Festival AND FF.Provincia = 'CA'
GROUP BY FC.Codigo, FF.Cod

--2. Crea un nuevo palo llamado �Ton�.
--Haz que todos los cantaores que cantaban Bamberas o Peteneras canten Ton�s. No utilices
--los c�digos de los palos, sino sus nombres.INSERT INTO F_Palos VALUES ('TO', 'Tonas')BEGIN TRANSACTIONUPDATE F_PalosSET Palo = 'Tonas' FROM F_Cantaores AS FCINNER JOIN F_Palos_Cantaor AS FPC ON FPC.Cod_cantaor = FC.CodigoINNER JOIN F_Palos AS FP ON FP.Cod_Palo = FPC.Cod_PaloWHERE Palo IN('Bamberas', 'Peteneras')--ROLLBACK--COMMIT