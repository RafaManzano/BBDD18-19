USE LeoMetroV2
SELECT * FROM LM_Estaciones
SELECT * FROM LM_Lineas
SELECT * FROM LM_Viajes
--1. Indica el número de estaciones por las que pasa cada línea
SELECT COUNT(DISTINCT LMR.estacion) AS NumeroEstaciones, LML.ID FROM LM_Estaciones AS LME
INNER JOIN LM_Recorridos AS LMR ON LMR.estacion = LME.ID
INNER JOIN LM_Lineas AS LML ON LML.ID = LMR.Linea
GROUP BY LML.ID

--2. Indica el número de trenes diferentes que han circulado en cada línea
SELECT COUNT(DISTINCT LMR.Tren) AS NumeroEstaciones, LML.ID FROM LM_Estaciones AS LME
INNER JOIN LM_Recorridos AS LMR ON LMR.estacion = LME.ID
INNER JOIN LM_Lineas AS LML ON LML.ID = LMR.Linea
GROUP BY LML.ID

--3. Indica el número medio de trenes de cada clase que pasan al día por cada estación. 
--Todos los trenes de cada clase
SELECT COUNT(*) AS NumeroTrenes, Tipo FROM LM_Trenes
GROUP BY Tipo

SELECT AVG(Trenes) AS MediaTrenes, TrenEstacion.estacion, TrenEstacion.Tipo FROM (
			SELECT estacion, COUNT(Tren) AS Trenes, DAY(Momento) AS Dia, T.Tipo FROM LM_Recorridos AS R
			INNER JOIN LM_Trenes AS T ON T.ID = R.Tren
			GROUP BY DAY(Momento), T.Tipo, estacion) AS TrenEstacion
GROUP BY TrenEstacion.estacion, TrenEstacion.Tipo
ORDER BY TrenEstacion.estacion

--4. Calcula el tiempo necesario para recorrer una línea completa, contando con el tiempo estimado de cada 
--itinerario y considerando que cada parada en una estación dura 30 s.
SELECT * FROM LM_Itinerarios

SELECT DATEADD(SECOND,SUM(DATEPART(MINUTE, TiempoEstimado) * 60 + DATEPART(SECOND, TiempoEstimado) + 30), CONVERT(TIME, '0:0')) AS Tiempo, Linea FROM LM_Itinerarios
GROUP BY Linea

--5. Indica el número total de pasajeros que entran (a pie) cada día por cada estación y los que salen del metro en la misma.
SELECT Entrada.Dia, IDEstacionEntrada, Entrada.PasajeroEntrada, Salida.PasajeroSalida FROM 
			(SELECT COUNT(IDTarjeta) AS PasajeroEntrada, DAY(MomentoEntrada) AS Dia, IDEstacionEntrada FROM LM_Viajes
			GROUP BY DAY(MomentoEntrada),IDEstacionEntrada) AS Entrada
			INNER JOIN (
			SELECT COUNT(IDTarjeta) AS PasajeroSalida, DAY(MomentoSalida) AS Dia, IDEstacionSalida FROM LM_Viajes
			GROUP BY DAY(MomentoSalida), IDEstacionSalida) AS Salida 
			ON Entrada.IDEstacionEntrada = Salida.IDEstacionSalida AND Entrada.Dia = Salida.Dia
GROUP BY Entrada.Dia, IDEstacionEntrada,  Entrada.PasajeroEntrada, Salida.PasajeroSalida 


--6. Calcula la media de kilómetros al día que hace cada tren. Considera únicamente los días que ha estado en servicio 
SELECT SUM(LMI.Distancia) AS Km, LMR.Tren FROM LM_Itinerarios AS LMI
INNER JOIN LM_Lineas AS LML ON LMI.Linea = LML.ID
INNER JOIN LM_Recorridos AS LMR ON LML.ID = LMR.Linea
GROUP BY LMR.Tren

--7. Calcula cuál ha sido el intervalo de tiempo en que más personas registradas han estado en el metro 
--al mismo tiempo. Considera intervalos de una hora (de 12:00 a 12:59, de 13:00 a 13:59, etc). 
--Si hay varios momentos con el número máximo de personas, muestra el más reciente.

--8 Calcula el dinero gastado por cada usuario en el mes de febrero de 2017. El precio de un viaje es el de la zona más 
--cara que incluya. Incluye a los que no han viajado.
SELECT * FROM LM_Pasajeros

--Creo que no es corercto, de toda formas preguntar a Leo
--Se suma para saber lo que se gasta cada persona en el mes
SELECT SUM(LMZP.Precio_Zona + LMV.Importe_Viaje) AS GastosMes, LMP.ID FROM LM_Estaciones AS LME
INNER JOIN LM_Zona_Precios AS LMZP ON LMZP.Zona = LME.Zona_Estacion
INNER JOIN LM_Viajes AS LMV ON LME.ID = LMV.IDEstacionEntrada OR LME.ID = LMV.IDEstacionSalida
INNER JOIN LM_Tarjetas AS LMT ON LMV.IDTarjeta = LMT.ID
INNER JOIN LM_Pasajeros AS LMP ON LMP.ID = LMT.IDPasajero
WHERE MONTH(LMV.MomentoEntrada) = 2 AND MONTH(LMV.MomentoSalida) = 2 AND YEAR(LMV.MomentoEntrada) = 2017 AND YEAR(LMV.MomentoSalida) = 2017
GROUP BY LMP.ID

SELECT LMZP.Precio_Zona, LME.ID FROM LM_Estaciones AS LME
INNER JOIN LM_Zona_Precios AS LMZP ON LMZP.Zona = LME.Zona_Estacion
