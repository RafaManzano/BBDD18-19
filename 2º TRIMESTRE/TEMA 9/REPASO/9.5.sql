USE LeoMetro
SELECT * FROM LM_Lineas
SELECT * FROM LM_Recorridos
SELECT * FROM LM_Trenes
--1. Indica el número de estaciones por las que pasa cada línea
SELECT COUNT(LMR.estacion) AS NumeroEstaciones, LML.ID FROM LM_Lineas AS LML
INNER JOIN LM_Recorridos AS LMR ON LML.ID = LMR.Linea
GROUP BY LML.ID

--2. Indica el número de trenes diferentes que han circulado en cada línea
SELECT COUNT(DISTINCT LMT.ID) AS TrenesDiferentes, LMR.Linea FROM LM_Trenes AS LMT
INNER JOIN LM_Recorridos AS LMR ON LMT.ID = LMR.Tren
GROUP BY LMR.Linea

--3. Indica el número medio de trenes de cada clase que pasan al día por cada estación. 
GO
ALTER VIEW TiposTrenes AS 
SELECT COUNT(LMR.Tren) AS Trenes, Tipo FROM LM_Trenes AS LMT
INNER JOIN LM_Recorridos AS LMR ON LMT.ID = LMR.Tren
GROUP BY Tipo
GO

SELECT AVG(TT.Trenes) AS MediaTrenes, DAY(Momento) AS Dia, LMR.estacion FROM LM_Trenes AS LMT
INNER JOIN TiposTrenes AS TT ON LMT.Tipo = TT.Tipo
INNER JOIN LM_Recorridos AS LMR ON LMT.ID = LMR.Tren
GROUP BY DAY(Momento), LMR.estacion 
ORDER BY Dia, LMR.estacion asc

--4. Calcula el tiempo necesario para recorrer una línea completa, contando con el tiempo estimado de cada 
--itinerario y considerando que cada parada en una estación dura 30 s.
SELECT * FROM LM_Itinerarios

SELECT DATEADD(SECOND,SUM(DATEPART(MINUTE, TiempoEstimado) * 60 + DATEPART(SECOND, TiempoEstimado) + 30), CONVERT(TIME, '0:0')) AS Tiempo, Linea FROM LM_Itinerarios
GROUP BY Linea

--5. Indica el número total de pasajeros que entran (a pie) cada día por cada estación y los que salen del metro en la misma.

GO
CREATE VIEW PasajerosEntrada AS
SELECT COUNT(LMV.IDTarjeta) AS Pasajeros, DAY(MomentoEntrada) AS Day, LMV.IDEstacionEntrada FROM LM_Estaciones AS LME
INNER JOIN LM_Viajes AS LMV ON LME.ID = LMV.IDEstacionEntrada 
GROUP BY DAY(MomentoEntrada), LMV.IDEstacionEntrada
GO

GO
CREATE VIEW PasajerosSalida AS
SELECT COUNT(LMV.IDTarjeta) AS Pasajeros, DAY(MomentoEntrada) AS Day, LMV.IDEstacionSalida FROM LM_Estaciones AS LME
INNER JOIN LM_Viajes AS LMV ON LME.ID = LMV.IDEstacionSalida
GROUP BY DAY(MomentoEntrada), LMV.IDEstacionSalida
GO
--Esta eliminada la consulta pero salia siempre 4 pasajeros

--6 Calcula la media de kilómetros al día que hace cada tren. Considera únicamente los días que ha estado en servicio
GO
CREATE VIEW SumaTotalPorTren AS
SELECT SUM(Distancia) AS DistanciaTotal, LMR.Tren FROM LM_Itinerarios AS LMI
INNER JOIN LM_Estaciones AS LME ON LMI.estacionIni = LME.ID
INNER JOIN LM_Recorridos AS LMR ON LME.ID = LMR.estacion
INNER JOIN LM_Trenes AS LMT ON LMR.Tren = LMT.ID
WHERE LMT.FechaEntraServicio < LMR.Momento
GROUP BY LMR.Tren
GO

--Preguntar a Leo si esto esta correcto
SELECT AVG(STPT.DistanciaTotal) AS MediaDistancia, DAY(LMR.Momento) AS Dias, STPT.Tren FROM LM_Recorridos AS LMR
INNER JOIN SumaTotalPorTren AS STPT ON LMR.Tren = STPT.Tren
GROUP BY DAY(LMR.Momento), STPT.Tren
ORDER BY Dias ASC

--7. Calcula cuál ha sido el intervalo de tiempo en que más personas registradas han estado en el metro al mismo tiempo. 
--Considera intervalos de una hora (de 12:00 a 12:59, de 13:00 a 13:59, etc). 
--Si hay varios momentos con el número máximo de personas, muestra el más reciente.
GO
CREATE VIEW PersonasRegistradasPorHoras AS
SELECT SUM(IDTarjeta) AS PersonasRegistradas, DATEPART(HH, MomentoEntrada) AS Horas FROM LM_Viajes
WHERE DATEPART(HH, MomentoEntrada) = DATEPART(HH, MomentoSalida)
GROUP BY DATEPART(HH, MomentoEntrada)
GO

--8. Calcula el dinero gastado por cada usuario en el mes de febrero de 2017. 
--El precio de un viaje es el de la zona más cara que incluya. Incluye a los que no han viajado.
--El planteamiento esta correcto pero quizas el resultado sea erroneo
GO
ALTER VIEW DineroTotalTarjetas AS 
SELECT SUM(Importe_Viaje) AS Dinero, IDTarjeta FROM LM_Viajes
WHERE MONTH(MomentoEntrada) = 2 AND YEAR(MomentoEntrada) = 2017
GROUP BY IDTarjeta
GO

SELECT Dinero, LMT.IDPasajero FROM LM_Tarjetas AS LMT
LEFT JOIN DineroTotalTarjetas AS DTT ON LMT.ID = DTT.IDTarjeta
GROUP BY LMT.IDPasajero, Dinero 

--9. Calcula el tiempo medio diario que cada pasajero pasa en el sistema de metro y el número de veces que accede al mismo.
GO
CREATE VIEW NumeroVecesPasajeros AS 
SELECT COUNT(LMV.ID) AS NumeroVeces, LMT.IDPasajero FROM LM_Viajes AS LMV
INNER JOIN LM_Tarjetas AS LMT ON LMV.IDTarjeta = LMT.ID
GROUP BY LMT.IDPasajero
GO

GO
CREATE VIEW DiferenciasHoeasPasajeros AS
SELECT SUM(DATEDIFF(HH, MomentoEntrada, MomentoSalida))AS DiferenciaMinutos, LMT.IDPasajero FROM LM_Viajes AS LMV
INNER JOIN LM_Tarjetas AS LMT ON LMV.IDTarjeta = LMT.ID
GROUP BY LMT.IDPasajero
GO

SELECT NVP.IDPasajero, NVP.NumeroVeces, AVG(DHP.DiferenciaMinutos) AS MediaMinutos FROM NumeroVecesPasajeros AS NVP
INNER JOIN DiferenciasHoeasPasajeros AS DHP ON NVP.IDPasajero = DHP.IDPasajero
GROUP BY NVP.IDPasajero, NVP.NumeroVeces
